import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import Header from "@/components/Header";
import { Button } from "@/components/ui/button";
import { ScrollArea } from "@/components/ui/scroll-area";
import { ArrowLeft, Loader2 } from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { MathText } from "@/components/MathText";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { MarkdownMessage } from "@/components/chat/MarkdownMessage";
import { normalizeChatText } from "@/utils/normalizeChatText";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";

interface ChatItem {
  id: string;
  created_at: string;
  exercices: {
    id: string;
    enonce: any;
    chapitre: string;
  } | null;
}

interface ChatMessage {
  role: string;
  content: string;
  created_at: string;
  image_url: string | null;
}

const Historique = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [userId, setUserId] = useState<string | null>(null);
  const [view, setView] = useState<'list' | 'detail'>('list');
  const [chats, setChats] = useState<ChatItem[]>([]);
  const [chatHistory, setChatHistory] = useState<ChatMessage[]>([]);
  const [selectedChat, setSelectedChat] = useState<ChatItem | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  
  const {
    isCSATOpen,
    userProfile: csatUserProfile,
    userId: csatUserId,
    triggerLogoutWithCSAT,
    handleCSATComplete,
    handleCSATSkip,
  } = useAdvancedCSAT();

  useEffect(() => {
    checkAuth();
  }, []);

  const checkAuth = async () => {
    const { data: { session } } = await supabase.auth.getSession();
    
    if (!session) {
      navigate("/login");
      return;
    }

    setIsLoggedIn(true);
    setUserId(session.user.id);
    
    // Load chats list
    await fetchChats(session.user.id);
  };

  const fetchChats = async (uid: string) => {
    setIsLoading(true);
    try {
      const { data, error } = await supabase
        .from("chats")
        .select(`
          id,
          created_at,
          exercices (
            id,
            enonce,
            chapitre
          )
        `)
        .eq("user_id", uid)
        .order("created_at", { ascending: false });

      if (error) throw error;

      setChats(data || []);
    } catch (error: any) {
      toast({
        title: "Erreur",
        description: error.message || "Impossible de charger l'historique",
        variant: "destructive",
      });
    } finally {
      setIsLoading(false);
    }
  };

  const handleChatClick = async (chat: ChatItem) => {
    setSelectedChat(chat);
    setIsLoading(true);
    
    try {
      // 1. Charger chat_history
      const { data, error } = await supabase
        .from("chat_history")
        .select("*")
        .eq("chat_id", chat.id)
        .order("created_at", { ascending: true });

      if (error) throw error;

      let finalHistory: ChatMessage[] = data || [];
      
      // 2. Si chat_history est vide ou presque, charger les interactions comme fallback
      if (chat.exercices?.id && (data && data.length <= 1)) {
        console.log("🔄 Fallback: chargement des interactions pour exercice", chat.exercices?.id);
        
        const { data: interactions, error: intError } = await supabase
          .from("interactions")
          .select("reponse_eleve, correction, created_at, image_url")
          .eq("user_id", userId!)
          .eq("exercice_id", chat.exercices!.id)
          .order("created_at", { ascending: true });
        
        if (intError) {
          console.error("❌ Erreur chargement interactions:", intError);
        } else if (interactions && interactions.length > 0) {
          console.log("✅ Fallback:", interactions.length, "interactions chargées");
          
          // Mapper interactions en messages
          const interactionMessages: ChatMessage[] = [];
          
          for (const inter of interactions) {
            // Message user (reponse_eleve)
            if (inter.reponse_eleve) {
              interactionMessages.push({
                role: "user",
                content: inter.reponse_eleve,
                created_at: inter.created_at,
                image_url: inter.image_url,
              });
            }
            
            // Message assistant (correction)
            if (inter.correction) {
              let assistantContent = inter.correction;
              
              try {
                const parsed = JSON.parse(inter.correction);
                
                // Priorité : reponse_naturelle > message > message_introduction
                if (parsed.reponse_naturelle) {
                  assistantContent = parsed.reponse_naturelle;
                } else if (parsed.message) {
                  assistantContent = parsed.message;
                } else if (parsed.message_introduction) {
                  assistantContent = parsed.message_introduction;
                }
              } catch {
                // Garder le texte brut si pas JSON
              }
              
              interactionMessages.push({
                role: "assistant",
                content: assistantContent,
                created_at: inter.created_at,
                image_url: null,
              });
            }
          }
          
          // Fusionner avec chat_history (éviter doublons)
          const existingKeys = new Set(
            finalHistory.map(msg => 
              `${msg.created_at}|${msg.role}|${msg.content.substring(0, 50)}`
            )
          );
          
          for (const msg of interactionMessages) {
            const key = `${msg.created_at}|${msg.role}|${msg.content.substring(0, 50)}`;
            if (!existingKeys.has(key)) {
              finalHistory.push(msg);
            }
          }
          
          // Trier par date
          finalHistory.sort((a, b) => 
            new Date(a.created_at).getTime() - new Date(b.created_at).getTime()
          );
        }
      }

      setChatHistory(finalHistory);
      setView('detail');
    } catch (error: any) {
      toast({
        title: "Erreur",
        description: error.message || "Impossible de charger le chat",
        variant: "destructive",
      });
    } finally {
      setIsLoading(false);
    }
  };

  const handleBack = () => {
    setView('list');
    setSelectedChat(null);
    setChatHistory([]);
  };

  const parseEnonce = (enonce: any) => {
    try {
      const parsed = typeof enonce === 'string' ? JSON.parse(enonce) : enonce;
      return {
        contexte: parsed.contexte || '',
        questions: parsed.questions || []
      };
    } catch (error) {
      return {
        contexte: '',
        questions: []
      };
    }
  };

  const formatMessageContent = (content: string) => {
    try {
      const parsed = typeof content === 'string' ? JSON.parse(content) : content;
      
      let textContent = content;
      
      // Priorité 1 : reponse_naturelle
      if (parsed.reponse_naturelle) {
        textContent = parsed.reponse_naturelle;
      }
      // Priorité 2 : exercice_genere avec message_introduction
      else if (parsed.type === 'exercice_genere' && parsed.message_introduction) {
        textContent = parsed.message_introduction;
      }
      // Priorité 3 : solution_complete (pour les fractions LaTeX)
      else if (parsed.solution_complete) {
        textContent = parsed.solution_complete;
      }
      // Priorité 4 : message générique
      else if (parsed.message) {
        textContent = parsed.message;
      }
      // Priorité 5 : contexte
      else if (parsed.contexte) {
        textContent = parsed.contexte;
      }
      // Si aucun champ reconnu, nettoyer et formater
      else {
        const technicalFields = ['justification', 'difficulte', 'type', 'tokens_utilises', 'modele_utilise'];
        const cleanedObject: any = {};
        
        for (const key in parsed) {
          if (!technicalFields.includes(key) && parsed[key]) {
            cleanedObject[key] = parsed[key];
          }
        }
        
        if (Object.keys(cleanedObject).length > 0) {
          textContent = Object.values(cleanedObject).join('\n\n');
        }
      }
      
      // ✅ Déséchapper les backslashes LaTeX (\\frac → \frac)
      textContent = textContent.replace(/\\\\(frac|sqrt|lim|sum|int|prod|infty|to|mathbb|text|displaystyle|tfrac|dfrac|binom|choose|left|right|begin|end|times|cdot|pm|leq|geq|ne|approx|equiv|subset|subseteq|in|notin|cup|cap|emptyset|forall|exists|nabla|partial|sin|cos|tan|log|ln|exp|alpha|beta|gamma|delta|epsilon|theta|lambda|mu|pi|sigma|omega|Omega|Delta|Gamma|Lambda|Pi|Sigma|ldots|implies|Rightarrow|Leftarrow|Leftrightarrow|iff|rightarrow|leftarrow|leftrightarrow|mapsto|longmapsto|hookrightarrow|hookleftarrow|xrightarrow|xleftarrow|parallel|perp|angle|triangle|circ|quad|qquad|overline|underline|hat|tilde|vec|dot|ddot|cosh|sinh|tanh|arcsin|arccos|arctan|cdots|vdots|ddots)/g, '\\$1');
      
      return normalizeChatText(textContent);
    } catch (error) {
      // Pas JSON, même traitement avec unescapeLatex
      let cleaned = content.replace(/\\\\(frac|sqrt|lim|sum|int|prod|infty|to|mathbb|text|displaystyle|tfrac|dfrac|binom|choose|left|right|begin|end|times|cdot|pm|leq|geq|ne|approx|equiv|subset|subseteq|in|notin|cup|cap|emptyset|forall|exists|nabla|partial|sin|cos|tan|log|ln|exp|alpha|beta|gamma|delta|epsilon|theta|lambda|mu|pi|sigma|omega|Omega|Delta|Gamma|Lambda|Pi|Sigma|ldots|implies|Rightarrow|Leftarrow|Leftrightarrow|iff|rightarrow|leftarrow|leftrightarrow|mapsto|longmapsto|hookrightarrow|hookleftarrow|xrightarrow|xleftarrow|parallel|perp|angle|triangle|circ|quad|qquad|overline|underline|hat|tilde|vec|dot|ddot|cosh|sinh|tanh|arcsin|arccos|arctan|cdots|vdots|ddots)/g, '\\$1');
      return normalizeChatText(cleaned);
    }
  };

  const handleLogout = () => {
    triggerLogoutWithCSAT();
  };

  return (
    <div className="min-h-screen bg-background flex flex-col">
      <Header isLoggedIn={isLoggedIn} onLogout={handleLogout} />

      <div className="flex-1 flex flex-col max-w-5xl mx-auto w-full p-4 sm:p-6 lg:p-8">
        <Button
          variant="outline"
          className="self-start mb-4"
          onClick={() => view === 'list' ? navigate("/") : handleBack()}
        >
          <ArrowLeft className="w-4 h-4 mr-2" />
          {view === 'list' ? "Retour à l'accueil" : "Retour à la liste"}
        </Button>

        {view === 'list' ? (
          <>
            <div className="mb-6">
              <h1 className="text-3xl font-bold mb-2">Mon historique d'exercices</h1>
              <p className="text-muted-foreground">
                Clique sur un exercice pour revoir ton échange complet
              </p>
            </div>

            {isLoading ? (
              <div className="flex justify-center items-center py-20">
                <Loader2 className="w-8 h-8 animate-spin" />
              </div>
            ) : chats.length === 0 ? (
              <Card>
                <CardHeader>
                  <CardTitle>Aucun chat pour le moment</CardTitle>
                  <CardDescription>
                    Commence par résoudre des exercices pour voir ton historique ici
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <Button onClick={() => navigate("/exercise")}>
                    Commencer mes exercices
                  </Button>
                </CardContent>
              </Card>
            ) : (
              <div className="space-y-4">
                {chats.map((chat) => {
                  if (!chat.exercices) return null;
                  
                  const { contexte, questions } = parseEnonce(chat.exercices.enonce);
                  const truncatedContexte = contexte.length > 200 
                    ? contexte.substring(0, 200) + '...' 
                    : contexte;
                  
                  return (
                    <Card 
                      key={chat.id}
                      className="cursor-pointer hover:shadow-lg transition-all hover:border-primary/50"
                      onClick={() => handleChatClick(chat)}
                    >
                      <CardHeader>
                        <CardTitle className="flex items-center gap-2 text-lg">
                          📚 {chat.exercices.chapitre}
                        </CardTitle>
                      </CardHeader>
                      <CardContent className="space-y-4">
                        {contexte && (
                          <div>
                            <p className="text-sm font-semibold text-muted-foreground mb-1">Énoncé :</p>
                            <MathText 
                              content={truncatedContexte} 
                              mode="lenient"
                              auto={{ functions: true, intervals: true, pi: true, sqrt: true, degrees: true, greek: true }}
                              className="text-base leading-relaxed"
                            />
                          </div>
                        )}
                        
                        {questions.length > 0 && (
                          <div>
                            <p className="text-sm font-semibold text-muted-foreground mb-1">Questions :</p>
                            <ol className="list-decimal list-inside space-y-1">
                              {questions.slice(0, 3).map((q: string, i: number) => (
                                <li key={i} className="text-sm">
                                  <MathText 
                                    content={q} 
                                    mode="lenient"
                                    auto={{ functions: true, pi: true, sqrt: true, degrees: true, intervals: true }}
                                    className="inline"
                                  />
                                </li>
                              ))}
                            </ol>
                            {questions.length > 3 && (
                              <p className="text-xs text-muted-foreground mt-1">
                                ... et {questions.length - 3} autre{questions.length - 3 > 1 ? 's' : ''} question{questions.length - 3 > 1 ? 's' : ''}
                              </p>
                            )}
                          </div>
                        )}
                        
                        <p className="text-xs text-muted-foreground text-right">
                          📅 {new Date(chat.created_at).toLocaleDateString("fr-FR", {
                            day: "numeric",
                            month: "long",
                            year: "numeric",
                            hour: "2-digit",
                            minute: "2-digit",
                          })}
                        </p>
                      </CardContent>
                    </Card>
                  );
                })}
              </div>
            )}
          </>
        ) : (
          <>
            <div className="mb-6">
              <h1 className="text-3xl font-bold mb-2">Historique du chat</h1>
              {selectedChat && selectedChat.exercices && (
                <div className="space-y-2">
                  <p className="text-sm text-primary font-medium">
                    📚 {selectedChat.exercices.chapitre}
                  </p>
                  <p className="text-xs text-muted-foreground">
                    {new Date(selectedChat.created_at).toLocaleDateString("fr-FR", {
                      day: "numeric",
                      month: "long",
                      year: "numeric",
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </p>
                </div>
              )}
            </div>

            {selectedChat && selectedChat.exercices && (
              <Card className="mb-4 bg-card/50 border-primary/20">
                <CardHeader>
                  <CardTitle className="text-lg flex items-center gap-2">
                    📝 Énoncé de l'exercice
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  {(() => {
                    const parsed = parseEnonce(selectedChat.exercices.enonce);
                    return (
                      <div className="space-y-3">
                        {parsed.contexte && (
                          <div>
                            <p className="font-medium text-sm mb-2">Contexte :</p>
                            <MathText 
                              content={parsed.contexte}
                              mode="lenient"
                              auto={{ functions: true, intervals: true, pi: true, sqrt: true, degrees: true, greek: true, variables: true }}
                              centerBlocks
                              className="text-sm leading-relaxed [&>div]:my-3 [&>div]:text-center"
                            />
                          </div>
                        )}
                        {parsed.questions && parsed.questions.length > 0 && (
                          <div>
                            <p className="font-medium text-sm mb-2">Questions :</p>
                            <ol className="list-decimal list-inside space-y-1">
                              {parsed.questions.map((q: string, i: number) => (
                                <li key={i} className="text-sm">
                                  <MathText 
                                    content={q}
                                    mode="lenient"
                                    auto={{ functions: true, pi: true, sqrt: true, degrees: true, intervals: true }}
                                    className="inline leading-relaxed"
                                  />
                                </li>
                              ))}
                            </ol>
                          </div>
                        )}
                      </div>
                    );
                  })()}
                </CardContent>
              </Card>
            )}

            {isLoading ? (
              <div className="flex justify-center items-center py-20">
                <Loader2 className="w-8 h-8 animate-spin" />
              </div>
            ) : chatHistory.length === 0 ? (
              <Card>
                <CardContent className="py-20 text-center">
                  <p className="text-lg text-muted-foreground">
                    Désolé, il n'y a pas d'historique associé à cet exercice.
                  </p>
                </CardContent>
              </Card>
            ) : (
              <ScrollArea className="flex-1 border rounded-lg p-4 bg-card">
                <div className="space-y-4">
                  {chatHistory.map((message, index) => (
                    <div
                      key={index}
                      className={`flex ${message.role === "user" ? "justify-end" : "justify-start"}`}
                    >
                      <div
                        className={`max-w-[80%] rounded-lg p-4 ${
                          message.role === "user"
                            ? "bg-primary text-primary-foreground"
                            : "bg-muted"
                        }`}
                      >
                        <MarkdownMessage 
                          content={formatMessageContent(message.content)}
                          role={message.role as 'user' | 'assistant'}
                        />
                        {message.image_url && (
                          <img 
                            src={message.image_url} 
                            alt="Réponse manuscrite" 
                            className="max-w-full rounded-lg border mt-2 mb-2"
                          />
                        )}
                        <p className="text-xs opacity-70 mt-2">
                          {new Date(message.created_at).toLocaleTimeString("fr-FR", {
                            hour: "2-digit",
                            minute: "2-digit",
                          })}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              </ScrollArea>
            )}
          </>
        )}
      </div>
      
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

export default Historique;
