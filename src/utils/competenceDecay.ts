/**
 * Utility functions for temporal decay in competence calculations
 */

/**
 * Calculate temporal decay based on age in days
 * - < 7 days: full weight (1.0)
 * - 7-30 days: slight reduction (0.8)
 * - 30-90 days: half weight (0.5)
 * - > 90 days: minimal weight (0.1)
 */
export const calculateTemporalDecay = (dateStr: string): number => {
  const date = new Date(dateStr);
  const now = new Date();
  const ageInDays = (now.getTime() - date.getTime()) / (1000 * 60 * 60 * 24);
  
  if (ageInDays <= 7) return 1.0;
  if (ageInDays <= 30) return 0.8;
  if (ageInDays <= 90) return 0.5;
  return 0.1;
};

/**
 * Check if an interaction is too old to be considered (> 90 days)
 */
export const isInteractionTooOld = (dateStr: string): boolean => {
  const date = new Date(dateStr);
  const now = new Date();
  const ageInDays = (now.getTime() - date.getTime()) / (1000 * 60 * 60 * 24);
  return ageInDays > 90;
};

/**
 * Get a recency bonus for recently worked chapters
 * - < 3 days: +2 bonus
 * - 3-7 days: +1 bonus
 * - > 7 days: no bonus
 */
export const getRecencyBonus = (dateStr: string | null): number => {
  if (!dateStr) return 0;
  
  const date = new Date(dateStr);
  const now = new Date();
  const daysSinceLastInteraction = (now.getTime() - date.getTime()) / (1000 * 60 * 60 * 24);
  
  if (daysSinceLastInteraction < 3) return 2;
  if (daysSinceLastInteraction < 7) return 1;
  return 0;
};

/**
 * Clean and validate lacunes array
 * Filters out malformed entries (strings instead of objects)
 */
export const cleanLacunes = (lacunes: unknown[]): Array<{
  chapitre: string;
  sous_notion: string;
  identifie_le: string;
  details?: string;
  est_prerequis?: boolean;
}> => {
  if (!Array.isArray(lacunes)) return [];
  
  return lacunes.filter((l: any) => 
    typeof l === 'object' && 
    l !== null && 
    typeof l.chapitre === 'string' && 
    l.chapitre.length > 0
  ) as Array<{
    chapitre: string;
    sous_notion: string;
    identifie_le: string;
    details?: string;
    est_prerequis?: boolean;
  }>;
};

/**
 * Calculate weighted success rate with temporal decay
 */
export const calculateWeightedSuccessRate = (
  sousNotions: Record<string, any>
): { 
  weightedSuccesses: number; 
  weightedTotal: number; 
  rate: number;
  lastInteractionDate: string | null;
} => {
  let weightedSuccesses = 0;
  let weightedTotal = 0;
  let lastInteractionDate: string | null = null;

  Object.values(sousNotions).forEach((sn: any) => {
    if (sn.interactions && Array.isArray(sn.interactions)) {
      sn.interactions.forEach((interaction: any) => {
        if (!interaction.date) return;
        
        // Track last interaction date
        if (!lastInteractionDate || interaction.date > lastInteractionDate) {
          lastInteractionDate = interaction.date;
        }
        
        const decay = calculateTemporalDecay(interaction.date);
        
        // Only count interactions with significant weight
        if (decay < 0.1) return;
        
        weightedTotal += decay;
        
        if (interaction.statut === 'maîtrisé' || interaction.statut === 'maitrise') {
          weightedSuccesses += decay;
        }
      });
    } else {
      // Legacy fallback: no date info, use raw counts with full weight
      const reussites = sn.reussites || 0;
      const echecs = sn.echecs || 0;
      weightedTotal += reussites + echecs;
      weightedSuccesses += reussites;
    }
  });

  const rate = weightedTotal > 0 ? (weightedSuccesses / weightedTotal) * 100 : 0;

  return {
    weightedSuccesses,
    weightedTotal,
    rate,
    lastInteractionDate
  };
};

/**
 * Sort chapters by priority for recommendations
 * Considers: priority level, status, recency, weighted success rate
 */
export interface ChapterPriority {
  chapitre: string;
  priorite: 'critique' | 'haute' | 'moyenne' | 'basse' | null;
  statut: 'a_renforcer' | 'fragile' | 'en_cours' | 'faible_taux';
  tauxReussite: number;
  lastInteractionDate: string | null;
  recencyBonus: number;
  sousNotions: string[];
}

export const sortChaptersByPriority = (
  chapters: ChapterPriority[]
): ChapterPriority[] => {
  const prioriteOrder: Record<string, number> = { 
    critique: 0, 
    haute: 1, 
    moyenne: 2, 
    basse: 3, 
    null: 4 
  };
  
  const statutOrder: Record<string, number> = { 
    a_renforcer: 0, 
    fragile: 1, 
    en_cours: 2, 
    faible_taux: 3 
  };

  return [...chapters].sort((a, b) => {
    // 1. Priority by recency bonus (recently worked chapters first)
    if (a.recencyBonus !== b.recencyBonus) {
      return b.recencyBonus - a.recencyBonus;
    }
    
    // 2. Priority level (critique > haute > moyenne > basse)
    const pA = prioriteOrder[a.priorite || 'null'];
    const pB = prioriteOrder[b.priorite || 'null'];
    if (pA !== pB) return pA - pB;
    
    // 3. Status (a_renforcer > fragile > en_cours > faible_taux)
    const sA = statutOrder[a.statut];
    const sB = statutOrder[b.statut];
    if (sA !== sB) return sA - sB;
    
    // 4. Lowest success rate first
    return a.tauxReussite - b.tauxReussite;
  });
};
