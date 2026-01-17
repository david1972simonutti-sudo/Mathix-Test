import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import {
  Drawer,
  DrawerContent,
  DrawerDescription,
  DrawerFooter,
  DrawerHeader,
  DrawerTitle,
} from "@/components/ui/drawer";
import { Button } from "@/components/ui/button";
import { AlertTriangle } from "lucide-react";
import { useIsMobile } from "@/hooks/use-mobile";

interface CorrectionWarningPopupProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirmCorrection: () => void;
}

const CorrectionWarningPopup = ({
  isOpen,
  onClose,
  onConfirmCorrection,
}: CorrectionWarningPopupProps) => {
  const isMobile = useIsMobile();

  const messageContent = (
    <>
      Me demander la correction ne va pas te faire progresser, et je ne peux pas évaluer tes compétences pour t'aider à combler tes lacunes.
      <br /><br />
      Pour que tu sois au point pour ta prochaine interro, il faut te lancer et essayer. Si tu rates, pas grave, je suis fait pour t'amener à réussir.
    </>
  );

  if (isMobile) {
    return (
      <Drawer open={isOpen} onOpenChange={(open) => !open && onClose()}>
        <DrawerContent>
          <DrawerHeader className="text-left">
            <DrawerTitle className="flex items-center gap-2 text-xl">
              <AlertTriangle className="h-6 w-6 text-amber-500" />
              Attention !
            </DrawerTitle>
            <DrawerDescription className="text-base leading-relaxed pt-2">
              {messageContent}
            </DrawerDescription>
          </DrawerHeader>
          <DrawerFooter className="flex flex-col gap-2 pb-6">
            <Button 
              onClick={onClose} 
              className="w-full"
            >
              OK, je vais essayer 💪
            </Button>
            <Button 
              variant="outline" 
              onClick={onConfirmCorrection} 
              className="w-full border-muted-foreground/30 text-muted-foreground"
            >
              Je veux quand même la correction
            </Button>
          </DrawerFooter>
        </DrawerContent>
      </Drawer>
    );
  }

  return (
    <AlertDialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <AlertDialogContent className="max-w-lg">
        <AlertDialogHeader>
          <AlertDialogTitle className="flex items-center gap-2 text-xl">
            <AlertTriangle className="h-6 w-6 text-amber-500" />
            Attention !
          </AlertDialogTitle>
          <AlertDialogDescription className="text-base leading-relaxed pt-2 text-foreground">
            {messageContent}
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter className="flex-col gap-2 sm:flex-row">
          <AlertDialogCancel
            onClick={onConfirmCorrection}
            className="border-muted-foreground/30 text-muted-foreground hover:bg-muted"
          >
            Je veux quand même la correction
          </AlertDialogCancel>
          <AlertDialogAction
            onClick={onClose}
            className="bg-primary text-primary-foreground hover:bg-primary/90"
          >
            OK, je vais essayer 💪
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  );
};

export default CorrectionWarningPopup;
