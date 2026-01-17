// TEST-FORMULAS.tsx
// Fichier de test pour vérifier que toutes les formules s'affichent correctement

import { MathText } from "@/components/MathText";
import { TableauVariations } from "@/components/math/TableauVariations";
import { ArbreProba } from "@/components/math/ArbreProba";

export const TestFormulas = () => {
  const testCases = [
    {
      title: "1. Fractions simples",
      formulas: [
        "$\\frac{1}{2}$",
        "$\\frac{3x + 5}{x + 2}$",
        "$\\frac{\\sin(2x)}{1 + \\cos(x)}$",
        "$f(x) = \\frac{3x + 5}{x + 2}$"
      ]
    },
    {
      title: "2. Suites et récurrence",
      formulas: [
        "$U_0 = 3$",
        "$U_{n+1} = \\frac{1}{2}U_n + 1$",
        "$U_1, U_2$ et $U_3$",
        "$P(n) : U_n > 2$"
      ]
    },
    {
      title: "3. Fonctions trigonométriques",
      formulas: [
        "$\\sin(x)$, $\\cos(x)$, $\\tan(x)$",
        "$\\sin(\\frac{\\pi}{4}) = \\frac{\\sqrt{2}}{2}$",
        "$\\cos(\\frac{\\pi}{3}) = \\frac{1}{2}$",
        "$\\tan(\\frac{\\pi}{6}) = \\frac{\\sqrt{3}}{3}$"
      ]
    },
    {
      title: "4. Pi et angles",
      formulas: [
        "$\\pi$",
        "$2\\pi$",
        "$\\frac{\\pi}{2}$",
        "$\\frac{3\\pi}{4}$",
        "$\\frac{5\\pi}{9}$",
        "$45^\\circ$"
      ]
    },
    {
      title: "5. Racines carrées",
      formulas: [
        "$\\sqrt{2}$",
        "$\\sqrt{x^2 + y^2}$",
        "$\\sqrt{a + b}$",
        "$\\frac{\\sqrt{2}}{2}$"
      ]
    },
    {
      title: "6. Logarithmes et exponentielles",
      formulas: [
        "$\\ln(x)$",
        "$\\log(x)$",
        "$e^x$",
        "$\\ln(\\frac{a}{b})$",
        "$e^{\\frac{\\pi}{2}}$"
      ]
    },
    {
      title: "7. Dérivées",
      formulas: [
        "$f'(x)$",
        "$u'(x)$, $v'(x)$",
        "$\\frac{u'(x)}{v'(x)}$",
        "$(uv)' = u'v + uv'$",
        "$(\\frac{u}{v})' = \\frac{u'v - uv'}{v^2}$"
      ]
    },
    {
      title: "8. Intervalles",
      formulas: [
        "$x \\in [0, 1]$",
        "$x \\in ]0, +\\infty[$",
        "$x \\in \\mathbb{R} \\setminus \\{-2\\}$",
        "$]-\\infty, 2[$"
      ]
    },
    {
      title: "9. Sommes et produits",
      formulas: [
        "$$\\sum_{i=1}^{n} i = \\frac{n(n+1)}{2}$$",
        "$$\\prod_{i=1}^{n} i = n!$$",
        "$$\\int_{0}^{1} x^2 dx = \\frac{1}{3}$$"
      ]
    },
    {
      title: "10. Limites",
      formulas: [
        "$\\lim_{x \\to 0} \\frac{\\sin(x)}{x} = 1$",
        "$\\lim_{n \\to +\\infty} U_n$",
        "$\\lim_{x \\to +\\infty} f(x) = L$"
      ]
    },
    {
      title: "11. Formules complexes (block math)",
      formulas: [
        "$$f(x) = \\frac{\\sin(2x)}{1 + \\cos(x)}$$",
        "$$\\int_{a}^{b} f(x)dx = F(b) - F(a)$$",
        "$$\\sum_{k=0}^{n} \\binom{n}{k} x^k = (1+x)^n$$",
        "$$\\frac{d}{dx}\\left(\\frac{u(x)}{v(x)}\\right) = \\frac{u'(x)v(x) - u(x)v'(x)}{v(x)^2}$$"
      ]
    },
    {
      title: "12. Matrices et vecteurs",
      formulas: [
        "$$\\begin{pmatrix} a & b \\\\ c & d \\end{pmatrix}$$",
        "$$\\vec{v} = \\begin{pmatrix} x \\\\ y \\end{pmatrix}$$",
        "$$\\det(A) = ad - bc$$"
      ]
    },
    {
      title: "13. Tableau de Variations",
      isVariationTable: true
    },
    {
      title: "14. Arbre de Probabilités",
      isArbreProba: true
    }
  ];

  return (
    <div className="max-w-4xl mx-auto p-8 space-y-8">
      <h1 className="text-3xl font-bold mb-8">🧪 Tests de Formules Mathématiques</h1>
      
      <div className="bg-blue-50 border-l-4 border-blue-500 p-4 mb-8">
        <p className="text-blue-700">
          <strong>Instructions :</strong> Toutes les formules ci-dessous devraient s'afficher correctement sans erreurs rouges.
          Si vous voyez des formules en rouge, vérifiez la console pour les détails de l'erreur.
        </p>
      </div>

      {testCases.map((testCase, idx) => (
        <div key={idx} className="bg-white rounded-lg shadow-md p-6 border">
          <h2 className="text-xl font-semibold mb-4 text-primary">{testCase.title}</h2>
          
          {testCase.isArbreProba ? (
            <div className="space-y-4">
              <p className="text-sm text-gray-600 mb-4">
                Test du composant ArbreProba avec rendu KaTeX et branches colorées
              </p>
              <ArbreProba
                titre="Arbre avec probabilités conditionnelles"
                racine={{
                  label: "\\Omega",
                  enfants: [
                    {
                      label: "A",
                      probaLabel: "P(A)",
                      proba: "0.4",
                      enfants: [
                        { 
                          label: "D", 
                          probaLabel: "P_A(D)", 
                          proba: "0.7", 
                          resultat: "P(A \\cap D) = 0.28" 
                        },
                        { 
                          label: "\\overline{D}", 
                          probaLabel: "P_A(\\overline{D})", 
                          proba: "0.3", 
                          resultat: "P(A \\cap \\overline{D}) = 0.12" 
                        }
                      ]
                    },
                    {
                      label: "\\overline{A}",
                      probaLabel: "P(\\overline{A})",
                      proba: "0.6",
                      enfants: [
                        { 
                          label: "D", 
                          probaLabel: "P_{\\overline{A}}(D)", 
                          proba: "0.2", 
                          resultat: "P(\\overline{A} \\cap D) = 0.12" 
                        },
                        { 
                          label: "\\overline{D}", 
                          probaLabel: "P_{\\overline{A}}(\\overline{D})", 
                          proba: "0.8", 
                          resultat: "P(\\overline{A} \\cap \\overline{D}) = 0.48" 
                        }
                      ]
                    }
                  ]
                }}
              />
            </div>
          ) : testCase.isVariationTable ? (
            <div className="space-y-4">
              <p className="text-sm text-gray-600 mb-4">
                Test du composant TableauVariations avec flèches SVG et rendu KaTeX
              </p>
              <TableauVariations
                variable="x"
                bornes={["-\\infty", "1", "+\\infty"]}
                lignes={[
                  { nom: "f'(x)", valeurs: ["-", "0", "+"], type: "signes" },
                  { nom: "f(x)", valeurs: ["0", "↘", "-1", "↗", "+\\infty"], type: "variations" }
                ]}
              />
            </div>
          ) : (
            <div className="space-y-3">
              {testCase.formulas?.map((formula, fIdx) => (
                <div key={fIdx} className="p-3 bg-gray-50 rounded border border-gray-200">
                  <div className="text-xs text-gray-500 mb-2 font-mono">{formula}</div>
                  <MathText 
                    content={formula}
                    mode="lenient"
                    auto={{ 
                      functions: true, 
                      pi: true, 
                      sqrt: true, 
                      degrees: true, 
                      intervals: true,
                      variables: true,
                      greek: true
                    }}
                    centerBlocks={formula.startsWith("$$")}
                    className="text-lg"
                  />
                </div>
              ))}
            </div>
          )}
        </div>
      ))}

      <div className="bg-green-50 border-l-4 border-green-500 p-4 mt-8">
        <h3 className="font-semibold text-green-700 mb-2">✅ Résultats attendus :</h3>
        <ul className="list-disc list-inside text-green-700 space-y-1">
          <li>Toutes les fractions sont correctement affichées avec des barres horizontales</li>
          <li>Les indices et exposants sont bien positionnés</li>
          <li>Les fonctions trigonométriques sont en italique</li>
          <li>Les symboles grecs (π) s'affichent correctement</li>
          <li>Les racines carrées ont le symbole radical correct</li>
          <li>Les formules longues peuvent scroller horizontalement si nécessaire</li>
          <li>Aucune formule n'est tronquée ou en rouge</li>
        </ul>
      </div>

      <div className="bg-yellow-50 border-l-4 border-yellow-500 p-4">
        <h3 className="font-semibold text-yellow-700 mb-2">⚠️ Si vous voyez des erreurs :</h3>
        <ol className="list-decimal list-inside text-yellow-700 space-y-1">
          <li>Ouvrez la console du navigateur (F12)</li>
          <li>Notez les erreurs KaTeX affichées</li>
          <li>Vérifiez que les fichiers MathText-3.tsx et katex-fraction-fix.css sont bien à jour</li>
          <li>Essayez de rafraîchir la page (Ctrl+F5)</li>
          <li>Si le problème persiste, envoyez-moi la formule problématique</li>
        </ol>
      </div>
    </div>
  );
};

