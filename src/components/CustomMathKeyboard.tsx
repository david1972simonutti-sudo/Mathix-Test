import { useState } from 'react';
import { Button } from '@/components/ui/button';

interface CustomMathKeyboardProps {
  onInsert: (latex: string) => void;
}

export const CustomMathKeyboard = ({ onInsert }: CustomMathKeyboardProps) => {
  const [activeTab, setActiveTab] = useState('basique');

  // Définition des boutons par catégorie
  const keyboards = {
    basique: [
      { latex: '\\frac{#?}{#?}', label: 'fraction', display: '𝑎/𝑏' },
      { latex: '\\sqrt{#?}', label: 'racine', display: '√' },
      { latex: '^{#?}', label: 'puissance', display: 'x²' },
      { latex: '_{#?}', label: 'indice', display: 'xᵢ' },
      { latex: '\\pi', label: 'pi', display: 'π' },
      { latex: '\\infty', label: 'infini', display: '∞' },
      { latex: '\\times', label: 'fois', display: '×' },
      { latex: '\\div', label: 'divise', display: '÷' },
      { latex: '\\leq', label: 'inférieur ou égal', display: '≤' },
      { latex: '\\geq', label: 'supérieur ou égal', display: '≥' },
      { latex: '\\neq', label: 'différent', display: '≠' },
      { latex: '\\approx', label: 'approximativement', display: '≈' },
      { latex: '(', label: 'parenthèse gauche', display: '(' },
      { latex: ')', label: 'parenthèse droite', display: ')' },
      { latex: '[', label: 'crochet gauche', display: '[' },
      { latex: ']', label: 'crochet droit', display: ']' },
      { latex: '\\{', label: 'accolade gauche', display: '{' },
      { latex: '\\}', label: 'accolade droite', display: '}' },
    ],
    fonctions: [
      { latex: '\\sin(#?)', label: 'sinus', display: 'sin' },
      { latex: '\\cos(#?)', label: 'cosinus', display: 'cos' },
      { latex: '\\tan(#?)', label: 'tangente', display: 'tan' },
      { latex: '\\ln(#?)', label: 'logarithme népérien', display: 'ln' },
      { latex: '\\log(#?)', label: 'logarithme', display: 'log' },
      { latex: 'e^{#?}', label: 'exponentielle', display: 'eˣ' },
      { latex: '\\lim_{#?\\to#?}', label: 'limite', display: 'lim' },
      { latex: '\\sum_{#?}^{#?}', label: 'somme', display: '∑' },
      { latex: '\\int_{#?}^{#?}', label: 'intégrale', display: '∫' },
      { latex: '\\frac{d}{dx}', label: 'dérivée', display: 'd/dx' },
    ],
    vecteurs: [
      { latex: '\\vec{#?}', label: 'vecteur', display: 'v⃗' },
      { latex: '\\overrightarrow{#?}', label: 'vecteur nommé', display: 'AB⃗' },
      { latex: '\\angle', label: 'angle', display: '∠' },
      { latex: '\\parallel', label: 'parallèle', display: '∥' },
      { latex: '\\perp', label: 'perpendiculaire', display: '⊥' },
      { latex: '\\triangle', label: 'triangle', display: '△' },
      { latex: '\\begin{pmatrix}#?\\\\#?\\end{pmatrix}', label: 'coordonnées', display: '(x,y)' },
      { latex: '\\cdot', label: 'produit scalaire', display: '·' },
      { latex: '\\circ', label: 'composition', display: '∘' },
    ],
    suites: [
      { latex: 'u_{n}', label: 'suite un', display: 'uₙ' },
      { latex: 'u_{n+1}', label: 'suite un+1', display: 'uₙ₊₁' },
      { latex: '\\sum_{n=0}^{+\\infty}', label: 'somme infinie', display: 'Σ∞' },
      { latex: 'n!', label: 'factorielle', display: 'n!' },
      { latex: 'P(#?)', label: 'probabilité', display: 'P()' },
      { latex: '\\binom{#?}{#?}', label: 'combinaison', display: 'Cₙᵏ' },
      { latex: '\\in', label: 'appartient', display: '∈' },
      { latex: '\\notin', label: 'n\'appartient pas', display: '∉' },
      { latex: '\\subset', label: 'inclus', display: '⊂' },
      { latex: '\\cup', label: 'union', display: '∪' },
      { latex: '\\cap', label: 'intersection', display: '∩' },
    ],
  };

  const tabs = [
    { id: 'basique', label: 'Basique' },
    { id: 'fonctions', label: 'Fonctions' },
    { id: 'vecteurs', label: 'Vecteurs' },
    { id: 'suites', label: 'Suites' },
  ];

  return (
    <div className="bg-white rounded-lg border border-gray-200">
      {/* Onglets */}
      <div className="flex gap-1 border-b bg-gray-50 rounded-t-lg">
        {tabs.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`px-4 py-2 font-medium transition-colors text-sm ${
              activeTab === tab.id
                ? 'text-blue-600 border-b-2 border-blue-600 bg-white'
                : 'text-gray-600 hover:text-blue-600 hover:bg-gray-100'
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Grille de boutons */}
      <div className="p-3">
        <div className={`grid gap-2 ${
          activeTab === 'basique' ? 'grid-cols-6' : 'grid-cols-5'
        }`}>
          {keyboards[activeTab as keyof typeof keyboards].map((btn, idx) => (
            <Button
              key={idx}
              variant="outline"
              onClick={() => onInsert(btn.latex)}
              className="h-12 text-lg font-semibold hover:bg-blue-50 hover:border-blue-400 transition-all"
              title={btn.label}
            >
              {btn.display}
            </Button>
          ))}
        </div>
      </div>

      <div className="px-3 pb-3 text-xs text-gray-500 text-center">
        💡 Clique sur les boutons pour construire ta formule
      </div>
    </div>
  );
};