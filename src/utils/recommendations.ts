/**
 * Centralized recommendation system
 * Single source of truth for chapter recommendations across all pages
 */

import { supabase } from "@/integrations/supabase/client";
import { 
  cleanLacunes, 
  calculateWeightedSuccessRate, 
  getRecencyBonus,
  sortChaptersByPriority,
  type ChapterPriority 
} from "@/utils/competenceDecay";

export interface Recommendation {
  chapitre: string;
  sousNotion: string;
  details: string;
  source: 'prerequis' | 'lacune_critique' | 'chapitre_fragile' | 'dernier_travaille';
  priorite?: 'critique' | 'haute' | 'moyenne' | 'basse' | null;
}

interface SousNotion {
  reussites?: number;
  echecs?: number;
  statut?: string;
  statut_actuel?: { label?: string; priorite?: string };
  interactions?: any[];
}

interface Chapitre {
  reussites_globales?: number;
  echecs_globaux?: number;
  nb_exercices?: number;
  sous_notions: Record<string, SousNotion>;
}

/**
 * Get the top recommendation for a user
 * Uses a unified priority system:
 * 1. Missing prerequisites (est_prerequis === true)
 * 2. Critical/high priority lacunes
 * 3. Most fragile chapter (weighted calculation with temporal decay)
 * 4. Fallback: last worked chapter
 */
