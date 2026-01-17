-- ============================================
-- BACKUP TABLE: parent_eleve_relations
-- Date: 2026-01-16
-- Nombre de lignes: 5
-- ============================================

-- 1. DROP TABLE (si elle existe)
DROP TABLE IF EXISTS parent_eleve_relations CASCADE;

-- 2. CREATE TABLE
CREATE TABLE parent_eleve_relations (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    parent_user_id uuid NOT NULL,
    eleve_user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    
    -- Primary Key
    CONSTRAINT parent_eleve_relations_pkey PRIMARY KEY (id),
    
    -- Unique Constraints
    CONSTRAINT parent_eleve_relations_parent_user_id_eleve_user_id_key UNIQUE (parent_user_id, eleve_user_id)
);

-- 3. FOREIGN KEYS
-- Aucune clé étrangère définie

-- 4. INDEXES
-- (Les index pkey et unique sont créés automatiquement par les contraintes)

-- 5. ROW LEVEL SECURITY
ALTER TABLE parent_eleve_relations ENABLE ROW LEVEL SECURITY;

-- 6. POLICIES
CREATE POLICY "Admins can manage all relations" ON parent_eleve_relations
    FOR ALL
    USING (has_role(auth.uid(), 'administrateur'::app_role))
    WITH CHECK (has_role(auth.uid(), 'administrateur'::app_role));

CREATE POLICY "Students can delete their parent relations" ON parent_eleve_relations
    FOR DELETE
    USING ((auth.uid() = eleve_user_id) OR has_role(auth.uid(), 'administrateur'::app_role));

CREATE POLICY "Users can view their own relations" ON parent_eleve_relations
    FOR SELECT
    USING ((auth.uid() = parent_user_id) OR (auth.uid() = eleve_user_id) OR has_role(auth.uid(), 'administrateur'::app_role));

-- 7. TRIGGERS
-- Fonction trigger (doit exister avant le trigger)
CREATE OR REPLACE FUNCTION public.check_max_parents()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
BEGIN
    IF (SELECT COUNT(*) FROM parent_eleve_relations WHERE eleve_user_id = NEW.eleve_user_id) >= 2 THEN
        RAISE EXCEPTION 'Un élève ne peut avoir que 2 parents maximum';
    END IF;
    RETURN NEW;
END;
$$;

-- Trigger
CREATE TRIGGER enforce_max_parents 
    BEFORE INSERT ON parent_eleve_relations 
    FOR EACH ROW 
    EXECUTE FUNCTION check_max_parents();

-- 8. INSERT DATA (5 lignes)
INSERT INTO parent_eleve_relations (id, parent_user_id, eleve_user_id, created_at) VALUES
('459c61cd-4a4f-4192-876f-5205714a4956', '408b880f-1db3-4740-a09f-28fc07262101', '76aa57e8-931b-4c15-b35a-9212685c370d', '2025-12-02 10:06:08.184995+00'),
('d61aa9bf-5fd7-4239-91b6-a5d3785d8852', '537ee23d-3465-4a8c-8260-c4d5e70791ba', 'b7513248-38c8-47fd-8a62-3f938316f9ad', '2025-12-22 17:40:31.546085+00'),
('81378b2a-b9d6-4383-92ec-4625aabb9fb3', 'e1c7b243-a450-46a2-b322-2ae25c42a139', '306093a9-efc0-4370-a917-35ca259ae261', '2025-12-22 21:25:24.695935+00'),
('6113e694-405e-4d6a-b756-a6e264878c5d', 'e8e21bc2-2060-4ef3-a46c-d59dd7bf2271', '65195e36-9ec5-4764-89d1-c470a99e144c', '2026-01-03 11:14:27.30205+00'),
('e43152d2-a2e0-4c64-91cb-d05262afbdc9', 'b7513248-38c8-47fd-8a62-3f938316f9ad', 'd2695df9-ba2a-46f4-a82d-227adbda6ebf', '2026-01-12 18:57:46.679725+00');

-- 9. SEQUENCES
-- Pas de séquences (utilisation de gen_random_uuid() pour l'ID)

-- ============================================
-- FIN DU BACKUP
-- ============================================

