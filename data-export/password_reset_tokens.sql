-- ============================================================================
-- BACKUP TABLE: password_reset_tokens
-- Date: 2026-01-16
-- Nombre de lignes: 8
-- Description: Tokens de réinitialisation de mot de passe (temporaires, expiration 15 min)
-- ============================================================================

-- ============================================================================
-- 1. SUPPRESSION DE LA TABLE EXISTANTE
-- ============================================================================
DROP TABLE IF EXISTS password_reset_tokens CASCADE;

-- ============================================================================
-- 2. CRÉATION DE LA TABLE
-- ============================================================================
CREATE TABLE password_reset_tokens (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    email text NOT NULL,
    token uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + '00:15:00'::interval),
    used_at timestamp with time zone,
    
    -- Primary Key
    CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id),
    
    -- Unique Constraints
    CONSTRAINT password_reset_tokens_token_key UNIQUE (token)
);

-- ============================================================================
-- 3. CLÉS ÉTRANGÈRES
-- ============================================================================
-- Aucune clé étrangère sur cette table

-- ============================================================================
-- 4. INDEX
-- ============================================================================
CREATE INDEX idx_password_reset_tokens_token ON password_reset_tokens USING btree (token);

-- ============================================================================
-- 5. ROW LEVEL SECURITY
-- ============================================================================
ALTER TABLE password_reset_tokens ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 6. POLICIES RLS
-- ============================================================================
-- Policy: Service role only - no direct access (bloque tout accès direct)
CREATE POLICY "Service role only - no direct access" 
    ON password_reset_tokens 
    FOR ALL 
    TO public 
    USING (false);

-- ============================================================================
-- 7. TRIGGERS
-- ============================================================================
-- Aucun trigger sur cette table

-- ============================================================================
-- 8. DONNÉES (8 lignes)
-- ============================================================================
INSERT INTO password_reset_tokens (id, user_id, email, token, created_at, expires_at, used_at) VALUES
('9cc3882b-3f66-4852-a1a4-958c054607fd', '76aa57e8-931b-4c15-b35a-9212685c370d', 'david1972.simonutti@gmail.com', 'c23ada93-65c7-4161-b722-56073dbb5598', '2025-12-03 09:11:38.694406+00', '2025-12-03 09:26:38.694406+00', '2025-12-03 09:12:09.958+00'),
('810f430e-e644-49fc-93bd-9249e5268504', 'e732120d-bb2d-4671-840d-2f74213bf0cc', 'raphael@siimply.fr', 'e08aae94-7d06-41f7-b026-0a7667d3613a', '2025-12-20 08:46:59.609756+00', '2025-12-20 09:01:59.609756+00', '2025-12-20 08:49:08.044+00'),
('6548b411-25c3-4e51-8de5-a965d28cc6e4', '4e06d5d1-ad17-4973-9ffd-90ee0e9b322a', 'lyfpay0@gmail.com', '0d05a083-46c5-430d-b4b9-36471ff36efc', '2025-12-22 17:18:45.694435+00', '2025-12-22 17:33:45.694435+00', '2025-12-22 17:19:02.719+00'),
('2bf6a150-41af-4239-ae43-ba145a93f0f6', 'e1c7b243-a450-46a2-b322-2ae25c42a139', 'raphael.stagetoussaint@gmail.com', '3ae2acfc-b399-4054-b991-0ee6664fbf22', '2025-12-23 21:07:46.193551+00', '2025-12-23 21:22:46.193551+00', NULL),
('a4cd1cd3-2576-4be4-91bf-75f69bb92880', 'e732120d-bb2d-4671-840d-2f74213bf0cc', 'raphael@siimply.fr', '82d5a1db-d5a8-40b0-9c7b-e7821d65c87a', '2025-12-27 10:08:29.550051+00', '2025-12-27 10:23:29.550051+00', '2025-12-27 10:08:58.379+00');

INSERT INTO password_reset_tokens (id, user_id, email, token, created_at, expires_at, used_at) VALUES
('6abd3bd3-e757-45d7-83fa-0a2f2d6501a7', '4e06d5d1-ad17-4973-9ffd-90ee0e9b322a', 'lyfpay0@gmail.com', 'b89551cf-b351-498c-a552-c61dbba7ad6a', '2025-12-29 19:50:56.802058+00', '2025-12-29 20:05:56.802058+00', '2025-12-29 19:53:37.846+00'),
('cebd9aa2-3dbd-446c-a008-8df308726cb3', '31fca5c9-e001-4fda-920f-9bfb90451d84', 'louisesoistier@icloud.com', '0bcb14fa-7949-483e-84ea-b8b7591f14e9', '2026-01-06 18:07:34.618718+00', '2026-01-06 18:22:34.618718+00', '2026-01-06 18:08:40.125+00'),
('9a4038eb-ed3a-4d4e-a4f5-4071a392531a', 'b7513248-38c8-47fd-8a62-3f938316f9ad', 'simonutti.raphael2003@gmail.com', '0cf5d132-22e1-4e7b-abb3-27a8d8f35c9e', '2026-01-12 18:21:49.39858+00', '2026-01-12 18:36:49.39858+00', '2026-01-12 18:26:05.142+00');

-- ============================================================================
-- 9. SÉQUENCES
-- ============================================================================
-- Aucune séquence (utilise gen_random_uuid() pour l'ID)

-- ============================================================================
-- FIN DU BACKUP
-- ============================================================================

