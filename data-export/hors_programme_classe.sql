-- ============================================================
-- TABLE: hors_programme_classe
-- Export date: 2026-01-16
-- Total rows: 50
-- ============================================================

-- ============================================================
-- SECTION 1: STRUCTURE
-- ============================================================

DROP TABLE IF EXISTS public.hors_programme_classe CASCADE;

CREATE TABLE public.hors_programme_classe (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    classe text NOT NULL,
    notion text NOT NULL,
    niveau_cible text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT hors_programme_classe_pkey PRIMARY KEY (id)
);

-- ============================================================
-- SECTION 2: FOREIGN KEYS
-- ============================================================
-- (Aucune foreign key pour cette table)

-- ============================================================
-- SECTION 3: INDEX
-- ============================================================
-- L'index pkey est cree automatiquement via la contrainte PRIMARY KEY
-- CREATE UNIQUE INDEX hors_programme_classe_pkey ON public.hors_programme_classe USING btree (id);

-- ============================================================
-- SECTION 4: ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE public.hors_programme_classe ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- SECTION 5: POLICIES
-- ============================================================

CREATE POLICY "Public read access"
    ON public.hors_programme_classe
    FOR SELECT
    TO public
    USING (true);

-- ============================================================
-- SECTION 6: TRIGGERS
-- ============================================================
-- (Aucun trigger pour cette table)

-- ============================================================
-- SECTION 7: DONNEES (50 lignes)
-- ============================================================

