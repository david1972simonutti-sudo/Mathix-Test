import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import Header from "@/components/Header";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { BookOpen, ClipboardList, ArrowLeft } from "lucide-react";
import GeometricBackground from "@/components/GeometricBackground";
import { Button } from "@/components/ui/button";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";

const HistoriqueHome = () => {
  const navigate = useNavigate();
  const [isLoggedIn, setIsLoggedIn] = useState(false);

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
  };

  const handleLogout = () => {
    triggerLogoutWithCSAT();
  };

  return (
    <div className="min-h-screen bg-background">
      <Header isLoggedIn={isLoggedIn} onLogout={handleLogout} />
      
      <GeometricBackground className="w-full min-h-screen">
        <div className="container mx-auto px-4 pt-8 pb-16">
          <Button
            variant="outline"
            className="mb-8"
            onClick={() => navigate("/")}
          >
            <ArrowLeft className="w-4 h-4 mr-2" />
            Retour à l'accueil
          </Button>
          
          <h1 className="text-4xl font-bold text-center mb-4">
            Mon Historique
          </h1>
          <p className="text-center text-muted-foreground mb-8">
            Consulte tes exercices passés et tes demandes de cours
          </p>
          
          <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
            {/* Carte Exercices avec bordure rose/violet */}
            <div
              className="rounded-[20px] md:rounded-[28px] p-[2px] md:p-[3px] shadow-md hover:shadow-xl transition-all duration-300 hover:-translate-y-0.5 hover:scale-105 cursor-pointer"
              style={{ background: "linear-gradient(to bottom, #f9a8d4, #9333ea)" }}
              onClick={() => navigate('/historique_exos')}
            >
              <Card className="bg-card/95 backdrop-blur-sm rounded-[18px] md:rounded-[25px] border-0 h-full">
                <CardHeader className="text-center">
                  <ClipboardList 
                    className="w-16 h-16 mx-auto mb-4" 
                    style={{ color: "#a855f7" }}
                  />
                  <CardTitle className="text-2xl">
                    Mes exercices
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-center text-muted-foreground">
                    Consulte l'historique de tous les exercices que tu as résolus avec moi
                  </p>
                </CardContent>
              </Card>
            </div>
            
            {/* Carte Cours avec bordure bleue */}
            <div
              className="rounded-[20px] md:rounded-[28px] p-[2px] md:p-[3px] shadow-md hover:shadow-xl transition-all duration-300 hover:-translate-y-0.5 hover:scale-105 cursor-pointer"
              style={{ background: "linear-gradient(to bottom, #93c5fd, #2563eb)" }}
              onClick={() => navigate('/historique_cours')}
            >
              <Card className="bg-card/95 backdrop-blur-sm rounded-[18px] md:rounded-[25px] border-0 h-full">
                <CardHeader className="text-center">
                  <BookOpen 
                    className="w-16 h-16 mx-auto mb-4" 
                    style={{ color: "#3b82f6" }}
                  />
                  <CardTitle className="text-2xl">
                    Mes cours
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-center text-muted-foreground">
                    Retrouve toutes les explications et leçons que tu as demandées
                  </p>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </GeometricBackground>

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

export default HistoriqueHome;
