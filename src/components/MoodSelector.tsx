import { useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  AlertDialog,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Button } from "@/components/ui/button";

interface MoodSelectorProps {
  isOpen: boolean;
  onClose: (selectedMood: string) => void;
  canDismiss?: boolean;
  onDismiss?: () => void;
}

const moodOptions = [
  { emoji: "😊", label: "Super motivé(e) !", value: "😊 Super motivé(e) !", color: "bg-green-100 hover:bg-green-200 border-green-300" },
  { emoji: "🙂", label: "Ça va, prêt(e) à travailler", value: "🙂 Ça va, prêt(e) à travailler", color: "bg-blue/10 hover:bg-blue/20 border-blue/30" },
  { emoji: "😐", label: "Moyen, on verra", value: "😐 Moyen, on verra", color: "bg-yellow-100 hover:bg-yellow-200 border-yellow-300" },
  { emoji: "😟", label: "Pas terrible aujourd'hui", value: "😟 Pas terrible aujourd'hui", color: "bg-orange-100 hover:bg-orange-200 border-orange-300" },
  { emoji: "😤", label: "Franchement pas motivé(e)", value: "😤 Franchement pas motivé(e)", color: "bg-red-100 hover:bg-red-200 border-red-300" },
];

export const MoodSelector = ({ isOpen, onClose, canDismiss = false, onDismiss }: MoodSelectorProps) => {
  const [selectedMood, setSelectedMood] = useState<string | null>(null);
  const [showInfoDialog, setShowInfoDialog] = useState(false);

  const handleMoodSelect = (mood: string) => {
    setSelectedMood(mood);
    // Small delay for visual feedback
    setTimeout(() => {
      onClose(mood);
      setSelectedMood(null);
    }, 200);
  };

  return (
    <>
    <Dialog 
      open={isOpen} 
      onOpenChange={(open) => {
        if (!open && canDismiss && onDismiss) {
          onDismiss();
        }
      }}
    >
      <DialogContent 
        className="sm:max-w-md" 
        onPointerDownOutside={(e) => {
          if (!canDismiss) e.preventDefault();
        }}
      >
        <DialogHeader>
          <DialogTitle className="text-2xl text-center">Comment te sens-tu aujourd'hui ?</DialogTitle>
          <div className="flex justify-center pt-2">
            <Button
              type="button"
              variant="outline"
              onClick={(e) => {
                e.stopPropagation();
                setShowInfoDialog(true);
              }}
              className="rounded-full bg-sky-100 hover:bg-sky-200 border-2 border-blue text-foreground px-6 py-2"
            >
              À quoi ça sert
            </Button>
          </div>
        </DialogHeader>
        <div className="grid gap-3 py-4">
          {moodOptions.map((option) => (
            <Button
              key={option.value}
              variant="outline"
              className={`h-auto py-4 px-6 justify-start gap-4 text-lg transition-all ${option.color} ${
                selectedMood === option.value ? "ring-2 ring-primary scale-105" : ""
              }`}
              onClick={() => handleMoodSelect(option.value)}
            >
              <span className="text-4xl">{option.emoji}</span>
              <span className="font-medium text-foreground">{option.label}</span>
            </Button>
          ))}
        </div>
      </DialogContent>
    </Dialog>

      <AlertDialog open={showInfoDialog} onOpenChange={setShowInfoDialog}>
        <AlertDialogContent className="sm:max-w-md">
          <AlertDialogHeader>
            <AlertDialogTitle className="text-xl text-center">
              Comment ton humeur influence l'expérience
            </AlertDialogTitle>
            <AlertDialogDescription className="text-base leading-relaxed pt-2">
              Plus tu es de bonne humeur et motivé, plus je vais allez creuser ce que tu fais et te poser des questions. 
              Si tu n'est pas de bonne humeur, je m'adapte! Je prendrai plus le temps sur les explications 
              ( donc elles seront plus longues ) et te poserai moins de questions.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <div className="flex justify-end pt-4">
            <Button onClick={() => setShowInfoDialog(false)}>
              Compris
            </Button>
          </div>
        </AlertDialogContent>
      </AlertDialog>
    </>
  );
};
