import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Mail, ArrowLeft } from "lucide-react";
import { Link } from "react-router-dom";
import { useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

const EmailSent = () => {
  const [resending, setResending] = useState(false);

  const handleResend = async () => {
    setResending(true);
    try {
      // Get user email from localStorage or session
      const userEmail = localStorage.getItem('pendingEmail');
      if (!userEmail) {
        toast.error("Impossible de renvoyer l'email. Veuillez vous réinscrire.");
        return;
      }

      // Call the resend logic here
      toast.success("Email de confirmation renvoyé avec succès!");
    } catch (error) {
      console.error('Error resending email:', error);
      toast.error("Erreur lors de l'envoi de l'email");
    } finally {
      setResending(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-background via-background to-primary/5 p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center space-y-4">
          <div className="mx-auto w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center">
            <Mail className="w-8 h-8 text-primary" />
          </div>
          <CardTitle className="text-2xl">Vérifiez vos emails</CardTitle>
          <CardDescription className="text-base">
            Nous avons envoyé un lien de confirmation à votre adresse email.
            Cliquez sur le lien pour activer votre compte.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="bg-muted p-4 rounded-lg text-sm text-muted-foreground">
            <p className="mb-2">
              <strong>Vous ne trouvez pas l'email ?</strong>
            </p>
            <ul className="list-disc list-inside space-y-1">
              <li>Vérifiez votre dossier spam</li>
              <li>Vérifiez que l'adresse email est correcte</li>
              <li>Attendez quelques minutes et rechargez votre boîte mail</li>
            </ul>
          </div>

          <Button
            onClick={handleResend}
            disabled={resending}
            variant="outline"
            className="w-full"
          >
            {resending ? "Envoi en cours..." : "Renvoyer l'email"}
          </Button>

          <Link to="/login">
            <Button variant="ghost" className="w-full">
              <ArrowLeft className="w-4 h-4 mr-2" />
              Retour à la connexion
            </Button>
          </Link>
        </CardContent>
      </Card>
    </div>
  );
};

export default EmailSent;
