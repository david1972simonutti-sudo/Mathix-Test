-- ============================================================
-- TABLE: bo_seconde
-- Export date: 2026-01-16
-- Total rows: 54
-- ============================================================

-- ============================================================
-- SECTION 1: STRUCTURE (CREATE TABLE)
-- ============================================================

DROP TABLE IF EXISTS public.bo_seconde CASCADE;

CREATE TABLE public.bo_seconde (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    chapitre text NOT NULL,
    sous_notion text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT bo_seconde_pkey PRIMARY KEY (id),
    CONSTRAINT bo_seconde_chapitre_sous_notion_key UNIQUE (chapitre, sous_notion)
);

-- ============================================================
-- SECTION 2: FOREIGN KEYS
-- ============================================================
-- (Aucune foreign key pour cette table)

-- ============================================================
-- SECTION 3: INDEX
-- ============================================================
-- Les index sont crees automatiquement via les contraintes PRIMARY KEY et UNIQUE
-- CREATE UNIQUE INDEX bo_seconde_pkey ON public.bo_seconde USING btree (id);
-- CREATE UNIQUE INDEX bo_seconde_chapitre_sous_notion_key ON public.bo_seconde USING btree (chapitre, sous_notion);

-- ============================================================
-- SECTION 4: ROW LEVEL SECURITY
-- ============================================================

ALTER TABLE public.bo_seconde ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- SECTION 5: POLICIES
-- ============================================================

CREATE POLICY "Lecture publique bo_seconde"
    ON public.bo_seconde
    FOR SELECT
    TO public
    USING (true);

-- ============================================================
-- SECTION 6: TRIGGERS
-- ============================================================
-- (Aucun trigger pour cette table)

-- ============================================================
-- SECTION 7: DONNEES (54 lignes, par lots de 5)
-- ============================================================

