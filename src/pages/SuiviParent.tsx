import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import Header from "@/components/Header";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowLeft, CheckCircle, XCircle } from "lucide-react";
import CompetencesRadar from "@/components/CompetencesRadar";
import { WeeklyStats, ChapterEvolution } from "@/components/parent";
import { format, subDays } from "date-fns";
import { fr } from "date-fns/locale";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";

interface ChildProfile {
  user_id: string;
  prenom: string;
  nom: string;
  classe: string;
}

interface InteractionRecord {
  id: string;
  created_at: string;
  chapitre: string | null;
  exercice_enonce: string | null;
  analyse_erreur: any;
}

interface TransversaleData {
  score_actuel: number;
  total_sollicitations: number;
  interactions: Array<{
    date: string;
    niveau: string;
    index: number;
  }>;
}

interface SnapshotData {
  snapshot_date: string;
  competences: Record<string, any>;
}

interface WeeklyStatsData {
  weeklyInteractions: {
    total: number;
    exercices: number;
    cours: number;
  };
  weeklyExercises: {
    reussis: number;
    tentes: number;
    correctionsImmediate: number;
  };
  regularite: number;
}

const SuiviParent = () => {
  const navigate = useNavigate();
  const { enfantId } = useParams<{ enfantId: string }>();
  const [loading, setLoading] = useState(true);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [childProfile, setChildProfile] = useState<ChildProfile | null>(null);
  const [transversales, setTransversales] = useState<Record<string, TransversaleData>>({});
  const [currentCompetences, setCurrentCompetences] = useState<Record<string, any>>({});
  const [snapshots, setSnapshots] = useState<SnapshotData[]>([]);
  const [recentInteractions, setRecentInteractions] = useState<InteractionRecord[]>([]);
  const [weeklyStats, setWeeklyStats] = useState<WeeklyStatsData>({
    weeklyInteractions: { total: 0, exercices: 0, cours: 0 },
    weeklyExercises: { reussis: 0, tentes: 0, correctionsImmediate: 0 },
    regularite: 0,
  });
  
  const {
    isCSATOpen,
    userProfile: csatUserProfile,
    userId: csatUserId,
    triggerLogoutWithCSAT,
    handleCSATComplete,
    handleCSATSkip,
  } = useAdvancedCSAT();

  useEffect(() => {
    checkAuthAndLoadData();
  }, [enfantId]);

  const checkAuthAndLoadData = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser();
      
      if (!user) {
        navigate("/login");
        return;
      }

      // Vérifier que c'est bien un parent
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

      // Vérifier que l'enfant est bien lié à ce parent
      const { data: relation, error: relError } = await supabase
        .from('parent_eleve_relations')
        .select('*')
        .eq('parent_user_id', user.id)
        .eq('eleve_user_id', enfantId)
        .single();

      if (relError || !relation) {
        toast.error("Vous n'avez pas accès à ce profil");
        navigate("/parents");
        return;
      }

      setIsLoggedIn(true);
      await loadChildData();
    } catch (error: any) {
      console.error("Erreur d'authentification:", error);
      navigate("/login");
    } finally {
      setLoading(false);
    }
  };

  const loadChildData = async () => {
    if (!enfantId) return;

    // Charger le profil de l'enfant
    const { data: profile } = await supabase
      .from('profiles')
      .select('user_id, prenom, nom, classe')
      .eq('user_id', enfantId)
      .single();

    if (profile) {
      setChildProfile(profile);
    }

    // Charger les compétences transversales
    const { data: studentProfile } = await supabase
      .from('student_profiles')
      .select('competences')
      .eq('user_id', enfantId)
      .single();

    if (studentProfile?.competences) {
      const competences = studentProfile.competences as any;
      if (competences._transversales) {
        setTransversales(competences._transversales);
      }
      // Store all competences for chapter evolution (excluding _transversales)
      const { _transversales, ...chapterCompetences } = competences;
      setCurrentCompetences(chapterCompetences);
    }

    // Charger les snapshots des 14 derniers jours pour l'évolution
    const twoWeeksAgo = subDays(new Date(), 14);
    const { data: snapshotsData } = await supabase
      .from('competences_snapshots')
      .select('snapshot_date, competences')
      .eq('user_id', enfantId)
      .gte('snapshot_date', twoWeeksAgo.toISOString().split('T')[0])
      .order('snapshot_date', { ascending: false });

    if (snapshotsData) {
      setSnapshots(snapshotsData as SnapshotData[]);
    }

    // Période : 7 derniers jours
    const weekAgo = new Date();
    weekAgo.setDate(weekAgo.getDate() - 7);
    
    // Charger les interactions récentes pour l'affichage
    const { data: interactions } = await supabase
      .from('interactions')
      .select('id, created_at, chapitre, exercice_enonce, analyse_erreur, correction, chat_type, exercice_id')
      .eq('user_id', enfantId)
      .gte('created_at', weekAgo.toISOString())
      .order('created_at', { ascending: false });

    if (interactions) {
      setRecentInteractions(interactions);
      
      // Calculer les exercices réussis/tentés avec la nouvelle logique
      // Grouper par exercice_id
      const exerciceGroups: Record<string, typeof interactions> = {};
      interactions.forEach(inter => {
        if (inter.chat_type === 'exercice' && inter.exercice_id) {
          if (!exerciceGroups[inter.exercice_id]) {
            exerciceGroups[inter.exercice_id] = [];
          }
          exerciceGroups[inter.exercice_id].push(inter);
        }
      });
      
      let exercicesReussis = 0;
      const exercicesTentes = Object.keys(exerciceGroups).length;
      
      // Pour chaque exercice, calculer le taux de réussite
      Object.values(exerciceGroups).forEach(messages => {
        // Filtrer : uniquement les tentatives de réponse OU photos avec verdict
        const tentatives = messages.filter(m => {
          const analyse = m.analyse_erreur as any;
          // Nouveau champ est_tentative_reponse = true
          if (analyse?.est_tentative_reponse === true) return true;
          // Fallback : photo OCR avec verdict
          if (analyse?.verdict !== undefined) return true;
          // Fallback pour anciens exercices sans est_tentative_reponse :
          // inclure si est_correct est défini ET pas de demande d'aide explicite
          if (analyse?.est_tentative_reponse === undefined && analyse?.est_correct !== undefined) {
            const statut = analyse?.analyse_fine?.[0]?.statut;
            // Exclure les demandes d'aide (indice_demande, consultation)
            if (statut === 'indice_demande' || statut === 'consultation') return false;
            return true;
          }
          return false;
        });
        
        if (tentatives.length > 0) {
          const correctCount = tentatives.filter(m => {
            const analyse = m.analyse_erreur as any;
            return analyse?.est_correct === true || analyse?.verdict === true;
          }).length;
          
          // Exercice réussi si >= 80% des tentatives sont correctes
          if (correctCount / tentatives.length >= 0.8) {
            exercicesReussis++;
          }
        }
      });
      
      // Corrections immédiates : interactions avec correction
      const correctionsImmediate = interactions.filter(i => 
        i.chat_type === 'exercice' && i.correction
      ).length;
      
      setWeeklyStats(prev => ({
        ...prev,
        weeklyExercises: { reussis: exercicesReussis, tentes: exercicesTentes, correctionsImmediate },
      }));
    }

    // Charger les messages de chat pour compter les interactions
    const { data: chatMessages } = await supabase
      .from('chat_history')
      .select('id, chat_id')
      .eq('role', 'user')
      .gte('created_at', weekAgo.toISOString());

    // Charger les chats de cet enfant pour filtrer
    const { data: childChats } = await supabase
      .from('chats')
      .select('id, chat_type')
      .eq('user_id', enfantId);

    if (chatMessages && childChats) {
      const childChatIds = new Set(childChats.map(c => c.id));
      const childChatTypes = new Map(childChats.map(c => [c.id, c.chat_type]));
      
      const filteredMessages = chatMessages.filter(m => m.chat_id && childChatIds.has(m.chat_id));
      const exerciceMessages = filteredMessages.filter(m => childChatTypes.get(m.chat_id!) === 'exercice').length;
      const coursMessages = filteredMessages.filter(m => childChatTypes.get(m.chat_id!) === 'cours').length;
      
      setWeeklyStats(prev => ({
        ...prev,
        weeklyInteractions: {
          total: filteredMessages.length,
          exercices: exerciceMessages,
          cours: coursMessages,
        },
      }));
    }

    // Charger les sessions pour la régularité
    const { data: sessions } = await supabase
      .from('sessions')
      .select('date_debut')
      .eq('user_id', enfantId)
      .gte('date_debut', weekAgo.toISOString());

    if (sessions) {
      const distinctDays = new Set(
        sessions.map(s => new Date(s.date_debut!).toDateString())
      ).size;
      
      setWeeklyStats(prev => ({ ...prev, regularite: distinctDays }));
    }
  };

  const handleLogout = () => {
    triggerLogoutWithCSAT();
  };

  // Style glassmorphism réutilisable
  const glassStyle = {
    boxShadow: "0 8px 32px 0 rgba(31, 38, 135, 0.1)",
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
          {/* Retour + Titre */}
          <div className="mb-8">
            <Button 
              variant="ghost" 
              onClick={() => navigate("/parents")}
              className="mb-4"
            >
              <ArrowLeft className="h-4 w-4 mr-2" />
              Retour au tableau de bord
            </Button>
            
            <h2 className="text-3xl font-bold">
              Suivi de {childProfile?.prenom || "l'élève"}
            </h2>
            <p className="text-muted-foreground">{childProfile?.classe}</p>
          </div>

          {/* Stats hebdomadaires - Glassmorphism */}
          <Card 
            className="mb-8 rounded-[16px] md:rounded-[24px] bg-white border border-white/50"
            style={glassStyle}
          >
            <CardHeader>
              <CardTitle className="text-lg">Statistiques de la semaine</CardTitle>
            </CardHeader>
            <CardContent>
              <WeeklyStats 
                weeklyInteractions={weeklyStats.weeklyInteractions}
                weeklyExercises={weeklyStats.weeklyExercises}
                regularite={weeklyStats.regularite}
              />
            </CardContent>
          </Card>

          {/* Évolution par chapitre - Le composant ChapterEvolution sera modifié séparément */}
          <div className="mb-8">
            <ChapterEvolution 
              currentCompetences={currentCompetences}
              snapshots={snapshots}
              glassStyle={true}
            />
          </div>

          {/* Radar des compétences - Glassmorphism */}
          <div 
            className="mb-8 p-4 md:p-6 rounded-[16px] md:rounded-[24px] bg-white border border-white/50"
            style={glassStyle}
          >
            <h3 className="text-xl font-semibold mb-4">Compétences transversales</h3>
            <CompetencesRadar transversales={transversales as any} />
          </div>

          {/* Historique récent - Glassmorphism */}
          <Card 
            className="rounded-[16px] md:rounded-[24px] bg-white border border-white/50"
            style={glassStyle}
          >
            <CardHeader>
              <CardTitle>Activité récente</CardTitle>
            </CardHeader>
            <CardContent>
              {recentInteractions.length === 0 ? (
                <p className="text-muted-foreground text-center py-8">
                  Aucune activité récente
                </p>
              ) : (
                <div className="space-y-3">
                  {recentInteractions.slice(0, 10).map((interaction) => {
                    const analyse = interaction.analyse_erreur as any;
                    // Vérifier si est_correct est défini (true ou false)
                    const estCorrect = analyse?.est_correct;
                    const hasEvaluation = estCorrect === true || estCorrect === false;
                    // isSuccess = réponse correcte
                    const isSuccess = estCorrect === true;
                    
                    return (
                      <div 
                        key={interaction.id}
                        className="flex items-center justify-between p-3 bg-white/30 rounded-lg"
                      >
                        <div className="flex items-center gap-3">
                          {isSuccess ? (
                            <CheckCircle className="h-5 w-5 text-green-500" />
                          ) : hasEvaluation ? (
                            <XCircle className="h-5 w-5 text-orange-400" />
                          ) : (
                            <div className="h-5 w-5 rounded-full bg-muted-foreground/30" />
                          )}
                          <div>
                            <p className="font-medium text-sm">
                              {interaction.chapitre || "Exercice"}
                            </p>
                            <p className="text-xs text-muted-foreground">
                              {format(new Date(interaction.created_at), 'dd MMM yyyy à HH:mm', { locale: fr })}
                            </p>
                          </div>
                        </div>
                        <span className={`text-sm font-medium ${isSuccess ? 'text-green-500' : hasEvaluation ? 'text-orange-400' : 'text-muted-foreground'}`}>
                          {isSuccess ? '✓' : hasEvaluation ? '✗' : '--'}
                        </span>
                      </div>
                    );
                  })}
                </div>
              )}
            </CardContent>
          </Card>
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

export default SuiviParent;
