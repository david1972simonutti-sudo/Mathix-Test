import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import Header from "@/components/Header";
import { Settings, ArrowLeft } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";
import { ParentInvitationManager } from "@/components/ParentInvitationManager";

const Parametres = () => {
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
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (!session) {
        navigate("/login");
      } else {
        setIsLoggedIn(true);
      }
    });
  }, [navigate]);

  const handleLogout = () => {
    triggerLogoutWithCSAT();
  };

  return (
    <div className="min-h-screen bg-background">
      <Header isLoggedIn={isLoggedIn} onLogout={handleLogout} />
      <main className="max-w-4xl mx-auto px-4 py-8">
        <Button variant="outline" onClick={() => navigate("/")} className="mb-8 border-muted-foreground/30">
          <ArrowLeft className="mr-2 h-4 w-4" />
          Retour à l'accueil
        </Button>
        
        <div className="flex items-center gap-3 mb-8">
          <Settings className="h-8 w-8 text-primary" />
          <h1 className="text-3xl font-bold">Paramètres du compte</h1>
        </div>

        <div className="space-y-6">
          <ParentInvitationManager />
          
          <div className="text-center p-8 border border-dashed rounded-lg">
            <p className="text-muted-foreground">
              D'autres paramètres arrivent bientôt ! 🚀
            </p>
          </div>
        </div>
      </main>
      
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

export default Parametres;
