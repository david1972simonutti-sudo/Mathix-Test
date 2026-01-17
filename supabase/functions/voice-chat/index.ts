import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { encodeBase64 } from "https://deno.land/std@0.224.0/encoding/base64.ts";
import "https://deno.land/x/xhr@0.1.0/mod.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

// ====== IMAGE DETECTION AND GENERATION FUNCTIONS ======

const detectImageRequest = (text: string): boolean => {
  const lowerText = text.toLowerCase();
  
  // Exclure les demandes d'explication/lecture
  const excludePatterns = [
    /\b(relire|lire|expli[cq]|rappel|révision|cours|leçon|comprendre|c'est quoi|qu'est[- ]ce)\b/i,
  ];
  
  if (excludePatterns.some(pattern => pattern.test(lowerText))) {
    return false;
  }
  
  // Verbes d'action visuelle
  const actionVerbs = /\b(dessine|trace|tracer|représente|affiche|montre|créer|créé|génère|schématise)\b/i;
  
  // Concepts mathématiques visuels
  const visualConcepts = [
    /\b(graphique|courbe|repère|schéma|diagramme|figure)\b/i,
    /\b(cercle|triangle|carré|rectangle|polygone)\b/i,
    /\b(venn)\b/i,
  ];
  
  // Pour qu'une image soit générée, il faut :
  // - Un verbe d'action visuelle + un concept mathématique visuel
  // OU un concept visuel explicite (graphique, schéma, diagramme)
  const hasActionVerb = actionVerbs.test(lowerText);
  const hasVisualConcept = visualConcepts.some(pattern => pattern.test(lowerText));
  
  return hasActionVerb && hasVisualConcept || 
         /\b(graphique|schéma|diagramme)\b/i.test(lowerText);
};

const buildMathImagePrompt = (originalRequest: string): string => {
  const lowerRequest = originalRequest.toLowerCase();
  
  // Detection patterns avec plus de spécificité
  const patterns = {
    graphFunction: /(?:trace|dessine|représente).*?(?:graphique|courbe).*?(?:fonction|f\(x\)|y\s*=)|(?:fonction|f\(x\)|y\s*=).*?(?:graphique|courbe)/i,
    vennDiagram: /(?:trace|dessine|représente).*?(?:venn|diagramme\s+de\s+venn)|(?:venn|diagramme\s+de\s+venn)/i,
    pythagoras: /(?:trace|dessine|représente|schématise).*?(?:pythagore|théorème\s+de\s+pythagore)|(?:schéma|figure).*?pythagore/i,
    thales: /(?:trace|dessine|représente|schématise).*?(?:thalès|théorème\s+de\s+thalès)|(?:schéma|figure).*?thalès/i,
    coordinate: /(?:trace|dessine).*?(?:repère|axes)|repère.*?(?:orthonorm|cartésien)/i,
    geometric: /(?:trace|dessine).*?(?:cercle|triangle|carré|rectangle|polygone)|(?:schéma|figure).*?(?:géométrique|triangle|cercle)/i,
  };
  
  let enhancedPrompt = `Create a precise, educational mathematical illustration in French for: "${originalRequest}". `;
  
  if (patterns.graphFunction.test(lowerRequest)) {
    enhancedPrompt += "Dessine un repère orthonormé avec axes x et y clairement étiquetés, quadrillage, et trace la fonction mathématique avec une courbe lisse. Inclus les graduations et points clés. Titre en français.";
  } else if (patterns.thales.test(lowerRequest)) {
    enhancedPrompt += "Illustre le théorème de Thalès avec deux triangles (configuration en papillon ou triangles emboîtés), droites parallèles clairement indiquées, points étiquetés (A, B, C, M, N), et rapports de longueurs annotés. Titre et annotations en français.";
  } else if (patterns.vennDiagram.test(lowerRequest)) {
    enhancedPrompt += "Crée un diagramme de Venn avec cercles/ensembles clairement étiquetés, intersections et régions visibles. Utilise des couleurs différentes pour la clarté. Titre en français.";
  } else if (patterns.pythagoras.test(lowerRequest)) {
    enhancedPrompt += "Illustre le théorème de Pythagore avec un triangle rectangle, côtés étiquetés (a, b, c), et représentation visuelle des carrés sur chaque côté (a², b², c²). Annotations en français.";
  } else if (patterns.coordinate.test(lowerRequest)) {
    enhancedPrompt += "Dessine un repère cartésien avec axes x et y clairement étiquetés, origine (0,0), quadrillage, et graduations appropriées. Annotations en français.";
  } else if (patterns.geometric.test(lowerRequest)) {
    enhancedPrompt += "Dessine la figure géométrique avec lignes claires, sommets/points étiquetés, mesures si applicable, et proportions correctes. Annotations en français.";
  } else {
    enhancedPrompt += "Crée un schéma mathématique clair et simple qui illustre le concept. Utilise des lignes nettes, annotations appropriées en français, et clarté pédagogique.";
  }
  
  enhancedPrompt += " Style: Schéma éducatif net sur fond blanc/clair. Haut contraste pour la visibilité. Illustration mathématique professionnelle avec texte en FRANÇAIS.";
  
  return enhancedPrompt;
};

