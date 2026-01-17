import { useMemo } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { TrendingUp, TrendingDown, Minus, Sparkles } from "lucide-react";

interface CompetenceData {
  score_actuel?: number;
  total_sollicitations?: number;
  interactions?: Array<{ date: string; niveau: string; index: number }>;
}

interface ChapterCompetences {
  [sousNotion: string]: CompetenceData;
}

interface SnapshotData {
  snapshot_date: string;
  competences: {
    [chapitre: string]: ChapterCompetences;
    _transversales?: any;
  };
}

interface ChapterEvolutionProps {
  currentCompetences: Record<string, ChapterCompetences>;
  snapshots: SnapshotData[];
  glassStyle?: boolean;
}

interface ChapterStats {
  chapitre: string;
  today: number | null;
  week7: number | null;
  week14: number | null;
}

/**
 * Calcule le % de maîtrise moyen d'un chapitre basé sur les scores des sous-notions
 */
function calculateChapterMastery(chapterData: ChapterCompetences | undefined): number | null {
  if (!chapterData) return null;
  
  const scores: number[] = [];
  
  for (const [key, sousNotion] of Object.entries(chapterData)) {
    // Skip _transversales and other special keys
    if (key.startsWith('_')) continue;
    
    if (sousNotion?.score_actuel !== undefined && sousNotion.score_actuel !== null) {
      scores.push(sousNotion.score_actuel);
    }
  }
  
  if (scores.length === 0) return null;
  
  const average = scores.reduce((sum, s) => sum + s, 0) / scores.length;
  return Math.round(average * 100);
}

/**
 * Trouve le snapshot le plus proche d'une date cible
 */
function findClosestSnapshot(
  snapshots: SnapshotData[], 
  targetDate: Date,
  maxDaysDiff: number = 2
): SnapshotData | null {
  const targetTime = targetDate.getTime();
  
  let closest: SnapshotData | null = null;
  let minDiff = Infinity;
  
  for (const snapshot of snapshots) {
    const snapshotDate = new Date(snapshot.snapshot_date);
    const diff = Math.abs(snapshotDate.getTime() - targetTime);
    const daysDiff = diff / (1000 * 60 * 60 * 24);
    
    if (daysDiff <= maxDaysDiff && diff < minDiff) {
      minDiff = diff;
      closest = snapshot;
    }
  }
  
  return closest;
}

export function ChapterEvolution({ currentCompetences, snapshots, glassStyle = false }: ChapterEvolutionProps) {
  const chapterStats = useMemo(() => {
    const today = new Date();
    const weekAgo = new Date(today);
    weekAgo.setDate(weekAgo.getDate() - 7);
    const twoWeeksAgo = new Date(today);
    twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 14);
    
    // Find closest snapshots for each period
    const snapshot7 = findClosestSnapshot(snapshots, weekAgo);
    const snapshot14 = findClosestSnapshot(snapshots, twoWeeksAgo);
    
    // Get all unique chapters from current competences
    const chapters = new Set<string>();
    
    // From current
    for (const chapitre of Object.keys(currentCompetences)) {
      if (!chapitre.startsWith('_')) chapters.add(chapitre);
    }
    
    // From snapshots
    for (const snapshot of snapshots) {
      for (const chapitre of Object.keys(snapshot.competences)) {
        if (!chapitre.startsWith('_')) chapters.add(chapitre);
      }
    }
    
    // Calculate stats for each chapter
    const stats: ChapterStats[] = [];
    
    for (const chapitre of chapters) {
      const todayScore = calculateChapterMastery(currentCompetences[chapitre]);
      const week7Score = snapshot7 
        ? calculateChapterMastery(snapshot7.competences[chapitre]) 
        : null;
      const week14Score = snapshot14 
        ? calculateChapterMastery(snapshot14.competences[chapitre]) 
        : null;
      
      // Only include chapters with at least some data
      if (todayScore !== null || week7Score !== null || week14Score !== null) {
        stats.push({
          chapitre,
          today: todayScore,
          week7: week7Score,
          week14: week14Score,
        });
      }
    }
    
    // Sort by current score descending, with nulls last
    stats.sort((a, b) => {
      if (a.today === null && b.today === null) return 0;
      if (a.today === null) return 1;
      if (b.today === null) return -1;
      return b.today - a.today;
    });
    
    return stats;
  }, [currentCompetences, snapshots]);

  const cardClasses = glassStyle 
    ? "rounded-[16px] md:rounded-[24px] bg-white border border-white/50"
    : "";

  const cardStyle = glassStyle 
    ? { boxShadow: "0 8px 32px 0 rgba(31, 38, 135, 0.1)" } 
    : {};

  if (chapterStats.length === 0) {
    return (
      <Card className={cardClasses} style={cardStyle}>
        <CardHeader>
          <CardTitle className="text-lg flex items-center gap-2">
            <TrendingUp className="h-5 w-5 text-primary" />
            Évolution par chapitre
          </CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground text-center py-8">
            Pas encore de données d'évolution disponibles
          </p>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card className={cardClasses} style={cardStyle}>
      <CardHeader>
        <CardTitle className="text-lg flex items-center gap-2">
          <TrendingUp className="h-5 w-5 text-primary" />
          Évolution par chapitre
        </CardTitle>
      </CardHeader>
      <CardContent>
        {/* Header row */}
        <div className="grid grid-cols-4 gap-4 mb-3 text-sm font-medium text-muted-foreground border-b pb-2">
          <div>Chapitre</div>
          <div className="text-center">-14 jours</div>
          <div className="text-center">-7 jours</div>
          <div className="text-center">Aujourd'hui</div>
        </div>
        
        {/* Chapter rows */}
        <div className="space-y-3">
          {chapterStats.map((stat) => (
            <ChapterRow key={stat.chapitre} stat={stat} />
          ))}
        </div>
      </CardContent>
    </Card>
  );
}

