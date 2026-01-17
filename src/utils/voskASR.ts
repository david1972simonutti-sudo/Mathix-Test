/**
 * Whisper ASR Local - Transcription vocale offline avec Transformers.js
 * Modèle: Xenova/whisper-small (~240 MB, bonne précision français)
 */

import { pipeline } from '@huggingface/transformers';

const MODEL_NAME = 'Xenova/whisper-small';

let whisperPipeline: any = null;
let isInitializing = false;

/**
 * Initialise le modèle Whisper (télécharge si nécessaire)
 */
export async function initVoskModel(
  onProgress?: (progressPercent: number) => void,
  onError?: (error: Error) => void
): Promise<{ duration: number; cached: boolean }> {
  // Éviter l'initialisation multiple simultanée
  if (isInitializing) {
    console.log('⏳ Initialisation déjà en cours...');
    throw new Error('Initialisation déjà en cours');
  }
  
  if (whisperPipeline) {
    console.log('✅ Modèle Whisper déjà chargé');
    return { duration: 0, cached: true };
  }

  try {
    isInitializing = true;
    const startTime = Date.now();
    console.log('🔧 Initialisation du modèle Whisper (~240 MB)...');
    console.log('📍 Modèle:', MODEL_NAME);
    
    // Créer le pipeline ASR avec progression
    whisperPipeline = await pipeline(
      'automatic-speech-recognition',
      MODEL_NAME,
      {
        progress_callback: (progress: any) => {
          if (onProgress && progress.progress !== undefined) {
            const percent = Math.round(progress.progress);
            console.log(`📥 Téléchargement: ${percent}%`);
            onProgress(percent);
          }
        }
      }
    );
    
    const duration = Date.now() - startTime;
    console.log(`✅ Modèle Whisper prêt (${Math.floor(duration / 1000)}s)`);
    
    // Définir le cache
    try { localStorage.setItem('whisper_small_cached', '1'); } catch {}
    
    return { duration, cached: false };
    
  } catch (error) {
    console.error('❌ Erreur initialisation Whisper:', error);
    if (onError) {
      onError(error instanceof Error ? error : new Error(String(error)));
    }
    throw error;
  } finally {
    isInitializing = false;
  }
}

/**
 * Transcrit un audio avec Whisper
 */
export async function transcribeAudioVosk(audioBlob: Blob): Promise<string> {
  if (!whisperPipeline) {
    throw new Error("Modèle Whisper non initialisé. Appelez initVoskModel() d'abord.");
  }
  
  try {
    console.log('🎤 Transcription locale avec Whisper...');
    const startTime = performance.now();
    
    // Créer une URL temporaire pour le blob audio
    const audioUrl = URL.createObjectURL(audioBlob);
    
    try {
      // Transcription avec Whisper
      const result = await whisperPipeline(audioUrl, {
        language: 'french',
        task: 'transcribe',
      });
      
      const duration = performance.now() - startTime;
      console.log(`✅ Transcription terminée en ${duration.toFixed(0)}ms`);
      
      // Gérer le résultat qui peut être un tableau ou un objet
      const text = Array.isArray(result) ? result[0]?.text || '' : result.text || '';
      console.log('📝 Texte transcrit:', text);
      
      return text;
    } finally {
      // Nettoyer l'URL temporaire
      URL.revokeObjectURL(audioUrl);
    }
    
  } catch (error) {
    console.error('❌ Erreur transcription Whisper:', error);
    throw error;
  }
}

/**
 * Nettoie les ressources Whisper
 */
export function cleanupVoskModel(): void {
  whisperPipeline = null;
  console.log('🧹 Modèle Whisper nettoyé');
}

/**
 * Vérifie si le modèle Whisper est prêt
 */
export function isVoskReady(): boolean {
  return whisperPipeline !== null;
}

/**
 * Indique si le modèle a déjà été téléchargé sur cet appareil
 */
export function isVoskModelCached(): boolean {
  try {
    return localStorage.getItem('whisper_small_cached') === '1';
  } catch {
    return false;
  }
}
