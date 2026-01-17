/**
 * Calcule la gravité contextuelle en fonction du décalage de niveau
 * Une erreur de fraction en 5ème ≠ en Terminale
 */
export const calculerGraviteContextuelle = (
  gravite_intrinsèque: number,
  niveau_attendu: string,
  niveau_eleve: string
): number => {
  const niveaux = ["4eme", "3eme", "seconde", "premiere", "terminale"];
  const index_attendu = niveaux.indexOf(niveau_attendu);
  const index_eleve = niveaux.indexOf(niveau_eleve);
  
  if (index_attendu === -1 || index_eleve === -1) {
    return gravite_intrinsèque; // Fallback si niveau inconnu
  }
  
  const decalage = index_eleve - index_attendu;
  
  let facteur: number;
  if (decalage <= 0) {
    facteur = 1.0; // Notion du niveau actuel ou supérieur
  } else if (decalage === 1) {
    facteur = 1.3; // Niveau N-1 (ex: erreur Première en Terminale)
  } else if (decalage === 2) {
    facteur = 1.6; // Niveau N-2 (ex: erreur Seconde en Terminale)
  } else {
    facteur = 2.0; // Collège en lycée (ex: erreur 4ème en Terminale)
  }
  
  const gravite_finale = Math.min(5, gravite_intrinsèque * facteur);
  return Math.round(gravite_finale * 10) / 10; // Arrondi à 1 décimale
};

/**
 * Calcule le poids d'une interaction selon sa récence
 * Les 3 dernières comptent plus que les anciennes
 */
export const calculerPoidsRecence = (
  interactionIndex: number,
  totalInteractions: number
): number => {
  const positionFromEnd = totalInteractions - interactionIndex;
  
  if (positionFromEnd < 3) return 1.0;   // 3 dernières : poids fort
  if (positionFromEnd < 6) return 0.6;   // 3-6 dernières : poids moyen
  if (positionFromEnd < 10) return 0.3;  // 6-10 dernières : poids faible
  return 0.1;                            // Au-delà : poids minimal
};

/**
 * Facteur multiplicateur selon le type d'erreur
 * Les erreurs conceptuelles sont plus graves
 */
export const calculerFacteurTypeErreur = (
  type_erreur: string
): number => {
  const facteurs: Record<string, number> = {
    'calcul': 0.8,           // Moins grave
    'notation': 0.9,
    'methodologique': 1.0,
    'conceptuelle': 1.5      // Plus grave
  };
  
  return facteurs[type_erreur] || 1.0;
};

/**
 * Calcule le score pondéré d'une sous-notion (-1 à 1)
 * Tient compte de la récence, gravité et type d'erreur
 */
export const calculerScorePondere = (
  interactions: Array<{
    index: number;
    statut: string;
    gravite_contextuelle?: number;
    type_erreur?: string;
  }>
): number => {
  if (interactions.length === 0) return 0;
  
  let totalWeightedScore = 0;
  let totalWeight = 0;
  
  interactions.forEach(interaction => {
    const poids = calculerPoidsRecence(interaction.index, interactions.length);
    
    let valeur: number;
    if (interaction.statut === 'maîtrisé') {
      valeur = 1.0;
    } else if (interaction.statut === 'en_cours_acquisition') {
      valeur = 0.3;
    } else if (interaction.statut === 'consultation') {
      // 🆕 Demande de correction/solution → neutre (juste comptabilisé)
      valeur = 0;
    } else if (interaction.statut === 'indice_demande') {
      // 🆕 Demande d'indice → petit malus (maîtrise incomplète)
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
  return Math.max(-1, Math.min(1, score)); // Clamp entre -1 et 1
};

/**
 * Compare les 3 dernières interactions vs 3 précédentes
 */
export const determinerTendance = (
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
 * Détermine le statut final : maitrise, en_cours, a_renforcer, fragile
 * Note: "a_renforcer" remplace "lacune" pour un vocabulaire plus encourageant
 */
export const determinerStatut = (
  score: number,
  tendance: string,
  interactions: Array<any>
): {
  label: 'maitrise' | 'en_cours' | 'a_renforcer' | 'fragile';
  priorite: 'critique' | 'haute' | 'moyenne' | 'basse';
  derniere_erreur_index: number | null;
  erreurs_recurrentes: boolean;
} => {
  // Trouver la dernière erreur
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
  
  // Détecter erreurs récurrentes (même type dans les 5 dernières)
  const recent5 = interactions.slice(-5);
  const errorTypes = recent5
    .filter(i => i.statut === 'a_renforcer' || i.statut === 'lacune')
    .map(i => i.type_erreur);
  const erreurs_recurrentes = errorTypes.some(type => 
    errorTypes.filter(t => t === type).length >= 2
  );
  
  let label: 'maitrise' | 'en_cours' | 'a_renforcer' | 'fragile';
  let priorite: 'critique' | 'haute' | 'moyenne' | 'basse';
  
  // Logique de décision
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
