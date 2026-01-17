// src/components/math/TableauVariations.tsx
import { useId } from "react";
import { InlineMath } from "react-katex";

interface LigneTableau {
  nom: string;
  valeurs: string[];
  type: "signes" | "variations";
}

interface TableauVariationsProps {
  variable?: string;
  bornes: string[];
  lignes: LigneTableau[];
}

// Wrapper safe pour KaTeX
function SafeMath({ math }: { math: string }) {
  try {
    // Retirer les délimiteurs $ si présents
    let cleanMath = math.trim();
    if (cleanMath.startsWith("$") && cleanMath.endsWith("$")) {
      cleanMath = cleanMath.slice(1, -1);
    }
    // Gérer aussi le cas des doubles $$ pour les blocs
    if (cleanMath.startsWith("$") && cleanMath.endsWith("$")) {
      cleanMath = cleanMath.slice(1, -1);
    }
    return <InlineMath math={cleanMath} />;
  } catch (e) {
    console.warn("KaTeX error:", math, e);
    return <span className="text-red-500 font-mono text-sm">{math}</span>;
  }
}

export function TableauVariations({ variable = "x", bornes, lignes }: TableauVariationsProps) {
  // Validation des données
  if (!bornes || bornes.length === 0) {
    console.warn("TableauVariations: bornes manquantes");
    return null;
  }

  if (!lignes || lignes.length === 0) {
    console.warn("TableauVariations: lignes manquantes");
    return null;
  }

  // Calculer la largeur minimale basée sur le nombre de colonnes
  const minTableWidth = Math.max(320, 140 + bornes.length * 80);

  return (
    // Conteneur externe avec scroll horizontal
    <div className="my-6 w-full">
      <div className="overflow-x-auto overflow-y-hidden -mx-2 px-2" style={{ WebkitOverflowScrolling: "touch" }}>
        {/* Conteneur du tableau avec largeur minimale fixe */}
        <div
          className="rounded-xl overflow-hidden shadow-lg border border-slate-200"
          style={{ minWidth: `${minTableWidth}px`, width: "max-content" }}
        >
          {/* En-tête */}
          <div className="bg-gradient-to-r from-indigo-500 to-purple-600 text-white">
            <div className="grid" style={{ gridTemplateColumns: `120px repeat(${bornes.length}, minmax(70px, 1fr))` }}>
              <div className="px-3 py-3 font-semibold border-r border-white/20 flex items-center justify-center">
                <SafeMath math={variable} />
              </div>
              {bornes.map((borne, i) => (
                <div key={i} className="px-2 py-3 text-center font-medium flex items-center justify-center">
                  <SafeMath math={borne} />
                </div>
              ))}
            </div>
          </div>

          {/* Corps */}
          <div className="bg-white">
            {lignes.map((ligne, i) => (
              <LigneTableauRow key={i} ligne={ligne} nbColonnes={bornes.length} />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

function LigneTableauRow({ ligne, nbColonnes }: { ligne: LigneTableau; nbColonnes: number }) {
  return (
    <div
      className={`
        grid border-t border-slate-200
        ${ligne.type === "variations" ? "min-h-[80px]" : "min-h-[50px]"}
      `}
      style={{ gridTemplateColumns: `120px 1fr` }}
    >
      {/* Nom de la ligne */}
      <div className="px-3 py-3 bg-slate-50 border-r border-slate-200 flex items-center justify-center font-medium text-slate-700 whitespace-nowrap">
        <SafeMath math={ligne.nom} />
      </div>

      {/* Contenu */}
      <div className="flex items-center overflow-hidden">
        {ligne.type === "signes" ? <SignesRow valeurs={ligne.valeurs} /> : <VariationsRow valeurs={ligne.valeurs} />}
      </div>
    </div>
  );
}

function SignesRow({ valeurs }: { valeurs: string[] }) {
  return (
    <div className="flex-1 grid" style={{ gridTemplateColumns: `repeat(${valeurs.length}, minmax(50px, 1fr))` }}>
      {valeurs.map((val, j) => (
        <div key={j} className="flex items-center justify-center border-r border-slate-100 last:border-r-0 py-2">
          <SigneCell valeur={val} />
        </div>
      ))}
    </div>
  );
}

function SigneCell({ valeur }: { valeur: string }) {
  if (valeur === "+") {
    return <span className="text-2xl font-bold text-emerald-500">+</span>;
  }
  if (valeur === "-") {
    return <span className="text-2xl font-bold text-rose-500">−</span>;
  }
  if (valeur === "0") {
    return (
      <span className="inline-flex items-center justify-center w-8 h-8 rounded-full bg-slate-800 text-white font-bold text-sm">
        0
      </span>
    );
  }
  if (valeur === "||") {
    return (
      <div className="flex gap-0.5">
        <div className="w-0.5 h-8 bg-rose-500 rounded-full" />
        <div className="w-0.5 h-8 bg-rose-500 rounded-full" />
      </div>
    );
  }
  return <SafeMath math={valeur} />;
}

// Fusionne les flèches consécutives identiques (sécurité si Gemini génère mal)
function mergeConsecutiveArrows(valeurs: string[]): string[] {
  if (valeurs.length <= 1) return valeurs;

  const result: string[] = [];
  let i = 0;

  while (i < valeurs.length) {
    const current = valeurs[i];

    if (current === "↗" || current === "↘") {
      // C'est une flèche, on l'ajoute
      result.push(current);
      i++;

      // On skip toutes les valeurs + flèches identiques qui suivent
      while (i < valeurs.length) {
        const next = valeurs[i];
        if (next === current) {
          // Même flèche, on skip
          i++;
        } else if (next !== "↗" && next !== "↘") {
          // C'est une valeur, on regarde si la flèche suivante est identique
          if (i + 1 < valeurs.length && valeurs[i + 1] === current) {
            // Valeur intermédiaire entre deux flèches identiques → on skip valeur + flèche
            i += 2;
          } else {
            // Soit pas de flèche après, soit flèche différente → on garde la valeur
            break;
          }
        } else {
          // Flèche différente, on arrête
          break;
        }
      }
    } else {
      // C'est une valeur, on l'ajoute
      result.push(current);
      i++;
    }
  }

  return result;
}

function VariationsRow({ valeurs }: { valeurs: string[] }) {
  const mergedValeurs = mergeConsecutiveArrows(valeurs);

  return (
    <div className="flex-1 flex w-full">
      {mergedValeurs.map((val, i) => {
        const isArrow = val === "↗" || val === "↘";

        // Si c'est une flèche, on l'étire sur toute la largeur
        if (isArrow) {
          return (
            <div key={i} className="flex-1 w-full flex items-center justify-center px-0">
              <FlecheEtiree type={val === "↗" ? "up" : "down"} />
            </div>
          );
        }

        // Si c'est une VALEUR, on calcule sa position verticale
        const prev = mergedValeurs[i - 1];
        const next = mergedValeurs[i + 1];

        let alignmentClass = "items-center"; // Par défaut au milieu
        let paddingClass = "";

        // POSITION HAUTE (sommet) : arrive d'une montée OU va descendre
        if (prev === "↗" || next === "↘") {
          alignmentClass = "items-start";
          paddingClass = "pt-1";
        }

        // POSITION BASSE (creux) : arrive d'une descente OU va monter
        if (prev === "↘" || next === "↗") {
          alignmentClass = "items-end";
          paddingClass = "pb-1";
        }

        return (
          <div key={i} className={`flex-none flex ${alignmentClass} justify-center px-2 min-w-[50px] ${paddingClass}`}>
            <span className="px-2 py-1 rounded-lg bg-indigo-50/50 text-indigo-900 font-semibold text-sm border border-indigo-100 whitespace-nowrap">
              <SafeMath math={val} />
            </span>
          </div>
        );
      })}
    </div>
  );
}

interface FlecheEtireeProps {
  type: "up" | "down";
}

function FlecheEtiree({ type }: FlecheEtireeProps) {
  const id = useId();
  const isUp = type === "up";
  const color = isUp ? "#10b981" : "#f43f5e";
  const markerId = `arrowhead-${id}`;

  return (
    <div className="w-full h-full min-h-[50px] flex items-center justify-center px-2">
      <svg width="100%" height="100%" style={{ overflow: "visible" }}>
        <defs>
          <marker id={markerId} markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
            <polygon points="0 0, 10 3.5, 0 7" fill={color} />
          </marker>
        </defs>
        <line
          x1="0%"
          y1={isUp ? "80%" : "20%"}
          x2="100%"
          y2={isUp ? "20%" : "80%"}
          stroke={color}
          strokeWidth="2.5"
          strokeLinecap="round"
          markerEnd={`url(#${markerId})`}
        />
      </svg>
    </div>
  );
}
