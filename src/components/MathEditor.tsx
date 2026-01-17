import { useRef, useState } from "react";
import { Button } from "@/components/ui/button";
import { Calculator, X } from "lucide-react";
import "mathlive";

interface MathEditorProps {
  onInsert: (latex: string) => void;
  onClose: () => void;
}

export const MathEditor = ({ onInsert, onClose }: MathEditorProps) => {
  const mfRef = useRef<any>(null);
  const [activeTab, setActiveTab] = useState("basique");
  const [hasContent, setHasContent] = useState(false);

  // Définition des boutons de symboles
  const keyboards = {
    basique: [
      { latex: "\\frac{#?}{#?}", display: "𝑎/𝑏", label: "fraction" },
      { latex: "\\sqrt{#?}", display: "√", label: "racine" },
      { latex: "^{#?}", display: "x²", label: "puissance" },
      { latex: "_{#?}", display: "xᵢ", label: "indice" },
      { latex: "\\pi", display: "π", label: "pi" },
      { latex: "\\infty", display: "∞", label: "infini" },
      { latex: "\\times", display: "×", label: "fois" },
      { latex: "\\div", display: "÷", label: "divise" },
      { latex: "\\leq", display: "≤", label: "≤" },
      { latex: "\\geq", display: "≥", label: "≥" },
      { latex: "\\neq", display: "≠", label: "≠" },
      { latex: "\\approx", display: "≈", label: "≈" },
      { latex: "(", display: "(", label: "(" },
      { latex: ")", display: ")", label: ")" },
      { latex: "[", display: "[", label: "[" },
      { latex: "]", display: "]", label: "]" },
      { latex: "\\{", display: "{", label: "{" },
      { latex: "\\}", display: "}", label: "}" },
    ],
    fonctions: [
      { latex: "\\sin(#?)", display: "sin", label: "sinus" },
      { latex: "\\cos(#?)", display: "cos", label: "cosinus" },
      { latex: "\\tan(#?)", display: "tan", label: "tangente" },
      { latex: "\\ln(#?)", display: "ln", label: "ln" },
      { latex: "\\log(#?)", display: "log", label: "log" },
      { latex: "e^{#?}", display: "eˣ", label: "exp" },
      { latex: "\\lim_{#?\\to#?}", display: "lim", label: "limite" },
      { latex: "\\sum_{#?}^{#?}", display: "∑", label: "somme" },
      { latex: "\\int_{#?}^{#?}", display: "∫", label: "intégrale" },
      { latex: "\\frac{d}{dx}", display: "d/dx", label: "dérivée" },
    ],
    vecteurs: [
      { latex: "\\vec{#?}", display: "v⃗", label: "vecteur" },
      { latex: "\\overrightarrow{#?}", display: "AB⃗", label: "vecteur nommé" },
      { latex: "\\begin{pmatrix}#?\\\\#?\\end{pmatrix}", display: "(x,y)", label: "vecteur colonne 2D" },
      { latex: "\\begin{pmatrix}#?\\\\#?\\\\#?\\end{pmatrix}", display: "(x,y,z)", label: "vecteur colonne 3D" },
      { latex: "\\angle", display: "∠", label: "angle" },
      { latex: "\\parallel", display: "∥", label: "parallèle" },
      { latex: "\\perp", display: "⊥", label: "perpendiculaire" },
      { latex: "\\triangle", display: "△", label: "triangle" },
      { latex: "\\cdot", display: "·", label: "produit scalaire" },
      { latex: "\\circ", display: "∘", label: "composition" },
    ],
    suites: [
      { latex: "u_{n}", display: "uₙ", label: "suite un" },
      { latex: "u_{n+1}", display: "uₙ₊₁", label: "suite un+1" },
      { latex: "\\sum_{n=0}^{+\\infty}", display: "Σ∞", label: "somme infinie" },
      { latex: "n!", display: "n!", label: "factorielle" },
      { latex: "P(#?)", display: "P()", label: "probabilité" },
      { latex: "\\binom{#?}{#?}", display: "Cₙᵏ", label: "combinaison" },
      { latex: "\\in", display: "∈", label: "appartient" },
      { latex: "\\notin", display: "∉", label: "n'appartient pas" },
      { latex: "\\subset", display: "⊂", label: "inclus" },
      { latex: "\\cup", display: "∪", label: "union" },
      { latex: "\\cap", display: "∩", label: "intersection" },
    ],
    systemes: [
      { latex: "\\begin{cases}#?\\\\#?\\end{cases}", display: "{ 2 éq.", label: "système 2×2" },
      { latex: "\\begin{cases}#?\\\\#?\\\\#?\\end{cases}", display: "{ 3 éq.", label: "système 3×3" },
      { latex: "\\begin{cases}#?\\\\#?\\\\#?\\\\#?\\end{cases}", display: "{ 4 éq.", label: "système 4×4" },
      { latex: "\\Leftrightarrow", display: "⇔", label: "équivalent" },
      { latex: "\\Rightarrow", display: "⇒", label: "implique" },
    ],
  };

  const tabs = [
    { id: "basique", label: "Basique" },
    { id: "fonctions", label: "Fonctions" },
    { id: "vecteurs", label: "Vecteurs" },
    { id: "suites", label: "Suites" },
    { id: "systemes", label: "Systèmes" },
  ];

  // Fonction pour insérer un symbole dans le math-field
  const insertSymbol = (latex: string) => {
    if (mfRef.current) {
      // Utilise la commande MathLive pour insérer
      mfRef.current.executeCommand(["insert", latex]);
      // Garde le focus sur le math-field
      mfRef.current.focus();
    }
  };

  // Fonction pour insérer la formule complète dans le message
  const handleInsertFormula = () => {
    if (mfRef.current) {
      const latex = mfRef.current.value;
      if (latex) {
        onInsert(latex);
        // Vider le champ
        mfRef.current.value = "";
        setHasContent(false);
      }
    }
  };

  // Fonction pour effacer
  const handleClear = () => {
    if (mfRef.current) {
      mfRef.current.value = "";
      setHasContent(false);
      mfRef.current.focus();
    }
  };

  return (
    <div className="border-2 border-blue-200 rounded-lg bg-gradient-to-b from-blue-50 to-white p-4">
      <div className="max-w-5xl mx-auto">
        {/* En-tête */}
        <div className="flex justify-between items-center mb-3">
          <div className="flex items-center gap-2">
            <Calculator className="w-5 h-5 text-blue-600" />
            <span className="font-semibold text-blue-900">Éditeur de formule mathématique</span>
          </div>
          <Button variant="ghost" size="sm" onClick={onClose}>
            <X className="w-4 h-4" />
          </Button>
        </div>

        {/* Math-field (champ de saisie) */}
        <div className="mb-3 relative">
          <div className="text-xs text-gray-600 mb-1">
            💡 Tu peux taper au clavier OU cliquer sur les boutons ci-dessous
          </div>

          {/* Placeholder personnalisé */}
          {!hasContent && (
            <div className="absolute top-8 left-4 text-gray-400 pointer-events-none text-lg italic">
              Tape ta formule ou utilise les boutons...
            </div>
          )}

          <math-field
            ref={mfRef}
            onInput={(evt: any) => setHasContent(evt.target.value !== "")}
            class="w-full"
            style={{
              fontSize: "24px",
              minHeight: "80px",
              display: "block",
              padding: "16px",
              border: "2px solid #3b82f6",
              borderRadius: "8px",
              backgroundColor: "white",
            }}
          />
        </div>

        {/* Onglets */}
        <div className="mb-3">
          <div className="flex gap-1 border-b bg-gray-50 rounded-t-lg">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`px-4 py-2 font-medium transition-colors text-sm ${
                  activeTab === tab.id
                    ? "text-blue-600 border-b-2 border-blue-600 bg-white"
                    : "text-gray-600 hover:text-blue-600 hover:bg-gray-100"
                }`}
              >
                {tab.label}
              </button>
            ))}
          </div>

          {/* Grille de boutons */}
          <div className="bg-white border border-gray-200 rounded-b-lg p-3">
            <div
              className={`grid gap-2 ${
                activeTab === "basique"
                  ? "grid-cols-6"
                  : activeTab === "vecteurs"
                    ? "grid-cols-5"
                    : activeTab === "systemes"
                      ? "grid-cols-3"
                      : "grid-cols-5"
              }`}
            >
              {keyboards[activeTab as keyof typeof keyboards].map((btn, idx) => (
                <Button
                  key={idx}
                  variant="outline"
                  onClick={() => insertSymbol(btn.latex)}
                  className="h-12 text-lg font-semibold hover:bg-blue-50 hover:border-blue-400"
                  title={btn.label}
                >
                  {btn.display}
                </Button>
              ))}
            </div>
          </div>
        </div>

        {/* Boutons d'action */}
        <div className="flex gap-2">
          <Button variant="outline" onClick={handleClear} className="flex-1">
            Effacer
          </Button>
          <Button onClick={handleInsertFormula} className="flex-[2] bg-blue-600 hover:bg-blue-700">
            ✓ Insérer dans le message
          </Button>
        </div>
      </div>
    </div>
  );
};
