import {
  AlertDialog,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Button } from "@/components/ui/button";
import { Sparkles } from "lucide-react";

interface WelcomePopupProps {
  isOpen: boolean;
  onClose: () => void;
}

export const WelcomePopup = ({ isOpen, onClose }: WelcomePopupProps) => {
  return (
    <AlertDialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <AlertDialogContent className="sm:max-w-md text-center">
        <AlertDialogHeader className="space-y-4">
          <div className="mx-auto w-20 h-20 rounded-full bg-gradient-to-br from-blue-100 to-cyan-100 flex items-center justify-center">
            <Sparkles className="w-10 h-10 text-blue-500" />
          </div>
          
          <AlertDialogTitle className="text-2xl">
            Bienvenue !
          </AlertDialogTitle>
          
          <AlertDialogDescription className="text-base leading-relaxed text-muted-foreground">
            La plateforme est toute neuve, donc beaucoup de mises à jour vont arriver. 
            Quelques bugs peuvent persister, n'hésite surtout pas à écrire pour les signaler, 
            les réponses sont très rapides. Merci !
          </AlertDialogDescription>
        </AlertDialogHeader>
        
        <div className="pt-4">
          <Button onClick={onClose} className="w-full">
            C'est parti !
          </Button>
        </div>
      </AlertDialogContent>
    </AlertDialog>
  );
};
