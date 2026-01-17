/**
 * Utility functions for audio processing in VoiceChatbot
 */

/**
 * Convert a Blob to base64 string
 */
export const blobToBase64 = (blob: Blob): Promise<string> => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onloadend = () => {
      const base64 = (reader.result as string).split(',')[1];
      resolve(base64);
    };
    reader.onerror = reject;
    reader.readAsDataURL(blob);
  });
};

import { prepareTextForSpeech } from './mathToSpeech';

/**
 * Clean text for speech synthesis by converting LaTeX math and enhancing punctuation
 */
export const cleanForSpeech = (text: string): string => {
  return prepareTextForSpeech(text);
};
