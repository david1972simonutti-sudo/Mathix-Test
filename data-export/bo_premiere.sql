-- ============================================================
-- TABLE: bo_premiere
-- Export date: 2026-01-16
-- Total rows: 67
-- ============================================================

-- ============================================================
-- SECTION 1: STRUCTURE
-- ============================================================

DROP TABLE IF EXISTS public.bo_premiere CASCADE;

CREATE TABLE public.bo_premiere (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    chapitre text NOT NULL,
    sous_notion text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT bo_premiere_pkey PRIMARY KEY (id),
    CONSTRAINT bo_premiere_chapitre_sous_notion_key UNIQUE (chapitre, sous_notion)
);

-- ============================================================
-- SECTION 2: FOREIGN KEYS
-- ============================================================
-- (Aucune foreign key pour cette table)

-- ============================================================
-- SECTION 3: INDEX
-- ============================================================
-- Les index pkey et unique sont crees automatiquement via les contraintes
-- CREATE UNIQUE INDEX bo_premiere_pkey ON public.bo_premiere USING btree (id);
-- CREATE UNIQUE INDEX bo_premiere_chapitre_sous_notion_key ON public.bo_premiere USING btree (chapitre, sous_notion);

-- ============================================================
-- SECTION 4: ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE public.bo_premiere ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- SECTION 5: POLICIES
-- ============================================================

CREATE POLICY "Lecture publique bo_premiere"
    ON public.bo_premiere
    FOR SELECT
    TO public
    USING (true);

-- ============================================================
-- SECTION 6: TRIGGERS
-- ============================================================
-- (Aucun trigger pour cette table)

