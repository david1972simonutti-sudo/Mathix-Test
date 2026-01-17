import { useId } from 'react';
import { InlineMath } from 'react-katex';

interface Noeud {
  label: string;
  probaLabel?: string; // Ex: P_A(B)
  proba?: string;      // Ex: 0.8
  resultat?: string;   // Ex: P(A ∩ B) = 0.56
  enfants?: Noeud[];
}

interface ArbreProbaProps {
  racine: Noeud;
  titre?: string;
}

function SafeMath({ math }: { math: string }) {
  try {
    return <InlineMath math={math} />;
  } catch (e) {
    return <span className="text-red-500 font-mono text-xs">{math}</span>;
  }
}

function calculerHauteur(noeud: Noeud): number {
  if (!noeud.enfants || noeud.enfants.length === 0) return 100; // Augmenté pour éviter chevauchements
  return noeud.enfants.reduce((sum, e) => sum + calculerHauteur(e), 0);
}

function calculerPositionsY(enfants: Noeud[], yParent: number): number[] {
  const positions: number[] = [];
  let currentY = yParent - (enfants.reduce((acc, e) => acc + calculerHauteur(e), 0) / 2);
  
  for (const enfant of enfants) {
    const h = calculerHauteur(enfant);
    positions.push(currentY + h / 2);
    currentY += h;
  }
  return positions;
}

export function ArbreProba({ racine, titre }: ArbreProbaProps) {
  if (!racine) return null;

  const height = calculerHauteur(racine);
  const width = 800;

  return (
    <div className="my-6 w-full overflow-x-auto bg-white rounded-xl shadow-sm border border-slate-100 p-6">
      {titre && (
        <div className="text-sm font-bold text-slate-500 uppercase tracking-wider mb-8 border-b pb-2">
          {titre}
        </div>
      )}
      <svg width={width} height={height} className="overflow-visible mx-auto" style={{ minWidth: '600px' }}>
        <DessinArbre noeud={racine} x={50} y={height / 2} isRoot={true} />
      </svg>
    </div>
  );
}

function DessinArbre({ noeud, x, y, isRoot = false }: { noeud: Noeud; x: number; y: number; isRoot?: boolean }) {
  const id = useId();
  // 1. Branches plus longues pour laisser de la place aux fractions
  const branchWidth = 280; 

  const NodeLabel = () => (
    <foreignObject x={x - 30} y={y - 20} width={60} height={40} className="pointer-events-none overflow-visible">
      <div className={`text-xl font-bold text-slate-900 text-center flex items-center justify-center h-full ${isRoot ? 'scale-125' : ''}`}>
        <SafeMath math={noeud.label} />
      </div>
    </foreignObject>
  );

  // Cas de base : Feuille
  if (!noeud.enfants || noeud.enfants.length === 0) {
    return (
      <g>
        <NodeLabel />
        {noeud.resultat && (
          <foreignObject x={x + 30} y={y - 20} width={300} height={40}>
            <div className="text-base text-slate-700 flex items-center h-full pl-2 border-l-2 border-slate-100">
               <span className="mr-3 opacity-50">→</span> <SafeMath math={noeud.resultat} />
            </div>
          </foreignObject>
        )}
      </g>
    );
  }

  const positionsY = calculerPositionsY(noeud.enfants, y);

  return (
    <g>
      <NodeLabel />

      {noeud.enfants.map((enfant, i) => {
        const yChild = positionsY[i];
        const xChild = x + branchWidth;
        
        // Calcul vectoriel
        const mx = (x + xChild) / 2;
        const my = (y + yChild) / 2;
        const dx = xChild - x;
        const dy = yChild - y;
        const len = Math.sqrt(dx*dx + dy*dy);
        
        return (
          <g key={`${id}-${i}`}>
            <line 
              x1={x + 30} y1={y} 
              x2={xChild - 30} y2={yChild} 
              stroke="#475569" 
              strokeWidth="1.5" 
            />
            
            {/* probaLabel AU-DESSUS de la branche */}
            {enfant.probaLabel && (
              <foreignObject x={mx - 40} y={my - 28} width={80} height={20} className="pointer-events-none overflow-visible">
                <div className="text-xs text-slate-600 text-center">
                  <SafeMath math={enfant.probaLabel} />
                </div>
              </foreignObject>
            )}

            {/* proba EN-DESSOUS de la branche */}
            {enfant.proba && (
              <foreignObject x={mx - 30} y={my + 8} width={60} height={20} className="pointer-events-none overflow-visible">
                <div className="text-xs text-indigo-600 text-center">
                  <SafeMath math={enfant.proba} />
                </div>
              </foreignObject>
            )}

            <DessinArbre noeud={enfant} x={xChild} y={yChild} />
          </g>
        );
      })}
    </g>
  );
}
