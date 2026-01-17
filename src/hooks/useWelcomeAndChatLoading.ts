import { supabase } from "@/integrations/supabase/client";
import { getRecommendedChapter } from "@/utils/recommendations";

export type ChatType = "cours" | "exercice";

export interface WelcomeContext {
  type: "first_ever" | "first_of_day" | "ongoing";
  lastGap: string | null;
}

export interface Message {
  role: "user" | "assistant";
  content: string;
  timestamp: Date;
  imageUrl?: string;
}

/**
 * Détecte le contexte de bienvenue pour un type de chat spécifique
 * Utilise la recommandation centralisée pour cohérence entre /cours et /exercise
 */
export const detectWelcomeContext = async (
  userId: string,
  chatType: ChatType
): Promise<WelcomeContext> => {
  // 1. Vérifier si première interaction du compte (tous types confondus)
  const { count: interactionsCount } = await supabase
    .from("interactions")
    .select("*", { count: "exact", head: true })
    .eq("user_id", userId);

  const isFirstEverInteraction = (interactionsCount || 0) === 0;

  if (isFirstEverInteraction) {
    return {
      type: "first_ever",
      lastGap: null,
    };
  }

  // 2. Vérifier si premier chat du jour POUR CE TYPE
  const today = new Date().toISOString().split("T")[0];

  const { data: todayChats } = await supabase
    .from("chats")
    .select("id")
    .eq("user_id", userId)
    .eq("chat_type", chatType)
    .gte("created_at", today);

  const isFirstChatOfTheDay = !todayChats || todayChats.length === 0;

  if (!isFirstChatOfTheDay) {
    return {
      type: "ongoing",
      lastGap: null,
    };
  }

  // 3. Utiliser la recommandation CENTRALISÉE (même logique que Competences.tsx)
  const lastGap = await getRecommendedChapter(userId);

  return {
    type: "first_of_day",
    lastGap,
  };
};

/**
 * Génère un message de bienvenue adapté au type de chat
 */
export const generateWelcomeMessage = (
  context: WelcomeContext,
  prenom: string,
  chatType: ChatType
): Message | null => {
  if (context.type === "first_ever") {
    if (chatType === "exercice") {
      return {
        role: "assistant" as const,
        content: `Salut ${prenom} !\n\nBienvenue sur Siimply\n\nJe suis Sophie, ta prof de maths personnelle. Tu peux :\n• Me soumettre un exercice pour que je t'aide à le résoudre\n• Me demander de générer un exercice sur un chapitre précis\n• Me poser des questions sur un point de cours\n\nComment puis-je t'aider aujourd'hui ?\n\nPour me montrer ce que tu fais, pense à écrire sur ton cahier et envoie-moi en photo. Je pourrai voir clairement ce que tu fais. L'analyse de photo doit être précise, donc ça peut prendre 30 secondes ne t'inquiète pas !`,
        timestamp: new Date(),
      };
    } else {
      return {
        role: "assistant" as const,
        content: `Salut ${prenom} !\n\nBienvenue sur Siimply\n\nJe suis Sophie, ta prof de maths personnelle. Ici tu peux me poser toutes tes questions sur le cours. N'hésite pas à me demander des explications sur n'importe quel concept mathématique !\n\nQuelle notion veux-tu que je t'explique ?\n\nPour me montrer ce que tu fais, pense à écrire sur ton cahier et envoie-moi en photo. Je pourrai voir clairement ce que tu fais. L'analyse de photo doit être précise, donc ça peut prendre 30 secondes ne t'inquiète pas !`,
        timestamp: new Date(),
      };
    }
  }

  if (context.type === "first_of_day") {
    if (chatType === "exercice") {
      const gapText = context.lastGap
        ? ` ou bien je te donne des exercices pour travailler ${context.lastGap}`
        : "";

      return {
        role: "assistant" as const,
        content: `Content de te revoir ! Tu as des choses que tu veux travailler en particulier${gapText} ?`,
        timestamp: new Date(),
      };
    } else {
      const gapText = context.lastGap
        ? ` ou bien je te fais des rappels de cours sur ${context.lastGap}`
        : "";

      return {
        role: "assistant" as const,
        content: `Content de te revoir ! Tu as des questions sur un cours ou un chapitre en particulier${gapText} ?`,
        timestamp: new Date(),
      };
    }
  }

  // Si 'ongoing', pas de message de bienvenue
  return null;
};

/**
 * Charge le dernier chat d'un type spécifique pour l'utilisateur
 */
export const loadLastChatOfType = async (
  userId: string,
  chatType: ChatType
): Promise<{ chatId: string; messages: Message[] } | null> => {
  const { data: lastChat } = await supabase
    .from("chats")
    .select("id")
    .eq("user_id", userId)
    .eq("chat_type", chatType)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (!lastChat) {
    return null;
  }

  const { data: chatHistory } = await supabase
    .from("chat_history")
    .select("*")
    .eq("chat_id", lastChat.id)
    .order("created_at", { ascending: true });

  const messages: Message[] = (chatHistory || []).map((msg) => ({
    role: msg.role as "user" | "assistant",
    content: msg.content,
    timestamp: new Date(msg.created_at),
    imageUrl: msg.image_url || undefined,
  }));

  return {
    chatId: lastChat.id,
    messages,
  };
};