const generateImage = async (prompt: string, apiKey: string): Promise<string | null> => {
  try {
    console.log("🎨 Generating image with prompt:", prompt.substring(0, 100));
    
    const enhancedPrompt = buildMathImagePrompt(prompt);
    
    const response = await fetch("https://ai.gateway.lovable.dev/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "google/gemini-2.5-flash-image-preview",
        messages: [
          {
            role: "user",
            content: enhancedPrompt
          }
        ],
        modalities: ["image", "text"]
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error("❌ Image generation API error:", response.status, errorText);
      
      if (response.status === 429) {
        console.warn("⚠️ Rate limit exceeded for image generation");
      } else if (response.status === 402) {
        console.warn("⚠️ Payment required for image generation");
      }
      
      return null;
    }

    const data = await response.json();
    const imageUrl = data.choices?.[0]?.message?.images?.[0]?.image_url?.url;
    
    if (imageUrl) {
      console.log("✅ Image generated successfully");
      return imageUrl;
    }
    
    console.warn("⚠️ No image URL in response");
    return null;
    
  } catch (error) {
    console.error("❌ Error generating image:", error);
    return null;
  }
};

// Normalize French mathematical expressions for detection
const normalizeMathExpression = (text: string): string => {
  let normalized = text;
  
  // "y égale x au carré" → "y = x^2"
  normalized = normalized.replace(
    /\b([a-z])\s+(?:égale?|est égale? à)\s+([a-z])\s+au\s+carré/gi,
    '$1 = $2^2'
  );
  
  // "x carré" or "x au carré" → "x^2"
  normalized = normalized.replace(
    /\b([a-z])\s+(?:au\s+)?carré/gi,
    '$1^2'
  );
  
  // "x cube" or "x au cube" → "x^3"
  normalized = normalized.replace(
    /\b([a-z])\s+(?:au\s+)?cube/gi,
    '$1^3'
  );
  
  // "x puissance n" → "x^n"
  normalized = normalized.replace(
    /\b([a-z])\s+puissance\s+([a-z0-9]+)/gi,
    '$1^$2'
  );
  
  // "égale" → "="
  normalized = normalized.replace(/\s+égale?\s+/gi, ' = ');
  
  // "plus" → "+"
  normalized = normalized.replace(/\s+plus\s+/gi, ' + ');
  
  // "moins" → "-"
  normalized = normalized.replace(/\s+moins\s+/gi, ' - ');
  
  // "fois" → "*"
  normalized = normalized.replace(/\s+fois\s+/gi, ' * ');
  
  // "divisé par" or "sur" → "/"
  normalized = normalized.replace(/\s+(?:divisé\s+par|sur)\s+/gi, ' / ');
  
  return normalized;
};

// Detect if the user is requesting a mathematical function graph
const detectMathFunction = (text: string): {
  expression: string,
  xMin?: number,
  xMax?: number,
  title?: string
} | null => {
  // Try to extract expression even without explicit graph keywords
  // 1) Equation form: y = ...  or f(x) = ... (capture to end of line)
  const equationMatch = text.match(/(?:y|f\s*\(x\))\s*=\s*([^\n\r]+)/i);
  let expression = equationMatch ? equationMatch[1] : null;

  // 2) Direct common functions when no equation (sin, cos, exp, ln, log, sqrt, abs)
  if (!expression) {
    const functionMatch = text.match(/\b(sin\(x\)|cos\(x\)|tan\(x\)|exp\(x\)|ln\(x\)|log\(x\)|sqrt\(x\)|abs\(x\))\b/i);
    if (functionMatch) expression = functionMatch[1];
  }

  // 3) Simple polynomial/monomial mentions (x2, x^2, -2x+5, etc.)
  if (!expression) {
    const polyMatch = text.match(/\b([-+]?\d*\s*x(?:\s*[\^²³]\s*\d+)?(?:\s*[+\-]\s*\d*\s*x(?:\s*[\^²³]\s*\d+)*)*(?:\s*[+\-]\s*\d+)?)\b/i)
      || text.match(/\b(x\d+)\b/i) // x2
      || text.match(/\b(x\^\d+)\b/i) // x^2
      || text.match(/\b(x²|x³)\b/i);
    if (polyMatch) expression = polyMatch[1] || polyMatch[0];
  }

  if (!expression) return null;

  // Clean and normalize
  expression = expression
    .replace(/[;.,]+$/,'')
    .replace(/\b(sin|cos|tan|exp|ln|log|sqrt|abs)\s+x\b/gi, '$1(x)')  // sin x -> sin(x)
    .replace(/x\s*(\d+)/gi, 'x^$1')  // x2 -> x^2
    .replace(/²/g, '^2')
    .replace(/³/g, '^3')
    .replace(/×/g, '*')
    .replace(/÷/g, '/')
    .replace(/\s+/g, '')
    .replace(/(\d)([a-z])/gi, '$1*$2'); // implicit multiplication

  const title = `f(x) = ${expression}`;
  let xMin = -10, xMax = 10;
  if (/sin|cos|tan/i.test(expression)) { xMin = -2 * Math.PI; xMax = 2 * Math.PI; }
  if (/exp/i.test(expression)) { xMin = -5; xMax = 5; }
  if (/ln|log/i.test(expression)) { xMin = 0.1; xMax = 10; }

  console.log("📊 Detected math function:", expression);
  return { expression, xMin, xMax, title };
};

