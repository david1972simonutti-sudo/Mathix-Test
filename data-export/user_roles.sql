-- =====================================================
-- BACKUP TABLE: user_roles
-- Date: 2026-01-16
-- Nombre de lignes: 57
-- =====================================================

-- Supprimer la table si elle existe
DROP TABLE IF EXISTS public.user_roles CASCADE;

-- =====================================================
-- 1. TYPE ENUM (prérequis)
-- =====================================================
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'app_role') THEN
        CREATE TYPE public.app_role AS ENUM ('eleve', 'parent', 'administrateur');
    END IF;
END$$;

-- =====================================================
-- 2. CREATE TABLE
-- =====================================================
CREATE TABLE public.user_roles (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    role public.app_role NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    
    CONSTRAINT user_roles_pkey PRIMARY KEY (id),
    CONSTRAINT user_roles_user_id_role_key UNIQUE (user_id, role)
);

-- =====================================================
-- 3. FOREIGN KEYS
-- =====================================================
-- Note: Pas de foreign key explicite vers auth.users dans la définition actuelle
-- (La référence à auth.users est gérée au niveau applicatif)

-- =====================================================
-- 4. INDEX
-- =====================================================
-- Les index suivants sont créés automatiquement par les contraintes:
-- CREATE UNIQUE INDEX user_roles_pkey ON public.user_roles USING btree (id);
-- CREATE UNIQUE INDEX user_roles_user_id_role_key ON public.user_roles USING btree (user_id, role);

-- =====================================================
-- 5. ROW LEVEL SECURITY
-- =====================================================
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 6. POLICIES
-- =====================================================
CREATE POLICY "Admins can manage all roles" ON public.user_roles
    FOR ALL
    USING (has_role(auth.uid(), 'administrateur'::app_role))
    WITH CHECK (has_role(auth.uid(), 'administrateur'::app_role));

CREATE POLICY "Admins can view all roles" ON public.user_roles
    FOR SELECT
    USING (has_role(auth.uid(), 'administrateur'::app_role));

CREATE POLICY "Users can only self-assign eleve role during signup" ON public.user_roles
    FOR INSERT
    WITH CHECK ((auth.uid() = user_id) AND (role = 'eleve'::app_role));

CREATE POLICY "Users can view their own roles" ON public.user_roles
    FOR SELECT
    USING (auth.uid() = user_id);

-- =====================================================
-- 7. TRIGGERS
-- =====================================================
-- Aucun trigger sur cette table

-- =====================================================
-- 8. FONCTION UTILITAIRE has_role (prérequis pour les policies)
-- =====================================================
CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role app_role)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path TO 'public'
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = _role
  )
$$;

-- =====================================================
-- 9. INSERT DATA (57 lignes par lots de 5)
-- =====================================================

-- Lot 1
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('114f5e63-0ba7-46b6-8db0-c507faed42bb', '5c6c30a8-6754-4d31-82ff-f198bb5c51ef', 'eleve', '2025-12-01 10:52:17.600285+00'),
('6d0a5c34-0446-40f2-a820-7f269952f890', '306093a9-efc0-4370-a917-35ca259ae261', 'eleve', '2025-12-01 10:52:17.600285+00'),
('f6ce0b1a-a506-4633-bf27-abe3aaedf8f6', '2abf3d77-50f5-4402-b284-6f69e94b6be4', 'eleve', '2025-12-01 10:52:17.600285+00'),
('fb044351-fe5a-4e93-b118-0096b33bec13', 'af3f8c59-af85-4ef0-8318-d4080947c46b', 'eleve', '2025-12-01 10:52:17.600285+00'),
('acbc3cb6-17b6-45cd-9697-74914371c36d', '9ad37b01-a2c0-4b06-b32b-b5a0b29dba21', 'eleve', '2025-12-01 10:52:17.600285+00');

-- Lot 2
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('2a02cf36-ab18-4a10-bacc-27a71a812a38', 'a94f2136-cae9-41b0-b97e-d007f737d093', 'eleve', '2025-12-01 10:52:17.600285+00'),
('7e47347e-870d-4321-912c-6af4c29d4ae7', 'ac695f72-cf0a-43da-b8fc-041686b8a5a3', 'eleve', '2025-12-01 10:52:17.600285+00'),
('bffa79b5-7e9b-4b35-bee2-9326dd2214e2', 'e3e2565f-6021-406f-a4dd-da731e2d9b04', 'eleve', '2025-12-01 10:52:17.600285+00'),
('97a92261-a2b7-47e7-85a6-b645bd573017', '38a66c45-4bdd-40c6-a755-b2ffac13b1b5', 'eleve', '2025-12-01 10:52:17.600285+00'),
('e8c8aa1c-40ff-463f-b7fc-340b5df3a812', '286418fb-4193-4498-a2d9-521618358b37', 'eleve', '2025-12-01 10:52:17.600285+00');

