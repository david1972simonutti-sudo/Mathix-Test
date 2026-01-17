-- Table pour stocker les tokens de réinitialisation de mot de passe
CREATE TABLE public.password_reset_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  email TEXT NOT NULL,
  token UUID NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  created_at TIMESTAMPTZ DEFAULT now(),
  expires_at TIMESTAMPTZ DEFAULT (now() + interval '15 minutes'),
  used_at TIMESTAMPTZ DEFAULT NULL
);

-- Index pour recherche rapide par token
CREATE INDEX idx_password_reset_tokens_token ON password_reset_tokens(token);

-- RLS activé mais pas de policies publiques - accès uniquement via service role
ALTER TABLE password_reset_tokens ENABLE ROW LEVEL SECURITY;