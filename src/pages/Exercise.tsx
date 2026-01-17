import { useEffect, useState, useMemo } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import Header from "@/components/Header";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Send,
  Loader2,
  ImagePlus,
  X,
  ArrowLeft,
  MessageSquarePlus,
  MessageSquare,
  Calculator,
  Microscope,
} from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { MathText } from "@/components/MathText";
import { MathGraph } from "@/components/MathGraph";
import { Badge } from "@/components/ui/badge";

import { normalizeChatText } from "@/utils/normalizeChatText";
import { MathEditor } from "@/components/MathEditor";
import { MarkdownMessage } from "@/components/chat/MarkdownMessage";
import { MessageFeedback } from "@/components/chat/MessageFeedback";
import { EmptyStateChat } from "@/components/chat/EmptyStateChat";
import { DisplayWarningPopup } from "@/components/DisplayWarningPopup";
import CorrectionWarningPopup from "@/components/CorrectionWarningPopup";

import { useTrackFirstChatUse } from "@/hooks/useTrackFirstChatUse";
import { detectWelcomeContext, generateWelcomeMessage, loadLastChatOfType } from "@/hooks/useWelcomeAndChatLoading";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";
import { DebugConsole, DebugEntry } from "@/components/DebugConsole";
import { compressImage } from "@/utils/imageCompression";


import "katex/dist/katex.min.css";

interface Message {
  id?: string;
  role: "user" | "assistant";
  content: string;
  timestamp: Date;
  imageUrl?: string;
  imageUrls?: string[];  // Support multi-images
}

