import "katex/dist/katex.min.css";
import { InlineMath, BlockMath } from "react-katex";
import { useState } from "react";

interface MathTextDebugProps {
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

// Version DEBUG du composant MathText
export const MathTextDebug = ({
  content,
  className = "",
  mode = "strict",
  auto = {},
  centerBlocks = false,
  preserveLineBreaks = false,
}: MathTextDebugProps) => {
  const [showDebug, setShowDebug] = useState(false);

  if (!content) return null;

  // Afficher le contenu brut pour debug
  const debugInfo = {
    rawContent: content,
    contentLength: content.length,
    hasDoubleBackslash: content.includes("\\\\"),
    hasSingleBackslash: content.includes("\\") && !content.includes("\\\\"),
    encoding: [...content].map(char => `${char} (U+${char.charCodeAt(0).toString(16).toUpperCase().padStart(4, '0')})`),
    mathDelimiters: {
      hasSingleDollar: content.includes("$") && !content.includes("$$"),
      hasDoubleDollar: content.includes("$$"),
      hasBackslashParen: content.includes("\\(") || content.includes("\\)"),
      hasBackslashBracket: content.includes("\\[") || content.includes("\\]"),
    },
    suspiciousPatterns: {
      doubleBackslashFrac: content.match(/\\\\frac/g)?.length || 0,
      spaceInCommand: content.match(/\\\s+[a-z]/g)?.length || 0,
      unmatchedBraces: (content.match(/\{/g)?.length || 0) - (content.match(/\}/g)?.length || 0),
      unmatchedDollars: (content.match(/\$/g)?.length || 0) % 2,
    }
  };

  // Normalisation (version simplifiée pour debug)
  let normalized = content.trim();
  
  // Fix double backslashes
  const beforeBackslashFix = normalized;
  normalized = normalized.replace(/\\\\(?=[a-zA-Z])/g, "\\");
  const afterBackslashFix = normalized;

  // Fix spaces in commands
  const beforeSpaceFix = normalized;
  normalized = normalized.replace(/\\\s+(frac|sin|cos|tan|sqrt|pi|left|right|sum|prod|int|lim)/g, '\\$1');
  const afterSpaceFix = normalized;

  // Extract math formulas
  const mathMatches = [...normalized.matchAll(/(\$\$[\s\S]+?\$\$|\$[^\n$]+?\$)/g)];

  return (
    <div className={`relative ${className}`}>
      {/* Bouton Debug */}
      <button
        onClick={() => setShowDebug(!showDebug)}
        className="absolute top-0 right-0 bg-blue-500 text-white px-2 py-1 rounded text-xs z-10"
      >
        {showDebug ? "🔍 Masquer Debug" : "🔍 Debug"}
      </button>

      {/* Panel Debug */}
      {showDebug && (
        <div className="mb-4 p-4 bg-yellow-50 border-2 border-yellow-400 rounded-lg text-xs font-mono overflow-auto max-h-96">
          <h3 className="font-bold text-lg mb-2 text-yellow-900">🐛 DEBUG INFO</h3>
          
          <div className="space-y-3">
            <div>
              <strong className="text-red-600">Raw Content:</strong>
              <pre className="bg-white p-2 rounded mt-1 overflow-x-auto">{content}</pre>
            </div>

            <div>
              <strong className="text-red-600">Content Length:</strong> {debugInfo.contentLength} chars
            </div>

            <div>
              <strong className="text-red-600">Encoding (first 200 chars):</strong>
              <pre className="bg-white p-2 rounded mt-1 overflow-x-auto text-xs">
                {debugInfo.encoding.slice(0, 50).join('\n')}
              </pre>
            </div>

            <div>
              <strong className="text-red-600">Backslashes:</strong>
              <ul className="list-disc ml-4">
                <li>Double backslash (\\): {debugInfo.hasDoubleBackslash ? '❌ YES' : '✅ NO'}</li>
                <li>Single backslash (\): {debugInfo.hasSingleBackslash ? '✅ YES' : '❌ NO'}</li>
              </ul>
            </div>

            <div>
              <strong className="text-red-600">Math Delimiters:</strong>
              <ul className="list-disc ml-4">
                <li>Single $: {debugInfo.mathDelimiters.hasSingleDollar ? '✅ YES' : '❌ NO'}</li>
                <li>Double $$: {debugInfo.mathDelimiters.hasDoubleDollar ? '✅ YES' : '❌ NO'}</li>
                <li>\(...\): {debugInfo.mathDelimiters.hasBackslashParen ? '✅ YES' : '❌ NO'}</li>
                <li>\[...\]: {debugInfo.mathDelimiters.hasBackslashBracket ? '✅ YES' : '❌ NO'}</li>
              </ul>
            </div>

            <div>
              <strong className="text-red-600">Suspicious Patterns:</strong>
              <ul className="list-disc ml-4">
                <li>\\frac (should be \frac): {debugInfo.suspiciousPatterns.doubleBackslashFrac > 0 ? `❌ ${debugInfo.suspiciousPatterns.doubleBackslashFrac} found` : '✅ OK'}</li>
                <li>Space in commands (\ frac): {debugInfo.suspiciousPatterns.spaceInCommand > 0 ? `❌ ${debugInfo.suspiciousPatterns.spaceInCommand} found` : '✅ OK'}</li>
                <li>Unmatched braces: {debugInfo.suspiciousPatterns.unmatchedBraces !== 0 ? `❌ ${debugInfo.suspiciousPatterns.unmatchedBraces}` : '✅ OK'}</li>
                <li>Unmatched dollars: {debugInfo.suspiciousPatterns.unmatchedDollars !== 0 ? `❌ Odd number` : '✅ OK'}</li>
              </ul>
            </div>

            {beforeBackslashFix !== afterBackslashFix && (
              <div>
                <strong className="text-red-600">Backslash Fix Applied:</strong>
                <pre className="bg-white p-2 rounded mt-1">Before: {beforeBackslashFix.substring(0, 100)}...</pre>
                <pre className="bg-green-100 p-2 rounded mt-1">After: {afterBackslashFix.substring(0, 100)}...</pre>
              </div>
            )}

            {beforeSpaceFix !== afterSpaceFix && (
              <div>
                <strong className="text-red-600">Space Fix Applied:</strong>
                <pre className="bg-white p-2 rounded mt-1">Before: {beforeSpaceFix.substring(0, 100)}...</pre>
                <pre className="bg-green-100 p-2 rounded mt-1">After: {afterSpaceFix.substring(0, 100)}...</pre>
              </div>
            )}

            <div>
              <strong className="text-red-600">Math Formulas Found:</strong> {mathMatches.length}
              {mathMatches.map((match, idx) => (
                <div key={idx} className="mt-2">
                  <div className="text-xs text-gray-600">Formula {idx + 1}:</div>
                  <pre className="bg-blue-50 p-2 rounded overflow-x-auto">{match[0]}</pre>
                  <div className="text-xs text-gray-600 mt-1">
                    Type: {match[0].startsWith('$$') ? 'Block Math' : 'Inline Math'}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Contenu normal (essayer de rendre) */}
      <div className="p-4 bg-white border rounded">
        <div className="text-xs text-gray-500 mb-2">Attempting to render:</div>
        <div className="text-red-600 font-mono text-sm break-all mb-2">
          {content}
        </div>
        
        {mathMatches.length > 0 ? (
          <div className="space-y-2">
            {mathMatches.map((match, idx) => {
              const formula = match[0];
              const isBlock = formula.startsWith('$$');
              const cleanFormula = isBlock 
                ? formula.slice(2, -2).trim() 
                : formula.slice(1, -1).trim();

              try {
                return (
                  <div key={idx} className="p-2 bg-green-50 rounded">
                    <div className="text-xs text-green-600 mb-1">✅ Rendered successfully:</div>
                    {isBlock ? (
                      <BlockMath math={cleanFormula} />
                    ) : (
                      <InlineMath math={cleanFormula} />
                    )}
                  </div>
                );
              } catch (error) {
                return (
                  <div key={idx} className="p-2 bg-red-50 rounded">
                    <div className="text-xs text-red-600 mb-1">❌ Render error:</div>
                    <pre className="text-xs">{String(error)}</pre>
                    <pre className="text-xs mt-2 bg-white p-1 rounded">Formula: {cleanFormula}</pre>
                  </div>
                );
              }
            })}
          </div>
        ) : (
          <div className="text-gray-500 italic">No math formulas detected in content</div>
        )}
      </div>
    </div>
  );
};

// Composant simple pour tester une formule spécifique
export const QuickTest = () => {
  const [testContent, setTestContent] = useState("$f(x) = \\frac{x^2 + 3x}{x + 1}$");

  return (
    <div className="max-w-4xl mx-auto p-8">
      <h1 className="text-2xl font-bold mb-4">🧪 Test Rapide MathText</h1>
      
      <div className="mb-4">
        <label className="block text-sm font-medium mb-2">
          Collez le contenu problématique ici:
        </label>
        <textarea
          value={testContent}
          onChange={(e) => setTestContent(e.target.value)}
          className="w-full p-3 border rounded font-mono text-sm"
          rows={5}
        />
      </div>

      <MathTextDebug content={testContent} mode="lenient" />

      <div className="mt-8 p-4 bg-blue-50 rounded">
        <h3 className="font-bold mb-2">📋 Tests Prédéfinis:</h3>
        <div className="space-y-2">
          <button
            onClick={() => setTestContent("$f(x) = \\frac{x^2 + 3x}{x + 1}$")}
            className="block w-full text-left px-3 py-2 bg-white rounded hover:bg-gray-100"
          >
            Test 1: Formule normale (correct)
          </button>
          <button
            onClick={() => setTestContent("$f(x) = \\\\frac{x^2 + 3x}{x + 1}$")}
            className="block w-full text-left px-3 py-2 bg-white rounded hover:bg-gray-100"
          >
            Test 2: Double backslash (erreur Gemini)
          </button>
          <button
            onClick={() => setTestContent("$f(x) = \\ frac{x^2 + 3x}{x + 1}$")}
            className="block w-full text-left px-3 py-2 bg-white rounded hover:bg-gray-100"
          >
            Test 3: Espace dans commande
          </button>
          <button
            onClick={() => setTestContent("$f(x) = frac{x^2 + 3x}{x + 1}$")}
            className="block w-full text-left px-3 py-2 bg-white rounded hover:bg-gray-100"
          >
            Test 4: Sans backslash
          </button>
        </div>
      </div>
    </div>
  );
};

export default MathTextDebug;
