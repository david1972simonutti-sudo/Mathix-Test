import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import Header from "@/components/Header";
import { HelpCircle, ArrowLeft } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";

const Aide = () => {
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
        <div className="text-center">
          <HelpCircle className="h-16 w-16 mx-auto text-primary mb-6" />
          <h1 className="text-4xl font-bold mb-4">Aide & support</h1>
          <p className="text-xl text-muted-foreground">
            Cette fonctionnalité arrive bientôt ! 🚀
          </p>
          <p className="text-muted-foreground mt-4">
            Tu pourras accéder à l'aide et contacter le support ici.
          </p>
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

export default Aide;
