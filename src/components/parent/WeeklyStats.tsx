import { HelpCircle } from "lucide-react";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";

interface WeeklyStatsProps {
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

export const WeeklyStats = ({ weeklyInteractions, weeklyExercises, regularite }: WeeklyStatsProps) => {
  const maxDays = 7;
  const regularitePercentage = (regularite / maxDays) * 100;

  return (
    <TooltipProvider delayDuration={100}>
      <div className="space-y-0 w-full">
        {/* Interactions */}
        <div className="flex justify-between items-start py-3 border-b border-border/30">
          <div className="flex items-center gap-1.5">
            <span className="text-sm font-medium text-foreground">Nombre d'interactions</span>
            <Tooltip>
              <TooltipTrigger asChild>
                <HelpCircle className="h-3.5 w-3.5 text-muted-foreground/50 cursor-help" />
              </TooltipTrigger>
              <TooltipContent side="top" className="max-w-[220px]">
                <p className="text-xs">Messages échangés avec Siimply cette semaine (questions sur les exercices ou les cours)</p>
              </TooltipContent>
            </Tooltip>
          </div>
          <div className="text-right">
            <span className="text-base font-semibold text-foreground">{weeklyInteractions.total} échanges</span>
            <p className="text-xs text-muted-foreground">
              {weeklyInteractions.exercices} exercices • {weeklyInteractions.cours} cours
            </p>
          </div>
        </div>

        {/* Exercices */}
        <div className="flex justify-between items-start py-3 border-b border-border/30">
          <div className="flex items-center gap-1.5">
            <span className="text-sm font-medium text-foreground">Exercices réussis</span>
            <Tooltip>
              <TooltipTrigger asChild>
                <HelpCircle className="h-3.5 w-3.5 text-muted-foreground/50 cursor-help" />
              </TooltipTrigger>
              <TooltipContent side="top" className="max-w-[220px]">
                <p className="text-xs">Exercices terminés avec succès sur le nombre total tenté. Les corrections sont les demandes d'aide.</p>
              </TooltipContent>
            </Tooltip>
          </div>
          <div className="text-right">
            <span className="text-base font-semibold text-foreground">
              {weeklyExercises.reussis}/{weeklyExercises.tentes} réussis
            </span>
            <p className="text-xs text-muted-foreground">
              {weeklyExercises.correctionsImmediate} correction{weeklyExercises.correctionsImmediate > 1 ? 's' : ''} demandée{weeklyExercises.correctionsImmediate > 1 ? 's' : ''}
            </p>
          </div>
        </div>

        {/* Régularité */}
        <div className="flex justify-between items-start py-3">
          <div className="flex items-center gap-1.5">
            <span className="text-sm font-medium text-foreground">Régularité</span>
            <Tooltip>
              <TooltipTrigger asChild>
                <HelpCircle className="h-3.5 w-3.5 text-muted-foreground/50 cursor-help" />
              </TooltipTrigger>
              <TooltipContent side="top" className="max-w-[220px]">
                <p className="text-xs">Nombre de jours où votre enfant s'est connecté cette semaine</p>
              </TooltipContent>
            </Tooltip>
          </div>
          <div className="flex flex-col items-end gap-1">
            <span className="text-base font-semibold text-foreground">{regularite}/7 jours</span>
            <div className="w-24 h-2 bg-muted rounded-full overflow-hidden">
              <div 
                className="h-full bg-primary rounded-full transition-all"
                style={{ width: `${regularitePercentage}%` }}
              />
            </div>
          </div>
        </div>
      </div>
    </TooltipProvider>
  );
};
