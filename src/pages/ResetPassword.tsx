import { useState, useEffect } from "react";
import { useNavigate, useSearchParams, Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card } from "@/components/ui/card";
import { toast } from "sonner";
import Header from "@/components/Header";
import { supabase } from "@/integrations/supabase/client";
import { z } from "zod";
import { AlertCircle, CheckCircle } from "lucide-react";

const passwordSchema = z.string().min(8, "Le mot de passe doit contenir au moins 8 caractères");

const ResetPassword = () => {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const token = searchParams.get('token');

  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!token) {
      setError("Lien invalide. Aucun token de réinitialisation trouvé.");
    }
  }, [token]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validation du mot de passe
    const validation = passwordSchema.safeParse(password);
    if (!validation.success) {
      toast.error(validation.error.errors[0].message);
      return;
    }

    // Vérification que les mots de passe correspondent
    if (password !== confirmPassword) {
      toast.error("Les mots de passe ne correspondent pas");
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const { data, error: fnError } = await supabase.functions.invoke('reset-password', {
        body: { 
          token,
          newPassword: password
        }
      });

      if (fnError) throw fnError;

      if (data.success) {
        setSuccess(true);
        toast.success("Mot de passe réinitialisé avec succès !");
      } else {
        setError(data.error || "Une erreur est survenue");
        toast.error(data.error || "Une erreur est survenue");
      }
    } catch (err: any) {
      console.error("Erreur:", err);
      setError(err.message || "Une erreur est survenue");
      toast.error(err.message || "Une erreur est survenue");
    } finally {
      setLoading(false);
    }
  };

  // État de succès
  if (success) {
    return (
      <div className="min-h-screen bg-background">
        <Header showAuthButton={false} />
        <div className="flex items-center justify-center px-4 py-8">
          <Card className="w-full max-w-md p-8 shadow-lg rounded-xl text-center">
            <div className="w-16 h-16 mx-auto mb-6 rounded-full bg-green-100 flex items-center justify-center">
              <CheckCircle className="w-8 h-8 text-green-600" />
            </div>
            <h2 className="text-2xl font-semibold mb-4">Mot de passe réinitialisé !</h2>
            <p className="text-muted-foreground mb-6">
              Votre mot de passe a été modifié avec succès. Vous pouvez maintenant vous connecter avec votre nouveau mot de passe.
            </p>
            <Button onClick={() => navigate('/login')} className="w-full">
              Se connecter
            </Button>
          </Card>
        </div>
      </div>
    );
  }

  // État d'erreur (lien invalide)
  if (error && !token) {
    return (
      <div className="min-h-screen bg-background">
        <Header showAuthButton={false} />
        <div className="flex items-center justify-center px-4 py-8">
          <Card className="w-full max-w-md p-8 shadow-lg rounded-xl text-center">
            <div className="w-16 h-16 mx-auto mb-6 rounded-full bg-destructive/10 flex items-center justify-center">
              <AlertCircle className="w-8 h-8 text-destructive" />
            </div>
            <h2 className="text-2xl font-semibold mb-4">Lien invalide</h2>
            <p className="text-muted-foreground mb-6">
              {error}
            </p>
            <Link to="/forgot-password">
              <Button className="w-full">
                Demander un nouveau lien
              </Button>
            </Link>
          </Card>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      <Header showAuthButton={false} />
      <div className="flex items-center justify-center px-4 py-8">
        <Card className="w-full max-w-md p-8 shadow-lg rounded-xl">
          <h2 className="text-2xl font-semibold mb-2">Nouveau mot de passe</h2>
          <p className="text-muted-foreground mb-8">
            Entrez votre nouveau mot de passe ci-dessous.
          </p>

          {error && (
            <div className="mb-6 p-4 rounded-lg bg-destructive/10 border border-destructive/20">
              <p className="text-sm text-destructive">{error}</p>
              <Link to="/forgot-password" className="text-sm text-primary hover:underline mt-2 block">
                Demander un nouveau lien
              </Link>
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <Label htmlFor="password">Nouveau mot de passe *</Label>
              <Input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Minimum 8 caractères"
                required
                minLength={8}
                className="mt-2"
              />
            </div>

            <div>
              <Label htmlFor="confirmPassword">Confirmer le mot de passe *</Label>
              <Input
                id="confirmPassword"
                type="password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                placeholder="Répétez votre mot de passe"
                required
                minLength={8}
                className="mt-2"
              />
            </div>

            <Button type="submit" className="w-full mt-6" disabled={loading}>
              {loading ? "Réinitialisation..." : "Réinitialiser le mot de passe"}
            </Button>

            <p className="text-center text-sm mt-4">
              <Link to="/login" className="text-primary hover:underline">
                Retour à la connexion
              </Link>
            </p>
          </form>
        </Card>
      </div>
    </div>
  );
};

export default ResetPassword;