-- ============================================================
-- SECTION 7: DONNEES (67 lignes)
-- ============================================================

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('46047ee1-1de6-4291-9936-ed209bb0e674', 'Dérivation', 'Dérivée de fonctions composées (du type u^n, 1/u)', '2025-12-06 16:06:55.251001+00'),
    ('49f6d0df-a43f-41e3-a2c2-2186535affb0', 'Dérivation', 'Dérivées des fonctions usuelles', '2025-12-06 16:06:55.251001+00'),
    ('d0716b3c-47f7-4d5e-9a36-2f8b8ed2913e', 'Dérivation', 'Équation de tangente', '2025-12-06 16:06:55.251001+00'),
    ('8db4675c-0bcc-4e9f-ba76-f9e60aa217b4', 'Dérivation', 'Fonction dérivée', '2025-12-06 16:06:55.251001+00'),
    ('62aa1aa9-45c3-4a81-a221-b2394cf671b3', 'Dérivation', 'Fonction dérivée de x ↦ g(ax+b)', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('49156c31-f9f9-43b2-bd6c-4e0788bd8416', 'Dérivation', 'Lien entre signe de la dérivée et variations', '2025-12-06 16:06:55.251001+00'),
    ('2ddf82dc-beba-43d5-9fe8-caf981670f94', 'Dérivation', 'Nombre dérivé en un point', '2025-12-06 16:06:55.251001+00'),
    ('8942f443-9488-45c2-a200-8879e6b2c2ad', 'Dérivation', 'Opérations sur les dérivées', '2025-12-06 16:06:55.251001+00'),
    ('7a22e998-bb05-4be9-856b-3ac3aeff0d4f', 'Dérivation', 'Taux de variation', '2025-12-06 16:06:55.251001+00'),
    ('0ca4b920-a313-4366-aac0-dec12057ce94', 'Expérimentations et simulations', 'Distance entre moyenne et espérance', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('2c19b9a4-2932-410d-96c0-88c3c9564fd5', 'Expérimentations et simulations', 'Moyenne d''un échantillon', '2025-12-06 16:06:55.251001+00'),
    ('de70e3de-eb24-47ec-878a-13bb1ba7a3b3', 'Expérimentations et simulations', 'Proportion de valeurs dans l''intervalle [μ - 2σ/√n ; μ + 2σ/√n]', '2025-12-06 16:06:55.251001+00'),
    ('bcde5b41-9983-4a41-8469-d5eea7b01095', 'Expérimentations et simulations', 'Simulations en Python', '2025-12-06 16:06:55.251001+00'),
    ('f7d46919-a364-4a5d-9666-237db244ed57', 'Fonction exponentielle', 'Définition (f'' = f et f(0) = 1)', '2025-12-06 16:06:55.251001+00'),
    ('15527615-7216-4e94-9a73-b71e2e5fe304', 'Fonction exponentielle', 'Lien avec les suites géométriques', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('f1dbadaf-7703-4863-887d-e8de3faca98a', 'Fonction exponentielle', 'Nombre e', '2025-12-06 16:06:55.251001+00'),
    ('edefb11e-7cf5-43fb-8aa0-7cff3c796b0f', 'Fonction exponentielle', 'Notation exp(x) = e^x', '2025-12-06 16:06:55.251001+00'),
    ('35cace9c-4b37-4511-8bf0-c9799aa7a6fc', 'Fonction exponentielle', 'Propriétés algébriques', '2025-12-06 16:06:55.251001+00'),
    ('266dbaed-acd3-466a-bbe2-81a92c9f61ce', 'Fonctions trigonométriques', 'Cercle trigonométrique', '2025-12-06 16:06:55.251001+00'),
    ('950d003e-58f7-4982-9e6b-e8000c32eabf', 'Fonctions trigonométriques', 'Enroulement de la droite sur le cercle', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('1f9e7aeb-2691-46a2-a78e-3a7535d8a8ab', 'Fonctions trigonométriques', 'Fonctions cosinus et sinus', '2025-12-06 16:06:55.251001+00'),
    ('158ff9c9-58f5-48e9-b349-902b7ca02478', 'Fonctions trigonométriques', 'Parité et périodicité', '2025-12-06 16:06:55.251001+00'),
    ('4dab539c-bf44-4114-92a6-e0154209c854', 'Fonctions trigonométriques', 'Radian', '2025-12-06 16:06:55.251001+00'),
    ('7b2fe681-9924-4d9f-b97d-30f3c340d3df', 'Fonctions trigonométriques', 'Valeurs remarquables', '2025-12-06 16:06:55.251001+00'),
    ('31dd68db-811d-458e-ad9b-57582d6906b5', 'Géométrie repérée', 'Équation du cercle', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('e839949d-5b9f-41b5-ac59-5e036ef5522e', 'Géométrie repérée', 'Parabole représentant une fonction du second degré', '2025-12-06 16:06:55.251001+00'),
    ('dfaeb08f-9001-448e-96ba-455937a15bf6', 'Géométrie repérée', 'Vecteur normal à une droite', '2025-12-06 16:06:55.251001+00'),
    ('a1691387-9764-4b1b-b719-47e0df206970', 'Manipuler les listes', 'Génération par extension et en compréhension', '2025-12-06 16:06:55.251001+00'),
    ('5947ae2f-17b1-4bd5-b5fc-72b14c02c905', 'Manipuler les listes', 'Itération sur les éléments', '2025-12-06 16:06:55.251001+00'),
    ('686e916d-c51b-4eb1-9bd2-0c85e09b0193', 'Manipuler les listes', 'Manipulation d''éléments et d''indices', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('f2ef5caa-4167-438a-8df5-3848c903e20d', 'Manipuler les listes', 'Parcours de listes', '2025-12-06 16:06:55.251001+00'),
    ('50041a9b-2318-496e-a001-e77af711d56e', 'Polynômes du second degré', 'Discriminant', '2025-12-06 16:06:55.251001+00'),
    ('9ba67b4d-0a19-41f5-a046-f76a800505fd', 'Polynômes du second degré', 'Forme développée, canonique, factorisée', '2025-12-06 16:06:55.251001+00'),
    ('39922fbd-1267-4a5e-b05c-9235b602a27b', 'Polynômes du second degré', 'Résolution d''équations du second degré', '2025-12-06 16:06:55.251001+00'),
    ('77225aa2-0417-4593-ab51-54062d0dc864', 'Polynômes du second degré', 'Signe du trinôme', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('11ead5d8-c146-443c-abec-7e3d8d61ec87', 'Polynômes du second degré', 'Somme et produit des racines', '2025-12-06 16:06:55.251001+00'),
    ('fc0aadc9-f743-42bd-9660-0900628fa1ac', 'Probabilités conditionnelles', 'Arbres pondérés', '2025-12-06 16:06:55.251001+00'),
    ('6a7c7fa1-41a6-4df6-ad2f-0b7f0ea319ca', 'Probabilités conditionnelles', 'Formule des probabilités totales', '2025-12-06 16:06:55.251001+00'),
    ('c7b90157-1a51-4b9d-81ff-72ca12f59be4', 'Probabilités conditionnelles', 'Indépendance de deux événements', '2025-12-06 16:06:55.251001+00'),
    ('aa9630f8-8715-4f96-8f92-0cdac577f217', 'Probabilités conditionnelles', 'Notation P_A(B)', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('79ded951-20a4-4693-82e6-a4ad6a5236af', 'Probabilités conditionnelles', 'Partition de l''univers', '2025-12-06 16:06:55.251001+00'),
    ('2dd339f9-7fc1-430c-89b5-de6a9f7b7881', 'Probabilités conditionnelles', 'Succession de deux épreuves indépendantes', '2025-12-06 16:06:55.251001+00'),
    ('0ce60bed-03cc-443f-b61a-e12fe8557c5c', 'Produit scalaire', 'Bilinéarité et symétrie', '2025-12-06 16:06:55.251001+00'),
    ('e3d58e83-fbaf-415e-b523-eb79a7522d06', 'Produit scalaire', 'Définition à partir de la projection orthogonale', '2025-12-06 16:06:55.251001+00'),
    ('1c118c50-1f6e-4789-891f-3b557543892f', 'Produit scalaire', 'Expression dans une base orthonormée', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('5fb07d8a-777f-41ab-9ea9-ade2cbd71803', 'Produit scalaire', 'Formule avec le cosinus', '2025-12-06 16:06:55.251001+00'),
    ('0f030ef0-9bb7-421e-b903-668636a91104', 'Produit scalaire', 'Théorème d''Al-Kashi', '2025-12-06 16:06:55.251001+00'),
    ('9182c0fa-d401-4459-9c45-d02a855e06c1', 'Produit scalaire', 'Transformation d''écritures vectorielles', '2025-12-06 16:06:55.251001+00'),
    ('508c45c9-d3fc-4004-aa1a-612f1ed69d67', 'Suites numériques', 'Limite intuitive (convergence, divergence vers l''infini)', '2025-12-06 16:06:55.251001+00'),
    ('02831d8c-c829-4d36-a588-7e101accc22e', 'Suites numériques', 'Modes de génération (explicite, récurrence)', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('a3c2f392-5381-4b16-80c1-0f7e6c7c152a', 'Suites numériques', 'Représentation graphique', '2025-12-06 16:06:55.251001+00'),
    ('98cceea7-a010-41dd-94bd-ef1a25052828', 'Suites numériques', 'Sens de variation', '2025-12-06 16:06:55.251001+00'),
    ('b6f73bcb-3039-4989-ab33-24a793e5dfe7', 'Suites numériques', 'Suites arithmétiques', '2025-12-06 16:06:55.251001+00'),
    ('c90381c9-a336-452c-9037-af7e90303947', 'Suites numériques', 'Suites géométriques', '2025-12-06 16:06:55.251001+00'),
    ('b8eba4f0-59e3-477a-99ed-36bdc50cf707', 'Variables aléatoires réelles', 'Définition (fonction sur l''univers)', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('ebda8455-efa8-4dd5-9e0a-b934e3484914', 'Variables aléatoires réelles', 'Espérance', '2025-12-06 16:06:55.251001+00'),
    ('6de38e77-8db0-495b-a05d-7fd0367df78a', 'Variables aléatoires réelles', 'Loi de probabilité', '2025-12-06 16:06:55.251001+00'),
    ('2b30be60-33ea-4233-9e97-71ef0e3fdac3', 'Variables aléatoires réelles', 'Variance et écart-type', '2025-12-06 16:06:55.251001+00'),
    ('1f8b6e96-6d26-4d95-aa38-46d868ac30de', 'Vocabulaire ensembliste et logique', 'Complémentaire d''une partie', '2025-12-06 16:06:55.251001+00'),
    ('d91726ad-e29c-4a7a-b038-6e41ead3cf66', 'Vocabulaire ensembliste et logique', 'Condition nécessaire et condition suffisante', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('cb9b6a36-d1b1-4620-95b5-5cd69ff5a664', 'Vocabulaire ensembliste et logique', 'Connecteurs logiques "et" / "ou"', '2025-12-06 16:06:55.251001+00'),
    ('963cdffb-080b-4b71-8d3e-b8ef1c1378c2', 'Vocabulaire ensembliste et logique', 'Couple et produit cartésien', '2025-12-06 16:06:55.251001+00'),
    ('be6ba67b-6d92-473d-9102-3bad45f59730', 'Vocabulaire ensembliste et logique', 'Négation de propositions quantifiées', '2025-12-06 16:06:55.251001+00'),
    ('0868aab0-64e7-446d-8259-c0b608a0f69c', 'Vocabulaire ensembliste et logique', 'Quantificateurs (universel et existentiel)', '2025-12-06 16:06:55.251001+00'),
    ('eadf40f4-dec1-4469-a72b-778f2eda4c41', 'Vocabulaire ensembliste et logique', 'Raisonnements (par disjonction de cas, par l''absurde, par contraposée)', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_premiere (id, chapitre, sous_notion, created_at) VALUES
    ('afd0e829-5936-48c3-9947-af8f5b2c4bd7', 'Vocabulaire ensembliste et logique', 'Statut des égalités (identité / équation)', '2025-12-06 16:06:55.251001+00'),
    ('17786fdc-2a47-4eef-a5ae-9a8eae7f4bcd', 'Vocabulaire ensembliste et logique', 'Statut des lettres (variable / inconnue / paramètre)', '2025-12-06 16:06:55.251001+00');

-- ============================================================
-- SECTION 8: SEQUENCES
-- ============================================================
-- (Pas de sequence pour cette table - id est uuid avec gen_random_uuid())

-- ============================================================
-- FIN DE L'EXPORT
-- ============================================================

