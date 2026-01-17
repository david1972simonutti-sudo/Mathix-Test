-- Activer RLS sur email_confirmations (utilisé uniquement par edge functions avec service role)
ALTER TABLE public.email_confirmations ENABLE ROW LEVEL SECURITY;

-- Politique restrictive : personne ne peut accéder directement (seul le service role bypasse RLS)
CREATE POLICY "Service role only - no direct access" 
ON public.email_confirmations 
FOR ALL 
USING (false);

-- Activer RLS sur password_reset_tokens (utilisé uniquement par edge functions avec service role)
ALTER TABLE public.password_reset_tokens ENABLE ROW LEVEL SECURITY;

-- Politique restrictive : personne ne peut accéder directement (seul le service role bypasse RLS)
CREATE POLICY "Service role only - no direct access" 
ON public.password_reset_tokens 
FOR ALL 
USING (false);