INSERT INTO public.bo_seconde (id, chapitre, sous_notion, created_at) VALUES
    ('8218b673-6ff7-4773-805d-28144d28f647', 'Concevoir et utiliser des fonctions', 'Fonctions avec arguments', '2025-12-06 16:06:55.251001+00'),
    ('66484676-4604-4c7e-9474-03edd061c8a3', 'Concevoir et utiliser des fonctions', 'Fonctions Python de generation aleatoire', '2025-12-06 16:06:55.251001+00'),
    ('5e2a6982-59e1-48dd-be99-0caf7d7366e2', 'Echantillonnage', 'Loi des grands nombres', '2025-12-06 16:06:55.251001+00'),
    ('46cab3c0-f36f-4f0c-8040-942d417e951b', 'Echantillonnage', 'Principe de l''estimation', '2025-12-06 16:06:55.251001+00'),
    ('8e987a39-bb5b-4692-bff5-755b83d92c1b', 'Exploiter la notion d''information chiffree', 'Ecart-type', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_seconde (id, chapitre, sous_notion, created_at) VALUES
    ('85782a36-270d-488a-bd88-75ca9bf63fef', 'Exploiter la notion d''information chiffree', 'Evolutions successives et reciproques', '2025-12-06 16:06:55.251001+00'),
    ('24e0635f-9b38-4cd1-952f-e9da031a5c23', 'Exploiter la notion d''information chiffree', 'Moyenne ponderee', '2025-12-06 16:06:55.251001+00'),
    ('125eaf18-95cb-4a4a-a1de-44f67b10e3b5', 'Exploiter la notion d''information chiffree', 'Proportions et pourcentages', '2025-12-06 16:06:55.251001+00'),
    ('7910481a-8d61-4433-b481-a52401420a4c', 'Manipuler les nombres reels', 'Encadrements et approximations', '2025-12-06 16:06:55.251001+00'),
    ('693a357d-b90a-4aef-8e6c-e1a4623fe985', 'Manipuler les nombres reels', 'Ensemble R et ses sous-ensembles', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_seconde (id, chapitre, sous_notion, created_at) VALUES
    ('177ed4c9-0078-44e1-ba91-18304d8380c2', 'Manipuler les nombres reels', 'Intervalles de R', '2025-12-06 16:06:55.251001+00'),
    ('148c0065-ad4f-4e26-9bdb-0b576fe3e2a1', 'Manipuler les nombres reels', 'Nombres rationnels et irrationnels', '2025-12-06 16:06:55.251001+00'),
    ('cc462853-fd45-4711-ac71-d1997115f554', 'Manipuler les nombres reels', 'Valeur absolue', '2025-12-06 16:06:55.251001+00'),
    ('91e85105-5285-42aa-b3cf-bb322511f86b', 'Manipuler les vecteurs du plan', 'Colinearite', '2025-12-06 16:06:55.251001+00'),
    ('02883bb5-cea9-45c0-a5ef-bc17e6204ec4', 'Manipuler les vecteurs du plan', 'Coordonnees dans un repere', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_seconde (id, chapitre, sous_notion, created_at) VALUES
    ('b65a1f47-2fc0-4da5-a471-bcd61e62d702', 'Manipuler les vecteurs du plan', 'Determinant de deux vecteurs', '2025-12-06 16:06:55.251001+00'),
    ('115a4761-4c8e-4d7c-9c3a-8a209e116951', 'Manipuler les vecteurs du plan', 'Somme de vecteurs', '2025-12-06 16:06:55.251001+00'),
    ('822fbee0-f401-499b-abcf-5e70b35a0321', 'Modeliser le hasard', 'Denombrement par arbres ou tableaux', '2025-12-06 16:06:55.251001+00'),
    ('b3528424-6ae0-4571-b0ee-23073231fa7f', 'Modeliser le hasard', 'Loi de probabilite', '2025-12-06 16:06:55.251001+00'),
    ('297b4a34-2623-48f1-87ca-74868e488b8f', 'Modeliser le hasard', 'Reunion, intersection, contraire', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_seconde (id, chapitre, sous_notion, created_at) VALUES
    ('b9375a48-50b5-49d1-a413-17c09af4e06a', 'Modeliser le hasard', 'Univers et evenements', '2025-12-06 16:06:55.251001+00'),
    ('1c1e18f6-b3c7-4715-929a-a45a9eb78d72', 'Representer algebriquement et graphiquement les fonctions', 'Courbe representative', '2025-12-06 16:06:55.251001+00'),
    ('157dd3ac-1c9f-4276-baad-84667d21507a', 'Representer algebriquement et graphiquement les fonctions', 'Parite (fonctions paires et impaires)', '2025-12-06 16:06:55.251001+00'),
    ('4892be26-813a-497a-bffe-b98c9bdd5739', 'Representer algebriquement et graphiquement les fonctions', 'Representation graphique', '2025-12-06 16:06:55.251001+00'),
    ('b5801b1a-c75e-42aa-b89c-bbce84440529', 'Representer et caracteriser les droites du plan', 'Equation cartesienne de droite', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_seconde (id, chapitre, sous_notion, created_at) VALUES
    ('d49d2f97-75dd-4a87-9f4d-5d84a5360b50', 'Representer et caracteriser les droites du plan', 'Equation reduite', '2025-12-06 16:06:55.251001+00'),
    ('b6f34514-0cba-41b2-b1a9-9df25e932382', 'Representer et caracteriser les droites du plan', 'Pente et ordonnee a l''origine', '2025-12-06 16:06:55.251001+00'),
    ('6e9bfd4a-3033-4948-9b14-6259f32da6f6', 'Representer et caracteriser les droites du plan', 'Systemes lineaires 2x2', '2025-12-06 16:06:55.251001+00'),
    ('5471e310-06e1-4812-9770-a7515cc63368', 'Resoudre des problemes de geometrie', 'Projete orthogonal d''un point sur une droite', '2025-12-06 16:06:55.251001+00'),
    ('68f553ad-ca80-4210-b7f7-4433c4dabb7d', 'Resoudre des problemes de variations et d''extremum', 'Maximum et minimum', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_seconde (id, chapitre, sous_notion, created_at) VALUES
    ('eaba4e8c-534c-4242-999a-2d7066d075cb', 'Resoudre des problemes de variations et d''extremum', 'Sens de variation', '2025-12-06 16:06:55.251001+00'),
    ('bc3a2cff-7189-45f7-950d-97d1aa584f56', 'Resoudre des problemes de variations et d''extremum', 'Tableau de variations', '2025-12-06 16:06:55.251001+00'),
    ('16a55b50-00b1-4363-8d88-ac2267143ef0', 'Se constituer un repertoire de fonctions de reference', 'Fonction carre', '2025-12-06 16:06:55.251001+00'),
    ('87ccedc1-a650-43af-99d8-8b8d1ab6aa1e', 'Se constituer un repertoire de fonctions de reference', 'Fonction cube', '2025-12-06 16:06:55.251001+00'),
    ('6a236836-b44d-4bb2-8f95-11097ecf2aea', 'Se constituer un repertoire de fonctions de reference', 'Fonction inverse', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_seconde (id, chapitre, sous_notion, created_at) VALUES
    ('9d19699b-ef5b-48f2-9530-0274c940a994', 'Se constituer un repertoire de fonctions de reference', 'Fonction racine carree', '2025-12-06 16:06:55.251001+00'),
    ('5acbe869-64d0-4ace-bfe7-7cec99a096a4', 'Utiliser le calcul litteral', 'Calculs avec radicaux', '2025-12-06 16:06:55.251001+00'),
    ('ea006265-8ddf-4c73-b22f-94d27ba6432f', 'Utiliser le calcul litteral', 'Identites remarquables', '2025-12-06 16:06:55.251001+00'),
    ('80f0c093-7a72-4d3b-87e0-003efc6017d1', 'Utiliser le calcul litteral', 'Puissances entieres et fractionnaires', '2025-12-06 16:06:55.251001+00'),
    ('5f739015-6675-4b49-a93b-a16239605421', 'Utiliser le calcul litteral', 'Resolution d''equations et inequations', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_seconde (id, chapitre, sous_notion, created_at) VALUES
    ('a97906c2-d5ec-4b17-b495-c4a662462406', 'Utiliser les notions de multiple, diviseur et de nombre premier', 'Decomposition en produit de facteurs premiers', '2025-12-06 16:06:55.251001+00'),
    ('4f23a23a-6d4f-4c41-bc34-eb6967f4624c', 'Utiliser les notions de multiple, diviseur et de nombre premier', 'Multiples et diviseurs', '2025-12-06 16:06:55.251001+00'),
    ('89199472-441a-4002-ba84-99b325c2e872', 'Utiliser les notions de multiple, diviseur et de nombre premier', 'Nombres premiers', '2025-12-06 16:06:55.251001+00'),
    ('a20b1d58-1412-4b14-ac81-1c0a14fdd9e9', 'Utiliser les variables et les instructions elementaires', 'Affectation', '2025-12-06 16:06:55.251001+00'),
    ('ec2bb194-68c5-423f-a5a2-0e3fd96337dd', 'Utiliser les variables et les instructions elementaires', 'Boucles (for, while)', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_seconde (id, chapitre, sous_notion, created_at) VALUES
    ('045fbd5e-14b8-4b9f-bcaa-f9d9b7dcd3b9', 'Utiliser les variables et les instructions elementaires', 'Instructions conditionnelles (if)', '2025-12-06 16:06:55.251001+00'),
    ('0b608a04-665b-40d0-aef4-f875e02a16df', 'Utiliser les variables et les instructions elementaires', 'Types de variables', '2025-12-06 16:06:55.251001+00'),
    ('5239cde0-fde6-4086-a83f-742d8a817c98', 'Vocabulaire ensembliste et logique', 'Appartenance, inclusion', '2025-12-06 16:06:55.251001+00'),
    ('9714b538-8bb6-46de-b6ad-8e1687214874', 'Vocabulaire ensembliste et logique', 'Contre-exemples', '2025-12-06 16:06:55.251001+00'),
    ('7f51d525-ef3c-48c6-8dd3-421f16a900c3', 'Vocabulaire ensembliste et logique', 'Couples et produit cartesien', '2025-12-06 16:06:55.251001+00');

INSERT INTO public.bo_seconde (id, chapitre, sous_notion, created_at) VALUES
    ('6151c166-8df8-4254-bbd5-1be5ad702f02', 'Vocabulaire ensembliste et logique', 'Implication', '2025-12-06 16:06:55.251001+00'),
    ('56e63ddf-e310-4626-a8cf-6d6f7bc9d974', 'Vocabulaire ensembliste et logique', 'Intersection, reunion', '2025-12-06 16:06:55.251001+00'),
    ('9111ee55-f890-43b4-b4d0-641c5c2dba0c', 'Vocabulaire ensembliste et logique', 'Propositions et negation', '2025-12-06 16:06:55.251001+00'),
    ('03b7746b-0658-4d78-9138-be8c92411392', 'Vocabulaire ensembliste et logique', 'Quantificateurs universel et existentiel', '2025-12-06 16:06:55.251001+00');

-- ============================================================
-- SECTION 8: SEQUENCES
-- ============================================================
-- (Pas de sequence - la colonne id utilise gen_random_uuid())

-- ============================================================
-- FIN DE L'EXPORT bo_seconde
-- ============================================================

