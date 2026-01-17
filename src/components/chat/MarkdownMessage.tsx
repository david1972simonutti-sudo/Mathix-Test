import { MathText } from '@/components/MathText';
import { TableauVariations } from '@/components/math/TableauVariations';
import { ArbreProba } from '@/components/math/ArbreProba';

interface MarkdownMessageProps {
  content: string;
  role?: 'user' | 'assistant';
}

// Fonction pour parser les blocs spéciaux (tableaux et arbres)
function parseSpecialBlocksFromContent(content: string) {
  const segments: Array<{ 
    type: 'text' | 'tableau' | 'arbre'; 
    content: string; 
    tableauData?: any;
    arbreData?: any;
  }> = [];
  
  // Regex pour détecter les deux types de blocs
  const blockRegex = /:::(TABLEAU_JSON|ARBRE_JSON)([\s\S]*?):::/g;
  
  let lastIndex = 0;
  let match;
  
  while ((match = blockRegex.exec(content)) !== null) {
    const [fullMatch, blockType, jsonContent] = match;
    const startIdx = match.index;
    
    // Ajouter le texte avant le bloc
    if (startIdx > lastIndex) {
      const textBefore = content.slice(lastIndex, startIdx).trim();
      if (textBefore) {
        segments.push({ type: 'text', content: textBefore });
      }
    }
    
    // Trouver le JSON dans le contenu du bloc
    const jsonStartIdx = jsonContent.indexOf('{');
    if (jsonStartIdx === -1) {
      lastIndex = startIdx + fullMatch.length;
      continue;
    }
    
    // Compter les accolades pour extraire le JSON complet
    let braceCount = 0;
    let jsonEndIdx = -1;
    
    for (let i = jsonStartIdx; i < jsonContent.length; i++) {
      if (jsonContent[i] === '{') braceCount++;
      else if (jsonContent[i] === '}') {
        braceCount--;
        if (braceCount === 0) {
          jsonEndIdx = i;
          break;
        }
      }
    }
    
    if (jsonEndIdx === -1) {
      lastIndex = startIdx + fullMatch.length;
      continue;
    }
    
    // Extraire le JSON
    let jsonStr = jsonContent.slice(jsonStartIdx, jsonEndIdx + 1);
    
    // Convertir les flèches LaTeX en Unicode AVANT le parsing JSON
    // (évite les erreurs "Invalid escape sequence")
    jsonStr = jsonStr
      .replace(/\\searrow/g, '↘')
      .replace(/\\nearrow/g, '↗')
      .replace(/\\rightarrow/g, '→')
      .replace(/\\leftarrow/g, '←')
      .replace(/\\uparrow/g, '↑')
      .replace(/\\downarrow/g, '↓');
    
    // Échapper seulement les commandes LaTeX connues pour JSON
    const latexCommands = ['infty', 'frac', 'sqrt', 'cdot', 'times', 'pm', 'mp', 'leq', 'geq', 'neq', 'alpha', 'beta', 'gamma', 'delta', 'pi', 'theta', 'lambda', 'mu', 'sigma', 'omega'];
    for (const cmd of latexCommands) {
      jsonStr = jsonStr.replace(new RegExp(`\\\\${cmd}(?![a-zA-Z])`, 'g'), `\\\\${cmd}`);
    }
    
    // Debug: afficher le JSON brut avant parsing
    console.log(`🔍 ${blockType} JSON brut avant parsing:`, jsonStr);
    
    try {
      const data = JSON.parse(jsonStr);
      
      if (blockType === 'TABLEAU_JSON') {
        console.log('📊 TableauVariations data:', JSON.stringify(data, null, 2));
        segments.push({ type: 'tableau', content: '', tableauData: data });
      } else if (blockType === 'ARBRE_JSON') {
        console.log('🌳 ArbreProba data:', JSON.stringify(data, null, 2));
        segments.push({ type: 'arbre', content: '', arbreData: data });
      }
    } catch (e) {
      console.warn(`${blockType}: JSON invalide - tentative de nettoyage...`, e);
      
      // Fallback: essayer de nettoyer les séquences d'échappement problématiques
      try {
        const cleanedJson = jsonStr.replace(/\\([a-z])/gi, (match, letter) => {
          const knownEscapes: Record<string, string> = { n: '\n', t: '\t', r: '\r', b: '\b', f: '\f' };
          if (knownEscapes[letter]) return knownEscapes[letter];
          // Supprimer le backslash si c'est une séquence inconnue
          return letter;
        });
        
        const data = JSON.parse(cleanedJson);
        console.log(`✅ ${blockType} récupéré après nettoyage`);
        
        if (blockType === 'TABLEAU_JSON') {
          segments.push({ type: 'tableau', content: '', tableauData: data });
        } else if (blockType === 'ARBRE_JSON') {
          segments.push({ type: 'arbre', content: '', arbreData: data });
        }
      } catch (e2) {
        console.error(`${blockType}: JSON invalide même après nettoyage`, e2, jsonStr);
        segments.push({ type: 'text', content: fullMatch });
      }
    }
    
    lastIndex = startIdx + fullMatch.length;
  }
  
  // Ajouter le texte restant
  if (lastIndex < content.length) {
    const textAfter = content.slice(lastIndex).trim();
    if (textAfter) {
      segments.push({ type: 'text', content: textAfter });
    }
  }
  
  if (segments.length === 0) {
    segments.push({ type: 'text', content });
  }
  
  return segments;
}

