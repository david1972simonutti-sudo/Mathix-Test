import { Link, useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { supabase } from "@/integrations/supabase/client";
import { useEffect, useState } from "react";
import Header from "@/components/Header";
import { MoodSelector } from "@/components/MoodSelector";
import { WelcomePopup } from "@/components/WelcomePopup";
import GeometricBackground from "@/components/GeometricBackground";
import { InviteParentsDialog } from "@/components/InviteParentsDialog";
import ContactModal from "@/components/ContactModal";
import { Users, Target, History, Sparkles, ArrowRight, Trophy, Calculator, BookOpen, ArrowDown, X, Check, Gift, CreditCard } from "lucide-react";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";
import CompetencesRadarPreview from "@/components/CompetencesRadarPreview";
import { useIsMobile } from "@/hooks/use-mobile";

const Index = () => {
  const navigate = useNavigate();
  const isMobile = useIsMobile();
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [showMoodModal, setShowMoodModal] = useState(false);
  const [showWelcomePopup, setShowWelcomePopup] = useState(false);
  const [userId, setUserId] = useState<string | null>(null);
  const [userFirstName, setUserFirstName] = useState<string | null>(null);
  const [hasParents, setHasParents] = useState(true);
  const [showInviteDialog, setShowInviteDialog] = useState(false);
  const [showContactModal, setShowContactModal] = useState(false);
  const [selectedImage, setSelectedImage] = useState<string | null>(null);

  // State pour le texte "Des maths"
  const [typedText, setTypedText] = useState("");
  // State pour déclencher l'apparition de la suite
  const [showSuffix, setShowSuffix] = useState(false);

  // State pour la flèche de scroll
  const [showScrollHint, setShowScrollHint] = useState(false);

  useEffect(() => {
    // Apparition après 5 secondes
    const timeout = setTimeout(() => {
      setShowScrollHint(true);
    }, 5000);
    return () => clearTimeout(timeout);
  }, []);

  // Disparition au scroll
  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 50) {
        setShowScrollHint(false);
      }
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const textToType = "Des maths";
  useEffect(() => {
    // Étape 1 : Écrire "Des maths" lettre par lettre
    if (typedText.length < textToType.length) {
      const timeout = setTimeout(() => {
        setTypedText(textToType.slice(0, typedText.length + 1));
      }, 100); // Vitesse de frappe (100ms par lettre)
      return () => clearTimeout(timeout);
    } else {
      // Étape 2 : Une fois fini, on attend 1 seconde, puis on lance le "shift"
      const timeout = setTimeout(() => {
        setShowSuffix(true);
      }, 1000); // La pause de 1 seconde demandée
      return () => clearTimeout(timeout);
    }
  }, [typedText]);

  const {
    isCSATOpen,
    userProfile: csatUserProfile,
    userId: csatUserId,
    triggerLogoutWithCSAT,
    handleCSATComplete,
    handleCSATSkip,
  } = useAdvancedCSAT();

  useEffect(() => {
    const checkUserAndRole = async (userId: string) => {
      // Vérifier si l'utilisateur est un parent
      const { data: roleData } = await supabase
        .from('user_roles')
        .select('role')
        .eq('user_id', userId)
        .single();
      
      if (roleData?.role === 'parent') {
        navigate('/parents');
        return;
      }
    };

    supabase.auth.getSession().then(({ data: { session } }) => {
      setIsLoggedIn(!!session);
      if (session?.user?.id) {
        setUserId(session.user.id);
        checkUserAndRole(session.user.id);
      }
    });

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setIsLoggedIn(!!session);
      if (session?.user?.id) {
        setUserId(session.user.id);
        checkUserAndRole(session.user.id);
      }
    });

    return () => subscription.unsubscribe();
  }, [navigate]);

  useEffect(() => {
    if (isLoggedIn && userId) {
      checkIfMoodNeeded();
      fetchUserProfile();
      checkIfHasParents();
    }
  }, [isLoggedIn, userId]);

  const checkIfHasParents = async () => {
    if (!userId) return;

    const { data: relations, error } = await supabase
      .from("parent_eleve_relations")
      .select("id")
      .eq("eleve_user_id", userId);

    if (error) {
      console.error("Erreur lors de la vérification des parents:", error);
      return;
    }

    setHasParents(relations && relations.length > 0);
  };

  const checkIfMoodNeeded = async () => {
    if (!userId) return;

    const { data: lastSession } = await supabase
      .from("sessions")
      .select("humeur_timestamp")
      .eq("user_id", userId)
      .order("date_debut", { ascending: false })
      .limit(1)
      .maybeSingle();

    const today = new Date().toDateString();
    const lastMoodDate = lastSession?.humeur_timestamp ? new Date(lastSession.humeur_timestamp).toDateString() : null;

    if (!lastMoodDate || lastMoodDate !== today) {
      setShowMoodModal(true);
    }
  };

  const fetchUserProfile = async () => {
    if (!userId) return;

    const { data: profile } = await supabase
      .from("profiles")
      .select("prenom, has_seen_welcome_popup")
      .eq("user_id", userId)
      .maybeSingle();

    if (profile?.prenom) {
      setUserFirstName(profile.prenom);
    }
    
    // Afficher le popup de bienvenue si jamais vu
    if (profile && profile.has_seen_welcome_popup === false) {
      setShowWelcomePopup(true);
    }
  };

  const handleWelcomeClose = async () => {
    setShowWelcomePopup(false);
    
    // Marquer comme vu dans la BDD
    if (userId) {
      await supabase
        .from("profiles")
        .update({ has_seen_welcome_popup: true })
        .eq("user_id", userId);
    }
  };

  const saveMood = async (selectedMood: string) => {
    if (!userId) return;

    // Check if there's an active session
    const { data: activeSession } = await supabase
      .from("sessions")
      .select("id")
      .eq("user_id", userId)
      .is("date_fin", null)
      .maybeSingle();

    if (activeSession) {
      // Update existing session
      await supabase
        .from("sessions")
        .update({
          humeur_du_jour: selectedMood,
          humeur_timestamp: new Date().toISOString(),
        })
        .eq("id", activeSession.id);
    } else {
      // Create new session
      await supabase.from("sessions").insert({
        user_id: userId,
        date_debut: new Date().toISOString(),
        humeur_du_jour: selectedMood,
        humeur_timestamp: new Date().toISOString(),
      });
    }

    setShowMoodModal(false);
  };

  const handleLogout = () => {
    triggerLogoutWithCSAT();
  };

  return (
    <>
      <div className="min-h-screen bg-background relative">
        {/* Welcome popup s'affiche en premier pour les nouveaux utilisateurs */}
        {showWelcomePopup && (
          <WelcomePopup isOpen={showWelcomePopup} onClose={handleWelcomeClose} />
        )}
        
        {/* MoodSelector s'affiche seulement après le welcome popup */}
        {!showWelcomePopup && showMoodModal && (
          <MoodSelector isOpen={showMoodModal} onClose={saveMood} />
        )}

        {/* Header EN DEHORS des sections - scrolle avec toute la page */}
        <Header isLoggedIn={isLoggedIn} onLogout={handleLogout} />

        {/* Slogan avec chorégraphie : Centré -> Frappe -> Décalage -> Reveal */}
        {!isLoggedIn && (
          <div className="w-full pt-2 pb-0 sm:py-4 flex items-center justify-center px-4 relative z-40">
            <h1 className={`text-2xl sm:text-5xl md:text-6xl lg:text-7xl font-bold text-foreground flex items-center justify-center ${isMobile ? "flex-row flex-wrap gap-2" : "flex-col"}`}>
              {/* "Des maths" avec curseur */}
              <span className="whitespace-nowrap flex items-center">
                {typedText}
                {!showSuffix && <span className="animate-pulse ml-1 text-blue-600 font-light">|</span>}
              </span>

              {/* "à ton niveau" - animation horizontale */}
              <span
                className={`
                  overflow-hidden whitespace-nowrap transition-all duration-[2000ms] ease-out inline-block
                  ${showSuffix ? "max-w-[200px] sm:max-w-[400px] md:max-w-[500px] lg:max-w-[600px] opacity-100" : "max-w-0 opacity-0"}
                `}
              >
                <span
                  style={{
                    background: "linear-gradient(to right, #22d3ee, #3b82f6)",
                    WebkitBackgroundClip: "text",
                    backgroundClip: "text",
                    WebkitTextFillColor: "transparent",
                    color: "transparent",
                  }}
                >
                  à ton niveau
                </span>
              </span>
            </h1>
          </div>
        )}

        {/* WRAPPER pour positionnement du rectangle relatif à la section accueil */}
        <div className="relative">
        
        {/* ===================================================================================== */}
        {/* FINAL RENDU : "STRUCTURED HALO GLASS" - RELIEF PAR BORDURE ET LUMIÈRE */}
        {/* Déplacé hors de la section accueil pour éviter le clip par overflow-hidden */}
        {/* ===================================================================================== */}
        {/* WIDGET MENU RAPIDE - Desktop: absolute à droite */}
        {!isLoggedIn && !isMobile && (
          <div className="absolute z-30 right-8 lg:right-16 top-[45%] -translate-y-1/2 w-[380px] lg:w-[450px] max-w-[40vw]">
            <div className="bg-white rounded-[32px] shadow-2xl border border-slate-100 overflow-hidden relative transform transition-all hover:scale-[1.01] duration-500">
              
              {/* Liste unifiée */}
              <div className="flex flex-col divide-y divide-slate-100">
                {/* LIGNE 1 : COMMENCER (Bleu) */}
                <Link to="/signup" className="relative py-10 px-8 flex items-center gap-6" style={{ backgroundColor: 'rgba(219, 234, 254, 0.4)' }}>
                  <div className="absolute left-0 top-0 bottom-0 w-2" style={{ backgroundColor: '#3b82f6' }} />
                  <div className="flex-shrink-0 w-20 h-20 rounded-2xl flex items-center justify-center scale-110" style={{ backgroundColor: '#dbeafe', color: '#2563eb' }}>
                    <Sparkles className="w-10 h-10" />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-bold text-2xl" style={{ color: '#1d4ed8' }}>Commencer</h3>
                    <p className="text-base text-muted-foreground font-medium mt-2">C'est hyper simple !</p>
                  </div>
                </Link>

                {/* LIGNE 2 : DISPONIBLE (Violet) */}
                <div className="relative py-10 px-8 cursor-default flex items-center gap-6" style={{ backgroundColor: 'rgba(243, 232, 255, 0.4)' }}>
                  <div className="absolute left-0 top-0 bottom-0 w-2" style={{ backgroundColor: '#a855f7' }} />
                  <div className="flex-shrink-0 w-20 h-20 rounded-2xl flex items-center justify-center scale-110" style={{ backgroundColor: '#f3e8ff', color: '#9333ea' }}>
                    <History className="w-10 h-10" />
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center gap-4">
                      <h3 className="font-bold text-2xl" style={{ color: '#7c3aed' }}>Disponible 24/7</h3>
                      <div className="flex items-center gap-2 px-3 py-1.5 rounded text-xs font-bold uppercase tracking-wide" style={{ backgroundColor: '#dcfce7', color: '#15803d' }}>
                        <span className="relative flex h-2.5 w-2.5">
                          <span className="animate-ping absolute inline-flex h-full w-full rounded-full opacity-75" style={{ backgroundColor: '#22c55e' }}></span>
                          <span className="relative inline-flex rounded-full h-2.5 w-2.5" style={{ backgroundColor: '#16a34a' }}></span>
                        </span>
                        En ligne
                      </div>
                    </div>
                    <p className="text-base text-muted-foreground font-medium mt-2">Support de 8h à 23h</p>
                  </div>
                </div>

                {/* LIGNE 3 : UN SITE POUR TOI (Rose) */}
                <Link to="/exercise" className="relative py-10 px-8 flex items-center gap-6" style={{ backgroundColor: 'rgba(252, 231, 243, 0.4)' }}>
                  <div className="absolute left-0 top-0 bottom-0 w-2" style={{ backgroundColor: '#ec4899' }} />
                  <div className="flex-shrink-0 w-20 h-20 rounded-2xl flex items-center justify-center scale-110" style={{ backgroundColor: '#fce7f3', color: '#db2777' }}>
                    <Target className="w-10 h-10" />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-bold text-2xl" style={{ color: '#be185d' }}>Un site pour toi</h3>
                    <p className="text-base text-muted-foreground font-medium mt-2">Contenu illimité</p>
                  </div>
                </Link>
              </div>
            </div>
          </div>
        )}

        {/* Section 1 - Accueil */}
        <section
          id="accueil"
          className={`
            relative w-full
            ${isMobile 
              ? "min-h-[calc(100svh-80px)] flex flex-col"
              : isLoggedIn
                ? "h-[calc(100vh-120px)]"
                : "h-[calc(100vh-260px)]"
            }
            overflow-hidden
          `}
        >
          {/* Zone principale avec GeometricBackground */}
          <GeometricBackground
            className={`w-full ${isMobile ? 'flex-1' : 'h-full'} flex items-center justify-center overflow-hidden`}
            onContactClick={() => setShowContactModal(true)}
          >
            {/* Contenu centré */}
            <div className={`text-center px-4 max-w-5xl mx-auto w-full ${isMobile ? '' : '-translate-y-8 md:-translate-y-4'}`}>
              {isLoggedIn && userFirstName && (
                <h2 className="text-4xl sm:text-5xl md:text-6xl lg:text-7xl font-bold text-foreground mb-4 md:mb-6">
                  Salut {userFirstName} !
                </h2>
              )}
              {isLoggedIn ? (
                <div className="w-full max-w-5xl mx-auto flex flex-col gap-4 md:gap-4 px-4">
                  {/* Rectangle de verre 1 : Cours & Exercices */}
                  <section 
                    className="rounded-[30px] p-4 md:p-6 bg-white/40 backdrop-blur-[5px] border border-white/50"
                    style={{
                      boxShadow: "0 25px 50px -12px rgba(59, 130, 246, 0.25), 0 8px 20px -8px rgba(0, 0, 0, 0.1)"
                    }}
                  >
                    <div className="grid grid-cols-2 gap-3 md:gap-6 max-w-4xl mx-auto">
                      {/* Bouton Cours */}
                      <Link to="/cours">
                        <div
                          className="group relative px-3 py-3 md:px-8 md:py-5 rounded-[16px] md:rounded-[24px] cursor-pointer transition-all duration-300 hover:scale-[1.02] hover:-translate-y-0.5 shadow-md hover:shadow-blue-500/20"
                          style={{
                            background: "linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)",
                            boxShadow: "inset 0 3px 8px rgba(255,255,255,0.4), inset 0 -3px 8px rgba(0,0,0,0.1)",
                          }}
                        >
                          <div className="flex items-center justify-center gap-2 md:gap-4">
                            <div className="bg-white/20 p-2 md:p-3 rounded-lg md:rounded-xl backdrop-blur-sm shadow-inner">
                              <BookOpen className="w-5 h-5 md:w-7 md:h-7 text-white drop-shadow-md" />
                            </div>
                            <div className="text-left text-white">
                              <span className="block font-bold text-sm md:text-2xl leading-none mb-0.5 md:mb-1 drop-shadow-md">
                                Explications
                              </span>
                              <span className="text-xs md:text-base opacity-90 font-medium">De cours</span>
                            </div>
                          </div>
                        </div>
                      </Link>
                      {/* Bouton Exercices */}
                      <Link to="/exercise">
                        <div
                          className="group relative px-3 py-3 md:px-8 md:py-5 rounded-[16px] md:rounded-[24px] cursor-pointer transition-all duration-300 hover:scale-[1.02] hover:-translate-y-0.5 shadow-md hover:shadow-pink-500/20"
                          style={{
                            background: "linear-gradient(135deg, #ec4899 0%, #a855f7 100%)",
                            boxShadow: "inset 0 3px 8px rgba(255,255,255,0.4), inset 0 -3px 8px rgba(0,0,0,0.1)",
                          }}
                        >
                          <div className="flex items-center justify-center gap-2 md:gap-4">
                            <div className="bg-white/20 p-2 md:p-3 rounded-lg md:rounded-xl backdrop-blur-sm shadow-inner">
                              <Calculator className="w-5 h-5 md:w-7 md:h-7 text-white drop-shadow-md" />
                            </div>
                            <div className="text-left text-white">
                              <span className="block font-bold text-sm md:text-2xl leading-none mb-0.5 md:mb-1 drop-shadow-md">
                                Commencer
                              </span>
                              <span className="text-xs md:text-base opacity-90 font-medium">Mes exercices</span>
                            </div>
                          </div>
                        </div>
                      </Link>
                    </div>
                  </section>

                  {/* Rectangle de verre 2 : Historique & Compétences */}
                  <section className="rounded-[30px] p-4 md:p-4 bg-white/40 backdrop-blur-[5px] border border-white/50 shadow-xl shadow-blue-900/5">
                    <div className="grid grid-cols-2 gap-3 md:gap-6 max-w-4xl mx-auto">
                      {/* Carte Historique */}
                      <Link to="/historique" className="group h-full">
                        <div
                          className="h-full rounded-[20px] md:rounded-[28px] p-[2px] md:p-[3px] shadow-md hover:shadow-lg transition-all duration-300 hover:-translate-y-0.5"
                          style={{ background: "linear-gradient(to bottom, #93c5fd, #2563eb)" }}
                        >
                          <div className="h-full bg-white rounded-[18px] md:rounded-[25px] p-3 md:p-4 flex flex-col items-center text-center relative overflow-hidden">
                            <div className="absolute top-0 inset-x-0 h-16 bg-gradient-to-b from-blue-50 to-transparent opacity-60"></div>
                            <div className="relative z-10 w-full flex flex-col items-center h-full">
                              <div className="w-10 h-10 md:w-14 md:h-14 bg-blue-100 text-blue-600 rounded-lg md:rounded-xl flex items-center justify-center mb-2 md:mb-3 group-hover:scale-110 transition-transform shadow-sm">
                                <History className="w-5 h-5 md:w-7 md:h-7" />
                              </div>
                              <h3 className="text-sm md:text-xl font-bold text-slate-800 mb-0.5 md:mb-1">Historique</h3>
                              <p className="text-slate-500 text-[10px] md:text-sm mb-2 md:mb-4 leading-relaxed hidden md:block">
                                Retrouve tes anciennes conversations.
                              </p>
                              <div className="mt-auto w-full py-1.5 md:py-2.5 rounded-lg bg-blue-50 text-blue-600 font-bold text-xs md:text-sm group-hover:bg-blue-600 group-hover:text-white transition-all">
                                Consulter
                              </div>
                            </div>
                          </div>
                        </div>
                      </Link>
                      {/* Carte Compétences */}
                      <Link to="/competences" className="group h-full">
                        <div
                          className="h-full rounded-[20px] md:rounded-[28px] shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-[1.01]"
                          style={{
                            background: "linear-gradient(135deg, #ec4899 0%, #a855f7 100%)",
                            padding: "2px",
                          }}
                        >
                          <div className="h-full bg-white rounded-[18px] md:rounded-[25px] p-3 md:p-4 flex flex-col items-center text-center relative overflow-hidden">
                            <div
                              className="absolute top-0 inset-x-0 h-16"
                              style={{ background: "linear-gradient(to bottom, rgba(253,242,248,0.6), transparent)" }}
                            ></div>
                            <div className="relative z-10 w-full flex flex-col items-center h-full">
                              <div
                                style={{ backgroundColor: "#fdf2f8", borderColor: "#fbcfe8" }}
                                className="w-10 h-10 md:w-14 md:h-14 rounded-lg md:rounded-xl flex items-center justify-center mb-2 md:mb-3 group-hover:rotate-6 transition-transform shadow-sm border"
                              >
                                <Target className="w-5 h-5 md:w-7 md:h-7" style={{ color: "#be185d" }} />
                              </div>
                              <h3 className="text-sm md:text-xl font-extrabold text-slate-900 mb-0.5 md:mb-1">Compétences</h3>
                              <p className="text-slate-500 text-[10px] md:text-sm mb-2 md:mb-4 leading-relaxed hidden md:block">
                                Visualise ta progression par chapitre.
                              </p>
                              <div
                                className="mt-auto w-full py-1.5 md:py-2.5 rounded-lg text-white font-bold text-xs md:text-sm shadow-md hover:shadow-lg transform transition-all"
                                style={{ background: "linear-gradient(135deg, #ec4899 0%, #a855f7 100%)" }}
                              >
                                Voir
                              </div>
                            </div>
                          </div>
                        </div>
                      </Link>
                    </div>
                  </section>

                  {/* Bouton Inviter parents */}
                  {!hasParents && (
                    <button
                      onClick={() => setShowInviteDialog(true)}
                      className="mx-auto px-4 py-3 md:px-8 md:py-3 rounded-full border-2 border-dashed border-slate-400 hover:border-slate-500 transition-all cursor-pointer flex items-center gap-2 md:gap-3 backdrop-blur-md bg-white/80 shadow-lg"
                    >
                      <div className="p-1.5 md:p-2 rounded-full bg-slate-500">
                        <Users className="w-4 h-4 md:w-5 md:h-5 text-white" />
                      </div>
                      <span className="font-bold text-slate-600 text-sm md:text-base">Inviter tes parents</span>
                    </button>
                  )}
                </div>
              ) : isMobile ? (
                /* VERSION MOBILE : Bouton CTA en haut + Cartes en dessous */
                <div className="flex flex-col items-center justify-start gap-2 px-4 py-0 w-full h-full">
                  {/* Bouton CTA EN PREMIER - sur fond blanc/clair */}
                  <Link to="/login" className="group relative">
                    <div 
                      className="absolute bg-gradient-to-r from-orange-300 via-orange-400 to-amber-400 rounded-full blur-2xl opacity-40 group-hover:opacity-60 transition-opacity duration-500 -inset-2"
                    ></div>
                    <div
                      className="relative flex items-center rounded-full transition-all duration-300 transform group-hover:scale-[1.02] group-hover:-translate-y-1 overflow-hidden gap-2 px-4 py-2"
                      style={{
                        background: "linear-gradient(135deg, #fb923c, #f59e0b)",
                        boxShadow: "inset 0 2px 4px rgba(255,255,255,0.4), 0 15px 30px -5px rgba(251, 146, 60, 0.5)"
                      }}
                    >
                      <div className="absolute top-0 left-0 right-0 h-1/2 bg-gradient-to-b from-white/30 to-transparent rounded-t-full pointer-events-none" />
                      <div className="flex flex-col items-start text-left relative z-10">
                        <span className="font-black text-white tracking-tight leading-none drop-shadow-sm text-base">
                          C'EST PARTI !
                        </span>
                        <span className="text-white/90 font-bold uppercase tracking-widest text-[8px] mt-0.5">
                          Connexion immédiate
                        </span>
                      </div>
                      <div className="bg-white/30 relative z-10 h-5 w-px"></div>
                      <div className="flex items-center justify-center text-white group-hover:translate-x-1 transition-transform duration-300 relative z-10">
                        <ArrowRight className="w-4 h-4" strokeWidth={3} />
                      </div>
                    </div>
                  </Link>

                  {/* 3 cartes EN DESSOUS */}
                  <div 
                    className="w-full max-w-[340px] py-4 px-3 rounded-[24px]"
                    style={{
                      background: "rgba(255, 255, 255, 0.6)",
                      backdropFilter: "blur(12px)",
                      border: "2px solid rgba(255, 255, 255, 0.5)",
                      boxShadow: "0 30px 70px -15px rgba(0, 0, 0, 0.25), 0 10px 30px -10px rgba(0, 0, 0, 0.1)"
                    }}
                  >
                  {/* --- DEBUT WIDGET UNIFIÉ --- */}
                  <div className="bg-white rounded-[20px] shadow-2xl border border-slate-100 overflow-hidden relative transform transition-all hover:scale-[1.01] duration-500">
                    
                    {/* Liste unifiée */}
                    <div className="flex flex-col divide-y divide-slate-100">
                      {/* LIGNE 1 : COMMENCER (Bleu) */}
                      <Link to="/signup" className="relative py-6 px-5 flex items-center gap-4" style={{ backgroundColor: 'rgba(219, 234, 254, 0.4)' }}>
                        <div className="absolute left-0 top-0 bottom-0 w-1.5" style={{ backgroundColor: '#3b82f6' }} />
                        <div className="flex-shrink-0 w-14 h-14 rounded-xl flex items-center justify-center" style={{ backgroundColor: '#dbeafe', color: '#2563eb' }}>
                          <Sparkles className="w-7 h-7" />
                        </div>
                        <div className="flex-1">
                          <h3 className="font-bold text-lg" style={{ color: '#1d4ed8' }}>Commencer</h3>
                          <p className="text-sm text-muted-foreground font-medium mt-1">C'est hyper simple !</p>
                        </div>
                      </Link>

                      {/* LIGNE 2 : DISPONIBLE (Violet) */}
                      <div className="relative py-6 px-5 cursor-default flex items-center gap-4" style={{ backgroundColor: 'rgba(243, 232, 255, 0.4)' }}>
                        <div className="absolute left-0 top-0 bottom-0 w-1.5" style={{ backgroundColor: '#a855f7' }} />
                        {/* Badge EN LIGNE positionné en haut à droite */}
                        <div className="absolute top-2 right-3 flex items-center gap-1 px-1.5 py-0.5 rounded text-[8px] font-bold uppercase tracking-wide" style={{ backgroundColor: '#dcfce7', color: '#15803d' }}>
                          <span className="relative flex h-1.5 w-1.5">
                            <span className="animate-ping absolute inline-flex h-full w-full rounded-full opacity-75" style={{ backgroundColor: '#22c55e' }}></span>
                            <span className="relative inline-flex rounded-full h-1.5 w-1.5" style={{ backgroundColor: '#16a34a' }}></span>
                          </span>
                          En ligne
                        </div>
                        <div className="flex-shrink-0 w-14 h-14 rounded-xl flex items-center justify-center" style={{ backgroundColor: '#f3e8ff', color: '#9333ea' }}>
                          <History className="w-7 h-7" />
                        </div>
                        <div className="flex-1">
                          <h3 className="font-bold text-lg" style={{ color: '#7c3aed' }}>Disponible 24/7</h3>
                          <p className="text-sm text-muted-foreground font-medium mt-1">Support de 8h à 23h</p>
                        </div>
                      </div>

                      {/* LIGNE 3 : UN SITE POUR TOI (Rose) */}
                      <Link to="/exercise" className="relative py-6 px-5 flex items-center gap-4" style={{ backgroundColor: 'rgba(252, 231, 243, 0.4)' }}>
                        <div className="absolute left-0 top-0 bottom-0 w-1.5" style={{ backgroundColor: '#ec4899' }} />
                        <div className="flex-shrink-0 w-14 h-14 rounded-xl flex items-center justify-center" style={{ backgroundColor: '#fce7f3', color: '#db2777' }}>
                          <Target className="w-7 h-7" />
                        </div>
                        <div className="flex-1">
                          <h3 className="font-bold text-lg" style={{ color: '#be185d' }}>Un site pour toi</h3>
                          <p className="text-sm text-muted-foreground font-medium mt-1">Contenu illimité</p>
                        </div>
                      </Link>
                    </div>
                  </div>
                  {/* --- FIN WIDGET --- */}
                  </div>
                </div>
              ) : (
                /* VERSION DESKTOP : Bouton CTA "C'EST PARTI !" uniquement */
                <div className="flex flex-col items-center gap-8 relative z-10 mt-4 mb-12">
                  <Link to="/login" className="group relative">
                    <div 
                      className="absolute bg-gradient-to-r from-orange-300 via-orange-400 to-amber-400 rounded-full blur-2xl opacity-40 group-hover:opacity-60 transition-opacity duration-500 -inset-3"
                    ></div>
                    <div
                      className="relative flex items-center rounded-full transition-all duration-300 transform group-hover:scale-[1.02] group-hover:-translate-y-1 overflow-hidden gap-6 px-12 py-6"
                      style={{
                        background: "linear-gradient(135deg, #fb923c, #f59e0b)",
                        boxShadow: "inset 0 2px 4px rgba(255,255,255,0.4), 0 15px 30px -5px rgba(251, 146, 60, 0.5)"
                      }}
                    >
                      <div className="absolute top-0 left-0 right-0 h-1/2 bg-gradient-to-b from-white/30 to-transparent rounded-t-full pointer-events-none" />
                      <div className="flex flex-col items-start text-left relative z-10">
                        <span className="font-black text-white tracking-tight leading-none drop-shadow-sm text-3xl">
                          C'EST PARTI !
                        </span>
                        <span className="text-white/90 font-bold uppercase tracking-widest text-sm mt-1.5">
                          Connexion immédiate
                        </span>
                      </div>
                      <div className="bg-white/30 relative z-10 h-10 w-px"></div>
                      <div className="flex items-center justify-center text-white group-hover:translate-x-1 transition-transform duration-300 relative z-10">
                        <ArrowRight className="w-8 h-8" strokeWidth={3} />
                      </div>
                    </div>
                  </Link>
                </div>
              )}
            </div>
          </GeometricBackground>


          {/* Indicateur de Scroll (Apparaît après 5s) - SEULEMENT en mode déconnecté */}
          {showScrollHint && !isLoggedIn && !isMobile && (
            <div 
              className="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-2 cursor-pointer transition-opacity duration-1000 animate-in fade-in zoom-in"
              onClick={() => {
                setShowScrollHint(false);
                document.getElementById('presentation')?.scrollIntoView({ behavior: 'smooth' });
              }}
            >
              {/* Conteneur qui rebondit */}
              <div className="flex flex-col items-center gap-2 sm:gap-3 animate-bounce">
                <span className={`font-bold text-slate-500 uppercase tracking-widest ${isMobile ? 'text-xs' : 'text-lg sm:text-2xl'}`}>
                  Découvre Siimply
                </span>
                
                <div className={`rounded-full bg-white/30 backdrop-blur-md border border-white/40 shadow-sm text-primary ${isMobile ? 'p-2' : 'p-3 sm:p-4'}`}>
                  <ArrowDown className={isMobile ? 'w-5 h-5' : 'w-8 h-8 sm:w-12 sm:h-12'} />
                </div>
              </div>
            </div>
          )}
        </section>
        </div>
        {/* FIN DU WRAPPER pour positionnement rectangle */}

        {/* Section 2 - Présentation (uniquement pour déconnectés) */}
        {!isLoggedIn && (
          <>
            {/* Section Présentation - pour déconnectés - NOUVELLE VERSION */}
            <section id="presentation" className="bg-background overflow-hidden">
              {/* 1. NOUVELLE SECTION PRÉSENTATION - STYLE "SLIDE" ÉTALÉ */}
              <div className="relative py-12 lg:py-16">
                {/* Fond global très léger */}
                <div className="absolute inset-0 bg-gradient-to-b from-white via-blue-50/20 to-white pointer-events-none" />
                <div className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-12 relative z-10">
                  
                  {/* En-tête de section */}
                  <div className="text-center max-w-3xl mx-auto mb-12 lg:mb-16">
                    <h2 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold text-slate-900 tracking-tight leading-tight">
                      Un outil puissant,<br/>
                      <span style={{
                        background: 'linear-gradient(to right, #2563eb, #06b6d4)',
                        WebkitBackgroundClip: 'text',
                        WebkitTextFillColor: 'transparent',
                        backgroundClip: 'text',
                        color: 'transparent'
                      }}>
                        simple à utiliser.
                      </span>
                    </h2>
                  </div>

                  {/* LIGNE 1 : TEXTE (Gauche) / IMAGE (Droite) */}
                  <div className="grid lg:grid-cols-2 gap-12 lg:gap-24 items-center mb-20 lg:mb-32">
                    
                    {/* COLONNE TEXTE (Gauche sur Desktop, 2ème sur Mobile) */}
                    <div className="order-2 lg:order-1 flex flex-col justify-center">
                    <h3 className="text-3xl sm:text-4xl lg:text-5xl font-bold text-slate-900 mb-6">
                        Ton parcours s'ajuste <br/>
                        <span style={{
                          background: 'linear-gradient(to right, #2563eb, #06b6d4)',
                          WebkitBackgroundClip: 'text',
                          WebkitTextFillColor: 'transparent',
                          backgroundClip: 'text',
                          color: 'transparent'
                        }}>
                          en temps réel.
                        </span>
                      </h3>
                      <p className="text-lg lg:text-2xl text-slate-600 mb-8 lg:mb-10 leading-relaxed">
                        Siimply analyse chacune de tes réponses pour détecter tes points forts et tes lacunes. Le contenu évolue en permanence.
                      </p>
                      
                      {/* Liste avec puces Bleues et Mots-clés en gras */}
                      <ul className="space-y-6 lg:space-y-7">
                        <li className="flex items-start gap-4">
                          <div className="mt-1 p-1 rounded-full" style={{ backgroundColor: '#ecfeff', color: '#0891b2' }}><Check className="w-4 h-4 lg:w-5 lg:h-5" strokeWidth={3} /></div>
                          <span className="text-lg lg:text-2xl text-slate-600">
                            Compréhension précise de <span className="font-bold text-slate-900">ton niveau réel</span>.
                          </span>
                        </li>
                        <li className="flex items-start gap-4">
                          <div className="mt-1 p-1 rounded-full" style={{ backgroundColor: '#ecfeff', color: '#0891b2' }}><Check className="w-4 h-4 lg:w-5 lg:h-5" strokeWidth={3} /></div>
                          <span className="text-lg lg:text-2xl text-slate-600">
                            Une aide qui cible <span className="font-bold text-slate-900">précisément tes besoins</span>.
                          </span>
                        </li>
                        <li className="flex items-start gap-4">
                          <div className="mt-1 p-1 rounded-full" style={{ backgroundColor: '#ecfeff', color: '#0891b2' }}><Check className="w-4 h-4 lg:w-5 lg:h-5" strokeWidth={3} /></div>
                          <span className="text-lg lg:text-2xl text-slate-600">
                            Visualise ton <span className="font-bold text-slate-900">évolution</span> instantanément.
                          </span>
                        </li>
                      </ul>
                    </div>

                    {/* COLONNE IMAGE (Droite sur Desktop, 1ère sur Mobile) */}
                    <div className="order-1 lg:order-2 relative">
                      <div 
                        className="rounded-3xl overflow-hidden shadow-2xl border border-slate-100 bg-white p-3 lg:p-4 cursor-pointer"
                        onClick={() => setSelectedImage("/images/dashboard-preview.png")}
                      >
                        <img 
                          src="/images/dashboard-preview.png" 
                          alt="Tableau de bord" 
                          className="w-full max-h-[280px] lg:max-h-[650px] object-contain transform hover:scale-[1.02] transition-transform duration-500"
                        />
                      </div>
                      {/* Ombre portée décorative */}
                      <div className="absolute -inset-4 rounded-[2rem] -z-10 blur-xl" style={{ backgroundColor: 'rgba(59, 130, 246, 0.1)' }} />
                    </div>
                  </div>

                  {/* LIGNE 2 : IMAGE (Gauche) / TEXTE (Droite) */}
                  <div className="grid lg:grid-cols-2 gap-12 lg:gap-24 items-center">
                    
                    {/* COLONNE IMAGE (Gauche sur Desktop, 1ère sur Mobile) */}
                    <div className="order-1 lg:order-1 relative">
                      <div 
                        className="rounded-3xl overflow-hidden shadow-2xl border border-slate-100 bg-white p-3 lg:p-4 cursor-pointer"
                        onClick={() => setSelectedImage("/images/exercice-preview2.png")}
                      >
                        <img 
                          src="/images/exercice-preview2.png" 
                          alt="Exercice avec assistance"
                          className="w-full max-h-[280px] lg:max-h-[550px] object-contain transform hover:scale-[1.02] transition-transform duration-500" 
                        />
                      </div>
                      <div className="absolute -inset-4 rounded-[2rem] -z-10 blur-xl" style={{ backgroundColor: 'rgba(168, 85, 247, 0.1)' }} />
                    </div>

                    {/* COLONNE TEXTE (Droite sur Desktop, 2ème sur Mobile) */}
                    <div className="order-2 lg:order-2 flex flex-col justify-center">
                      <h3 className="text-3xl sm:text-4xl lg:text-5xl font-bold text-slate-900 mb-6">
                        Siimply te guide <br/>
                        <span style={{ color: '#9333ea' }}>
                          dans ta progression.
                        </span>
                      </h3>
                      <p className="text-lg lg:text-2xl text-slate-600 mb-8 lg:mb-10 leading-relaxed">
                        Besoin d'éclaircir le cours ? Besoin d'exercices pertinents ? L'assistant prend tout en compte pour t'aider.
                      </p>
                      
                      {/* Liste avec puces Violettes */}
                      <ul className="space-y-6 lg:space-y-7">
                        <li className="flex items-start gap-4">
                          <div className="mt-1 p-1 rounded-full" style={{ backgroundColor: '#faf5ff', color: '#9333ea' }}><Check className="w-4 h-4 lg:w-5 lg:h-5" strokeWidth={3} /></div>
                          <span className="text-lg lg:text-2xl text-muted-foreground">
                            Humeur & objectifs : <span className="font-bold text-foreground">tout est pris en compte</span>.
                          </span>
                        </li>
                        <li className="flex items-start gap-4">
                          <div className="mt-1 p-1 rounded-full" style={{ backgroundColor: '#faf5ff', color: '#9333ea' }}><Check className="w-4 h-4 lg:w-5 lg:h-5" strokeWidth={3} /></div>
                          <span className="text-lg lg:text-2xl text-muted-foreground">
                            T'explique la méthode <span className="font-bold text-foreground">pas à pas, sans juger</span>.
                          </span>
                        </li>
                        <li className="flex items-start gap-4">
                          <div className="mt-1 p-1 rounded-full" style={{ backgroundColor: '#faf5ff', color: '#9333ea' }}><Check className="w-4 h-4 lg:w-5 lg:h-5" strokeWidth={3} /></div>
                          <span className="text-lg lg:text-2xl text-muted-foreground">
                            Dispo 24/7, avec un support de <span className="font-bold text-foreground">8h à 23h</span>.
                          </span>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>


              {/* 2. SECTION COMPETENCES : La grosse valeur ajoutée */}
              <div className="relative py-20 lg:py-32 bg-muted/30">
                {/* Formes géométriques décoratives */}
                <div className="absolute top-20 left-10 w-72 h-72 bg-cyan-500/5 rounded-full blur-3xl" />
                <div className="absolute bottom-20 right-10 w-96 h-96 bg-teal-500/5 rounded-full blur-3xl" />

                <div className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-12 relative z-10">
                  <div className="grid lg:grid-cols-2 gap-12 lg:gap-24 items-center">
                    {/* Texte à Gauche */}
                    <div className="lg:order-1 flex flex-col justify-center">
                      <div
                        className="inline-flex items-center justify-center w-14 h-14 rounded-xl mb-6"
                        style={{ backgroundColor: "rgba(34, 211, 238, 0.15)" }}
                      >
                        <Target className="w-7 h-7" style={{ color: "#0891b2" }} />
                      </div>

                      <h3 className="text-3xl sm:text-4xl lg:text-5xl font-bold text-foreground mb-6">
                        Ne travaille plus au hasard.
                        <br />
                        <span style={{ 
                          background: 'linear-gradient(to right, #f97316, #ec4899)',
                          WebkitBackgroundClip: 'text',
                          WebkitTextFillColor: 'transparent',
                          backgroundClip: 'text'
                        }}>Siimply cible ce qu'il faut travailler.</span>
                      </h3>

                      <p className="text-lg lg:text-2xl text-muted-foreground mb-8 lg:mb-10 leading-relaxed">
                        Comment cibler tes problèmes ? Fais confiance à Siimply pour identifier les axes de travail et atteindre tes objectifs.
                      </p>

                      <ul className="space-y-6 lg:space-y-7">
                        <li className="flex items-start gap-4">
                          <div className="mt-1 p-1 rounded-full" style={{ backgroundColor: '#ffedd5', color: '#ea580c' }}>
                            <Check className="w-4 h-4 lg:w-5 lg:h-5" strokeWidth={3} />
                          </div>
                          <span className="text-lg lg:text-2xl text-muted-foreground">Compétences par <span className="font-bold text-foreground">chapitres</span> et <span className="font-bold text-foreground">sous-notions</span></span>
                        </li>
                        <li className="flex items-start gap-4">
                          <div className="mt-1 p-1 rounded-full" style={{ backgroundColor: '#ffedd5', color: '#ea580c' }}>
                            <Check className="w-4 h-4 lg:w-5 lg:h-5" strokeWidth={3} />
                          </div>
                          <span className="text-lg lg:text-2xl text-muted-foreground"><span className="font-bold text-foreground">Identification précise</span> des chapitres à revoir</span>
                        </li>
                        <li className="flex items-start gap-4">
                          <div className="mt-1 p-1 rounded-full" style={{ backgroundColor: '#ffedd5', color: '#ea580c' }}>
                            <Check className="w-4 h-4 lg:w-5 lg:h-5" strokeWidth={3} />
                          </div>
                          <span className="text-lg lg:text-2xl text-muted-foreground">Mise à jour <span className="font-bold text-foreground">en temps réel</span> après chaque exercice</span>
                        </li>
                      </ul>
                    </div>

                    {/* COLONNE DROITE : IMAGES */}
                    <div className="lg:order-2 relative">
                      {/* Fond lumineux */}
                      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-gradient-to-r from-cyan-500/10 to-teal-500/10 rounded-full blur-3xl -z-10" />

                      {/* Mobile: images chevauchées cliquables */}
                      <div className="relative h-[350px] lg:hidden">
                        {/* Carte 1 - Radar */}
                        <div 
                          onClick={() => setSelectedImage("/images/radarcompetences.png")}
                          className="absolute top-0 left-0 w-[80%] h-[180px] bg-white rounded-2xl shadow-xl border border-slate-200 overflow-hidden cursor-pointer hover:scale-[1.02] transition-transform z-10"
                        >
                          <img src="/images/radarcompetences.png" alt="Radar des compétences" className="w-full h-full object-cover" />
                        </div>
                        
                        {/* Carte 2 - Compétences */}
                        <div 
                          onClick={() => setSelectedImage("/images/competences-preview-2.png")}
                          className="absolute bottom-0 right-0 w-[80%] h-[180px] bg-white rounded-2xl shadow-2xl border border-slate-200 overflow-hidden cursor-pointer hover:scale-[1.02] transition-transform z-20"
                        >
                          <img src="/images/competences-preview-2.png" alt="Aperçu des compétences" className="w-full h-full object-contain bg-white" />
                        </div>
                      </div>

                      {/* Desktop: version avec positions absolues */}
                      <div className="hidden lg:block relative h-[550px] sm:h-[620px]">
                        {/* CARTE 1 - LE RADAR */}
                        <div 
                          className="absolute top-[-75px] left-[-50px] w-[95%] h-[300px] sm:h-[360px] bg-white rounded-2xl shadow-2xl border border-slate-200 z-10 overflow-hidden hover:z-30 hover:scale-[1.02] transition-all duration-300 cursor-pointer"
                          onClick={() => setSelectedImage("/images/radarcompetences.png")}
                        >
                          <img src="/images/radarcompetences.png" alt="Radar des compétences" className="w-full h-full object-cover object-center" />
                        </div>

                        {/* CARTE 2 - L'IMAGE */}
                        <div 
                          className="absolute bottom-[-40px] right-0 w-[95%] h-[330px] sm:h-[390px] bg-white rounded-2xl shadow-[0_30px_60px_-10px_rgba(0,0,0,0.2)] border border-slate-200 z-20 overflow-hidden hover:scale-[1.02] transition-all duration-300 cursor-pointer"
                          onClick={() => setSelectedImage("/images/competences-preview-2.png")}
                        >
                          <img src="/images/competences-preview-2.png" alt="Aperçu des compétences Siimply" className="w-full h-full object-contain object-center bg-white" />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

            </section>

            {/* ===================================================================================== */}
            {/* TRANSITION IA - BANDEAU "FULL WIDTH" COMPACT */}
            {/* ===================================================================================== */}
            <section className="py-12 bg-slate-50 border-y border-slate-100">
              <div className="max-w-4xl mx-auto px-4 text-center">
                
                <div className="flex flex-col items-center justify-center">
                  {/* Le Texte (Centré, sans icône) */}
                  <div className="text-center">
                    <h3 className="text-4xl md:text-5xl font-bold text-slate-900 mb-4">
                      Et l'IA dans tout ça ?
                    </h3>
                    <p className="text-slate-600 leading-relaxed text-lg md:text-xl">
                      C'est juste un outil de lecture et de vérification. La stratégie pour te faire progresser a été <span className="inline-block bg-gradient-to-r from-blue-100 via-indigo-100 to-purple-100 text-indigo-700 font-bold px-3 py-1 rounded-md mx-1">pensée par des experts pédagogiques</span>.
                    </p>
                  </div>
                </div>
              </div>
            </section>

            {/* ===================================================================================== */}
            {/* 2. SECTION OFFRE (Fond Blanc pour le contraste) */}
            {/* ===================================================================================== */}
            <section id="offre" className="py-24 bg-white relative">
              <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
                
                {/* TITRE + PHRASE CHOC "PULSE" */}
                <div className="text-center max-w-4xl mx-auto mb-20">
                  <h2 className="text-5xl md:text-6xl font-black text-slate-900 mb-8 tracking-tight">
                    Choisis ton abonnement.
                  </h2>
                  {/* LA PHRASE MAGIQUE (Simple, centrée, animée) */}
                  <div className="inline-flex items-center gap-3 bg-green-50 border border-green-100 rounded-full px-6 py-3 shadow-sm hover:shadow-md transition-all cursor-default group">
                    {/* Le point qui pulse */}
                    <span className="relative flex h-3 w-3">
                      <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
                      <span className="relative inline-flex rounded-full h-3 w-3 bg-green-500"></span>
                    </span>
                    
                    <p className="text-green-800 font-medium text-lg">
                      <span className="font-bold">1 mois OFFERT</span> sans engagement • Aucune CB requise
                    </p>
                  </div>
                </div>

                {/* GRILLE DES CARTES DE PRIX */}
                <div className="grid md:grid-cols-2 gap-8 max-w-5xl mx-auto items-stretch">
                  
                  {/* --- OFFRE 1 : AUTONOMIE (9,99€) - DESIGN REHAUSSÉ (Bleu/Cyan) --- */}
                  <div className="relative bg-white rounded-[2rem] border-2 border-cyan-300 p-8 shadow-lg hover:shadow-2xl hover:border-cyan-400 transition-all group flex flex-col">
                    <h3 className="text-2xl font-bold text-slate-900 mb-2">Siimply Autonomie</h3>
                    <p className="text-slate-500 text-sm mb-6 h-10">L'essentiel pour atteindre tes objectifs.</p>
                    {/* Prix en Dégradé Bleu Roi → Bleu Ciel */}
                    <div className="flex items-baseline gap-1 mb-6">
                      <span className="text-5xl font-extrabold" style={{ color: '#1d4ed8' }}>9,99€</span>
                      <span className="text-slate-500 font-medium">/mois</span>
                    </div>
                    {/* Liste - Puces colorées en Bleu */}
                    <ul className="space-y-4 mb-8 flex-grow">
                      <li className="flex items-start gap-3">
                        <div className="mt-0.5 p-1 rounded-full" style={{ backgroundColor: '#ecfeff', color: '#0891b2' }}><Check className="w-3.5 h-3.5" strokeWidth={3} /></div>
                        <span className="text-slate-700 font-medium">Cours & Exercices illimités</span>
                      </li>
                      <li className="flex items-start gap-3">
                        <div className="mt-0.5 p-1 rounded-full" style={{ backgroundColor: '#ecfeff', color: '#0891b2' }}><Check className="w-3.5 h-3.5" strokeWidth={3} /></div>
                        <span className="text-slate-700 font-medium">Disponible 24/7</span>
                      </li>
                      <li className="flex items-start gap-3">
                        <div className="mt-0.5 p-1 rounded-full" style={{ backgroundColor: '#ecfeff', color: '#0891b2' }}><Check className="w-3.5 h-3.5" strokeWidth={3} /></div>
                        <span className="text-slate-700 font-medium">Parcours adaptatif intelligent</span>
                      </li>
                      <li className="flex items-start gap-3">
                        <div className="mt-0.5 p-1 rounded-full" style={{ backgroundColor: '#ecfeff', color: '#0891b2' }}><Check className="w-3.5 h-3.5" strokeWidth={3} /></div>
                        <span className="text-slate-700 font-medium">Suivi progression élève & parent</span>
                      </li>
                    </ul>
                    <Link to="/signup?plan=autonomie" className="block">
                      {/* Bouton Dégradé Bleu Roi → Bleu Ciel */}
                      <Button className="w-full bg-gradient-to-r from-blue-700 to-sky-400 hover:from-blue-800 hover:to-sky-500 text-white font-bold rounded-xl py-6 shadow-md hover:shadow-blue-200 transition-all">
                        Pack autonomie
                      </Button>
                    </Link>
                  </div>
                  {/* --- OFFRE 2 : SUIVI + (29,99€) - DESIGN PREMIUM (Violet/Rose) --- */}
                  <div className="relative bg-white rounded-[2rem] border-2 border-purple-300 p-8 shadow-xl hover:border-purple-400 hover:shadow-2xl transition-all flex flex-col">
                    {/* Badge Recommandé */}
                    <div className="absolute -top-4 left-1/2 -translate-x-1/2 bg-gradient-to-r from-purple-600 to-pink-500 text-white text-xs font-bold px-4 py-1.5 rounded-full shadow-lg tracking-wide uppercase whitespace-nowrap">
                      recommandé pour les parents
                    </div>
                    <h3 className="text-2xl font-bold text-slate-900 mb-2">Siimply Suivi +</h3>
                    <p className="text-slate-500 text-sm mb-6 h-10">L'alliance de la technologie et d'un coach humain dédié.</p>
                    {/* Prix en Dégradé Violet */}
                    <div className="flex items-baseline gap-1 mb-6">
                      <span className="text-5xl font-extrabold" style={{ color: '#9333ea' }}>14,99€</span>
                      <span className="text-slate-500 font-medium">/mois</span>
                    </div>
                    {/* Liste */}
                    <ul className="space-y-4 mb-8 flex-grow">
                      {/* Ligne "Tout le pack" */}
                      <li className="flex items-start gap-3">
                        <div className="mt-0.5 p-1 rounded-full" style={{ backgroundColor: '#ecfeff', color: '#0891b2' }}><Check className="w-3.5 h-3.5" strokeWidth={3} /></div>
                        <span className="text-blue-600 font-medium text-sm">Tout le pack Autonomie</span>
                      </li>
                      
                      {/* FOCUS : Les lignes Premium en Gras/Surbrillance */}
                      <li className="flex items-start gap-3 bg-purple-50 p-2 -mx-2 rounded-lg">
                        <div className="mt-0.5 p-1 rounded-full" style={{ backgroundColor: '#f3e8ff', color: '#9333ea' }}><Users className="w-3.5 h-3.5" strokeWidth={3} /></div>
                        <span className="text-purple-900 font-bold text-sm">Support pour répondre aux questions de 8h à 23h</span>
                      </li>
                      
                      <li className="flex items-start gap-3">
                        <div className="mt-0.5 p-1 rounded-full" style={{ backgroundColor: '#f3e8ff', color: '#9333ea' }}><Check className="w-3.5 h-3.5" strokeWidth={3} /></div>
                        <span className="text-slate-800 font-semibold text-sm">Messagerie permanente pour accompagner (parents)</span>
                      </li>
                      <li className="flex items-start gap-3">
                        <div className="mt-0.5 p-1 rounded-full" style={{ backgroundColor: '#f3e8ff', color: '#9333ea' }}><Check className="w-3.5 h-3.5" strokeWidth={3} /></div>
                        <span className="text-slate-800 font-semibold text-sm">Conseils d'orientation & méthodologie</span>
                      </li>
                    </ul>
                    <Link to="/signup?plan=suivi" className="block">
                      {/* Bouton Dégradé Violet */}
                      <Button className="w-full bg-gradient-to-r from-purple-600 to-pink-500 hover:from-purple-700 hover:to-pink-600 text-white font-bold rounded-xl py-6 shadow-lg shadow-purple-500/20 transition-all">
                        Pack Suivi+
                      </Button>
                    </Link>
                  </div>
                </div>
                
                <div className="mt-12 text-center">
                   <p className="text-sm text-slate-400 flex items-center justify-center gap-2">
                     <span className="w-2 h-2 rounded-full bg-green-400 animate-pulse"></span>
                     Paiement sécurisé via Stripe. Annulation en 1 clic depuis l'espace parent.
                   </p>
                   <p className="text-sm text-slate-500 mt-4">
                     Des questions ? Contactez{' '}
                     <a href="mailto:raphael@siimply.fr" className="text-blue-600 hover:underline font-medium">
                       raphael@siimply.fr
                     </a>
                   </p>
                </div>
              </div>
            </section>
          </>
        )}

        {/* Invite Parents Dialog */}
        <InviteParentsDialog
          open={showInviteDialog}
          onOpenChange={setShowInviteDialog}
          userId={userId || ""}
          onSuccess={() => {
            setHasParents(true);
            checkIfHasParents();
          }}
        />

        {/* Footer */}
        <footer className="bg-muted py-8">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex flex-col sm:flex-row justify-between items-center gap-4 text-sm text-muted-foreground">
              <p>Siimply © 2025</p>
              <div className="flex gap-6">
                <a href="#" className="hover:text-foreground transition-colors">
                  À propos
                </a>
                <button onClick={() => setShowContactModal(true)} className="hover:text-foreground transition-colors">
                  Contact
                </button>
                <a href="#" className="hover:text-foreground transition-colors">
                  Confidentialité
                </a>
              </div>
            </div>
          </div>
        </footer>
      </div>

      {/* Contact Modal */}
      {showContactModal && <ContactModal isOpen={showContactModal} onClose={() => setShowContactModal(false)} />}

      {/* CSAT Dialog */}
      {isCSATOpen && (
        <LogoutCSATDialog
          isOpen={isCSATOpen}
          onComplete={handleCSATComplete}
          onSkip={handleCSATSkip}
          userId={csatUserId}
          userProfile={csatUserProfile}
        />
      )}

      {/* Modal plein écran pour les images */}
      {selectedImage && (
        <div 
          className="fixed inset-0 bg-black/90 z-50 flex items-center justify-center p-4"
          onClick={() => setSelectedImage(null)}
        >
          {/* Bouton fermer */}
          <button 
            onClick={() => setSelectedImage(null)}
            className="absolute top-4 right-4 w-10 h-10 bg-white/20 rounded-full flex items-center justify-center text-white hover:bg-white/30 transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
          
          {/* Image en grand */}
          <img 
            src={selectedImage} 
            alt="Image agrandie"
            className="max-w-full max-h-[90vh] object-contain rounded-lg"
            onClick={(e) => e.stopPropagation()}
          />
        </div>
      )}
    </>
  );
};

export default Index;