// EXEMPLES D'UTILISATION DANS Exercise.tsx

export const ExerciseExamples = () => {
  return (
    <div className="space-y-6 p-6">
      {/* Exemple 1: Énoncé simple */}
      <div className="bg-background/50 rounded-md border p-4">
        <h3 className="text-lg font-semibold mb-4">📝 Énoncé</h3>
        <MathText
          content="Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{-2\\}$ par $$f(x) = \\frac{3x + 5}{x + 2}$$"
          mode="lenient"
          auto={{ functions: true, pi: true, sqrt: true, intervals: true }}
          centerBlocks
        />
      </div>

      {/* Exemple 2: Questions numérotées */}
      <div className="space-y-4">
        <div className="flex gap-3 items-start">
          <span className="font-bold text-primary">1.</span>
          <MathText 
            content="Identifie la forme de la fonction $f(x)$ parmi les suivantes: $u \\times v$, $\\frac{u}{v}$, $u + v$, $u - v$."
            mode="lenient"
            auto={{ functions: true, variables: true }}
          />
        </div>
        
        <div className="flex gap-3 items-start">
          <span className="font-bold text-primary">2.</span>
          <MathText 
            content="Détermine les fonctions $u(x)$ et $v(x)$ ainsi que leurs dérivées respectives $u'(x)$ et $v'(x)$."
            mode="lenient"
            auto={{ functions: true, variables: true }}
          />
        </div>

        <div className="flex gap-3 items-start">
          <span className="font-bold text-primary">3.</span>
          <MathText 
            content="Applique la formule de la dérivée d'un quotient pour calculer $f'(x)$."
            mode="lenient"
            auto={{ functions: true, variables: true }}
          />
        </div>
      </div>

      {/* Exemple 3: Suite récurrente */}
      <div className="bg-muted/30 p-4 rounded-lg">
        <MathText 
          content="Soit la suite $(U_n)$ définie pour tout entier naturel $n$ par $U_0 = 3$ et $$U_{n+1} = \\frac{1}{2}U_n + 1$$"
          mode="lenient"
          auto={{ 
            functions: true, 
            intervals: true, 
            variables: true 
          }}
          centerBlocks
          preserveLineBreaks
        />
      </div>

      {/* Exemple 4: Message du chatbot */}
      <div className="bg-muted rounded-lg p-4">
        <MathText 
          content="Super ! Tu as raison. La dérivée de $\\sin(2x)$ est effectivement $2\\cos(2x)$. Maintenant, essaie de calculer la dérivée de $\\cos(\\frac{\\pi}{3}x)$."
          mode="lenient"
          auto={{ 
            functions: true, 
            pi: true, 
            sqrt: true, 
            degrees: true 
          }}
          preserveLineBreaks
        />
      </div>
    </div>
  );
};

