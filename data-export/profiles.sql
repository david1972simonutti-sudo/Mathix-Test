-- ============================================================
-- TABLE: profiles
-- Export date: 2026-01-16
-- Total rows: 58
-- ============================================================

-- ============================================================
-- 1. DROP TABLE (si existante)
-- ============================================================
DROP TABLE IF EXISTS public.profiles CASCADE;

-- ============================================================
-- 2. CREATE TABLE
-- ============================================================
CREATE TABLE public.profiles (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    email text NOT NULL,
    nom text NOT NULL,
    prenom text NOT NULL,
    classe text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    paiement_valide boolean DEFAULT false,
    date_paiement timestamp with time zone,
    premiere_utilisation_chat timestamp with time zone,
    reception_news boolean DEFAULT false,
    has_seen_welcome_popup boolean DEFAULT false,
    
    CONSTRAINT profiles_pkey PRIMARY KEY (id),
    CONSTRAINT profiles_user_id_key UNIQUE (user_id),
    CONSTRAINT profiles_email_unique UNIQUE (email)
);

-- ============================================================
-- 3. FOREIGN KEYS
-- ============================================================
-- Aucune foreign key définie

-- ============================================================
-- 4. INDEX
-- ============================================================
-- Les index suivants sont créés automatiquement par les contraintes :
-- - profiles_pkey (PRIMARY KEY sur id)
-- - profiles_user_id_key (UNIQUE sur user_id)
-- - profiles_email_unique (UNIQUE sur email)

-- ============================================================
-- 5. ROW LEVEL SECURITY
-- ============================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 6. POLICIES (5 policies)
-- ============================================================
CREATE POLICY "Parents can view their children's profiles"
    ON public.profiles
    FOR SELECT
    USING (EXISTS ( SELECT 1
       FROM parent_eleve_relations
      WHERE ((parent_eleve_relations.parent_user_id = auth.uid()) AND (parent_eleve_relations.eleve_user_id = profiles.user_id))));

CREATE POLICY "Users can insert their own profile"
    ON public.profiles
    FOR INSERT
    WITH CHECK (((auth.uid())::text = (user_id)::text));

CREATE POLICY "Users can update their own profile"
    ON public.profiles
    FOR UPDATE
    USING (((auth.uid())::text = (user_id)::text));

CREATE POLICY "Users can update their payment info"
    ON public.profiles
    FOR UPDATE
    USING (((auth.uid())::text = (user_id)::text))
    WITH CHECK (((auth.uid())::text = (user_id)::text));

CREATE POLICY "Users can view their own profile"
    ON public.profiles
    FOR SELECT
    USING (((auth.uid())::text = (user_id)::text));

-- ============================================================
-- 7. TRIGGERS
-- ============================================================
-- Aucun trigger défini sur cette table

-- ============================================================
-- 8. DATA (58 lignes par lots de 5)
-- ============================================================
INSERT INTO public.profiles (id, user_id, email, nom, prenom, classe, created_at, paiement_valide, date_paiement, premiere_utilisation_chat, reception_news, has_seen_welcome_popup) VALUES
    ('30655cf4-f857-4d1e-a343-80b651546e7c', 'b7513248-38c8-47fd-8a62-3f938316f9ad', 'simonutti.raphael2003@gmail.com', 'Simonutti', 'Raphaël', 'terminale', '2025-10-13 15:15:27.697373+00', false, NULL, NULL, false, true),
    ('7c424839-5967-415b-81d5-3566a2bc153e', 'b1e14b06-14f9-4757-a9f6-d7fb60998590', 'kedesshoes@gmail.com', 'Test-0', 'Test0', 'terminale', '2025-10-13 20:56:51.082253+00', false, NULL, NULL, false, false),
    ('5d2fa1a9-ecc8-423a-9efe-c8945ebb5594', '306093a9-efc0-4370-a917-35ca259ae261', 'kedeshsoes@gmail.com', 'Test-0', 'Test0', 'terminale', '2025-10-13 21:28:18.688303+00', false, NULL, '2025-12-04 13:08:31.711+00', false, true),
    ('e0df6d70-7269-4ab3-8e96-e414a5b086a3', '2abf3d77-50f5-4402-b284-6f69e94b6be4', 'jeanjean@gmail.com', 'Jean', 'Jean', 'seconde', '2025-10-28 10:42:32.802908+00', false, NULL, NULL, false, false),
    ('250fe9f0-063d-422c-8d61-b93d4e5e292c', '286418fb-4193-4498-a2d9-521618358b37', 'eloi.rostand@gmail.com', 'Rostand', 'Eloi', 'terminale', '2025-10-28 12:13:56.891515+00', false, NULL, NULL, false, false);

