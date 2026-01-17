import "katex/dist/katex.min.css";
import { InlineMath, BlockMath } from "react-katex";

interface MathTextProps {
  content: string;
  className?: string;
  mode?: "strict" | "lenient";
  auto?: {
    intervals?: boolean;
    functions?: boolean;
    variables?: boolean;
    pi?: boolean;
    sqrt?: boolean;
    degrees?: boolean;
    greek?: boolean;
  };
  centerBlocks?: boolean;
  preserveLineBreaks?: boolean;
}

// Fonction de log pour le debug
const visualLog = (category: string, label: string, data: any) => {
  if (process.env.NODE_ENV === 'development') {
    console.log(`[${category}] ${label}:`, data);
  }
};


export const MathText = ({
  content,
  className = "",
  mode = "strict",
  auto = {},
  centerBlocks = false,
  preserveLineBreaks = false,
}: MathTextProps) => {
  if (!content) return null;

  let cleanedContent = content;

  // Normaliser les délimiteurs LaTeX SEULEMENT
  cleanedContent = cleanedContent
    .replace(/\\\(([\s\S]*?)\\\)/g, "$$$1$$")
    .replace(/\\\[([\s\S]*?)\\\]/g, "$$$$$$1$$$$");

  // Tokeniser le contenu en segments texte et math
  const segments: Array<{ type: "text" | "math"; content: string; isBlock: boolean }> = [];
  const mathRegex = /(\$\$[\s\S]+?\$\$|\$[^\n$]+?\$)/g;
  let lastIndex = 0;
  let match;

  while ((match = mathRegex.exec(cleanedContent)) !== null) {
    // Ajouter le texte avant le math
    if (match.index > lastIndex) {
      segments.push({
        type: "text",
        content: cleanedContent.substring(lastIndex, match.index),
        isBlock: false,
      });
    }

    // Ajouter le segment math
    const mathContent = match[1];
    const isBlock = mathContent.startsWith("$$");
    segments.push({
      type: "math",
      content: mathContent,
      isBlock,
    });

    lastIndex = match.index + mathContent.length;
  }

  // Ajouter le texte restant
  if (lastIndex < cleanedContent.length) {
    segments.push({
      type: "text",
      content: cleanedContent.substring(lastIndex),
      isBlock: false,
    });
  }

  // Rendu des segments
  const parts: JSX.Element[] = [];
  let key = 0;

  const renderTextWithBold = (text: string) => {
    // on coupe sur les ** ... ** (paire la plus simple)
    const parts = text.split(/(\*\*[^*]+\*\*)/g);
    return parts.map((part, i) => {
      if (part.startsWith("**") && part.endsWith("**")) {
        return <strong key={i}>{part.slice(2, -2)}</strong>;
      }
      return part;
    });
  };

  segments.forEach((segment) => {
    if (segment.type === "math") {
      try {
        if (segment.isBlock) {
          // Block math: $$...$$
          let formula = segment.content.slice(2, -2).trim();
          
          // ✅ FIX: PAS de normalisation, normalizeChatText a déjà fait le travail
          // Le contenu est déjà propre, on l'envoie directement à KaTeX
          
          parts.push(
            <div
              key={`math-${key++}`}
              className={`my-4 w-full max-w-full overflow-x-auto no-scrollbar ${centerBlocks ? "flex justify-center" : ""}`}
            >
              <div className="w-fit max-w-full">
                <BlockMath math={formula} />
              </div>
            </div>,
          );
        } else {
          // Inline math: $...$
          let formula = segment.content.slice(1, -1).trim();

          // ✅ FIX: PAS de normalisation, normalizeChatText a déjà fait le travail

          // NEW: détecter une formule "haute"
          const isTallInline = /\\(d?frac|tfrac|sqrt|sum|int)\b/.test(formula);

          visualLog("mathtext", "INLINE MATH envoyé à KaTeX", formula);

          parts.push(
            <span
              key={`math-${key++}`}
              className={`math-inline ${isTallInline ? "math-inline--tall" : ""} mx-0.5 inline align-middle`}
              style={{ verticalAlign: "middle", whiteSpace: "nowrap" }}
            >
              <InlineMath math={formula} />
            </span>
          );
        }
      } catch (error) {
        // En cas d'erreur, afficher proprement
        console.error("❌ KaTeX Error:", error, "\nFormula:", segment.content);
        
        parts.push(
          <span
            key={`math-error-${key++}`}
            className="inline-block text-red-600 bg-red-50 px-2 py-1 rounded font-mono text-sm"
            title={`Erreur LaTeX: ${error}`}
          >
            {segment.content}
          </span>
        );
      }
    } else {
      // Segment texte
      parts.push(
        <span key={`text-${key++}`}>
          {renderTextWithBold(segment.content)}
        </span>
      );
    }
  });

  return (
    <div
      className={`math-text leading-relaxed whitespace-pre-line w-full max-w-full ${className}`}
      style={{
        lineHeight: "1.6",
        overflowWrap: "anywhere",
        wordBreak: "normal",
      }}
    >
      {parts}
    </div>
  );
};