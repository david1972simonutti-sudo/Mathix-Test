import { useState, useEffect } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { supabase } from "@/integrations/supabase/client";
import { z } from "zod";

interface ContactModalProps {
  isOpen: boolean;
  onClose: () => void;
}

const contactSchema = z.object({
  objet: z.string().trim().min(1, "L'objet est requis").max(100, "100 caractères max"),
  email: z.string().trim().email("Email invalide").max(255, "255 caractères max"),
  message: z.string().trim().min(1, "Le message est requis").max(2000, "2000 caractères max"),
});

const ContactModal = ({ isOpen, onClose }: ContactModalProps) => {
  const [objet, setObjet] = useState("");
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const [status, setStatus] = useState<"idle" | "sending" | "success" | "error">("idle");
  const [errorMessage, setErrorMessage] = useState("");

  // Pré-remplir l'email si l'utilisateur est connecté
  useEffect(() => {
    const fetchUserEmail = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        const { data: profile } = await supabase
          .from('profiles')
          .select('email')
          .eq('user_id', user.id)
          .single();
        if (profile?.email) {
          setEmail(profile.email);
        }
      }
    };
    if (isOpen) {
      fetchUserEmail();
    }
  }, [isOpen]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage("");

    // Validation
    const result = contactSchema.safeParse({ objet, email, message });
    if (!result.success) {
      setErrorMessage(result.error.errors[0].message);
      return;
    }

    setStatus("sending");

    try {
      const { error } = await supabase.functions.invoke("send-email", {
        body: {
          type: "contact_with_confirmation",
          objet: result.data.objet,
          email: result.data.email,
          message: result.data.message,
        },
      });

      if (error) throw error;

      setStatus("success");

      setTimeout(() => {
        onClose();
        setObjet("");
        setEmail("");
        setMessage("");
        setStatus("idle");
      }, 1500);
    } catch (err: any) {
      console.error("Erreur envoi contact:", err);
      setStatus("error");
      setErrorMessage("Une erreur est survenue. Réessayez plus tard.");
    }
  };

  const getButtonContent = () => {
    switch (status) {
      case "sending":
        return "Envoi en cours...";
      case "success":
        return "C'est parti ! 🎉";
      case "error":
        return "Réessayer";
      default:
        return "Envoyer";
    }
  };

  const getButtonStyles = () => {
    if (status === "success") {
      return "bg-green-500 hover:bg-green-500";
    }
    if (status === "sending") {
      return "bg-gradient-to-br from-[#667eea] to-[#764ba2] opacity-70 cursor-wait";
    }
    if (status === "error") {
      return "bg-destructive hover:bg-destructive/90";
    }
    return "bg-gradient-to-br from-[#667eea] to-[#764ba2] hover:scale-[1.02] hover:brightness-110";
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle className="text-2xl">Nous contacter</DialogTitle>
          <DialogDescription>
            Pose ta question en maths, signale un problème ou pose une question générale. Réponse rapide !
          </DialogDescription>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="objet">Objet</Label>
              <Input
                id="objet"
                type="text"
                placeholder="Question sur l'abonnement"
                value={objet}
                onChange={(e) => setObjet(e.target.value)}
                required
                maxLength={100}
                className="rounded-xl border-2 border-transparent bg-secondary/50 px-4 py-3 text-sm transition-all focus:bg-background focus:border-[#764ba2] focus:ring-4 focus:ring-[#764ba2]/10"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="email">Ton Email</Label>
              <Input
                id="email"
                type="email"
                placeholder="marie@email.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                maxLength={255}
                className="rounded-xl border-2 border-transparent bg-secondary/50 px-4 py-3 text-sm transition-all focus:bg-background focus:border-[#764ba2] focus:ring-4 focus:ring-[#764ba2]/10"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="message">Ton Message</Label>
              <Textarea
                id="message"
                placeholder="Dis-nous tout..."
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                required
                maxLength={2000}
                className="rounded-xl border-2 border-transparent bg-secondary/50 px-4 py-3 text-sm min-h-[100px] resize-y transition-all focus:bg-background focus:border-[#764ba2] focus:ring-4 focus:ring-[#764ba2]/10"
              />
            </div>
          </div>

          {errorMessage && (
            <p className="text-sm text-destructive">{errorMessage}</p>
          )}

          <button
            type="submit"
            disabled={status === "sending"}
            className={`w-full py-4 rounded-xl text-white font-bold text-base transition-all duration-200 flex items-center justify-center gap-2 ${getButtonStyles()}`}
          >
            {getButtonContent()}
          </button>
        </form>
      </DialogContent>
    </Dialog>
  );
};

export default ContactModal;
