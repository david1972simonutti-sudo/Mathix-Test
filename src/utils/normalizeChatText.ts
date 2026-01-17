// Extended version of normalizeChatText with additional patterns
// CORRECTED: Added pattern for fracu(x)v(x) WITHOUT SPACE

export const normalizeChatText = (content: string): string => {
  if (!content) return content;
  
  let normalized = content;
  
  // ===== PROTECT SPECIAL BLOCKS (TABLEAU_JSON, ARBRE_JSON) FIRST =====
  // These blocks contain JSON and must NOT be processed
  const specialBlocks: { placeholder: string; content: string }[] = [];
  const specialBlockRegex = /:::(TABLEAU_JSON|ARBRE_JSON)[\s\S]*?:::/g;
  let blockIndex = 0;
  
  normalized = normalized.replace(specialBlockRegex, (match) => {
    const placeholder = `__SPECIAL_BLOCK_${blockIndex++}__`;
    specialBlocks.push({ placeholder, content: match });
    return placeholder;
  });
  
  // 🔧 FIX: Convertir les retours à la ligne échappés en vrais retours à la ligne
  // Gemini renvoie parfois \\n au lieu de \n
  normalized = normalized.replace(/\\n/g, '\n');
  
  // ===== CLEAN UP LINE BREAKS AND SPACING FIRST =====
  // Remove excessive spaces around formulas
  normalized = normalized.replace(/\s{2,}\$/g, ' $');
  normalized = normalized.replace(/\$\s{2,}/g, '$ ');
  // Normalize line breaks around block math
  normalized = normalized.replace(/\n{2,}\$\$\$/g, '\n\n$$');
  normalized = normalized.replace(/\$\$\$\n{2,}/g, '$$\n\n');
  // Remove space before punctuation
  normalized = normalized.replace(/\s+([.,;:!?])/g, '$1');
  // Add space after punctuation if missing
  normalized = normalized.replace(/([.,;:!?])([a-zA-Z])/g, '$1 $2');
  
  // ===== NORMALIZE TYPOGRAPHIC CHARACTERS =====
  normalized = normalized.replace(/[\u2212\u2013\u2014]/g, '-');
  normalized = normalized.replace(/[\u2019]/g, "'");
  normalized = normalized.replace(/ {3,}/g, '  ');
  
  // ===== PROTECT ALREADY WELL-FORMED LATEX =====
  const protectedSections: { start: number; end: number }[] = [];
  const mathRegex = /(\$\$[\s\S]+?\$\$|\$[^$\n]+?\$)/g;
  let match;
  
  while ((match = mathRegex.exec(normalized)) !== null) {
    protectedSections.push({
      start: match.index,
      end: match.index + match[0].length
    });
  }
  
  // Process the string in chunks, skipping protected sections
  let result = '';
  let lastIndex = 0;
  
  for (const section of protectedSections) {
    const chunk = normalized.substring(lastIndex, section.start);
    result += processChunk(chunk);
    result += normalized.substring(section.start, section.end);
    lastIndex = section.end;
  }
  result += processChunk(normalized.substring(lastIndex));
  
  // ===== RESTORE SPECIAL BLOCKS AT THE END =====
  for (const block of specialBlocks) {
    result = result.replace(block.placeholder, block.content);
  }
  
  return result;
};

