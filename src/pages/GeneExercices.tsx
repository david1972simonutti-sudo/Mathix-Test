import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import Header from "@/components/Header";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";

const GeneExercices = () => {
  const navigate = useNavigate();
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  
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
      setIsLoading(false);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (!session) {
        navigate("/login");
      } else {
        setIsLoggedIn(true);
      }
    });

    return () => subscription.unsubscribe();
  }, [navigate]);

  const handleLogout = () => {
    triggerLogoutWithCSAT();
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      <Header isLoggedIn={isLoggedIn} onLogout={handleLogout} />
      
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <h1 className="text-4xl font-bold mb-8 text-center">Génération d'exercices</h1>
        
        <div className="bg-card rounded-2xl border border-border p-12 text-center">
          <p className="text-xl text-muted-foreground">
            Cette page sera bientôt disponible.
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

export default GeneExercices;
