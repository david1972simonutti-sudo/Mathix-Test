-- ============================================================
-- BACKUP SQL : user_feedback
-- Date d'export : 2026-01-16
-- Nombre de lignes : 12
-- ============================================================

-- ============================================================
-- 1. SUPPRESSION DE LA TABLE EXISTANTE
-- ============================================================
DROP TABLE IF EXISTS user_feedback CASCADE;

-- ============================================================
-- 2. CREATION DE LA TABLE
-- ============================================================
CREATE TABLE public.user_feedback (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    csat_score integer NOT NULL,
    difficulty text,
    comment text,
    
    -- PRIMARY KEY
    CONSTRAINT user_feedback_pkey PRIMARY KEY (id)
);

-- ============================================================
-- 3. FOREIGN KEYS
-- ============================================================
-- Aucune foreign key définie

-- ============================================================
-- 4. INDEX
-- ============================================================
-- Note: L'index user_feedback_pkey est créé automatiquement avec la PRIMARY KEY

-- ============================================================
-- 5. ROW LEVEL SECURITY
-- ============================================================
ALTER TABLE public.user_feedback ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 6. POLICIES
-- ============================================================
CREATE POLICY "Users can insert their own feedback"
    ON public.user_feedback
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own feedback"
    ON public.user_feedback
    FOR SELECT
    USING (auth.uid() = user_id);

-- ============================================================
-- 7. TRIGGERS
-- ============================================================
-- Aucun trigger défini

-- ============================================================
-- 8. DONNEES (12 lignes)
-- ============================================================

-- Lot 1 (lignes 1-5)
INSERT INTO public.user_feedback (id, user_id, created_at, csat_score, difficulty, comment) VALUES
('6cea1fda-496d-4c8a-b384-e0401a4620e3', '76aa57e8-931b-4c15-b35a-9212685c370d', '2025-12-04 19:21:01.482371+00', 5, 'moyen', 'parfait pour mon niveau'),
('0ad9baee-4e5b-4dda-b0fd-30e437564fa1', '76aa57e8-931b-4c15-b35a-9212685c370d', '2025-12-05 18:47:56.518941+00', 1, NULL, NULL),
('9e1783dc-4bab-437a-95e2-90caca878911', '59e80fe2-208e-42ae-8ab2-e2d9adc663bc', '2025-12-06 12:27:51.87932+00', 3, 'moyen', 'azdz'),
('39b13bca-eecb-44f8-89fa-e3fe9a0fa3ad', '306093a9-efc0-4370-a917-35ca259ae261', '2025-12-08 08:41:55.020075+00', 5, 'moyen', 'ef'),
('c54139c5-41ee-4f43-9b20-e08c60d789ac', '255895dc-667d-4d27-a57f-5dfa2e131af0', '2025-12-12 18:22:39.929985+00', 3, 'facile', 'chk');

-- Lot 2 (lignes 6-10)
INSERT INTO public.user_feedback (id, user_id, created_at, csat_score, difficulty, comment) VALUES
('f55c7179-f78c-4787-8d7b-a03198ccf9ad', '76aa57e8-931b-4c15-b35a-9212685c370d', '2025-12-14 07:41:07.403739+00', 1, 'moyen', 'probleme sur la generation d''exercice'),
('b0229b51-adbe-4b2a-b28e-42d1067f7936', '76aa57e8-931b-4c15-b35a-9212685c370d', '2025-12-16 13:31:40.831218+00', 3, 'moyen', 'Merci ça change la vie'),
('a0e9e2e0-c395-433a-b5a7-ed3499f1a308', '306093a9-efc0-4370-a917-35ca259ae261', '2025-12-20 11:34:52.883427+00', 5, NULL, NULL),
('dffadae7-a65a-4dbc-8ff9-0442225a05e5', '255895dc-667d-4d27-a57f-5dfa2e131af0', '2025-12-20 15:21:13.635021+00', 3, NULL, NULL),
('b7742d70-d0cf-432d-96b0-a1b8a2985fee', 'e3aef950-59ba-48c1-9399-05b1a2e0e77f', '2026-01-02 20:05:48.641269+00', 5, NULL, NULL);

-- Lot 3 (lignes 11-12)
INSERT INTO public.user_feedback (id, user_id, created_at, csat_score, difficulty, comment) VALUES
('162547b9-4f78-4c9a-97b0-79ef0bbd069f', '306093a9-efc0-4370-a917-35ca259ae261', '2026-01-12 16:28:57.023064+00', 3, NULL, NULL),
('dd453bda-9545-4428-8dd9-e7d3c65cd679', 'b7513248-38c8-47fd-8a62-3f938316f9ad', '2026-01-13 15:09:22.523642+00', 1, NULL, 'Attention bug pour les parents, ils peuvent cliquer sur l''historique et cela affiche quelque chose , sur l''écran principal a droite on voit 3 des 6 competences , normal ?');

-- ============================================================
-- 9. SEQUENCES
-- ============================================================
-- Aucune séquence (id utilise gen_random_uuid())

-- ============================================================
-- FIN DU BACKUP
-- ============================================================