// Process a chunk of text that's NOT in math mode
function processChunk(text: string): string {
  let processed = text;
  
  // ===== FRENCH MATHEMATICAL EXPRESSIONS =====
  
  // "y égale x au carré" → $y = x^2$
  processed = processed.replace(
    /\b([a-z])\s+(?:égale?|est égale? à)\s+([a-z])\s+au\s+carré/gi,
    '$$$1 = $2^2$$'
  );
  
  // "x carré" or "x au carré" → $x^2$
  processed = processed.replace(
    /\b([a-z])\s+(?:au\s+)?carré/gi,
    '$$$1^2$$'
  );
  
  // "x cube" or "x au cube" → $x^3$
  processed = processed.replace(
    /\b([a-z])\s+(?:au\s+)?cube/gi,
    '$$$1^3$$'
  );
  
  // "x puissance n" → $x^n$
  processed = processed.replace(
    /\b([a-z])\s+puissance\s+([a-z0-9]+)/gi,
    '$$$1^{$2}$$'
  );
  
  // "racine de x" or "racine carrée de x" → $\sqrt{x}$
  processed = processed.replace(
    /racine\s+(?:carrée\s+)?de\s+([a-z0-9]+)/gi,
    '$\\sqrt{$1}$'
  );
  
  // "racine nième de x" or "racine n de x" → $\sqrt[n]{x}$
  processed = processed.replace(
    /racine\s+([a-z0-9]+)(?:ième)?\s+de\s+([a-z0-9]+)/gi,
    '$\\sqrt[$1]{$2}$'
  );
  
  // "f de x" or "fonction f de x" → $f(x)$
  // ⚠️ STRICT: Only capture single letters followed by parentheses or space+letter (not articles)
  processed = processed.replace(
    /\b(?:fonction\s+)?([a-z])\s+de\s+([a-z])(?=\s*[\(]|$|\s+[A-Z])/gi,
    '$$$1($2)$$'
  );
  
  // "a sur b" (fraction) → $\frac{a}{b}$ - Only for SINGLE LETTERS or NUMBERS
  // Exclude any words (2+ letters) to avoid transforming natural language like "ner sur les"
  // Valid: "1 sur 2", "a sur b", "x sur y", "12 sur 5"
  // Invalid: "ner sur les", "un sur le", "er sur la"
  const frenchWords = ['un', 'le', 'la', 'de', 'du', 'en', 'et', 'ou', 'ne', 'ni', 'si', 'ce', 'se', 'me', 'te', 'je', 'tu', 'il', 'on', 'ma', 'ta', 'sa', 'au', 'ay', 'es', 'as', 'ai', 'va', 'vu', 'lu', 'su', 'eu', 'bu', 'nu', 'mu', 'pu', 'ru', 'us', 'ut', 'os', 'or', 'oh', 'eh', 'ah', 'ha', 'ho', 'hi', 'fi', 'pi', 'do', 're', 'mi', 'fa', 'sol', 'ner', 'les', 'des', 'ces', 'ses', 'mes', 'tes', 'nos', 'vos', 'aux', 'une', 'ton', 'son', 'mon', 'qui', 'que', 'par', 'sur', 'pour', 'avec', 'dans', 'sans', 'sous', 'vers', 'chez', 'donc', 'mais', 'car'];
  processed = processed.replace(
    /\b([a-z0-9]{1,3})\s+sur\s+([a-z0-9]{1,3})\b/gi,
    (match, num, den) => {
      const numLower = num.toLowerCase();
      const denLower = den.toLowerCase();
      // Only convert if BOTH are single letters OR numbers (not French words)
      const isNumValid = /^\d+$/.test(num) || (num.length === 1 && /^[a-z]$/i.test(num));
      const isDenValid = /^\d+$/.test(den) || (den.length === 1 && /^[a-z]$/i.test(den));
      if (isNumValid && isDenValid && !frenchWords.includes(numLower) && !frenchWords.includes(denLower)) {
        return `$\\frac{${num}}{${den}}$`;
      }
      return match; // Keep original text
    }
  );
  
  // "dérivée de f" → $f'$ (mais PAS "dérivée de la/le/l'")
  processed = processed.replace(
    /dérivée\s+de\s+(?!la\b|le\b|l')([a-z])\b/gi,
    "$$$1'$$"
  );
  
  // "f prime de x" → $f'(x)$
  processed = processed.replace(
    /\b([a-z])\s+prime\s+de\s+([a-z])/gi,
    "$$$1'($2)$$"
  );
  
  // ===== FUNCTION COMPOSITION =====
  
  // Circle notation: f∘g → $f \circ g$
  processed = processed.replace(
    /([a-zA-Z])∘([a-zA-Z])/g,
    '$$$1 \\circ $2$$'
  );
  
  // Text notation: fog, gof → $f \circ g$ (only before parentheses or equals)
  processed = processed.replace(
    /\b([a-z])o([a-z])\b(?=\s*[\(=])/g,
    '$$$1 \\circ $2$$'
  );
  
  // Explicit: "f composée g" or "f compose g" → $f \circ g$
  processed = processed.replace(
    /([a-zA-Z])\s+(?:composée?|compose)\s+([a-zA-Z])/gi,
    '$$$1 \\circ $2$$'
  );
  
  // ===== FRAC PATTERNS =====
  
  // 🔴 CRITICAL: fracu(x)v(x) WITHOUT SPACE - Must be FIRST to catch before other patterns
  // This catches: fracu(x)v(x), fracu'(x)v'(x), etc.
  // ⚠️ IMPORTANT: Exclude French words starting with "frac" (fraction, fracture, fracas, etc.)
  processed = processed.replace(
    /\bfrac(?!tion|ture|as|tionner|tionnel)([a-zA-Z]+(?:'*)(?:\([^)]*\))?)([a-zA-Z]+(?:'*)(?:\([^)]*\))?)/gi,
    '$\\frac{$1}{$2}$'
  );
  
  // frac(a)(b) → $\frac{a}{b}$
  processed = processed.replace(
    /\bfrac\s*\(\s*([^)]+?)\s*\)\s*\(\s*([^)]+?)\s*\)/gi,
    '$\\frac{$1}{$2}$'
  );
  
  // frac{a}{b} where frac is not escaped → $\frac{a}{b}$
  processed = processed.replace(
    /(?<!\\)\bfrac\s*\{([^}]+)\}\s*\{([^}]+)\}/gi,
    '$\\frac{$1}{$2}$'
  );
  
  // frac with function calls WITH SPACE: frac u'(x) v'(x) → $\frac{u'(x)}{v'(x)}$
  processed = processed.replace(
    /\bfrac\s+([a-zA-Z]+(?:'*)\s*\([^)]*\))\s+([a-zA-Z]+(?:'*)\s*\([^)]*\))/gi,
    '$\\frac{$1}{$2}$'
  );
  
  // frac with simple tokens: frac a b → $\frac{a}{b}$
  processed = processed.replace(
    /\bfrac\s+([a-zA-Z]+(?:'*))\s+([a-zA-Z]+(?:'*))\b/gi,
    '$\\frac{$1}{$2}$'
  );
  
  // frac with numbers: frac 1 2 → $\frac{1}{2}$
  processed = processed.replace(
    /\bfrac\s+(\d+(?:[.,]\d+)?)\s+(\d+(?:[.,]\d+)?)/g,
    '$\\frac{$1}{$2}$'
  );
  
  // frac with mixed: frac5x+2121-x, fracn!k!(n-k)! → $\frac{...}{...}$
  processed = processed.replace(
    /\bfrac([\d\w\s+\-!()^*\/]+?)([\d\w\s+\-!()^*\/]+?)(?=\s|$|[.,;?:])/gi,
    (match, num, den) => {
      // Only if it looks like a valid fraction (contains at least one alphanumeric)
      if (num && den && /[\da-z]/i.test(num) && /[\da-z]/i.test(den)) {
        return `$\\frac{${num}}{${den}}$`;
      }
      return match;
    }
  );
  
  // ===== DERIVATIVES AND DIFFERENTIALS =====
  
  // df/dx → $\frac{df}{dx}$
  processed = processed.replace(
    /d([a-zA-Z])\/d([a-zA-Z])/g,
    '$\\frac{d$1}{d$2}$'
  );
  
  // d²f/dx² → $\frac{d^2f}{dx^2}$
  processed = processed.replace(
    /d²([a-zA-Z])\/d([a-zA-Z])²/g,
    '$\\frac{d^2$1}{d$2^2}$'
  );
  
  // Partial derivative: ∂f/∂x → $\frac{\partial f}{\partial x}$
  processed = processed.replace(
    /∂([a-zA-Z])\/∂([a-zA-Z])/g,
    '$\\frac{\\partial $1}{\\partial $2}$'
  );
  
  // ===== LIMITS =====
  
  // lim x->0, lim x→0 → $\lim_{x \to 0}$
  processed = processed.replace(
    /\blim\s+([a-z])\s*(?:->|→)\s*([^\s,;.!?]+)/gi,
    '$\\lim_{$1 \\to $2}$'
  );
  
  // ===== INTEGRALS =====
  
  // int_a^b f(x)dx → $\int_a^b f(x)dx$
  processed = processed.replace(
    /\bint_([^\s^]+)\^([^\s]+)\s+([^\s]+(?:\s*d[a-z])?)/gi,
    '$\\int_{$1}^{$2} $3$'
  );
  
  // Simple integral: int f(x)dx → $\int f(x)dx$
  // ⚠️ IMPORTANT: Ne pas matcher "int" au milieu d'un mot (ex: "Interprète")
  // On exige que "int" soit suivi d'un espace avant l'expression
  processed = processed.replace(
    /\bint\s+([a-zA-Z]+(?:'*)(?:\([^)]*\))?(?:\s*[a-zA-Z]+(?:'*)(?:\([^)]*\))?)*)(?:\s*,?\s*dx)?/gi,
    '$\\int $1$'
  );
  
  // Integral with bounds at end: intb_a → $\int_a^b$
  processed = processed.replace(
    /\bint([a-z])_([a-z])/gi,
    '$\\int_{$2}^{$1}$'
  );
  
  // ===== SUMMATIONS AND PRODUCTS =====
  
  // sum_{k=0}^{n} → $\sum_{k=0}^{n}$
  processed = processed.replace(
    /\bsum_\{([^}]+)\}\^\{([^}]+)\}/gi,
    '$\\sum_{$1}^{$2}$'
  );
  
  // Σ symbol → $\sum$
  processed = processed.replace(/Σ/g, '$\\sum$');
  
  // Product symbol: ∏ → $\prod$
  processed = processed.replace(/∏/g, '$\\prod$');
  
  // ===== VECTORS =====
  
  // vec u, vec AB → $\vec{u}$, $\overrightarrow{AB}$
  processed = processed.replace(
    /\bvec\s+([a-zA-Z]{1,2})\b/g,
    (_, v) => v.length === 1 ? `$\\vec{${v}}$` : `$\\overrightarrow{${v}}$`
  );
  
  // Arrow notation: AB→
  processed = processed.replace(
    /([A-Z]{1,2})→/g,
    (_, v) => v.length === 1 ? `$\\vec{${v}}$` : `$\\overrightarrow{${v}}$`
  );
  
  // Norm: ||u|| → $\|u\|$
  processed = processed.replace(
    /\|\|([^|]+)\|\|/g,
    '$\\|$1\\|$'
  );
  
  // ===== EXPONENTS AND SUBSCRIPTS =====
  
  // x^2, x^n → $x^2$, $x^n$ (but be careful with context)
  processed = processed.replace(
    /([a-zA-Z])(\^)([0-9a-zA-Z]+)\b/g,
    '$$$1^{$3}$$'
  );
  
  // x_0, x_i → $x_0$, $x_i$
  processed = processed.replace(
    /([a-zA-Z])_([0-9a-zA-Z]+)\b/g,
    '$$$1_{$2}$$'
  );
  
  // ===== MATHEMATICAL SETS =====
  
  // R, N, Z, Q, C → $\mathbb{R}$, etc. (only when followed by special context)
  processed = processed.replace(
    /\b([RNZQC])\b(?=\s*[,;.]|\s+(?:tel|où|avec|pour|dans))/g,
    '$\\mathbb{$1}$'
  );
  
  // Set operations
  processed = processed.replace(/∪/g, '$\\cup$');      // Union
  processed = processed.replace(/∩/g, '$\\cap$');      // Intersection
  processed = processed.replace(/∅/g, '$\\emptyset$'); // Empty set
  processed = processed.replace(/⊂/g, '$\\subset$');   // Subset
  processed = processed.replace(/⊆/g, '$\\subseteq$'); // Subset or equal
  
  // ===== SPECIAL SYMBOLS =====
  
  // Arithmetic
  processed = processed.replace(/\s×\s/g, ' $\\times$ ');
  processed = processed.replace(/\s÷\s/g, ' $\\div$ ');
  processed = processed.replace(/±/g, '$\\pm$');
  processed = processed.replace(/∓/g, '$\\mp$');
  
  // Comparisons
  processed = processed.replace(/≠/g, '$\\neq$');
  processed = processed.replace(/≤/g, '$\\leq$');
  processed = processed.replace(/≥/g, '$\\geq$');
  processed = processed.replace(/≈/g, '$\\approx$');
  processed = processed.replace(/≡/g, '$\\equiv$');
  processed = processed.replace(/∝/g, '$\\propto$');
  
  // Logic
  processed = processed.replace(/∴/g, '$\\therefore$');
  processed = processed.replace(/∵/g, '$\\because$');
  processed = processed.replace(/⇒/g, '$\\Rightarrow$');
  processed = processed.replace(/⇔/g, '$\\Leftrightarrow$');
  processed = processed.replace(/∧/g, '$\\wedge$');
  processed = processed.replace(/∨/g, '$\\vee$');
  processed = processed.replace(/¬/g, '$\\neg$');
  processed = processed.replace(/∀/g, '$\\forall$');
  processed = processed.replace(/∃/g, '$\\exists$');
  
  // Geometry
  processed = processed.replace(/∠/g, '$\\angle$');
  processed = processed.replace(/⊥/g, '$\\perp$');
  processed = processed.replace(/∥/g, '$\\parallel$');
  processed = processed.replace(/°/g, '$^\\circ$');
  
  // Membership and other
  processed = processed.replace(/∈/g, '$\\in$');
  processed = processed.replace(/∉/g, '$\\notin$');
  processed = processed.replace(/∞/g, '$\\infty$');
  
  return processed;
}