// Detect user's mathematical intention
const detectMathIntention = (text: string): 'solve' | 'graph' | 'explain' | 'general' => {
  const lowerText = text.toLowerCase();
  
  // Detect method-related keywords that imply solving
  const methodKeywords = /\b(utilise|applique|avec|par|méthode|formule|procède|en\s+utilisant)\b/i;
  const mathTerms = /\b(déterminant|discriminant|factorisation|dérivée|primitive|limite|intégrale|substitution|identification)\b/i;
  
  if (methodKeywords.test(lowerText) && mathTerms.test(lowerText)) {
    return 'solve';
  }
  
  // Priority 1: Explicit solve request
  if (/\b(résou[ds]?|solution|trouv[eé]|calcul[eé]?|réponse|équation)\b/i.test(lowerText)) {
    return 'solve';
  }
  
  // Priority 2: Explicit graph request
  if (/\b(trace|dessine|graph|courbe|représente)\b/i.test(lowerText)) {
    return 'graph';
  }
  
  // Priority 3: Explanation request
  if (/\b(expli[cqu]|[cq]u[' ]est[- ]ce|comment|pourquoi|définition)\b/i.test(lowerText)) {
    return 'explain';
  }
  
  return 'general';
};

// Process base64 in chunks to prevent memory issues
function processBase64Chunks(base64String: string, chunkSize = 32768) {
  const chunks: Uint8Array[] = [];
  let position = 0;
  
  while (position < base64String.length) {
    const chunk = base64String.slice(position, position + chunkSize);
    const binaryChunk = atob(chunk);
    const bytes = new Uint8Array(binaryChunk.length);
    
    for (let i = 0; i < binaryChunk.length; i++) {
      bytes[i] = binaryChunk.charCodeAt(i);
    }
    
    chunks.push(bytes);
    position += chunkSize;
  }

  const totalLength = chunks.reduce((acc, chunk) => acc + chunk.length, 0);
  const result = new Uint8Array(totalLength);
  let offset = 0;

  for (const chunk of chunks) {
    result.set(chunk, offset);
    offset += chunk.length;
  }

  return result;
}

// ====== TEXT-TO-SPEECH PREPARATION FUNCTIONS ======

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

  // Nettoyer les backslashes et accolades restants
  spoken = spoken.replace(/\\/g, '').replace(/[{}]/g, '');

  return spoken.trim();
};

/**
 * Convert LaTeX expressions in text to spoken French
 */
const convertLatexToSpeech = (text: string): string => {
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
const enhancePunctuation = (text: string): string => {
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
const prepareTextForSpeech = (text: string): string => {
  // 1. Convertir le LaTeX en français parlé
  let prepared = convertLatexToSpeech(text);
  
  // 2. Améliorer la ponctuation
  prepared = enhancePunctuation(prepared);
  
  // 3. Normaliser les espaces
  prepared = prepared.replace(/\s{2,}/g, ' ').trim();
  
  return prepared;
};

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { 
      audio, 
      voice = 'nova', 
      conversationHistory = [], 
      welcomeMessage = null, 
      exerciseContext = null, 
      transcribedText = null,
      confirmationNeeded = false,
      skipConfirmation = false,
      confirmationMode = false,
      generateAudioOnly = false
    } = await req.json();
    
    console.log('Exercise context received:', exerciseContext);
    
    // Mode 1: Generate audio only for a given text
    if (generateAudioOnly && transcribedText) {
      console.log('🎤 Generating audio for text...');
      
      const allowedVoices = new Set(['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer']);
      const voiceSafe = allowedVoices.has(voice) ? voice : 'nova';
      
      const ttsResponse = await fetch('https://api.openai.com/v1/audio/speech', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Deno.env.get('OPENAI_API_KEY')}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: 'tts-1-hd',
          input: transcribedText,
          voice: voiceSafe,
          response_format: 'mp3',
          speed: 0.95,
        }),
      });
      
      if (!ttsResponse.ok) {
        const errorText = await ttsResponse.text();
        console.error('TTS error:', errorText);
        throw new Error('TTS API error');
      }
      
      const arrayBuffer = await ttsResponse.arrayBuffer();
      const uint8Array = new Uint8Array(arrayBuffer);
      const base64Audio = encodeBase64(uint8Array);
      
      return new Response(
        JSON.stringify({
          audioContent: base64Audio,
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }
    
    // Mode 2: Transcribe only (for yes/no confirmation)
    if (confirmationMode && audio) {
      console.log('🎤 Transcribing confirmation response...');
      
      const binaryAudio = processBase64Chunks(audio);
      const whisperFormData = new FormData();
      const audioBlob = new Blob([binaryAudio], { type: 'audio/webm' });
      whisperFormData.append('file', audioBlob, 'audio.webm');
      whisperFormData.append('model', 'whisper-1');
      whisperFormData.append('language', 'fr');

      const transcriptionResponse = await fetch('https://api.openai.com/v1/audio/transcriptions', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Deno.env.get('OPENAI_API_KEY')}`,
        },
        body: whisperFormData,
      });

      if (!transcriptionResponse.ok) {
        const errorText = await transcriptionResponse.text();
        console.error('Whisper error:', errorText);
        throw new Error(`Whisper API error: ${errorText}`);
      }

      const transcriptionResult = await transcriptionResponse.json();
      
      return new Response(
        JSON.stringify({
          transcribedText: transcriptionResult.text,
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }
    
    // If it's a welcome message request, generate audio directly
    if (welcomeMessage && !audio) {
      console.log('🎤 Generating welcome message audio...');
      
      // Ensure voice is valid
      const allowedVoices = new Set(['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer']);
      const voiceSafe = allowedVoices.has(voice) ? voice : 'alloy';
      
      const ttsResponse = await fetch('https://api.openai.com/v1/audio/speech', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Deno.env.get('OPENAI_API_KEY')}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: 'tts-1-hd',
          input: welcomeMessage,
          voice: voiceSafe,
          response_format: 'mp3',
          speed: 0.95,
        }),
      });
      
      if (!ttsResponse.ok) {
        const errorText = await ttsResponse.text();
        console.error('TTS error:', errorText);
        throw new Error('TTS API error');
      }
      
      const arrayBuffer = await ttsResponse.arrayBuffer();
      const uint8Array = new Uint8Array(arrayBuffer);
      const base64Audio = encodeBase64(uint8Array);
      
      console.log('Welcome message audio generated successfully');
      
      return new Response(
        JSON.stringify({
          transcribedText: "",
          aiText: welcomeMessage,
          audioContent: base64Audio,
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }
    
    if (!audio && !transcribedText) {
      throw new Error('No audio data or transcribed text provided');
    }

    console.log('Starting voice-chat processing...');
    console.log('Voice selected:', voice);
    console.log('Conversation history length:', conversationHistory.length);
    console.log('Mode:', transcribedText ? 'Local ASR' : 'Cloud Whisper');
    
    const LOVABLE_API_KEY = Deno.env.get('LOVABLE_API_KEY');
    
    // Variable to store image response if generated
    let imageResponseData: any = undefined;

    let finalTranscribedText = transcribedText;
    
    // Step 1: Transcribe audio with OpenAI Whisper (seulement si pas déjà transcrit en local)
    if (!transcribedText && audio) {
      console.log('Step 1: Transcribing audio with Whisper...');
      const binaryAudio = processBase64Chunks(audio);
      
      const whisperFormData = new FormData();
      const audioBlob = new Blob([binaryAudio], { type: 'audio/webm' });
      whisperFormData.append('file', audioBlob, 'audio.webm');
      whisperFormData.append('model', 'whisper-1');
      whisperFormData.append('language', 'fr');

      const transcriptionResponse = await fetch('https://api.openai.com/v1/audio/transcriptions', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Deno.env.get('OPENAI_API_KEY')}`,
        },
        body: whisperFormData,
      });

    if (!transcriptionResponse.ok) {
      const errorText = await transcriptionResponse.text();
      console.error('Whisper transcription error:', errorText);
      throw new Error(`Whisper API error: ${errorText}`);
    }

    const transcriptionResult = await transcriptionResponse.json();
    finalTranscribedText = transcriptionResult.text;
    console.log('Transcribed text:', finalTranscribedText);
    } else if (transcribedText) {
      console.log('Using locally transcribed text:', transcribedText);
    }

    // Normalize French mathematical expressions before detection
    const normalizedText = normalizeMathExpression(finalTranscribedText);
    console.log('Normalized text:', normalizedText);

    // ====== MODE 3: GENERATE CONFIRMATION REQUEST ======
    if (confirmationNeeded && !skipConfirmation) {
      console.log('🔄 Generating confirmation request...');
      
      const confirmationPrompt = `L'élève a dit : "${normalizedText}"
      
Reformule cette demande de manière claire et concise pour confirmer que tu as bien compris.
Commence par : "Si je comprends bien, tu as demandé : "
Puis reformule la demande avec tes propres mots (maximum 15 mots).
Termine par : "Est-ce correct ?"

Réponds uniquement avec la phrase de confirmation, rien d'autre.`;

      const confirmationResponse = await fetch('https://ai.gateway.lovable.dev/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${LOVABLE_API_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: 'google/gemini-2.5-flash',
          messages: [
            { role: 'system', content: 'Tu es Sophie, une assistante pédagogique qui reformule les demandes des élèves pour confirmer leur compréhension.' },
            { role: 'user', content: confirmationPrompt }
          ],
          temperature: 0.3,
          max_tokens: 100,
        }),
      });
      
      if (!confirmationResponse.ok) {
        console.error('Confirmation API error:', await confirmationResponse.text());
        throw new Error('Failed to generate confirmation');
      }
      
      const confirmationResult = await confirmationResponse.json();
      const confirmationText = confirmationResult.choices[0].message.content;
      console.log('Confirmation text:', confirmationText);
      
      // Generate confirmation audio
      const allowedVoices = new Set(['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer']);
      const voiceSafe = allowedVoices.has(voice) ? voice : 'nova';
      
      const ttsResponse = await fetch('https://api.openai.com/v1/audio/speech', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Deno.env.get('OPENAI_API_KEY')}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: 'tts-1-hd',
          input: confirmationText,
          voice: voiceSafe,
          response_format: 'mp3',
          speed: 0.95,
        }),
      });
      
      if (!ttsResponse.ok) {
        console.error('TTS error:', await ttsResponse.text());
        throw new Error('TTS API error');
      }
      
      const audioBuffer = await ttsResponse.arrayBuffer();
      const audioBase64 = encodeBase64(new Uint8Array(audioBuffer));
      
      return new Response(
        JSON.stringify({
          transcribedText: finalTranscribedText,
          aiText: confirmationText,
          audioContent: audioBase64,
          isConfirmation: true
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    // ====== DETECT USER'S INTENTION FIRST ======
    const intention = detectMathIntention(normalizedText);
    console.log('🎯 Detected intention:', intention);

    // ====== PRIORITY 1: HANDLE SOLVE REQUESTS ======
    if (intention === 'solve') {
      console.log("🎯 Solve request detected, delegating to Gemini");
      
      const solvePrompt = `${exerciseContext ? `📚 **CONTEXTE DE L'EXERCICE** :
L'élève travaille actuellement sur : "${exerciseContext.enonce}"
Chapitre : ${exerciseContext.chapitre} | Niveau : ${exerciseContext.niveau}

⚠️ **VÉRIFICATION DE COHÉRENCE OBLIGATOIRE** :
AVANT de répondre, tu DOIS analyser si la demande est cohérente avec l'exercice :

1️⃣ **Si la demande contient des ERREURS** (terminologie incorrecte, méthode inadaptée) :
   - **N'essaie PAS de répondre directement**
   - Explique gentiment l'erreur (1-2 phrases)
   - Propose la correction appropriée
   - Termine par : "Veux-tu que je [action corrigée] ? (Oui/Non)"
   
   Exemples d'erreurs courantes :
   - "déterminant" sur une équation du 2nd degré → corrige avec "discriminant Δ"
   - "méthode des déterminants" sur un système non linéaire → explique que ce n'est pas applicable
   - méthode inadaptée au type de problème → propose l'approche correcte

2️⃣ **Si la demande est COHÉRENTE** :
   - Procède à la résolution complète étape par étape

` : ''}L'élève demande : "${normalizedText}"

${exerciseContext ? `🔍 Analyse d'abord la cohérence de cette demande avec l'exercice "${exerciseContext.enonce}".
Si incohérence détectée → Propose correction et demande validation.
Si cohérent → Résous étape par étape.

` : ''}Il veut RÉSOUDRE cette équation ou ce problème, PAS tracer une courbe.

Sois pédagogue et utilise des formules LaTeX entre $ pour les expressions mathématiques.
Maximum 250 mots.`;

      // Build messages array with conversation history
      const messages = [
        {
          role: 'system',
          content: `Tu es Sophie, une assistante pédagogique en mathématiques bienveillante et patiente.

${exerciseContext ? `📚 **CONTEXTE DE L'EXERCICE EN COURS** :
- Énoncé : ${exerciseContext.enonce}
- Chapitre : ${exerciseContext.chapitre}
- Niveau : ${exerciseContext.niveau}

⚠️ **RÈGLE ABSOLUE DE VÉRIFICATION** :
L'élève travaille sur cet exercice. Tu DOIS vérifier la cohérence AVANT toute réponse.

Si tu détectes une INCOHÉRENCE (terminologie incorrecte, méthode inadaptée) :
1. **N'essaie PAS de résoudre directement**
2. Explique l'erreur gentiment (1-2 phrases max)
3. Propose la correction appropriée
4. **TERMINE TOUJOURS par** : "Veux-tu que je [action corrigée] ? (Oui/Non)"

Exemples de corrections :
- "déterminant" sur équation 2nd degré → "On utilise le **discriminant Δ**, pas le déterminant (réservé aux systèmes linéaires). Veux-tu que je calcule Δ ? (Oui/Non)"
- Méthode inadaptée → "Cette méthode ne s'applique pas ici. Pour ce type de problème, on utilise [méthode correcte]. Veux-tu que je procède ainsi ? (Oui/Non)"

` : ''}Tu dois distinguer clairement :
- "résoudre", "trouver x", "solution" → Résolution d'équation étape par étape
- "tracer", "dessiner", "courbe" → Graphique à afficher
- "expliquer", "qu'est-ce que" → Explication de concept

Adapte ta réponse en fonction de l'intention détectée${exerciseContext ? ' ET du contexte de l\'exercice' : ''}.
Utilise TOUJOURS le format LaTeX avec $ ... $ pour les formules mathématiques.`
        },
        ...conversationHistory.slice(-10),
        { role: 'user', content: solvePrompt }
      ];

      const solveResponse = await fetch('https://ai.gateway.lovable.dev/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${LOVABLE_API_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: 'google/gemini-2.5-flash',
          messages: messages,
          temperature: 0.3,
          max_tokens: 800,
        }),
      });

      if (!solveResponse.ok) {
        const errorText = await solveResponse.text();
        console.error('Solve API error:', errorText);
        throw new Error('Failed to get solution from Gemini');
      }

      const solveResult = await solveResponse.json();
      const solveText = solveResult.choices[0].message.content;
      console.log('📝 Solution text:', solveText);

      // Generate audio for the solution
      const allowedVoices = new Set(['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer']);
      const voiceSafe = allowedVoices.has(voice) ? voice : 'nova';
      
      // Clean text for natural TTS
      const cleanedSolveText = prepareTextForSpeech(solveText);
      
      const ttsResponse = await fetch('https://api.openai.com/v1/audio/speech', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Deno.env.get('OPENAI_API_KEY')}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: 'tts-1-hd',
          input: cleanedSolveText,
          voice: voiceSafe,
          response_format: 'mp3',
          speed: 0.95,
        }),
      });

      if (!ttsResponse.ok) {
        const errorText = await ttsResponse.text();
        console.error('TTS error:', errorText);
        throw new Error('TTS API error');
      }

      const audioBuffer = await ttsResponse.arrayBuffer();
      const audioBase64 = encodeBase64(new Uint8Array(audioBuffer));

      return new Response(
        JSON.stringify({
          transcribedText: finalTranscribedText,
          aiText: solveText,
          audioContent: audioBase64
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    // ====== PRIORITY 2: HANDLE GRAPH REQUESTS ======
    if (intention === 'graph') {
      const mathFunc = detectMathFunction(normalizedText);
      if (mathFunc) {
        console.log("📊 Graph request detected:", mathFunc.expression);
        
        // Validate with Gemini before displaying the graph
        const validationPrompt = `L'élève a dit : "${normalizedText}"
J'ai détecté la fonction : ${mathFunc.expression}

Est-ce correct ? Si oui, confirme en disant "D'accord, je trace..." et explique brièvement la fonction.
Si non, propose une correction et demande confirmation à l'élève.

Réponds de manière concise et naturelle (maximum 2 phrases).`;

        const validationResponse = await fetch('https://ai.gateway.lovable.dev/v1/chat/completions', {
          method: 'POST',
          headers: {
          'Authorization': `Bearer ${LOVABLE_API_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: 'google/gemini-2.5-flash',
          messages: [
            { role: 'system', content: 'Tu es Sophie, une assistante pédagogique qui valide les demandes des élèves.' },
            { role: 'user', content: validationPrompt }
          ],
          temperature: 0.3,
          max_tokens: 150,
        }),
      });
      
      if (!validationResponse.ok) {
        console.error('Validation API error:', await validationResponse.text());
        throw new Error('Failed to validate with Gemini');
      }
      
      const validationResult = await validationResponse.json();
      const validationText = validationResult.choices[0].message.content;
      console.log('Validation text:', validationText);
      
      // Generate validation audio
      const allowedVoices = new Set(['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer']);
      const voiceSafe = allowedVoices.has(voice) ? voice : 'nova';
      
      // Clean text for natural TTS
      const cleanedValidationText = prepareTextForSpeech(validationText);
      
      const ttsResponse = await fetch('https://api.openai.com/v1/audio/speech', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Deno.env.get('OPENAI_API_KEY')}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: 'tts-1-hd',
          input: cleanedValidationText,
          voice: voiceSafe,
          response_format: 'mp3',
          speed: 0.95,
        }),
      });
      
      if (!ttsResponse.ok) {
        console.error('TTS error:', await ttsResponse.text());
        throw new Error('TTS API error');
      }
      
      const audioBuffer = await ttsResponse.arrayBuffer();
      const audioBase64 = encodeBase64(new Uint8Array(audioBuffer));
      
      const graphResponse = {
        type: "math_graph",
        expression: mathFunc.expression,
        xMin: mathFunc.xMin || -10,
        xMax: mathFunc.xMax || 10,
        title: mathFunc.title || `f(x) = ${mathFunc.expression}`,
        message_introduction: validationText
      };
      
      // Return graph response with validation audio
      return new Response(
        JSON.stringify({
          transcribedText: finalTranscribedText,
          aiText: validationText,
          audioContent: audioBase64,
          graphResponse
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }
    } // End of if (intention === 'graph')

    // ====== HANDLE FAILED GRAPH REQUESTS (no function detected) ======
    const seemsLikeMathRequest = /trace|graph|courbe|dessine|fonction/i.test(normalizedText);
    
    if (seemsLikeMathRequest) {
      console.log("⚠️ Math request detected but no function found");
      
      // Ask Gemini to propose a correction
      const correctionPrompt = `L'élève a dit : "${normalizedText}"
Il semble vouloir tracer une fonction, mais je n'ai pas compris quelle fonction.

Propose-lui gentiment de reformuler ou donne-lui des exemples de ce qu'il peut demander.
Sois concis (maximum 2 phrases).`;

      const correctionResponse = await fetch('https://ai.gateway.lovable.dev/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${LOVABLE_API_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model: 'google/gemini-2.5-flash',
          messages: [
            { role: 'system', content: 'Tu es Sophie, une assistante pédagogique patiente.' },
            { role: 'user', content: correctionPrompt }
          ],
          temperature: 0.4,
          max_tokens: 150,
        }),
      });
      
      if (correctionResponse.ok) {
        const correctionResult = await correctionResponse.json();
        const correctionText = correctionResult.choices[0].message.content;
        console.log('Correction text:', correctionText);
        
        // Generate correction audio
        const allowedVoices = new Set(['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer']);
        const voiceSafe = allowedVoices.has(voice) ? voice : 'nova';
        
        // Clean text for natural TTS
        const cleanedCorrectionText = prepareTextForSpeech(correctionText);
        
        const ttsResponse = await fetch('https://api.openai.com/v1/audio/speech', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${Deno.env.get('OPENAI_API_KEY')}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            model: 'tts-1-hd',
            input: cleanedCorrectionText,
            voice: voiceSafe,
            response_format: 'mp3',
            speed: 0.95,
          }),
        });
        
        if (ttsResponse.ok) {
          const audioBuffer = await ttsResponse.arrayBuffer();
          const audioBase64 = encodeBase64(new Uint8Array(audioBuffer));
          
          return new Response(
            JSON.stringify({
              transcribedText: finalTranscribedText,
              aiText: correctionText,
              audioContent: audioBase64
            }),
            {
              headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            }
          );
        }
      }
      // If correction fails, continue with normal flow
    }

    // ====== PRIORITY 2: INTERCEPTION DES DEMANDES D'IMAGES (GEMINI) ======
    if (detectImageRequest(finalTranscribedText) && LOVABLE_API_KEY) {
      console.log("🎨 Image request detected:", finalTranscribedText.substring(0, 100));
      
      try {
        const imageBase64 = await generateImage(finalTranscribedText, LOVABLE_API_KEY);
        
        if (imageBase64) {
          console.log("✅ Image generated successfully");
          
          imageResponseData = {
            type: "image_generee",
            message_introduction: "Voici l'image que tu m'as demandée ! 🎨",
            image_base64: imageBase64,
            description: finalTranscribedText
          };
          
          // Continue to generate audio for the description
          console.log("✅ Image generated, now generating audio for description");
          // Don't return yet, continue to text + audio generation below
        } else {
          console.warn("⚠️ Image generation failed, falling back to text explanation");
          // Continue with normal flow to let Gemini explain in text
        }
      } catch (error) {
        console.error("❌ Error in image generation:", error);
        // Continue with normal flow
      }
    }

    // Step 2: Process with Gemini 2.5 Flash via Lovable AI
    console.log('Step 2: Processing with Gemini 2.5 Flash...');
    
    // Build messages array with conversation history (last 10 messages)
    const messages = [
      {
        role: 'system',
        content: `Tu es Sophie, une assistante pédagogique en mathématiques bienveillante et patiente qui répond en français de manière naturelle et conversationnelle.

${exerciseContext ? `📚 **CONTEXTE DE L'EXERCICE EN COURS** :
- Énoncé : ${exerciseContext.enonce}
- Chapitre : ${exerciseContext.chapitre}
- Niveau : ${exerciseContext.niveau}

⚠️ **RÈGLE ABSOLUE : VÉRIFICATION DE COHÉRENCE** :
L'élève travaille sur cet exercice. **AVANT TOUTE RÉPONSE**, tu dois vérifier la cohérence de sa demande.

**Si tu détectes une INCOHÉRENCE** (terminologie incorrecte, méthode inadaptée, demande hors-sujet) :
1. **NE RÉPONDS PAS directement à sa question erronée**
2. Explique gentiment l'erreur (1-2 phrases courtes)
3. Propose la ou les corrections appropriées
4. **TERMINE OBLIGATOIREMENT par une question de validation** : "Veux-tu que je [action corrigée] ? (Oui/Non)"

Exemples concrets :
- Élève dit "utilise la méthode des déterminants" sur $x^2 - 5x + 6 = 0$
  → "Pour une équation du second degré, on utilise le **discriminant Δ**, pas le déterminant (qui sert pour les systèmes linéaires). Veux-tu que je calcule le discriminant ? (Oui/Non)"
  
- Élève demande une méthode non applicable
  → "Cette méthode ne s'applique pas ici. Pour ce type d'exercice (${exerciseContext.chapitre}), on utilise plutôt [méthode correcte]. Veux-tu que je procède ainsi ? (Oui/Non)"

**Si la demande est COHÉRENTE** : réponds normalement et aide-le dans ce contexte.

` : ''}🎯 DISTINCTIONS IMPORTANTES :
- Si l'élève dit "résoudre", "trouver x", "solution", "calculer" : il veut RÉSOUDRE une équation (pas tracer)
- Si l'élève dit "tracer", "dessiner", "courbe", "graphique" : il veut voir un GRAPHIQUE
- Si l'élève dit "expliquer", "qu'est-ce que", "comment" : il veut COMPRENDRE un concept

⚠️ RÈGLE SUR LES IMAGES :
❌ NE DIS JAMAIS "En tant qu'IA textuelle, je ne peux pas dessiner d'images"
❌ NE DIS JAMAIS "je ne peux pas créer d'images directement"
Les demandes d'images sont gérées automatiquement par un système dédié.

🔢 FORMAT LATEX OBLIGATOIRE :
Utilise TOUJOURS des délimiteurs $ ... $ ou $$ ... $$ pour les formules mathématiques dans tes réponses.

RÈGLES STRICTES :
✅ Fractions : $\\frac{numerateur}{denominateur}$ (JAMAIS "frac3x", "fracu(x)v(x)")
✅ Sommes : $\\sum_{k=1}^{n}$ (JAMAIS "sum k=1^n")
✅ Produits : $\\prod_{k=1}^{n}$ (JAMAIS "prod k=1^n")
✅ Fonctions : $\\sin(x)$, $\\cos^2(x)$, $\\ln(x)$ (TOUJOURS avec backslash)
✅ Racines : $\\sqrt{x}$ (JAMAIS "sqrt x")
✅ Puissances : $x^2$, $e^{x}$ (TOUJOURS entre $ ... $)
✅ Limites : $\\lim_{x \\to 0}$ (JAMAIS "lim x->0")
✅ Intégrales : $\\int_{a}^{b} f(x)\\,dx$ (JAMAIS "int_a^b")
✅ Dérivées : $f'(x)$, $f''(x)$ (entre $ ... $)
✅ Pi : $\\pi$, $2\\pi$, $\\frac{\\pi}{2}$

EXEMPLES CORRECTS :
✅ "La dérivée de $f(x) = \\frac{3x - 12}{x}$ est..."
✅ "Pour $\\sum_{k=1}^{n} k = \\frac{n(n+1)}{2}$..."
✅ "Avec $\\lim_{x \\to 0} \\frac{\\sin(x)}{x} = 1$..."

EXEMPLES INTERDITS :
❌ "La dérivée de frac3x - 12 - x est..."
❌ "Pour sum k=1^n k = fracn(n+1)2..."
❌ "Avec lim x->0 sin(x)/x = 1..."

Adapte ta réponse en fonction de l'intention détectée et applique ces règles SYSTÉMATIQUEMENT.`
      }
    ];

    // Add last 10 messages from history
    const recentHistory = conversationHistory.slice(-10);
    messages.push(...recentHistory);

    // Add current user message
    messages.push({
      role: 'user',
      content: finalTranscribedText
    });

    const geminiResponse = await fetch('https://ai.gateway.lovable.dev/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${Deno.env.get('LOVABLE_API_KEY')}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'google/gemini-2.5-flash',
        messages: messages,
        temperature: 0.2,
        top_p: 0.9,
        max_tokens: 1000,
      }),
    });

    if (!geminiResponse.ok) {
      const errorText = await geminiResponse.text();
      console.error('Gemini API error:', errorText);
      throw new Error(`Gemini API error: ${errorText}`);
    }

    const geminiResult = await geminiResponse.json();
    const aiText = geminiResult.choices[0].message.content;
    console.log('AI response:', aiText);

    // Step 3: Generate audio with OpenAI TTS
    console.log('Step 3: Generating audio with TTS...');
    
    // Ensure voice is valid
    const allowedVoices = new Set(['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer']);
    const voiceSafe = allowedVoices.has(voice) ? voice : 'alloy';
    
    // Clean text for natural TTS
    const cleanedAiText = prepareTextForSpeech(aiText);
    
    const ttsResponse = await fetch('https://api.openai.com/v1/audio/speech', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${Deno.env.get('OPENAI_API_KEY')}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'tts-1-hd',
        input: cleanedAiText,
        voice: voiceSafe,
        response_format: 'mp3',
        speed: 0.95,
      }),
    });

    if (!ttsResponse.ok) {
      const errorText = await ttsResponse.text();
      console.error('TTS error:', errorText);
      throw new Error(`TTS API error: ${errorText}`);
    }

    // Convert audio buffer to base64 properly
    const arrayBuffer = await ttsResponse.arrayBuffer();
    const uint8Array = new Uint8Array(arrayBuffer);
    const base64Audio = encodeBase64(uint8Array);
    
    console.log('Voice-chat processing completed successfully');
    console.log('Audio size:', uint8Array.length, 'bytes, base64 length:', base64Audio.length);

    return new Response(
      JSON.stringify({
        transcribedText: finalTranscribedText,
        aiText,
        audioContent: base64Audio,
        imageResponse: imageResponseData
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );

  } catch (error) {
    console.error('Error in voice-chat function:', error);
    return new Response(
      JSON.stringify({ error: error instanceof Error ? error.message : 'Unknown error' }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  }
});