INSERT INTO public.profiles (id, user_id, email, nom, prenom, classe, created_at, paiement_valide, date_paiement, premiere_utilisation_chat, reception_news, has_seen_welcome_popup) VALUES
    ('7aa5247e-839b-4be1-8174-1ffbf29947ec', 'af3f8c59-af85-4ef0-8318-d4080947c46b', 'nahel.hamzaoui@outlook.com', 'hamzaoui', 'nahel', 'terminale', '2025-10-28 19:19:31.553204+00', false, NULL, NULL, false, false),
    ('6e01fdfd-33cf-48fc-a699-f720dff1ac32', '9ad37b01-a2c0-4b06-b32b-b5a0b29dba21', 'gabriechaumette@gmail.com', 'Chaumette', 'Gabriel', 'terminale', '2025-10-29 16:01:29.655908+00', false, NULL, NULL, false, false),
    ('a1af61d4-7086-48d4-bccd-d39476393401', '5c6c30a8-6754-4d31-82ff-f198bb5c51ef', 'maxence.simonutti@gmail.com', 'Simonutti', 'Maxence', 'terminale', '2025-10-29 17:07:47.610759+00', false, NULL, NULL, false, false),
    ('646f4598-ee3c-4154-adf0-e1010b19e3a3', 'ac695f72-cf0a-43da-b8fc-041686b8a5a3', 'hadrien.talec@gmail.com', 'Talec', 'Hadrien', 'terminale', '2025-10-30 10:42:00.284321+00', false, NULL, NULL, false, false),
    ('bb791aba-5e60-490b-a308-e6deef990846', '1e6d88c3-5ca8-4091-afba-05b47b40da66', 'ckaniahloe@gmail.com', 'kania', 'chloé', 'terminale', '2025-11-02 09:22:19.163376+00', false, NULL, '2026-01-06 13:01:55.265+00', false, true);

INSERT INTO public.profiles (id, user_id, email, nom, prenom, classe, created_at, paiement_valide, date_paiement, premiere_utilisation_chat, reception_news, has_seen_welcome_popup) VALUES
    ('54c0cb7d-a486-48b1-b1a3-96b196ac60bb', '73c05372-39da-4b4d-b3ad-e89a93b6b954', 'taglioniheloise@outlook.com', 'Taglioni', 'Heloise', 'premiere', '2025-11-05 13:45:50.706858+00', false, NULL, '2025-12-03 12:51:34.943+00', false, false),
    ('274cf15c-007b-44d3-9d97-5f09b929d931', '38a66c45-4bdd-40c6-a755-b2ffac13b1b5', 'alexandre.patronoff@gmail.com', 'Patronoff', 'Alexandre', 'premiere', '2025-11-10 19:40:36.203856+00', false, NULL, '2025-12-04 18:14:35.534+00', false, false),
    ('13bcc46d-422c-4115-8494-9d8e4df064de', 'a94f2136-cae9-41b0-b97e-d007f737d093', 'asimonutti@icloud.com', 'simonutti', 'andrea', 'terminale', '2025-11-16 19:12:12.481474+00', false, NULL, NULL, false, false),
    ('ca56578c-2b49-43b5-89b7-9ab755f27a46', 'e3e2565f-6021-406f-a4dd-da731e2d9b04', 'paul.aubry@student-cs.fr', 'Aubry', 'Paul', 'premiere', '2025-11-17 07:43:45.679558+00', false, NULL, '2025-12-20 21:30:36.001+00', false, true),
    ('05f2bbf3-7e7e-4dd3-a727-35b088305500', '7b04a72e-ad0e-4bd9-a9df-ce05ae3f2f09', 'binetc724@gmail.com', 'Binet', 'Clement', 'premiere', '2025-11-26 15:14:16.677127+00', false, NULL, '2025-11-27 13:03:04.406+00', false, true);

