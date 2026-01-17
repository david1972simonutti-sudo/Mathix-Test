import { pipeline } from '@huggingface/transformers';

const MODEL_NAME = 'onnx-community/DeepSeek-R1-Distill-Qwen-1.5B-ONNX';

let deepseekPipeline: any = null;
let isInitializing = false;

/**
 * Dictionnaire de corrections fréquentes (cache statique)
 */
const MATH_CORRECTIONS: Record<string, string> = {
  'terrain de dalis': 'théorème de Thalès',
  'dalice': 'de Thalès',
  'x o car': 'x au carré',
  'x car': 'x au carré',
  'ikse car': 'x au carré',
  'racine de deux': 'racine de 2',
  'racine deux': 'racine de 2',
  'pi ta gore': 'Pythagore',
  'pita gore': 'Pythagore',
  'dérivée de f': "f prime",
  'air sous la courbe': 'intégrale',
};

/**
 * Initialise le modèle DeepSeek Math
 */
export async function initDeepSeekMath(
  onProgress?: (progressPercent: number) => void
): Promise<{ duration: number; cached: boolean }> {
  if (!('gpu' in navigator)) {
    throw new Error('WebGPU non disponible - DeepSeek Math nécessite Chrome 113+');
  }

  if (isInitializing) {
    throw new Error('Initialisation déjà en cours');
  }
  
  if (deepseekPipeline) {
    return { duration: 0, cached: true };
  }

  try {
    isInitializing = true;
    const startTime = Date.now();
    console.log('🔧 Initialisation DeepSeek Math (~1.5 GB)...');
    
    deepseekPipeline = await pipeline(
      'text-generation',
      MODEL_NAME,
      {
        device: 'webgpu',
        dtype: 'q4f16',
        progress_callback: (progress: any) => {
          if (onProgress && progress.progress !== undefined) {
            const percent = Math.round(progress.progress);
            onProgress(percent);
          }
        }
      }
    );
    
    const duration = Date.now() - startTime;
    console.log(`✅ DeepSeek Math prêt (${Math.floor(duration / 1000)}s)`);
    
    try { 
      localStorage.setItem('deepseek_math_cached', '1'); 
    } catch {}
    
    return { duration, cached: false };
    
  } catch (error) {
    console.error('❌ Erreur initialisation DeepSeek:', error);
    throw error;
  } finally {
    isInitializing = false;
  }
}

/**
 * Corrige les termes mathématiques mal transcrits
 */
export async function correctMathTranscription(rawText: string): Promise<string> {
  if (!deepseekPipeline) {
    throw new Error("DeepSeek Math non initialisé");
  }
  
  try {
    console.log('🔍 Correction mathématique...');
    const startTime = performance.now();
    
    // Appliquer les corrections connues d'abord
    let correctedText = rawText;
    let hasKnownCorrection = false;
    
    for (const [wrong, correct] of Object.entries(MATH_CORRECTIONS)) {
      const regex = new RegExp(wrong, 'gi');
      if (regex.test(correctedText)) {
        correctedText = correctedText.replace(regex, correct);
        hasKnownCorrection = true;
      }
    }
    
    // Si corrections connues suffisent
    if (hasKnownCorrection && !needsComplexCorrection(correctedText)) {
      console.log(`✅ Correction terminée (cache)`);
      return correctedText;
    }
    
    // Utiliser DeepSeek pour corrections complexes
    const prompt = `Tu es un correcteur spécialisé en transcriptions audio de mathématiques françaises.

Texte original : "${correctedText}"

Tâche : Corrige UNIQUEMENT les termes mathématiques mal transcrits.

Règles strictes :
- Conserve le reste du texte tel quel
- Ne change que les termes mathématiques incorrects
- Ne rajoute AUCUNE explication
- Réponds UNIQUEMENT avec le texte corrigé

Texte corrigé :`;

    const result = await deepseekPipeline(prompt, {
      max_new_tokens: 150,
      temperature: 0.1,
      do_sample: false,
      repetition_penalty: 1.1,
    });
    
    let finalText = result[0].generated_text.replace(prompt, '').trim();
    finalText = finalText
      .replace(/^["']|["']$/g, '')
      .replace(/\n/g, ' ')
      .trim();
    
    const duration = performance.now() - startTime;
    console.log(`✅ Correction terminée en ${duration.toFixed(0)}ms`);
    
    return finalText;
    
  } catch (error) {
    console.error('❌ Erreur correction:', error);
    return rawText;
  }
}

function needsComplexCorrection(text: string): boolean {
  const complexPatterns = [
    /\b(fonction|équation|formule|expression)\b.*\b(incorrect|bizarre|étrange)\b/i,
    /\d+\s+[a-z]+\s+\d+/i,
    /[a-z]{1,2}\s+o\s+[a-z]/i,
  ];
  
  return complexPatterns.some(pattern => pattern.test(text));
}

export function isDeepSeekReady(): boolean {
  return deepseekPipeline !== null;
}

export function isDeepSeekCached(): boolean {
  try {
    return localStorage.getItem('deepseek_math_cached') === '1';
  } catch {
    return false;
  }
}

export function isWebGPUAvailable(): boolean {
  return 'gpu' in navigator;
}
