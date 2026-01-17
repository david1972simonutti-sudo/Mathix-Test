import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ChevronDown, ChevronUp } from "lucide-react";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import { useNavigate } from "react-router-dom";

interface SousNotion {
  reussites: number;
  echecs: number;
  statut: string;
  interactions?: Array<{ statut: string }>;
}

interface CompetenceCardProps {
  chapitre: string;
  nbExercices: number;
  sousNotions: Record<string, SousNotion>;
  reussitesGlobales?: number;
  echecsGlobaux?: number;
}

// Helper function to calculate stats from interactions or legacy fields
const getNotionStats = (data: SousNotion) => {
  if (data.interactions && Array.isArray(data.interactions)) {
    const total = data.interactions.length;
    const reussites = data.interactions.filter((i) => 
      i.statut === 'maîtrisé' || i.statut === 'maitrise'
    ).length;
    return { reussites, total };
  }
  // Legacy fallback
  return { 
    reussites: data.reussites || 0, 
    total: (data.reussites || 0) + (data.echecs || 0) 
  };
};

const CompetenceCard = ({
  chapitre,
  nbExercices,
  sousNotions,
  reussitesGlobales: propReussites,
  echecsGlobaux: propEchecs,
}: CompetenceCardProps) => {
  const [isOpen, setIsOpen] = useState(false);
  const navigate = useNavigate();

  // Calculer les totaux globaux - utiliser les props si fournies, sinon calculer à partir des sous-notions
  // Supporte les deux structures: interactions[] (nouvelle) et reussites/echecs (legacy)
  
  // Compter TOUTES les interactions comme "questions" (pas juste réussites+échecs)
  const sousNotionTotal = Object.values(sousNotions).reduce((sum, sn: any) => {
    if (sn.interactions && Array.isArray(sn.interactions)) {
      return sum + sn.interactions.length;
    }
    // Legacy: réussites + échecs
    return sum + (sn.reussites || 0) + (sn.echecs || 0);
  }, 0);
  
  const sousNotionReussites = Object.values(sousNotions).reduce((sum, sn: any) => {
    // Nouvelle structure avec interactions[]
    if (sn.interactions && Array.isArray(sn.interactions)) {
      return sum + sn.interactions.filter((i: any) => 
        i.statut === 'maîtrisé' || i.statut === 'maitrise'
      ).length;
    }
    // Ancienne structure legacy
    return sum + (sn.reussites || 0);
  }, 0);
  
  const sousNotionEchecs = Object.values(sousNotions).reduce((sum, sn: any) => {
    // Nouvelle structure avec interactions[]
    if (sn.interactions && Array.isArray(sn.interactions)) {
      return sum + sn.interactions.filter((i: any) => 
        i.statut === 'lacune' || i.statut === 'a_renforcer' || i.statut === 'erreur' || i.statut === 'fragile'
      ).length;
    }
    // Ancienne structure legacy
    return sum + (sn.echecs || 0);
  }, 0);
  
  // Utiliser les props si fournies et > 0, sinon utiliser les calculs des sous-notions
  const reussitesGlobales = (propReussites !== undefined && propReussites > 0) ? propReussites : sousNotionReussites;
  const echecsGlobaux = (propEchecs !== undefined && propEchecs > 0) ? propEchecs : sousNotionEchecs;

  // Total des questions = max entre (réussites+échecs) calculé et total des interactions
  const totalQuestions = Math.max(reussitesGlobales + echecsGlobaux, sousNotionTotal);
  const successRate = totalQuestions === 0 ? 0 : Math.round((reussitesGlobales / totalQuestions) * 100);

  const getSuccessRateColor = (rate: number) => {
    if (rate >= 70) return "text-green-600";
    if (rate >= 40) return "text-cyan-600";
    return "text-red-600";
  };

  const getSuccessRateBadge = (rate: number) => {
    if (rate >= 70) return { text: "Excellent travail !", variant: "default" as const };
    if (rate >= 40) return { text: "En progression", variant: "secondary" as const };
    return { text: "À renforcer", variant: "destructive" as const };
  };

  const getStatutBadge = (statut: string) => {
    // Normaliser le statut pour gérer les variations (avec/sans accents)
    const normalizedStatut = statut?.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    
    // Statuts harmonisés avec vocabulaire encourageant
    if (normalizedStatut === "maitrise" || normalizedStatut === "maitrise") {
      return { emoji: "✅", text: "Maîtrisé", className: "bg-green-100 text-green-800 border-green-200" };
    }
    if (normalizedStatut === "fragile") {
      return { emoji: "⚠️", text: "À consolider", className: "bg-yellow-100 text-yellow-800 border-yellow-200" };
    }
    if (normalizedStatut === "en_cours" || normalizedStatut === "en_cours_acquisition") {
      return { emoji: "🔄", text: "En progression", className: "bg-blue-100 text-blue-800 border-blue-200" };
    }
    // statut === "a_renforcer" ou "lacune" ou tout autre cas
    return { emoji: "💪", text: "À renforcer", className: "bg-cyan-100 text-cyan-800 border-cyan-200" };
  };

  const badge = getSuccessRateBadge(successRate);

  return (
    <Card className="hover:shadow-lg transition-all hover:scale-102">
      <CardHeader>
        <div className="flex items-start justify-between">
          <div className="flex-1">
            <CardTitle className="text-xl mb-2">📊 {chapitre}</CardTitle>
            <div className={`text-3xl font-bold mb-2 ${getSuccessRateColor(successRate)}`}>
              {successRate}%
            </div>
            <Badge variant={badge.variant} className="mb-3">
              {badge.text}
            </Badge>
          </div>
        </div>
        <Progress value={successRate} className="h-3 mb-2" />
        <p className="text-sm text-muted-foreground">
          {reussitesGlobales} réussites sur {totalQuestions} questions • {nbExercices} interaction{nbExercices > 1 ? "s" : ""}
        </p>
      </CardHeader>
      <CardContent>
        <Collapsible open={isOpen} onOpenChange={setIsOpen}>
          <CollapsibleTrigger asChild>
            <Button variant="ghost" className="w-full justify-between">
              <span>Voir les détails</span>
              {isOpen ? <ChevronUp className="h-4 w-4" /> : <ChevronDown className="h-4 w-4" />}
            </Button>
          </CollapsibleTrigger>
          <CollapsibleContent className="space-y-2 mt-4">
            {Object.entries(sousNotions).map(([notion, data]) => {
              const badge = getStatutBadge(data.statut);
              return (
                <div
                  key={notion}
                  className="py-3 border-b last:border-b-0"
                >
                  <div className="flex items-center justify-between gap-3 mb-1">
                    <h4 className="font-medium text-sm flex-1">{notion}</h4>
                    <Badge className={badge.className} variant="outline">
                      {badge.emoji} {badge.text}
                    </Badge>
                  </div>
                  <p className="text-xs text-muted-foreground mb-2">
                    {(() => {
                      const stats = getNotionStats(data);
                      return `${stats.reussites} bonnes réponses sur ${stats.total} questions`;
                    })()}
                  </p>
                  {data.statut !== "maîtrisé" && (
                    <Button
                      size="sm"
                      variant="outline"
                      className="w-full"
                      onClick={() => navigate(`/exercise?chapitre=${encodeURIComponent(chapitre)}&sous_notion=${encodeURIComponent(notion)}&from=competences`)}
                    >
                      Travailler cette notion
                    </Button>
                  )}
                </div>
              );
            })}
          </CollapsibleContent>
        </Collapsible>
      </CardContent>
    </Card>
  );
};

export default CompetenceCard;
