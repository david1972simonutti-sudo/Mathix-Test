import { useEffect, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import Header from "@/components/Header";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";

import { Send, Loader2, ImagePlus, X, ArrowLeft, MessageSquarePlus, BookOpen, Calculator } from "lucide-react";
import { EmptyStateChat } from "@/components/chat/EmptyStateChat";
import { useToast } from "@/hooks/use-toast";

import { MarkdownMessage } from "@/components/chat/MarkdownMessage";
import { ExerciseDisplay } from "@/components/ExerciseDisplay";
import { MessageFeedback } from "@/components/chat/MessageFeedback";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { detectWelcomeContext, generateWelcomeMessage, loadLastChatOfType } from "@/hooks/useWelcomeAndChatLoading";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";
import { DebugConsole, DebugEntry } from "@/components/DebugConsole";

import "katex/dist/katex.min.css";

interface Message {
  id?: string;
  role: "user" | "assistant";
  content: string;
  timestamp: Date;
  imageUrl?: string;
}

const Cours = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const [searchParams] = useSearchParams();
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [userId, setUserId] = useState<string | null>(null);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [messages, setMessages] = useState<Message[]>([]);
  const [inputMessage, setInputMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [userProfile, setUserProfile] = useState<any>(null);
  const [selectedImages, setSelectedImages] = useState<File[]>([]);
  const [imagePreviews, setImagePreviews] = useState<string[]>([]);
  const [currentChatId, setCurrentChatId] = useState<string | null>(null);
  const [debugEntries, setDebugEntries] = useState<DebugEntry[]>([]);

  const {
    isCSATOpen,
    userProfile: csatUserProfile,
    userId: csatUserId,
    triggerLogoutWithCSAT,
    handleCSATComplete,
    handleCSATSkip,
  } = useAdvancedCSAT();

  // URL parameters for prerequisite revision
  const chapitre = searchParams.get("chapitre");
  const mode = searchParams.get("mode");
  const niveauPrerequisParam = searchParams.get("niveau_prerequis");

  useEffect(() => {
    checkAuth();

    // Listen for auth state changes
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(async (event, session) => {
      if (event === "SIGNED_OUT") {
        navigate("/login");
      } else if (event === "TOKEN_REFRESHED") {
        console.log("🔄 Token refreshed successfully");
      } else if (session) {
        setIsLoggedIn(true);
        setUserId(session.user.id);
      }
    });

    return () => subscription.unsubscribe();
  }, []);

  // Pre-fill prompt if coming from prerequisite revision
  useEffect(() => {
    if (chapitre && mode === "revision") {
      const niveauText = niveauPrerequisParam ? ` (niveau ${niveauPrerequisParam})` : "";
      setInputMessage(
        `Peux-tu m'expliquer le cours sur ${chapitre}${niveauText} ? J'ai besoin de revoir cette notion pour consolider mes bases.`,
      );
    }
  }, [chapitre, mode, niveauPrerequisParam]);

  const checkAuth = async () => {
    const {
      data: { session },
      error,
    } = await supabase.auth.getSession();

    if (error || !session) {
      console.error("Not authenticated:", error);
      navigate("/login");
      return;
    }

    setIsLoggedIn(true);
    setUserId(session.user.id);

    const profile = await fetchUserProfile(session.user.id);
    await ensureSessionExists(session.user.id);

    // Restaurer depuis localStorage si disponible
    const savedChatId = localStorage.getItem("currentChatId_cours");
    if (savedChatId) {
      const { data: existingChat } = await supabase
        .from("chats")
        .select("id, chat_type")
        .eq("id", savedChatId)
        .eq("user_id", session.user.id)
        .eq("chat_type", "cours")
        .maybeSingle();

      if (existingChat) {
        setCurrentChatId(savedChatId);
        // Charger l'historique du chat
        const lastChat = await loadLastChatOfType(session.user.id, "cours");
        if (lastChat && lastChat.chatId === savedChatId) {
          setMessages(lastChat.messages);
          return;
        }
      } else {
        localStorage.removeItem("currentChatId_cours");
      }
    }

    // Détecter le contexte de bienvenue pour les cours
    const welcomeContext = await detectWelcomeContext(session.user.id, "cours");
    const welcomeMessage = generateWelcomeMessage(welcomeContext, profile?.prenom || "", "cours");

    // Si premier chat du jour ou première interaction → nouveau chat, pas d'historique
    if (welcomeMessage) {
      setCurrentChatId(null);
      localStorage.removeItem("currentChatId_cours");
      setMessages([welcomeMessage]);
      return;
    }

    // Si 'ongoing' → charger le dernier chat cours existant sans welcome message
    const lastChat = await loadLastChatOfType(session.user.id, "cours");

    if (lastChat) {
      setCurrentChatId(lastChat.chatId);
      localStorage.setItem("currentChatId_cours", lastChat.chatId);
      setMessages(lastChat.messages);
    } else {
      // Pas de chat existant du tout
      setMessages([]);
    }
  };

  const fetchUserProfile = async (uid: string) => {
    try {
      const { data, error } = await supabase.from("profiles").select("*").eq("user_id", uid).single();

      if (error) throw error;
      setUserProfile(data);
      return data;
    } catch (error) {
      console.error("Error fetching user profile:", error);
      return null;
    }
  };

  const ensureSessionExists = async (uid: string) => {
    try {
      const { data: existingSessions, error: fetchError } = await supabase
        .from("sessions")
        .select("*")
        .eq("user_id", uid)
        .order("date_debut", { ascending: false })
        .limit(1);

      if (fetchError) throw fetchError;

      if (existingSessions && existingSessions.length > 0) {
        setSessionId(existingSessions[0].id);
      } else {
        const { data: newSession, error: insertError } = await supabase
          .from("sessions")
          .insert({
            user_id: uid,
            date_debut: new Date().toISOString(),
          })
          .select()
          .single();

        if (insertError) throw insertError;
        setSessionId(newSession.id);
      }
    } catch (error) {
      console.error("Error managing session:", error);
    }
  };

  const handleLogout = () => {
    triggerLogoutWithCSAT();
  };

  const handleImageSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      // Vérifier le nombre maximum d'images (3)
      if (selectedImages.length >= 3) {
        toast({
          title: "Maximum atteint",
          description: "Tu peux envoyer jusqu'à 3 images maximum",
          variant: "destructive",
        });
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        toast({
          title: "Erreur",
          description: "L'image est trop volumineuse (max 5MB)",
          variant: "destructive",
        });
        return;
      }

      setSelectedImages((prev) => [...prev, file]);
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreviews((prev) => [...prev, reader.result as string]);
      };
      reader.readAsDataURL(file);
    }
    // Reset input pour permettre de sélectionner le même fichier
    e.target.value = "";
  };

  const handleRemoveImage = (index: number) => {
    setSelectedImages((prev) => prev.filter((_, i) => i !== index));
    setImagePreviews((prev) => prev.filter((_, i) => i !== index));
  };

  const clearAllImages = () => {
    setSelectedImages([]);
    setImagePreviews([]);
  };

  const uploadImages = async (files: File[]): Promise<string[]> => {
    const urls: string[] = [];
    for (const file of files) {
      const url = await uploadImage(file);
      if (url) {
        urls.push(url);
      }
    }
    return urls;
  };

  const uploadImage = async (file: File): Promise<string | null> => {
    try {
      // ✅ Récupérer l'userId directement depuis la session active pour éviter désync RLS
      const {
        data: { session },
      } = await supabase.auth.getSession();
      const currentUserId = session?.user?.id;

      if (!currentUserId) {
        console.error("No authenticated user for upload");
        toast({
          title: "Erreur d'authentification",
          description: "Reconnecte-toi et réessaie",
          variant: "destructive",
        });
        return null;
      }

      const fileExt = file.name.split(".").pop();
      const fileName = `${currentUserId}/${Date.now()}.${fileExt}`;

      const { data: uploadData, error: uploadError } = await supabase.storage
        .from("student-responses")
        .upload(fileName, file, {
          cacheControl: "3600",
          upsert: false,
        });

      if (uploadError) throw uploadError;

      // Générer une URL signée (bucket privé) pour sécuriser les photos élèves
      const { data: signedUrlData, error: signedUrlError } = await supabase.storage
        .from("student-responses")
        .createSignedUrl(uploadData.path, 3600); // Expire dans 1 heure

      if (signedUrlError || !signedUrlData?.signedUrl) {
        console.error("Erreur création URL signée:", signedUrlError);
        throw new Error("Impossible de générer l'URL de l'image");
      }

      return signedUrlData.signedUrl;
    } catch (error) {
      console.error("Error uploading image:", error);
      toast({
        title: "Erreur",
        description: "Échec du téléchargement de l'image",
        variant: "destructive",
      });
      return null;
    }
  };

  const handleSendMessage = async () => {
    if (!inputMessage.trim() && selectedImages.length === 0) return;
    if (!userId || !sessionId) return;

    const newMessage: Message = {
      role: "user",
      content: inputMessage,
      timestamp: new Date(),
      imageUrl: imagePreviews.length > 0 ? imagePreviews[0] : undefined,
    };

    setMessages((prev) => [...prev, newMessage]);
    setInputMessage("");
    setIsLoading(true);

    // Upload toutes les images
    let uploadedImageUrls: string[] = [];
    if (selectedImages.length > 0) {
      uploadedImageUrls = await uploadImages(selectedImages);
      clearAllImages();
    }

    try {
      let chatId = currentChatId;

      // Create a new chat if it doesn't exist
      if (!chatId) {
        const { data: chatData, error: chatError } = await supabase
          .from("chats")
          .insert({
            user_id: userId,
            session_id: sessionId,
            chat_type: "cours", // Mark as "cours" type
          })
          .select()
          .single();

        if (chatError) throw chatError;
        chatId = chatData.id;
        setCurrentChatId(chatId);
        localStorage.setItem("currentChatId_cours", chatId);
      }

      // Save user message (avec la première image URL pour compatibilité)
      await supabase.from("chat_history").insert({
        user_id: userId,
        chat_id: chatId,
        role: "user",
        content: inputMessage,
        image_url: uploadedImageUrls[0] || null,
      });

      // ✅ Construire l'historique complet incluant le message actuel
      const historyToSend = [...messages, newMessage];

      // Call AI with chatType parameter + conversationHistory + multi-images
      const requestPayload = {
        userId: userId,
        reponseEleve: inputMessage,
        imageUrl: uploadedImageUrls[0] || null, // Compatibilité ancien format
        imageUrls: uploadedImageUrls, // Nouveau format multi-images
        userProfile,
        sessionId,
        chatId,
        chatType: "cours",
        conversationHistory: historyToSend.map((m) => ({
          role: m.role,
          content: m.content,
        })),
      };

      // 🐛 DEBUG: Log request
      setDebugEntries((prev) => [
        ...prev,
        {
          timestamp: new Date(),
          type: "request",
          data: requestPayload,
        },
      ]);

      const { data: functionData, error: functionError } = await supabase.functions.invoke("analyze-response", {
        body: requestPayload,
      });

      // 🐛 DEBUG: Log response
      setDebugEntries((prev) => [
        ...prev,
        {
          timestamp: new Date(),
          type: "response",
          data: { rawData: functionData, response: functionData?.data },
        },
      ]);
      console.log("🔍 DEBUG COURS - Réponse brute:", functionData);

      if (functionError) throw functionError;

      // Fonction pour nettoyer la réponse Gemini (retire ** et normalise LaTeX)
      const cleanGeminiResponse = (text: string): string => {
        if (typeof text !== "string") return text;

        let cleaned = text;

        // 🔧 FIX: Convertir les \\n en vrais retours à la ligne
        cleaned = cleaned.replace(/\\n/g, "\n");

        // Retirer uniquement les ** (markdown gras)
        cleaned = cleaned.replace(/\*\*([^*]+)\*\*/g, "$1");

        // ✅ FIX: Déséchapper les backslashes LaTeX (\\frac → \frac)
        cleaned = cleaned.replace(
          /\\\\(frac|sqrt|lim|sum|int|prod|infty|to|mathbb|mathcal|mathscr|mathfrak|mathbf|mathrm|mathit|text|displaystyle|tfrac|dfrac|binom|choose|left|right|begin|end|times|cdot|pm|leq|geq|ne|approx|equiv|subset|subseteq|in|notin|cup|cap|emptyset|forall|exists|nabla|partial|sin|cos|tan|log|ln|exp|alpha|beta|gamma|delta|epsilon|theta|lambda|mu|pi|sigma|omega|Omega|Delta|Gamma|Lambda|Pi|Sigma|ldots|implies|Rightarrow|Leftarrow|Leftrightarrow|iff|rightarrow|leftarrow|leftrightarrow|mapsto|longmapsto|hookrightarrow|hookleftarrow|xrightarrow|xleftarrow|parallel|perp|angle|triangle|circ|quad|qquad|overline|underline|hat|tilde|vec|dot|ddot|cosh|sinh|tanh|arcsin|arccos|arctan|cdots|vdots|ddots)/g,
          "\\$1",
        );

        return cleaned;
      };

      // Extract response from the correct structure
      let aiResponse = "Désolé, je n'ai pas pu générer de réponse.";

      if (typeof functionData === "string") {
        aiResponse = cleanGeminiResponse(functionData);
      } else if (functionData?.data) {
        const assistantResponse = functionData.data;

        // Handle exercice_genere objects
        if (
          typeof assistantResponse === "object" &&
          assistantResponse !== null &&
          assistantResponse.type === "exercice_genere"
        ) {
          aiResponse = JSON.stringify(assistantResponse);
        }
        // If data is an object with reponse_naturelle, extract it
        else if (typeof assistantResponse === "object" && assistantResponse.reponse_naturelle) {
          aiResponse = cleanGeminiResponse(assistantResponse.reponse_naturelle);
        }
        // If data is a string, use it directly
        else if (typeof assistantResponse === "string") {
          aiResponse = cleanGeminiResponse(assistantResponse);
        }
      }

      const assistantMessage: Message = {
        role: "assistant",
        content: aiResponse,
        timestamp: new Date(),
      };

      setMessages((prev) => [...prev, assistantMessage]);

      // Save assistant message
      await supabase.from("chat_history").insert({
        user_id: userId,
        chat_id: chatId,
        role: "assistant",
        content: aiResponse,
      });
    } catch (error) {
      console.error("Error sending message:", error);
      toast({
        title: "Erreur",
        description: "Une erreur s'est produite lors de l'envoi du message",
        variant: "destructive",
      });
    } finally {
      setIsLoading(false);
    }
  };

  const handleNewChat = async () => {
    setCurrentChatId(null);
    localStorage.removeItem("currentChatId_cours");

    // Détecter le contexte et afficher le welcome message
    if (!userId) {
      setMessages([]);
      return;
    }

    const welcomeContext = await detectWelcomeContext(userId, "cours");
    const welcomeMessage = generateWelcomeMessage(welcomeContext, userProfile?.prenom || "", "cours");

    setMessages(welcomeMessage ? [welcomeMessage] : []);

    toast({
      title: "Nouvelle conversation",
      description: "Prêt pour une nouvelle explication de cours",
    });
  };

  const handleGoBack = () => {
    navigate("/");
  };

  const handleSwitchToExercises = () => {
    if (chapitre && niveauPrerequisParam) {
      navigate(
        `/?chapitre=${encodeURIComponent(chapitre)}&niveau_prerequis=${encodeURIComponent(niveauPrerequisParam)}`,
      );
    } else if (chapitre) {
      navigate(`/?chapitre=${encodeURIComponent(chapitre)}`);
    } else {
      navigate("/");
    }
  };

  return (
    <div className="min-h-screen flex flex-col bg-gradient-to-br from-sky-50 via-white to-blue-50 dark:from-gray-900 dark:via-gray-900 dark:to-blue-950/30">
      <Header
        isLoggedIn={isLoggedIn}
        onLogout={handleLogout}
        pageTitle="Explications de cours"
        onBack={handleGoBack}
        onNewChat={handleNewChat}
      />

      <div className="flex-1 flex flex-col">
        <div className="flex-1 flex flex-col max-w-5xl mx-auto w-full p-4 sm:p-6 lg:p-8">
          {/* Prerequisite revision banner */}
          {chapitre && mode === "revision" && (
            <Alert className="mb-6 border-l-4 border-cyan-500 bg-cyan-50 dark:bg-cyan-950/20">
              <BookOpen className="h-5 w-5 text-cyan-600" />
              <AlertTitle className="text-cyan-800 dark:text-cyan-300 font-bold">
                📚 Révision de prérequis {niveauPrerequisParam && `(niveau ${niveauPrerequisParam})`}
              </AlertTitle>
              <AlertDescription className="text-cyan-700 dark:text-cyan-400">
                Tu es en train de réviser <strong>{chapitre}</strong> pour consolider tes bases.
                <div className="mt-3 flex gap-2">
                  <Button
                    onClick={handleSwitchToExercises}
                    variant="default"
                    size="sm"
                    className="bg-cyan-600 hover:bg-cyan-700"
                  >
                    <Calculator className="w-4 h-4 mr-2" />
                    Passer aux exercices
                  </Button>
                </div>
              </AlertDescription>
            </Alert>
          )}

          {/* Chat Messages */}
          {/* Chat Messages - FIX: Added overflow-hidden and max-w-full */}
          <div className="flex-1 flex flex-col bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm rounded-2xl border-2 border-[hsl(210,100%,85%)] dark:border-[hsl(210,100%,35%)] shadow-[0_4px_20px_rgba(59,130,246,0.25)] dark:shadow-[0_4px_20px_rgba(30,64,175,0.3)] p-2 sm:p-4 overflow-hidden max-w-full">
            {/* FIX: Added overflow-x-hidden to ScrollArea */}
            <div className="flex-1 rounded-lg bg-card/50 p-1 sm:p-2 overflow-y-auto overflow-x-hidden">
              {messages.length === 0 && !isLoading ? (
                <EmptyStateChat onSuggestionClick={(msg) => setInputMessage(msg)} />
              ) : (
                /* FIX: Added w-full overflow-hidden to messages container */
                <div className="space-y-6 px-2 sm:px-0 w-full overflow-hidden">
                  {messages.map((msg, idx) => {
                    // Try to parse JSON for assistant messages (exercises)
                    let parsedContent = null;
                    try {
                      if (msg.role === "assistant" && msg.content.startsWith("{")) {
                        parsedContent = JSON.parse(msg.content);
                      }
                    } catch {
                      parsedContent = null;
                    }

                    const isExercise = parsedContent?.type === "exercice_genere";

                    return (
                      <div key={idx} className={`flex ${msg.role === "user" ? "justify-end" : "justify-start"} w-full`}>
                        {/* FIX: Changed overflow-hidden to overflow-x-auto and added maxWidth style */}
                        <div
                          className={`max-w-[95%] sm:max-w-[80%] min-w-0 rounded-lg p-3 sm:p-4 overflow-x-auto ${
                            msg.role === "user" ? "bg-primary text-white" : "bg-muted"
                          }`}
                          style={{ wordBreak: "break-word", overflowWrap: "anywhere", minWidth: 0, maxWidth: "100%" }}
                        >
                          {msg.imageUrl && (
                            <img src={msg.imageUrl} alt="Uploaded" className="max-w-full rounded-lg mb-3" />
                          )}

                          {/* Rendu structuré pour les exercices générés */}
                          {msg.role === "assistant" && isExercise ? (
                            <ExerciseDisplay parsedContent={parsedContent} showSolution={false} />
                          ) : (
                            /* Rendu classique pour les autres messages */
                            <MarkdownMessage content={msg.content} role={msg.role} />
                          )}

                          <div className="flex items-center justify-between mt-2">
                            <span className="text-xs opacity-70">
                              {msg.timestamp.toLocaleTimeString("fr-FR", {
                                hour: "2-digit",
                                minute: "2-digit",
                              })}
                            </span>
                            {msg.role === "assistant" && userId && (
                              <MessageFeedback
                                messageId={msg.id || `cours-${idx}-${msg.timestamp.getTime()}`}
                                conversationId={currentChatId}
                                messageContent={msg.content}
                                userId={userId}
                                userProfile={userProfile}
                              />
                            )}
                          </div>
                        </div>
                      </div>
                    );
                  })}
                  {isLoading && (
                    <div className="flex justify-start">
                      <div className="bg-muted rounded-lg p-4 flex items-center gap-2">
                        <Loader2 className="w-5 h-5 animate-spin" />
                        <span>Je réfléchis...</span>
                      </div>
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Input Area - Floating Style */}
            <div className="mb-4 mt-4">
              <div className="bg-white dark:bg-gray-800 rounded-2xl border border-gray-800 dark:border-gray-300 shadow-lg p-4">
                {/* Prévisualisation multi-images */}
                {imagePreviews.length > 0 && (
                  <div className="flex flex-wrap gap-2 mb-3">
                    {imagePreviews.map((preview, index) => (
                      <div key={index} className="relative inline-block">
                        <img
                          src={preview}
                          alt={`Preview ${index + 1}`}
                          className="max-h-24 rounded-lg border-2 border-border"
                        />
                        <Button
                          size="icon"
                          variant="destructive"
                          className="absolute -top-2 -right-2 h-6 w-6 rounded-full"
                          onClick={() => handleRemoveImage(index)}
                        >
                          <X className="h-4 w-4" />
                        </Button>
                        <span className="absolute bottom-1 left-1 bg-black/50 text-white text-xs px-1 rounded">
                          {index + 1}/3
                        </span>
                      </div>
                    ))}
                    {selectedImages.length < 3 && (
                      <div className="text-xs text-muted-foreground self-center ml-2">
                        +{3 - selectedImages.length} image(s) possible(s)
                      </div>
                    )}
                  </div>
                )}

                <div className="flex gap-3">
                  <label htmlFor="image-upload">
                    <Button
                      type="button"
                      variant="outline"
                      size="icon"
                      className="cursor-pointer h-[60px] w-[60px] rounded-xl border-gray-300 dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700"
                      asChild
                      title={`Ajouter une image (${selectedImages.length}/3)`}
                    >
                      <span>
                        <ImagePlus className="w-5 h-5" />
                      </span>
                    </Button>
                  </label>
                  <input
                    id="image-upload"
                    type="file"
                    accept="image/*"
                    className="hidden"
                    onChange={handleImageSelect}
                  />

                  <Textarea
                    placeholder="Pose ta question"
                    value={inputMessage}
                    onChange={(e) => setInputMessage(e.target.value)}
                    onKeyDown={(e) => {
                      if (e.key === "Enter" && !e.shiftKey) {
                        e.preventDefault();
                        handleSendMessage();
                      }
                    }}
                    className="flex-1 min-h-[60px] rounded-xl border-gray-300 dark:border-gray-600 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  />

                  <Button
                    onClick={handleSendMessage}
                    disabled={isLoading || (!inputMessage.trim() && selectedImages.length === 0)}
                    size="icon"
                    className="h-[60px] w-[60px] rounded-xl bg-blue-600 hover:bg-blue-700 text-white"
                  >
                    <Send className="w-5 h-5" />
                  </Button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* 🐛 Debug Console - masquée en production */}
      {false && <DebugConsole entries={debugEntries} onClear={() => setDebugEntries([])} />}

      <LogoutCSATDialog
        isOpen={isCSATOpen}
        onComplete={handleCSATComplete}
        onSkip={handleCSATSkip}
        userId={csatUserId}
        userProfile={csatUserProfile}
      />
    </div>
  );
};

export default Cours;