-- Lot 3
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('a36013ba-1735-400d-9b5d-0cad6b20d4b9', '1e6d88c3-5ca8-4091-afba-05b47b40da66', 'eleve', '2025-12-01 10:52:17.600285+00'),
('d4f1d63d-dca7-4731-b357-fc2808e5976c', '73c05372-39da-4b4d-b3ad-e89a93b6b954', 'eleve', '2025-12-01 10:52:17.600285+00'),
('c902bba2-40ba-49de-995d-de76f07cde05', 'ce842f9b-e38b-421d-b5f8-8e0570a149d6', 'eleve', '2025-12-01 10:52:17.600285+00'),
('f8a8d751-8885-4a8f-b3a9-dd9fd135a641', '76aa57e8-931b-4c15-b35a-9212685c370d', 'eleve', '2025-12-02 08:31:09.389355+00'),
('d08304d6-3e66-49cf-a56b-77636b828211', '408b880f-1db3-4740-a09f-28fc07262101', 'parent', '2025-12-02 10:06:08.119291+00');

-- Lot 4
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('f69378c4-b12c-4230-b9e0-602f7a46fea9', '45be8e26-8733-46c8-a568-d4b869fe4b3d', 'eleve', '2025-12-02 21:47:28.41723+00'),
('7154772f-0da0-4365-8267-489520d91bad', 'd619011a-1c7f-4cc3-8470-bcea825bff88', 'eleve', '2025-12-06 10:58:35.926092+00'),
('f7d64b2d-fd58-4a2f-9d32-5c8c580335b8', '960aa6d8-0fd7-4875-be9d-097d1f3aee55', 'eleve', '2025-12-06 10:58:36.272007+00'),
('32ebd064-b846-4610-a04c-9434b859880e', '57086d64-c438-4577-b36b-53da70584eb6', 'eleve', '2025-12-06 10:58:36.568745+00'),
('9703de5b-f77c-48d2-b3c5-85f504c1dd9a', 'ef1d55a3-7b4f-4e28-a913-3788571a1228', 'eleve', '2025-12-06 10:58:36.890354+00');

-- Lot 5
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('2b2b7ce5-fb67-46a0-86b2-9073a96398b0', 'bb9ae76c-506f-4794-a729-c704ca3c4297', 'eleve', '2025-12-06 10:58:37.19838+00'),
('6f8bac78-475c-401c-bfab-694dad6ac50f', '2074452e-769b-4195-8e26-04f18811019f', 'eleve', '2025-12-06 10:58:37.470574+00'),
('6ce381a3-3a77-4620-bb38-6d6427241c64', '59e80fe2-208e-42ae-8ab2-e2d9adc663bc', 'eleve', '2025-12-06 10:58:37.776288+00'),
('02620f1e-fd7a-455a-9247-772e28fc61e7', '6a73d17e-4da0-4ae4-b0e4-a3f758cb99a2', 'eleve', '2025-12-06 10:58:38.037426+00'),
('ccacd206-e68f-48b4-b4dc-9007a4c1ce1a', 'e77fd065-aa28-4417-a1d3-f0e345fa8cf2', 'eleve', '2025-12-06 10:58:38.303014+00');

-- Lot 6
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('2f6d555a-6d1b-4497-89cc-9d595108cfbf', '89fad5be-2edd-4dec-a1cd-01b755285dcf', 'eleve', '2025-12-07 17:56:34.97286+00'),
('b12c63a1-8d8f-4fcd-9895-2e1df093d0e8', '255895dc-667d-4d27-a57f-5dfa2e131af0', 'eleve', '2025-12-12 14:45:11.001029+00'),
('8a41d5fc-c253-4734-9b99-da83567ae866', 'bcbdd388-8d08-40c4-af5b-b92b2ac7a3d9', 'eleve', '2025-12-14 08:36:33.020655+00'),
('f2832e81-a90b-428f-be94-9801eaa7a13a', '26b6edab-f251-46dd-9d80-bcdc78432e39', 'eleve', '2025-12-14 10:54:21.986875+00'),
('babd54f6-6b20-4676-99f4-c590d2832a63', '8c822748-57fc-4604-a3e1-57ca6156d4c1', 'eleve', '2025-12-14 11:22:51.342763+00');

-- Lot 7
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('de8ff003-523b-45c2-881c-01dac15fba2c', '5dce013c-6cc6-4468-ac5f-ba850e1777b7', 'eleve', '2025-12-15 14:25:20.704484+00'),
('0d82a5ea-5cb0-44dd-a431-c8e519fa26b3', 'bdf82908-068b-44be-8a86-f91903258d21', 'eleve', '2025-12-16 23:07:55.78104+00'),
('6fa9ea14-af3f-4d06-895a-1ec76387d87f', 'e732120d-bb2d-4671-840d-2f74213bf0cc', 'eleve', '2025-12-19 13:26:34.466085+00'),
('9ac1d07a-ebf3-44d3-8ad2-3f44e28dbacb', 'd2695df9-ba2a-46f4-a82d-227adbda6ebf', 'eleve', '2025-12-20 09:07:15.13768+00'),
('8424110e-c9ef-4f81-82d8-ddc25f69d9f6', 'ce9d4cb6-1d3f-495e-ae5d-5f53a62a2a91', 'eleve', '2025-12-20 21:10:45.101202+00');

