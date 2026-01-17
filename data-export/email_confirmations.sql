-- ============================================================================
-- BACKUP TABLE: email_confirmations
-- Date: 2026-01-16
-- Nombre de lignes: 0
-- Description: Table de confirmation d'email pour les inscriptions
-- ============================================================================

-- ============================================================================
-- 1. SUPPRESSION TABLE EXISTANTE
-- ============================================================================
DROP TABLE IF EXISTS public.email_confirmations CASCADE;

-- ============================================================================
-- 2. CRÉATION DE LA TABLE
-- ============================================================================
CREATE TABLE public.email_confirmations (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    email text NOT NULL,
    token uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    confirmed_at timestamp with time zone,
    expires_at timestamp with time zone NOT NULL DEFAULT (now() + '00:15:00'::interval),
    
    -- Primary Key
    CONSTRAINT email_confirmations_pkey PRIMARY KEY (id),
    
    -- Unique Constraints
    CONSTRAINT email_confirmations_token_key UNIQUE (token)
);

-- ============================================================================
-- 3. FOREIGN KEYS
-- ============================================================================
-- Aucune clé étrangère sur cette table

-- ============================================================================
-- 4. INDEX
-- ============================================================================
-- Index automatiques créés par PRIMARY KEY et UNIQUE:
-- - email_confirmations_pkey (btree sur id)
-- - email_confirmations_token_key (btree sur token)

-- ============================================================================
-- 5. ROW LEVEL SECURITY
-- ============================================================================
ALTER TABLE public.email_confirmations ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 6. POLICIES
-- ============================================================================
-- Policy: Service role only - no direct access
-- Cette table ne peut être manipulée que par le service_role (edge functions)
CREATE POLICY "Service role only - no direct access"
    ON public.email_confirmations
    FOR ALL
    TO public
    USING (false);

-- ============================================================================
-- 7. TRIGGERS
-- ============================================================================
-- Aucun trigger sur cette table

-- ============================================================================
-- 8. DONNÉES
-- ============================================================================
-- Table vide - aucune donnée à insérer
-- (Les confirmations d'email sont temporaires et supprimées après utilisation)

-- ============================================================================
-- 9. SÉQUENCES
-- ============================================================================
-- Aucune séquence (utilisation de gen_random_uuid() pour les IDs)

-- ============================================================================
-- FIN DU BACKUP
-- ============================================================================

