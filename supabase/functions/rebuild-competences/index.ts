import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

// ========== UTILITY FUNCTIONS (mirrored from analyze-response) ==========

/**
 * Calcule le poids d'une interaction selon sa récence
 */
const calculerPoidsRecence = (
  interactionIndex: number,
  totalInteractions: number
): number => {
  const positionFromEnd = totalInteractions - interactionIndex;
  
  if (positionFromEnd < 3) return 1.0;
  if (positionFromEnd < 6) return 0.6;
  if (positionFromEnd < 10) return 0.3;
  return 0.1;
};

/**
 * Calcule le decay temporel basé sur l'âge en jours
 * - < 7 jours: poids complet (1.0)
 * - 7-30 jours: réduction légère (0.8)
 * - 30-90 jours: demi-poids (0.5)
 * - > 90 jours: poids minimal (0.1)
 */
const calculerDecayTemporel = (dateStr: string): number => {
  const date = new Date(dateStr);
  const now = new Date();
  const ageInDays = (now.getTime() - date.getTime()) / (1000 * 60 * 60 * 24);
  
  if (ageInDays <= 7) return 1.0;
  if (ageInDays <= 30) return 0.8;
  if (ageInDays <= 90) return 0.5;
  return 0.1;
};

/**
 * Facteur multiplicateur selon le type d'erreur
 */
const calculerFacteurTypeErreur = (type_erreur: string): number => {
  const facteurs: Record<string, number> = {
    'calcul': 0.8,
    'notation': 0.9,
    'methodologique': 1.0,
    'conceptuelle': 1.5
  };
  return facteurs[type_erreur] || 1.0;
};

/**
 * Calcule le score pondéré d'une sous-notion (-1 à 1)
 */
const calculerScorePondere = (
  interactions: Array<{
    index: number;
    date?: string;
    statut: string;
    gravite_contextuelle?: number;
    type_erreur?: string;
  }>
): number => {
  if (interactions.length === 0) return 0;
  
  let totalWeightedScore = 0;
  let totalWeight = 0;
  
  interactions.forEach(interaction => {
    const poidsRecence = calculerPoidsRecence(interaction.index, interactions.length);
    const poidsTemporel = interaction.date ? calculerDecayTemporel(interaction.date) : 1.0;
    const poids = poidsRecence * poidsTemporel;
    
    let valeur: number;
    if (interaction.statut === 'maîtrisé' || interaction.statut === 'maitrise') {
      valeur = 1.0;
    } else if (interaction.statut === 'en_cours_acquisition' || interaction.statut === 'en_cours') {
      valeur = 0.3;
    } else if (interaction.statut === 'consultation') {
      valeur = 0;
    } else if (interaction.statut === 'indice_demande') {
      valeur = -0.2;
    } else { // lacune / a_renforcer
      const gravite = interaction.gravite_contextuelle || 3;
      const facteurType = calculerFacteurTypeErreur(interaction.type_erreur || 'methodologique');
      valeur = -(gravite / 3) * facteurType;
    }
    
    totalWeightedScore += valeur * poids;
    totalWeight += poids;
  });
  
  const score = totalWeight > 0 ? totalWeightedScore / totalWeight : 0;
  return Math.max(-1, Math.min(1, score));
};

/**
 * Compare les 3 dernières interactions vs 3 précédentes
 */
const determinerTendance = (
  interactions: Array<any>
): 'en_amelioration' | 'stable' | 'a_reconsolider' | 'decouverte' => {
  if (interactions.length < 3) return 'decouverte';
  
  const last3 = interactions.slice(-3);
  const prev3 = interactions.slice(-6, -3);
  
  if (prev3.length === 0) return 'decouverte';
  
  const last3Score = calculerScorePondere(last3);
  const prev3Score = calculerScorePondere(prev3);
  
  const delta = last3Score - prev3Score;
  
  if (delta > 0.3) return 'en_amelioration';
  if (delta < -0.3) return 'a_reconsolider';
  return 'stable';
};

