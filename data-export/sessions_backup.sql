-- ============================================================
-- TABLE: sessions
-- Export date: 2026-01-16T17:24:28.141Z
-- Total rows: 57
-- ============================================================

-- ============================================================
-- 1. DROP TABLE (if exists)
-- ============================================================
DROP TABLE IF EXISTS public.sessions CASCADE;

-- ============================================================
-- 2. CREATE TABLE
-- ============================================================
CREATE TABLE public.sessions (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    date_debut timestamp with time zone DEFAULT now(),
    date_fin timestamp with time zone,
    duree_totale integer,
    nb_exercices integer DEFAULT 0,
    progression jsonb DEFAULT '{}'::jsonb,
    humeur_du_jour text,
    humeur_timestamp timestamp with time zone,
    CONSTRAINT sessions_pkey PRIMARY KEY (id)
);

-- ============================================================
-- 3. FOREIGN KEYS
-- ============================================================
-- Aucune clé étrangère sur cette table

-- ============================================================
-- 4. INDEXES
-- ============================================================
-- L'index sessions_pkey est créé automatiquement par la contrainte PRIMARY KEY

-- ============================================================
-- 5. ROW LEVEL SECURITY
-- ============================================================
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 6. POLICIES
-- ============================================================
CREATE POLICY "Parents can view their children's sessions"
ON public.sessions
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM parent_eleve_relations per
        JOIN user_roles ur ON ur.user_id = auth.uid()
        WHERE per.parent_user_id = auth.uid()
        AND per.eleve_user_id = sessions.user_id
        AND ur.role = 'parent'
    )
);

CREATE POLICY "Users can delete their own sessions"
ON public.sessions
FOR DELETE
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own sessions"
ON public.sessions
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own sessions"
ON public.sessions
FOR UPDATE
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can view their own sessions"
ON public.sessions
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- ============================================================
-- 7. TRIGGERS
-- ============================================================
-- Aucun trigger sur cette table

