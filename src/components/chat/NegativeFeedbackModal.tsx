import { useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Loader2 } from "lucide-react";

interface NegativeFeedbackModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (comment: string) => Promise<void>;
  isSubmitting: boolean;
}

/**
 * NegativeFeedbackModal Component
 * 
 * Modal dialog for collecting detailed feedback when user clicks 👎.
 * Requires a comment before submission.
 * 
 * @location Opened from MessageFeedback component
 */
export const NegativeFeedbackModal = ({
  isOpen,
  onClose,
  onSubmit,
  isSubmitting,
}: NegativeFeedbackModalProps) => {
  const [comment, setComment] = useState("");

  const handleSubmit = async () => {
    if (!comment.trim()) return;
    await onSubmit(comment.trim());
    setComment("");
  };

  const handleClose = () => {
    if (!isSubmitting) {
      setComment("");
      onClose();
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={handleClose}>
      <DialogContent className="sm:max-w-md max-w-[90vw] mx-4">
        <DialogHeader>
          <DialogTitle className="text-lg">
            Qu'est-ce qui n'a pas bien fonctionné ?
          </DialogTitle>
          <DialogDescription className="text-sm">
            Ton avis nous aide à améliorer les réponses du chatbot
          </DialogDescription>
        </DialogHeader>

        <div className="py-4">
          <Textarea
            placeholder="Explique-nous ce qui n'allait pas avec cette réponse..."
            value={comment}
            onChange={(e) => setComment(e.target.value)}
            className="min-h-[120px] resize-none"
            disabled={isSubmitting}
            autoFocus
          />
          {comment.length === 0 && (
            <p className="text-xs text-muted-foreground mt-2">
              Un commentaire est requis pour nous aider à comprendre le problème
            </p>
          )}
        </div>

        <DialogFooter className="flex gap-2 sm:gap-2">
          <Button
            variant="ghost"
            onClick={handleClose}
            disabled={isSubmitting}
          >
            Annuler
          </Button>
          <Button
            onClick={handleSubmit}
            disabled={!comment.trim() || isSubmitting}
          >
            {isSubmitting ? (
              <>
                <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                Envoi...
              </>
            ) : (
              "Envoyer"
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};