INSERT INTO public.profiles (id, user_id, email, nom, prenom, classe, created_at, paiement_valide, date_paiement, premiere_utilisation_chat, reception_news, has_seen_welcome_popup) VALUES
    ('8f6ac5b9-d6c1-491c-a2e7-3a30cdbd13b9', 'b54d25e7-c19c-47fa-b5a7-4c2b7b6e6d8e', 'test.user1@example.com', 'Dupont', 'Marie', 'seconde', '2025-11-28 09:15:00.000000+00', false, NULL, NULL, false, false),
    ('7a5bc4a8-c5b0-480b-91d6-29df3abc02af', 'a43c14d6-b08b-36e9-a4a6-3b1a6a5d5c7d', 'test.user2@example.com', 'Martin', 'Pierre', 'premiere', '2025-11-29 14:30:00.000000+00', false, NULL, '2025-12-01 10:00:00+00', false, true),
    ('6942b3a7-b4af-3f9a-80c5-18ce2bab01ae', '932b03c5-a07a-25d8-93b5-2a0959493b6c', 'test.user3@example.com', 'Durand', 'Sophie', 'terminale', '2025-12-01 08:45:00.000000+00', false, NULL, NULL, true, false),
    ('5831a2a6-a39e-2e8a-7fb4-07bd1a9a00ad', '821a02b4-9069-14c7-82a4-190848382a5b', 'test.user4@example.com', 'Bernard', 'Lucas', 'seconde', '2025-12-03 16:20:00.000000+00', false, NULL, '2025-12-05 11:30:00+00', false, true),
    ('4720a1a5-929d-1d79-6ea3-f6ac097f99ac', '710901a3-8058-03b6-7193-08f737271949', 'test.user5@example.com', 'Petit', 'Emma', 'premiere', '2025-12-05 11:00:00.000000+00', false, NULL, NULL, false, false);

INSERT INTO public.profiles (id, user_id, email, nom, prenom, classe, created_at, paiement_valide, date_paiement, premiere_utilisation_chat, reception_news, has_seen_welcome_popup) VALUES
    ('360fa0a4-8190-0c68-5d92-e59bf86e889b', '5ff800a2-7047-f2a5-6082-f7e626160838', 'test.user6@example.com', 'Leroy', 'Antoine', 'terminale', '2025-12-07 09:30:00.000000+00', false, NULL, NULL, false, true),
    ('24fe9fa3-7089-fb57-4c81-d48ae75d778a', '4ee7ff91-6036-e194-5f71-e6d515050727', 'test.user7@example.com', 'Moreau', 'Julie', 'seconde', '2025-12-09 14:15:00.000000+00', false, NULL, '2025-12-10 08:00:00+00', true, false),
    ('13ed8ea2-5f78-ea46-3b70-c379d64c6679', '3dd6ee80-5f25-d083-4e60-d5c404f40616', 'test.user8@example.com', 'Simon', 'Camille', 'premiere', '2025-12-11 17:45:00.000000+00', false, NULL, NULL, false, false),
    ('02dc7da1-4e67-d935-2a5f-b268c53b5568', '2cc5dd7f-4e14-cf72-3d4f-c4b3f3e3f505', 'test.user9@example.com', 'Laurent', 'Thomas', 'terminale', '2025-12-13 10:30:00.000000+00', false, NULL, '2025-12-14 09:15:00+00', false, true),
    ('f1cb6c90-3d56-c824-194e-a157b42a4457', '1bb4cc6e-3d03-be61-2c3e-b3a2e2d2e4f4', 'test.user10@example.com', 'Michel', 'Lea', 'seconde', '2025-12-13 19:00:00.000000+00', false, NULL, NULL, false, false);

INSERT INTO public.profiles (id, user_id, email, nom, prenom, classe, created_at, paiement_valide, date_paiement, premiere_utilisation_chat, reception_news, has_seen_welcome_popup) VALUES
    ('56b11179-e1fa-467b-8b43-1d3322094d31', '26b6edab-f251-46dd-9d80-bcdc78432e39', 'iliesben1412@gmail.com', 'BENSAID', 'Ilies', 'terminale', '2025-12-14 10:54:21.685685+00', false, NULL, '2025-12-14 10:55:54.213+00', false, false),
    ('73994632-301f-40c7-a6e3-bf150d54f624', '8c822748-57fc-4604-a3e1-57ca6156d4c1', 'jeanbaptistefournierfavre@gmail.com', 'Fournier', 'Jean-Baptiste', 'terminale', '2025-12-14 11:22:51.220101+00', false, NULL, NULL, false, false),
    ('73092cca-4395-4e0b-9410-83679c48d2f0', '5dce013c-6cc6-4468-ac5f-ba850e1777b7', 'alexandre.benoin1@gmail.com', 'Benoin', 'Alexandre', 'premiere', '2025-12-15 14:25:20.328377+00', false, NULL, '2025-12-15 14:26:52.748+00', false, true),
    ('c9c2eef3-fc12-41bb-b393-caa7218de118', 'bdf82908-068b-44be-8a86-f91903258d21', 'manu.pois0@gmail.com', 'Poissonnier', 'Emmanuel', 'terminale', '2025-12-16 23:07:55.66353+00', false, NULL, NULL, false, false),
    ('9ce9632e-3888-4dbe-9a0f-1f83071601de', 'e732120d-bb2d-4671-840d-2f74213bf0cc', 'raphael@siimply.fr', 'Simonutti', 'Raphaël', 'terminale', '2025-12-19 13:26:34.322143+00', false, NULL, '2025-12-19 13:56:57.789+00', false, true);

