import { useState, useEffect, useRef } from 'react';
import { Mic, MicOff, Loader2, Volume2, RotateCcw, StopCircle, MessageSquare } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { Progress } from '@/components/ui/progress';
import { Label } from '@/components/ui/label';
import { useToast } from '@/hooks/use-toast';
import { supabase } from '@/integrations/supabase/client';
import { blobToBase64, cleanForSpeech } from '@/utils/audioUtils';
import { MathGraph } from '@/components/MathGraph';
import { MathText } from '@/components/MathText';
import { MessageFeedback } from '@/components/chat/MessageFeedback';
import { normalizeChatText } from '@/utils/normalizeChatText';
import { initVoskModel, transcribeAudioVosk, isVoskReady, isVoskModelCached } from '@/utils/voskASR';
import { initDeepSeekMath, correctMathTranscription, isDeepSeekReady, isDeepSeekCached, isWebGPUAvailable } from '@/utils/deepseekMath';
import { useTrackFirstChatUse } from '@/hooks/useTrackFirstChatUse';

interface VoiceMessage {
  id?: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: Date;
  audioUrl?: string;
}

interface VoiceChatbotProps {
  userId: string;
  sessionId: string;
  userProfile: any;
  currentChatId: string | null;
  onChatCreated: (chatId: string) => void;
  onBackToTextChat?: () => void;
}

const VOICES = [
  { value: 'alloy', label: 'Alloy', emoji: '🎭', description: 'Neutre et équilibrée' },
  { value: 'echo', label: 'Echo', emoji: '🎸', description: 'Masculine et claire' },
  { value: 'fable', label: 'Fable', emoji: '📖', description: 'Expressive et chaleureuse' },
  { value: 'onyx', label: 'Onyx', emoji: '💎', description: 'Profonde et autoritaire' },
  { value: 'nova', label: 'Nova', emoji: '⭐', description: 'Féminine et dynamique' },
  { value: 'shimmer', label: 'Shimmer', emoji: '✨', description: 'Douce et apaisante' }
];

// Detect the best supported audio format for the browser
const getSupportedMimeType = (): string => {
  const types = [
    'audio/webm;codecs=opus',
    'audio/webm',
    'audio/ogg;codecs=opus',
    'audio/mp4',
    'audio/mpeg',
    'audio/wav'
  ];
  
  for (const type of types) {
    if (MediaRecorder.isTypeSupported(type)) {
      console.log('✅ Using supported audio format:', type);
      return type;
    }
  }
  
  console.warn('⚠️ No preferred audio format supported, using browser default');
  return '';
};

