import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import Header from "@/components/Header";
import { ChildCard, ChildData } from "@/components/parent";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";

const Parents = () => {
  const navigate = useNavigate();
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [loading, setLoading] = useState(true);
  const [parentPrenom, setParentPrenom] = useState("");
  const [children, setChildren] = useState<ChildData[]>([]);
  
  const {
    isCSATOpen,
    userProfile: csatUserProfile,
    userId: csatUserId,
    triggerLogoutWithCSAT,
    handleCSATComplete,
    handleCSATSkip,
  } = useAdvancedCSAT();

  useEffect(() => {
    checkAuthAndRole();
  }, []);

  const checkAuthAndRole = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      
      if (!user) {
        navigate("/login");
        return;
      }

      // Vérifier le rôle
      const { data: roleData, error: roleError } = await supabase
        .from('user_roles')
        .select('role')
        .eq('user_id', user.id)
        .single();

      if (roleError || roleData?.role !== 'parent') {
        toast.error("Accès non autorisé");
        navigate("/");
        return;
      }

      setIsLoggedIn(true);

      // Charger le profil du parent
      const { data: profileData } = await supabase
        .from('profiles')
        .select('prenom')
        .eq('user_id', user.id)
        .single();

      if (profileData) {
        setParentPrenom(profileData.prenom);
      }

      // Charger les enfants avec leurs données
      await loadChildren(user.id);
    } catch (error: any) {
      console.error("Erreur d'authentification:", error);
      navigate("/login");
    } finally {
      setLoading(false);
    }
  };

  const loadChildren = async (parentUserId: string) => {
    try {
      // Récupérer les relations parent-élève
      const { data: relations, error: relError } = await supabase
        .from('parent_eleve_relations')
        .select('eleve_user_id')
        .eq('parent_user_id', parentUserId);

      if (relError) throw relError;

      if (!relations || relations.length === 0) {
        return;
      }

      const eleveIds = relations.map(r => r.eleve_user_id);

      // Récupérer les profils des élèves
      const { data: profiles, error: profilesError } = await supabase
        .from('profiles')
        .select('user_id, prenom, nom, classe')
        .in('user_id', eleveIds);

      if (profilesError) throw profilesError;

      // Pour chaque enfant, récupérer les données supplémentaires
      const childrenData: ChildData[] = await Promise.all(
        (profiles || []).map(async (profile) => {
          // Dernière interaction (pour le badge d'activité)
          const { data: lastInteraction } = await supabase
            .from('interactions')
            .select('created_at')
            .eq('user_id', profile.user_id)
            .order('created_at', { ascending: false })
            .limit(1)
            .maybeSingle();

          // Stats de la semaine
          const weekAgo = new Date();
          weekAgo.setDate(weekAgo.getDate() - 7);

          // 1. Compter les messages (interactions chat) par type
          const { data: chatMessages } = await supabase
            .from('chat_history')
            .select('chat_id, created_at')
            .eq('user_id', profile.user_id)
            .eq('role', 'user')
            .gte('created_at', weekAgo.toISOString());

          // Récupérer les types de chat pour chaque message
          let interactionsExercices = 0;
          let interactionsCours = 0;
          
          if (chatMessages && chatMessages.length > 0) {
            const chatIds = [...new Set(chatMessages.map(m => m.chat_id).filter(Boolean))];
            if (chatIds.length > 0) {
              const { data: chats } = await supabase
                .from('chats')
                .select('id, chat_type')
                .in('id', chatIds);
              
              const chatTypeMap = new Map(chats?.map(c => [c.id, c.chat_type]) || []);
              
              chatMessages.forEach(msg => {
                const chatType = chatTypeMap.get(msg.chat_id);
                if (chatType === 'exercice') interactionsExercices++;
                else if (chatType === 'cours') interactionsCours++;
              });
            }
          }

          // 2. Stats exercices (réussis/tentés + corrections)
          const { data: weeklyInteractions } = await supabase
            .from('interactions')
            .select('exercice_id, analyse_erreur, correction')
            .eq('user_id', profile.user_id)
            .eq('chat_type', 'exercice')
            .gte('created_at', weekAgo.toISOString());

          // Grouper par exercice_id pour calculer le taux de réussite par exercice
          const exercisesMap = new Map<string, { tentatives: number; correctes: number }>();
          
          weeklyInteractions?.forEach(interaction => {
            if (!interaction.exercice_id) return;
            
            const analyse = interaction.analyse_erreur as any;
            
            // Vérifier si c'est une vraie tentative de réponse
            const estTentative = analyse?.est_tentative_reponse === true || analyse?.verdict !== undefined;
            const estCorrect = analyse?.est_correct === true || analyse?.verdict === true;
            
            // Fallback pour les anciennes interactions sans est_tentative_reponse
            const isFallbackAttempt = analyse?.est_tentative_reponse === undefined && 
              analyse?.est_correct !== undefined &&
              !['indice_demande', 'consultation', 'question'].includes(analyse?.statut);
            
            if (estTentative || isFallbackAttempt) {
              const current = exercisesMap.get(interaction.exercice_id) || { tentatives: 0, correctes: 0 };
              current.tentatives++;
              if (estCorrect) current.correctes++;
              exercisesMap.set(interaction.exercice_id, current);
            }
          });

          // Un exercice est réussi si >= 80% des tentatives sont correctes
          let exercicesReussis = 0;
          exercisesMap.forEach(({ tentatives, correctes }) => {
            if (tentatives > 0 && (correctes / tentatives) >= 0.8) {
              exercicesReussis++;
            }
          });

          const exercicesTentes = exercisesMap.size;
          const correctionsImmediate = weeklyInteractions?.filter(i => i.correction !== null).length || 0;

          // 3. Régularité (jours distincts avec sessions)
          const { data: sessions } = await supabase
            .from('sessions')
            .select('date_debut')
            .eq('user_id', profile.user_id)
            .gte('date_debut', weekAgo.toISOString());

          const distinctDays = new Set(
            sessions?.map(s => new Date(s.date_debut!).toDateString()) || []
          ).size;

          // Compétences transversales
          const { data: studentProfile } = await supabase
            .from('student_profiles')
            .select('competences')
            .eq('user_id', profile.user_id)
            .maybeSingle();

          let competences = {
            analyse: null as number | null,
            calcul: null as number | null,
            raisonnement: null as number | null,
          };

          if (studentProfile?.competences) {
            const comp = studentProfile.competences as any;
            if (comp._transversales) {
              competences = {
                analyse: comp._transversales.chercher?.score_actuel 
                  ? Math.round(comp._transversales.chercher.score_actuel * 100) 
                  : null,
                calcul: comp._transversales.calculer?.score_actuel 
                  ? Math.round(comp._transversales.calculer.score_actuel * 100) 
                  : null,
                raisonnement: comp._transversales.raisonner?.score_actuel 
                  ? Math.round(comp._transversales.raisonner.score_actuel * 100) 
                  : null,
              };
            }
          }

          return {
            user_id: profile.user_id,
            prenom: profile.prenom,
            nom: profile.nom,
            classe: profile.classe,
            lastActivity: lastInteraction?.created_at || null,
            weeklyInteractions: {
              total: (chatMessages?.length || 0),
              exercices: interactionsExercices,
              cours: interactionsCours,
            },
            weeklyExercises: {
              reussis: exercicesReussis,
              tentes: exercicesTentes,
              correctionsImmediate,
            },
            regularite: distinctDays,
            competences,
          };
        })
      );

      setChildren(childrenData);
    } catch (error: any) {
      console.error("Erreur lors du chargement des enfants:", error);
      toast.error("Erreur lors du chargement des enfants");
    }
  };

  const handleLogout = () => {
    triggerLogoutWithCSAT();
  };

  if (loading) {
    return (
      <div className="min-h-screen relative">
        <div 
          className="fixed inset-0 bg-white"
          style={{
            backgroundImage: `url('/images/background-siimply.png')`,
            backgroundSize: "cover",
            backgroundPosition: "bottom left",
            backgroundRepeat: "no-repeat",
          }}
        />
        <div className="relative z-10 flex items-center justify-center min-h-screen">
          <p className="text-lg">Chargement...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen relative">
      {/* Background layer */}
      <div 
        className="fixed inset-0 bg-white"
        style={{
          backgroundImage: `url('/images/background-siimply.png')`,
          backgroundSize: "cover",
          backgroundPosition: "bottom left",
          backgroundRepeat: "no-repeat",
        }}
      />
      
      {/* Content layer */}
      <div className="relative z-10">
        <Header isLoggedIn={isLoggedIn} onLogout={handleLogout} />
        
        <main className="container mx-auto px-4 py-8">
          <h2 className="text-3xl font-bold mb-2">
            Bonjour {parentPrenom}
          </h2>
          <p className="text-muted-foreground mb-8">
            Suivez la progression de vos enfants
          </p>

          {children.length === 0 ? (
            <div className="text-center py-12">
              <p className="text-muted-foreground text-lg">
                Aucun enfant associé à votre compte
              </p>
            </div>
          ) : (
            <div className="flex flex-col gap-6">
              {children.map((child) => (
                <ChildCard key={child.user_id} child={child} />
              ))}
            </div>
          )}
        </main>
        
        <LogoutCSATDialog
          isOpen={isCSATOpen}
          onComplete={handleCSATComplete}
          onSkip={handleCSATSkip}
          userId={csatUserId}
          userProfile={csatUserProfile}
        />
      </div>
    </div>
  );
};

export default Parents;
