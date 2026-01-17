-- ============================================================
-- TABLE: bo_terminale
-- Export date: 2026-01-16
-- Total rows: 79
-- ============================================================

-- ============================================================
-- SECTION 1: STRUCTURE
-- ============================================================

DROP TABLE IF EXISTS public.bo_terminale CASCADE;

CREATE TABLE public.bo_terminale (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    chapitre text NOT NULL,
    sous_notion text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT bo_terminale_pkey PRIMARY KEY (id),
    CONSTRAINT bo_terminale_chapitre_sous_notion_key UNIQUE (chapitre, sous_notion)
);

-- ============================================================
-- SECTION 2: FOREIGN KEYS
-- ============================================================
-- (Aucune foreign key pour cette table)

-- ============================================================
-- SECTION 3: INDEX
-- ============================================================
-- Les index pkey et unique sont créés automatiquement via les contraintes
-- CREATE UNIQUE INDEX bo_terminale_pkey ON public.bo_terminale USING btree (id);
-- CREATE UNIQUE INDEX bo_terminale_chapitre_sous_notion_key ON public.bo_terminale USING btree (chapitre, sous_notion);

-- ============================================================
-- SECTION 4: ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE public.bo_terminale ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- SECTION 5: POLICIES
-- ============================================================

CREATE POLICY "Lecture publique bo_terminale"
    ON public.bo_terminale
    FOR SELECT
    TO public
    USING (true);

-- ============================================================
-- SECTION 6: TRIGGERS
-- ============================================================
-- (Aucun trigger pour cette table)

