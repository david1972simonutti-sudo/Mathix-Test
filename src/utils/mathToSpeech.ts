/**
 * Utility functions for converting LaTeX mathematical expressions to spoken French
 * Handles math notation, punctuation, and natural speech patterns
 */

/**
 * Convert a LaTeX expression to spoken French
 */
const convertMathExpression = (latex: string): string => {
  let spoken = latex;

  // FRACTIONS
  spoken = spoken.replace(/\\frac\{([^}]+)\}\{([^}]+)\}/g, (_, num, den) => {
    return `${convertMathExpression(num)} sur ${convertMathExpression(den)}`;
  });

  // PUISSANCES
  spoken = spoken.replace(/([a-z0-9]+)\^(\d+)/gi, (_, base, exp) => {
    const expWords: Record<string, string> = {
      '2': 'au carré',
      '3': 'au cube',
      '4': 'puissance quatre',
      '5': 'puissance cinq',
    };
    return `${base} ${expWords[exp] || `puissance ${exp}`}`;
  });
  
  spoken = spoken.replace(/([a-z0-9]+)\^\{([^}]+)\}/gi, (_, base, exp) => {
    return `${base} puissance ${convertMathExpression(exp)}`;
  });

  // RACINES
  spoken = spoken.replace(/\\sqrt\{([^}]+)\}/g, (_, content) => {
    return `racine carrée de ${convertMathExpression(content)}`;
  });
  
  spoken = spoken.replace(/\\sqrt\[(\d+)\]\{([^}]+)\}/g, (_, n, content) => {
    return `racine ${n}-ième de ${convertMathExpression(content)}`;
  });

  // FONCTIONS TRIGONOMÉTRIQUES
  spoken = spoken
    .replace(/\\sin\(([^)]+)\)/g, 'sinus de $1')
    .replace(/\\cos\(([^)]+)\)/g, 'cosinus de $1')
    .replace(/\\tan\(([^)]+)\)/g, 'tangente de $1')
    .replace(/\\ln\(([^)]+)\)/g, 'logarithme népérien de $1')
    .replace(/\\log\(([^)]+)\)/g, 'logarithme de $1')
    .replace(/\\exp\(([^)]+)\)/g, 'exponentielle de $1');

  // LIMITES
  spoken = spoken.replace(/\\lim_\{([^}]+)\\to([^}]+)\}/g, (_, var_, val) => {
    return `limite quand ${var_} tend vers ${val}`;
  });

  // SOMMES ET PRODUITS
  spoken = spoken.replace(/\\sum_\{([^}]+)\}\^\{([^}]+)\}/g, (_, lower, upper) => {
    return `somme de ${lower} à ${upper}`;
  });
  
  spoken = spoken.replace(/\\prod_\{([^}]+)\}\^\{([^}]+)\}/g, (_, lower, upper) => {
    return `produit de ${lower} à ${upper}`;
  });

  // INTÉGRALES
  spoken = spoken.replace(/\\int_\{([^}]+)\}\^\{([^}]+)\}/g, (_, lower, upper) => {
    return `intégrale de ${lower} à ${upper}`;
  });

  // DÉRIVÉES
  spoken = spoken
    .replace(/f''/g, 'f seconde')
    .replace(/f'/g, 'f prime')
    .replace(/([a-z])''''/g, '$1 dérivée quatrième')
    .replace(/([a-z])'''/g, '$1 dérivée tierce')
    .replace(/([a-z])''/g, '$1 seconde')
    .replace(/([a-z])'/g, '$1 prime');

  // SYMBOLES GRECS
  spoken = spoken
    .replace(/\\pi/g, 'pi')
    .replace(/\\theta/g, 'thêta')
    .replace(/\\alpha/g, 'alpha')
    .replace(/\\beta/g, 'bêta')
    .replace(/\\gamma/g, 'gamma')
    .replace(/\\delta/g, 'delta')
    .replace(/\\Delta/g, 'Delta')
    .replace(/\\epsilon/g, 'epsilon')
    .replace(/\\lambda/g, 'lambda')
    .replace(/\\mu/g, 'mu')
    .replace(/\\sigma/g, 'sigma')
    .replace(/\\Sigma/g, 'Sigma')
    .replace(/\\omega/g, 'oméga')
    .replace(/\\Omega/g, 'Oméga');

  // OPÉRATEURS ET SYMBOLES
  spoken = spoken
    .replace(/\\times/g, 'fois')
    .replace(/\\cdot/g, 'fois')
    .replace(/\\div/g, 'divisé par')
    .replace(/\\pm/g, 'plus ou moins')
    .replace(/\\mp/g, 'moins ou plus')
    .replace(/\\approx/g, 'environ égal à')
    .replace(/\\neq/g, 'différent de')
    .replace(/\\leq/g, 'inférieur ou égal à')
    .replace(/\\geq/g, 'supérieur ou égal à')
    .replace(/\\to/g, 'vers')
    .replace(/\\infty/g, 'infini')
    .replace(/\\in/g, 'appartient à')
    .replace(/\\subset/g, 'inclus dans')
    .replace(/\\cup/g, 'union')
    .replace(/\\cap/g, 'intersection')
    .replace(/\\emptyset/g, 'ensemble vide')
    .replace(/\\forall/g, 'pour tout')
    .replace(/\\exists/g, 'il existe');

  // ENSEMBLES
  spoken = spoken
    .replace(/\\mathbb\{R\}/g, 'ensemble R')
    .replace(/\\mathbb\{N\}/g, 'ensemble N')
    .replace(/\\mathbb\{Z\}/g, 'ensemble Z')
    .replace(/\\mathbb\{Q\}/g, 'ensemble Q')
    .replace(/\\mathbb\{C\}/g, 'ensemble C');

  // Nettoyer les backslashes restants
  spoken = spoken.replace(/\\/g, '');
  
  // Nettoyer les accolades restantes
  spoken = spoken.replace(/[{}]/g, '');

  return spoken.trim();
};

/**
 * Convert LaTeX expressions in text to spoken French
 */
export const convertLatexToSpeech = (text: string): string => {
  let processed = text;

  // 1. Protéger les expressions entre $$...$$ (affichage)
  processed = processed.replace(/\$\$([^\$]+)\$\$/g, (_, expr) => {
    return ` ${convertMathExpression(expr)} `;
  });

  // 2. Convertir les expressions inline $...$
  processed = processed.replace(/\$([^\$]+)\$/g, (_, expr) => {
    return convertMathExpression(expr);
  });

  // 3. Normaliser la ponctuation pour le français
  processed = processed
    .replace(/\.\.\./g, '...') // Ellipses
    .replace(/\s*,\s*/g, ', ') // Virgules avec espace après
    .replace(/\s*:\s*/g, ' : ') // Deux-points avec espaces
    .replace(/\s*;\s*/g, ' ; ') // Point-virgules
    .replace(/\s*\?\s*/g, ' ? ') // Points d'interrogation
    .replace(/\s*!\s*/g, ' ! ') // Points d'exclamation
    .replace(/\n{2,}/g, '. '); // Paragraphes → pauses

  // 4. Nettoyer le markdown
  processed = processed
    .replace(/\*\*([^*]+)\*\*/g, '$1') // Bold
    .replace(/\*([^*]+)\*/g, '$1') // Italic
    .replace(/[#•]/g, ''); // Listes

  return processed.trim();
};

/**
 * Enhance punctuation for natural French speech
 */
export const enhancePunctuation = (text: string): string => {
  let enhanced = text;

  // Ajouter des pauses après les transitions logiques
  enhanced = enhanced
    .replace(/(donc|ainsi|alors|par conséquent|en effet)/gi, '$1,')
    .replace(/(d'abord|ensuite|puis|enfin|finalement)/gi, '$1,')
    .replace(/(cependant|néanmoins|toutefois|pourtant)/gi, '$1,');

  // S'assurer que les phrases se terminent correctement
  enhanced = enhanced.replace(/([a-zà-ÿ0-9])\s+([A-ZÀ-Ÿ])/g, '$1. $2');

  // Ajouter une pause avant "par exemple"
  enhanced = enhanced.replace(/\s+(par exemple)/gi, ', $1');

  return enhanced;
};

/**
 * Main function: prepare text for TTS by converting LaTeX and enhancing punctuation
 */
export const prepareTextForSpeech = (text: string): string => {
  // 1. Convertir le LaTeX en français parlé
  let prepared = convertLatexToSpeech(text);
  
  // 2. Améliorer la ponctuation
  prepared = enhancePunctuation(prepared);
  
  // 3. Normaliser les espaces
  prepared = prepared.replace(/\s{2,}/g, ' ').trim();
  
  return prepared;
};