-- ============================================================
-- 8. DATA (57 rows, batches of 5)
-- ============================================================
INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('7183d8b2-9d5f-40ff-a513-a96a6b5a399f', '0adfa326-254c-4090-8cab-38249e9d7525', '2026-01-14T16:22:06.379+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2026-01-14T16:22:06.379+00:00'::timestamptz),
    ('f776f913-dabf-4a07-8025-12136d2f55fb', '3ae820fa-f311-4c28-bc3e-0ae4c1c90f62', '2026-01-12T10:31:13.431+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2026-01-12T10:31:13.432+00:00'::timestamptz),
    ('98f4b61c-81e5-44ae-91c7-338311f213c6', 'a5440184-5907-4db0-af34-021798491187', '2026-01-09T17:02:20.369+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2026-01-09T17:02:20.369+00:00'::timestamptz),
    ('06025e47-2adb-4e8f-a1a1-71af008b9f04', 'ec1ed2df-6b3a-4346-b817-78a003bf6255', '2026-01-08T22:31:36.216+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2026-01-08T22:31:36.216+00:00'::timestamptz),
    ('0d34c01d-f9c0-4e8e-a9be-fd1743192625', 'e8e21bc2-2060-4ef3-a46c-d59dd7bf2271', '2026-01-03T11:15:14.693+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, NULL, NULL);

INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('1cdc6022-9fb9-4e7e-b5fd-d4a94e00f951', '65195e36-9ec5-4764-89d1-c470a99e144c', '2026-01-03T11:12:27.625+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2026-01-03T11:12:27.625+00:00'::timestamptz),
    ('6ad339df-009f-4a1c-9bd1-b3bcf3a54f82', 'e3aef950-59ba-48c1-9399-05b1a2e0e77f', '2026-01-02T20:02:38.274+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2026-01-02T20:02:38.274+00:00'::timestamptz),
    ('0b2299cc-40c3-4b1e-bd16-5504ca36cfe9', '1c325adb-60d8-403e-89ee-7bb87ca8689d', '2026-01-02T13:47:54.404+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2026-01-02T13:47:54.404+00:00'::timestamptz),
    ('6c5b8924-62ec-40cb-b135-9671d3035e7d', '5283a5c1-abb0-4050-8f63-111e4497ccae', '2025-12-31T17:22:30.106+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-31T17:22:30.106+00:00'::timestamptz),
    ('dba4584f-237f-41cd-a80b-baf1c052b247', '9ab90f75-3492-4170-ab45-bfc7a6ebfa97', '2025-12-31T00:12:32.757+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2025-12-31T00:12:32.757+00:00'::timestamptz);

INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('28b6930d-83c0-4510-929b-e1ba3baf4c6c', '9776e2c6-a37f-4d98-b1a8-d7908e585c5c', '2025-12-30T18:38:05.499+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-12-30T18:38:05.503+00:00'::timestamptz),
    ('93c7b8a5-aca9-47b2-aab4-8f9399b78509', '400bfb6a-df9f-4d59-bfcc-ec1fe33a5807', '2025-12-30T18:29:27.553+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2026-01-02T15:14:30.402+00:00'::timestamptz),
    ('40d47e7c-3ed0-43eb-a772-657fb23e78c7', '3df25035-922f-4ab2-8b91-04aaf18d982f', '2025-12-29T23:12:52.095+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-29T23:12:52.095+00:00'::timestamptz),
    ('ce138a0e-4843-4145-82d6-421eae9fa8f5', '6ffa9301-b885-4fb8-a251-5f0eca1cf1bb', '2025-12-28T15:15:04.542+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2025-12-28T15:15:04.542+00:00'::timestamptz),
    ('ddd56106-3e6f-4b75-a297-87b7aeaf6cfb', 'c5ce5010-6e40-4934-acf8-945ca0ea4a83', '2025-12-23T18:52:09.222+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2025-12-23T18:52:09.222+00:00'::timestamptz);

INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('a763754f-8395-4b38-bcc5-b4afb232cb40', 'fde6d58e-d848-4be2-b3c7-0ab2800d1ff2', '2025-12-23T13:19:23.963+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-12-23T13:19:23.963+00:00'::timestamptz),
    ('03941f0c-bc1b-44a1-9fd9-c5f1974157b3', 'e1c7b243-a450-46a2-b322-2ae25c42a139', '2025-12-22T21:26:14.827+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-23T21:08:08.339+00:00'::timestamptz),
    ('e4b4e01f-0231-4aa3-bff3-05d7a1e824c9', '4e06d5d1-ad17-4973-9ffd-90ee0e9b322a', '2025-12-22T17:19:19.632+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😤 Franchement pas motivé(e)', '2025-12-29T19:54:07.959+00:00'::timestamptz),
    ('71ce2595-627d-4aa2-a5cb-10a47dd68053', '31fca5c9-e001-4fda-920f-9bfb90451d84', '2025-12-22T16:55:22.61+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2026-01-13T12:13:24.738+00:00'::timestamptz),
    ('29501467-3400-411e-8e97-1640ee7d5678', '8e09340c-34d0-4cf6-a1f1-18783d55adf3', '2025-12-22T15:58:44.051+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-12-22T15:58:44.051+00:00'::timestamptz);

INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('dcff0363-bc79-4d76-8652-2c0d2851ff11', '411acd66-a493-445e-9823-ddb6a19d36ed', '2025-12-21T16:51:00.105+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2025-12-21T16:51:00.105+00:00'::timestamptz),
    ('693e7f99-b9da-46a9-84c6-75c863fc76ae', '3d53301d-9e42-48ac-be34-6ee9de057fa6', '2025-12-20T22:54:03.287+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-20T22:54:03.287+00:00'::timestamptz),
    ('4eada858-39d9-4a17-bc1d-ada623a91f33', '1855c954-4e94-45b0-ab01-a0cec27dfb90', '2025-12-20T22:15:24.588+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-20T22:15:24.588+00:00'::timestamptz),
    ('feb1dc22-0b4f-4b46-a403-c66498217dba', '94f8193a-a8fb-4fda-945f-4f2776bdaf84', '2025-12-20T21:10:56.652+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-20T21:10:56.652+00:00'::timestamptz),
    ('830d729c-e770-4fb3-b2c2-91e48a8b28d4', 'd2695df9-ba2a-46f4-a82d-227adbda6ebf', '2025-12-20T09:07:19.632+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-22T17:21:07.706+00:00'::timestamptz);

INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('4613146e-b064-4115-a1af-a2831d1e6dc4', 'e732120d-bb2d-4671-840d-2f74213bf0cc', '2025-12-19T13:26:45.232+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2026-01-15T22:18:21.909+00:00'::timestamptz),
    ('79130509-e67b-4846-8ace-192408eece41', 'bdf82908-068b-44be-8a86-f91903258d21', '2025-12-16T23:07:57.623+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2025-12-18T19:29:27.948+00:00'::timestamptz),
    ('d5572046-066b-4d50-85e8-2517373b2766', '5dce013c-6cc6-4468-ac5f-ba850e1777b7', '2025-12-15T14:25:27.128+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-12-20T23:57:52.861+00:00'::timestamptz),
    ('1099e2d6-f2c6-4af1-8bf9-19f28a5d166f', '8c822748-57fc-4604-a3e1-57ca6156d4c1', '2025-12-14T11:23:10.41+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2025-12-14T11:23:10.41+00:00'::timestamptz),
    ('55778254-ad25-4a55-8f12-915a24589a14', '26b6edab-f251-46dd-9d80-bcdc78432e39', '2025-12-14T10:54:27.752+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😤 Franchement pas motivé(e)', '2025-12-14T10:54:27.752+00:00'::timestamptz);

INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('460223ec-bb72-482e-84ec-3dd2560e1b49', 'bcbdd388-8d08-40c4-af5b-b92b2ac7a3d9', '2025-12-14T08:38:06.276+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-14T08:38:06.276+00:00'::timestamptz),
    ('e920336c-ccd3-45b5-bc66-254e2197cfad', '255895dc-667d-4d27-a57f-5dfa2e131af0', '2025-12-12T14:46:38.34+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2026-01-11T11:00:41.085+00:00'::timestamptz),
    ('5d67e7e7-71a6-41a7-bec2-f0285ab83a13', '89fad5be-2edd-4dec-a1cd-01b755285dcf', '2025-12-07T17:57:15.741+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-20T09:04:48.86+00:00'::timestamptz),
    ('c2ec4e32-c958-4266-84c0-b7680273eff0', '59e80fe2-208e-42ae-8ab2-e2d9adc663bc', '2025-12-06T10:58:51.915+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-13T11:23:53.847+00:00'::timestamptz),
    ('d7b49c1e-01f3-4586-a889-58853a529af6', '45be8e26-8733-46c8-a568-d4b869fe4b3d', '2025-12-02T21:47:48.473+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2026-01-15T18:14:20.884+00:00'::timestamptz);

INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('0e048e74-37a9-4ff6-86e2-806e3f7f1f6e', '76aa57e8-931b-4c15-b35a-9212685c370d', '2025-12-02T08:31:15.894+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-12-16T13:25:55.664+00:00'::timestamptz),
    ('a137d492-b6d1-4949-a3f8-a795f31e6979', 'aa86ed3d-f2f2-4844-ad23-850ba4dd09ca', '2025-12-01T15:19:48.645+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-12-01T15:19:48.645+00:00'::timestamptz),
    ('174621e1-2c3b-42c8-ac98-f47a652285a9', 'ce842f9b-e38b-421d-b5f8-8e0570a149d6', '2025-11-26T15:14:20.365+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2025-11-26T15:14:20.365+00:00'::timestamptz),
    ('a78db3d9-c527-4f6b-a738-ada9f9c3b44a', 'e3e2565f-6021-406f-a4dd-da731e2d9b04', '2025-11-17T07:43:48.985+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2025-12-21T10:02:54.531+00:00'::timestamptz),
    ('85ad9e80-dc32-4b90-9b3c-d36639e98531', 'a94f2136-cae9-41b0-b97e-d007f737d093', '2025-11-16T19:12:45.16+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-11-16T19:12:45.16+00:00'::timestamptz);

INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('927fa176-56df-4e42-9691-6f76492739d4', '38a66c45-4bdd-40c6-a755-b2ffac13b1b5', '2025-11-10T19:40:45.808+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-04T18:13:57.56+00:00'::timestamptz),
    ('8c0a2ec1-c605-41a4-b68c-20a2c443bf62', '73c05372-39da-4b4d-b3ad-e89a93b6b954', '2025-11-05T13:45:58.849+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-12-03T12:50:26.538+00:00'::timestamptz),
    ('2545ab9e-74bd-444f-8af3-351c6ff45c5e', '1e6d88c3-5ca8-4091-afba-05b47b40da66', '2025-11-02T09:22:29.102+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2026-01-06T13:01:31.478+00:00'::timestamptz),
    ('663c4c3c-3cde-4119-acca-ed06b14fd1ce', 'ac695f72-cf0a-43da-b8fc-041686b8a5a3', '2025-10-30T10:42:06.894+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2025-10-30T10:42:06.894+00:00'::timestamptz),
    ('751ecb59-d726-4c84-b59b-a59690755bd5', '5c6c30a8-6754-4d31-82ff-f198bb5c51ef', '2025-10-29T17:10:15.848+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-11-02T20:27:47.186+00:00'::timestamptz);

INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('2bfe7072-bb64-4098-aa7b-2ba49a6df00b', '9ad37b01-a2c0-4b06-b32b-b5a0b29dba21', '2025-10-29T16:01:39.044+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-11-20T17:38:53.519+00:00'::timestamptz),
    ('be50a19f-b1e7-4cf2-95ba-e0e0e22619fb', 'af3f8c59-af85-4ef0-8318-d4080947c46b', '2025-10-28T19:19:35.587+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-11-16T20:51:40.33+00:00'::timestamptz),
    ('8ab2ad96-4374-4a82-b033-426ca943b597', '286418fb-4193-4498-a2d9-521618358b37', '2025-10-28T12:14:03.833+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2025-11-20T18:42:43.424+00:00'::timestamptz),
    ('df3e50c6-1ca6-469b-a479-9809ad53e55a', '2abf3d77-50f5-4402-b284-6f69e94b6be4', '2025-10-28T10:42:35.025+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-10-28T10:42:35.025+00:00'::timestamptz),
    ('79b7499c-774b-45e6-a646-e88154dc967d', '306093a9-efc0-4370-a917-35ca259ae261', '2025-10-23T21:39:10.161+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '🙂 Ça va, prêt(e) à travailler', '2026-01-16T07:58:15.556+00:00'::timestamptz);

INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('5861596b-51f2-4ea9-92dc-0f817b35a595', '306093a9-efc0-4370-a917-35ca259ae261', '2025-10-23T21:17:37.905+00:00'::timestamptz, '2025-10-23T21:39:10.032+00:00'::timestamptz, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-10-23T21:27:47.558+00:00'::timestamptz),
    ('8acb548a-492a-4f4f-abb9-23cf5e8506a2', '306093a9-efc0-4370-a917-35ca259ae261', '2025-10-23T21:08:23.642+00:00'::timestamptz, '2025-10-23T21:17:37.406+00:00'::timestamptz, NULL, 0, '{}'::jsonb, NULL, NULL),
    ('3add6818-e47d-4dfd-b088-d8c9d3b3a771', '306093a9-efc0-4370-a917-35ca259ae261', '2025-10-23T16:47:06.447+00:00'::timestamptz, '2025-10-23T21:08:23.533+00:00'::timestamptz, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-10-23T16:51:08.994+00:00'::timestamptz),
    ('54df30b6-8463-4477-a349-790ab62a843b', '306093a9-efc0-4370-a917-35ca259ae261', '2025-10-23T16:28:46.145+00:00'::timestamptz, '2025-10-23T16:47:06.28+00:00'::timestamptz, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-10-23T16:30:31.945+00:00'::timestamptz),
    ('0b5bfc71-c92c-4851-b743-86b0eb1d3d13', '306093a9-efc0-4370-a917-35ca259ae261', '2025-10-13T21:28:22.694+00:00'::timestamptz, '2025-10-23T16:28:46.044+00:00'::timestamptz, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2025-10-23T11:21:37.62+00:00'::timestamptz);

INSERT INTO public.sessions (id, user_id, date_debut, date_fin, duree_totale, nb_exercices, progression, humeur_du_jour, humeur_timestamp) VALUES
    ('269257c7-5566-49e3-b262-9fdc5fab543c', 'b7513248-38c8-47fd-8a62-3f938316f9ad', '2025-10-13T21:26:24.311+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😊 Super motivé(e) !', '2026-01-13T15:08:05.923+00:00'::timestamptz),
    ('02baacbe-ac3b-4fa2-a3b5-e3a14f084b2e', 'b1e14b06-14f9-4757-a9f6-d7fb60998590', '2025-10-13T20:56:57.792+00:00'::timestamptz, NULL, NULL, 0, '{}'::jsonb, '😐 Moyen, on verra', '2025-10-13T20:56:57.792+00:00'::timestamptz);

-- ============================================================
-- 9. SEQUENCES
-- ============================================================
-- Aucune séquence (id utilise gen_random_uuid())
