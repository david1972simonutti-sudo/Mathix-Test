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
import { Badge } from "@/components/ui/badge";
import { normalizeChatText } from "@/utils/normalizeChatText";
import { MarkdownMessage } from "@/components/chat/MarkdownMessage";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";

interface ChatItem {
  id: string;
  created_at: string;
  titre?: string;
}

interface ChatMessage {
  role: string;
  content: string;
  created_at: string;
  image_url: string | null;
}

const HistoriqueCours = () => {
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
        .select("id, created_at, chat_type, titre")
        .eq("user_id", uid)
        .eq("chat_type", "cours")
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
      // Charger uniquement les messages de ce chat spécifique
      const { data, error } = await supabase
        .from("chat_history")
        .select("*")
        .eq("chat_id", chat.id)
        .order("created_at", { ascending: true });

      if (error) throw error;

      setChatHistory(data || []);
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

  const formatMessageContent = (content: string) => {
    try {
      const parsed = typeof content === 'string' ? JSON.parse(content) : content;
      
      let textContent = content;
      
      if (parsed.reponse_naturelle) {
        textContent = parsed.reponse_naturelle;
      } else if (parsed.message) {
        textContent = parsed.message;
      } else if (parsed.solution_complete) {
        textContent = parsed.solution_complete;
      }
      
      // 🔧 FIX: Convertir les \\n en vrais retours à la ligne
      textContent = textContent.replace(/\\n/g, '\n');
      
      // ✅ Déséchapper les backslashes LaTeX (\\frac → \frac)
      textContent = textContent.replace(/\\\\(frac|sqrt|lim|sum|int|prod|infty|to|mathbb|text|displaystyle|tfrac|dfrac|binom|choose|left|right|begin|end|times|cdot|pm|leq|geq|ne|approx|equiv|subset|subseteq|in|notin|cup|cap|emptyset|forall|exists|nabla|partial|sin|cos|tan|log|ln|exp|alpha|beta|gamma|delta|epsilon|theta|lambda|mu|pi|sigma|omega|Omega|Delta|Gamma|Lambda|Pi|Sigma|ldots|implies|Rightarrow|Leftarrow|Leftrightarrow|iff|rightarrow|leftarrow|leftrightarrow|mapsto|longmapsto|hookrightarrow|hookleftarrow|xrightarrow|xleftarrow|parallel|perp|angle|triangle|circ|quad|qquad|overline|underline|hat|tilde|vec|dot|ddot|cosh|sinh|tanh|arcsin|arccos|arctan|cdots|vdots|ddots)/g, '\\$1');
      
      return normalizeChatText(textContent);
    } catch (error) {
      // Même traitement si pas JSON
      let cleaned = content.replace(/\\n/g, '\n');
      cleaned = cleaned.replace(/\\\\(frac|sqrt|lim|sum|int|prod|infty|to|mathbb|text|displaystyle|tfrac|dfrac|binom|choose|left|right|begin|end|times|cdot|pm|leq|geq|ne|approx|equiv|subset|subseteq|in|notin|cup|cap|emptyset|forall|exists|nabla|partial|sin|cos|tan|log|ln|exp|alpha|beta|gamma|delta|epsilon|theta|lambda|mu|pi|sigma|omega|Omega|Delta|Gamma|Lambda|Pi|Sigma|ldots|implies|Rightarrow|Leftarrow|Leftrightarrow|iff|rightarrow|leftarrow|leftrightarrow|mapsto|longmapsto|hookrightarrow|hookleftarrow|xrightarrow|xleftarrow|parallel|perp|angle|triangle|circ|quad|qquad|overline|underline|hat|tilde|vec|dot|ddot|cosh|sinh|tanh|arcsin|arccos|arctan|cdots|vdots|ddots)/g, '\\$1');
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
          onClick={() => view === 'list' ? navigate("/historique") : handleBack()}
        >
          <ArrowLeft className="w-4 h-4 mr-2" />
          {view === 'list' ? "Retour" : "Retour à la liste"}
        </Button>

        {view === 'list' ? (
          <>
            <div className="mb-6">
              <h1 className="text-3xl font-bold mb-2">Mon historique de cours</h1>
              <p className="text-muted-foreground">
                Clique sur une conversation pour la revoir
              </p>
            </div>

            {isLoading ? (
              <div className="flex justify-center items-center py-20">
                <Loader2 className="w-8 h-8 animate-spin" />
              </div>
            ) : chats.length === 0 ? (
              <Card>
                <CardHeader>
                  <CardTitle>Aucune demande de cours pour le moment</CardTitle>
                  <CardDescription>
                    Demande-moi des explications sur un cours pour voir ton historique ici
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <Button onClick={() => navigate("/exercise")}>
                    Poser une question
                  </Button>
                </CardContent>
              </Card>
            ) : (
              <div className="space-y-4">
                {chats.map((chat) => {
                  return (
                    <Card 
                      key={chat.id}
                      className="cursor-pointer hover:shadow-lg transition-all hover:border-secondary/50"
                      onClick={() => handleChatClick(chat)}
                    >
                      <CardHeader>
                        <div className="flex items-center justify-between">
                          <CardTitle className="flex items-center gap-2 text-lg">
                            📖 {chat.titre || "Demande de cours"}
                          </CardTitle>
                          <Badge variant="secondary">Cours</Badge>
                        </div>
                      </CardHeader>
                      <CardContent>
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
              <h1 className="text-3xl font-bold mb-2">Conversation de cours</h1>
              {selectedChat && (
                <div className="space-y-2">
                  <Badge variant="secondary">Cours</Badge>
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

            {isLoading ? (
              <div className="flex justify-center items-center py-20">
                <Loader2 className="w-8 h-8 animate-spin" />
              </div>
            ) : chatHistory.length === 0 ? (
              <Card>
                <CardContent className="py-20 text-center">
                  <p className="text-lg text-muted-foreground">
                    Désolé, il n'y a pas d'historique pour cette conversation.
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
                            alt="Image" 
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

export default HistoriqueCours;
