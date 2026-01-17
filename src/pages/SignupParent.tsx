import { useState, useEffect } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";
import { Loader2, UserCircle2 } from "lucide-react";

export default function SignupParent() {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const token = searchParams.get("token");

  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [invitation, setInvitation] = useState<any>(null);
  
  const [prenom, setPrenom] = useState("");
  const [nom, setNom] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");

  useEffect(() => {
    if (!token) {
      toast.error("Lien d'invitation invalide");
      navigate("/login");
      return;
    }

    // Récupérer les informations de l'invitation via edge function (bypass RLS)
    const fetchInvitation = async () => {
      try {
        const { data, error } = await supabase.functions.invoke("validate-parent-invitation", {
          body: { token },
        });

        if (error) {
          console.error("Error validating invitation:", error);
          toast.error("Erreur lors de la vérification de l'invitation");
          navigate("/login");
          return;
        }

        if (data?.error) {
          toast.error(data.error);
          navigate("/login");
          return;
        }

        if (!data?.success || !data?.invitation) {
          toast.error("Ce lien d'invitation n'est pas valide ou a expiré");
          navigate("/login");
          return;
        }

        setInvitation(data.invitation);
      } catch (error) {
        console.error("Unexpected error:", error);
        toast.error("Une erreur inattendue s'est produite");
        navigate("/login");
      } finally {
        setLoading(false);
      }
    };

    fetchInvitation();
  }, [token, navigate]);

  const getPasswordStrength = (password: string) => {
    if (!password) return { label: "", color: "" };
    if (password.length < 8) return { label: "Faible", color: "text-destructive" };
    if (password.length < 12) return { label: "Moyen", color: "text-yellow-600" };
    return { label: "Fort", color: "text-green-600" };
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!prenom.trim() || !nom.trim()) {
      toast.error("Veuillez renseigner votre prénom et nom");
      return;
    }

    if (password.length < 8) {
      toast.error("Le mot de passe doit contenir au moins 8 caractères");
      return;
    }

    if (password !== confirmPassword) {
      toast.error("Les mots de passe ne correspondent pas");
      return;
    }

    setSubmitting(true);

    try {
      const { data, error } = await supabase.functions.invoke("signup-parent", {
        body: {
          invitationToken: token,
          prenom: prenom.trim(),
          nom: nom.trim(),
          password,
        },
      });

      // Le message d'erreur du serveur peut être dans 'data' même si 'error' existe
      if (error || data?.error || data?.success === false) {
        console.error("Error creating parent account:", error, data);
        
        // Prioriser le message d'erreur métier du serveur
        const errorMessage = 
          data?.error ||
          (error?.message && !error.message.includes("non-2xx") ? error.message : null) ||
          "Erreur lors de la création du compte";
        
        toast.error(errorMessage);
        return;
      }

      toast.success("Email de confirmation envoyé ! Vérifiez votre boîte mail (valable 15 minutes).");
      navigate("/email-sent");
    } catch (error) {
      console.error("Unexpected error:", error);
      toast.error("Une erreur inattendue s'est produite");
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-b from-background to-secondary/20">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (!invitation) {
    return null;
  }

  const passwordStrength = getPasswordStrength(password);

  return (
    <div className="min-h-screen flex items-center justify-center p-4 bg-gradient-to-b from-background to-secondary/20">
      <Card className="w-full max-w-md">
        <CardHeader className="space-y-1">
          <CardTitle className="text-2xl text-center">Bienvenue sur le site Siimply</CardTitle>
          <CardDescription className="text-center">
            merci de compléter les champs ci-dessous
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            {/* Bloc enfant */}
            <div className="flex items-center gap-3 p-4 rounded-lg bg-secondary/50 border border-border">
              <UserCircle2 className="h-8 w-8 text-primary" />
              <div>
                <div className="text-sm text-muted-foreground">Inscription parent de :</div>
                <div className="font-semibold">
                  {invitation.profiles?.prenom} {invitation.profiles?.nom}
                </div>
              </div>
            </div>

            {/* Prénom du parent */}
            <div className="space-y-2">
              <Label htmlFor="prenom">Prénom du parent *</Label>
              <Input
                id="prenom"
                type="text"
                placeholder="Votre prénom"
                value={prenom}
                onChange={(e) => setPrenom(e.target.value)}
                required
                disabled={submitting}
              />
            </div>

            {/* Nom du parent */}
            <div className="space-y-2">
              <Label htmlFor="nom">Nom du parent *</Label>
              <Input
                id="nom"
                type="text"
                placeholder="Votre nom"
                value={nom}
                onChange={(e) => setNom(e.target.value)}
                required
                disabled={submitting}
              />
            </div>

            {/* Email pré-rempli */}
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                value={invitation.parent_email}
                readOnly
                disabled
                className="bg-muted"
              />
            </div>

            {/* Mot de passe */}
            <div className="space-y-2">
              <Label htmlFor="password">Mot de passe *</Label>
              <Input
                id="password"
                type="password"
                placeholder="Minimum 8 caractères"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                disabled={submitting}
              />
              {password && (
                <p className={`text-sm ${passwordStrength.color}`}>
                  Force : {passwordStrength.label}
                </p>
              )}
            </div>

            {/* Confirmer mot de passe */}
            <div className="space-y-2">
              <Label htmlFor="confirmPassword">Confirmer le mot de passe *</Label>
              <Input
                id="confirmPassword"
                type="password"
                placeholder="Retapez votre mot de passe"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                required
                disabled={submitting}
              />
            </div>

            {/* Bouton de soumission */}
            <Button type="submit" className="w-full" disabled={submitting}>
              {submitting ? (
                <>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  Création en cours...
                </>
              ) : (
                "Créer mon compte"
              )}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