// TESTS DE RÉGRESSION (formules qui posaient problème)

export const RegressionTests = () => {
  const problematicFormulas = [
    {
      description: "Fraction avec sin et cos (Image 1)",
      original: "$\\frac{\\sin(2x)}{1 + \\cos(x)}$",
      expected: "Fraction avec barres de fraction correctes, sin et cos en italique"
    },
    {
      description: "Définition de fonction (Image 2)",
      original: "$f(x) = \\frac{3x + 5}{x + 2}$",
      expected: "Fonction avec fraction bien affichée, pas de rouge"
    },
    {
      description: "Suite récurrente (Image 3)",
      original: "$U_{n+1} = \\frac{1}{2}U_n + 1$",
      expected: "Indices corrects, fraction 1/2 bien formatée"
    },
    {
      description: "Double backslash de Gemini",
      original: "$\\\\frac{3}{4}$", // Simule l'erreur Gemini
      expected: "Devrait être normalisé en \\frac{3}{4}"
    },
    {
      description: "Espaces dans les commandes",
      original: "$\\ frac {3} {4}$", // Espaces incorrects
      expected: "Devrait être corrigé en \\frac{3}{4}"
    }
  ];

  return (
    <div className="max-w-4xl mx-auto p-8 space-y-6">
      <h1 className="text-3xl font-bold mb-8">🔍 Tests de Régression</h1>
      
      <div className="bg-red-50 border-l-4 border-red-500 p-4 mb-8">
        <p className="text-red-700">
          <strong>Important :</strong> Ces formules posaient problème avant les corrections.
          Elles devraient maintenant toutes s'afficher correctement.
        </p>
      </div>

      {problematicFormulas.map((test, idx) => (
        <div key={idx} className="bg-white rounded-lg shadow-md p-6 border">
          <h3 className="font-semibold text-lg mb-2">{test.description}</h3>
          <div className="bg-gray-100 p-3 rounded font-mono text-sm mb-3">
            {test.original}
          </div>
          <div className="bg-blue-50 p-4 rounded border border-blue-200 mb-3">
            <MathText 
              content={test.original}
              mode="lenient"
              auto={{ functions: true, pi: true, sqrt: true }}
            />
          </div>
          <p className="text-sm text-gray-600 italic">✅ Attendu: {test.expected}</p>
        </div>
      ))}
    </div>
  );
};

export default TestFormulas;