export const getTopRecommendation = async (userId: string): Promise<Recommendation | null> => {
  try {
    // 1. Fetch student profile
    const { data: profile } = await supabase
      .from("student_profiles")
      .select("competences, lacunes_identifiees")
      .eq("user_id", userId)
      .maybeSingle();

    if (!profile) {
      // No profile - check for recent interactions as fallback
      return await getFallbackRecommendation(userId);
    }

    const rawCompetences = (profile.competences as unknown as Record<string, Chapitre>) || {};
    const lacunesData = cleanLacunes((profile.lacunes_identifiees as unknown as any[]) || []);

    // 2. PRIORITY 1: Missing prerequisites
    const prerequisManquant = lacunesData.find((l) => l.est_prerequis === true);
    if (prerequisManquant) {
      return {
        chapitre: prerequisManquant.chapitre,
        sousNotion: prerequisManquant.sous_notion || '',
        details: `Tu as des difficultés avec ${prerequisManquant.sous_notion || prerequisManquant.chapitre} qui bloquent ta progression. Consolide cette base pour avancer sereinement !`,
        source: 'prerequis',
        priorite: 'critique'
      };
    }

    // 3. Sanitize competences
    const sanitizedCompetences: Record<string, Chapitre> = {};
    Object.entries(rawCompetences).forEach(([key, value]) => {
      if (key === "undefined" || !key || key === "_transversales") return;
      if (typeof value === 'object' && 'sous_notions' in value) {
        sanitizedCompetences[key] = value;
      }
    });

    // 4. Calculate chapter priorities with temporal decay
    const chapterPriorities: ChapterPriority[] = [];

    Object.entries(sanitizedCompetences).forEach(([chapitre, data]) => {
      if (!data.sous_notions) return;
      
      const { rate: weightedRate, weightedTotal, lastInteractionDate } = 
        calculateWeightedSuccessRate(data.sous_notions);
      
      // Skip chapters with no significant weighted interactions
      if (weightedTotal < 0.5) return;
      
      const recencyBonus = getRecencyBonus(lastInteractionDate);
      
      // Identify sub-notions by status
      const aRenforcerInChapter = Object.entries(data.sous_notions)
        .filter(([_, details]) => {
          const statut = details.statut?.toLowerCase() || details.statut_actuel?.label?.toLowerCase();
          return statut === "lacune" || statut === "a_renforcer";
        })
        .map(([sousNotion]) => sousNotion);
      
      const fragileInChapter = Object.entries(data.sous_notions)
        .filter(([_, details]) => {
          const statut = details.statut?.toLowerCase() || details.statut_actuel?.label?.toLowerCase();
          return statut === "fragile";
        })
        .map(([sousNotion]) => sousNotion);
      
      const enCoursInChapter = Object.entries(data.sous_notions)
        .filter(([_, details]) => {
          const statut = details.statut?.toLowerCase() || details.statut_actuel?.label?.toLowerCase();
          return statut === "en_cours_acquisition" || statut === "en_cours";
        })
        .map(([sousNotion]) => sousNotion);
      
      // Determine chapter status and priority
      let statut: 'a_renforcer' | 'fragile' | 'en_cours' | 'faible_taux' = 'faible_taux';
      let sousNotions = Object.keys(data.sous_notions);
      let priorite: 'critique' | 'haute' | 'moyenne' | 'basse' | null = null;
      
      // Find highest priority among sub-notions
      Object.values(data.sous_notions).forEach((details) => {
        const p = details.statut_actuel?.priorite;
        if (p === 'critique') priorite = 'critique';
        else if (p === 'haute' && priorite !== 'critique') priorite = 'haute';
        else if (p === 'moyenne' && !['critique', 'haute'].includes(priorite || '')) priorite = 'moyenne';
      });
      
      if (aRenforcerInChapter.length > 0) {
        statut = 'a_renforcer';
        sousNotions = aRenforcerInChapter;
      } else if (fragileInChapter.length > 0) {
        statut = 'fragile';
        sousNotions = fragileInChapter;
      } else if (enCoursInChapter.length > 0) {
        statut = 'en_cours';
        sousNotions = enCoursInChapter;
      }
      
      chapterPriorities.push({
        chapitre,
        priorite,
        statut,
        tauxReussite: weightedRate,
        lastInteractionDate,
        recencyBonus,
        sousNotions
      });
    });

    // 5. Get top recommendation from sorted chapters
    if (chapterPriorities.length > 0) {
      const sortedChapters = sortChaptersByPriority(chapterPriorities);
      const topChapter = sortedChapters[0];
      
      const { tauxReussite, statut, sousNotions, priorite } = topChapter;
      
      // Generate appropriate message
      let details: string;
      let source: Recommendation['source'] = 'chapitre_fragile';
      
      if (priorite === 'critique') {
        details = `Cette notion nécessite ton attention immédiate (taux : ${Math.round(tauxReussite)}%). C'est la clé pour débloquer ta progression !`;
        source = 'lacune_critique';
      } else if (statut === 'a_renforcer') {
        details = `Tu as des notions à renforcer dans ce chapitre (taux : ${Math.round(tauxReussite)}%). C'est le moment idéal pour progresser !`;
      } else if (statut === 'fragile') {
        details = `Quelques notions sont fragiles ici (taux : ${Math.round(tauxReussite)}%). Un peu de pratique et tu seras au top !`;
      } else if (statut === 'en_cours') {
        details = `Tu as des notions en progression (taux : ${Math.round(tauxReussite)}%). Continue ton élan !`;
      } else {
        details = `C'est ton chapitre le plus fragile avec un taux de ${Math.round(tauxReussite)}%. Concentre-toi dessus pour progresser !`;
      }
      
      return {
        chapitre: topChapter.chapitre,
        sousNotion: sousNotions[0] || 'général',
        details,
        source,
        priorite
      };
    }

    // 6. Fallback: last worked chapter
    return await getFallbackRecommendation(userId);
    
  } catch (error) {
    console.error("Erreur lors du calcul de la recommandation:", error);
    return null;
  }
};

/**
 * Fallback: get recommendation from last worked chapter
 */
const getFallbackRecommendation = async (userId: string): Promise<Recommendation | null> => {
  const { data: interactions } = await supabase
    .from("interactions")
    .select("chapitre")
    .eq("user_id", userId)
    .order("created_at", { ascending: false })
    .limit(1);

  if (interactions && interactions.length > 0 && interactions[0].chapitre) {
    return {
      chapitre: interactions[0].chapitre,
      sousNotion: "",
      details: "Commence à t'entraîner sur ce chapitre pour identifier tes points forts.",
      source: 'dernier_travaille',
      priorite: null
    };
  }

  return null;
};

/**
 * Get just the chapter name for simple use cases (like welcome messages)
 */
export const getRecommendedChapter = async (userId: string): Promise<string | null> => {
  const recommendation = await getTopRecommendation(userId);
  return recommendation?.chapitre || null;
};
