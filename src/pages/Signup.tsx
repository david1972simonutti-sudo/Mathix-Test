import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card } from "@/components/ui/card";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";
import Header from "@/components/Header";
import GeometricBackground from "@/components/GeometricBackground";
import ContactModal from "@/components/ContactModal";

const Signup = () => {
  const navigate = useNavigate();
  const [prenom, setPrenom] = useState("");
  const [nom, setNom] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showContactModal, setShowContactModal] = useState(false);
  const [confirmPassword, setConfirmPassword] = useState("");
  const [classe, setClasse] = useState("");
  const [acceptTerms, setAcceptTerms] = useState(false);
  const [receptionNews, setReceptionNews] = useState(false);
  const [parentEmail1, setParentEmail1] = useState("");
  const [parentEmail2, setParentEmail2] = useState("");
  const [loading, setLoading] = useState(false);

  const getPasswordStrength = (password: string) => {
    if (password.length < 8) return { label: "Trop court", color: "text-error" };
    if (password.length < 10) return { label: "Faible", color: "text-warning" };
    if (password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$/))
      return { label: "Fort", color: "text-success" };
    return { label: "Moyen", color: "text-warning" };
  };

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!acceptTerms) {
      toast.error("Veuillez accepter de participer au test");
      return;
    }

    if (password !== confirmPassword) {
      toast.error("Les mots de passe ne correspondent pas");
      return;
    }

    setLoading(true);

    try {
      // Validate parent emails
      const parentEmails: string[] = [];
      if (parentEmail1.trim()) {
        if (parentEmail1.trim().toLowerCase() === email.toLowerCase()) {
          toast.error("L'email du parent 1 ne peut pas être identique à ton email");
          setLoading(false);
          return;
        }
        parentEmails.push(parentEmail1.trim());
      }
      if (parentEmail2.trim()) {
        if (parentEmail2.trim().toLowerCase() === email.toLowerCase()) {
          toast.error("L'email du parent 2 ne peut pas être identique à ton email");
          setLoading(false);
          return;
        }
        if (parentEmail1.trim() && parentEmail2.trim().toLowerCase() === parentEmail1.trim().toLowerCase()) {
          toast.error("Les deux emails parents doivent être différents");
          setLoading(false);
          return;
        }
        parentEmails.push(parentEmail2.trim());
      }

      // Call the signup-student edge function
      const { data, error } = await supabase.functions.invoke('signup-student', {
        body: {
          email,
          password,
          nom,
          prenom,
          classe,
          receptionNews,
          parentEmails,
        }
      });

      if (error) throw error;
      
      if (!data?.success) {
        throw new Error(data?.error || "Erreur lors de la création du compte");
      }

      // Store email in localStorage for resend functionality
      localStorage.setItem('pendingEmail', email);

      // Show success message
      toast.success("Compte créé ! Vérifiez votre email.");

      // Redirect to email sent page
      navigate('/email-sent');
    } catch (error: any) {
      console.error('Signup error:', error);
      
      const errorMessage = error.message || "Erreur lors de la création du compte";
      const isExistingAccount = errorMessage.includes("compte existe déjà") || 
                               errorMessage.includes("already") ||
                               errorMessage.includes("vous connecter");
      
      if (isExistingAccount) {
        toast.error("Un compte existe déjà avec cet email", {
          description: "Veuillez vous connecter ou utiliser un autre email.",
          action: {
            label: "Se connecter",
            onClick: () => navigate("/login"),
          },
        });
      } else {
        toast.error(errorMessage);
      }
    } finally {
      setLoading(false);
    }
  };

  const passwordStrength = getPasswordStrength(password);

  return (
    <GeometricBackground className="min-h-screen" onContactClick={() => setShowContactModal(true)}>
      <Header showAuthButton={false} />
      <div className="flex items-center justify-center px-4 py-8">
        <Card className="w-full max-w-md p-8 shadow-lg rounded-xl bg-white/95 backdrop-blur-sm">

        <h2 className="text-2xl font-semibold mb-8">Créer mon compte</h2>

        <form onSubmit={handleSignup} className="space-y-4">
          <div>
            <Label htmlFor="prenom">Prénom *</Label>
            <Input
              id="prenom"
              type="text"
              value={prenom}
              onChange={(e) => setPrenom(e.target.value)}
              required
              className="mt-2"
            />
          </div>

          <div>
            <Label htmlFor="nom">Nom *</Label>
            <Input
              id="nom"
              type="text"
              value={nom}
              onChange={(e) => setNom(e.target.value)}
              required
              className="mt-2"
            />
          </div>

          <div>
            <Label htmlFor="email">Email *</Label>
            <Input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              className="mt-2"
            />
          </div>

          <div>
            <Label htmlFor="password">Mot de passe *</Label>
            <Input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              minLength={8}
              className="mt-2"
            />
            {password && (
              <p className={`text-xs mt-1 ${passwordStrength.color}`}>
                Force : {passwordStrength.label}
              </p>
            )}
          </div>

          <div>
            <Label htmlFor="confirmPassword">Confirmer le mot de passe *</Label>
            <Input
              id="confirmPassword"
              type="password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              required
              minLength={8}
              className="mt-2"
            />
            {confirmPassword && password !== confirmPassword && (
              <p className="text-xs mt-1 text-destructive">
                Les mots de passe ne correspondent pas
              </p>
            )}
          </div>

          <div>
            <Label htmlFor="classe">Classe *</Label>
            <Select value={classe} onValueChange={setClasse} required>
              <SelectTrigger className="mt-2">
                <SelectValue placeholder="Sélectionne ta classe" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="seconde">Seconde</SelectItem>
                <SelectItem value="premiere">Première</SelectItem>
                <SelectItem value="terminale">Terminale</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div className="space-y-4 pt-4 border-t border-border">
            <h3 className="text-sm font-semibold">Informations parents (optionnel)</h3>
            <p className="text-xs text-muted-foreground">
              Tu peux ajouter jusqu'à 2 emails de parents. Seuls les parents peuvent effectuer les paiements.
            </p>
            
            <div>
              <Label htmlFor="parentEmail1">Email parent 1</Label>
              <Input
                id="parentEmail1"
                type="email"
                value={parentEmail1}
                onChange={(e) => setParentEmail1(e.target.value)}
                placeholder="parent1@email.com"
                className="mt-2"
              />
            </div>

            <div>
              <Label htmlFor="parentEmail2">Email parent 2</Label>
              <Input
                id="parentEmail2"
                type="email"
                value={parentEmail2}
                onChange={(e) => setParentEmail2(e.target.value)}
                placeholder="parent2@email.com"
                className="mt-2"
              />
            </div>
          </div>

          <div className="flex items-start space-x-2 mt-4">
            <Checkbox
              id="news"
              checked={receptionNews}
              onCheckedChange={(checked) => setReceptionNews(checked as boolean)}
            />
            <Label htmlFor="news" className="text-sm font-normal leading-relaxed">
              Je souhaite recevoir les actualités de Siimply
            </Label>
          </div>

          <div className="flex items-start space-x-2 mt-4">
            <Checkbox
              id="terms"
              checked={acceptTerms}
              onCheckedChange={(checked) => setAcceptTerms(checked as boolean)}
            />
            <Label htmlFor="terms" className="text-sm font-normal leading-relaxed">
              J'accepte de participer au test de la plateforme
              <span className="block text-xs text-muted-foreground mt-1">
                Le test est anonyme et sert à améliorer l'outil
              </span>
            </Label>
          </div>

          <Button type="submit" className="w-full mt-6" disabled={loading}>
            {loading ? "Création..." : "Créer mon compte"}
          </Button>

          <p className="text-center text-sm mt-4">
            Déjà un compte ?{" "}
            <Link to="/login" className="text-primary hover:underline">
              Se connecter
            </Link>
          </p>
        </form>
      </Card>
      </div>
      <ContactModal isOpen={showContactModal} onClose={() => setShowContactModal(false)} />
    </GeometricBackground>
  );
};

export default Signup;
