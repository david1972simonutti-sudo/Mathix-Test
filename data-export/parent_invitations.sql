-- ============================================================================
-- BACKUP SQL COMPLET : parent_invitations
-- Date de génération : 2026-01-16
-- Nombre de lignes : 15
-- ============================================================================

-- ============================================================================
-- 1. SUPPRESSION TABLE EXISTANTE
-- ============================================================================
DROP TABLE IF EXISTS parent_invitations CASCADE;

-- ============================================================================
-- 2. CREATE TABLE
-- ============================================================================
CREATE TABLE public.parent_invitations (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    eleve_user_id UUID NOT NULL,
    parent_email TEXT NOT NULL,
    token UUID NOT NULL DEFAULT gen_random_uuid(),
    status TEXT DEFAULT 'pending'::text,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    expires_at TIMESTAMP WITH TIME ZONE DEFAULT (now() + '7 days'::interval),
    
    -- Primary Key
    CONSTRAINT parent_invitations_pkey PRIMARY KEY (id),
    
    -- Unique Constraints
    CONSTRAINT parent_invitations_token_key UNIQUE (token)
);

-- ============================================================================
-- 3. FOREIGN KEYS
-- ============================================================================
-- Aucune foreign key définie

-- ============================================================================
-- 4. INDEX
-- ============================================================================
-- Index primaire et unique créés automatiquement via les contraintes

-- ============================================================================
-- 5. ROW LEVEL SECURITY
-- ============================================================================
ALTER TABLE parent_invitations ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 6. POLICIES RLS
-- ============================================================================

-- Policy: Admins can manage all invitations (ALL)
CREATE POLICY "Admins can manage all invitations"
ON public.parent_invitations
FOR ALL
TO public
USING (has_role(auth.uid(), 'administrateur'::app_role))
WITH CHECK (has_role(auth.uid(), 'administrateur'::app_role));

-- Policy: Eleves can create invitations (INSERT)
CREATE POLICY "Eleves can create invitations"
ON public.parent_invitations
FOR INSERT
TO public
WITH CHECK (auth.uid() = eleve_user_id);

-- Policy: Eleves can update their own invitations (UPDATE)
CREATE POLICY "Eleves can update their own invitations"
ON public.parent_invitations
FOR UPDATE
TO public
USING (auth.uid() = eleve_user_id);

-- Policy: Eleves can view their own invitations (SELECT)
CREATE POLICY "Eleves can view their own invitations"
ON public.parent_invitations
FOR SELECT
TO public
USING ((auth.uid() = eleve_user_id) OR has_role(auth.uid(), 'administrateur'::app_role));

-- Policy: Students can delete their own invitations (DELETE)
CREATE POLICY "Students can delete their own invitations"
ON public.parent_invitations
FOR DELETE
TO public
USING ((auth.uid() = eleve_user_id) OR has_role(auth.uid(), 'administrateur'::app_role));

-- ============================================================================
-- 7. TRIGGERS
-- ============================================================================
-- Aucun trigger défini

-- ============================================================================
-- 8. INSERTION DES DONNÉES (15 lignes)
-- ============================================================================

INSERT INTO parent_invitations (id, eleve_user_id, parent_email, token, status, created_at, expires_at) VALUES
('8b0d85f3-448d-4674-852b-45d4d30dd0dc', '76aa57e8-931b-4c15-b35a-9212685c370d', 'dsimonutti@gmail.com', 'c4d2042e-8518-482f-ae6f-b493b846d7ce', 'pending', '2025-12-02 09:39:05.718686+00', '2025-12-02 09:54:05.718686+00'),
('522c2088-2af8-48af-9be2-39d44c060584', '76aa57e8-931b-4c15-b35a-9212685c370d', 'dsimonutti@gmail.com', 'aed4bc2d-3ac9-4a5e-9818-62a9dd257e1b', 'pending', '2025-12-02 09:59:20.351909+00', '2025-12-02 10:14:20.351909+00'),
('53f3878e-1b8e-4b7c-9bf5-8a742cd1dafc', '76aa57e8-931b-4c15-b35a-9212685c370d', 'dsimonutti@gmail.com', '705d8041-d2cf-4958-9897-eebd8b3c7356', 'accepted', '2025-12-02 10:04:30.206659+00', '2025-12-02 10:19:30.206659+00'),
('418dddea-3c38-44f8-84e4-ab095824b979', '5dce013c-6cc6-4468-ac5f-ba850e1777b7', 'caca.pipi@gmail.com', 'b2e36afa-116f-4c40-bf5c-b2887638da4d', 'pending', '2025-12-15 14:25:20.823357+00', '2025-12-15 14:40:20.823357+00'),
('5c628b45-b5eb-4807-9094-7d2ed4772f0d', 'd2695df9-ba2a-46f4-a82d-227adbda6ebf', 'simonutti.raphael2003@gmail.com', 'd65c9433-1894-4e10-9700-1e654356cdab', 'accepted', '2025-12-20 09:07:15.208945+00', '2025-12-20 09:22:15.208945+00');

