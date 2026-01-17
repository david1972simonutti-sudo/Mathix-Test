import { useState, useEffect } from "react";
import { useNavigate, Link } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card } from "@/components/ui/card";
import { Checkbox } from "@/components/ui/checkbox";
import { toast } from "sonner";
import { Lock } from "lucide-react";
import Header from "@/components/Header";
import GeometricBackground from "@/components/GeometricBackground";
import ContactModal from "@/components/ContactModal";

// Rate limiting constants
const MAX_LOGIN_ATTEMPTS = 5;
const LOCKOUT_DURATION_MS = 15 * 60 * 1000; // 15 minutes
const STORAGE_KEY = 'siimply_login_attempts';

interface LoginAttempts {
  count: number;
  firstAttemptTime: number;
  lockedUntil: number | null;
}

const Login = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [rememberMe, setRememberMe] = useState(false);
  const [loading, setLoading] = useState(false);
  const [showContactModal, setShowContactModal] = useState(false);
  const [isLockedOut, setIsLockedOut] = useState(false);
  const [lockoutRemainingTime, setLockoutRemainingTime] = useState(0);

  // Get login attempts from localStorage
  const getLoginAttempts = (): LoginAttempts => {
    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      if (stored) {
        return JSON.parse(stored);
      }
    } catch {
      // Ignore parse errors
    }
    return { count: 0, firstAttemptTime: 0, lockedUntil: null };
  };

  // Record a failed attempt
  const recordFailedAttempt = () => {
    const attempts = getLoginAttempts();
    const now = Date.now();

    // Reset if first attempt was more than lockout duration ago
    if (attempts.firstAttemptTime && now - attempts.firstAttemptTime > LOCKOUT_DURATION_MS) {
      attempts.count = 0;
      attempts.firstAttemptTime = 0;
      attempts.lockedUntil = null;
    }

    attempts.count += 1;
    if (attempts.count === 1) {
      attempts.firstAttemptTime = now;
    }

    // Lock out after max attempts
    if (attempts.count >= MAX_LOGIN_ATTEMPTS) {
      attempts.lockedUntil = now + LOCKOUT_DURATION_MS;
    }

    localStorage.setItem(STORAGE_KEY, JSON.stringify(attempts));
    checkLockout();
  };

  // Reset attempts after successful login
  const resetAttempts = () => {
    localStorage.removeItem(STORAGE_KEY);
    setIsLockedOut(false);
    setLockoutRemainingTime(0);
  };

  // Check if user is locked out
  const checkLockout = () => {
    const attempts = getLoginAttempts();
    const now = Date.now();

    if (attempts.lockedUntil && attempts.lockedUntil > now) {
      setIsLockedOut(true);
      setLockoutRemainingTime(Math.ceil((attempts.lockedUntil - now) / 1000));
    } else if (attempts.lockedUntil && attempts.lockedUntil <= now) {
      // Lockout expired, reset
      resetAttempts();
    } else {
      setIsLockedOut(false);
      setLockoutRemainingTime(0);
    }
  };

  // Check lockout on mount and update timer
  useEffect(() => {
    checkLockout();

    const interval = setInterval(() => {
      checkLockout();
    }, 1000);

    return () => clearInterval(interval);
  }, []);

  // Format remaining time as mm:ss
  const formatRemainingTime = (seconds: number): string => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();

    // Check if locked out
    if (isLockedOut) {
      toast.error("Trop de tentatives. Veuillez patienter.");
      return;
    }

    setLoading(true);

    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) throw error;

      // Reset attempts on successful login
      resetAttempts();

      // Vérifier le rôle de l'utilisateur
      const { data: roleData } = await supabase
        .from('user_roles')
        .select('role')
        .eq('user_id', data.user.id)
        .single();

      toast.success("Connexion réussie !");
      
      // Redirection selon le rôle
      if (roleData?.role === 'parent') {
        navigate("/parents");
      } else {
        navigate("/");
      }
    } catch (error: any) {
      // Record failed attempt
      recordFailedAttempt();
      toast.error(error.message || "Erreur de connexion");
    } finally {
      setLoading(false);
    }
  };

  return (
    <GeometricBackground className="min-h-screen" onContactClick={() => setShowContactModal(true)}>
      <Header showAuthButton={false} />
      <div className="flex items-center justify-center px-4 py-8 min-h-[calc(100vh-80px)]">
        <Card className="w-full max-w-md p-8 shadow-lg rounded-xl bg-white/95 backdrop-blur-sm">

        <h2 className="text-2xl font-semibold mb-8">Se connecter</h2>

        {/* Lockout warning */}
        {isLockedOut && (
          <div className="mb-6 p-4 bg-destructive/10 border border-destructive/20 rounded-lg flex items-center gap-3">
            <Lock className="h-5 w-5 text-destructive flex-shrink-0" />
            <div>
              <p className="text-sm font-medium text-destructive">Trop de tentatives de connexion</p>
              <p className="text-sm text-destructive/80">
                Réessayez dans {formatRemainingTime(lockoutRemainingTime)}
              </p>
            </div>
          </div>
        )}

        <form onSubmit={handleLogin} className="space-y-4">
          <div>
            <Label htmlFor="email">Email *</Label>
            <Input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              disabled={isLockedOut}
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
              disabled={isLockedOut}
              className="mt-2"
            />
          </div>

          <div className="flex items-center space-x-2 mt-2">
            <Checkbox
              id="remember"
              checked={rememberMe}
              onCheckedChange={(checked) => setRememberMe(checked as boolean)}
            />
            <Label htmlFor="remember" className="text-sm font-normal">
              Se souvenir de moi
            </Label>
          </div>

          <Link
            to="/forgot-password"
            className="block text-sm text-primary hover:underline mt-2"
          >
            Mot de passe oublié ?
          </Link>

          <Button type="submit" className="w-full mt-6" disabled={loading || isLockedOut}>
            {loading ? "Connexion..." : isLockedOut ? "Connexion bloquée" : "Se connecter"}
          </Button>

          <p className="text-center text-sm mt-4">
            Pas encore de compte ?{" "}
            <Link to="/signup" className="text-primary hover:underline">
              S'inscrire
            </Link>
          </p>
        </form>
      </Card>
      </div>
      <ContactModal isOpen={showContactModal} onClose={() => setShowContactModal(false)} />
    </GeometricBackground>
  );
};

export default Login;