/**
 * Détermine le statut final avec priorité
 */
const determinerStatut = (
  score: number,
  tendance: string,
  interactions: Array<any>
): {
  label: 'maitrise' | 'en_cours' | 'a_renforcer' | 'fragile';
  priorite: 'critique' | 'haute' | 'moyenne' | 'basse';
  derniere_erreur_index: number | null;
  erreurs_recurrentes: boolean;
} => {
  let lastErrorIndex = -1;
  for (let i = interactions.length - 1; i >= 0; i--) {
    if (interactions[i].statut === 'a_renforcer' || interactions[i].statut === 'lacune') {
      lastErrorIndex = i;
      break;
    }
  }
  const interactionsSinceError = lastErrorIndex >= 0 
    ? interactions.length - lastErrorIndex - 1
    : 999;
  
  const recent5 = interactions.slice(-5);
  const errorTypes = recent5
    .filter((i: any) => i.statut === 'a_renforcer' || i.statut === 'lacune')
    .map((i: any) => i.type_erreur);
  const erreurs_recurrentes = errorTypes.some((type: string) => 
    errorTypes.filter((t: string) => t === type).length >= 2
  );
  
  let label: 'maitrise' | 'en_cours' | 'a_renforcer' | 'fragile';
  let priorite: 'critique' | 'haute' | 'moyenne' | 'basse';
  
  if (score >= 0.7 && interactionsSinceError >= 3) {
    label = 'maitrise';
    priorite = 'basse';
  } else if (score >= 0.5 && interactionsSinceError === 0) {
    label = 'fragile';
    priorite = 'moyenne';
  } else if (score < -0.3 || erreurs_recurrentes) {
    label = 'a_renforcer';
    priorite = tendance === 'a_reconsolider' ? 'critique' : 'haute';
  } else {
    label = 'en_cours';
    priorite = 'moyenne';
  }
  
  return {
    label,
    priorite,
    derniere_erreur_index: lastErrorIndex,
    erreurs_recurrentes
  };
};