INSERT INTO parent_invitations (id, eleve_user_id, parent_email, token, status, created_at, expires_at) VALUES
('fc10b131-c358-41cf-94eb-c211a0786761', '411acd66-a493-445e-9823-ddb6a19d36ed', 'aauvillain@hotmail.com', '0f11e0e9-b44e-4689-920a-135d5b635f4c', 'pending', '2025-12-21 16:50:49.80679+00', '2025-12-21 17:05:49.80679+00'),
('1a3dd68d-347b-4eab-8b37-2967bc23925c', 'd2695df9-ba2a-46f4-a82d-227adbda6ebf', 'simonutti.raphael2003@gmail.com', '0d00a36b-dcb4-4bc1-8586-9dabfad32d12', 'accepted', '2025-12-22 17:21:27.027415+00', '2025-12-29 17:21:27.027415+00'),
('8b245405-15a8-4b47-a720-c8474f7dfac3', '306093a9-efc0-4370-a917-35ca259ae261', 'raphael.stagetoussaint@gmail.com', 'f38511c5-1935-4109-93d7-b5105bf9ab97', 'pending', '2025-12-22 21:20:09.172533+00', '2025-12-29 21:20:09.172533+00'),
('5de54a2c-c1f7-4e49-a05f-45171498c44b', '306093a9-efc0-4370-a917-35ca259ae261', 'raphael.stagetoussaint@siimply.fr', '3541a152-dccd-48b9-ba25-30958a68fced', 'pending', '2025-12-22 21:24:02.532531+00', '2025-12-29 21:24:02.532531+00'),
('1addb8de-8698-4554-b0da-a90e608df712', '306093a9-efc0-4370-a917-35ca259ae261', 'raphael.stagetoussaint@gmail.com', '782d3abc-90c1-4c93-9022-6dd1c8e1e1d1', 'accepted', '2025-12-22 21:24:38.803258+00', '2025-12-29 21:24:38.803258+00');

INSERT INTO parent_invitations (id, eleve_user_id, parent_email, token, status, created_at, expires_at) VALUES
('82a1838b-7912-4cb7-925f-d7370920d1a3', 'fde6d58e-d848-4be2-b3c7-0ab2800d1ff2', 'mlitel@orange.fr', '83ea835b-1b1e-4509-8c77-9dc22aa47def', 'pending', '2025-12-23 13:19:13.151491+00', '2025-12-30 13:19:13.151491+00'),
('819a1614-fd81-486f-b001-aec1d5b95b22', 'e3aef950-59ba-48c1-9399-05b1a2e0e77f', 'mariegardes@yahoo.com', '55050ee3-aa8d-4f2e-b112-c9691c85e7d5', 'pending', '2026-01-02 20:02:18.631629+00', '2026-01-09 20:02:18.631629+00'),
('468f2093-fc56-4281-99a7-301baac60ff3', '65195e36-9ec5-4764-89d1-c470a99e144c', 'christelle.maison@gmail.com', '84c3bb5a-553a-49f5-8719-06e8283044fe', 'accepted', '2026-01-03 11:12:13.578731+00', '2026-01-10 11:12:13.578731+00'),
('6a77045e-17e4-451b-9996-e22570b9a251', 'a5440184-5907-4db0-af34-021798491187', 'nicolasben@gmail.com', 'a97a08c6-1cdd-4689-afcc-7dae651eee42', 'pending', '2026-01-09 17:02:12.178362+00', '2026-01-16 17:02:12.178362+00'),
('8c2bc87e-3192-46f1-83ba-f1ed22d91c22', 'a5440184-5907-4db0-af34-021798491187', 'vanessa.krespine@l-ka-avocats.com', '4cee0d0e-2895-476e-b789-2d8141c3d61f', 'pending', '2026-01-09 17:02:12.178362+00', '2026-01-16 17:02:12.178362+00');

-- ============================================================================
-- 9. SEQUENCES
-- ============================================================================
-- Aucune séquence (id utilise gen_random_uuid())

-- ============================================================================
-- FIN DU BACKUP
-- ============================================================================

