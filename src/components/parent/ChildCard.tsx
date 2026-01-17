import { useNavigate } from "react-router-dom";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { ActivityBadge } from "./ActivityBadge";
import { WeeklyStats } from "./WeeklyStats";
import { MiniProgressBar } from "./MiniProgressBar";
import { Bot } from "lucide-react";

export interface ChildData {
  user_id: string;
  prenom: string;
  nom: string;
  classe: string;
  lastActivity: string | null;
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
  competences: {
    analyse: number | null;
    calcul: number | null;
    raisonnement: number | null;
  };
}

interface ChildCardProps {
  child: ChildData;
}

export const ChildCard = ({ child }: ChildCardProps) => {
  const navigate = useNavigate();
  
  const initials = `${child.prenom.charAt(0)}${child.nom.charAt(0)}`.toUpperCase();
  
  const generateSummary = () => {
    if (child.weeklyExercises.tentes === 0) {
      return `${child.prenom} n'a pas encore travaillé cette semaine. Un peu d'encouragement pourrait l'aider à reprendre.`;
    }
    const successRate = child.weeklyExercises.tentes > 0 
      ? (child.weeklyExercises.reussis / child.weeklyExercises.tentes) * 100 
      : 0;
    if (successRate >= 80) {
      return `${child.prenom} fait d'excellents progrès cette semaine. La régularité du travail porte ses fruits.`;
    }
    if (successRate >= 50) {
      return `${child.prenom} travaille régulièrement. Quelques notions sont encore à consolider pour progresser.`;
    }
    return `${child.prenom} a besoin d'un accompagnement renforcé sur certaines notions. Les exercices réguliers l'aideront.`;
  };

  const glassStyle = {
    boxShadow: "0 8px 32px 0 rgba(31, 38, 135, 0.1)",
  };

  return (
    <Card 
      className="w-full max-w-4xl mx-auto rounded-[16px] md:rounded-[24px] bg-white border border-white/50 hover:bg-white/95 transition-all"
      style={glassStyle}
    >
      <CardContent className="p-4 md:p-6 space-y-5">
        {/* ZONE A : En-tête */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Avatar className="h-14 w-14">
              <AvatarFallback className="bg-primary/10 text-primary font-semibold text-lg">
                {initials}
              </AvatarFallback>
            </Avatar>
            <div>
              <h3 className="font-semibold text-xl">{child.prenom}</h3>
              <p className="text-sm text-muted-foreground">{child.classe}</p>
            </div>
          </div>
          <ActivityBadge lastActivity={child.lastActivity} />
        </div>

        {/* ZONE B + D : Stats et Compétences côte à côte sur desktop */}
        <div className="flex flex-col md:flex-row gap-5">
          {/* Stats hebdo */}
          <div className="flex-1">
            <WeeklyStats 
              weeklyInteractions={child.weeklyInteractions}
              weeklyExercises={child.weeklyExercises}
              regularite={child.regularite}
            />
          </div>
          
          {/* Météo des compétences */}
          <div className="md:w-64 space-y-2 md:border-l md:border-white/30 md:pl-5">
            <h4 className="text-sm font-medium text-muted-foreground mb-3">Compétences</h4>
            <MiniProgressBar label="Analyse" value={child.competences.analyse} />
            <MiniProgressBar label="Calcul" value={child.competences.calcul} />
            <MiniProgressBar label="Raisonnement" value={child.competences.raisonnement} />
          </div>
        </div>

        {/* ZONE C : Synthèse IA */}
        <div className="bg-white/30 rounded-lg p-4">
          <div className="flex items-center gap-2 mb-2">
            <Bot className="h-4 w-4 text-primary" />
            <span className="text-sm font-medium">Bilan de la semaine</span>
          </div>
          <p className="text-sm text-muted-foreground leading-relaxed">
            {generateSummary()}
          </p>
        </div>

        {/* ACTIONS - côte à côte */}
        <div className="pt-2 flex flex-col sm:flex-row gap-3">
          <Button 
            className="flex-1"
            onClick={() => navigate(`/suivi_parents/${child.user_id}`)}
          >
            Voir le suivi détaillé
          </Button>
          <Button 
            variant="outline"
            className="flex-1 bg-white/30 border-white/50 hover:bg-white/50"
            onClick={() => {/* TODO: paramètres */}}
          >
            Paramètres du profil
          </Button>
        </div>
      </CardContent>
    </Card>
  );
};
