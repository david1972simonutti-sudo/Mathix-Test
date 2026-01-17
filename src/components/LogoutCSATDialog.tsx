import { useState, useEffect } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

export interface CSATData {
  csat: number;
  difficulty?: string;
  comment?: string;
}

interface UserProfile {
  prenom: string;
  nom: string;
  email: string;
  classe: string;
}

interface LogoutCSATDialogProps {
  isOpen: boolean;
  onComplete: (data?: CSATData) => void;
  onSkip: () => void;
  userId: string | null;
  userProfile: UserProfile | null;
}

export const LogoutCSATDialog = ({
  isOpen,
  onComplete,
  onSkip,
  userId,
  userProfile,
}: LogoutCSATDialogProps) => {
  const [csat, setCsat] = useState<number | null>(null);
  const [difficulty, setDifficulty] = useState<string>("");
  const [comment, setComment] = useState<string>("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Reset state when dialog opens
  useEffect(() => {
    if (isOpen) {
      setCsat(null);
      setDifficulty("");
      setComment("");
    }
  }, [isOpen]);

  const handleSubmit = async () => {
    if (!csat) return;
    
    setIsSubmitting(true);

    const data: CSATData = {
      csat,
      difficulty: difficulty || undefined,
      comment: comment.trim() || undefined,
    };

    await onComplete(data);
    setIsSubmitting(false);
  };

  return (
    <Dialog open={isOpen} onOpenChange={(open) => { if (!open) onSkip(); }}>
      <DialogContent 
        className="sm:max-w-md bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-blue-950/30 dark:to-indigo-950/30 border-blue-200 dark:border-blue-800"
        onInteractOutside={(e) => e.preventDefault()}
      >
        <DialogHeader>
          <DialogTitle className="text-xl text-center">
            Avant de partir, 10s pour nous aider ? 📚
          </DialogTitle>
        </DialogHeader>

        <div className="space-y-6 py-4">
          {/* Question 1: Satisfaction */}
          <div className="space-y-3">
            <Label className="text-base font-semibold">
              Ta satisfaction cette session ?
            </Label>
            <div className="flex justify-center gap-4">
              {[
                { value: 5, emoji: "😊", label: "Heureux" },
                { value: 3, emoji: "😐", label: "Moyen" },
                { value: 1, emoji: "😞", label: "Déçu" },
              ].map((option) => (
                <button
                  key={option.value}
                  type="button"
                  onClick={() => setCsat(option.value)}
                  className={`flex flex-col items-center p-4 rounded-xl border-2 transition-all hover:scale-105 ${
                    csat === option.value
                      ? "border-primary bg-primary/10 shadow-md"
                      : "border-border bg-background hover:border-primary/50"
                  }`}
                >
                  <span className="text-4xl mb-1">{option.emoji}</span>
                  <span className="text-sm font-medium">{option.label}</span>
                </button>
              ))}
            </div>
          </div>

          {/* Question 2: Difficulty */}
          <div className="space-y-2">
            <Label className="text-base font-semibold">
              Difficulté des exercices ? (optionnel)
            </Label>
            <Select value={difficulty} onValueChange={setDifficulty}>
              <SelectTrigger className="bg-background">
                <SelectValue placeholder="Sélectionner..." />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="facile">😌 Facile</SelectItem>
                <SelectItem value="moyen">🤔 Moyen</SelectItem>
                <SelectItem value="dur">😓 Dur</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* Question 3: Comment */}
          <div className="space-y-2">
            <Label className="text-base font-semibold">
              Un commentaire ? (optionnel)
            </Label>
            <Textarea
              placeholder="Dis-nous ce que tu penses..."
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              className="bg-background resize-none"
              rows={3}
            />
          </div>
        </div>

        <DialogFooter className="flex gap-2 sm:gap-2">
          <Button
            variant="ghost"
            onClick={onSkip}
            disabled={isSubmitting}
            className="flex-1"
          >
            Non merci, à bientôt ! 👋
          </Button>
          <Button
            onClick={handleSubmit}
            disabled={!csat || isSubmitting}
            className="flex-1 bg-gradient-to-r from-blue-500 to-indigo-500 hover:from-blue-600 hover:to-indigo-600"
          >
            {isSubmitting ? "Envoi..." : "Envoyer ✨"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};