-- Lot 8
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('41444496-a641-47bc-9bca-b0b3ae4d340c', '1855c954-4e94-45b0-ab01-a0cec27dfb90', 'eleve', '2025-12-20 22:15:06.97884+00'),
('167f7ddc-297e-401e-abe6-ec1abe067df6', '3d53301d-9e42-48ac-be34-6ee9de057fa6', 'eleve', '2025-12-20 22:53:58.437015+00'),
('342c8e16-65c0-40bf-8a52-6d706a9a253c', '411acd66-a493-445e-9823-ddb6a19d36ed', 'eleve', '2025-12-21 16:50:49.753692+00'),
('af5c6a1e-abba-4304-aca3-3152d6e0d7e3', '8e09340c-34d0-4cf6-a1f1-18783d55adf3', 'eleve', '2025-12-22 15:58:25.284096+00'),
('e3450def-4aff-42d5-bbbd-0460839ef1e3', '31fca5c9-e001-4fda-920f-9bfb90451d84', 'eleve', '2025-12-22 16:55:14.298274+00');

-- Lot 9
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('aabd7496-c8a6-44fa-9591-d87d0c66ec2f', '4e06d5d1-ad17-4973-9ffd-90ee0e9b322a', 'eleve', '2025-12-22 17:17:34.356015+00'),
('a41ca2c3-a0d6-4ff0-89f5-0f4172ba4fe2', '537ee23d-3465-4a8c-8260-c4d5e70791ba', 'parent', '2025-12-22 17:40:31.479001+00'),
('e89ab111-97ca-4ca1-ac8f-7119ab5aa01b', 'e1c7b243-a450-46a2-b322-2ae25c42a139', 'parent', '2025-12-22 21:25:24.654944+00'),
('5d7a6cb3-5910-44f0-8dd5-d7a3234b8207', 'fde6d58e-d848-4be2-b3c7-0ab2800d1ff2', 'eleve', '2025-12-23 13:19:13.047295+00'),
('c62e11ae-61fd-40a7-aa2d-2229dd28d129', 'c5ce5010-6e40-4934-acf8-945ca0ea4a83', 'eleve', '2025-12-23 18:51:54.667015+00');

-- Lot 10
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('ea00cf6a-1679-49a3-9212-9b98ed5fc146', '6ffa9301-b885-4fb8-a251-5f0eca1cf1bb', 'eleve', '2025-12-28 15:14:48.023693+00'),
('3dd1c345-025f-4cff-9d77-0104ce80aca6', '3df25035-922f-4ab2-8b91-04aaf18d982f', 'eleve', '2025-12-29 23:12:36.901277+00'),
('6334cf24-2dda-483d-bacf-b145e1aaddb7', '400bfb6a-df9f-4d59-bfcc-ec1fe33a5807', 'eleve', '2025-12-30 18:29:14.973788+00'),
('d7891ab9-1434-48c9-8312-d76c9454daeb', '5283a5c1-abb0-4050-8f63-111e4497ccae', 'eleve', '2025-12-31 17:22:25.146012+00'),
('8a2441e9-5c44-4bb8-a4db-bac67ddbc0be', '1c325adb-60d8-403e-89ee-7bb87ca8689d', 'eleve', '2026-01-02 13:47:48.971029+00');

-- Lot 11
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('95cf2b48-edeb-45d4-a558-5c34caf57034', 'e3aef950-59ba-48c1-9399-05b1a2e0e77f', 'eleve', '2026-01-02 20:02:18.534844+00'),
('441253b3-2666-445e-897f-26f27fdbe806', '65195e36-9ec5-4764-89d1-c470a99e144c', 'eleve', '2026-01-03 11:12:13.49874+00'),
('7721ffa4-7625-4cb7-9c45-8b837c411286', 'e8e21bc2-2060-4ef3-a46c-d59dd7bf2271', 'parent', '2026-01-03 11:14:27.244725+00'),
('186971e3-4472-4bfc-b526-f69a3e0710d4', 'ec1ed2df-6b3a-4346-b817-78a003bf6255', 'eleve', '2026-01-08 22:31:23.805841+00'),
('0acaf81e-9f4a-4330-ae34-fdfba0b543cc', 'a5440184-5907-4db0-af34-021798491187', 'eleve', '2026-01-09 17:02:12.06194+00');

-- Lot 12 (dernières lignes)
INSERT INTO public.user_roles (id, user_id, role, created_at) VALUES
('6dc40593-ee4a-49a7-85aa-f2b4c70d3a97', 'b7513248-38c8-47fd-8a62-3f938316f9ad', 'parent', '2026-01-12 18:56:20.131138+00'),
('165c604a-b537-4f72-bb6c-18155d665c58', '0adfa326-254c-4090-8cab-38249e9d7525', 'eleve', '2026-01-14 16:22:00.711458+00');

-- =====================================================
-- 10. SEQUENCES
-- =====================================================
-- Aucune séquence (utilisation de gen_random_uuid())

-- =====================================================
-- FIN DU BACKUP
-- =====================================================

