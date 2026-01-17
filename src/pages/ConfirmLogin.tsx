import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Loader2, Lock, Mail } from "lucide-react";
import { useSearchParams, useNavigate } from "react-router-dom";
import { useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { toast } from "sonner";

const ConfirmLogin = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [email, setEmail] = useState(() => {
    return localStorage.getItem('pendingEmail') || "";
  });
  const [password, setPassword] = useState("");

  const token = searchParams.get('token');
  const userType = searchParams.get('type') || 'student'; // student ou parent

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!token) {
      toast.error("Token de confirmation manquant");
      return;
    }

    if (!email || !password) {
      toast.error("Veuillez remplir tous les champs");
      return;
    }

    setLoading(true);

    try {
      // 1. D'ABORD finaliser l'inscription (confirme l'email)
      console.log("📝 Finalisation de l'inscription...");
      const functionName = userType === 'parent' ? 'complete-parent-signup' : 'complete-signup';
      
      const { data: completeData, error: completeError } = await supabase.functions.invoke(
        functionName,
        {
          body: {
            token,
            email,
          },
        }
      );

      if (completeError) {
        console.error("❌ Erreur finalisation:", completeError);
        throw new Error(completeError.message || "Erreur lors de la finalisation de l'inscription");
      }

      if (!completeData?.success) {
        console.error("❌ Finalisation échouée:", completeData);
        throw new Error(completeData?.error || "Erreur lors de la finalisation de l'inscription");
      }

      console.log("✅ Inscription finalisée, connexion...");

      // 2. ENSUITE se connecter (l'email est maintenant confirmé)
      const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (authError || !authData.user) {
        console.error("❌ Erreur de connexion:", authError);
        throw new Error("Email ou mot de passe incorrect");
      }

      console.log("🎉 Connexion réussie!");
      toast.success("Votre compte a été activé avec succès!");

      // Vérifier le rôle de l'utilisateur
      const { data: roleData } = await supabase
        .from('user_roles')
        .select('role')
        .eq('user_id', authData.user.id)
        .single();

      // Redirection selon le rôle
      setTimeout(() => {
        if (roleData?.role === 'parent') {
          navigate("/parents");
        } else {
          navigate("/");
        }
      }, 1000);

    } catch (error: any) {
      console.error("Erreur confirmation:", error);
      toast.error(error.message || "Une erreur est survenue");
    } finally {
      setLoading(false);
    }
  };

  if (!token) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-background via-background to-primary/5 p-4">
        <Card className="w-full max-w-md">
          <CardHeader className="text-center">
            <CardTitle className="text-2xl text-destructive">Lien invalide</CardTitle>
            <CardDescription>
              Le lien de confirmation est manquant ou invalide.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Button onClick={() => navigate("/login")} className="w-full">
              Retour à la connexion
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-background via-background to-primary/5 p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center space-y-4">
          <div className="mx-auto w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center">
            <Lock className="w-8 h-8 text-primary" />
          </div>
          <CardTitle className="text-2xl">Confirmez votre inscription</CardTitle>
          <CardDescription className="text-base">
            Pour activer votre compte, veuillez vous connecter avec vos identifiants
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="email">Adresse email</Label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                <Input
                  id="email"
                  type="email"
                  placeholder="votre@email.fr"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="pl-10"
                  required
                  disabled={loading}
                />
              </div>
              <button
                type="button"
                onClick={() => navigate("/signup")}
                className="text-xs text-muted-foreground hover:text-primary underline"
              >
                Ce n'est pas mon email ?
              </button>
            </div>

            <div className="space-y-2">
              <Label htmlFor="password">Mot de passe</Label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                <Input
                  id="password"
                  type="password"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="pl-10"
                  required
                  disabled={loading}
                />
              </div>
            </div>

            <div className="bg-primary/5 border border-primary/20 rounded-lg p-3">
              <p className="text-sm text-muted-foreground">
                ⏰ Ce lien est valable pendant <strong>15 minutes</strong>
              </p>
            </div>

            <Button type="submit" className="w-full" disabled={loading}>
              {loading ? (
                <>
                  <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                  Confirmation en cours...
                </>
              ) : (
                "Confirmer et activer mon compte"
              )}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
};

export default ConfirmLogin;
