-- Modifier la durée d'expiration des email_confirmations à 15 minutes
ALTER TABLE public.email_confirmations 
ALTER COLUMN expires_at SET DEFAULT (now() + interval '15 minutes');

-- Modifier la durée d'expiration des parent_invitations à 15 minutes
ALTER TABLE public.parent_invitations 
ALTER COLUMN expires_at SET DEFAULT (now() + interval '15 minutes');

-- Créer la table pending_signups pour stocker temporairement les données chiffrées
CREATE TABLE public.pending_signups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE,
  token UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
  encrypted_data TEXT NOT NULL,
  parent_emails_encrypted TEXT,
  reception_news BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  expires_at TIMESTAMPTZ DEFAULT (now() + interval '15 minutes')
);

-- Activer RLS sur pending_signups sans ajouter de policies
-- Cela bloque tous les accès client, seul le service role pourra accéder
ALTER TABLE public.pending_signups ENABLE ROW LEVEL SECURITY;