-- ============================================================
-- SECTION 7: DONNEES (79 lignes)
-- ============================================================

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('183599f4-eaba-4d5c-a745-5a84958bd281', 'Calcul intégral', 'Calcul d''intégrale à l''aide de primitives', '2025-12-06 16:06:55.251001+00'),
    ('06e8c308-ec3c-480f-acc6-4620b73cfde5', 'Calcul intégral', 'Intégrale d''une fonction continue positive', '2025-12-06 16:06:55.251001+00'),
    ('bee0ad44-2415-47cd-977b-1b09970d372f', 'Calcul intégral', 'Intégration par parties', '2025-12-06 16:06:55.251001+00'),
    ('b23dd02a-134e-426d-bb9a-6ee8bd51ac4f', 'Calcul intégral', 'Linéarité de l''intégrale', '2025-12-06 16:06:55.251001+00'),
    ('4b49d9c1-e77d-4858-9d5a-784190621ad4', 'Calcul intégral', 'Notation ∫ₐᵇ f(x)dx', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('dc99b988-014a-4264-a82c-7c5ad661b7fd', 'Calcul intégral', 'Primitive s''annulant en a', '2025-12-06 16:06:55.251001+00'),
    ('b32b0bd7-62bb-49c2-a4c4-5c75b7adf7c3', 'Calcul intégral', 'Relation de Chasles', '2025-12-06 16:06:55.251001+00'),
    ('532928f2-36de-41b4-b227-b1249e3da60d', 'Calcul intégral', 'Valeur moyenne', '2025-12-06 16:06:55.251001+00'),
    ('a2f54739-ca75-45f2-b674-5a4b0529a1be', 'Combinatoire et dénombrement', 'Combinaisons', '2025-12-06 16:06:55.251001+00'),
    ('68d0e22f-7df0-47ba-9dab-df38f0483675', 'Combinatoire et dénombrement', 'k-uplets', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('c1947f63-c100-4425-83f5-0693c50581c5', 'Combinatoire et dénombrement', 'Nombre de parties d''un ensemble fini', '2025-12-06 16:06:55.251001+00'),
    ('ccfbc1ac-d02f-4639-9c7e-c71877b1972c', 'Combinatoire et dénombrement', 'Permutations et factorielle', '2025-12-06 16:06:55.251001+00'),
    ('a4d88e8b-68de-4064-9f3b-0da2d22d6c51', 'Combinatoire et dénombrement', 'Principe additif et principe multiplicatif', '2025-12-06 16:06:55.251001+00'),
    ('8bcd64c1-0f9e-4b74-b44a-de1e41cded7d', 'Combinatoire et dénombrement', 'Triangle de Pascal', '2025-12-06 16:06:55.251001+00'),
    ('0822f928-9e36-46a9-b851-90b76952b8a1', 'Compléments sur la dérivation', 'Convexité', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('515a02e7-6601-4eaa-9b3c-3a5e218a44c9', 'Compléments sur la dérivation', 'Dérivée d''une fonction composée', '2025-12-06 16:06:55.251001+00'),
    ('4b019206-d032-434f-b5fe-0452d4b5aeb2', 'Compléments sur la dérivation', 'Dérivée seconde', '2025-12-06 16:06:55.251001+00'),
    ('e5dc1d13-36e5-40a2-b008-c53164042783', 'Compléments sur la dérivation', 'Point d''inflexion', '2025-12-06 16:06:55.251001+00'),
    ('ac8d002f-a757-42f9-a118-6e02d5cd4454', 'Concentration et loi des grands nombres', 'Inégalité de Bienaymé-Tchebychev', '2025-12-06 16:06:55.251001+00'),
    ('ea86fabf-739c-4161-9e7d-7e0c5a77482d', 'Concentration et loi des grands nombres', 'Inégalité de concentration', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('fb886850-c2d1-4d1a-8723-7d671ce02bc6', 'Concentration et loi des grands nombres', 'Loi des grands nombres', '2025-12-06 16:06:55.251001+00'),
    ('0a2fae4f-a20b-4211-a7c2-412c9d970da3', 'Continuité', 'Cas des fonctions continues strictement monotones', '2025-12-06 16:06:55.251001+00'),
    ('7f8fcf0d-be73-4bf4-9eb6-52adb4ad8ef3', 'Continuité', 'Définition par les limites', '2025-12-06 16:06:55.251001+00'),
    ('c2a1acf2-7084-4f68-942e-6252c2768fec', 'Continuité', 'Fonction dérivable continue', '2025-12-06 16:06:55.251001+00'),
    ('a0ddf86f-37e0-484e-a76d-90fcac982e8f', 'Continuité', 'Image d''une suite convergente', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('3ec2f417-c4a7-4ec9-ae28-c7160ba186d4', 'Continuité', 'Théorème des valeurs intermédiaires', '2025-12-06 16:06:55.251001+00'),
    ('f4c98264-84ac-48c9-a5e2-ae45de1c8934', 'Fonction logarithme népérien', 'Croissances comparées', '2025-12-06 16:06:55.251001+00'),
    ('eaf83200-4921-4946-b0f7-64949361f974', 'Fonction logarithme népérien', 'Dérivée', '2025-12-06 16:06:55.251001+00'),
    ('a748cc50-28b3-4d86-a4e6-8ef5807823cb', 'Fonction logarithme népérien', 'Fonction réciproque de l''exponentielle', '2025-12-06 16:06:55.251001+00'),
    ('15899aac-35ab-4ab1-a215-b996f4ffa191', 'Fonction logarithme népérien', 'Limites en 0 et en +∞', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('e78efe34-b3b3-4784-a47f-86d9e428e468', 'Fonction logarithme népérien', 'Propriétés algébriques', '2025-12-06 16:06:55.251001+00'),
    ('42e3381a-3dd0-4c19-b089-12659e17c45e', 'Fonctions sinus et cosinus', 'Dérivées', '2025-12-06 16:06:55.251001+00'),
    ('9d1cc0eb-8255-4ea2-b5a2-710a0b757396', 'Fonctions sinus et cosinus', 'Résolution d''équations trigonométriques', '2025-12-06 16:06:55.251001+00'),
    ('d9558ccc-26b4-49ec-926c-9be154f6c884', 'Fonctions sinus et cosinus', 'Variations', '2025-12-06 16:06:55.251001+00'),
    ('0aebecc9-e98b-45e8-8433-0580180c538f', 'Géométrie repérée dans l''espace', 'Équation cartésienne d''un plan', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('dd86ea20-2987-4da8-a48d-c97f603c6978', 'Géométrie repérée dans l''espace', 'Représentation paramétrique d''une droite', '2025-12-06 16:06:55.251001+00'),
    ('1aa3a66e-6f6e-4275-986d-93e1ffa2ef58', 'Géométrie repérée dans l''espace', 'Systèmes d''équations linéaires', '2025-12-06 16:06:55.251001+00'),
    ('e6aa76fc-a1f5-4678-8efb-799ceecd712b', 'Limites de fonctions', 'Asymptotes', '2025-12-06 16:06:55.251001+00'),
    ('9e14303f-05f2-4924-8ade-17f8a61da140', 'Limites de fonctions', 'Croissances comparées', '2025-12-06 16:06:55.251001+00'),
    ('27570cc6-c266-4727-9483-5cd6f06fef56', 'Limites de fonctions', 'Limite finie ou infinie en l''infini ou en un point', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('a45b00fc-2318-4bb0-8572-6bc82116a66d', 'Limites de fonctions', 'Opérations sur les limites', '2025-12-06 16:06:55.251001+00'),
    ('a7a98528-2ef3-4205-9b5e-f654240b730a', 'Manipuler les listes', 'Génération par extension et en compréhension', '2025-12-06 16:06:55.251001+00'),
    ('c05379ce-e413-46e8-a8d1-39c53294db73', 'Manipuler les listes', 'Itération sur les éléments', '2025-12-06 16:06:55.251001+00'),
    ('caf8f36a-fd40-4555-bbc8-f6dfe736e8d8', 'Manipuler les listes', 'Manipulation d''éléments et d''indices', '2025-12-06 16:06:55.251001+00'),
    ('3e77cb30-12d7-44a7-a6ba-d72de671821e', 'Manipuler les listes', 'Parcours de listes', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('83c3d5ad-d8e4-4066-8661-c3aa231f71a0', 'Manipuler les vecteurs de l''espace', 'Coplanarité', '2025-12-06 16:06:55.251001+00'),
    ('0172cd4f-d79e-4d10-9b99-4b87e5d9a2a0', 'Manipuler les vecteurs de l''espace', 'Décomposition dans une base', '2025-12-06 16:06:55.251001+00'),
    ('a17f6990-3d74-4ad6-8fe6-dd0b2ecd498b', 'Manipuler les vecteurs de l''espace', 'Repérage dans l''espace', '2025-12-06 16:06:55.251001+00'),
    ('90018ad9-38a2-4f0c-89db-11ce3de7fc7f', 'Manipuler les vecteurs de l''espace', 'Translation dans l''espace', '2025-12-06 16:06:55.251001+00'),
    ('60c0ac25-7a02-4758-8f8b-5b745eca4471', 'Primitives et équations différentielles', 'Équations différentielles y'' = ay', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('6bff84a8-a50a-490d-bac9-15f40311d0bc', 'Primitives et équations différentielles', 'Équations différentielles y'' = ay + b', '2025-12-06 16:06:55.251001+00'),
    ('e00f58ef-614b-4c83-85b3-b5ee9e4c062c', 'Primitives et équations différentielles', 'Équations du type y'' = f', '2025-12-06 16:06:55.251001+00'),
    ('10922707-e6d5-4fee-bf45-c73c40be0625', 'Primitives et équations différentielles', 'Primitives des fonctions usuelles', '2025-12-06 16:06:55.251001+00'),
    ('129b731b-c385-49a8-97e0-0e5c8393d48e', 'Produit scalaire dans l''espace', 'Définition et propriétés', '2025-12-06 16:06:55.251001+00'),
    ('6c5a3c48-5d69-4d8c-a0a7-b60e9772a045', 'Produit scalaire dans l''espace', 'Expression dans une base orthonormée', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('a212c15d-3846-43ff-8e25-4939fc56659c', 'Produit scalaire dans l''espace', 'Orthogonalité dans l''espace', '2025-12-06 16:06:55.251001+00'),
    ('cd50c779-e078-4ce9-8b39-a479b1f372e8', 'Produit scalaire dans l''espace', 'Projeté orthogonal sur un plan', '2025-12-06 16:06:55.251001+00'),
    ('b003fe82-4eaf-436e-8597-bb1713818610', 'Produit scalaire dans l''espace', 'Vecteur normal à un plan', '2025-12-06 16:06:55.251001+00'),
    ('5fdc05ec-36e5-43be-94a8-84886e1585d1', 'Sommes de variables aléatoires', 'Échantillon et moyenne empirique', '2025-12-06 16:06:55.251001+00'),
    ('f3cec32a-1558-4ae9-9557-098e81153393', 'Sommes de variables aléatoires', 'Linéarité de l''espérance', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('61077f52-b91f-40e7-8d15-5e829071d637', 'Sommes de variables aléatoires', 'Loi binomiale (espérance, variance, écart-type)', '2025-12-06 16:06:55.251001+00'),
    ('59c147d7-9fe3-45e5-a4b7-e097529922c8', 'Sommes de variables aléatoires', 'Variance de sommes (cas indépendant)', '2025-12-06 16:06:55.251001+00'),
    ('b3151181-a346-4d2f-91d1-c8ac4321abb0', 'Succession d''épreuves indépendantes (schéma de Bernoulli)', 'Coefficients binomiaux', '2025-12-06 16:06:55.251001+00'),
    ('d60bf596-0fe9-4ed1-ae2a-908467e15d3c', 'Succession d''épreuves indépendantes (schéma de Bernoulli)', 'Épreuve de Bernoulli', '2025-12-06 16:06:55.251001+00'),
    ('8b394fdc-3700-4283-b9b1-6c1f5b4cc59c', 'Succession d''épreuves indépendantes (schéma de Bernoulli)', 'Loi binomiale', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('378ebe63-ad6a-456f-912c-a93c8a6cdc7d', 'Succession d''épreuves indépendantes (schéma de Bernoulli)', 'Schéma de Bernoulli', '2025-12-06 16:06:55.251001+00'),
    ('851add57-d982-48ed-b218-9c77ce47fc02', 'Suites numériques', 'Convergence et divergence', '2025-12-06 16:06:55.251001+00'),
    ('bb6aeb08-4a90-4376-bbe4-25b8e3aa34b2', 'Suites numériques', 'Limite de q^n', '2025-12-06 16:06:55.251001+00'),
    ('96190d80-3fa5-4d3e-8a5b-36095ab29432', 'Suites numériques', 'Limite finie ou infinie', '2025-12-06 16:06:55.251001+00'),
    ('aa2aeec4-67ec-48d7-b5ac-6fec72c753b0', 'Suites numériques', 'Limites et comparaison', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('089a3407-4c54-4554-a9fc-c613260c9878', 'Suites numériques', 'Opérations sur les limites', '2025-12-06 16:06:55.251001+00'),
    ('5c74e4c7-dec3-4fbc-9e25-ff1a5097af4c', 'Suites numériques', 'Suite croissante majorée', '2025-12-06 16:06:55.251001+00'),
    ('2d1d10ad-7021-493e-abc9-cb0ff6d5302f', 'Suites numériques', 'Théorème des gendarmes', '2025-12-06 16:06:55.251001+00'),
    ('56d4b18e-7875-462a-8ef9-6d869b2abd30', 'Vocabulaire ensembliste et logique', 'Condition nécessaire et suffisante', '2025-12-06 16:06:55.251001+00'),
    ('d2edb907-b4bf-4357-98bd-7186881a9912', 'Vocabulaire ensembliste et logique', 'Contraposée, équivalence', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_terminale (id, chapitre, sous_notion, created_at) VALUES
    ('394e11a1-621b-4ecf-9354-b41aab41683f', 'Vocabulaire ensembliste et logique', 'k-uplet et produit cartésien', '2025-12-06 16:06:55.251001+00'),
    ('d4c2c367-b49e-4e46-83d0-ca61af51f073', 'Vocabulaire ensembliste et logique', 'Négation de propositions avec quantificateurs', '2025-12-06 16:06:55.251001+00'),
    ('f7b404ef-6879-4f77-99c9-8fdd0f855957', 'Vocabulaire ensembliste et logique', 'Propriété caractéristique', '2025-12-06 16:06:55.251001+00'),
    ('623a36fc-e96b-4d54-8b26-0cdd5431c67a', 'Vocabulaire ensembliste et logique', 'Raisonnement par récurrence', '2025-12-06 16:06:55.251001+00');

-- ============================================================
-- SECTION 8: SEQUENCES
-- ============================================================
-- (Pas de séquence pour cette table - id est uuid avec gen_random_uuid())

-- ============================================================
-- FIN DE L'EXPORT
-- ============================================================