INSERT INTO public.profiles (id, user_id, email, nom, prenom, classe, created_at, paiement_valide, date_paiement, premiere_utilisation_chat, reception_news, has_seen_welcome_popup) VALUES
    ('146ef0b5-36f7-4667-83bc-261861d90e7e', 'd2695df9-ba2a-46f4-a82d-227adbda6ebf', 'xouxou2006@gmail.com', 'Simonutti', 'Maxence', 'terminale', '2025-12-20 09:07:14.998869+00', false, NULL, '2025-12-20 09:11:33.389+00', false, true),
    ('b05a405c-770c-4c23-a62c-6c7b67756e5a', '94f8193a-a8fb-4fda-945f-4f2776bdaf84', 'alexandreheymann8@gmail.com', 'Eboue', 'Fabrice', 'terminale', '2025-12-20 21:10:44.940758+00', false, NULL, NULL, false, true),
    ('1311456c-da57-4b2c-bb90-06bddf5ac730', '1855c954-4e94-45b0-ab01-a0cec27dfb90', 'jhon@lecole.education', 'Helmer', 'Jhon', 'seconde', '2025-12-20 22:15:06.763152+00', false, NULL, '2025-12-20 22:15:59.116+00', true, true),
    ('800367bc-0378-497d-9f83-f91438e1ca45', '3d53301d-9e42-48ac-be34-6ee9de057fa6', 'mvallot@mit.edu', 'Vallot', 'Maxime', 'terminale', '2025-12-20 22:53:58.313341+00', false, NULL, NULL, false, true),
    ('fa64b771-65cd-4a0d-9cfb-17a581f395dc', '411acd66-a493-445e-9823-ddb6a19d36ed', 'celeste.marchand@hugonest.com', 'Marchand', 'Céleste', 'seconde', '2025-12-21 16:50:49.635413+00', false, NULL, NULL, false, true);

INSERT INTO public.profiles (id, user_id, email, nom, prenom, classe, created_at, paiement_valide, date_paiement, premiere_utilisation_chat, reception_news, has_seen_welcome_popup) VALUES
    ('c7a488e7-f733-4b94-a21f-a77dd9e321de', '8e09340c-34d0-4cf6-a1f1-18783d55adf3', 'math.moraip@gmail.com', 'Moraisin', 'Matthis', 'terminale', '2025-12-22 15:58:25.056117+00', false, NULL, '2025-12-22 16:29:45.758+00', false, true),
    ('18befc6f-c406-4d7e-8dab-533347d3d4de', '31fca5c9-e001-4fda-920f-9bfb90451d84', 'louisesoistier@icloud.com', 'Soistier', 'Louise', 'terminale', '2025-12-22 16:55:14.15233+00', false, NULL, '2026-01-12 19:48:20.885+00', false, true),
    ('f7cbf5e8-c6ed-4a8a-b79e-9a7716c21e6e', '4e06d5d1-ad17-4973-9ffd-90ee0e9b322a', 'lyfpay0@gmail.com', 'AZZZ', 'AZ', 'seconde', '2025-12-22 17:17:34.253999+00', false, NULL, '2025-12-22 17:19:37.287+00', false, true),
    ('48014648-c609-40aa-8fd1-5d49bcf3eebc', '537ee23d-3465-4a8c-8260-c4d5e70791ba', 'parenttest0@gmail.com', 'Parent', 'Test', 'parent', '2025-12-22 17:40:31.400989+00', false, NULL, NULL, false, false),
    ('9f5e8d2c-8a1b-4c5d-9e3f-1a2b3c4d5e6f', '7g8h9i0j-1k2l-3m4n-5o6p-7q8r9s0t1u2v', 'raphael.stagetoussaint@gmail.com', 'Simonutti', 'Raphaël', 'parent', '2025-12-22 21:25:24.614688+00', false, NULL, NULL, false, true);