-- Classe: Première (13 lignes)
INSERT INTO public.hors_programme_classe (id, classe, notion, niveau_cible, created_at) VALUES
    ('f98d71be-f498-4419-a43e-3f50ec96946d', 'Première', 'Asymptotes', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('40669537-fd79-41ca-8bb3-31818c5faac3', 'Première', 'Calcul intégral', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('364250dd-e051-47af-9a66-821a05e9faed', 'Première', 'Continuité', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('a1f371ae-ddc9-4f76-8919-effc0846a1d7', 'Première', 'Croissances comparées', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('2bbf1cff-698e-4cd1-b4d7-98bf42558339', 'Première', 'Équations différentielles', 'Terminale', '2026-01-10 20:22:57.242984+00');

INSERT INTO public.hors_programme_classe (id, classe, notion, niveau_cible, created_at) VALUES
    ('11d1ab48-18ea-439d-b3a6-6a9e5757aef9', 'Première', 'Géométrie dans l''espace vecteurs', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('0432c079-128c-46fe-8f21-a0f1225c1801', 'Première', 'Intervalle de confiance', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('6ad47aef-3108-4beb-9784-be576f566b4a', 'Première', 'Limites de fonctions', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('8accd0fc-3baf-40e4-9dfb-5e92a428f8cd', 'Première', 'Logarithme népérien', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('65f4f3dd-b20e-4513-b61e-a9a438a8a7f2', 'Première', 'Loi normale', 'Terminale', '2026-01-10 20:22:57.242984+00');

INSERT INTO public.hors_programme_classe (id, classe, notion, niveau_cible, created_at) VALUES
    ('6262af73-8a55-4781-829c-11938c9746c4', 'Première', 'Nombres complexes', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('9aa0d087-ac3f-4213-89aa-cbb7788b6b10', 'Première', 'Plans et droites dans l''espace', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('3545e76f-7fd8-4e80-9013-44350e7d33a6', 'Première', 'Primitives', 'Terminale', '2026-01-10 20:22:57.242984+00');

-- Classe: Seconde (22 lignes)
INSERT INTO public.hors_programme_classe (id, classe, notion, niveau_cible, created_at) VALUES
    ('b10efc7e-9aec-4b4a-b6d3-019305a96a01', 'Seconde', 'Asymptotes', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('487d56ba-5e4a-4e6d-8c1a-02d1bf158685', 'Seconde', 'Calcul intégral', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('0fc28407-9e3b-4577-9d0f-1e32cd7247fa', 'Seconde', 'Continuité', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('bf9255e0-e8af-473e-90a3-e2106623a194', 'Seconde', 'Dérivation', 'Première', '2026-01-10 20:22:57.242984+00'),
    ('159f12c3-9f9e-4e35-b691-2d434b0e7f3a', 'Seconde', 'Équations différentielles', 'Terminale', '2026-01-10 20:22:57.242984+00');

INSERT INTO public.hors_programme_classe (id, classe, notion, niveau_cible, created_at) VALUES
    ('8e739dbe-efd6-492d-aff7-09bce7effdb4', 'Seconde', 'Fonction dérivée', 'Première', '2026-01-10 20:22:57.242984+00'),
    ('611dd8ca-ab5f-4e7f-b562-3c251adbb02b', 'Seconde', 'Fonction exponentielle', 'Première', '2026-01-10 20:22:57.242984+00'),
    ('439955da-3e60-4bec-ace9-9837beb74fe9', 'Seconde', 'Limites de fonctions', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('1ea1a755-31cb-4d7e-a464-6b14326f44a2', 'Seconde', 'Logarithme népérien', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('96b1cd4b-7080-449c-b034-351d175f2b09', 'Seconde', 'Loi normale', 'Terminale', '2026-01-10 20:22:57.242984+00');

INSERT INTO public.hors_programme_classe (id, classe, notion, niveau_cible, created_at) VALUES
    ('a4e3129d-6c42-432d-a422-e4dd49b4fa35', 'Seconde', 'Nombre dérivé', 'Première', '2026-01-10 20:22:57.242984+00'),
    ('42c5f909-e66d-480f-a25f-ba3cdc4963d9', 'Seconde', 'Nombres complexes', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('6cf0ea0a-a4d0-4034-943b-828a334063d2', 'Seconde', 'Primitives', 'Terminale', '2026-01-10 20:22:57.242984+00'),
    ('7f6c8337-a482-41b1-aa35-1663d67a7a0d', 'Seconde', 'Probabilités conditionnelles', 'Première', '2026-01-10 20:22:57.242984+00'),
    ('3e571562-c9ec-4066-967b-81b1079193b9', 'Seconde', 'Produit scalaire', 'Première', '2026-01-10 20:22:57.242984+00');

INSERT INTO public.hors_programme_classe (id, classe, notion, niveau_cible, created_at) VALUES
    ('bf1de336-1bb2-43fd-a9b4-3bed536260cd', 'Seconde', 'Récurrence', 'Première', '2026-01-10 20:22:57.242984+00'),
    ('91e82e69-07fd-428b-a271-715a01f3a852', 'Seconde', 'Second degré discriminant', 'Première', '2026-01-10 20:22:57.242984+00'),
    ('4d328414-9680-4cc9-b66a-c2934f8d1595', 'Seconde', 'Suite arithmétique', 'Première', '2026-01-10 20:22:57.242984+00'),
    ('ce705c40-406a-4e24-9974-77c1c2951492', 'Seconde', 'Suite géométrique', 'Première', '2026-01-10 20:22:57.242984+00'),
    ('3ab4f13d-841c-4b5f-8995-e7fd908ee544', 'Seconde', 'Suites numériques', 'Première', '2026-01-10 20:22:57.242984+00');

INSERT INTO public.hors_programme_classe (id, classe, notion, niveau_cible, created_at) VALUES
    ('368fad6c-2bff-424a-a5f0-383bd2842376', 'Seconde', 'Tangente à une courbe', 'Première', '2026-01-10 20:22:57.242984+00'),
    ('674aca49-3c5b-4c34-a4a3-508acc128d89', 'Seconde', 'Trigonométrie cercle trigonométrique', 'Première', '2026-01-10 20:22:57.242984+00');

-- Classe: Terminale (15 lignes)
INSERT INTO public.hors_programme_classe (id, classe, notion, niveau_cible, created_at) VALUES
    ('1f7af9ab-5e99-4f61-ad2b-4793c5a7a1db', 'Terminale', 'Calcul matriciel avancé', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('08372ba3-0f0d-4639-85d0-0aeb0984bf69', 'Terminale', 'Dérivées partielles', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('2ae97a95-5ac2-4512-ad35-64a9b869f422', 'Terminale', 'Déterminants', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('92de94fc-f172-4d7d-b1d0-b39249a841ed', 'Terminale', 'Développements limités', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('42d35fea-c1fc-46dd-9b48-cd7be4833339', 'Terminale', 'Équations différentielles ordre 2', 'Prépa/Université', '2026-01-10 20:22:57.242984+00');

INSERT INTO public.hors_programme_classe (id, classe, notion, niveau_cible, created_at) VALUES
    ('f41a3900-8bfa-4bee-86cc-0fbf36b6c970', 'Terminale', 'Espaces vectoriels', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('71ad44af-73fb-41be-a201-6a06e9ea1d67', 'Terminale', 'Fonctions de plusieurs variables', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('ae544c4e-3d5b-4068-a7f9-f10e33db62c5', 'Terminale', 'Formule de Taylor', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('77c2a9ba-00a9-4a4d-b059-c0d243719046', 'Terminale', 'Intégrales doubles', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('b0f58877-fd52-4398-8506-146f1a1e1e4b', 'Terminale', 'Intégrales généralisées', 'Prépa/Université', '2026-01-10 20:22:57.242984+00');

INSERT INTO public.hors_programme_classe (id, classe, notion, niveau_cible, created_at) VALUES
    ('4b599b7d-6844-47f5-8941-b40cff280b4c', 'Terminale', 'Intégrales triples', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('4e79edc0-def1-4397-bb12-f241225b0afb', 'Terminale', 'Séries entières', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('7ad7fec4-0ae2-4799-8b36-9cf1b2c0860b', 'Terminale', 'Séries numériques', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('a687d20e-07e4-4557-839d-6d0f5c89962b', 'Terminale', 'Topologie', 'Prépa/Université', '2026-01-10 20:22:57.242984+00'),
    ('4d48701a-2e3e-48d8-89f5-8d1d7cd28443', 'Terminale', 'Valeurs propres et vecteurs propres', 'Prépa/Université', '2026-01-10 20:22:57.242984+00');

-- ============================================================
-- SECTION 8: SEQUENCES
-- ============================================================
-- (Pas de sequence pour cette table - id est uuid avec gen_random_uuid())

-- ============================================================
-- FIN DE L'EXPORT
-- ============================================================