const VoiceChatbot = ({ userId, sessionId, userProfile, currentChatId, onChatCreated, onBackToTextChat }: VoiceChatbotProps) => {
  const { toast } = useToast();
  const [messages, setMessages] = useState<VoiceMessage[]>([]);
  const [isRecording, setIsRecording] = useState(false);
  const [isProcessing, setIsProcessing] = useState(false);
  const [isPlaying, setIsPlaying] = useState(false);
  const [selectedVoice, setSelectedVoice] = useState('nova');
  const [micPermission, setMicPermission] = useState<'pending' | 'granted' | 'denied'>('pending');
  const [hasClickedOnce, setHasClickedOnce] = useState(false);
  const [hasPlayedWelcome, setHasPlayedWelcome] = useState(false);
  const [availableFrenchVoices, setAvailableFrenchVoices] = useState<SpeechSynthesisVoice[]>([]);
  
  // ASR Mode states
  const [asrMode, setAsrMode] = useState<'local' | 'cloud'>('local'); // Local par défaut
  const [modelStatus, setModelStatus] = useState<'not-loaded' | 'downloading' | 'ready' | 'error'>('not-loaded');
  const [downloadProgress, setDownloadProgress] = useState<{ loaded: number; total: number } | null>(null);
  const [downloadStartTime, setDownloadStartTime] = useState<number | null>(null);
  
  // DeepSeek Math states
  const [deepseekStatus, setDeepseekStatus] = useState<'not-loaded' | 'downloading' | 'ready' | 'error' | 'disabled'>('not-loaded');
  const [deepseekProgress, setDeepseekProgress] = useState<{ loaded: number; total: number } | null>(null);
  const [useMathCorrection, setUseMathCorrection] = useState(true);
  const [webGPUAvailable, setWebGPUAvailable] = useState(false);
  
  // Confirmation state
  const [pendingConfirmation, setPendingConfirmation] = useState<{
    transcribedText: string;
    normalizedText: string;
    conversationHistory: any[];
    exerciseContext: any;
  } | null>(null);
  
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const audioChunksRef = useRef<Blob[]>([]);
  const currentAudioRef = useRef<HTMLAudioElement | null>(null);
  const speechSynthesisRef = useRef<SpeechSynthesisUtterance | null>(null);
  const scrollAreaRef = useRef<HTMLDivElement>(null);

  // Track first chat use
  const { trackFirstMessage } = useTrackFirstChatUse(userId);

  // Helper function to safely decode base64 audio
  const safeBase64ToUint8 = (base64: string): Uint8Array => {
    try {
      const clean = base64.replace(/[^A-Za-z0-9+/=]/g, '');
      const pad = clean.length % 4 === 0 ? clean : clean + '='.repeat(4 - (clean.length % 4));
      const binary = atob(pad);
      const bytes = new Uint8Array(binary.length);
      for (let i = 0; i < binary.length; i++) {
        bytes[i] = binary.charCodeAt(i);
      }
      return bytes;
    } catch (error) {
      console.error('Base64 decode error:', error);
      throw error;
    }
  };

  // Check and init Vosk model on mount
  useEffect(() => {
    const initVosk = async () => {
      console.log('🔧 Vérification du modèle Vosk local...');
      try {
        if (isVoskModelCached()) {
          setModelStatus('downloading');
          setDownloadStartTime(Date.now());
          setDownloadProgress({ loaded: 0, total: 100 });
          toast({
            title: "Mode Local",
            description: "Modèle détecté. Initialisation en cours…",
          });
          
          // Progression réaliste pendant l'initialisation
          const progressInterval = setInterval(() => {
            setDownloadProgress(prev => {
              if (!prev) return { loaded: 5, total: 100 };
              const newProgress = Math.min(prev.loaded + 3, 95);
              return { ...prev, loaded: newProgress };
            });
          }, 300);
          
          try {
            const result = await initVoskModel();
            clearInterval(progressInterval);
            
            setDownloadProgress({ loaded: 100, total: 100 });
            await new Promise(resolve => setTimeout(resolve, 300));
            
            setModelStatus('ready');
            setDownloadProgress(null);
            setDownloadStartTime(null);
            
            toast({
              title: "✅ Initialisation terminée",
              description: `Modèle Vosk prêt en ${Math.floor(result.duration / 1000)}s !`,
              duration: 5000,
            });
          } catch (error) {
            clearInterval(progressInterval);
            console.error('❌ Erreur initialisation Vosk:', error);
            setModelStatus('error');
            setAsrMode('cloud');
            setDownloadProgress(null);
            setDownloadStartTime(null);
            toast({
              title: "❌ Échec de l'initialisation locale",
              description: "Basculement vers le mode Cloud",
              variant: "destructive",
            });
          }
        } else {
          setModelStatus('not-loaded');
          toast({
            title: "Mode Local",
            description: "Cliquez sur Télécharger pour installer Vosk français (1.4 GB)",
          });
        }
      } catch (e) {
        console.error('Erreur init Vosk:', e);
        setModelStatus('error');
        setDownloadProgress(null);
        setDownloadStartTime(null);
      }
    };

    initVosk();
  }, [toast]);

  // Check DeepSeek availability on mount (no auto-init)
  useEffect(() => {
    const checkDeepSeek = () => {
      const hasWebGPU = isWebGPUAvailable();
      setWebGPUAvailable(hasWebGPU);
      
      if (!hasWebGPU) {
        setDeepseekStatus('disabled');
        setUseMathCorrection(false);
        return;
      }
      
      // Just check if cached, but don't auto-initialize
      if (isDeepSeekCached()) {
        setDeepseekStatus('ready');
        toast({
          title: "✅ DeepSeek Math disponible",
          description: "Modèle déjà téléchargé",
        });
      } else {
        setDeepseekStatus('not-loaded');
      }
    };
    
    checkDeepSeek();
  }, [toast]);


  // Load available French voices on mount
  useEffect(() => {
    const loadVoices = () => {
      const voices = window.speechSynthesis.getVoices();
      const frenchVoices = voices.filter(v => v.lang.startsWith('fr'));
      
      // Prioritize Enhanced, Premium, or Natural voices
      frenchVoices.sort((a, b) => {
        const aScore = (a.name.match(/enhanced|premium|natural/i) ? 10 : 0) +
                       (a.localService ? 5 : 0); // Local voices are faster
        const bScore = (b.name.match(/enhanced|premium|natural/i) ? 10 : 0) +
                       (b.localService ? 5 : 0);
        return bScore - aScore;
      });
      
      setAvailableFrenchVoices(frenchVoices);
      if (frenchVoices.length > 0) {
        console.log('🎤 Best French voice selected:', frenchVoices[0].name);
      }
    };

    // Voices load asynchronously
    if (window.speechSynthesis.onvoiceschanged !== undefined) {
      window.speechSynthesis.onvoiceschanged = loadVoices;
    }
    loadVoices();
  }, []);

  // Load chat history from localStorage on mount
  useEffect(() => {
    const loadFromLocalStorage = () => {
      const stored = localStorage.getItem(`voice-chat-${sessionId}`);
      if (stored) {
        try {
          const parsed = JSON.parse(stored);
          setMessages(parsed.map((m: any) => ({
            ...m,
            timestamp: new Date(m.timestamp)
          })));
        } catch (e) {
          console.error('Error loading chat history:', e);
        }
      }
    };

    loadFromLocalStorage();
  }, [sessionId]);

  // Auto-save to localStorage when messages change
  useEffect(() => {
    if (messages.length > 0) {
      const messagesForStorage = messages
        .slice(-100)
        .map(({ role, content, timestamp }) => ({ 
          role, 
          content, 
          timestamp: timestamp.toISOString() 
        }));
      
      localStorage.setItem(`voice-chat-${sessionId}`, JSON.stringify(messagesForStorage));
    }
  }, [messages, sessionId]);

  // Auto-scroll to bottom when new messages arrive
  useEffect(() => {
    if (scrollAreaRef.current) {
      const scrollContainer = scrollAreaRef.current.querySelector('[data-radix-scroll-area-viewport]');
      if (scrollContainer) {
        scrollContainer.scrollTop = scrollContainer.scrollHeight;
      }
    }
  }, [messages]);

  // Play welcome message on mount
  useEffect(() => {
    const playWelcome = async () => {
      if (hasPlayedWelcome || !userProfile?.prenom) return;
      
      // Slight delay to ensure everything is ready
      await new Promise(resolve => setTimeout(resolve, 500));
      
      const welcomeText = `Bonjour ${userProfile.prenom}, comment vas-tu aujourd'hui ? Comment puis-je t'aider ?`;
      
      try {
        setIsProcessing(true);
        
        const { data, error } = await supabase.functions.invoke('voice-chat', {
          body: {
            audio: null,
            voice: selectedVoice,
            conversationHistory: [],
            welcomeMessage: welcomeText
          }
        });
        
        if (error) throw error;
        
        const assistantMessage: VoiceMessage = {
          role: 'assistant',
          content: welcomeText,
          timestamp: new Date(),
          audioUrl: `data:audio/mpeg;base64,${data.audioContent}`
        };
        
        setMessages([assistantMessage]);
        await saveToChatHistory(assistantMessage, currentChatId);
        
        // Play audio automatically
        await autoPlayAudio(data.audioContent, welcomeText);
        
        setHasPlayedWelcome(true);
        
        toast({
          title: "👋 Bienvenue !",
          description: "Sophie t'accueille",
        });
      } catch (error) {
        console.error('Error playing welcome message:', error);
        // Don't show error toast for welcome message, just continue
      } finally {
        setIsProcessing(false);
      }
    };
    
    playWelcome();
  }, [userProfile, selectedVoice, hasPlayedWelcome, currentChatId]);

  const startRecording = async () => {
    setHasClickedOnce(true);
    
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ 
        audio: {
          sampleRate: 16000,
          channelCount: 1,
          echoCancellation: true,
          noiseSuppression: true
        } 
      });
      
      setMicPermission('granted');
      
      const mimeType = getSupportedMimeType();
      const recorder = new MediaRecorder(stream, mimeType ? { mimeType } : undefined);
      
      audioChunksRef.current = [];
      
      recorder.ondataavailable = (e) => {
        if (e.data.size > 0) {
          audioChunksRef.current.push(e.data);
        }
      };
      
      recorder.onstop = async () => {
        const recordedMimeType = mimeType || recorder.mimeType || 'audio/webm';
        console.debug('📼 Recording stopped, MIME type:', recordedMimeType);
        const audioBlob = new Blob(audioChunksRef.current, { type: recordedMimeType });
        await handleAudioSubmission(audioBlob);
        stream.getTracks().forEach(track => track.stop());
      };
      
      recorder.start();
      mediaRecorderRef.current = recorder;
      setIsRecording(true);
      
      if (micPermission === 'pending') {
        toast({
          title: "🎤 Micro activé !",
          description: "Parle maintenant, je t'écoute",
        });
      } else {
        toast({
          title: "🎤 Enregistrement...",
          description: "Parle maintenant",
        });
      }
    } catch (error: any) {
      console.error('Error starting recording:', error);
      setMicPermission('denied');
      toast({
        title: "❌ Erreur microphone",
        description: error.message || "Impossible d'accéder au microphone. Vérifie les permissions de ton navigateur.",
        variant: "destructive",
      });
    }
  };

  const stopRecording = () => {
    if (mediaRecorderRef.current && mediaRecorderRef.current.state !== 'inactive') {
      mediaRecorderRef.current.stop();
    }
    setIsRecording(false);
  };

  const saveToChatHistory = async (message: VoiceMessage, chatId: string | null = null) => {
    const finalChatId = chatId || currentChatId;
    if (!finalChatId) return; // Skip if no chat active
    
    try {
      await supabase.from('chat_history').insert({
        user_id: userId,
        chat_id: finalChatId,
        role: message.role,
        content: message.content,
      });
    } catch (error) {
      console.error('Error saving to chat history:', error);
    }
  };

  // Helper: Coerce exercise payload to valid format
  const coerceExercisePayload = (payload: any): any | null => {
    if (!payload) return null;

    // If already an object with type "exercice_genere", return as-is
    if (typeof payload === 'object' && payload.type === "exercice_genere") {
      return payload;
    }

    // If it's a string, try to parse JSON
    if (typeof payload === 'string') {
      // Try to extract JSON from code fence
      const codeFenceMatch = payload.match(/```json\s*(\{[\s\S]*?\})\s*```/);
      if (codeFenceMatch) {
        try {
          const parsed = JSON.parse(codeFenceMatch[1]);
          if (parsed.enonce) return { ...parsed, type: "exercice_genere" };
        } catch (e) {
          console.debug('Failed to parse JSON from code fence');
        }
      }

      // Try to extract first JSON object
      const jsonMatch = payload.match(/\{[\s\S]*?\}/);
      if (jsonMatch) {
        try {
          const parsed = JSON.parse(jsonMatch[0]);
          if (parsed.enonce) return { ...parsed, type: "exercice_genere" };
        } catch (e) {
          console.debug('Failed to parse JSON object');
        }
      }

      return null;
    }

    // If it's an object without type but has exercise markers
    if (typeof payload === 'object' && payload.enonce) {
      const hasExerciseMarkers = payload.chapitre || payload.indices || 
                                 payload.solution_complete || payload.message_introduction || 
                                 payload.difficulte;
      if (hasExerciseMarkers) {
        return { ...payload, type: "exercice_genere" };
      }
    }

    return null;
  };

  // Helper: Detect if AI generated an exercise
  const isExerciseFromAI = (payload: any): boolean => {
    return coerceExercisePayload(payload) !== null;
  };

  const createNewChatWithExercice = async (exerciceDataOrId: any) => {
    try {
      let exerciceId: string;

      if (typeof exerciceDataOrId === 'string' || exerciceDataOrId.exercice_id) {
        exerciceId = typeof exerciceDataOrId === 'string' ? exerciceDataOrId : exerciceDataOrId.exercice_id;
        console.log("✅ Using existing exercise ID:", exerciceId);
      } else {
        const enonce = exerciceDataOrId.enonce;
        const solution = exerciceDataOrId.solution_complete || exerciceDataOrId.solution || "Solution disponible via le corrigé";
        const chapitre = exerciceDataOrId.chapitre || (exerciceDataOrId.type === "exercice_genere" ? "Exercice généré (vocal)" : "Exercice vocal");
        const niveau = exerciceDataOrId.niveau || userProfile?.classe || "Lycée";
        const indices = exerciceDataOrId.indices || [];

        const enonceStr = typeof enonce === 'object' ? JSON.stringify(enonce) : enonce;

        const { data: newExercice, error: exerciceError } = await supabase
          .from("exercices")
          .insert({
            enonce: enonceStr,
            solution: solution,
            chapitre: chapitre,
            niveau: niveau,
            indices: indices,
          })
          .select()
          .single();

        if (exerciceError) throw exerciceError;
        exerciceId = newExercice.id;
        console.log("✅ Created new exercise ID:", exerciceId);
      }

      const { data: newChat, error: chatError } = await supabase
        .from("chats")
        .insert({
          user_id: userId,
          session_id: sessionId,
          exercice_id: exerciceId,
        })
        .select()
        .single();

      if (chatError) throw chatError;

      return newChat;
    } catch (error) {
      console.error("Error creating chat with exercise:", error);
      return null;
    }
  };

  const playAudioMP3 = async (base64Audio: string): Promise<void> => {
    console.debug('🎵 Starting audio playback with Web Audio API');
    
    try {
      // Create AudioContext
      const audioContext = new (window.AudioContext || (window as any).webkitAudioContext)();
      console.debug('✅ AudioContext created, state:', audioContext.state);
      
      // Resume context if suspended (for autoplay policy)
      if (audioContext.state === 'suspended') {
        await audioContext.resume();
        console.debug('✅ AudioContext resumed');
      }
      
      // Helper function to safely decode base64 audio
      const safeBase64ToUint8 = (base64: string): Uint8Array => {
        // Clean the base64 string
        const clean = base64.replace(/[^A-Za-z0-9+/=]/g, '');
        // Ensure proper padding
        const pad = clean.length % 4 === 0 ? clean : clean + '='.repeat(4 - (clean.length % 4));
        const binary = atob(pad);
        const bytes = new Uint8Array(binary.length);
        for (let i = 0; i < binary.length; i++) {
          bytes[i] = binary.charCodeAt(i);
        }
        return bytes;
      };
      
      // Convert base64 to ArrayBuffer using safe decoder
      console.debug('Audio base64 length:', base64Audio?.length, 'ends with "=":', /={1,2}$/.test(base64Audio || ''));
      const bytes = safeBase64ToUint8(base64Audio);
      console.debug('✅ Audio data decoded, size:', bytes.length, 'bytes');
      
      // Decode audio data
      const audioBuffer = await audioContext.decodeAudioData(bytes.buffer);
      console.debug('✅ Audio buffer decoded, duration:', audioBuffer.duration, 'seconds');
      
      // Create source and connect to destination
      const source = audioContext.createBufferSource();
      source.buffer = audioBuffer;
      source.connect(audioContext.destination);
      
      // Set up event handlers
      setIsPlaying(true);
      
      return new Promise((resolve, reject) => {
        source.onended = () => {
          console.debug('✅ Audio playback ended');
          setIsPlaying(false);
          currentAudioRef.current = null;
          audioContext.close();
          resolve();
        };
        
        // Start playback
        source.start(0);
        console.debug('✅ Audio playback started');
        
        // Store reference (for potential stop)
        currentAudioRef.current = { pause: () => source.stop() } as any;
      });
      
    } catch (error: any) {
      console.error('❌ Web Audio API error:', error.name, error.message);
      setIsPlaying(false);
      throw error;
    }
  };

  const playWithWebSpeech = (text: string): Promise<void> => {
    return new Promise((resolve, reject) => {
      if (!('speechSynthesis' in window)) {
        reject(new Error('Speech Synthesis non supporté'));
        return;
      }
      
      const cleanedText = cleanForSpeech(text);
      const utterance = new SpeechSynthesisUtterance(cleanedText);
      
      // Configuration optimale pour français naturel
      utterance.lang = 'fr-FR';
      utterance.rate = 0.9; // Légèrement ralenti pour clarté
      utterance.pitch = 1.0; // Hauteur naturelle
      utterance.volume = 1.0; // Volume maximum
      
      // Sélectionner la meilleure voix française disponible
      if (availableFrenchVoices.length > 0) {
        utterance.voice = availableFrenchVoices[0];
        console.log('🎤 Using voice:', availableFrenchVoices[0].name);
      }
      
      utterance.onstart = () => {
        console.log('🔊 Web Speech playback started');
        setIsPlaying(true);
      };
      
      utterance.onend = () => {
        console.log('✅ Web Speech playback ended');
        setIsPlaying(false);
        speechSynthesisRef.current = null;
        resolve();
      };
      
      utterance.onerror = (e) => {
        console.error('❌ Web Speech error:', e);
        setIsPlaying(false);
        speechSynthesisRef.current = null;
        reject(e);
      };
      
      // Handle long text (Chrome has ~200 character limit)
      if (cleanedText.length > 200) {
        const chunks = cleanedText.match(/.{1,190}[.!?,;\s]/g) || [cleanedText];
        let currentChunk = 0;
        
        const speakChunk = () => {
          if (currentChunk >= chunks.length) {
            setIsPlaying(false);
            resolve();
            return;
          }
          
          const chunkUtterance = new SpeechSynthesisUtterance(chunks[currentChunk]);
          chunkUtterance.lang = 'fr-FR';
          chunkUtterance.rate = 0.9;
          chunkUtterance.pitch = 1.0;
          chunkUtterance.volume = 1.0;
          if (availableFrenchVoices.length > 0) {
            chunkUtterance.voice = availableFrenchVoices[0];
          }
          
          chunkUtterance.onend = () => {
            currentChunk++;
            speakChunk();
          };
          
          chunkUtterance.onerror = (e) => {
            console.error('Chunk error:', e);
            setIsPlaying(false);
            reject(e);
          };
          
          window.speechSynthesis.speak(chunkUtterance);
        };
        
        setIsPlaying(true);
        speakChunk();
      } else {
        speechSynthesisRef.current = utterance;
        window.speechSynthesis.speak(utterance);
      }
    });
  };

  const stopAudio = () => {
    if (currentAudioRef.current) {
      try {
        currentAudioRef.current.pause();
      } catch (e) {
        console.debug('Audio already stopped or error stopping:', e);
      }
      currentAudioRef.current = null;
    }
    
    if (speechSynthesisRef.current) {
      window.speechSynthesis.cancel();
      speechSynthesisRef.current = null;
    }
    
    setIsPlaying(false);
  };

  const autoPlayAudio = async (base64Audio: string, textFallback: string) => {
    try {
      await playAudioMP3(base64Audio);
    } catch (error: any) {
      if (error instanceof DOMException && error.name === 'NotAllowedError') {
        toast({
          title: "🔊 Lecture audio",
          description: "Autoplay bloqué, utilisation de la synthèse vocale",
        });
        await playWithWebSpeech(textFallback);
      } else {
        console.error('Erreur audio:', error);
        toast({
          title: "Erreur audio",
          description: "Impossible de lire l'audio",
          variant: "destructive",
        });
      }
    }
  };

  const replayAudio = async (audioUrl: string) => {
    if (isPlaying) {
      stopAudio();
    }
    
    const base64Audio = audioUrl.split(',')[1];
    await playAudioMP3(base64Audio).catch(console.error);
  };

  // Download Vosk model manually
  const downloadVoskModel = async () => {
    let progressInterval: NodeJS.Timeout | null = null;
    
    try {
      setModelStatus('downloading');
      setDownloadStartTime(Date.now());
      setDownloadProgress({ loaded: 0, total: 100 });
      
      toast({
        title: "📥 Téléchargement du modèle Whisper",
        description: "~240 MB à télécharger. Cela peut prendre 1-3 minutes selon votre connexion.",
      });
      
      // Progression réaliste basée sur le temps écoulé
      progressInterval = setInterval(() => {
        setDownloadProgress(prev => {
          if (!prev || !downloadStartTime) return prev;
          const elapsed = Date.now() - downloadStartTime;
          
          // Progression non-linéaire réaliste
          let progress = 0;
          if (elapsed < 30000) {
            progress = (elapsed / 30000) * 30; // 0-30% en 30s
          } else if (elapsed < 120000) {
            progress = 30 + ((elapsed - 30000) / 90000) * 30; // 30-60% en 1.5min
          } else if (elapsed < 300000) {
            progress = 60 + ((elapsed - 120000) / 180000) * 30; // 60-90% en 3min
          } else {
            progress = 90; // Reste à 90% jusqu'à la fin
          }
          
          return { ...prev, loaded: Math.floor(progress) };
        });
      }, 500);
      
      const result = await initVoskModel();
      
      if (progressInterval) clearInterval(progressInterval);
      
      // Animation finale : 90 → 100%
      setDownloadProgress({ loaded: 90, total: 100 });
      await new Promise(resolve => setTimeout(resolve, 200));
      setDownloadProgress({ loaded: 95, total: 100 });
      await new Promise(resolve => setTimeout(resolve, 200));
      setDownloadProgress({ loaded: 100, total: 100 });
      await new Promise(resolve => setTimeout(resolve, 300));
      
      setModelStatus('ready');
      setDownloadProgress(null);
      setDownloadStartTime(null);
      
      toast({
        title: "✅ Installation terminée !",
        description: `Modèle Whisper installé en ${Math.floor(result.duration / 1000)}s. Vous pouvez maintenant parler en français.`,
        duration: 8000,
      });
      
    } catch (error: any) {
      if (progressInterval) clearInterval(progressInterval);
      console.error('❌ Erreur téléchargement:', error);
      
      setModelStatus('error');
      setAsrMode('cloud');
      setDownloadProgress(null);
      setDownloadStartTime(null);
      
      toast({
        title: "❌ Échec du téléchargement",
        description: error.message?.includes('Timeout') 
          ? "Le téléchargement a pris trop de temps. Vérifiez votre connexion."
          : "Basculement automatique vers le mode Cloud",
        variant: "destructive",
      });
    }
  };

  const handleAudioSubmission = async (audioBlob: Blob) => {
    setIsProcessing(true);
    
    let transcribedText = '';
    let useLocalASR = asrMode === 'local' && modelStatus === 'ready' && isVoskReady();
    
    // Si local non disponible, fallback automatique
    if (asrMode === 'local' && modelStatus !== 'ready') {
      console.warn('⚠️ Mode local demandé mais modèle non prêt, basculement vers Cloud');
      useLocalASR = false;
    }
    
    // Gérer la confirmation en attente
    if (pendingConfirmation) {
      try {
        // Transcrire la réponse
        if (useLocalASR) {
          transcribedText = await transcribeAudioVosk(audioBlob);
        } else {
          const base64Audio = await blobToBase64(audioBlob);
          const { data: transcriptionData } = await supabase.functions.invoke('voice-chat', {
            body: { audio: base64Audio, voice: selectedVoice, confirmationMode: true }
          });
          transcribedText = transcriptionData?.transcribedText || '';
        }
        
        transcribedText = normalizeChatText(transcribedText);
        console.log('📝 Confirmation response:', transcribedText);
        
        // Correction DeepSeek si disponible
        if (useLocalASR && useMathCorrection && deepseekStatus === 'ready') {
          try {
            const correctedText = await correctMathTranscription(transcribedText);
            if (correctedText !== transcribedText && correctedText.trim().length > 0) {
              transcribedText = correctedText;
              toast({
                title: "🔍 Correction appliquée",
                description: "Terminologie mathématique corrigée",
              });
            }
          } catch (error) {
            console.warn('⚠️ Erreur correction:', error);
          }
        }
        
        // Ajouter le message de l'utilisateur
        const confirmMsg: VoiceMessage = {
          role: 'user',
          content: transcribedText,
          timestamp: new Date()
        };
        setMessages(prev => [...prev, confirmMsg]);
        
        // Détecter oui/non
        const lowerText = transcribedText.toLowerCase().trim();
        const isConfirmed = /\b(oui|yes|ok|d'accord|exact|correct|confirme|ouais|affirmatif)\b/.test(lowerText);
        const isDenied = /\b(non|no|pas\s+du\s+tout|incorrect|faux|négatif)\b/.test(lowerText);
        
        if (isConfirmed) {
          console.log('✅ Request confirmed, processing...');
          
          // Traiter la requête confirmée
          const confirmedRequest = pendingConfirmation;
          setPendingConfirmation(null);
          
          // Appel à voice-chat avec skipConfirmation=true
          const { data: confirmData, error: confirmError } = await supabase.functions.invoke('voice-chat', {
            body: {
              transcribedText: confirmedRequest.transcribedText,
              voice: selectedVoice,
              conversationHistory: confirmedRequest.conversationHistory,
              exerciseContext: confirmedRequest.exerciseContext,
              skipConfirmation: true
            }
          });
          
          if (confirmError) throw confirmError;
          
          // Traiter la réponse comme d'habitude
          const { aiText, audioContent, imageResponse, graphResponse, exerciceResponse } = confirmData;
          
          // Traiter selon le type de réponse (copie de la logique ci-dessous)
          const normalizedExercise = coerceExercisePayload(exerciceResponse);
          const aiGeneratedExercise = normalizedExercise !== null;
          
          if (aiGeneratedExercise) {
            const newChat = await createNewChatWithExercice(normalizedExercise.exercice_id || normalizedExercise);
            if (newChat) {
              onChatCreated(newChat.id);
              toast({
                title: "📚 Nouveau chat créé !",
                description: "Un nouveau chat a été ouvert pour cet exercice",
              });
            }
            const assistantMsg: VoiceMessage = {
              role: 'assistant',
              content: JSON.stringify(normalizedExercise),
              timestamp: new Date(),
              audioUrl: undefined
            };
            setMessages(prev => [...prev, assistantMsg]);
            await saveToChatHistory({ role: 'user', content: confirmedRequest.transcribedText, timestamp: new Date() }, newChat?.id || null);
            await saveToChatHistory(assistantMsg, newChat?.id || null);
          } else if (graphResponse) {
            const assistantMsg: VoiceMessage = {
              role: 'assistant',
              content: JSON.stringify(graphResponse),
              timestamp: new Date(),
              audioUrl: undefined
            };
            setMessages(prev => [...prev, assistantMsg]);
            await saveToChatHistory({ role: 'user', content: confirmedRequest.transcribedText, timestamp: new Date() });
            await saveToChatHistory(assistantMsg);
            toast({
              title: "📊 Graphique généré",
              description: "Voici le graphique de ta fonction !",
            });
          } else if (imageResponse) {
            const assistantMsg: VoiceMessage = {
              role: 'assistant',
              content: JSON.stringify(imageResponse),
              timestamp: new Date(),
              audioUrl: audioContent ? `data:audio/mpeg;base64,${audioContent}` : undefined
            };
            setMessages(prev => [...prev, assistantMsg]);
            await saveToChatHistory({ role: 'user', content: confirmedRequest.transcribedText, timestamp: new Date() });
            await saveToChatHistory(assistantMsg);
            toast({
              title: "🎨 Image générée",
              description: "Écoute la description !",
            });
            if (audioContent && aiText) {
              await autoPlayAudio(audioContent, aiText);
            }
          } else {
            const assistantMsg: VoiceMessage = {
              role: 'assistant',
              content: aiText,
              timestamp: new Date(),
              audioUrl: `data:audio/mpeg;base64,${audioContent}`
            };
            setMessages(prev => [...prev, assistantMsg]);
            await saveToChatHistory({ role: 'user', content: confirmedRequest.transcribedText, timestamp: new Date() });
            await saveToChatHistory(assistantMsg);
            toast({
              title: "✅ Réponse reçue",
              description: "Lecture en cours...",
            });
            await autoPlayAudio(audioContent, aiText);
          }
          
        } else if (isDenied) {
          console.log('❌ Request denied, asking to reformulate');
          setPendingConfirmation(null);
          
          const reformulateMsg: VoiceMessage = {
            role: 'assistant',
            content: 'D\'accord, peux-tu reformuler ta question ?',
            timestamp: new Date()
          };
          setMessages(prev => [...prev, reformulateMsg]);
          
          await saveToChatHistory(confirmMsg);
          await saveToChatHistory(reformulateMsg);
          
          // Générer l'audio de la reformulation
          const { data: audioData } = await supabase.functions.invoke('voice-chat', {
            body: {
              transcribedText: reformulateMsg.content,
              voice: selectedVoice,
              generateAudioOnly: true
            }
          });
          
          if (audioData?.audioContent) {
            await autoPlayAudio(audioData.audioContent, reformulateMsg.content);
          }
          
        } else {
          console.log('⚠️ Unclear response, asking for clarification');
          
          const clarifyMsg: VoiceMessage = {
            role: 'assistant',
            content: 'Je n\'ai pas bien compris. Dis "oui" pour confirmer ou "non" pour reformuler.',
            timestamp: new Date()
          };
          setMessages(prev => [...prev, clarifyMsg]);
          
          await saveToChatHistory(confirmMsg);
          await saveToChatHistory(clarifyMsg);
          
          // Générer l'audio
          const { data: audioData } = await supabase.functions.invoke('voice-chat', {
            body: {
              transcribedText: clarifyMsg.content,
              voice: selectedVoice,
              generateAudioOnly: true
            }
          });
          
          if (audioData?.audioContent) {
            await autoPlayAudio(audioData.audioContent, clarifyMsg.content);
          }
        }
        
        setIsProcessing(false);
        return;
        
      } catch (error: any) {
        console.error('Error processing confirmation:', error);
        setPendingConfirmation(null);
        toast({
          title: "Erreur",
          description: "Erreur lors de la confirmation",
          variant: "destructive",
        });
        setIsProcessing(false);
        return;
      }
    }
    
    try {
      if (useLocalASR) {
        // ✅ TRANSCRIPTION LOCALE avec Vosk
        toast({
          title: "🎤 Transcription locale Vosk (FR)...",
          description: "Traitement en cours",
          duration: 1000
        });
        
        const startTime = performance.now();
        transcribedText = await transcribeAudioVosk(audioBlob);
        const duration = performance.now() - startTime;
        
        console.log(`✅ Transcription locale en ${duration.toFixed(0)}ms`);
        
        // Normaliser le texte
        transcribedText = normalizeChatText(transcribedText);
        
        // Correction DeepSeek si disponible
        if (useMathCorrection && deepseekStatus === 'ready') {
          try {
            const correctedText = await correctMathTranscription(transcribedText);
            if (correctedText !== transcribedText && correctedText.trim().length > 0) {
              console.log(`✅ Correction: "${transcribedText}" → "${correctedText}"`);
              transcribedText = correctedText;
              toast({
                title: "🔍 Correction mathématique",
                description: "Terminologie corrigée",
              });
            }
          } catch (error) {
            console.warn('⚠️ Erreur correction:', error);
          }
        }
        
        // Créer le message utilisateur
        const userMsg: VoiceMessage = {
          role: 'user',
          content: transcribedText,
          timestamp: new Date()
        };
        setMessages(prev => [...prev, userMsg]);
        
        // Track first chat use
        trackFirstMessage();
        
        // Appeler l'edge function SEULEMENT pour l'IA (sans audio)
        toast({
          title: "🤖 Génération de la réponse...",
          description: "L'IA réfléchit...",
        });
      } else {
        // ✅ TRANSCRIPTION CLOUD avec Whisper
        toast({
          title: "🎤 Traitement...",
          description: "Transcription de votre message",
        });
      }
      
      const base64Audio = useLocalASR ? null : await blobToBase64(audioBlob);
      
      // Fetch conversation history from database if chat exists, otherwise use local
      let conversationHistory = [];
      if (currentChatId) {
        try {
          const { data: historyData } = await supabase
            .from('chat_history')
            .select('role, content')
            .eq('chat_id', currentChatId)
            .order('created_at', { ascending: false })
            .limit(10);
          
          if (historyData && historyData.length > 0) {
            conversationHistory = historyData.reverse(); // Restore chronological order
            console.log(`📚 Loaded ${conversationHistory.length} messages from chat history`);
          }
        } catch (e) {
          console.warn('Could not load chat history, using local:', e);
          conversationHistory = messages.slice(-10).map(m => ({
            role: m.role,
            content: m.content
          }));
        }
      } else {
        conversationHistory = messages.slice(-10).map(m => ({
          role: m.role,
          content: m.content
        }));
      }
      
      // Get current exercise context if exists
      let exerciseContext = null;
      if (currentChatId) {
        try {
          const { data: chatData } = await supabase
            .from('chats')
            .select('exercice_id, exercices(enonce, chapitre, niveau)')
            .eq('id', currentChatId)
            .single();
          
          if (chatData?.exercices) {
            exerciseContext = {
              enonce: chatData.exercices.enonce,
              chapitre: chatData.exercices.chapitre,
              niveau: chatData.exercices.niveau
            };
            console.log('📚 Exercise context loaded:', exerciseContext);
          } else if (chatData?.exercice_id) {
            // Fallback: direct fetch if join failed
            console.warn('⚠️ Join failed, fetching exercise directly');
            const { data: exerciseData } = await supabase
              .from('exercices')
              .select('enonce, chapitre, niveau')
              .eq('id', chatData.exercice_id)
              .single();
            
            if (exerciseData) {
              exerciseContext = {
                enonce: exerciseData.enonce,
                chapitre: exerciseData.chapitre,
                niveau: exerciseData.niveau
              };
              console.log('📚 Exercise context loaded (fallback):', exerciseContext);
            }
          }
          
          if (!exerciseContext) {
            console.warn('⚠️ No exercise context found', { currentChatId, chatData });
          }
        } catch (e) {
          console.warn('Could not load exercise context:', e);
        }
      }
      
      const { data, error } = await supabase.functions.invoke('voice-chat', {
        body: {
          audio: base64Audio, // null si local
          transcribedText: useLocalASR ? transcribedText : undefined, // Texte déjà transcrit en local
          voice: selectedVoice,
          conversationHistory: useLocalASR 
            ? [...messages.slice(-10).map(m => ({ role: m.role, content: m.content })), { role: 'user', content: transcribedText }]
            : conversationHistory,
          exerciseContext,
          confirmationNeeded: true  // Demander une confirmation
        }
      });
      
      if (error) throw error;
      
      const { transcribedText: cloudTranscription, aiText, audioContent, imageResponse, graphResponse, exerciceResponse, isConfirmation } = data;
      
      // Si transcription cloud, l'utiliser
      if (!useLocalASR && cloudTranscription) {
        transcribedText = cloudTranscription;
      }
      
      // Normalize the transcribed text (si pas déjà fait en local)
      const normalizedTranscription = useLocalASR ? transcribedText : normalizeChatText(transcribedText);
      
      const userMsg: VoiceMessage = useLocalASR 
        ? messages[messages.length - 1] // Déjà ajouté plus haut
        : {
            role: 'user',
            content: normalizedTranscription,
            timestamp: new Date()
          };
      
      // Ajouter le message utilisateur seulement si mode cloud
      if (!useLocalASR) {
        setMessages(prev => [...prev, userMsg]);
        // Track first chat use
        trackFirstMessage();
      }
      
      // Si c'est une demande de confirmation, stocker et attendre la réponse
      if (isConfirmation) {
        console.log('⏸️ Confirmation request, waiting for user response');
        
        setPendingConfirmation({
          transcribedText: normalizedTranscription,
          normalizedText: normalizedTranscription,
          conversationHistory: useLocalASR 
            ? [...messages.slice(-10).map(m => ({ role: m.role, content: m.content })), { role: 'user', content: transcribedText }]
            : conversationHistory,
          exerciseContext
        });
        
        // Afficher le message de confirmation
        const confirmationMsg: VoiceMessage = {
          role: 'assistant',
          content: aiText,
          timestamp: new Date(),
          audioUrl: `data:audio/mpeg;base64,${audioContent}`
        };
        
        setMessages(prev => [...prev, confirmationMsg]);
        await saveToChatHistory(userMsg);
        await saveToChatHistory(confirmationMsg);
        
        // Jouer l'audio de confirmation
        toast({
          title: "🎤 Confirmation",
          description: "Dis 'oui' pour confirmer ou 'non' pour reformuler",
        });
        
        await autoPlayAudio(audioContent, aiText);
        setIsProcessing(false);
        return;
      }
      
      // Normalize exercise payload if present
      const normalizedExercise = coerceExercisePayload(exerciceResponse);
      const aiGeneratedExercise = normalizedExercise !== null;
      
      if (aiGeneratedExercise) {
        console.log("📚 AI generated exercise detected, creating new chat");
        
        const newChat = await createNewChatWithExercice(
          normalizedExercise.exercice_id || normalizedExercise
        );
        
        if (newChat) {
          onChatCreated(newChat.id);
          
          toast({
            title: "📚 Nouveau chat créé !",
            description: "Un nouveau chat a été ouvert pour cet exercice",
          });
        }
        
        const assistantMsg: VoiceMessage = {
          role: 'assistant',
          content: JSON.stringify(normalizedExercise),
          timestamp: new Date(),
          audioUrl: undefined
        };
        
        setMessages(prev => [...prev, assistantMsg]);
        
        // Save to new chat
        await saveToChatHistory(userMsg, newChat?.id || null);
        await saveToChatHistory(assistantMsg, newChat?.id || null);
        
      } else if (graphResponse) {
        // Handle math graph response (local generation)
        console.log("📊 Math graph response detected, displaying graph");
        
        const assistantMsg: VoiceMessage = {
          role: 'assistant',
          content: JSON.stringify(graphResponse),
          timestamp: new Date(),
          audioUrl: undefined
        };
        
        setMessages(prev => [...prev, assistantMsg]);
        
        await saveToChatHistory(userMsg);
        await saveToChatHistory(assistantMsg);
        
        toast({
          title: "📊 Graphique généré",
          description: "Voici le graphique de ta fonction !",
        });
      } else if (imageResponse) {
        // Handle image response (Gemini generation) with audio
        console.log("🎨 Image response detected, displaying image with audio");
        
        const assistantMsg: VoiceMessage = {
          role: 'assistant',
          content: JSON.stringify(imageResponse),
          timestamp: new Date(),
          audioUrl: audioContent ? `data:audio/mpeg;base64,${audioContent}` : undefined
        };
        
        setMessages(prev => [...prev, assistantMsg]);
        
        await saveToChatHistory(userMsg);
        await saveToChatHistory(assistantMsg);
        
        toast({
          title: "🎨 Image générée",
          description: "Écoute la description !",
        });
        
        // Play audio if available
        if (audioContent && aiText) {
          await autoPlayAudio(audioContent, aiText);
        }
      } else {
        // Normal text response with audio
        const assistantMsg: VoiceMessage = {
          role: 'assistant',
          content: aiText,
          timestamp: new Date(),
          audioUrl: `data:audio/mpeg;base64,${audioContent}`
        };
        
        setMessages(prev => [...prev, assistantMsg]);
        
        await saveToChatHistory(userMsg);
        await saveToChatHistory(assistantMsg);
        
        toast({
          title: "✅ Réponse reçue",
          description: "Lecture en cours...",
        });
        
        await autoPlayAudio(audioContent, aiText);
      }
      
    } catch (error: any) {
      console.error('Erreur:', error);
      toast({
        title: "❌ Erreur",
        description: error.message || "Une erreur est survenue",
        variant: "destructive",
      });
    } finally {
      setIsProcessing(false);
    }
  };

  const handleNewConversation = () => {
    setMessages([]);
    localStorage.removeItem(`voice-chat-${sessionId}`);
    toast({
      title: "Nouvelle conversation",
      description: "L'historique a été effacé",
    });
  };

  return (
    <Card className="w-full max-w-3xl mx-auto bg-gradient-to-br from-background via-background to-muted/20">
      <CardHeader>
        <div className="flex items-center justify-between flex-wrap gap-4">
          <div className="flex items-center gap-3">
            <div className="h-12 w-12 rounded-full bg-primary/10 flex items-center justify-center">
              <Volume2 className="w-6 h-6 text-primary" />
            </div>
            <div>
              <h2 className="text-2xl font-bold">Assistant Vocal</h2>
              <p className="text-sm text-muted-foreground">Sophie, ta prof de maths</p>
            </div>
          </div>
          
          <div className="flex gap-2 items-center">
            <Button
              variant="outline"
              size="sm"
              onClick={onBackToTextChat}
              title="Revenir au chat texte"
              className="gap-2"
            >
              <MessageSquare className="w-4 h-4" />
              Chat texte
            </Button>
            
            <Select value={selectedVoice} onValueChange={setSelectedVoice}>
              <SelectTrigger className="w-[180px]">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {VOICES.map(voice => (
                  <SelectItem key={voice.value} value={voice.value}>
                    <div className="flex flex-col">
                      <span>{voice.emoji} {voice.label}</span>
                      <span className="text-xs text-muted-foreground">{voice.description}</span>
                    </div>
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            
            <Button
              variant="outline"
              size="icon"
              onClick={handleNewConversation}
              title="Nouvelle conversation"
              disabled={isProcessing || isPlaying}
            >
              <RotateCcw className="w-4 h-4" />
            </Button>
          </div>
        </div>
      </CardHeader>
      
      {/* ASR Mode Selection */}
      <CardContent className="pb-4">
        <div className="space-y-4 border-b pb-4 mb-4">
          <div className="grid grid-cols-2 gap-4">
            {/* Mode ASR */}
            <div>
              <Label className="text-sm font-medium mb-2 block">Mode de transcription</Label>
              <Select value={asrMode} onValueChange={(v: 'local' | 'cloud') => setAsrMode(v)}>
                <SelectTrigger className="w-full">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="local">
                  <div className="flex flex-col">
                      <span>💻 Local (Whisper - FR)</span>
                      <span className="text-xs text-muted-foreground">✅ Priorité - Gratuit, rapide, offline, ~240 MB</span>
                    </div>
                  </SelectItem>
                  <SelectItem value="cloud">
                    <div className="flex flex-col">
                      <span>☁️ Cloud (OpenAI Whisper)</span>
                      <span className="text-xs text-muted-foreground">Fallback si modèle non téléchargé</span>
                    </div>
                  </SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          {/* Statut du modèle local */}
          {asrMode === 'local' && (
            <div className="space-y-2">
              {modelStatus === 'not-loaded' && (
                <Alert>
                  <AlertDescription className="flex items-center justify-between">
                    <span className="text-sm">Modèle Whisper français (~240 MB à télécharger)</span>
                    <Button
                      size="sm" 
                      onClick={downloadVoskModel}
                      disabled={isProcessing}
                    >
                      📥 Télécharger
                    </Button>
                  </AlertDescription>
                </Alert>
              )}
              
              {modelStatus === 'downloading' && downloadProgress && (
                <div className="space-y-2">
                  <div className="flex items-center justify-between text-sm">
                    <span className="font-medium">
                      {downloadProgress.loaded < 30 && "⏳ Connexion au serveur..."}
                      {downloadProgress.loaded >= 30 && downloadProgress.loaded < 60 && "📥 Téléchargement en cours..."}
                      {downloadProgress.loaded >= 60 && downloadProgress.loaded < 90 && "📦 Presque terminé..."}
                      {downloadProgress.loaded >= 90 && "🔧 Installation finale..."}
                    </span>
                    <span className="font-bold text-primary">
                      {downloadProgress.loaded}%
                    </span>
                  </div>
                  <Progress 
                    value={downloadProgress.loaded} 
                  />
                  <div className="flex items-center justify-between text-xs text-muted-foreground">
                    <span>
                      {isVoskModelCached()
                        ? "Initialisation depuis le cache local"
                        : "Téléchargement initial: ~240 MB (Whisper)"}
                    </span>
                    {downloadStartTime && (
                      <span className="font-mono">
                        {Math.floor((Date.now() - downloadStartTime) / 1000)}s écoulées
                      </span>
                    )}
                  </div>
                </div>
              )}
              
                {modelStatus === 'ready' && (
                <Alert className="bg-green-500/10 border-green-500/20">
                  <AlertDescription className="text-sm text-green-600 dark:text-green-400">
                    ✅ Whisper prêt ! Transcription locale instantanée
                  </AlertDescription>
                </Alert>
              )}
              
              {modelStatus === 'error' && (
                <Alert variant="destructive">
                  <AlertDescription className="text-sm">
                    ❌ Erreur de chargement. Basculement automatique vers le mode Cloud
                  </AlertDescription>
                </Alert>
              )}
            </div>
          )}

          {/* DeepSeek Math section */}
          {webGPUAvailable && asrMode === 'local' && (
            <div className="space-y-2 mt-4 pt-4 border-t">
              <div className="flex items-center justify-between mb-2">
                <Label className="text-sm font-medium">🧠 DeepSeek Math (Correction)</Label>
                {deepseekStatus === 'ready' && (
                  <span className="text-xs text-green-600 dark:text-green-400">✅ Prêt</span>
                )}
              </div>
              
              <p className="text-xs text-muted-foreground mb-2">
                Corrige automatiquement les termes mathématiques mal transcrits (~1.5 GB)
              </p>
              
              {deepseekStatus === 'not-loaded' && (
                <Button
                  size="sm"
                  variant="outline"
                  onClick={async () => {
                    setDeepseekStatus('downloading');
                    setDeepseekProgress({ loaded: 0, total: 100 });
                    
                    toast({
                      title: "📥 Téléchargement DeepSeek",
                      description: "~1.5 GB, peut prendre 10-20 min",
                      duration: 10000,
                    });
                    
                    try {
                      const result = await initDeepSeekMath((p) => {
                        setDeepseekProgress({ loaded: p, total: 100 });
                      });
                      
                      setDeepseekStatus('ready');
                      setDeepseekProgress(null);
                      
                      toast({
                        title: "✅ DeepSeek installé !",
                        description: "Correction activée",
                      });
                    } catch (error: any) {
                      setDeepseekStatus('error');
                      setDeepseekProgress(null);
                      toast({
                        title: "❌ Erreur",
                        description: error.message,
                        variant: "destructive"
                      });
                    }
                  }}
                  disabled={isProcessing}
                  className="w-full"
                >
                  📥 Télécharger DeepSeek Math
                </Button>
              )}
              
              {deepseekStatus === 'downloading' && deepseekProgress && (
                <div className="space-y-2">
                  <Progress value={deepseekProgress.loaded} />
                  <p className="text-xs text-center text-muted-foreground">
                    {deepseekProgress.loaded}% téléchargé
                  </p>
                </div>
              )}
              
              {deepseekStatus === 'ready' && (
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    id="use-math-correction"
                    checked={useMathCorrection}
                    onChange={(e) => setUseMathCorrection(e.target.checked)}
                    className="rounded"
                  />
                  <Label htmlFor="use-math-correction" className="text-xs cursor-pointer">
                    Activer correction automatique
                  </Label>
                </div>
              )}
            </div>
          )}
        </div>
      </CardContent>
      
      <CardContent>
        <ScrollArea ref={scrollAreaRef} className="h-[400px] mb-4 pr-4">
          {messages.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-full text-center px-6">
              <Mic className="w-16 h-16 mb-6 text-primary/70 animate-bounce" />
              <h3 className="text-xl font-semibold mb-4 text-foreground">
                🎤 Pour commencer à parler avec moi :
              </h3>
              
              <div className="space-y-3 text-left bg-muted/50 rounded-lg p-4 max-w-md">
                <div className="flex items-start gap-3">
                  <span className="text-2xl shrink-0">1️⃣</span>
                  <p className="text-sm text-foreground">Clique sur le <strong>bouton micro 🎤</strong> ci-dessous</p>
                </div>
                <div className="flex items-start gap-3">
                  <span className="text-2xl shrink-0">2️⃣</span>
                  <p className="text-sm text-foreground">Autorise l'accès à ton micro dans ton navigateur</p>
                </div>
                <div className="flex items-start gap-3">
                  <span className="text-2xl shrink-0">3️⃣</span>
                  <p className="text-sm text-foreground">Parle-moi de ton problème de maths !</p>
                </div>
              </div>
              
              <p className="text-sm text-muted-foreground mt-6 max-w-md">
                Je peux t'aider avec des exercices, des explications de cours, et plus encore. 📚✨
              </p>
              
              {micPermission === 'granted' && (
                <div className="mt-4 px-4 py-2 bg-primary/10 text-primary rounded-full text-sm font-medium flex items-center gap-2">
                  <div className="w-2 h-2 bg-primary rounded-full animate-pulse"></div>
                  Micro activé - Tu peux parler !
                </div>
              )}
              
              {micPermission === 'denied' && (
                <div className="mt-4 px-4 py-2 bg-destructive/10 text-destructive rounded-lg text-sm">
                  ⚠️ Accès au micro refusé. Vérifie les permissions de ton navigateur.
                </div>
              )}
            </div>
          ) : (
            <div className="space-y-4">
              {messages.map((msg, idx) => {
                // Try to parse content as JSON for image responses
                let parsedContent = null;
                try {
                  parsedContent = JSON.parse(msg.content);
                } catch {
                  // Not JSON, regular text message
                }
                
                const isImageResponse = parsedContent?.type === 'image_generee';
                const isMathGraph = parsedContent?.type === 'math_graph';
                
                return (
                  <div key={idx} className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'}`}>
                    <Card className={`max-w-[70%] ${
                      msg.role === 'user' 
                        ? 'bg-primary text-primary-foreground' 
                        : 'bg-secondary'
                    }`}>
                      <CardContent className="p-3">
                        {isMathGraph ? (
                          <div className="space-y-2">
                            <p className="text-sm font-medium">{parsedContent.message_introduction}</p>
                            <MathGraph
                              expression={parsedContent.expression}
                              xMin={parsedContent.xMin}
                              xMax={parsedContent.xMax}
                              title={parsedContent.title}
                            />
                          </div>
                        ) : isImageResponse ? (
                          <div className="space-y-2">
                            <p className="text-sm font-medium">{parsedContent.message_introduction}</p>
                            <img 
                              src={parsedContent.image_base64} 
                              alt={parsedContent.description}
                              className="w-full rounded-lg border border-border"
                            />
                            <p className="text-xs text-muted-foreground italic">{parsedContent.description}</p>
                          </div>
                        ) : (
                          <MathText content={msg.content} mode="strict" className="text-sm" />
                        )}
                        <div className="flex items-center justify-between mt-2 gap-2">
                          <span className="text-xs opacity-70">
                            {msg.timestamp.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })}
                          </span>
                          <div className="flex items-center gap-1">
                            {msg.role === 'assistant' && (
                              <MessageFeedback
                                messageId={msg.id || `voice-${idx}-${msg.timestamp.getTime()}`}
                                conversationId={currentChatId}
                                messageContent={msg.content}
                                userId={userId}
                                userProfile={userProfile}
                              />
                            )}
                            {msg.role === 'assistant' && msg.audioUrl && (
                              <Button 
                                size="icon" 
                                variant="ghost"
                                className="h-6 w-6"
                                onClick={() => replayAudio(msg.audioUrl!)}
                                disabled={isPlaying}
                              >
                                <Volume2 className="w-3 h-3" />
                              </Button>
                            )}
                          </div>
                        </div>
                      </CardContent>
                    </Card>
                  </div>
                );
              })}
            </div>
          )}
        </ScrollArea>
        
        <div className="flex items-center gap-3 justify-center p-4 border-t">
          {isPlaying ? (
            <Button onClick={stopAudio} variant="secondary" className="gap-2">
              <StopCircle className="w-5 h-5" />
              Arrêter la lecture
            </Button>
          ) : (
            <Button
              size="lg"
              variant={isRecording ? "destructive" : "default"}
              onClick={isRecording ? stopRecording : startRecording}
              disabled={isProcessing}
              className={`w-20 h-20 rounded-full transition-all ${
                isRecording 
                  ? 'animate-pulse' 
                  : !hasClickedOnce && messages.length === 0 
                    ? 'animate-pulse shadow-lg shadow-primary/50' 
                    : ''
              }`}
            >
              {isRecording ? (
                <MicOff className="w-8 h-8" />
              ) : (
                <Mic className="w-8 h-8" />
              )}
            </Button>
          )}
        </div>
        
        {isProcessing && (
          <div className="flex items-center justify-center gap-2 text-sm text-muted-foreground mt-2">
            <Loader2 className="w-4 h-4 animate-spin" />
            <span>Traitement en cours...</span>
          </div>
        )}
      </CardContent>
    </Card>
  );
};

export default VoiceChatbot;
