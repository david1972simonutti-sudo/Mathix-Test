import { useState } from "react";
import { ThumbsUp, ThumbsDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { NegativeFeedbackModal } from "./NegativeFeedbackModal";

interface MessageFeedbackProps {
  messageId: string;
  conversationId: string | null;
  messageContent: string;
  userId: string;
  userProfile: {
    prenom?: string;
    email?: string;
    classe?: string;
  } | null;
}

/**
 * MessageFeedback Component
 * 
 * Renders 👍/👎 feedback icons under assistant messages.
 * - 👍: Direct submission with toast confirmation
 * - 👎: Opens NegativeFeedbackModal for comment collection
 * 
 * @location Used in Cours.tsx, Exercise.tsx, VoiceChatbot.tsx
 */
export const MessageFeedback = ({
  messageId,
  conversationId,
  messageContent,
  userId,
  userProfile,
}: MessageFeedbackProps) => {
  const { toast } = useToast();
  const [hasVoted, setHasVoted] = useState(false);
  const [votedType, setVotedType] = useState<'positive' | 'negative' | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const submitFeedback = async (rating: 'positive' | 'negative', comment?: string) => {
    setIsSubmitting(true);
    try {
      // Insert feedback into database
      const { error: dbError } = await supabase
        .from('chat_feedback')
        .insert({
          conversation_id: conversationId,
          message_id: messageId,
          user_id: userId,
          rating,
          comment: comment || null,
          message_content: messageContent.substring(0, 1000), // Limit content length
        });

      if (dbError) throw dbError;

      // Send email notification for negative feedback
      if (rating === 'negative' && comment) {
        await supabase.functions.invoke('send-email', {
          body: {
            type: 'chat_message_feedback',
            userPrenom: userProfile?.prenom || 'Utilisateur',
            userEmail: userProfile?.email || 'non-renseigné',
            userClasse: userProfile?.classe || 'non-renseigné',
            rating,
            comment,
            messageContent: messageContent.substring(0, 500),
            conversationId: conversationId || 'N/A',
          },
        });
      }

      setHasVoted(true);
      setVotedType(rating);

      toast({
        title: rating === 'positive' ? "Merci pour ton retour 👍" : "Merci, ton avis va nous aider à améliorer le chatbot",
        duration: 3000,
      });
    } catch (error) {
      console.error('Error submitting feedback:', error);
      toast({
        title: "Erreur",
        description: "Impossible d'enregistrer ton retour",
        variant: "destructive",
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  const handlePositive = async () => {
    if (hasVoted || isSubmitting) return;
    await submitFeedback('positive');
  };

  const handleNegative = () => {
    if (hasVoted || isSubmitting) return;
    setIsModalOpen(true);
  };

  const handleNegativeSubmit = async (comment: string) => {
    await submitFeedback('negative', comment);
    setIsModalOpen(false);
  };

  if (hasVoted) {
    return (
      <div className="flex items-center gap-1 text-xs text-muted-foreground">
        {votedType === 'positive' ? (
          <ThumbsUp className="w-3 h-3 fill-primary text-primary" />
        ) : (
          <ThumbsDown className="w-3 h-3 fill-destructive text-destructive" />
        )}
        <span>Merci !</span>
      </div>
    );
  }

  return (
    <>
      <div className="flex items-center gap-1">
        <Button
          variant="ghost"
          size="sm"
          className="h-7 w-7 p-0 hover:bg-yellow-500/10 touch-manipulation"
          onClick={handlePositive}
          disabled={isSubmitting}
          title="Cette réponse m'a aidé"
        >
          <ThumbsUp className="w-4 h-4 text-yellow-500 hover:text-yellow-600 transition-colors" />
        </Button>
        <Button
          variant="ghost"
          size="sm"
          className="h-7 w-7 p-0 hover:bg-yellow-500/10 touch-manipulation"
          onClick={handleNegative}
          disabled={isSubmitting}
          title="Cette réponse ne m'a pas aidé"
        >
          <ThumbsDown className="w-4 h-4 text-yellow-500 hover:text-yellow-600 transition-colors" />
        </Button>
      </div>

      <NegativeFeedbackModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleNegativeSubmit}
        isSubmitting={isSubmitting}
      />
    </>
  );
};