function ChapterRow({ stat }: { stat: ChapterStats }) {
  // Calculate evolution indicators
  const diff7to14 = stat.week7 !== null && stat.week14 !== null 
    ? stat.week7 - stat.week14 
    : null;
  const diffTodayTo7 = stat.today !== null && stat.week7 !== null 
    ? stat.today - stat.week7 
    : null;

  return (
    <div className="grid grid-cols-4 gap-4 items-center py-2 border-b border-border/30 last:border-0">
      {/* Chapter name */}
      <div className="text-sm font-medium truncate" title={stat.chapitre}>
        {stat.chapitre}
      </div>
      
      {/* -14 days */}
      <div className="text-center">
        <ScoreCell value={stat.week14} />
      </div>
      
      {/* -7 days */}
      <div className="text-center">
        <ScoreCell value={stat.week7} diff={diff7to14} />
      </div>
      
      {/* Today */}
      <div className="text-center">
        <ScoreCell value={stat.today} diff={diffTodayTo7} isToday />
      </div>
    </div>
  );
}

function ScoreCell({ 
  value, 
  diff, 
  isToday = false 
}: { 
  value: number | null; 
  diff?: number | null;
  isToday?: boolean;
}) {
  if (value === null) {
    return <span className="text-muted-foreground text-sm">—</span>;
  }
  
  // Determine color based on score
  const getScoreColor = (score: number) => {
    if (score >= 75) return 'text-green-600';
    if (score >= 50) return 'text-amber-600';
    return 'text-red-500';
  };
  
  // Render evolution indicator
  const renderDiff = () => {
    if (diff === null || diff === undefined) return null;
    
    if (diff > 3) {
      return (
        <div className="flex items-center justify-center gap-0.5 text-green-600 text-xs">
          <TrendingUp className="h-3 w-3" />
          <span>+{diff}%</span>
        </div>
      );
    }
    
    if (diff < -3) {
      return (
        <div className="flex items-center justify-center gap-0.5 text-red-500 text-xs">
          <TrendingDown className="h-3 w-3" />
          <span>{diff}%</span>
        </div>
      );
    }
    
    return (
      <div className="flex items-center justify-center gap-0.5 text-muted-foreground text-xs">
        <Minus className="h-3 w-3" />
        <span>stable</span>
      </div>
    );
  };
  
  return (
    <div className="flex flex-col items-center gap-0.5">
      <span className={`text-sm font-semibold ${getScoreColor(value)} ${isToday ? 'text-base' : ''}`}>
        {value}%
      </span>
      {renderDiff()}
    </div>
  );
}

export default ChapterEvolution;
