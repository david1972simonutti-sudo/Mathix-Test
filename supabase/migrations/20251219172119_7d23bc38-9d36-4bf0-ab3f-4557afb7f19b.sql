-- Révoquer tous les privilèges du rôle anon sur les tables sensibles
-- Cela ajoute une couche de sécurité supplémentaire en plus des RLS policies

-- Table profiles (données personnelles des élèves)
REVOKE ALL ON public.profiles FROM anon;

-- Table email_confirmations (tokens de confirmation d'email)
REVOKE ALL ON public.email_confirmations FROM anon;

-- Table pending_signups (données d'inscription chiffrées)
REVOKE ALL ON public.pending_signups FROM anon;

-- Table password_reset_tokens (tokens de réinitialisation de mot de passe)
REVOKE ALL ON public.password_reset_tokens FROM anon;