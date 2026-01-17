import { useState } from "react";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "@/hooks/use-toast";
import { UserPlus, Mail, Loader2, AlertTriangle } from "lucide-react";
import { z } from "zod";
import { detectEmailTypo, type EmailTypoResult } from "@/utils/emailValidation";

interface InviteParentsDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  userId: string;
  onSuccess: () => void;
}

const emailSchema = z.string().trim().email("Email invalide");

export const InviteParentsDialog = ({ open, onOpenChange, userId, onSuccess }: InviteParentsDialogProps) => {
  const [email1, setEmail1] = useState("");
  const [email2, setEmail2] = useState("");
  const [showSecondEmail, setShowSecondEmail] = useState(false);
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<{ email1?: string; email2?: string }>({});
  const [typoWarning1, setTypoWarning1] = useState<EmailTypoResult | null>(null);
  const [typoWarning2, setTypoWarning2] = useState<EmailTypoResult | null>(null);

  const resetForm = () => {
    setEmail1("");
    setEmail2("");
    setShowSecondEmail(false);
    setErrors({});
    setTypoWarning1(null);
    setTypoWarning2(null);
  };

  const checkTypos = (): boolean => {
    const typo1 = email1.trim() ? detectEmailTypo(email1) : null;
    const typo2 = showSecondEmail && email2.trim() ? detectEmailTypo(email2) : null;

    if (typo1?.hasTypo) {
      setTypoWarning1(typo1);
      return true;
    }
    if (typo2?.hasTypo) {
      setTypoWarning2(typo2);
      return true;
    }
    return false;
  };

  const applyTypoCorrection = (field: 1 | 2) => {
    if (field === 1 && typoWarning1?.suggestedEmail) {
      setEmail1(typoWarning1.suggestedEmail);
      setTypoWarning1(null);
    } else if (field === 2 && typoWarning2?.suggestedEmail) {
      setEmail2(typoWarning2.suggestedEmail);
      setTypoWarning2(null);
    }
  };

  const ignoreTypoWarning = (field: 1 | 2) => {
    if (field === 1) {
      setTypoWarning1(null);
    } else {
      setTypoWarning2(null);
    }
  };

  const validateEmails = (): boolean => {
    const newErrors: { email1?: string; email2?: string } = {};

    // Validate email1
    if (!email1.trim()) {
      newErrors.email1 = "L'email est requis";
    } else {
      const result = emailSchema.safeParse(email1);
      if (!result.success) {
        newErrors.email1 = "Email invalide";
      }
    }

    // Validate email2 if shown
    if (showSecondEmail && email2.trim()) {
      const result = emailSchema.safeParse(email2);
      if (!result.success) {
        newErrors.email2 = "Email invalide";
      }
    }

    // Check for duplicate emails
    if (email1.trim() && email2.trim() && email1.toLowerCase() === email2.toLowerCase()) {
      newErrors.email2 = "Les deux emails doivent être différents";
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async () => {
    if (!validateEmails()) {
      return;
    }

    // Vérifier les fautes de frappe avant l'envoi
    if (checkTypos()) {
      return; // Affiche les warnings, l'utilisateur doit confirmer
    }

    await sendInvitations();
  };

  const sendInvitations = async () => {
    setLoading(true);

    try {
      const parentEmails = [email1.trim()];
      if (showSecondEmail && email2.trim()) {
        parentEmails.push(email2.trim());
      }

      const { data, error } = await supabase.functions.invoke("invite-parents", {
        body: { parentEmails },
      });

      if (error) {
        throw error;
      }

      if (data?.error) {
        throw new Error(data.error);
      }

      toast({
        title: "Invitations envoyées !",
        description: `${parentEmails.length} invitation(s) envoyée(s) avec succès. Tes parents vont recevoir un email pour créer leur compte.`,
      });

      resetForm();
      onOpenChange(false);
      onSuccess();
    } catch (error: any) {
      console.error("Erreur lors de l'envoi des invitations:", error);
      toast({
        title: "Erreur",
        description: error.message || "Une erreur est survenue lors de l'envoi des invitations",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  const handleClose = () => {
    if (!loading) {
      resetForm();
      onOpenChange(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader>
          <div className="flex items-center gap-2">
            <UserPlus className="h-6 w-6 text-primary" />
            <DialogTitle className="text-2xl">Inviter tes parents</DialogTitle>
          </div>
          <DialogDescription className="text-base pt-2">
            Permets à tes parents de suivre ta progression en mathématiques. T'inquiète pas, ils n'ont pas accès à ce que tu fais, le but est de leur montrer ta progression et d'identifier les potentiels points bloquants. Ils recevront un email pour créer leur compte.
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-4 py-4">
          {/* Premier email */}
          <div className="space-y-2">
            <Label htmlFor="email1" className="text-base flex items-center gap-2">
              <Mail className="h-4 w-4" />
              Email du premier parent *
            </Label>
            <Input
              id="email1"
              type="email"
              placeholder="parent1@example.com"
              value={email1}
              onChange={(e) => {
                setEmail1(e.target.value);
                if (errors.email1) setErrors({ ...errors, email1: undefined });
                if (typoWarning1) setTypoWarning1(null);
              }}
              disabled={loading}
              className={errors.email1 ? "border-destructive" : ""}
            />
            {errors.email1 && (
              <p className="text-sm text-destructive">{errors.email1}</p>
            )}
            {/* Avertissement faute de frappe email 1 */}
            {typoWarning1 && (
              <div className="p-3 bg-yellow-50 dark:bg-yellow-950 border border-yellow-200 dark:border-yellow-800 rounded-lg">
                <div className="flex items-start gap-2">
                  <AlertTriangle className="h-4 w-4 text-yellow-600 dark:text-yellow-400 mt-0.5 flex-shrink-0" />
                  <div className="space-y-2 flex-1">
                    <p className="text-sm text-yellow-800 dark:text-yellow-200">
                      Faute de frappe détectée : <strong>{typoWarning1.domain}</strong>
                    </p>
                    <p className="text-sm text-yellow-700 dark:text-yellow-300">
                      Vouliez-vous dire <strong>{typoWarning1.suggestedEmail}</strong> ?
                    </p>
                    <div className="flex gap-2 flex-wrap">
                      <Button 
                        size="sm" 
                        type="button"
                        onClick={() => applyTypoCorrection(1)}
                      >
                        Corriger
                      </Button>
                      <Button 
                        size="sm" 
                        variant="outline"
                        type="button"
                        onClick={() => ignoreTypoWarning(1)}
                      >
                        Garder tel quel
                      </Button>
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>

          {/* Second email (conditionnel) */}
          {showSecondEmail ? (
            <div className="space-y-2">
              <Label htmlFor="email2" className="text-base flex items-center gap-2">
                <Mail className="h-4 w-4" />
                Email du second parent
              </Label>
              <Input
                id="email2"
                type="email"
                placeholder="parent2@example.com"
                value={email2}
                onChange={(e) => {
                  setEmail2(e.target.value);
                  if (errors.email2) setErrors({ ...errors, email2: undefined });
                  if (typoWarning2) setTypoWarning2(null);
                }}
                disabled={loading}
                className={errors.email2 ? "border-destructive" : ""}
              />
              {errors.email2 && (
                <p className="text-sm text-destructive">{errors.email2}</p>
              )}
              {/* Avertissement faute de frappe email 2 */}
              {typoWarning2 && (
                <div className="p-3 bg-yellow-50 dark:bg-yellow-950 border border-yellow-200 dark:border-yellow-800 rounded-lg">
                  <div className="flex items-start gap-2">
                    <AlertTriangle className="h-4 w-4 text-yellow-600 dark:text-yellow-400 mt-0.5 flex-shrink-0" />
                    <div className="space-y-2 flex-1">
                      <p className="text-sm text-yellow-800 dark:text-yellow-200">
                        Faute de frappe détectée : <strong>{typoWarning2.domain}</strong>
                      </p>
                      <p className="text-sm text-yellow-700 dark:text-yellow-300">
                        Vouliez-vous dire <strong>{typoWarning2.suggestedEmail}</strong> ?
                      </p>
                      <div className="flex gap-2 flex-wrap">
                        <Button 
                          size="sm" 
                          type="button"
                          onClick={() => applyTypoCorrection(2)}
                        >
                          Corriger
                        </Button>
                        <Button 
                          size="sm" 
                          variant="outline"
                          type="button"
                          onClick={() => ignoreTypoWarning(2)}
                        >
                          Garder tel quel
                        </Button>
                      </div>
                    </div>
                  </div>
                </div>
              )}
            </div>
          ) : (
            <Button
              type="button"
              variant="outline"
              onClick={() => setShowSecondEmail(true)}
              disabled={loading}
              className="w-full border-dashed"
            >
              <UserPlus className="h-4 w-4 mr-2" />
              Ajouter un 2ème parent
            </Button>
          )}
        </div>

        <DialogFooter>
          <Button
            variant="outline"
            onClick={handleClose}
            disabled={loading}
          >
            Annuler
          </Button>
          <Button
            onClick={handleSubmit}
            disabled={loading || !email1.trim()}
          >
            {loading ? (
              <>
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                Envoi en cours...
              </>
            ) : (
              <>
                <Mail className="mr-2 h-4 w-4" />
                Envoyer les invitations
              </>
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};
