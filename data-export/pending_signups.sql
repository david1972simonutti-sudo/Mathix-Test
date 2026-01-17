-- ============================================
-- BACKUP TABLE: pending_signups
-- Date: 2026-01-16
-- Rows: 0
-- ============================================

-- 1. DROP existing table
DROP TABLE IF EXISTS pending_signups CASCADE;

-- 2. CREATE TABLE
CREATE TABLE pending_signups (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    token uuid NOT NULL DEFAULT gen_random_uuid(),
    encrypted_data text NOT NULL,
    parent_emails_encrypted text,
    reception_news boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + '00:15:00'::interval),
    
    -- Primary Key
    CONSTRAINT pending_signups_pkey PRIMARY KEY (id),
    
    -- Unique constraints
    CONSTRAINT pending_signups_user_id_key UNIQUE (user_id),
    CONSTRAINT pending_signups_token_key UNIQUE (token)
);

-- 3. FOREIGN KEYS
-- Aucune clé étrangère

-- 4. INDEXES
-- Les indexes UNIQUE sont déjà créés par les contraintes ci-dessus
-- pending_signups_pkey (id)
-- pending_signups_user_id_key (user_id)
-- pending_signups_token_key (token)

-- 5. ENABLE ROW LEVEL SECURITY
ALTER TABLE pending_signups ENABLE ROW LEVEL SECURITY;

-- 6. RLS POLICIES
CREATE POLICY "Service role only - no direct access"
ON pending_signups
FOR ALL
TO public
USING (false);

-- 7. TRIGGERS
-- Aucun trigger sur cette table

-- 8. DATA INSERT
-- Table vide - aucune donnée à insérer

-- 9. SEQUENCES
-- Aucune séquence (utilise gen_random_uuid())

-- ============================================
-- END OF BACKUP
-- ============================================