// ========== MAIN FUNCTION ==========

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      throw new Error('Missing authorization header');
    }

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: authHeader },
        },
      }
    );

    const { data: { user }, error: userError } = await supabaseClient.auth.getUser();
    if (userError || !user) {
      throw new Error('Unauthorized');
    }

    console.log(`🔄 Rebuilding competences for user: ${user.id}`);

    // Fetch ALL interactions with created_at for temporal decay
    const { data: interactions, error: interactionsError } = await supabaseClient
      .from('interactions')
      .select('chapitre, analyse_erreur, reponse_eleve, exercice_enonce, exercice_id, created_at')
      .eq('user_id', user.id)
      .order('created_at', { ascending: true });

    if (interactionsError) {
      throw interactionsError;
    }

    if (!interactions || interactions.length === 0) {
      console.log('⚠️ No interactions found');
      return new Response(
        JSON.stringify({ success: true, message: 'No data to rebuild' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    console.log(`📊 Processing ${interactions.length} interactions`);
    
    // Helper functions
    const isHelpRequest = (reponse: string): boolean => {
      if (!reponse) return false;
      const msg = reponse.toLowerCase();
      const helpPatterns = [
        "je ne me souviens plus", "je ne me rappelle plus", "j'ai oublié", "j ai oublie",
        "explique", "expliquer", "réexplique", "rappelle-moi", "rappelle moi",
        "comment on fait", "comment faire", "comment ça marche", "comment ca marche",
        "je comprends pas", "je ne comprends pas", "aide-moi", "aide moi",
        "peux-tu m'aider", "peux tu m'aider", "peux-tu m'expliquer", "peux tu m'expliquer",
        "c'est quoi", "c est quoi", "qu'est-ce que", "qu est ce que",
        "comment calculer", "comment trouver", "je suis perdu", "je suis bloqué", "je bloque",
        "je ne sais pas", "je ne sais plus"
      ];
      return helpPatterns.some(pattern => msg.includes(pattern));
    };
    
    const detectChapterFromMessage = (text: string): string | null => {
      if (!text) return null;
      const msg = text.toLowerCase();
      
      const chapterKeywords: Record<string, string[]> = {
        "Équations du second degré": ["second degré", "second degree", "discriminant", "delta", "trinôme", "trinome", "forme canonique", "ax²+bx+c"],
        "Dérivation": ["dérivée", "dérivées", "dériver", "dérivation", "tangente", "f'(x)", "nombre dérivé"],
        "Suites": ["suite", "suites", "récurrence", "recurrence", "u_n", "v_n", "terme", "raison"],
        "Fonctions": ["fonction", "fonctions", "courbe", "graphe", "image", "antécédent", "f(x)"],
        "Probabilités": ["probabilité", "probabilites", "proba", "loi", "binomiale", "événement"],
        "Limites": ["limite", "limites", "infini", "asymptote", "convergence", "lim"],
        "Intégrales": ["intégrale", "integrales", "primitive", "aire sous courbe", "∫"],
        "Trigonométrie": ["trigonométrie", "trigonometrie", "cosinus", "sinus", "tangente", "cos", "sin"],
        "Logarithmes": ["logarithme", "ln", "log", "exponentielle", "exp", "e^x"],
        "Vecteurs": ["vecteur", "vecteurs", "colinéaire", "norme", "produit scalaire"],
        "Géométrie": ["géométrie", "triangle", "cercle", "pythagore", "coordonnées", "repère"]
      };
      
      for (const [chapter, keywords] of Object.entries(chapterKeywords)) {
        if (keywords.some(kw => msg.includes(kw))) {
          return chapter;
        }
      }
      
      return null;
    };

    const invalidChapitrePatterns = [
      /^exercice/i, /soumis/i, /proposé/i, /envoyé/i, /question de l'élève/i,
      /demande de l'élève/i, /vérification/i, /transcription/i,
      /^analyse$/i, /^travail$/i, /^calcul$/i
    ];
    
    const normalizationMap: Record<string, string[]> = {
      "Calcul intégral": ["intégrale", "intégrales", "primitive", "primitives"],
      "Fonction logarithme népérien": ["logarithme", "logarithmes", "ln"],
      "Fonction exponentielle": ["exponentielle", "exponentielles", "exp"],
      "Suites numériques": ["suite", "suites"],
      "Limites de fonctions": ["limite", "limites"],
      "Dérivation": ["dérivée", "dérivées", "dériver"],
      "Probabilités conditionnelles": ["probabilité", "probabilités", "proba"],
      "Équations et inéquations": ["équation", "équations", "inéquation"],
      "Fonctions affines et linéaires": ["fonction affine", "affine", "linéaire"],
      "Fonctions de référence": ["fonction carré", "fonction inverse", "fonction racine"],
      "Second degré": ["trinôme", "polynôme du second degré", "équation du second degré"],
    };
    
    function validateChapitre(chapitre: string): string | null {
      if (!chapitre || chapitre.trim() === '') return null;
      if (invalidChapitrePatterns.some(p => p.test(chapitre))) {
        console.log(`❌ Chapitre invalide rejeté: "${chapitre}"`);
        return null;
      }
      const chapLower = chapitre.toLowerCase();
      for (const [validChap, keywords] of Object.entries(normalizationMap)) {
        if (keywords.some(kw => chapLower.includes(kw))) {
          return validChap;
        }
      }
      return chapitre;
    }

    // ========== NEW RICH STRUCTURE ==========
    // Structure: competences[chapitre].sous_notions[sousNotion].interactions[]
    const competencesMap: Record<string, {
      exercice_ids: Set<string>;
      total_interactions: number;
      last_interaction_date: string | null;
      sous_notions: Record<string, {
        interactions: Array<{
          index: number;
          date: string;
          statut: string;
          gravite_contextuelle?: number;
          type_erreur?: string;
          details?: string;
        }>;
      }>;
    }> = {};

    const lacunesArray: Array<{
      chapitre: string;
      sous_notion: string;
      identifie_le: string;
      details?: string;
    }> = [];

    let globalInteractionIndex = 0;

    for (const interaction of interactions) {
      let chapitre = interaction.chapitre;
      const analyseErreur = interaction.analyse_erreur as any;
      let analyseFine = analyseErreur?.analyse_fine;
      const reponseEleve = interaction.reponse_eleve;
      const exerciceEnonce = interaction.exercice_enonce;
      const interactionDate = interaction.created_at;

      // Detect chapter if missing
      if (!chapitre) {
        if (reponseEleve) {
          chapitre = detectChapterFromMessage(reponseEleve);
        }
        if (!chapitre && exerciceEnonce) {
          const enonceStr = typeof exerciceEnonce === 'string' 
            ? exerciceEnonce 
            : JSON.stringify(exerciceEnonce);
          chapitre = detectChapterFromMessage(enonceStr);
        }
        
        if (!chapitre) {
          continue;
        }
      }
      
      const validatedChapitre = validateChapitre(chapitre);
      if (!validatedChapitre) {
        continue;
      }
      chapitre = validatedChapitre;

      // Generate generic analyse_fine if missing
      if (!Array.isArray(analyseFine) || analyseFine.length === 0) {
        const isHelp = reponseEleve && isHelpRequest(reponseEleve);
        const hasMathContent = reponseEleve && /[=+\-*/]|\d+|\\frac|\\sqrt|U_n|x\^|f\(|lim|dérivée/.test(reponseEleve);
        
        if (isHelp || hasMathContent) {
          const genericSousNotion = chapitre;
          const statut = isHelp ? "a_renforcer" : "en_cours";
          
          analyseFine = [{
            sous_notion: genericSousNotion,
            statut: statut,
            details: isHelp ? "Demande d'aide identifiée" : "Interaction mathématique"
          }];
        } else {
          continue;
        }
      }
      
      // Initialize chapter if not exists
      if (!competencesMap[chapitre]) {
        competencesMap[chapitre] = {
          exercice_ids: new Set<string>(),
          total_interactions: 0,
          last_interaction_date: null,
          sous_notions: {}
        };
      }
      
      competencesMap[chapitre].total_interactions += 1;
      
      // Track last interaction date
      const currentLast = competencesMap[chapitre].last_interaction_date;
      if (!currentLast || (interactionDate && interactionDate > currentLast)) {
        competencesMap[chapitre].last_interaction_date = interactionDate || null;
      }

      if (interaction.exercice_id) {
        competencesMap[chapitre].exercice_ids.add(interaction.exercice_id);
      }

      // Process each sous_notion in analyse_fine
      for (const item of analyseFine) {
        const sousNotion = item.sous_notion || item.notion;
        const statut = item.statut?.toLowerCase();

        if (!sousNotion) continue;

        if (!competencesMap[chapitre].sous_notions[sousNotion]) {
          competencesMap[chapitre].sous_notions[sousNotion] = {
            interactions: []
          };
        }

        // Add interaction to the list (RICH STRUCTURE)
        competencesMap[chapitre].sous_notions[sousNotion].interactions.push({
          index: globalInteractionIndex,
          date: interactionDate,
          statut: statut || 'en_cours',
          gravite_contextuelle: item.gravite_contextuelle || item.gravite,
          type_erreur: item.type_erreur,
          details: item.details
        });

        globalInteractionIndex++;
      }
    }

    // ========== COMPUTE FINAL STRUCTURE WITH STATUT_ACTUEL ==========
    const sanitizedCompetences: Record<string, {
      reussites_globales: number;
      echecs_globaux: number;
      nb_exercices: number;
      last_interaction_date: string | null;
      sous_notions: Record<string, {
        interactions: Array<any>;
        statut_actuel: {
          score: number;
          label: string;
          tendance: string;
          priorite: string;
          derniere_erreur_index: number | null;
          erreurs_recurrentes: boolean;
        };
        statut: string; // For legacy compatibility
        reussites: number;
        echecs: number;
      }>;
    }> = {};
    
    for (const [chapitre, data] of Object.entries(competencesMap)) {
      if (!chapitre || chapitre === "undefined" || chapitre === "null") {
        console.log(`⚠️ Removing invalid chapter key: "${chapitre}"`);
        continue;
      }

      let reussitesGlobales = 0;
      let echecsGlobaux = 0;
      const sousNotionsProcessed: Record<string, any> = {};

      for (const [sousNotion, snData] of Object.entries(data.sous_notions)) {
        const interactionsList = snData.interactions;
        
        // Calculate score, tendance, statut using utility functions
        const score = calculerScorePondere(interactionsList);
        const tendance = determinerTendance(interactionsList);
        const statutResult = determinerStatut(score, tendance, interactionsList);

        // Count successes/failures for legacy compatibility
        let reussites = 0;
        let echecs = 0;
        interactionsList.forEach((i: any) => {
          if (i.statut === 'maitrise' || i.statut === 'maîtrisé' || i.statut === 'reussi') {
            reussites++;
            reussitesGlobales++;
          } else if (i.statut === 'a_renforcer' || i.statut === 'lacune' || i.statut === 'erreur') {
            echecs++;
            echecsGlobaux++;
          }
        });

        sousNotionsProcessed[sousNotion] = {
          interactions: interactionsList,
          statut_actuel: {
            score: Math.round(score * 100) / 100,
            label: statutResult.label,
            tendance,
            priorite: statutResult.priorite,
            derniere_erreur_index: statutResult.derniere_erreur_index,
            erreurs_recurrentes: statutResult.erreurs_recurrentes
          },
          statut: statutResult.label, // Legacy
          reussites,
          echecs
        };

        // Add to lacunes if a_renforcer with echecs >= 2
        if (statutResult.label === 'a_renforcer' && echecs >= 2) {
          const existingLacune = lacunesArray.find(
            l => l.chapitre === chapitre && l.sous_notion === sousNotion
          );
          
          if (!existingLacune) {
            lacunesArray.push({
              chapitre,
              sous_notion: sousNotion,
              identifie_le: new Date().toISOString(),
              details: `Difficultés identifiées sur ${sousNotion}`
            });
          }
        }
      }

      sanitizedCompetences[chapitre] = {
        reussites_globales: reussitesGlobales,
        echecs_globaux: echecsGlobaux,
        nb_exercices: data.exercice_ids.size > 0 
          ? data.exercice_ids.size 
          : data.total_interactions,
        last_interaction_date: data.last_interaction_date,
        sous_notions: sousNotionsProcessed
      };
    }
    
    console.log(`✅ Rebuilt ${Object.keys(sanitizedCompetences).length} chapters`);
    console.log(`🔴 Found ${lacunesArray.length} lacunes`);

    // Update or create student_profiles entry
    const { data: existingProfile } = await supabaseClient
      .from('student_profiles')
      .select('id')
      .eq('user_id', user.id)
      .maybeSingle();

    if (existingProfile) {
      const { error: updateError } = await supabaseClient
        .from('student_profiles')
        .update({
          competences: sanitizedCompetences,
          lacunes_identifiees: lacunesArray,
          updated_at: new Date().toISOString()
        })
        .eq('user_id', user.id);

      if (updateError) throw updateError;
    } else {
      const { error: insertError } = await supabaseClient
        .from('student_profiles')
        .insert({
          user_id: user.id,
          competences: sanitizedCompetences,
          lacunes_identifiees: lacunesArray
        });

      if (insertError) throw insertError;
    }

    console.log('💾 Student profile updated successfully');

    return new Response(
      JSON.stringify({ 
        success: true,
        chaptersRebuilt: Object.keys(sanitizedCompetences).length,
        lacunesFound: lacunesArray.length
      }),
      { 
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    );

  } catch (error) {
    console.error('❌ Error rebuilding competences:', error);
    return new Response(
      JSON.stringify({ error: (error as Error).message || 'Internal server error' }),
      { 
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    );
  }
});