export function MarkdownMessage({ content, role = 'assistant' }: MarkdownMessageProps) {
  const segments = parseSpecialBlocksFromContent(content);
  
  return (
    <div className="space-y-3 w-full max-w-full overflow-hidden">
      {segments.map((segment, segmentIndex) => {
        // Rendu du tableau de variations
        if (segment.type === 'tableau' && segment.tableauData) {
          return (
            <div key={`tableau-${segmentIndex}`} className="w-full overflow-x-auto my-4 rounded-lg border border-gray-100 touch-pan-x">
              <div className="min-w-fit p-1">
                <TableauVariations
                  variable={segment.tableauData.variable || 'x'}
                  bornes={segment.tableauData.bornes || []}
                  lignes={segment.tableauData.lignes || []}
                />
              </div>
            </div>
          );
        }
        
        // Rendu de l'arbre de probabilités
        if (segment.type === 'arbre' && segment.arbreData) {
          return (
            <div key={`arbre-${segmentIndex}`} className="w-full overflow-x-auto my-4 touch-pan-x">
              <div className="min-w-fit p-1">
                {/* 🐛 BOÎTE DE DEBUG - À SUPPRIMER APRÈS */}
                <details className="mb-4 p-3 bg-yellow-50 border border-yellow-300 rounded-lg">
                  <summary className="cursor-pointer font-mono text-sm text-yellow-800">
                    🐛 DEBUG: Voir JSON brut de l'arbre
                  </summary>
                  <pre className="mt-2 p-2 bg-white rounded text-xs overflow-auto max-h-60">
                    {JSON.stringify(segment.arbreData, null, 2)}
                  </pre>
                </details>
                
                {/* Le vrai composant */}
                <ArbreProba
                  racine={segment.arbreData.racine}
                  titre={segment.arbreData.titre}
                />
              </div>
            </div>
          );
        }
        
        // Rendu du texte normal avec la logique existante
        return (
          <TextSegment 
            key={`text-${segmentIndex}`} 
            content={segment.content} 
            role={role} 
          />
        );
      })}
    </div>
  );
}

