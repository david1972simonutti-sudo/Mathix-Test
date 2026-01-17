import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { AlertTriangle } from "lucide-react";

interface DisplayWarningPopupProps {
  isOpen: boolean;
  onClose: () => void;
  warningType: "tableaux" | "arbres";
}

export const DisplayWarningPopup = ({
  isOpen,
  onClose,
  warningType,
}: DisplayWarningPopupProps) => {
  const displayElement = warningType === "tableaux" ? "Les tableaux" : "Les arbres";

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2 text-amber-600">
            <AlertTriangle className="h-5 w-5" />
            Petit avertissement
          </DialogTitle>
          <DialogDescription className="text-base pt-2">
            {displayElement} ne s'affichent pas bien pour le moment, le correctif arrive très vite, désolé !
          </DialogDescription>
        </DialogHeader>
        <div className="flex justify-end pt-4">
          <Button onClick={onClose} className="px-6">
            Compris !
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
};