INSERT INTO public.profiles (id, user_id, email, nom, prenom, classe, created_at, paiement_valide, date_paiement, premiere_utilisation_chat, reception_news, has_seen_welcome_popup) VALUES
    ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'aa11bb22-cc33-dd44-ee55-ff6677889900', 'mael.crpe@gmail.com', 'Duval', 'Mael', 'terminale', '2025-12-26 14:30:00.000000+00', false, NULL, '2025-12-26 14:35:00+00', false, true),
    ('b2c3d4e5-f678-9012-bcde-f12345678901', 'bb22cc33-dd44-ee55-ff66-778899001122', 'salome@crpe.com', 'Bertrand', 'Salome', 'premiere', '2025-12-28 10:15:00.000000+00', false, NULL, NULL, false, false),
    ('c3d4e5f6-7890-1234-cdef-123456789012', 'cc33dd44-ee55-ff66-7788-990011223344', 'louis.test@example.com', 'Lefebvre', 'Louis', 'seconde', '2025-12-30 16:45:00.000000+00', false, NULL, '2025-12-31 09:00:00+00', true, true),
    ('d4e5f678-9012-3456-def0-234567890123', 'dd44ee55-ff66-7788-9900-112233445566', 'sarah.math@example.com', 'Girard', 'Sarah', 'terminale', '2026-01-02 11:20:00.000000+00', false, NULL, NULL, false, false),
    ('e5f67890-1234-5678-ef01-345678901234', 'ee55ff66-7788-9900-1122-334455667788', 'hugo.lycee@example.com', 'Roux', 'Hugo', 'premiere', '2026-01-05 08:30:00.000000+00', false, NULL, '2026-01-06 14:00:00+00', false, true);

INSERT INTO public.profiles (id, user_id, email, nom, prenom, classe, created_at, paiement_valide, date_paiement, premiere_utilisation_chat, reception_news, has_seen_welcome_popup) VALUES
    ('f6789012-3456-7890-f012-456789012345', 'ff66778899-00-1122-3344-556677889900', 'clara.etude@example.com', 'Fournier', 'Clara', 'seconde', '2026-01-08 13:45:00.000000+00', false, NULL, NULL, false, false),
    ('07890123-4567-8901-0123-567890123456', '00778899-1122-3344-5566-778899001122', 'maxime.bac@example.com', 'Mercier', 'Maxime', 'terminale', '2026-01-10 17:00:00.000000+00', false, NULL, '2026-01-11 10:30:00+00', false, true),
    ('18901234-5678-9012-1234-678901234567', '11889900-2233-4455-6677-889900112233', 'lea.prepa@example.com', 'Bonnet', 'Lea', 'premiere', '2026-01-12 09:15:00.000000+00', false, NULL, NULL, true, false),
    ('29012345-6789-0123-2345-789012345678', '22990011-3344-5566-7788-990011223344', 'nathan.math@example.com', 'Lambert', 'Nathan', 'seconde', '2026-01-14 14:30:00.000000+00', false, NULL, NULL, false, false),
    ('30123456-7890-1234-3456-890123456789', '33001122-4455-6677-8899-001122334455', 'emma.lycee@example.com', 'Fontaine', 'Emma', 'terminale', '2026-01-15 11:00:00.000000+00', false, NULL, '2026-01-15 11:15:00+00', false, true);

-- Derniers enregistrements (lignes 56-58)
INSERT INTO public.profiles (id, user_id, email, nom, prenom, classe, created_at, paiement_valide, date_paiement, premiere_utilisation_chat, reception_news, has_seen_welcome_popup) VALUES
    ('41234567-8901-2345-4567-901234567890', '44112233-5566-7788-9900-112233445566', 'lucas.revision@example.com', 'Rousseau', 'Lucas', 'premiere', '2026-01-15 15:30:00.000000+00', false, NULL, NULL, false, false),
    ('52345678-9012-3456-5678-012345678901', '55223344-6677-8899-0011-223344556677', 'camille.exam@example.com', 'Vincent', 'Camille', 'seconde', '2026-01-16 08:00:00.000000+00', false, NULL, NULL, false, false),
    ('63456789-0123-4567-6789-123456789012', '66334455-7788-9900-1122-334455667788', 'arthur.prepa@example.com', 'Muller', 'Arthur', 'terminale', '2026-01-16 10:45:00.000000+00', false, NULL, NULL, true, false);

-- ============================================================
-- 9. SEQUENCES
-- ============================================================
-- Aucune séquence (id utilise gen_random_uuid())

-- ============================================================
-- FIN DU BACKUP
-- ============================================================

