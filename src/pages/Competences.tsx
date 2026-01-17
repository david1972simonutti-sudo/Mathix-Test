import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { LogOut, ArrowLeft } from "lucide-react";
import RecommendationBanner from "@/components/RecommendationBanner";
import CompetenceCard from "@/components/CompetenceCard";
import CompetencesRadar from "@/components/CompetencesRadar";
import { useToast } from "@/hooks/use-toast";
import { useAdvancedCSAT } from "@/hooks/useAdvancedCSAT";
import { LogoutCSATDialog } from "@/components/LogoutCSATDialog";
import { cleanLacunes } from "@/utils/competenceDecay";
import { getTopRecommendation } from "@/utils/recommendations";

interface Lacune {
  chapitre: string;
  sous_notion: string;
  identifie_le: string;
  details?: string;
}

interface SousNotion {
  reussites: number;
  echecs: number;
  statut: string;
}

interface Chapitre {
  reussites_globales: number;
  echecs_globaux: number;
  nb_exercices?: number;
  sous_notions: Record<string, SousNotion>;
}

const Competences = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  
  const {
    isCSATOpen,
    userProfile: csatUserProfile,
    userId: csatUserId,
    triggerLogoutWithCSAT,
    handleCSATComplete,
    handleCSATSkip,
  } = useAdvancedCSAT();
  const [loading, setLoading] = useState(true);
  const [competences, setCompetences] = useState<Record<string, Chapitre>>({});
  const [lacunes, setLacunes] = useState<Lacune[]>([]);
  const [recommendation, setRecommendation] = useState<{
    chapitre: string;
    sousNotion: string;
    details?: string;
  } | null>(null);
  const [exercicesCounts, setExercicesCounts] = useState<Record<string, number>>({});
  const [isRebuilding, setIsRebuilding] = useState(false);
  const [hasUndefinedData, setHasUndefinedData] = useState(false);
  const [hasInteractions, setHasInteractions] = useState(false);
  const [shouldAutoRebuild, setShouldAutoRebuild] = useState(false);
  const [transversales, setTransversales] = useState<any>(null);

  useEffect(() => {
    const checkAuth = async () => {
      const { data: { session } } = await supabase.auth.getSession();
      if (!session) {
        navigate("/login");
      } else {
        setIsAuthenticated(true);
        await loadCompetences(session.user.id);
      }
    };
    checkAuth();
  }, [navigate]);

  const loadCompetences = async (userId: string) => {
    try {
      // Récupérer le profil de compétences
      const { data: profile } = await supabase
        .from("student_profiles")
        .select("competences, lacunes_identifiees")
        .eq("user_id", userId)
        .maybeSingle();

      // Check if user has interactions
      const { count: interactionCount } = await supabase
        .from("interactions")
        .select("id", { count: 'exact', head: true })
        .eq("user_id", userId);
      
      const hasInteractionsData = (interactionCount || 0) > 0;
      setHasInteractions(hasInteractionsData);

      if (profile) {
        // Sanitize competences data to remove invalid entries
        const rawCompetences = (profile.competences as unknown as Record<string, Chapitre>) || {};
        const sanitizedCompetences: Record<string, Chapitre> = {};
        
        let foundUndefined = false;
        Object.entries(rawCompetences).forEach(([key, value]) => {
          // Filter out "undefined" key and invalid data
          if (key === "undefined" || !key) {
            foundUndefined = true;
            return;
          }
          
          if (typeof value === 'object' && 
              ('reussites_globales' in value || 'echecs_globaux' in value || 'sous_notions' in value)) {
            // Assurer que les valeurs par défaut sont présentes
            sanitizedCompetences[key] = {
              reussites_globales: (value as any).reussites_globales || 0,
              echecs_globaux: (value as any).echecs_globaux || 0,
              nb_exercices: (value as any).nb_exercices || 0,
              sous_notions: (value as any).sous_notions || {}
            };
          }
        });
        
        setHasUndefinedData(foundUndefined);
        setCompetences(sanitizedCompetences);
        // Clean lacunes: filter out malformed entries (strings instead of objects)
        const rawLacunes = (profile.lacunes_identifiees as unknown as any[]) || [];
        const cleanedLacunes = cleanLacunes(rawLacunes);
        setLacunes(cleanedLacunes);
        
        // Extraire les compétences transversales OU utiliser des valeurs par défaut (50%)
        const defaultTransversales = {
          chercher: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
          modeliser: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
          representer: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
          raisonner: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
          calculer: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
          communiquer: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] }
        };
        setTransversales(rawCompetences._transversales || defaultTransversales);
        
        // If competences empty but interactions exist, suggest rebuild
        const hasCompetencesData = Object.keys(sanitizedCompetences).length > 0;
        if (!hasCompetencesData && hasInteractionsData) {
          setShouldAutoRebuild(true);
        }
      } else if (hasInteractionsData) {
        // No profile but has interactions - definitely need rebuild
        setShouldAutoRebuild(true);
      }

      // Récupérer les dernières interactions pour détecter les chapitres récents
      const { data: interactions } = await supabase
        .from("interactions")
        .select("chapitre, created_at")
        .eq("user_id", userId)
        .order("created_at", { ascending: false })
        .limit(10);

      // Calculer le nombre d'exercices par chapitre
      const counts: Record<string, number> = {};
      if (interactions) {
        interactions.forEach((inter) => {
          if (inter.chapitre) {
            counts[inter.chapitre] = (counts[inter.chapitre] || 0) + 1;
          }
        });
      }
      setExercicesCounts(counts);

      // Utiliser la recommandation CENTRALISÉE (même logique que useWelcomeAndChatLoading)
      const topRecommendation = await getTopRecommendation(userId);
      if (topRecommendation) {
        setRecommendation({
          chapitre: topRecommendation.chapitre,
          sousNotion: topRecommendation.sousNotion,
          details: topRecommendation.details
        });
      }
    } catch (error) {
      console.error("Erreur lors du chargement des compétences:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = () => {
    triggerLogoutWithCSAT();
  };
  
  const handleRebuildCompetences = async () => {
    setIsRebuilding(true);
    try {
      const { data: { session } } = await supabase.auth.getSession();
      if (!session) {
        navigate("/login");
        return;
      }
      
      const { data, error } = await supabase.functions.invoke("rebuild-competences");
      
      if (error) throw error;
      
      // Reload competences after rebuild
      await loadCompetences(session.user.id);
      
      toast({
        title: "✅ Compétences recalculées",
        description: "Ton profil a été reconstruit à partir de toutes tes interactions.",
      });
    } catch (error) {
      console.error("Erreur lors du recalcul des compétences:", error);
      toast({
        title: "Erreur",
        description: "Impossible de recalculer les compétences",
        variant: "destructive",
      });
    } finally {
      setIsRebuilding(false);
    }
  };

  if (!isAuthenticated) {
    return null;
  }

  // Filtrer les chapitres vides (sans données réelles)
  const chapitresTraites = Object.keys(competences).filter(chapitre => {
    const data = competences[chapitre];
    
    // Vérifier s'il y a des interactions dans les sous-notions
    const hasInteractions = Object.values(data.sous_notions || {}).some((sn: any) => 
      (sn.interactions && sn.interactions.length > 0) ||
      ((sn.reussites || 0) + (sn.echecs || 0)) > 0
    );
    
    return (
      (data.nb_exercices || 0) > 0 ||
      (data.reussites_globales || 0) > 0 ||
      (data.echecs_globaux || 0) > 0 ||
      hasInteractions
    );
  });
  const hasData = chapitresTraites.length > 0;

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="bg-card border-b border-border">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex justify-between items-center">
            <div className="flex items-center gap-4">
              <Button variant="ghost" size="icon" onClick={() => navigate("/")}>
                <ArrowLeft className="h-5 w-5" />
              </Button>
              <h1 className="text-2xl font-bold">Mes compétences</h1>
            </div>
            <Button variant="outline" onClick={handleLogout} className="gap-2">
              <LogOut className="h-4 w-4" />
              Déconnexion
            </Button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {loading ? (
          <div className="text-center py-12">
            <p className="text-muted-foreground">Chargement de tes compétences...</p>
          </div>
        ) : !hasData ? (
          <div className="text-center py-12">
            {hasInteractions && shouldAutoRebuild ? (
              <div className="space-y-6">
                <div className="text-6xl mb-6">🔄</div>
                <h2 className="text-3xl font-bold mb-4">Reconstruit ton profil de compétences</h2>
                <p className="text-muted-foreground text-lg max-w-2xl mx-auto mb-6">
                  Tu as des interactions enregistrées mais ton profil de compétences n'est pas encore généré. 
                  Lance un recalcul pour construire ton panorama de compétences à partir de tout ton historique.
                </p>
                <Button onClick={handleRebuildCompetences} disabled={isRebuilding} size="lg">
                  {isRebuilding ? "Recalcul en cours..." : "Calculer mes compétences"}
                </Button>
              </div>
            ) : (
              <div className="space-y-6">
                <div className="text-6xl mb-6">🎯</div>
                <h2 className="text-3xl font-bold mb-4">Commence ton parcours !</h2>
                <p className="text-muted-foreground text-lg max-w-2xl mx-auto mb-6">
                  Tu n'as pas encore fait d'exercices. Commence à t'entraîner pour voir tes
                  compétences et ta progression s'afficher ici.
                </p>
                <Button onClick={() => navigate("/exercise")} size="lg">
                  Commencer un exercice
                </Button>
              </div>
            )}
          </div>
        ) : (
          <div className="space-y-8">
            {/* Button to rebuild competences if undefined data detected */}
            {hasUndefinedData && (
              <div className="bg-muted/50 border border-border rounded-lg p-4 flex items-center justify-between">
                <div>
                  <p className="font-medium">Données incomplètes détectées</p>
                  <p className="text-sm text-muted-foreground">
                    Recalcule tes compétences pour corriger ton profil à partir de toutes tes interactions.
                  </p>
                </div>
                <Button onClick={handleRebuildCompetences} disabled={isRebuilding}>
                  {isRebuilding ? "Recalcul en cours..." : "Recalculer"}
                </Button>
              </div>
            )}
            
            {/* Section 0: Radar des compétences transversales - Toujours affiché */}
            <CompetencesRadar transversales={transversales || {
              chercher: { score_actuel: 0, total_sollicitations: 0, interactions: [] },
              modeliser: { score_actuel: 0, total_sollicitations: 0, interactions: [] },
              representer: { score_actuel: 0, total_sollicitations: 0, interactions: [] },
              raisonner: { score_actuel: 0, total_sollicitations: 0, interactions: [] },
              calculer: { score_actuel: 0, total_sollicitations: 0, interactions: [] },
              communiquer: { score_actuel: 0, total_sollicitations: 0, interactions: [] }
            }} />
            
            {/* Section 1: Recommandation prioritaire */}
            {recommendation && (
              <RecommendationBanner
                chapitre={recommendation.chapitre}
                sousNotion={recommendation.sousNotion}
                details={recommendation.details}
              />
            )}

            {/* Section 2: Panorama par chapitre */}
            <div>
              <h2 className="text-2xl font-bold mb-6">Ton panorama de compétences</h2>
              <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                {chapitresTraites.map((chapitre) => {
                  const data = competences[chapitre];
                  return (
                    <CompetenceCard
                      key={chapitre}
                      chapitre={chapitre}
                      nbExercices={data.nb_exercices || exercicesCounts[chapitre] || 0}
                      sousNotions={data.sous_notions || {}}
                      reussitesGlobales={data.reussites_globales}
                      echecsGlobaux={data.echecs_globaux}
                    />
                  );
                })}
              </div>
            </div>
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
  );
};

export default Competences;
