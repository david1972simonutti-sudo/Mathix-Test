import { Link, useNavigate, useLocation } from "react-router-dom";
import { useEffect, useState } from "react";
import { useIsMobile } from "@/hooks/use-mobile";
import { supabase } from "@/integrations/supabase/client";
import { UserCircle, BarChart3, History, Target, HelpCircle, LogIn, LogOut, Smile, ArrowLeft, MessageSquarePlus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { MoodSelector } from "@/components/MoodSelector";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

interface HeaderProps {
  isLoggedIn?: boolean;
  onLogout?: () => void;
  showAuthButton?: boolean;
  // Props for chat pages (Cours, Exercise)
  pageTitle?: string;
  onBack?: () => void;
  onNewChat?: () => void;
  backLabel?: string;
  newChatLabel?: string;
}


const Header = ({ 
  isLoggedIn = false, 
  onLogout,
  pageTitle,
  onBack,
  onNewChat,
  backLabel = "Retour",
  newChatLabel = "Nouveau"
}: HeaderProps) => {
  const navigate = useNavigate();
  const location = useLocation();
  const isMobile = useIsMobile();
  const [userFirstName, setUserFirstName] = useState<string | null>(null);
  const [userClasse, setUserClasse] = useState<string | null>(null);
  const [showMoodSelector, setShowMoodSelector] = useState(false);
  const [activeSection, setActiveSection] = useState<string>("accueil");
  const [userRole, setUserRole] = useState<string | null>(null);

  // Only show navigation bar on homepage (and not on chat pages)
  const isHomePage = location.pathname === "/" && !pageTitle;

  // Intersection Observer pour détecter la section visible au scroll
  useEffect(() => {
    if (!isHomePage) return;

    const sectionIds = isLoggedIn 
      ? ['accueil', 'analyse', 'presentation']
      : ['accueil', 'presentation', 'offre'];

    const observer = new IntersectionObserver(
      (entries) => {
        // Trouver la section la plus proche du centre de l'écran
        const visibleEntries = entries.filter(entry => entry.isIntersecting);
        if (visibleEntries.length > 0) {
          const topEntry = visibleEntries.reduce((best, current) => {
            const bestRect = best.boundingClientRect;
            const currentRect = current.boundingClientRect;
            // Celui dont le haut est le plus proche du centre de l'écran
            return Math.abs(currentRect.top) < Math.abs(bestRect.top) ? current : best;
          });
          setActiveSection(topEntry.target.id);
        }
      },
      {
        rootMargin: '-40% 0px -40% 0px',
        threshold: 0
      }
    );

    sectionIds.forEach((id) => {
      const element = document.getElementById(id);
      if (element) {
        observer.observe(element);
      }
    });

    return () => observer.disconnect();
  }, [isHomePage, isLoggedIn]);

  // Force "accueil" quand on est tout en haut de la page
  useEffect(() => {
    if (!isHomePage) return;

    const handleScroll = () => {
      if (window.scrollY < 100) {
        setActiveSection('accueil');
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, [isHomePage]);

  useEffect(() => {
    if (isLoggedIn) {
      fetchUserProfile();
    } else {
      setUserFirstName(null);
      setUserClasse(null);
    }
  }, [isLoggedIn]);

  const fetchUserProfile = async () => {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return;
    
    const { data: profile } = await supabase
      .from("profiles")
      .select("prenom, classe")
      .eq("user_id", user.id)
      .maybeSingle();
    
    if (profile) {
      setUserFirstName(profile.prenom);
      setUserClasse(profile.classe);
    }

    // Récupérer le rôle de l'utilisateur
    const { data: roleData } = await supabase
      .from("user_roles")
      .select("role")
      .eq("user_id", user.id)
      .single();
    
    if (roleData) {
      setUserRole(roleData.role);
    }
  };

  const saveMood = async (selectedMood: string) => {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return;

    const { data: activeSession } = await supabase
      .from("sessions")
      .select("id")
      .eq("user_id", user.id)
      .is("date_fin", null)
      .maybeSingle();

    if (activeSession) {
      await supabase
        .from("sessions")
        .update({
          humeur_du_jour: selectedMood,
          humeur_timestamp: new Date().toISOString(),
        })
        .eq("id", activeSession.id);
    } else {
      await supabase
        .from("sessions")
        .insert({
          user_id: user.id,
          date_debut: new Date().toISOString(),
          humeur_du_jour: selectedMood,
          humeur_timestamp: new Date().toISOString(),
        });
    }
    
    setShowMoodSelector(false);
  };

  const scrollToSection = (sectionId: string) => {
    const element = document.getElementById(sectionId);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <>
      <header 
        className="sticky top-0 z-50 border-b"
        style={{
          background: 'rgba(255, 255, 255, 0.95)',
          backdropFilter: 'blur(12px)',
          WebkitBackdropFilter: 'blur(12px)',
          borderBottomColor: 'rgba(255, 255, 255, 0.3)',
          boxShadow: '0 8px 32px rgba(96, 165, 250, 0.15), 0 0 1px rgba(255, 255, 255, 0.5)'
        }}
      >
        <div className="w-full px-3 sm:px-6 lg:px-8 py-1 sm:py-4">
          <div className={`${isMobile ? "flex justify-between w-full" : "grid grid-cols-3"} items-center`}>
            {/* Logo à gauche - redirige vers le bon dashboard selon le rôle */}
            <button 
              onClick={() => navigate(userRole === 'parent' ? '/parents' : '/')}
              className="flex-shrink-0 justify-self-start"
            >
              <img 
                src="/images/logo-siimply.png" 
                alt="Siimply" 
                className="h-10 sm:h-16 hover:opacity-80 transition-opacity cursor-pointer"
              />
            </button>
            
            {/* Zone centrale - Navigation OU Titre de page avec boutons */}
            {pageTitle ? (
              // Chat pages: Back button + Title + New button
              <div className="flex items-center justify-center gap-1 sm:gap-4">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={onBack}
                  className="flex items-center gap-1 sm:gap-2 px-2 sm:px-3"
                >
                  <ArrowLeft className="w-3 h-3 sm:w-4 sm:h-4" />
                  <span className="hidden sm:inline">{backLabel}</span>
                </Button>
                
                <h1 className="text-xs sm:text-2xl font-bold text-primary truncate max-w-[80px] sm:max-w-none">
                  {pageTitle}
                </h1>
                
                <Button
                  variant="outline"
                  size="sm"
                  onClick={onNewChat}
                  className="flex items-center gap-1 sm:gap-2 px-2 sm:px-3"
                >
                  <MessageSquarePlus className="w-3 h-3 sm:w-4 sm:h-4" />
                  <span className="hidden sm:inline">{newChatLabel}</span>
                </Button>
              </div>
            ) : isHomePage && !isLoggedIn ? (
              // Homepage: Navigation bar for non-logged visitors (mobile + desktop)
              <nav className="flex bg-muted rounded-full px-1 sm:px-2 py-1 sm:py-1.5 gap-0.5 sm:gap-1 shadow-sm justify-self-center">
                <button 
                  onClick={() => {
                    setActiveSection("accueil");
                    scrollToSection('accueil');
                  }}
                  className={`text-xs sm:text-sm font-medium px-2 sm:px-4 py-1 sm:py-1.5 rounded-full transition-all duration-300 ${
                    activeSection === "accueil" 
                      ? "bg-gradient-to-r from-[#3b82f6] to-[#8b5cf6] text-white shadow-md" 
                      : "text-foreground hover:text-foreground hover:bg-background/50"
                  }`}
                >
                  Accueil
                </button>
                <button 
                  onClick={() => {
                    setActiveSection("presentation");
                    scrollToSection('presentation');
                  }}
                  className={`text-xs sm:text-sm font-medium px-2 sm:px-4 py-1 sm:py-1.5 rounded-full transition-all duration-300 ${
                    activeSection === "presentation" 
                      ? "bg-gradient-to-r from-[#3b82f6] to-[#8b5cf6] text-white shadow-md" 
                      : "text-foreground hover:text-foreground hover:bg-background/50"
                  }`}
                >
                  Présentation
                </button>
                <button 
                  onClick={() => {
                    setActiveSection("offre");
                    scrollToSection('offre');
                  }}
                  className={`text-xs sm:text-sm font-medium px-2 sm:px-4 py-1 sm:py-1.5 rounded-full transition-all duration-300 ${
                    activeSection === "offre" 
                      ? "bg-gradient-to-r from-[#3b82f6] to-[#8b5cf6] text-white shadow-md" 
                      : "text-foreground hover:text-foreground hover:bg-background/50"
                  }`}
                >
                  L'offre
                </button>
              </nav>
            ) : (
              // Other pages: Empty center
              <div />
            )}

            {/* Connexion à droite */}
            <div className="flex items-center justify-end justify-self-end">
              {isLoggedIn ? (
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <button className="p-1 sm:p-2 hover:bg-accent rounded-full transition-colors">
                      <UserCircle className={`${isMobile ? "w-8 h-8" : "w-14 h-14"}`} />
                    </button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end" className="w-56">
                    <DropdownMenuLabel className="font-normal">
                      <div className="flex flex-col space-y-1">
                        <p className="text-sm font-medium">{userFirstName || "Utilisateur"}</p>
                        <p className="text-xs text-muted-foreground">{userClasse || "Classe non définie"}</p>
                      </div>
                    </DropdownMenuLabel>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem onClick={() => setShowMoodSelector(true)}>
                      <Smile className="mr-2 h-4 w-4" />
                      Mood du jour
                    </DropdownMenuItem>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem onClick={() => navigate("/competences")}>
                      <BarChart3 className="mr-2 h-4 w-4" />
                      Mes compétences
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => navigate("/historique")}>
                      <History className="mr-2 h-4 w-4" />
                      Historique
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => navigate("/objectifs")}>
                      <Target className="mr-2 h-4 w-4" />
                      Mes objectifs
                    </DropdownMenuItem>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem onClick={() => navigate("/aide")}>
                      <HelpCircle className="mr-2 h-4 w-4" />
                      Aide & support
                    </DropdownMenuItem>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem onClick={onLogout} className="text-destructive focus:text-destructive">
                      <LogOut className="mr-2 h-4 w-4" />
                      Se déconnecter
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              ) : (
                <Button 
                  variant="outline" 
                  onClick={() => navigate("/login")}
                  className={`flex items-center ${isMobile ? "gap-1 px-2 py-1 text-xs" : "gap-2"}`}
                  size={isMobile ? "sm" : "default"}
                >
                  <LogIn className={isMobile ? "h-3 w-3" : "h-4 w-4"} />
                  {isMobile ? "Connexion" : "Se connecter"}
                </Button>
              )}
            </div>
          </div>
        </div>
      </header>

      {/* MoodSelector - même composant que lors de la première connexion */}
      <MoodSelector 
        isOpen={showMoodSelector} 
        onClose={(selectedMood) => saveMood(selectedMood)}
        canDismiss={true}
        onDismiss={() => setShowMoodSelector(false)}
      />
    </>
  );
};

export default Header;