// Composant pour gérer un segment de texte (logique existante extraite)
function TextSegment({ content, role }: { content: string; role: 'user' | 'assistant' }) {
  const lines = content.split('\n');
  
  // Détecter si on est dans une section "Exemple"
  const isInExampleSection = (lineIndex: number): boolean => {
    for (let i = lineIndex; i >= 0; i--) {
      const prevLine = lines[i].trim().toLowerCase();
      if (/^\*\*.*\*\*/.test(lines[i]) || /^#{1,3}\s+/.test(lines[i])) {
        return /exemple|prenons|application|exercice|calculons/.test(prevLine);
      }
    }
    return false;
  };
  
  // Détecter les sections méthodologiques de manière persistante
  const detectMethodSections = (): boolean[] => {
    const inMethodSection: boolean[] = new Array(lines.length).fill(false);
    let methodMode = true;
    let lastNumber = 0;
    
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();
      const lineLower = line.toLowerCase();
      
      const numberedMatch = line.match(/^(\d+)\./);
      const currentNumber = numberedMatch ? parseInt(numberedMatch[1]) : null;
      
      if (currentNumber === 1 && lastNumber > 1) {
        methodMode = false;
      }
      
      if ((/^\*\*.*\*\*/.test(line) || /^#{1,3}\s+/.test(line)) && /exemple|prenons|application|calculons|exercice pratique|cas pratique|voici un cas/i.test(lineLower)) {
        methodMode = false;
      }
      
      if ((/^\*\*.*\*\*/.test(line) || /^#{1,3}\s+/.test(line)) && (
        /pour appliquer/i.test(lineLower) ||
        /il faut suivre/i.test(lineLower) ||
        /étapes précises/i.test(lineLower) ||
        /suivre (les |des )?étapes/i.test(lineLower) ||
        /plusieurs étapes/i.test(lineLower) ||
        /méthode/i.test(lineLower) ||
        /démarche/i.test(lineLower) ||
        /procédure/i.test(lineLower) ||
        /processus/i.test(lineLower) ||
        /voici comment/i.test(lineLower) ||
        /comment (calculer|résoudre|faire|appliquer|l'appliquer)/i.test(lineLower) ||
        /chaque cas/i.test(lineLower) ||
        /(les|deux|plusieurs) cas/i.test(lineLower) ||
        /(expliquer|détailler|voir).*cas/i.test(lineLower) ||
        /dans (chaque|les) cas/i.test(lineLower)
      )) {
        methodMode = true;
        lastNumber = 0;
      }
      
      if (methodMode && currentNumber !== null) {
        inMethodSection[i] = true;
        lastNumber = currentNumber;
      }
    }
    
    return inMethodSection;
  };
  
  const methodSections = detectMethodSections();
  
  return (
    <>
      {lines.map((line, idx) => {
        if (line.trim() === '') {
          return <div key={idx} className="h-2" />;
        }
        const inExample = isInExampleSection(idx);
        const inMethodSection = methodSections[idx];
        return <FormattedLine key={idx} line={line} role={role} inExample={inExample} inMethodSection={inMethodSection} />;
      })}
    </>
  );
}

function FormattedLine({ line, role, inExample = false, inMethodSection = false }: { line: string; role: 'user' | 'assistant'; inExample?: boolean; inMethodSection?: boolean }) {
  const isBullet = /^[•\-]\s/.test(line.trim()) || /^\*\s/.test(line.trim());
  const isNumbered = /^\d+\.\s+/.test(line.trim());
  const isSubBullet = /^\s+\*\s/.test(line);
  const isTitle = /^#{1,3}\s+/.test(line.trim()) || /^\*\*[^*]+\*\*$/.test(line.trim());
  const isStep = /^(Étape|Step|Méthode|Rappel|Astuce|Attention|⚠️)\s?:?\s/i.test(line.trim());
  
  const colors = role === 'user' ? {
    title: 'text-white',
    step: 'text-white',
    stepBg: 'bg-white/10 border-white/30',
    bullet: 'text-white',
    text: 'text-white',
  } : {
    title: 'text-blue-700',
    step: 'text-blue-900',
    stepBg: 'bg-indigo-100 border-indigo-600',
    bullet: 'text-indigo-500',
    text: 'text-gray-800',
  };
  
  const numberedColors = role === 'user' ? {
    bg: 'bg-white text-primary',
    text: 'text-white'
  } : inExample ? {
    bg: 'bg-green-700 text-white',
    text: 'text-gray-800'
  } : {
    bg: 'bg-indigo-600 text-white',
    text: 'text-gray-800'
  };
  
  if (isTitle) {
    const cleanTitle = line.trim()
      .replace(/^#{1,3}\s+/, '')
      .replace(/^\*\*/, '')
      .replace(/\*\*$/, '');
    
    return (
      <div className={`mt-4 mb-2 text-lg font-bold w-full break-words ${colors.title}`}>
        <MathText content={cleanTitle} mode="lenient" />
      </div>
    );
  }
  
  if (isStep) {
    return (
      <div className={`mt-3 p-3 w-full max-w-full ${colors.stepBg} border-l-4 rounded`}>
        <div className={`font-semibold ${colors.step} w-full break-words`}>
          <MathText content={line} mode="lenient" />
        </div>
      </div>
    );
  }
  
  if (isNumbered) {
    const cleanedLine = line.trim().replace(/\s+/g, ' ');
    const match = cleanedLine.match(/^(\d+)\.\s+(.+)$/);
    
    let number = '?';
    let text = cleanedLine;
    
    if (match) {
      [, number, text] = match;
    } else {
      const simpleMatch = cleanedLine.match(/^(\d+)\./);
      if (simpleMatch) {
        number = simpleMatch[1];
        text = cleanedLine.substring(simpleMatch[0].length).trim();
      }
    }
    
    // Nettoyer les numéros redondants au début du texte (ex: "1. Détermine..." -> "Détermine...")
    text = text.replace(/^\d+\.\s*/, '').trim();
    
    if (inMethodSection) {
      return (
        <div className={`mt-3 p-3 w-full max-w-full ${colors.stepBg} border-l-4 rounded`}>
          <div className={`font-semibold ${colors.step} flex items-baseline gap-2 w-full`}>
            <span className="text-blue-600 font-bold shrink-0">{number}.</span>
            <div className="inline-math-container flex-1 min-w-0">
              <MathText content={text} mode="lenient" />
            </div>
          </div>
        </div>
      );
    }
    
    return (
      <div className="flex gap-3 mt-2 w-full max-w-full">
        <span className={`flex-shrink-0 w-7 h-7 ${numberedColors.bg} rounded-full flex items-center justify-center text-sm font-bold`}>
          {number}
        </span>
        <div className={`flex-1 min-w-0 pt-0.5 break-words ${numberedColors.text}`}>
          <MathText content={text} mode="lenient" />
        </div>
      </div>
    );
  }
  
  if (isBullet) {
    const text = line.trim().replace(/^[•\-*]\s+/, '');
    return (
      <div className="flex gap-2 mt-1 w-full max-w-full pl-1">
        <span className={`${colors.bullet} font-bold mt-1 shrink-0`}>•</span>
        <div className={`flex-1 min-w-0 break-words ${colors.text}`}>
          <MathText content={text} mode="lenient" />
        </div>
      </div>
    );
  }
  
  if (isSubBullet) {
    const text = line.replace(/^\s+\*\s/, '').replace(/^→\s*/, '');
    return (
      <div className="flex gap-2 mt-1 w-full max-w-full pl-4 ml-1 border-l-2 border-gray-100/50">
        <span className={`${role === 'user' ? 'text-white/70' : 'text-gray-400'} shrink-0 text-xs mt-1`}>→</span>
        <div className={`flex-1 min-w-0 break-words ${role === 'user' ? 'text-white/90' : 'text-gray-700'}`}>
          <MathText content={text} mode="lenient" />
        </div>
      </div>
    );
  }
  
  return (
    <div className={`leading-relaxed w-full max-w-full break-words ${colors.text}`}>
      <MathText content={line} mode="lenient" />
    </div>
  );
}