const Exercise = () => {
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
  const {
    isCSATOpen,
    userProfile: csatUserProfile,
    userId: csatUserId,
    triggerLogoutWithCSAT,
    handleCSATComplete,
    handleCSATSkip,
  } = useAdvancedCSAT();
  
  // URL parameters for prerequisite exercises and competences navigation
  const chapitreParam = searchParams.get("chapitre");
  const niveauPrerequisParam = searchParams.get("niveau_prerequis");
  const sousNotionParam = searchParams.get("sous_notion");
  const fromCompetences = searchParams.get("from") === "competences";
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [currentChatId, setCurrentChatId] = useState<string | null>(null);
  const [graphOffer, setGraphOffer] = useState<{
    expression: string;
    xMin: number;
    xMax: number;
  } | null>(null);
  const [chatContexts, setChatContexts] = useState<Record<string, { exerciceId: string; chapitre: string }>>({});
  const [showMathEditor, setShowMathEditor] = useState(false);
  const [debugEntries, setDebugEntries] = useState<DebugEntry[]>([]);
  const [showDisplayWarning, setShowDisplayWarning] = useState<{type: "tableaux" | "arbres"} | null>(null);
  const [showCorrectionWarning, setShowCorrectionWarning] = useState(false);
  
  
  // 🆕 Contexte d'exercice persistant (énoncé, résolution, corrections)
  const [exerciseContext, setExerciseContext] = useState<{
    enonce_exercice?: string;
    resolution_eleve?: string;
    corrections_remarques?: string;
    derniere_maj?: string;
  } | null>(null);

  // Track first chat use
  const { trackFirstMessage } = useTrackFirstChatUse(userId || undefined);

  useEffect(() => {
    checkAuth();

    // Restore chat contexts from localStorage
    const savedContexts = localStorage.getItem("chatContexts");
    if (savedContexts) {
      try {
        setChatContexts(JSON.parse(savedContexts));
      } catch (e) {
        console.error("Failed to parse chatContexts:", e);
      }
    }

    // Listen for auth state changes to prevent disconnections
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


  // Handle graph offer acceptance/refusal
  useEffect(() => {
    const handleGraphOfferResponse = async () => {
      if (graphOffer && messages.length > 0) {
        const lastMessage = messages[messages.length - 1];

        // Only process user messages (not assistant messages)
        if (lastMessage.role === "user" && !isLoading) {
          const userResponse = lastMessage.content.toLowerCase().trim();

          // Keywords for acceptance
          const acceptKeywords = ["oui", "ok", "d'accord", "vas-y", "volontiers", "trace", "montre", "ouais", "yes"];
          const isAccepted = acceptKeywords.some((keyword) => userResponse.includes(keyword));

          // Keywords for refusal
          const refuseKeywords = ["non", "pas besoin", "ça va", "merci"];
          const isRefused = refuseKeywords.some((keyword) => userResponse.includes(keyword));

          if (isAccepted) {
            // Display the graph
            const graphMessage: Message = {
              role: "assistant",
              content: JSON.stringify({
                type: "math_graph",
                expression: graphOffer.expression,
                xMin: graphOffer.xMin,
                xMax: graphOffer.xMax,
                title: `Graphique de f(x) = ${graphOffer.expression}`,
                message_introduction: "Voici le graphique de la fonction ! 📊",
              }),
              timestamp: new Date(),
            };

            setMessages((prev) => [...prev, graphMessage]);
            await saveMessageToChat(currentChatId, graphMessage);

            // Clear the offer
            setGraphOffer(null);
          } else if (isRefused) {
            // User declined, clear the offer silently
            setGraphOffer(null);
          }
          // If neither accepted nor refused, keep the offer active for next message
        }
      }
    };

    handleGraphOfferResponse();
  }, [messages, graphOffer, isLoading, currentChatId]);

  // Les fonctions detectWelcomeContext et generateWelcomeMessage sont maintenant dans useWelcomeAndChatLoading.ts

  // Function to automatically generate a targeted exercise from /competences navigation
  const generateTargetedExerciseFromCompetences = async (
    userId: string,
    sessionId: string | null,
    chapitre: string,
    sousNotion?: string,
    classe?: string
  ) => {
    setIsLoading(true);
    
    try {
      console.log("🎯 Auto-generating targeted exercise:", { chapitre, sousNotion });
      
      // Create a new chat first
      const { data: newChat, error: chatError } = await supabase
        .from("chats")
        .insert({
          user_id: userId,
          session_id: sessionId,
          chat_type: "exercice",
          titre: sousNotion ? `Exercice : ${sousNotion}` : `Exercice : ${chapitre}`,
        })
        .select()
        .single();
      
      if (chatError) {
        console.error("❌ Error creating chat:", chatError);
        throw chatError;
      }
      
      setCurrentChatId(newChat.id);
      localStorage.setItem("currentChatId_exercise", newChat.id);
      
      // Call analyze-response with forceRequestType and targetedSousNotion
      const promptMessage = sousNotion 
        ? `Génère-moi un exercice sur ${sousNotion} (chapitre ${chapitre})`
        : `Génère-moi un exercice sur ${chapitre}`;
      
      const { data, error } = await supabase.functions.invoke("analyze-response", {
        body: {
          userId,
          sessionId,
          exerciceId: null,
          reponseEleve: promptMessage,
          chapitre: chapitre,
          forceRequestType: "generate_exercise",
          targetedSousNotion: sousNotion || null,
          conversationHistory: [],
          fromCompetences: true, // Navigation depuis /competences
        },
      });
      
      if (error) throw error;
      
      const assistantResponse = data?.data;
      
      if (assistantResponse) {
        // Clean Gemini response
        const cleanGeminiResponse = (text: string): string => {
          if (typeof text !== 'string') return text;
          let cleaned = text.replace(/\\n/g, '\n');
          cleaned = cleaned.replace(/\*\*([^*]+)\*\*/g, '$1');
          cleaned = cleaned.replace(/\\\\(frac|sqrt|lim|sum|int|prod|infty|to|mathbb|text|displaystyle|tfrac|dfrac|binom|choose|left|right|begin|end|times|cdot|pm|leq|geq|ne|approx|equiv|subset|subseteq|in|notin|cup|cap|emptyset|forall|exists|nabla|partial|sin|cos|tan|log|ln|exp|alpha|beta|gamma|delta|epsilon|theta|lambda|mu|pi|sigma|omega|Omega|Delta|Gamma|Lambda|Pi|Sigma|ldots|implies|Rightarrow|Leftarrow|Leftrightarrow|iff|rightarrow|leftarrow|leftrightarrow|parallel|perp|angle|triangle|circ|quad|qquad|overline|underline|hat|tilde|vec|dot|ddot|cosh|sinh|tanh|arcsin|arccos|arctan|cdots|vdots|ddots)/g, '\\$1');
          return cleaned;
        };
        
        let responseContent: string;
        
        if (typeof assistantResponse === "object") {
          if (assistantResponse.type === "exercice_genere") {
            // Clean LaTeX in exercise
            const cleanedExercise = {
              ...assistantResponse,
              message_introduction: cleanGeminiResponse(assistantResponse.message_introduction || ""),
              enonce: assistantResponse.enonce ? {
                contexte: cleanGeminiResponse(assistantResponse.enonce.contexte || ""),
                questions: (assistantResponse.enonce.questions || []).map((q: string) => cleanGeminiResponse(q)),
              } : assistantResponse.enonce,
              indices: (assistantResponse.indices || []).map((i: string) => cleanGeminiResponse(i)),
              solution_complete: cleanGeminiResponse(assistantResponse.solution_complete || ""),
            };
            responseContent = JSON.stringify(cleanedExercise);
          } else {
            responseContent = JSON.stringify(assistantResponse);
          }
        } else {
          responseContent = cleanGeminiResponse(String(assistantResponse));
        }
        
        const assistantMessage: Message = {
          role: "assistant",
          content: responseContent,
          timestamp: new Date(),
        };
        
        setMessages([assistantMessage]);
        
        // Save to chat history
        await supabase.from("chat_history").insert({
          chat_id: newChat.id,
          user_id: userId,
          role: "assistant",
          content: responseContent,
        });
        
        console.log("✅ Targeted exercise generated successfully");
      }
    } catch (error) {
      console.error("❌ Error generating targeted exercise:", error);
      toast({
        title: "Erreur",
        description: "Impossible de générer l'exercice. Réessaie !",
        variant: "destructive",
      });
      
      // Show error message in chat
      setMessages([{
        role: "assistant",
        content: "Désolé, je n'ai pas pu générer l'exercice. Peux-tu réessayer en me demandant directement ?",
        timestamp: new Date(),
      }]);
    } finally {
      setIsLoading(false);
    }
  };

  const checkAuth = async () => {
    const {
      data: { session },
    } = await supabase.auth.getSession();

    if (!session) {
      navigate("/login");
      return;
    }

    setIsLoggedIn(true);
    setUserId(session.user.id);

    // Load user profile
    const { data: profile } = await supabase.from("profiles").select("*").eq("user_id", session.user.id).single();

    setUserProfile(profile);

    // Get or create active session
    const { data: activeSession } = await supabase
      .from("sessions")
      .select("*")
      .eq("user_id", session.user.id)
      .is("date_fin", null)
      .maybeSingle();

    let currentSessionId: string | null = null;

    if (activeSession) {
      currentSessionId = activeSession.id;
      setSessionId(activeSession.id);
    } else {
      // Create new session
      const { data: newSession } = await supabase
        .from("sessions")
        .insert({
          user_id: session.user.id,
          date_debut: new Date().toISOString(),
        })
        .select()
        .single();

      currentSessionId = newSession?.id || null;
      setSessionId(newSession?.id || null);
    }

    // If coming from /competences with a chapter parameter, create a new targeted chat
    if (fromCompetences && chapitreParam) {
      console.log("🎯 Creating targeted chat from /competences:", { chapitreParam, sousNotionParam });
      
      // Generate loading message while exercise is being generated
      const loadingMessage = sousNotionParam 
        ? `Je te prépare un exercice sur **${sousNotionParam}** dans le chapitre **${chapitreParam}**... ⏳`
        : `Je te prépare un exercice sur **${chapitreParam}**... ⏳`;
      
      setMessages([{
        role: "assistant" as const,
        content: loadingMessage,
        timestamp: new Date(),
      }]);
      
      // Clear currentChatId to ensure a new chat is created on first message
      setCurrentChatId(null);
      localStorage.removeItem("currentChatId_exercise");
      
      // Trigger automatic exercise generation (URL cleaned after success)
      setTimeout(async () => {
        try {
          await generateTargetedExerciseFromCompetences(
            session.user.id,
            currentSessionId,
            chapitreParam,
            sousNotionParam || undefined,
            profile?.classe || "lycée"
          );
          // Clean URL parameters AFTER successful generation
          window.history.replaceState({}, '', '/exercise');
        } catch (err) {
          console.error("❌ Exercise generation failed:", err);
        }
      }, 100);
      
      return; // Don't load any existing chat
    }

    // Restore active chat from localStorage if available
    const savedChatId = localStorage.getItem("currentChatId_exercise");
    if (savedChatId) {
      // Verify the chat still exists, belongs to this user, AND is of type "exercice"
      const { data: existingChat } = await supabase
        .from("chats")
        .select("id, chat_type, exercise_context")
        .eq("id", savedChatId)
        .eq("user_id", session.user.id)
        .eq("chat_type", "exercice")
        .maybeSingle();

      if (existingChat) {
        setCurrentChatId(savedChatId);
        console.log("🔄 Chat restored from localStorage:", savedChatId);
        
        // 🆕 Charger le contexte d'exercice persistant
        if (existingChat.exercise_context) {
          setExerciseContext(existingChat.exercise_context as any);
          console.log("📋 Contexte exercice restauré:", JSON.stringify(existingChat.exercise_context).substring(0, 100));
        } else {
          setExerciseContext(null);
        }

        // Load chat history
        const { data: history } = await supabase
          .from("chat_history")
          .select("*")
          .eq("chat_id", savedChatId)
          .order("created_at", { ascending: true });

        if (history) {
          const loadedMessages = history.map((msg) => {
            console.log("📖 Loaded message from DB:", {
              role: msg.role,
              contentLength: msg.content?.length,
              preview: msg.content?.substring(0, 100),
              hasLatex: msg.content?.includes("\\frac") || msg.content?.includes("\\sin"),
            });

            return {
              role: msg.role as "user" | "assistant",
              content: msg.content,
              timestamp: new Date(msg.created_at),
              imageUrl: msg.image_url || undefined,
            };
          });
          setMessages(loadedMessages);
        }
        return; // Skip loading other chats if restored from localStorage
      } else {
        // Chat no longer exists or is wrong type, clear localStorage
        localStorage.removeItem("currentChatId_exercise");
      }
    }

    // Détecter le contexte de bienvenue pour les exercices
    const welcomeContext = await detectWelcomeContext(session.user.id, "exercice");
    const welcomeMessage = generateWelcomeMessage(welcomeContext, profile?.prenom || "", "exercice");

    // Si premier chat du jour ou première interaction → nouveau chat, pas d'historique
    if (welcomeMessage) {
      setCurrentChatId(null);
      localStorage.removeItem("currentChatId_exercise");
      setMessages([welcomeMessage]);
      return;
    }

    // Si 'ongoing' → charger le dernier chat exercice existant sans welcome message
    const lastChat = await loadLastChatOfType(session.user.id, "exercice");

    if (lastChat) {
      setCurrentChatId(lastChat.chatId);
      localStorage.setItem("currentChatId_exercise", lastChat.chatId);
      setMessages(lastChat.messages);
    } else {
      // Pas de chat existant du tout
      setMessages([]);
    }
  };

  const handleLogout = () => {
    triggerLogoutWithCSAT();
  };

  // Pre-fill prompt if coming from prerequisite revision
  useEffect(() => {
    if (chapitreParam && niveauPrerequisParam && !currentChatId) {
      const message = `Génère-moi un exercice sur ${chapitreParam} adapté au niveau ${niveauPrerequisParam} pour que je puisse consolider cette notion.`;
      setInputMessage(message);
      toast({
        title: "🎯 Exercice de consolidation",
        description: `Prêt à travailler ${chapitreParam} (niveau ${niveauPrerequisParam})`,
      });
    }
  }, [chapitreParam, niveauPrerequisParam, currentChatId, toast]);

  // Function to load chat history for a specific chat
  const loadChatHistory = async (chatId: string) => {
    try {
      const { data: chatData, error: chatError } = await supabase
        .from("chats")
        .select("*, exercices(*), exercise_context")
        .eq("id", chatId)
        .single();

      if (chatError) throw chatError;
      
      // 🆕 Charger le contexte d'exercice persistant
      if (chatData?.exercise_context) {
        setExerciseContext(chatData.exercise_context as any);
        console.log("📋 Contexte exercice chargé depuis DB:", JSON.stringify(chatData.exercise_context).substring(0, 100));
      } else {
        setExerciseContext(null);
      }

      // Load all messages for this chat
      const { data: historyData, error: historyError } = await supabase
        .from("chat_history")
        .select("*")
        .eq("chat_id", chatId)
        .order("created_at", { ascending: true });

      if (historyError) throw historyError;

      // Map to Message format
      const mappedMessages: Message[] = (historyData || []).map((h: any) => ({
        role: h.role,
        content: h.content,
        timestamp: new Date(h.created_at),
        imageUrl: h.image_url || undefined,
      }));

      // Replace entire message history with this chat's history
      setMessages(mappedMessages);

      console.log(`✅ Loaded ${mappedMessages.length} messages for chat ${chatId}`);
    } catch (error) {
      console.error("Error loading chat history:", error);
    }
  };

  const handleNewChat = async () => {
    // Reset current chat
    setCurrentChatId(null);
    localStorage.removeItem("currentChatId_exercise"); // Clear persisted chat
    
    // 🆕 Reset exercise context for new chat
    setExerciseContext(null);

    // Détecter le contexte (premier chat du jour ou non)
    if (!userId) return;

    const welcomeContext = await detectWelcomeContext(userId, "exercice");
    const welcomeMessage = generateWelcomeMessage(welcomeContext, userProfile?.prenom || "", "exercice");

    // Afficher le message de bienvenue si applicable
    setMessages(welcomeMessage ? [welcomeMessage] : []);

    toast({
      title: "Nouveau chat démarré",
      description: "Tu peux commencer un nouvel exercice",
    });
  };

  const handleImageSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if (selectedImages.length >= 3) {
      toast({ title: "Maximum atteint", description: "Tu peux envoyer jusqu'à 3 images maximum", variant: "destructive" });
      return;
    }
    if (!file.type.startsWith("image/")) {
      toast({ title: "Erreur", description: "Seules les images sont acceptées", variant: "destructive" });
      return;
    }
    if (file.size > 10 * 1024 * 1024) {
      toast({ title: "Erreur", description: "L'image ne doit pas dépasser 10MB", variant: "destructive" });
      return;
    }

    try {
      const compressedFile = await compressImage(file, 1024, 0.8);
      const reader = new FileReader();
      reader.onloadend = () => {
        setSelectedImages(prev => [...prev, compressedFile]);
        setImagePreviews(prev => [...prev, reader.result as string]);
      };
      reader.readAsDataURL(compressedFile);
    } catch (error) {
      console.error("Compression error:", error);
      const reader = new FileReader();
      reader.onloadend = () => {
        setSelectedImages(prev => [...prev, file]);
        setImagePreviews(prev => [...prev, reader.result as string]);
      };
      reader.readAsDataURL(file);
    }
    e.target.value = '';
  };

  const handlePreciseVerification = () => {
    toast({ title: "🔬 Vérification en cours", description: "Analyse mathématique approfondie (~30s)..." });
    handleSendMessage("Vérifie précisément si mon travail est correct.", { forcePreciseVerification: true });
  };

  const handleRemoveImage = (index: number) => {
    setSelectedImages(prev => prev.filter((_, i) => i !== index));
    setImagePreviews(prev => prev.filter((_, i) => i !== index));
  };

  const clearAllImages = () => {
    setSelectedImages([]);
    setImagePreviews([]);
  };

  const uploadImageToStorage = async (file: File): Promise<string | null> => {
    // ✅ Récupérer l'userId directement depuis la session active pour éviter désync RLS
    const { data: { session } } = await supabase.auth.getSession();
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

    const { data, error } = await supabase.storage.from("student-responses").upload(fileName, file);

    if (error) {
      console.error("Upload error:", error);
      toast({
        title: "Erreur d'upload",
        description: error.message,
        variant: "destructive",
      });
      return null;
    }

    // Générer une URL signée (bucket privé) pour sécuriser les photos élèves
    const { data: signedUrlData, error: signedUrlError } = await supabase.storage
      .from("student-responses")
      .createSignedUrl(fileName, 3600); // Expire dans 1 heure

    if (signedUrlError || !signedUrlData?.signedUrl) {
      console.error("Erreur création URL signée:", signedUrlError);
      toast({
        title: "Erreur",
        description: "Impossible de générer l'URL de l'image",
        variant: "destructive",
      });
      return null;
    }

    return signedUrlData.signedUrl;
  };

  const uploadAllImages = async (files: File[]): Promise<string[]> => {
    const urls: string[] = [];
    for (const file of files) {
      const url = await uploadImageToStorage(file);
      if (url) {
        urls.push(url);
      }
    }
    return urls;
  };

  // Helper: Coerce exercise payload to valid format
  const coerceExercisePayload = (payload: any): any | null => {
    if (!payload) return null;

    // If already an object with type "exercice_genere", return as-is
    if (typeof payload === "object" && payload.type === "exercice_genere") {
      return payload;
    }

    // If it's a string, try to parse JSON
    if (typeof payload === "string") {
      // Try to extract JSON from code fence (with or without "json" tag)
      const codeFenceMatch = payload.match(/```(?:json)?\s*(\{[\s\S]*?\})\s*```/);
      if (codeFenceMatch) {
        try {
          const parsed = JSON.parse(codeFenceMatch[1]);
          if (parsed.enonce || parsed.exercice_id) {
            return { ...parsed, type: "exercice_genere" };
          }
        } catch (e) {
          console.debug("Failed to parse JSON from code fence");
        }
      }

      // Try to parse entire string as JSON
      try {
        const parsed = JSON.parse(payload);
        if (parsed.enonce || parsed.exercice_id) {
          return { ...parsed, type: "exercice_genere" };
        }
      } catch (e) {
        // Not valid JSON, continue to next attempt
      }

      // Try to extract first JSON object
      const jsonMatch = payload.match(/\{[\s\S]*?\}/);
      if (jsonMatch) {
        try {
          const parsed = JSON.parse(jsonMatch[0]);
          if (parsed.enonce || parsed.exercice_id) {
            return { ...parsed, type: "exercice_genere" };
          }
        } catch (e) {
          console.debug("Failed to parse JSON object");
        }
      }

      return null;
    }

    // If it's an object without type but has exercise structure
    // Accept any object with enonce OR exercice_id (more permissive)
    if (typeof payload === "object" && (payload.enonce || payload.exercice_id)) {
      return { ...payload, type: "exercice_genere" };
    }

    return null;
  };

  // Helper: Detect if AI generated an exercise
  const isExerciseFromAI = (payload: any): boolean => {
    return coerceExercisePayload(payload) !== null;
  };

  // Helper: Detect if user is requesting a new exercise generation
  const isGenerationRequest = (message: string): boolean => {
    const lowered = message.toLowerCase().trim();
    const generationPatterns = [
      /g[eé]n[eè]re(\s+un)?\s+(exercice|exo)/i,
      /propose(\s+un)?\s+(exercice|exo)/i,
      /donne(\s*-\s*moi)?(\s+un)?\s+(exercice|exo)/i,
      /fais(\s*-\s*moi)?(\s+un)?\s+(exercice|exo)/i,
      /cr[eé]e(\s+un)?\s+(exercice|exo)/i,
      /un\s+(exercice|exo)\s+sur/i,
      /contr[oô]le/i,
      /nouvel?\s+(exercice|exo)/i,
    ];

    return generationPatterns.some((pattern) => pattern.test(lowered));
  };

  // Helper: Detect if user is submitting an exercise
  const isUserSubmittingExercise = (message: string, hasImage: boolean): boolean => {
    // Image attached is a strong indicator
    if (hasImage) return true;

    // Long text (likely an exercise statement)
    if (message.length >= 120) return true;

    // Markers of exercise statements
    const exerciseMarkers = [
      /\b(soit|détermine|calcule|résous|montre|démontre|prouve)\b/i,
      /\$.*\$/, // LaTeX math
      /\d+\.\s+/, // Numbered questions (1. 2. 3.)
      /question\s+\d+/i,
      /exercice\s+\d+/i,
    ];

    return exerciseMarkers.some((marker) => marker.test(message));
  };

  const createNewChatWithExercice = async (exerciceDataOrId: any) => {
    if (!userId || !sessionId) return null;

    try {
      let exerciceId: string;

      // Check if we already have an exercice_id from backend
      if (typeof exerciceDataOrId === "string") {
        exerciceId = exerciceDataOrId;
        console.log("✅ Using existing exercise ID (string):", exerciceId);
      } else if (exerciceDataOrId.exercice_id) {
        exerciceId = exerciceDataOrId.exercice_id;
        console.log("✅ Using existing exercise ID (from object):", exerciceId);
      } else {
        // ❌ CRITICAL: Backend MUST provide exercice_id - never create duplicates on frontend
        console.error("❌ Backend didn't provide exercice_id, refusing to create duplicate!", {
          payload: exerciceDataOrId,
          hasEnonce: !!exerciceDataOrId.enonce,
          hasChapitre: !!exerciceDataOrId.chapitre
        });
        throw new Error("Exercise ID missing from backend response - cannot create duplicate");
      }

      // 🔄 REFRESH: Ensure auth session is fresh before creating chat
      const {
        data: { session: currentSession },
        error: sessionError,
      } = await supabase.auth.refreshSession();

      if (sessionError || !currentSession) {
        console.error("❌ Failed to refresh session:", sessionError);
        throw new Error("Session expirée. Reconnecte-toi.");
      }

      console.log("🔍 Auth debug before chat creation:", {
        userId: userId,
        sessionId: sessionId,
        authUid: currentSession?.user?.id,
        authMatches: currentSession?.user?.id === userId,
      });

      // Create chat linked to this exercise
      const { data: newChat, error: chatError } = await supabase
        .from("chats")
        .insert({
          user_id: userId,
          session_id: sessionId,
          exercice_id: exerciceId,
        })
        .select()
        .single();

      if (chatError) {
        console.error("❌ RLS Error creating chat:", {
          error: chatError,
          code: chatError.code,
          message: chatError.message,
          userId: userId,
          authUid: currentSession?.user?.id,
        });

        // If it's an RLS error, provide helpful message
        if (chatError.code === "42501" || chatError.message?.includes("policy")) {
          throw new Error("Erreur d'authentification. Rafraîchis la page et réessaie.");
        }

        throw chatError;
      }

      return newChat;
    } catch (error) {
      console.error("Error creating chat with exercise:", error);
      return null;
    }
  };

  const saveMessageToChat = async (chatId: string | null, message: Message) => {
    if (!chatId || !userId) return;

    try {
      // Ensure content is a string
      const content = typeof message.content === "string" ? message.content : JSON.stringify(message.content);

      console.log("💾 Saving message:", {
        role: message.role,
        contentLength: content.length,
        preview: content.substring(0, 100),
        hasLatex: content.includes("\\frac") || content.includes("\\sin"),
      });

      await supabase.from("chat_history").insert({
        chat_id: chatId,
        user_id: userId,
        role: message.role,
        content: content,
        image_url: message.imageUrl || null,
      });
    } catch (error) {
      console.error("Error saving message to chat:", error);
    }
  };


  // Save current chat ID to localStorage for persistence across refreshes
  useEffect(() => {
    if (currentChatId) {
      localStorage.setItem("currentChatId_exercise", currentChatId);
      console.log("💾 Exercise chat ID saved to localStorage:", currentChatId);
    }
  }, [currentChatId]);

  // Persist chat contexts to localStorage
  useEffect(() => {
    localStorage.setItem("chatContexts", JSON.stringify(chatContexts));
  }, [chatContexts]);

  // Debug: Log raw content from Gemini vs normalized content
  useEffect(() => {
    if (messages.length > 0) {
      const lastMessage = messages[messages.length - 1];
      if (lastMessage.role === "assistant") {
        try {
          const parsed = JSON.parse(lastMessage.content);
          if (parsed.type === "exercice_genere") {
            console.log("🔴 CONTENU BRUT de Gemini:");
            console.log("Message intro:", parsed.message_introduction);
            console.log("Contexte:", parsed.enonce?.contexte);
            console.log("Question 1:", parsed.enonce?.questions?.[0]);

            console.log("\n🟢 APRÈS normalizeChatText:");
            console.log("Message intro:", normalizeChatText(parsed.message_introduction));
            console.log("Contexte:", normalizeChatText(parsed.enonce?.contexte || ""));
            console.log("Question 1:", normalizeChatText(parsed.enonce?.questions?.[0] || ""));
          }
        } catch (e) {
          // Not JSON, ignore
        }
      }
    }
  }, [messages]);

  // Détecte si un exercice est en cours dans la conversation
  const hasActiveExercise = useMemo(() => {
    return messages.some(msg => {
      if (msg.role !== "assistant") return false;
      try {
        const parsed = JSON.parse(msg.content);
        return parsed?.type === "exercice_genere";
      } catch {
        return false;
      }
    });
  }, [messages]);

  // Interface pour les options de handleSendMessage
  interface SendMessageOptions {
    forceCorrection?: boolean;
    forceHint?: boolean;
    forcePreciseVerification?: boolean;
  }

  // Handlers pour les boutons d'aide rapide
  const handleRequestCorrection = () => {
    setShowCorrectionWarning(true);
  };

  const handleConfirmCorrection = () => {
    setShowCorrectionWarning(false);
    handleSendMessage("Donne-moi la correction complète de l'exercice.", { forceCorrection: true });
  };

  const handleRequestHint = () => {
    handleSendMessage("Donne-moi un indice pour m'aider avec cet exercice.", { forceHint: true });
  };

  const handleSendMessage = async (messageOverride?: string, options?: SendMessageOptions) => {
    const messageToSend = messageOverride || inputMessage;
    if ((!messageToSend.trim() && selectedImages.length === 0) || !userId) return;

    // Upload toutes les images
    let uploadedImageUrls: string[] = [];
    if (selectedImages.length > 0) {
      setIsLoading(true);
      uploadedImageUrls = await uploadAllImages(selectedImages);

      if (uploadedImageUrls.length === 0 && selectedImages.length > 0) {
        setIsLoading(false);
        return;
      }
    }

    const userMessage: Message = {
      role: "user",
      content: messageToSend || "📸 Réponse manuscrite",
      timestamp: new Date(),
      imageUrl: uploadedImageUrls[0] || undefined,
      imageUrls: uploadedImageUrls.length > 0 ? uploadedImageUrls : undefined,
    };

    // Check if user is submitting a new exercise BEFORE calling AI
    const isSubmittingExercise = isUserSubmittingExercise(messageToSend, selectedImages.length > 0);
    const isRequestingGeneration = isGenerationRequest(messageToSend);
    let preChatId = currentChatId;

    // Determine explicit request type for backend
    let forceRequestType: string | undefined;
    
    // 🔧 FIX: forceCorrection/forceHint = TOUJOURS analyze_response (jamais génération)
    if (options?.forceCorrection || options?.forceHint) {
      forceRequestType = "analyze_response";
    } else if (isRequestingGeneration) {
      forceRequestType = "generate_exercise";
    } else if (isSubmittingExercise) {
      forceRequestType = "analyze_response";
    }

    // Create new chat for ANY conversation (not just exercises)
    // 🔧 FIX: Always create a simple chat first, especially for image submissions
    if (!currentChatId) {
      console.log("📚 Creating new chat for conversation (image or text)");

      // Always create a simple chat first - this ensures persistence
      const { data: chatData, error: chatError } = await supabase
        .from("chats")
        .insert({
          user_id: userId,
          session_id: sessionId,
          chat_type: "exercice",
          titre: messageToSend 
            ? messageToSend.substring(0, 50) + (messageToSend.length > 50 ? "..." : "")
            : uploadedImageUrls.length > 0 
              ? "📸 Exercice soumis via image"
              : "Nouvelle conversation",
        })
        .select()
        .single();

      if (!chatError && chatData) {
        preChatId = chatData.id;
        setCurrentChatId(chatData.id);
        localStorage.setItem("currentChatId_exercise", chatData.id);
        console.log("✅ Chat created successfully:", chatData.id);
        
        if (uploadedImageUrls.length > 0) {
          toast({
            title: "📚 Chat créé !",
            description: "Analyse de ton image en cours...",
          });
        }
      } else {
        console.error("❌ Failed to create chat:", chatError);
        toast({
          title: "Erreur",
          description: "Impossible de créer le chat. Réessaie.",
          variant: "destructive",
        });
        setIsLoading(false);
        return;
      }
    }

    setMessages((prev) => [...prev, userMessage]);
    // Track first chat use
    trackFirstMessage();
    setInputMessage("");
    clearAllImages();
    setIsLoading(true);

    // Optional: gentle reminder for multi-part questions with short answers
    if (preChatId && !isSubmittingExercise) {
      const messageLength = messageToSend.trim().length;
      const hasMathExpressions = /[=+\-*/]|\\frac|\\sqrt|\\lim|U_n|V_n|x\s*=/.test(messageToSend);

      if (messageLength < 80 && !hasMathExpressions && messageLength > 0 && !messageOverride) {
        toast({
          title: "💡 Conseil",
          description: "Pense à rédiger ta démarche complète avec les calculs détaillés !",
          duration: 3000,
        });
      }
    }

    // Save user message to the appropriate chat
    await saveMessageToChat(preChatId, userMessage);

    try {
      // Build history including the current user message
      const historyToSend = [...messages, userMessage];

      // Get context for current chat (exerciceId and chapitre)
      const chatContext = preChatId ? chatContexts[preChatId] : null;

      // 🐛 DEBUG: Build request payload avec multi-images
      const requestPayload = {
        userId,
        sessionId,
        exerciceId: chatContext?.exerciceId || null,
        reponseEleve: messageToSend || "Voici ma réponse manuscrite (voir image)",
        imageUrl: uploadedImageUrls[0] || null, // Compatibilité ancien format
        imageUrls: uploadedImageUrls, // Nouveau format multi-images
        enonce: "Chat libre avec l'élève",
        chapitre: chatContext?.chapitre || chapitreParam || null,
        niveauPrerequisParam: niveauPrerequisParam || null,
        chatId: preChatId,
        forceRequestType,
        forceCorrection: options?.forceCorrection || false,
        forceHint: options?.forceHint || false,
        imageProcessingMode: uploadedImageUrls.length > 0 ? "precise" : undefined,
        forcePreciseVerification: options?.forcePreciseVerification || false,
        exerciseContext: exerciseContext, // 🆕 Contexte persistant de l'exercice
        fromCompetences: false, // Appel normal depuis la page exercice
        conversationHistory: historyToSend.map((m) => ({
          role: m.role,
          content: m.content,
        })),
      };

      // 🐛 DEBUG: Log request
      setDebugEntries(prev => [...prev, {
        timestamp: new Date(),
        type: "request",
        data: requestPayload,
      }]);

      // Call analyze-response edge function
      const { data, error } = await supabase.functions.invoke("analyze-response", {
        body: requestPayload,
      });

      // 🐛 DEBUG: Log response
      setDebugEntries(prev => [...prev, {
        timestamp: new Date(),
        type: "response",
        data: { rawData: data, response: data?.data },
      }]);
      console.log("🔍 DEBUG EXERCISE - Réponse brute:", data);

      if (error) throw error;

      // Fonction pour nettoyer la réponse Gemini (retire ** et normalise LaTeX)
      // 🔧 Utilise la version Pro quand imageProcessingMode === 'precise' pour préserver les commandes LaTeX
      const cleanGeminiResponse = (text: string): string => {
        if (typeof text !== 'string') return text;
        
        let cleaned = text;
        
        // 🔧 FIX: Convertir les \\n en vrais retours à la ligne
        // Mode précis (Pro) - utilise une regex qui préserve les commandes LaTeX comme \neq, \nu, etc.
        cleaned = cleaned.replace(/\\n(?![a-zA-Z])/g, '\n');
        
        // Retirer uniquement les ** (markdown gras)
        cleaned = cleaned.replace(/\*\*([^*]+)\*\*/g, '$1');
        
        // ✅ FIX: Déséchapper les backslashes LaTeX (\\frac → \frac)
        cleaned = cleaned.replace(/\\\\(frac|sqrt|lim|sum|int|prod|infty|to|mathbb|mathcal|mathscr|mathfrak|mathbf|mathrm|mathit|text|displaystyle|tfrac|dfrac|binom|choose|left|right|begin|end|times|cdot|pm|leq|geq|ne|neq|approx|equiv|subset|subseteq|in|notin|cup|cap|emptyset|forall|exists|nabla|partial|sin|cos|tan|log|ln|exp|alpha|beta|gamma|delta|epsilon|theta|lambda|mu|nu|pi|sigma|omega|Omega|Delta|Gamma|Lambda|Pi|Sigma|ldots|implies|Rightarrow|Leftarrow|Leftrightarrow|iff|rightarrow|leftarrow|leftrightarrow|mapsto|longmapsto|hookrightarrow|hookleftarrow|xrightarrow|xleftarrow|parallel|perp|angle|triangle|circ|quad|qquad|overline|underline|hat|tilde|vec|dot|ddot|cosh|sinh|tanh|arcsin|arccos|arctan|cdots|vdots|ddots)/g, '\\$1');
        
        return cleaned;
      };

      const assistantResponse = data?.data;
      const updatedContext = data?.updatedExerciseContext;
      
      // 🆕 Mettre à jour et sauvegarder le contexte d'exercice si présent
      if (updatedContext && preChatId) {
        setExerciseContext(updatedContext);
        console.log("📋 ExerciseContext reçu du backend:", JSON.stringify(updatedContext).substring(0, 150));
        
        // Sauvegarder en DB de manière asynchrone (non bloquant)
        supabase
          .from("chats")
          .update({ exercise_context: updatedContext })
          .eq("id", preChatId)
          .then(({ error: updateError }) => {
            if (updateError) {
              console.error("❌ Erreur sauvegarde exercise_context:", updateError);
            } else {
              console.log("✅ ExerciseContext sauvegardé en DB");
            }
          });
      }

      // Extraire les nouveaux champs pour l'étape 2
      const analyseFine = assistantResponse?.analyse_fine || [];
      const nouveauxChamps = analyseFine.map((item: any) => ({
        sous_notion: item.sous_notion,
        statut: item.statut,
        // ⭐ NOUVEAUX CHAMPS DE L'ÉTAPE 2
        gravite_intrinsèque: item.gravite_intrinsèque,
        niveau_attendu: item.niveau_attendu,
        type_erreur: item.type_erreur,
        est_prerequis_manquant: item.est_prerequis_manquant,
        prerequis_identifie: item.prerequis_identifie,
        niveau_attendu_prerequis: item.niveau_attendu_prerequis,
        bloque_progression: item.bloque_progression
      }));


      // Nettoyer les réponses textuelles (retire ** et normalise LaTeX)
      if (assistantResponse?.reponse_naturelle) {
        assistantResponse.reponse_naturelle = cleanGeminiResponse(assistantResponse.reponse_naturelle);
      }
      if (assistantResponse?.message_introduction) {
        assistantResponse.message_introduction = cleanGeminiResponse(assistantResponse.message_introduction);
      }

      console.log("📥 Received from backend:", {
        type: typeof assistantResponse,
        isString: typeof assistantResponse === "string",
        preview:
          typeof assistantResponse === "string"
            ? assistantResponse.substring(0, 100)
            : JSON.stringify(assistantResponse).substring(0, 100),
        hasLatex:
          typeof assistantResponse === "string"
            ? assistantResponse.includes("\\frac") || assistantResponse.includes("\\sin")
            : JSON.stringify(assistantResponse).includes("\\frac"),
      });

      // Normalize exercise payload if present
      const normalizedExercise = coerceExercisePayload(assistantResponse);
      
      // 🔧 FIX: Si on a demandé une correction ou un indice, NE JAMAIS créer un nouveau chat
      // même si le backend a renvoyé type: "exercice_genere" par erreur
      const isExplicitRequestFromButton = options?.forceCorrection || options?.forceHint;
      const aiGeneratedExercise = normalizedExercise !== null && !isExplicitRequestFromButton;

      // Handle different response types
      let responseText;
      let finalChatId = preChatId; // Track which chat to save to

      if (assistantResponse?.type === "erreur_format") {
        responseText =
          assistantResponse.message_introduction ||
          "Désolé, j'ai raté la génération. Dis 'regénère' ou réessaie ta demande.";

        const assistantMessage: Message = {
          role: "assistant",
          content: responseText,
          timestamp: new Date(),
        };

        setMessages((prev) => [...prev, assistantMessage]);

        await saveMessageToChat(finalChatId, assistantMessage);

        toast({
          title: "Erreur de génération",
          description: "Je n'ai pas pu générer l'exercice. Réessaie avec une autre formulation.",
          variant: "destructive",
        });
      } else if (aiGeneratedExercise) {
        // AI GENERATED AN EXERCISE - Create new chat
        console.log("📚 AI generated exercise detected:", {
          hasExerciceId: !!normalizedExercise.exercice_id,
          exerciceId: normalizedExercise.exercice_id,
          chapitre: normalizedExercise.chapitre
        });

        // ⚠️ CRITICAL: Backend MUST provide exercice_id
        if (!normalizedExercise.exercice_id) {
          console.error("❌ Backend returned exercise without exercice_id - blocking duplicate creation");
          toast({
            title: "Erreur de génération",
            description: "L'exercice n'a pas pu être créé correctement. Réessaie.",
            variant: "destructive",
          });
          return;
        }

        // Step 1: Create new chat with exercise (using backend-provided ID)
        const newChat = await createNewChatWithExercice(normalizedExercise.exercice_id);

        if (newChat) {
          finalChatId = newChat.id;
          setCurrentChatId(newChat.id);
          localStorage.setItem("currentChatId_exercise", newChat.id);

          // Store context for this chat
          setChatContexts((prev) => ({
            ...prev,
            [newChat.id]: {
              exerciceId: normalizedExercise.exercice_id,
              chapitre: normalizedExercise.chapitre || "Exercice généré",
            },
          }));

          // Step 2: Clear current messages (fresh start for new chat)
          setMessages([]);

          // Step 3: Create exercise message (using normalized payload)
          const exerciseContent = JSON.stringify(normalizedExercise);
          console.log("🎯 Creating exercise message:", {
            contentLength: exerciseContent.length,
            exerciceId: normalizedExercise.exercice_id,
            hasLatex: exerciseContent.includes("\\frac") || exerciseContent.includes("\\sin"),
          });

          const exerciseMessage: Message = {
            role: "assistant",
            content: exerciseContent,
            timestamp: new Date(),
          };

          // Step 4: Update UI with exercise message only
          setMessages([exerciseMessage]);

          // Step 5: Save exercise message to NEW chat
          await saveMessageToChat(finalChatId, exerciseMessage);

          // Step 6: Check for first-time display warnings (tableaux/arbres)
          const chapitreLower = (normalizedExercise.chapitre || "").toLowerCase();
          const isDerivees = chapitreLower.includes("dérivé") || chapitreLower.includes("derive");
          const isProbabilites = chapitreLower.includes("probabilité") || chapitreLower.includes("probabilite") || chapitreLower.includes("proba");
          
          const hasSeenArbresWarning = localStorage.getItem("hasSeenArbresWarning") === "true";
          
          if (isProbabilites && !hasSeenArbresWarning) {
            setShowDisplayWarning({ type: "arbres" });
          }

          toast({
            title: "📚 Nouveau chat créé !",
            description: "Un nouveau chat a été ouvert pour cet exercice",
          });
        } else {
          // If chat creation failed, show error (don't pollute old chat)
          toast({
            title: "Erreur",
            description: "Impossible de créer le chat pour cet exercice",
            variant: "destructive",
          });
        }
      } else if (assistantResponse?.type === "error_analysis_with_graph_offer") {
        // AI detected error in variation table and offers to show graph
        responseText = assistantResponse.message;

        const assistantMessage: Message = {
          role: "assistant",
          content: responseText,
          timestamp: new Date(),
        };

        setMessages((prev) => [...prev, assistantMessage]);
        await saveMessageToChat(finalChatId, assistantMessage);

        // Store graph offer for potential user acceptance
        setGraphOffer({
          expression: assistantResponse.graph_expression,
          xMin: assistantResponse.graph_xMin || -10,
          xMax: assistantResponse.graph_xMax || 10,
        });
      } else {
        // All other responses (natural language, images, graphs, etc.)
        responseText =
          assistantResponse?.reponse_naturelle ||
          (assistantResponse?.type === "image_generee" || assistantResponse?.type === "math_graph"
            ? JSON.stringify(assistantResponse)
            : assistantResponse?.message || "Je suis là pour t'aider, continue !");

        const assistantMessage: Message = {
          role: "assistant",
          content: responseText,
          timestamp: new Date(),
        };

        setMessages((prev) => [...prev, assistantMessage]);

        await saveMessageToChat(finalChatId, assistantMessage);
      }
    } catch (error: any) {
      console.error("Error:", error);
      
      
      toast({
        title: "Erreur",
        description: error.message || "Une erreur est survenue",
        variant: "destructive",
      });
    } finally {
      setIsLoading(false);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  // Accepter la révision d'un pré-requis bloquant
  const accepterRevision = async (intervention: any) => {
    if (!userId) return;
    
    try {
      // Mettre à jour le statut de l'intervention
      await supabase
        .from('interventions_pedagogiques')
        .update({ statut: 'acceptee', updated_at: new Date().toISOString() })
        .eq('id', intervention.intervention_id);
      
      toast({
        title: "✅ Parfait !",
        description: `On va réviser ${intervention.notion} ensemble.`,
      });
      
      // Naviguer vers la page cours avec le chapitre du pré-requis
      navigate(`/cours?chapitre=${encodeURIComponent(intervention.notion)}&mode=revision`);
    } catch (error) {
      console.error("Erreur lors de l'acceptation de la révision:", error);
      toast({
        title: "Erreur",
        description: "Impossible d'enregistrer ta décision.",
        variant: "destructive",
      });
    }
  };

  // Refuser la révision d'un pré-requis bloquant
  const refuserRevision = async (intervention: any) => {
    if (!userId) return;
    
    try {
      // Mettre à jour le statut de l'intervention avec mode aide renforcée
      await supabase
        .from('interventions_pedagogiques')
        .update({ 
          statut: 'refusee', 
          mode_aide_renforcee: true,
          updated_at: new Date().toISOString() 
        })
        .eq('id', intervention.intervention_id);
      
      toast({
        title: "📝 Très bien",
        description: "J'ai noté. Je vais t'expliquer plus en détail dans les prochains exercices.",
        duration: 4000,
      });
      
      // L'utilisateur peut continuer le chat normalement
      // Le mode aide renforcée sera activé dans les prochaines réponses du backend
    } catch (error) {
      console.error("Erreur lors du refus de la révision:", error);
      toast({
        title: "Erreur",
        description: "Impossible d'enregistrer ta décision.",
        variant: "destructive",
      });
    }
  };

  // Helper function to add display help message to exercise introductions
  const addDisplayHelpMessage = (introMessage: string) => {
    return introMessage;
  };

  // Déterminer si on est dans un état vide (pour afficher l'EmptyState)
  const isEmptyState = messages.length === 0 || 
    (messages.length === 1 && messages[0].role === "assistant" && 
     (messages[0].content.includes("Salut") || messages[0].content.includes("Bienvenue") || messages[0].content.includes("Bonjour")));

  return (
    <div className="min-h-screen flex flex-col bg-gradient-to-br from-indigo-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-900 dark:to-purple-950/30">
      <Header 
        isLoggedIn={isLoggedIn} 
        onLogout={handleLogout}
        pageTitle="Espace Exercices"
        onBack={() => navigate("/")}
        onNewChat={handleNewChat}
      />
      <div className="flex-1 flex flex-col">
        <div className="flex-1 flex flex-col max-w-5xl mx-auto w-full p-4 sm:p-6 lg:p-8">

          <div className="flex-1 flex flex-col bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm rounded-2xl border-2 border-[hsl(270,80%,85%)] dark:border-[hsl(270,60%,40%)] shadow-[0_4px_20px_rgba(139,92,246,0.25)] dark:shadow-[0_4px_20px_rgba(76,29,149,0.3)] p-2 sm:p-4 mb-4">
          <ScrollArea className="flex-1 rounded-lg bg-card/50">
            {isEmptyState && !isLoading ? (
              <EmptyStateChat onSuggestionClick={(msg) => setInputMessage(msg)} />
            ) : (
            <div className="space-y-4 px-2 sm:px-0">
              {messages.map((message, index) => {
                // Try to parse JSON for assistant messages
                let parsedContent;
                try {
                  if (message.role === "assistant") {
                    parsedContent = JSON.parse(message.content);
                  }
                } catch {
                  // Fallback : détecter NOUVEL_EXERCICE_JSON: dans le texte brut
                  if (message.role === "assistant") {
                    const jsonMarkerMatch = message.content.match(/NOUVEL_EXERCICE_JSON:\s*(\{[\s\S]*\})\s*$/);
                    if (jsonMarkerMatch) {
                      try {
                        let jsonStr = jsonMarkerMatch[1]
                          // Échapper les commandes LaTeX non échappées (\infty → \\infty)
                          .replace(/(^|[^\\])\\([a-zA-Z])/g, '$1\\\\$2')
                          .replace(/\\{3,}/g, '\\\\')
                          .replace(/\\\\n/g, '\\n')
                          .replace(/\\\\\\\\/g, '\\\\');
                        parsedContent = JSON.parse(jsonStr);
                        parsedContent.type = "exercice_genere";
                      } catch {
                        parsedContent = null;
                      }
                    }
                  }
                }

                    const isExercise = parsedContent?.type === "exercice_genere";
                    const isImage = parsedContent?.type === "image_generee";

                    return (
                      <div key={index} className={`flex ${message.role === "user" ? "justify-end" : "justify-start"}`}>
                        <div
                          className={`max-w-[95%] sm:max-w-[80%] rounded-lg p-3 sm:p-4 overflow-hidden ${
                            message.role === "user" ? "bg-primary text-white" : "bg-muted"
                          }`}
                        >
                          {message.role === "assistant" && parsedContent?.type === "math_graph" ? (
                            <div className="space-y-3">
                              {/* Message d'introduction */}
                              <p className="text-sm text-foreground leading-relaxed break-words">
                                {parsedContent.message_introduction}
                              </p>

                              {/* Math graph */}
                              <MathGraph
                                expression={parsedContent.expression}
                                xMin={parsedContent.xMin}
                                xMax={parsedContent.xMax}
                                title={parsedContent.title}
                              />
                            </div>
                          ) : message.role === "assistant" && isImage ? (
                            <div className="space-y-3">
                              {/* Message d'introduction */}
                              <p className="text-sm text-foreground leading-relaxed break-words">
                                {parsedContent.message_introduction}
                              </p>

                              {/* Image générée */}
                              <img
                                src={parsedContent.image_base64}
                                alt={parsedContent.description || "Image générée"}
                                className="rounded-lg max-w-full h-auto border border-border shadow-sm"
                              />

                              {/* Description optionnelle */}
                              {parsedContent.description && (
                                <p className="text-xs text-muted-foreground italic">{parsedContent.description}</p>
                              )}
                            </div>
                          ) : message.role === "assistant" && isExercise ? (
                            <div className="space-y-4">
                              {/* Message d'introduction */}
                              <MathText
                                content={normalizeChatText(addDisplayHelpMessage(parsedContent.message_introduction))}
                                mode="lenient"
                                auto={{ functions: true, pi: true, sqrt: true, degrees: true, intervals: true }}
                                className="text-foreground"
                              />

                              {/* Chapitre en badge discret */}
                              {parsedContent.chapitre && (
                                <Badge variant="outline" className="text-xs">
                                  {parsedContent.chapitre}
                                </Badge>
                              )}

                              {/* Énoncé de l'exercice */}
                              <div className="mt-4 p-4 bg-background/50 rounded-md border">
                                <h3 className="text-lg font-semibold text-primary mb-4">📝 Énoncé</h3>

                                {/* Contexte de l'exercice */}
                                {parsedContent.enonce?.contexte && (
                                  <div className="mb-6 bg-muted/30 p-4 rounded-lg">
                                    <MathText
                                      content={normalizeChatText(parsedContent.enonce.contexte)}
                                      mode="lenient"
                                      auto={{
                                        functions: true,
                                        intervals: true,
                                        pi: true,
                                        sqrt: true,
                                        degrees: true,
                                        variables: true,
                                        greek: true,
                                      }}
                                      centerBlocks
                                      className="text-foreground [&>div]:my-4"
                                    />
                                  </div>
                                )}

                                {/* Questions séparées avec numérotation */}
                                {parsedContent.enonce?.questions && parsedContent.enonce.questions.length > 0 ? (
                                  <div className="space-y-4">
                                    {parsedContent.enonce.questions.map((question: string, qIdx: number) => (
                                      <div key={qIdx} className="flex gap-3 items-start">
                                        <span className="font-bold text-primary shrink-0 text-lg">{qIdx + 1}.</span>
                                        <MathText
                                          content={normalizeChatText(question)}
                                          mode="lenient"
                                          auto={{
                                            functions: true,
                                            pi: true,
                                            sqrt: true,
                                            degrees: true,
                                            intervals: true,
                                          }}
                                          className="flex-1 pt-0.5"
                                        />
                                      </div>
                                    ))}
                                  </div>
                                ) : (
                                  // Fallback pour ancien format (si enonce est string)
                                  typeof parsedContent.enonce === "string" && (
                                    <MathText
                                      content={normalizeChatText(parsedContent.enonce)}
                                      mode="lenient"
                                      auto={{
                                        functions: true,
                                        intervals: true,
                                        pi: true,
                                        sqrt: true,
                                        degrees: true,
                                        variables: true,
                                        greek: true,
                                      }}
                                      centerBlocks
                                      className="text-foreground [&>div]:my-4"
                                    />
                                  )
                                )}
                              </div>
                            </div>
                          ) : (
                            <MarkdownMessage 
                              content={message.content} 
                              role={message.role}
                            />
                          )}
                          
                          {/* Affichage de l'intervention pour pré-requis bloquant */}
                          {message.role === "assistant" && parsedContent?.intervention_prerequis?.actif && (
                            <div className="mt-4 p-4 bg-red-50 dark:bg-red-950/20 border-l-4 border-red-500 rounded-lg">
                              <div className="flex items-start gap-3">
                                <span className="text-3xl">🚨</span>
                                <div className="flex-1">
                                  <h3 className="font-bold text-red-800 dark:text-red-300 text-lg mb-2">
                                    Lacune bloquante détectée
                                  </h3>
                                  <div className="text-gray-700 dark:text-gray-300 mb-4 whitespace-pre-line">
                                    <MathText 
                                      content={parsedContent.intervention_prerequis.message}
                                      mode="lenient"
                                      className="[&>p]:mb-2"
                                    />
                                  </div>
                                  <div className="flex flex-col sm:flex-row gap-3">
                                    <Button 
                                      onClick={() => accepterRevision(parsedContent.intervention_prerequis)}
                                      className="bg-green-600 hover:bg-green-700 text-white"
                                    >
                                      ✅ OK, on révise maintenant (Recommandé)
                                    </Button>
                                    <Button 
                                      onClick={() => refuserRevision(parsedContent.intervention_prerequis)}
                                      variant="outline"
                                      className="border-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800"
                                    >
                                      ⏭️ Non, je veux continuer
                                    </Button>
                                  </div>
                                </div>
                              </div>
                            </div>
                          )}
                          
                          {/* Afficher toutes les images du message */}
                          {(message.imageUrls || message.imageUrl) && (
                            <div className="flex flex-wrap gap-2 mt-2 mb-2">
                              {(message.imageUrls || (message.imageUrl ? [message.imageUrl] : [])).map((url, imgIdx) => (
                                <img
                                  key={imgIdx}
                                  src={url}
                                  alt={`Photo ${imgIdx + 1}`}
                                  className="max-w-[150px] rounded-lg border"
                                />
                              ))}
                            </div>
                          )}
                          <div className="flex items-center justify-between mt-2">
                            <span className="text-xs opacity-70">
                              {message.timestamp.toLocaleTimeString("fr-FR", {
                                hour: "2-digit",
                                minute: "2-digit",
                              })}
                            </span>
                            {message.role === "assistant" && userId && (
                              <MessageFeedback
                                messageId={message.id || `exo-${index}-${message.timestamp.getTime()}`}
                                conversationId={currentChatId}
                                messageContent={message.content}
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
              </ScrollArea>

              {/* Zone de saisie avec HybridMathEditor */}
              <div className="mb-4 sm:mb-6">
                <div className="p-4">
                  <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-lg border border-gray-800 dark:border-gray-300 p-3 max-w-4xl mx-auto">
                  <div className="max-w-4xl mx-auto space-y-2">
                    {/* Prévisualisation multi-images */}
                    {imagePreviews.length > 0 && (
                      <div className="flex flex-wrap gap-2 mb-2">
                        {imagePreviews.map((preview, index) => (
                          <div key={index} className="relative inline-block">
                            <img src={preview} alt={`Preview ${index + 1}`} className="max-h-24 rounded-lg border" />
                            <Button
                              variant="destructive"
                              size="icon"
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
                            +{3 - selectedImages.length} image(s)
                          </div>
                        )}
                      </div>
                    )}

                    {/* Affichage du retour sur le travail de l'élève */}
                    {exerciseContext?.corrections_remarques && (
                      <div className="mb-4 p-4 bg-amber-50 dark:bg-amber-950/20 border-l-4 border-amber-500 rounded-lg">
                        <h3 className="font-bold text-amber-800 dark:text-amber-300 mb-2">📝 Retour sur ton travail</h3>
                        <MathText 
                          content={normalizeChatText(exerciseContext.corrections_remarques)}
                          mode="lenient"
                          className="whitespace-pre-line text-amber-900 dark:text-amber-200"
                        />
                      </div>
                    )}

                    {/* Boutons d'aide rapide - visibles uniquement si exercice en cours */}
                    {hasActiveExercise && !isLoading && (
                      <div className="flex gap-2 mb-3">
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={handleRequestCorrection}
                          className="border-cyan-300 text-cyan-600 hover:bg-cyan-50 dark:border-cyan-600 dark:text-cyan-400 dark:hover:bg-cyan-950"
                        >
                          📝 Donne la correction
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={handleRequestHint}
                          className="border-blue-300 text-blue-600 hover:bg-blue-50 dark:border-blue-600 dark:text-blue-400 dark:hover:bg-blue-950"
                        >
                          💡 Indice
                        </Button>
                      </div>
                    )}

              <div className="flex gap-2 items-stretch">
                <input
                  id="image-upload"
                  type="file"
                  accept="image/*"
                  className="hidden"
                  onChange={handleImageSelect}
                  disabled={isLoading}
                />
                <Button
                  variant="outline"
                  size="icon"
                  className="h-[60px] w-[60px] flex-shrink-0"
                  onClick={() => document.getElementById("image-upload")?.click()}
                  disabled={isLoading || selectedImages.length >= 3}
                  title={`Ajouter une image (${selectedImages.length}/3)`}
                >
                  <ImagePlus className="w-5 h-5" />
                </Button>

                <div className="relative flex-1 min-w-0">
                  <Textarea
                    value={inputMessage}
                    onChange={(e) => setInputMessage(e.target.value)}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter' && !e.shiftKey) {
                        e.preventDefault();
                        handleSendMessage();
                      }
                    }}
                    placeholder="Pose ta question"
                    rows={2}
                    disabled={isLoading}
                    className="resize-none min-h-[60px] pr-14 rounded-xl border-gray-200 dark:border-gray-700 focus:ring-2 focus:ring-violet-500 focus:border-violet-500 transition-all"
                  />
                  <Button
                    variant="ghost"
                    size="icon"
                    className="absolute right-2 top-1/2 -translate-y-1/2 h-10 w-10"
                    onClick={() => setShowMathEditor(true)}
                    disabled={isLoading}
                    title="Insérer une formule"
                  >
                    <Calculator className="w-5 h-5" />
                  </Button>
                </div>

                <Button
                  onClick={() => handleSendMessage()}
                  disabled={(!inputMessage.trim() && selectedImages.length === 0) || isLoading}
                  size="icon"
                  className="h-[60px] w-[60px] flex-shrink-0 rounded-xl bg-violet-600 hover:bg-violet-700 shadow-md"
                >
                  {isLoading ? (
                    <Loader2 className="w-5 h-5 animate-spin" />
                  ) : (
                    <Send className="w-5 h-5" />
                  )}
                </Button>
              </div>

              {/* Aperçu en temps réel des formules */}
              {inputMessage && !showMathEditor && (
                <div className="p-3 bg-muted rounded-lg border border-border">
                  <div className="text-xs text-muted-foreground mb-1">Aperçu :</div>
                  <div className="text-base">
                    <MathText content={inputMessage} />
                  </div>
                </div>
              )}

                    {showMathEditor && (
                      <div className="mt-4">
                        <MathEditor
                          onInsert={(latex) => {
                            setInputMessage(prev => prev + ` $${latex}$ `);
                            setShowMathEditor(false);
                          }}
                          onClose={() => setShowMathEditor(false)}
                        />
                      </div>
                    )}
                  </div>
                </div>
                </div>
              </div>
              </div>
        </div>
      </div>

      {/* 🐛 Debug Console - masquée en production */}
      {false && (
        <DebugConsole 
          entries={debugEntries} 
          onClear={() => setDebugEntries([])} 
        />
      )}

      <LogoutCSATDialog
        isOpen={isCSATOpen}
        onComplete={handleCSATComplete}
        onSkip={handleCSATSkip}
        userId={csatUserId}
        userProfile={csatUserProfile}
      />

      <DisplayWarningPopup
        isOpen={showDisplayWarning !== null}
        onClose={() => {
          if (showDisplayWarning?.type === "tableaux") {
            localStorage.setItem("hasSeenTableauxWarning", "true");
          } else if (showDisplayWarning?.type === "arbres") {
            localStorage.setItem("hasSeenArbresWarning", "true");
          }
          setShowDisplayWarning(null);
        }}
        warningType={showDisplayWarning?.type || "tableaux"}
      />

      <CorrectionWarningPopup
        isOpen={showCorrectionWarning}
        onClose={() => setShowCorrectionWarning(false)}
        onConfirmCorrection={handleConfirmCorrection}
      />

    </div>
  );
};

export default Exercise;
