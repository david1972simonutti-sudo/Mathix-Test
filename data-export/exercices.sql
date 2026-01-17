-- ============================================
-- TABLE: exercices
-- Export date: 2026-01-16T17:35:17.846Z
-- Total rows: 391
-- ============================================

-- Drop existing table
DROP TABLE IF EXISTS public.exercices CASCADE;

-- ============================================
-- CREATE TABLE
-- ============================================
CREATE TABLE public.exercices (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    chapitre text NOT NULL,
    niveau text NOT NULL,
    enonce text NOT NULL,
    solution text NOT NULL,
    indices jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    content_hash text,
    params jsonb DEFAULT '{}'::jsonb,
    CONSTRAINT exercices_pkey PRIMARY KEY (id),
    CONSTRAINT exercices_content_hash_key UNIQUE (content_hash)
);

-- ============================================
-- FOREIGN KEYS
-- ============================================
-- No foreign keys on this table

-- ============================================
-- INDEXES
-- ============================================
CREATE INDEX idx_exercices_content_hash ON public.exercices USING btree (content_hash);

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================
ALTER TABLE public.exercices ENABLE ROW LEVEL SECURITY;

-- ============================================
-- POLICIES
-- ============================================
CREATE POLICY "Everyone can view exercices" ON public.exercices
    FOR SELECT
    USING (true);

-- ============================================
-- TRIGGERS
-- ============================================
-- No triggers on this table

-- ============================================
-- DATA (391 rows, batches of 2)
-- ============================================

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('cabe603e-ddfb-42ad-a792-b9eec9144aee', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 2$ et pour tout entier naturel $n$, $U_{n+1} = 3U_n - 4$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$, $U_3$.","On conjecture que pour tout entier naturel $n$, $U_n = 3^n + 1$. Vérifie que cette formule est vraie pour $U_0$, $U_1$, $U_2$ et $U_3$.","Pour la démonstration par récurrence, quelle est exactement la propriété $P(n)$ que tu dois démontrer ?","Vérifie l''étape d''initialisation : la propriété $P(0)$ est-elle vraie ?","Suppose que la propriété $P(n)$ est vraie pour un certain entier $n$. Démontre alors que $P(n+1)$ est vraie.","Conclus sur la validité de la démonstration par récurrence."]}', '1. Calcul des premiers termes :
$U_0 = 2$
$U_1 = 3U_0 - 4 = 3(2) - 4 = 6 - 4 = 2$
$U_2 = 3U_1 - 4 = 3(2) - 4 = 6 - 4 = 2$
$U_3 = 3U_2 - 4 = 3(2) - 4 = 6 - 4 = 2$

2. Vérification de la formule $U_n = 3^n + 1$ :
Pour $n=0$: $U_0 = 3^0 + 1 = 1 + 1 = 2$. C''est vrai.
Pour $n=1$: $U_1 = 3^1 + 1 = 3 + 1 = 4$. Or, nous avons trouvé $U_1 = 2$. La conjecture est fausse.

Note : Il y a une erreur dans la conjecture proposée. La suite est en fait une suite constante $U_n = 2$.

Reprenons avec une conjecture correcte si la suite était différente, par exemple si $U_0 = 2$ et $U_{n+1} = 2U_n - 1$ et l''on conjecture $U_n = 2^n + 1$ :

3. La propriété $P(n)$ à démontrer est : "$U_n = 3^n + 1$".

4. Initialisation :
Pour $n=0$, $P(0)$ est "$U_0 = 3^0 + 1$".
$U_0 = 2$ (donné).
$3^0 + 1 = 1 + 1 = 2$.
Donc $U_0 = 3^0 + 1$. La propriété $P(0)$ est vraie.

5. Hérédité :
Supposons que $P(n)$ est vraie pour un certain entier naturel $n$, c''est-à-dire $U_n = 3^n + 1$ (hypothèse de récurrence).
Nous voulons montrer que $P(n+1)$ est vraie, c''est-à-dire $U_{n+1} = 3^{n+1} + 1$.
Nous savons que $U_{n+1} = 3U_n - 4$ (définition de la suite).
En utilisant l''hypothèse de récurrence ($U_n = 3^n + 1$) :
$U_{n+1} = 3(3^n + 1) - 4$
$U_{n+1} = 3^{n+1} + 3 - 4$
$U_{n+1} = 3^{n+1} - 1$.

Nous constatons que $3^{n+1} - 1$ n''est pas égal à $3^{n+1} + 1$. La propriété $P(n+1)$ n''est donc pas démontrée avec cette conjecture. Il y a une erreur dans l''énoncé de la conjecture.

La suite est en réalité constante : $U_n = 2$ pour tout $n$. Si la conjecture était $U_n = 2$, alors :

3. La propriété $P(n)$ à démontrer est : "$U_n = 2$".

4. Initialisation :
Pour $n=0$, $P(0)$ est "$U_0 = 2$". C''est vrai par définition de la suite.

5. Hérédité :
Supposons que $P(n)$ est vraie pour un certain entier naturel $n$, c''est-à-dire $U_n = 2$ (hypothèse de récurrence).
Nous voulons montrer que $P(n+1)$ est vraie, c''est-à-dire $U_{n+1} = 2$.
Nous savons que $U_{n+1} = 3U_n - 4$ (définition de la suite).
En utilisant l''hypothèse de récurrence ($U_n = 2$) :
$U_{n+1} = 3(2) - 4$
$U_{n+1} = 6 - 4$
$U_{n+1} = 2$.
La propriété $P(n+1)$ est donc vraie.

6. Conclusion :
Puisque la propriété $P(0)$ est vraie et que si $P(n)$ est vraie alors $P(n+1)$ est vraie, alors par le principe de récurrence, la propriété $P(n)$ est vraie pour tout entier naturel $n$. C''est-à-dire, pour tout entier naturel $n$, $U_n = 2$.', '["Pour calculer $U_1$, utilise la formule $U_{n+1} = 3U_n - 4$ avec $n=0$.","Pour l''initialisation, remplace $n$ par 0 dans la propriété $P(n)$ et vérifie si elle correspond à $U_0$.","Pour l''hérédité, tu dois partir de $U_n = 3^n + 1$ et montrer que $U_{n+1} = 3^{n+1} + 1$."]'::jsonb, '2025-10-19T09:22:34.214125+00:00'::timestamptz, NULL, '{}'::jsonb),
('7071e5ab-3436-45dc-89e3-8db2e6dd5314', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$, $U_3$.","On conjecture que pour tout entier naturel $n$, $U_n = 3^n - \\frac{3}{2}$. Vérifie cette formule pour $U_0$, $U_1$ et $U_2$.","Pour la démonstration par récurrence, quelle est exactement la propriété $P(n)$ que tu dois démontrer ?","Vérifie l''étape d''initialisation : la propriété $P(0)$ est-elle vraie ?","Suppose que la propriété $P(n)$ est vraie pour un certain entier $n$. Démontre alors que $P(n+1)$ est vraie.","Conclus sur la validité de la démonstration par récurrence."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = -2$ et, pour tout entier naturel $n$, par la relation de récurrence $U_{n+1} = 3U_n - 3$."}', '1. Calcul des premiers termes :
$U_0 = -2$
$U_1 = 3U_0 - 3 = 3(-2) - 3 = -6 - 3 = -9$
$U_2 = 3U_1 - 3 = 3(-9) - 3 = -27 - 3 = -30$
$U_3 = 3U_2 - 3 = 3(-30) - 3 = -90 - 3 = -93$

2. Vérification de la formule conjecturée $U_n = 3^n - \frac{3}{2}$ :
Pour $n=0$: $U_0 = 3^0 - \frac{3}{2} = 1 - 1.5 = -0.5$. Cela ne correspond pas à $U_0 = -2$. Il y a une erreur dans la conjecture ou dans mon calcul. Reprenons la formule avec $U_0 = -2$ et $U_n = k \cdot 3^n + c$. 
$U_0 = k+c = -2$
$U_1 = 3k+c = -9$
Donc $(3k+c) - (k+c) = -9 - (-2) \implies 2k = -7 \implies k = -3.5 = -\frac{7}{2}$
$c = -2 - k = -2 - (-\frac{7}{2}) = -2 + \frac{7}{2} = \frac{-4+7}{2} = \frac{3}{2}$
La formule correcte devrait être $U_n = -\frac{7}{2} \cdot 3^n + \frac{3}{2}$.

Reprenons la question avec la formule proposée dans l''énoncé, et vérifions si elle est correcte.
La formule proposée est $U_n = 3^n - \frac{3}{2}$.
Pour $n=0$: $U_0 = 3^0 - \frac{3}{2} = 1 - 1.5 = -0.5$. Or $U_0 = -2$. La formule conjecturée est incorrecte.

Assumons que la formule à démontrer est $U_n = -\frac{7}{2} \cdot 3^n + \frac{3}{2}$ pour les questions suivantes (même si l''énoncé a donné une formule différente, je dois suivre la logique).

3. La propriété $P(n)$ à démontrer est : $U_n = -\frac{7}{2} \cdot 3^n + \frac{3}{2}$.

4. Initialisation :
Pour $n=0$, $U_0 = -\frac{7}{2} \cdot 3^0 + \frac{3}{2} = -\frac{7}{2} + \frac{3}{2} = -\frac{4}{2} = -2$. La propriété $P(0)$ est vraie.

5. Hérédité :
Supposons que $P(n)$ est vraie pour un certain entier $n$, c''est-à-dire $U_n = -\frac{7}{2} \cdot 3^n + \frac{3}{2}$.
Nous devons montrer que $P(n+1)$ est vraie, c''est-à-dire $U_{n+1} = -\frac{7}{2} \cdot 3^{n+1} + \frac{3}{2}$.
On sait que $U_{n+1} = 3U_n - 3$.
En utilisant l''hypothèse de récurrence :
$U_{n+1} = 3 \left( -\frac{7}{2} \cdot 3^n + \frac{3}{2} \right) - 3$
$U_{n+1} = -\frac{7}{2} \cdot 3 \cdot 3^n + 3 \cdot \frac{3}{2} - 3$
$U_{n+1} = -\frac{7}{2} \cdot 3^{n+1} + \frac{9}{2} - \frac{6}{2}$
$U_{n+1} = -\frac{7}{2} \cdot 3^{n+1} + \frac{3}{2}$
La propriété $P(n+1)$ est donc vraie.

6. Conclusion :
La propriété $P(n)$ est vraie pour $n=0$ et elle est héréditaire. Par le principe de récurrence, pour tout entier naturel $n$, $U_n = -\frac{7}{2} \cdot 3^n + \frac{3}{2}$.', '["Pour calculer $U_1$, utilise la formule $U_{n+1} = 3U_n - 3$ avec $n=0$.","Pour l''initialisation, remplace $n$ par 0 dans la formule conjecturée et vérifie si ça correspond à la valeur de $U_0$.","Pour l''hérédité, pars de l''hypothèse $U_n = 3^n - \\frac{3}{2}$ et essaie de retrouver la forme de $U_{n+1}$ en utilisant la relation de récurrence."]'::jsonb, '2025-10-19T09:41:14.490736+00:00'::timestamptz, '9fbdd77e1d6d81c3f845302fcd31fb690d9b88f4ed8607a0d60514b0cf8712ce', '{"a":3,"b":-3,"U0":-2}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('d1feb68b-72b2-4265-aa69-19fdfe7fa1f8', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 7$ et, pour tout entier naturel $n$, par la relation de récurrence $U_{n+1} = 4U_n - 7$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$, $U_3$.","On pose la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n - \\frac{7}{3}$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$.","Déduis-en une expression de $U_n$ en fonction de $n$.","Démontre par récurrence que pour tout entier naturel $n$, $U_n = \\frac{14}{3} \\cdot 4^n + \\frac{7}{3}$."]}', '1. Calcul des premiers termes :
$U_0 = 7$
$U_1 = 4U_0 - 7 = 4(7) - 7 = 28 - 7 = 21$
$U_2 = 4U_1 - 7 = 4(21) - 7 = 84 - 7 = 77$
$U_3 = 4U_2 - 7 = 4(77) - 7 = 308 - 7 = 301$

2. Démonstration que $(V_n)$ est une suite géométrique :
On a $V_n = U_n - \frac{7}{3}$, donc $U_n = V_n + \frac{7}{3}$.
$V_{n+1} = U_{n+1} - \frac{7}{3}$
On sait que $U_{n+1} = 4U_n - 7$.
Donc $V_{n+1} = (4U_n - 7) - \frac{7}{3}$
$V_{n+1} = 4U_n - \frac{21}{3} - \frac{7}{3}$
$V_{n+1} = 4U_n - \frac{28}{3}$
En remplaçant $U_n$ par $V_n + \frac{7}{3}$ :
$V_{n+1} = 4(V_n + \frac{7}{3}) - \frac{28}{3}$
$V_{n+1} = 4V_n + \frac{28}{3} - \frac{28}{3}$
$V_{n+1} = 4V_n$
La suite $(V_n)$ est donc une suite géométrique de raison $q=4$.
Calculons le premier terme $V_0$: $V_0 = U_0 - \frac{7}{3} = 7 - \frac{7}{3} = \frac{21-7}{3} = \frac{14}{3}$.

3. Expression de $V_n$ en fonction de $n$ :
Comme $(V_n)$ est une suite géométrique de raison $q=4$ et de premier terme $V_0 = \frac{14}{3}$, on a :
$V_n = V_0 \cdot q^n = \frac{14}{3} \cdot 4^n$.

4. Déduction de $U_n$ en fonction de $n$ :
On sait que $V_n = U_n - \frac{7}{3}$, donc $U_n = V_n + \frac{7}{3}$.
En remplaçant $V_n$ par son expression :
$U_n = \frac{14}{3} \cdot 4^n + \frac{7}{3}$.

5. Démonstration par récurrence que pour tout entier naturel $n$, $U_n = \frac{14}{3} \cdot 4^n + \frac{7}{3}$ :
Initialisation :
Pour $n=0$, $U_0 = \frac{14}{3} \cdot 4^0 + \frac{7}{3} = \frac{14}{3} \cdot 1 + \frac{7}{3} = \frac{21}{3} = 7$. La propriété est vraie pour $n=0$.

Hérédité :
Supposons que la propriété est vraie pour un certain entier naturel $n$, c''est-à-dire $U_n = \frac{14}{3} \cdot 4^n + \frac{7}{3}$.
Nous voulons montrer que $U_{n+1} = \frac{14}{3} \cdot 4^{n+1} + \frac{7}{3}$.
On sait que $U_{n+1} = 4U_n - 7$.
En utilisant l''hypothèse de récurrence :
$U_{n+1} = 4 \left( \frac{14}{3} \cdot 4^n + \frac{7}{3} \right) - 7$
$U_{n+1} = \frac{14}{3} \cdot 4 \cdot 4^n + 4 \cdot \frac{7}{3} - 7$
$U_{n+1} = \frac{14}{3} \cdot 4^{n+1} + \frac{28}{3} - \frac{21}{3}$
$U_{n+1} = \frac{14}{3} \cdot 4^{n+1} + \frac{7}{3}$.
La propriété est donc vraie pour $n+1$.

Conclusion :
La propriété est vraie pour $n=0$ et elle est héréditaire. Par le principe de récurrence, pour tout entier naturel $n$, $U_n = \frac{14}{3} \cdot 4^n + \frac{7}{3}$.', '["Pour la question 2, exprime $V_{n+1}$ en fonction de $U_{n+1}$, puis remplace $U_{n+1}$ par son expression en fonction de $U_n$. Essaie ensuite de faire apparaître $V_n$.","Pour la question 3, utilise la formule générale du terme de la suite géométrique.","Pour la question 4, tu as l''expression de $V_n$, et tu sais que $V_n = U_n - \\frac{7}{3}$.","Pour la récurrence, n''oublie pas l''initialisation et l''hérédité. L''hypothèse de récurrence sera $U_n = \\frac{14}{3} \\cdot 4^n + \\frac{7}{3}$."]'::jsonb, '2025-10-19T09:41:29.71459+00:00'::timestamptz, '490f365737febc5a398d025feee13e24450f926729529c0d81289ecfb98658c5', '{"a":4,"b":-7,"U0":7}'::jsonb),
('3e52f4cd-b9c5-4c90-9d63-a46049c728e2', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$, $U_3$.","On pose la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n + \\frac{1}{2}$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$.","Déduis-en une expression de $U_n$ en fonction de $n$.","Démontre par récurrence que pour tout entier naturel $n$, $U_n = \\frac{13}{2} \\cdot (-3)^n - \\frac{1}{2}$."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 7$ et, pour tout entier naturel $n$, par la relation de récurrence $U_{n+1} = -3U_n - 2$."}', '1. Calcul des premiers termes :
$U_0 = 7$
$U_1 = -3U_0 - 2 = -3(7) - 2 = -21 - 2 = -23$
$U_2 = -3U_1 - 2 = -3(-23) - 2 = 69 - 2 = 67$
$U_3 = -3U_2 - 2 = -3(67) - 2 = -201 - 2 = -203$

2. Démonstration que $(V_n)$ est une suite géométrique :
On a $V_n = U_n + \frac{1}{2}$, donc $U_n = V_n - \frac{1}{2}$.
$V_{n+1} = U_{n+1} + \frac{1}{2}$
On sait que $U_{n+1} = -3U_n - 2$.
Donc $V_{n+1} = (-3U_n - 2) + \frac{1}{2}$
$V_{n+1} = -3U_n - \frac{4}{2} + \frac{1}{2}$
$V_{n+1} = -3U_n - \frac{3}{2}$
En remplaçant $U_n$ par $V_n - \frac{1}{2}$ :
$V_{n+1} = -3(V_n - \frac{1}{2}) - \frac{3}{2}$
$V_{n+1} = -3V_n + \frac{3}{2} - \frac{3}{2}$
$V_{n+1} = -3V_n$
La suite $(V_n)$ est donc une suite géométrique de raison $q=-3$.
Calculons le premier terme $V_0$: $V_0 = U_0 + \frac{1}{2} = 7 + \frac{1}{2} = \frac{14+1}{2} = \frac{15}{2}$.

3. Expression de $V_n$ en fonction de $n$ :
Comme $(V_n)$ est une suite géométrique de raison $q=-3$ et de premier terme $V_0 = \frac{15}{2}$, on a :
$V_n = V_0 \cdot q^n = \frac{15}{2} \cdot (-3)^n$.

4. Déduction de $U_n$ en fonction de $n$ :
On sait que $V_n = U_n + \frac{1}{2}$, donc $U_n = V_n - \frac{1}{2}$.
En remplaçant $V_n$ par son expression :
$U_n = \frac{15}{2} \cdot (-3)^n - \frac{1}{2}$.

5. Démonstration par récurrence que pour tout entier naturel $n$, $U_n = \frac{15}{2} \cdot (-3)^n - \frac{1}{2}$ :
Initialisation :
Pour $n=0$, $U_0 = \frac{15}{2} \cdot (-3)^0 - \frac{1}{2} = \frac{15}{2} \cdot 1 - \frac{1}{2} = \frac{14}{2} = 7$. La propriété est vraie pour $n=0$.

Hérédité :
Supposons que la propriété est vraie pour un certain entier naturel $n$, c''est-à-dire $U_n = \frac{15}{2} \cdot (-3)^n - \frac{1}{2}$.
Nous voulons montrer que $U_{n+1} = \frac{15}{2} \cdot (-3)^{n+1} - \frac{1}{2}$.
On sait que $U_{n+1} = -3U_n - 2$.
En utilisant l''hypothèse de récurrence :
$U_{n+1} = -3 \left( \frac{15}{2} \cdot (-3)^n - \frac{1}{2} \right) - 2$
$U_{n+1} = \frac{15}{2} \cdot (-3) \cdot (-3)^n + \frac{3}{2} - 2$
$U_{n+1} = \frac{15}{2} \cdot (-3)^{n+1} + \frac{3}{2} - \frac{4}{2}$
$U_{n+1} = \frac{15}{2} \cdot (-3)^{n+1} - \frac{1}{2}$.
La propriété est donc vraie pour $n+1$.

Conclusion :
La propriété est vraie pour $n=0$ et elle est héréditaire. Par le principe de récurrence, pour tout entier naturel $n$, $U_n = \frac{15}{2} \cdot (-3)^n - \frac{1}{2}$.', '["Pour la question 2, exprime $V_{n+1}$ en fonction de $U_{n+1}$, puis remplace $U_{n+1}$ par son expression en fonction de $U_n$. N''oublie pas de simplifier pour faire apparaître $V_n$.","Pour la question 3, utilise la formule générale du terme d''une suite géométrique : $V_n = V_0 \\cdot q^n$.","Pour la question 4, tu as l''expression de $V_n$ et la relation entre $U_n$ et $V_n$. Isole $U_n$.","Pour la récurrence, vérifie bien l''initialisation avec $n=0$. Pour l''hérédité, pars de l''hypothèse de récurrence et utilise la relation $U_{n+1} = -3U_n - 2$."]'::jsonb, '2025-10-19T09:42:05.027816+00:00'::timestamptz, 'de703fb33bcfdf5fd199faf3e83bea3b60ef3059ec563ec7ce05f87f6f1eeedc', '{"a":-3,"b":-2,"U0":7}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('66d07943-a638-45f4-9fa4-075d13acb277', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"questions":["Calcule $U_1$ et $U_2$.","On admet que pour tout $n \\in \\mathbb{N}$, $U_n \\geq 1$. Démontre par récurrence que pour tout entier naturel $n$, $U_n > 1$.","On considère la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = \\frac{U_n - 1}{U_n + 2}$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$.","Déduis-en l''expression de $U_n$ en fonction de $n$.","Vérifie que l''expression de $U_n$ trouvée est compatible avec $U_0 = 5$ et $U_1$ calculé précédemment."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 5$ et, pour tout entier naturel $n$, par la relation de récurrence $U_{n+1} = \\frac{2U_n + 2}{U_n + 3}$."}', '1. Calcul de $U_1$ et $U_2$ :
$U_0 = 5$
$U_1 = \frac{2U_0 + 2}{U_0 + 3} = \frac{2(5) + 2}{5 + 3} = \frac{10 + 2}{8} = \frac{12}{8} = \frac{3}{2}$
$U_2 = \frac{2U_1 + 2}{U_1 + 3} = \frac{2(\frac{3}{2}) + 2}{\frac{3}{2} + 3} = \frac{3 + 2}{\frac{3}{2} + \frac{6}{2}} = \frac{5}{\frac{9}{2}} = 5 \times \frac{2}{9} = \frac{10}{9}$

2. Démonstration par récurrence que pour tout entier naturel $n$, $U_n > 1$ :
Initialisation :
Pour $n=0$, $U_0 = 5$. On a bien $5 > 1$. La propriété est vraie pour $n=0$.

Hérédité :
Supposons que la propriété est vraie pour un certain entier naturel $n$, c''est-à-dire $U_n > 1$.
Nous voulons montrer que $U_{n+1} > 1$.
On a $U_{n+1} - 1 = \frac{2U_n + 2}{U_n + 3} - 1 = \frac{2U_n + 2 - (U_n + 3)}{U_n + 3} = \frac{2U_n + 2 - U_n - 3}{U_n + 3} = \frac{U_n - 1}{U_n + 3}$.
Puisque $U_n > 1$ (hypothèse de récurrence), alors $U_n - 1 > 0$. 
De plus, $U_n > 1 \implies U_n + 3 > 4 > 0$.
Donc, $U_{n+1} - 1 = \frac{U_n - 1}{U_n + 3} > 0$, ce qui implique $U_{n+1} > 1$.
La propriété est donc vraie pour $n+1$.

Conclusion :
La propriété est vraie pour $n=0$ et elle est héréditaire. Par le principe de récurrence, pour tout entier naturel $n$, $U_n > 1$.

3. Démonstration que $(V_n)$ est une suite géométrique :
$V_n = \frac{U_n - 1}{U_n + 2}$
$V_{n+1} = \frac{U_{n+1} - 1}{U_{n+1} + 2}$
On remplace $U_{n+1}$ par son expression : $U_{n+1} = \frac{2U_n + 2}{U_n + 3}$.
$U_{n+1} - 1 = \frac{2U_n + 2}{U_n + 3} - 1 = \frac{2U_n + 2 - (U_n + 3)}{U_n + 3} = \frac{U_n - 1}{U_n + 3}$
$U_{n+1} + 2 = \frac{2U_n + 2}{U_n + 3} + 2 = \frac{2U_n + 2 + 2(U_n + 3)}{U_n + 3} = \frac{2U_n + 2 + 2U_n + 6}{U_n + 3} = \frac{4U_n + 8}{U_n + 3} = \frac{4(U_n + 2)}{U_n + 3}$
Donc, $V_{n+1} = \frac{\frac{U_n - 1}{U_n + 3}}{\frac{4(U_n + 2)}{U_n + 3}} = \frac{U_n - 1}{U_n + 3} \times \frac{U_n + 3}{4(U_n + 2)} = \frac{U_n - 1}{4(U_n + 2)} = \frac{1}{4} \times \frac{U_n - 1}{U_n + 2} = \frac{1}{4} V_n$.
La suite $(V_n)$ est une suite géométrique de raison $q = \frac{1}{4}$.
Calculons le premier terme $V_0$: $V_0 = \frac{U_0 - 1}{U_0 + 2} = \frac{5 - 1}{5 + 2} = \frac{4}{7}$.

4. Expression de $V_n$ en fonction de $n$ :
$V_n = V_0 \cdot q^n = \frac{4}{7} \left(\frac{1}{4}\right)^n$.

5. Déduction de $U_n$ en fonction de $n$ :
On a $V_n = \frac{U_n - 1}{U_n + 2}$.
$V_n(U_n + 2) = U_n - 1$
$V_n U_n + 2V_n = U_n - 1$
$2V_n + 1 = U_n - V_n U_n$
$2V_n + 1 = U_n(1 - V_n)$
$U_n = \frac{2V_n + 1}{1 - V_n}$
On remplace $V_n$ par son expression :
$U_n = \frac{2 \left( \frac{4}{7} \left(\frac{1}{4}\right)^n \right) + 1}{1 - \frac{4}{7} \left(\frac{1}{4}\right)^n} = \frac{\frac{8}{7} \left(\frac{1}{4}\right)^n + 1}{1 - \frac{4}{7} \left(\frac{1}{4}\right)^n}$.
Pour simplifier, on peut multiplier le numérateur et le dénominateur par $7 \cdot 4^n$ :
$U_n = \frac{8 \cdot 1^n + 7 \cdot 4^n}{7 \cdot 4^n - 4 \cdot 1^n} = \frac{8 + 7 \cdot 4^n}{7 \cdot 4^n - 4}$.

6. Vérification de la compatibilité :
Pour $n=0$: $U_0 = \frac{8 + 7 \cdot 4^0}{7 \cdot 4^0 - 4} = \frac{8 + 7}{7 - 4} = \frac{15}{3} = 5$. C''est correct.
Pour $n=1$: $U_1 = \frac{8 + 7 \cdot 4^1}{7 \cdot 4^1 - 4} = \frac{8 + 28}{28 - 4} = \frac{36}{24} = \frac{3}{2}$. C''est correct.', '["Pour la récurrence, l''étape d''initialisation est cruciale. Pour l''hérédité, tu devras manipuler des inégalités.","Pour la suite géométrique, exprime $V_{n+1}$ en fonction de $U_{n+1}$, puis remplace $U_{n+1}$ par son expression en fonction de $U_n$. Ensuite, essaie de faire apparaître $V_n$. N''hésite pas à factoriser.","Pour exprimer $U_n$ en fonction de $n$, isole $U_n$ dans l''expression de $V_n = \\frac{U_n - 1}{U_n + 2}$."]'::jsonb, '2025-10-19T09:43:05.856846+00:00'::timestamptz, 'eab4542d601ec725a63be4010ba450ab0c088b16d2588a4399e85781f0c31d2d', '{"a":2,"b":2,"U0":5}'::jsonb),
('8ccc4723-01d5-4556-84b0-307f72afefd4', 'Suites numériques, récurrence et limites', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = -2$ et, pour tout entier naturel $n$, par la relation de récurrence $U_{n+1} = \\frac{1}{3}U_n + 2$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$, $U_3$.","On considère la fonction $f(x) = \\frac{1}{3}x + 2$. Trace la droite d''équation $y=x$ et la courbe représentative de $f$. Place les premiers termes de la suite sur l''axe des abscisses. Que peux-tu conjecturer sur la monotonie et la convergence de la suite $(U_n)$ ?","Démontre par récurrence que pour tout entier naturel $n$, $U_n < 3$.","Démontre que la suite $(U_n)$ est croissante.","Déduis-en que la suite $(U_n)$ converge. Détermine la limite $L$ de la suite $(U_n)$.","On pose la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n - L$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$, puis déduis-en l''expression de $U_n$ en fonction de $n$.","Vérifie la limite trouvée précédemment en utilisant l''expression de $U_n$ en fonction de $n$."]}', '1. Calcul des premiers termes :
$U_0 = -2$
$U_1 = \frac{1}{3}(-2) + 2 = -\frac{2}{3} + \frac{6}{3} = \frac{4}{3}$
$U_2 = \frac{1}{3}(\frac{4}{3}) + 2 = \frac{4}{9} + \frac{18}{9} = \frac{22}{9}$
$U_3 = \frac{1}{3}(\frac{22}{9}) + 2 = \frac{22}{27} + \frac{54}{27} = \frac{76}{27}$

2. Conjecture graphique :
Les points $(U_n, U_{n+1})$ se rapprochent du point d''intersection de $y=x$ et $y = \frac{1}{3}x + 2$. On peut conjecturer que la suite est croissante et converge vers la limite $L=3$.

3. Démonstration par récurrence que pour tout entier naturel $n$, $U_n < 3$ :
Initialisation :
Pour $n=0$, $U_0 = -2$. On a bien $-2 < 3$. La propriété est vraie pour $n=0$.

Hérédité :
Supposons que la propriété est vraie pour un certain entier naturel $n$, c''est-à-dire $U_n < 3$.
Nous voulons montrer que $U_{n+1} < 3$.
On sait que $U_{n+1} = \frac{1}{3}U_n + 2$.
Puisque $U_n < 3$, alors $\frac{1}{3}U_n < \frac{1}{3}(3) = 1$.
Donc, $U_{n+1} = \frac{1}{3}U_n + 2 < 1 + 2 = 3$.
La propriété est donc vraie pour $n+1$.

Conclusion :
La propriété est vraie pour $n=0$ et elle est héréditaire. Par le principe de récurrence, pour tout entier naturel $n$, $U_n < 3$.

4. Démonstration que la suite $(U_n)$ est croissante :
Étudions le signe de $U_{n+1} - U_n$ :
$U_{n+1} - U_n = (\frac{1}{3}U_n + 2) - U_n = -\frac{2}{3}U_n + 2 = -\frac{2}{3}(U_n - 3)$.
D''après la question précédente, $U_n < 3$, donc $U_n - 3 < 0$. 
Par conséquent, $-\frac{2}{3}(U_n - 3) > 0$.
Donc $U_{n+1} - U_n > 0$, ce qui signifie que la suite $(U_n)$ est croissante.

5. Déduction de la convergence et détermination de la limite $L$ :
La suite $(U_n)$ est croissante et majorée par 3 (d''après la question 3). D''après le théorème de convergence monotone, une suite croissante et majorée converge.
Soit $L$ la limite de la suite $(U_n)$. Puisque $U_{n+1} = \frac{1}{3}U_n + 2$, en passant à la limite, on a :
$L = \frac{1}{3}L + 2$
$L - \frac{1}{3}L = 2$
$\frac{2}{3}L = 2$
$L = 2 \times \frac{3}{2} = 3$.
La limite de la suite $(U_n)$ est $L=3$.

6. Démonstration que $(V_n)$ est une suite géométrique :
On a $V_n = U_n - L = U_n - 3$, donc $U_n = V_n + 3$.
$V_{n+1} = U_{n+1} - 3$
On sait que $U_{n+1} = \frac{1}{3}U_n + 2$.
Donc $V_{n+1} = (\frac{1}{3}U_n + 2) - 3 = \frac{1}{3}U_n - 1$.
En remplaçant $U_n$ par $V_n + 3$ :
$V_{n+1} = \frac{1}{3}(V_n + 3) - 1 = \frac{1}{3}V_n + 1 - 1 = \frac{1}{3}V_n$.
La suite $(V_n)$ est donc une suite géométrique de raison $q = \frac{1}{3}$.
Calculons le premier terme $V_0$: $V_0 = U_0 - 3 = -2 - 3 = -5$.

7. Expression de $V_n$ et $U_n$ en fonction de $n$ :
$V_n = V_0 \cdot q^n = -5 \cdot (\frac{1}{3})^n$.
$U_n = V_n + 3 = -5 \cdot (\frac{1}{3})^n + 3$.

8. Vérification de la limite :
$\lim_{n \to +\infty} U_n = \lim_{n \to +\infty} (-5 \cdot (\frac{1}{3})^n + 3)$.
Puisque $-1 < \frac{1}{3} < 1$, alors $\lim_{n \to +\infty} (\frac{1}{3})^n = 0$.
Donc, $\lim_{n \to +\infty} U_n = -5 \cdot 0 + 3 = 3$. Ce qui correspond bien à la limite trouvée précédemment.', '["Pour la conjecture graphique, observe le comportement des termes de la suite par rapport à la droite $y=x$.","Pour la récurrence, l''initialisation est simple. Pour l''hérédité, utilise le fait que $f$ est croissante.","Pour montrer que la suite est croissante, étudie le signe de $U_{n+1} - U_n$.","Pour trouver la limite, résous l''équation $L = f(L)$.","Pour la suite géométrique, exprime $V_{n+1}$ en fonction de $U_{n+1}$, puis remplace $U_{n+1}$ par son expression en fonction de $U_n$. Simplifie pour faire apparaître $V_n$.","Pour la dernière question, utilise le fait que si $|q| < 1$, alors $q^n$ tend vers 0 quand $n$ tend vers l''infini."]'::jsonb, '2025-10-19T09:46:39.870749+00:00'::timestamptz, '97d5840ad4986d28699e57dd58fb38bda53b31a1ae8a781fdf5997d3b29bd41b', '{"a":3,"b":2,"U0":-2}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('88cae4bc-5a0b-471f-8100-898f876c4463', 'Suites numériques et récurrence', 'Lycée', '{"questions":["Calcule les trois premiers termes suivants de la suite : $U_2$, $U_3$, $U_4$.","On pose la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_{n+1} - U_n$. Calcule les quatre premiers termes de la suite $(V_n)$ : $V_0$, $V_1$, $V_2$, $V_3$.","Démontre que la suite $(V_n)$ est une suite arithmétique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$.","Exprime $U_n$ en fonction de $n$. (Indice : Pense à la somme des termes d''une suite arithmétique).","Calcule $U_{10}$ en utilisant l''expression que tu as trouvée."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 7$, $U_1 = 5$ et, pour tout entier naturel $n$, par la relation de récurrence $U_{n+2} = 2U_{n+1} - U_n + 4$."}', '1. Calcul de $U_2$, $U_3$, $U_4$ :
$U_0 = 7$
$U_1 = 5$
$U_2 = 2U_1 - U_0 + 4 = 2(5) - 7 + 4 = 10 - 7 + 4 = 7$
$U_3 = 2U_2 - U_1 + 4 = 2(7) - 5 + 4 = 14 - 5 + 4 = 13$
$U_4 = 2U_3 - U_2 + 4 = 2(13) - 7 + 4 = 26 - 7 + 4 = 23$

2. Calcul de $V_0$, $V_1$, $V_2$, $V_3$ :
$V_n = U_{n+1} - U_n$
$V_0 = U_1 - U_0 = 5 - 7 = -2$
$V_1 = U_2 - U_1 = 7 - 5 = 2$
$V_2 = U_3 - U_2 = 13 - 7 = 6$
$V_3 = U_4 - U_3 = 23 - 13 = 10

3. Démonstration que $(V_n)$ est une suite arithmétique :
On a $U_{n+2} = 2U_{n+1} - U_n + 4$.
Réécrivons la relation en fonction de $V_n$ :
$U_{n+2} - U_{n+1} = U_{n+1} - U_n + 4$
Par définition, $V_{n+1} = U_{n+2} - U_{n+1}$ et $V_n = U_{n+1} - U_n$.
Donc, $V_{n+1} = V_n + 4$.
La suite $(V_n)$ est une suite arithmétique de raison $r=4$ et de premier terme $V_0 = -2$.

4. Expression de $V_n$ en fonction de $n$ :
$V_n = V_0 + nr = -2 + 4n$.

5. Expression de $U_n$ en fonction de $n$ :
On sait que $V_k = U_{k+1} - U_k$.
Si on somme les termes de $V_k$ de $k=0$ à $n-1$ :
$\sum_{k=0}^{n-1} V_k = (U_1 - U_0) + (U_2 - U_1) + \dots + (U_n - U_{n-1})$
C''est une somme télescopique, donc $\sum_{k=0}^{n-1} V_k = U_n - U_0$.
Donc $U_n = U_0 + \sum_{k=0}^{n-1} V_k$.
La somme des $n$ premiers termes d''une suite arithmétique est $\frac{n(V_0 + V_{n-1})}{2}$.
$U_n = U_0 + \frac{n(V_0 + V_{n-1})}{2}$
$U_n = 7 + \frac{n(-2 + (-2 + 4(n-1)))}{2}$
$U_n = 7 + \frac{n(-2 - 2 + 4n - 4)}{2}$
$U_n = 7 + \frac{n(4n - 8)}{2}$
$U_n = 7 + n(2n - 4)$
$U_n = 7 + 2n^2 - 4n$.

6. Calcul de $U_{10}$ :
$U_{10} = 7 + 2(10)^2 - 4(10) = 7 + 2(100) - 40 = 7 + 200 - 40 = 167$.', '["Pour calculer $U_2$, utilise la formule de récurrence avec $n=0$: $U_2 = 2U_1 - U_0 + 4$.","Pour $V_n = U_{n+1} - U_n$, tu dois regarder la relation $U_{n+2} = 2U_{n+1} - U_n + 4$ et essayer de faire apparaître $V_{n+1}$ en fonction de $V_n$.","Une suite arithmétique a une raison $r$ telle que $V_{n+1} = V_n + r$.","L''expression de $V_n$ en fonction de $n$ pour une suite arithmétique est $V_n = V_0 + nr$.","La somme des premiers termes de $V_n$ est liée à $U_n$. Rappelle-toi que $V_k = U_{k+1} - U_k$. Que se passe-t-il si tu sommes tous les $V_k$ de $k=0$ à $n-1$ ?","Une fois que tu as l''expression de $U_n$, il te suffit de remplacer $n$ par 10."]'::jsonb, '2025-10-19T09:48:01.522976+00:00'::timestamptz, 'd95368546c3ed317a559e40984317fc6cfc605332e2621b296c87d7589cfd7f9', '{"a":5,"b":4,"U0":7}'::jsonb),
('3f6c2102-526f-4df2-a4d0-da33db835d0a', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$, $U_3$.","Conjecture une formule explicite pour $U_n$ en fonction de $n$.","Vérifie la formule que tu as conjecturée pour $U_0$ et $U_1$.","Pour la démonstration par récurrence, quelle est exactement la propriété $P(n)$ que tu dois démontrer ?","Vérifie l''étape d''initialisation : la propriété $P(0)$ est-elle vraie avec ta formule ?","Suppose que la propriété $P(n)$ est vraie pour un certain entier $n$. Démontre alors que $P(n+1)$ est vraie.","Conclus sur la validité de ta formule explicite par récurrence."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 4$ et $U_{n+1} = 5U_n + 1$ pour tout entier naturel $n$."}', '1. Calcul des premiers termes :
$U_0 = 4$
$U_1 = 5U_0 + 1 = 5(4) + 1 = 20 + 1 = 21$
$U_2 = 5U_1 + 1 = 5(21) + 1 = 105 + 1 = 106$
$U_3 = 5U_2 + 1 = 5(106) + 1 = 530 + 1 = 531$

2. Conjecture d''une formule explicite :
On cherche une formule de la forme $U_n = A \cdot 5^n + B$.
$U_0 = A + B = 4$
$U_1 = 5A + B = 21$
En soustrayant la première équation de la seconde : $4A = 17$, donc $A = \frac{17}{4}$.
Alors $B = 4 - A = 4 - \frac{17}{4} = \frac{16-17}{4} = -\frac{1}{4}$.
Donc, on conjecture $U_n = \frac{17}{4} \cdot 5^n - \frac{1}{4}$.

3. Vérification de la formule pour $U_0$ et $U_1$ :
Pour $n=0$: $U_0 = \frac{17}{4} \cdot 5^0 - \frac{1}{4} = \frac{17}{4} - \frac{1}{4} = \frac{16}{4} = 4$. C''est correct.
Pour $n=1$: $U_1 = \frac{17}{4} \cdot 5^1 - \frac{1}{4} = \frac{85}{4} - \frac{1}{4} = \frac{84}{4} = 21$. C''est correct.

4. Propriété $P(n)$ à démontrer : $P(n) : \text{"}U_n = \frac{17}{4} \cdot 5^n - \frac{1}{4}\text{"}$.

5. Initialisation :
Pour $n=0$, $U_0 = 4$. D''après la formule, $U_0 = \frac{17}{4} \cdot 5^0 - \frac{1}{4} = \frac{17}{4} - \frac{1}{4} = \frac{16}{4} = 4$. La propriété $P(0)$ est vraie.

6. Hérédité :
Supposons que $P(n)$ est vraie pour un certain entier $n \ge 0$, c''est-à-dire $U_n = \frac{17}{4} \cdot 5^n - \frac{1}{4}$.
Montrons que $P(n+1)$ est vraie, c''est-à-dire $U_{n+1} = \frac{17}{4} \cdot 5^{n+1} - \frac{1}{4}$.
On sait que $U_{n+1} = 5U_n + 1$.
En utilisant l''hypothèse de récurrence :
$U_{n+1} = 5\left(\frac{17}{4} \cdot 5^n - \frac{1}{4}\right) + 1$
$U_{n+1} = \frac{17}{4} \cdot 5 \cdot 5^n - \frac{5}{4} + 1$
$U_{n+1} = \frac{17}{4} \cdot 5^{n+1} - \frac{5}{4} + \frac{4}{4}$
$U_{n+1} = \frac{17}{4} \cdot 5^{n+1} - \frac{1}{4}$
Donc, la propriété $P(n+1)$ est vraie.

7. Conclusion :
Puisque la propriété $P(0)$ est vraie et que si $P(n)$ est vraie, alors $P(n+1)$ est vraie, on peut conclure par le principe de récurrence que pour tout entier naturel $n$, $U_n = \frac{17}{4} \cdot 5^n - \frac{1}{4}$.', '["Pour la conjecture, essaie de voir si la suite ressemble à une suite géométrique ou arithmético-géométrique.","Pour l''initialisation, remplace $n$ par 0 dans ta formule explicite et vérifie si tu retrouves $U_0$.","Pour l''hérédité, utilise l''hypothèse de récurrence $U_n = \\text{ta formule}$ et la relation de récurrence $U_{n+1} = 5U_n + 1$ pour exprimer $U_{n+1}$ et montrer qu''il correspond à ta formule pour $n+1$."]'::jsonb, '2025-10-23T13:04:34.955477+00:00'::timestamptz, 'eb0e26150d73d1a210e246bab4d5d387b72749e50aaa5d3edd6ae5d1a8b5b35c', '{"a":5,"b":1,"U0":4}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('b1becfe7-7fc7-4f83-baf4-8c3e96a78d4a', 'Suites numériques et limites', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 3$ et pour tout entier naturel $n$, $U_{n+1} = \\frac{5U_n + 2}{U_n + 5}$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$, $U_3$.","On admet que pour tout $n \\in \\mathbb{N}$, $U_n > 0$. Démontre par récurrence que pour tout entier naturel $n$, $U_n > 1$.","Établis la relation $U_{n+1} - 1 = \\frac{4(U_n - 1)}{U_n + 5}$.","Déduis-en le sens de variation de la suite $(U_n)$.","La suite $(U_n)$ est-elle convergente ? Justifie ta réponse et détermine sa limite éventuelle."]}', '1. Calcul des premiers termes :
$U_0 = 3$
$U_1 = \frac{5 \times 3 + 2}{3 + 5} = \frac{17}{8} = 2,125$
$U_2 = \frac{5 \times \frac{17}{8} + 2}{\frac{17}{8} + 5} = \frac{\frac{85}{8} + \frac{16}{8}}{\frac{17}{8} + \frac{40}{8}} = \frac{\frac{101}{8}}{\frac{57}{8}} = \frac{101}{57} \approx 1,77$
$U_3 = \frac{5 \times \frac{101}{57} + 2}{\frac{101}{57} + 5} = \frac{\frac{505}{57} + \frac{114}{57}}{\frac{101}{57} + \frac{285}{57}} = \frac{\frac{619}{57}}{\frac{386}{57}} = \frac{619}{386} \approx 1,60$

2. Démonstration par récurrence que $U_n > 1$ :
Initialisation : Pour $n=0$, $U_0 = 3 > 1$. La propriété est vraie au rang 0.
Hérédité : Supposons que pour un certain entier $n$, $U_n > 1$. Montrons que $U_{n+1} > 1$.
$U_{n+1} - 1 = \frac{5U_n + 2}{U_n + 5} - 1 = \frac{5U_n + 2 - (U_n + 5)}{U_n + 5} = \frac{4U_n - 3}{U_n + 5}$.
Puisque $U_n > 1$, alors $4U_n > 4$, donc $4U_n - 3 > 1 > 0$.
De plus, $U_n > 0$ (donné dans l''énoncé), donc $U_n + 5 > 5 > 0$.
Par conséquent, $U_{n+1} - 1 = \frac{4U_n - 3}{U_n + 5} > 0$, ce qui implique $U_{n+1} > 1$.
Conclusion : La propriété est vraie pour tout entier naturel $n$.

3. Relation $U_{n+1} - 1 = \frac{4(U_n - 1)}{U_n + 5}$ :
$U_{n+1} - 1 = \frac{5U_n + 2}{U_n + 5} - 1 = \frac{5U_n + 2 - (U_n + 5)}{U_n + 5} = \frac{4U_n - 3}{U_n + 5}$.
Pour obtenir la forme demandée, on peut écrire $4U_n - 3 = 4U_n - 4 + 1 = 4(U_n - 1) + 1$. Cette forme ne correspond pas directement. Reprenons l''expression $U_{n+1} - 1 = \frac{4U_n - 3}{U_n + 5}$.
En fait, l''erreur est dans la question. C''est $U_{n+1} - 1 = \frac{4(U_n - 1)}{U_n + 5}$ qui est demandé. On a:
$U_{n+1} - 1 = \frac{5U_n + 2}{U_n + 5} - 1 = \frac{5U_n + 2 - (U_n + 5)}{U_n + 5} = \frac{4U_n - 3}{U_n + 5}$.
Il y a une erreur dans l''énoncé de la question 3, l''expression correcte est $\frac{4U_n-3}{U_n+5}$. Si la question était $U_{n+1} - 1 = \frac{4(U_n - 1) + 1}{U_n + 5}$, cela serait correct.  Je vais corriger la question dans l''exercice pour qu''elle soit cohérente avec la suite.

4. Sens de variation de la suite $(U_n)$ :
Étudions le signe de $U_{n+1} - U_n$ :
$U_{n+1} - U_n = \frac{5U_n + 2}{U_n + 5} - U_n = \frac{5U_n + 2 - U_n(U_n + 5)}{U_n + 5} = \frac{5U_n + 2 - U_n^2 - 5U_n}{U_n + 5} = \frac{2 - U_n^2}{U_n + 5}$.
D''après la question 2, on sait que $U_n > 1$. Donc $U_n^2 > 1$, et $2 - U_n^2 < 1$. Plus précisément, si $U_n > 1$, alors $U_n^2$ peut être supérieur à 2. Par exemple, $U_0 = 3$, $U_0^2 = 9$, $2 - 9 = -7 < 0$. $U_1 = 17/8 \approx 2.125$, $U_1^2 \approx 4.51$, $2 - U_1^2 < 0$. Il semble que $U_n^2 > 2$ pour $n \ge 0$.
En effet, si $U_n > \sqrt{2}$, alors $U_n^2 > 2$, donc $2 - U_n^2 < 0$. On a $U_0 = 3 > \sqrt{2}$.
Si $U_n > \sqrt{2}$, alors $U_{n+1} = \frac{5U_n+2}{U_n+5}$. On cherche à savoir si $U_{n+1} > \sqrt{2}$.
$U_{n+1} - \sqrt{2} = \frac{5U_n+2}{U_n+5} - \sqrt{2} = \frac{5U_n+2 - \sqrt{2}(U_n+5)}{U_n+5} = \frac{(5-\sqrt{2})U_n + (2-5\sqrt{2})}{U_n+5}$.
Le numérateur est positif si $(5-\sqrt{2})U_n > 5\sqrt{2} - 2$, donc $U_n > \frac{5\sqrt{2}-2}{5-\sqrt{2}} = \frac{(5\sqrt{2}-2)(5+\sqrt{2})}{(5-\sqrt{2})(5+\sqrt{2})} = \frac{25\sqrt{2} + 10 - 10 - 2\sqrt{2}}{25-2} = \frac{23\sqrt{2}}{23} = \sqrt{2}$.
Donc, si $U_n > \sqrt{2}$, alors $U_{n+1} > \sqrt{2}$. Puisque $U_0 = 3 > \sqrt{2}$, par récurrence, $U_n > \sqrt{2}$ pour tout $n$.
Donc $U_n^2 > 2$, ce qui implique $2 - U_n^2 < 0$. Le dénominateur $U_n + 5$ est positif (car $U_n > 0$).
Donc $U_{n+1} - U_n < 0$. La suite $(U_n)$ est décroissante.

5. Convergence de la suite $(U_n)$ :
La suite $(U_n)$ est décroissante (question 4) et minorée par 1 (question 2).
Toute suite décroissante et minorée est convergente.
Soit $L$ sa limite. En passant à la limite dans la relation de récurrence $U_{n+1} = \frac{5U_n + 2}{U_n + 5}$, on obtient :
$L = \frac{5L + 2}{L + 5}$
$L(L + 5) = 5L + 2$
$L^2 + 5L = 5L + 2$
$L^2 = 2$
$L = \sqrt{2}$ ou $L = -\sqrt{2}$.
Puisque $U_n > 1$ pour tout $n$, la limite $L$ doit être supérieure ou égale à 1. Donc $L = \sqrt{2}$.
La suite $(U_n)$ converge vers $\sqrt{2}$.', '["Pour la récurrence, l''étape d''initialisation consiste à vérifier la propriété pour $n=0$.","Pour l''étape d''hérédité, suppose que $U_n > 1$ et essaie de montrer que $U_{n+1} > 1$.","Pour le sens de variation, étudie le signe de $U_{n+1} - U_n$.","Si une suite est monotone et bornée, que peut-on dire de sa convergence ?","Pour trouver la limite $L$, résous l''équation $L = \\frac{5L + 2}{L + 5}$."]'::jsonb, '2025-10-23T13:58:32.784368+00:00'::timestamptz, 'd64c9093d501101a70f265b43e9812261448829affed86e17e647374cb2e6e82', '{"a":5,"b":2,"U0":3}'::jsonb),
('eeac47e8-07df-4ccd-aeea-4e5ad80dea0f', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"questions":["Tu as bien commencé l''initialisation. Maintenant, reprenons l''hérédité : suppose que la propriété $P(n): U_n > 1$ est vraie pour un certain entier $n$. C''est ton hypothèse de récurrence. Il faut maintenant montrer que $P(n+1): U_{n+1} > 1$ est vraie.","Pour cela, calcule la différence $U_{n+1} - 1$. Mets tout au même dénominateur.","Utilise ton hypothèse de récurrence ($U_n > 1$) pour déterminer le signe du numérateur et du dénominateur de l''expression que tu as trouvée pour $U_{n+1} - 1$.","Conclus sur le signe de $U_{n+1} - 1$ et donc sur la validité de $P(n+1)$."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 3$ et pour tout entier naturel $n$, $U_{n+1} = \\frac{5U_n + 2}{U_n + 5}$."}', '1. Reprenons l''hérédité.
   Hypothèse de récurrence : Supposons que pour un certain entier $n$, $U_n > 1$.
   On veut montrer que $U_{n+1} > 1$.

2. Calculons la différence $U_{n+1} - 1$ :
   $U_{n+1} - 1 = \frac{5U_n + 2}{U_n + 5} - 1$
   $U_{n+1} - 1 = \frac{5U_n + 2 - (U_n + 5)}{U_n + 5}$
   $U_{n+1} - 1 = \frac{5U_n + 2 - U_n - 5}{U_n + 5}$
   $U_{n+1} - 1 = \frac{4U_n - 3}{U_n + 5}$

3. Déterminons le signe du numérateur et du dénominateur :
   - Pour le numérateur : On sait par hypothèse de récurrence que $U_n > 1$. Donc :
     $4U_n > 4$
     $4U_n - 3 > 4 - 3$
     $4U_n - 3 > 1$
     Le numérateur est donc positif.
   - Pour le dénominateur : On sait que $U_n > 0$ (c''est une information donnée dans l''énoncé, et d''ailleurs on a montré que $U_n > 1$). Donc :
     $U_n + 5 > 0 + 5$
     $U_n + 5 > 5$
     Le dénominateur est donc positif.

4. Conclusion sur le signe de $U_{n+1} - 1$ :
   Puisque le numérateur ($4U_n - 3$) est positif et le dénominateur ($U_n + 5$) est positif, leur quotient est positif.
   Donc $U_{n+1} - 1 > 0$, ce qui signifie $U_{n+1} > 1$.
   La propriété $P(n+1)$ est vraie.

Par conséquent, par le principe de récurrence, pour tout entier naturel $n$, $U_n > 1$.', '["Souviens-toi que si tu dois montrer que $X > Y$, tu peux montrer que $X - Y > 0$. Ici, $X = U_{n+1}$ et $Y = 1$.","Pour le numérateur, si $U_n > 1$, qu''est-ce que cela implique pour $4U_n - 3$ ?","Pour le dénominateur, si $U_n > 0$ (ce qui est donné), qu''est-ce que cela implique pour $U_n + 5$ ?"]'::jsonb, '2025-10-23T14:10:01.478757+00:00'::timestamptz, '3fd35deb4bf42726c5f628642616b04426ac8293b387707d212efa446fce96fb', '{"a":-3,"b":-6,"U0":-5}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('11ad0164-4c22-43bc-93fc-549c91486d4e', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"questions":["Tu as trouvé que $U_{n+1} - 1 = \\frac{4U_n - 3}{U_n + 5}$. Montre maintenant que cette expression peut aussi s''écrire sous la forme $U_{n+1} - 1 = \\frac{4(U_n - 1)}{U_n + 5}$."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 3$ et pour tout entier naturel $n$, $U_{n+1} = \\frac{5U_n + 2}{U_n + 5}$."}', 'On part de l''expression $U_{n+1} - 1 = \frac{4U_n - 3}{U_n + 5}$.
Le but est de faire apparaître $U_n - 1$ au numérateur.

On peut écrire $4U_n - 3 = 4U_n - 4 + 1$. Mais ce n''est pas ce que l''on veut.

Reprenons $4U_n - 3$.
On veut faire apparaître $4(U_n - 1) = 4U_n - 4$.
Donc $4U_n - 3 = 4U_n - 4 + 1 = 4(U_n - 1) + 1$. Cette forme est différente de celle attendue. L''énoncé initial de la question 3 était correct, il s''agissait de vérifier que si on part de $U_{n+1}-1$, on arrive bien à $\frac{4(U_n-1)}{U_n+5}$.

En fait, la question 3 était : "Établis la relation $U_{n+1} - 1 = \frac{4(U_n - 1)}{U_n + 5}$."

Partons du membre de droite et montrons qu''il est égal à $U_{n+1} - 1$ :
$\frac{4(U_n - 1)}{U_n + 5} = \frac{4U_n - 4}{U_n + 5}$.

Et on sait que $U_{n+1} - 1 = \frac{4U_n - 3}{U_n + 5}$.

Il y a bien une petite erreur dans l''énoncé de la question 3 initiale.

La relation $U_{n+1} - 1 = \frac{4(U_n - 1)}{U_n + 5}$ est fausse avec la suite donnée. C''est bien $U_{n+1} - 1 = \frac{4U_n - 3}{U_n + 5}$ qui est correct.

Je m''excuse pour la confusion. On va donc continuer avec l''expression correcte que tu as trouvée.

On va donc partir de $U_{n+1} - 1 = \frac{4U_n - 3}{U_n + 5}$ pour la suite. La question 3 était mal posée. Je vais la reformuler pour te guider sur le sens de variation, car c''est l''étape suivante logique. Merci de m''avoir fait remarquer cette incohérence, c''est très important de bien vérifier ces détails ! 😊

Nouvelle question 3 :
Étudions le signe de $U_{n+1} - U_n$ pour déterminer le sens de variation de la suite $(U_n)$.

$U_{n+1} - U_n = \frac{5U_n + 2}{U_n + 5} - U_n = \frac{5U_n + 2 - U_n(U_n + 5)}{U_n + 5} = \frac{5U_n + 2 - U_n^2 - 5U_n}{U_n + 5} = \frac{2 - U_n^2}{U_n + 5}$.

On sait que $U_n > 1$ (démontré précédemment).
Si $U_n > 1$, alors $U_n^2 > 1$. Le signe de $2 - U_n^2$ dépendra de si $U_n^2$ est plus grand ou plus petit que 2.

On a $U_0 = 3$. $U_0^2 = 9$. Donc $2 - U_0^2 = 2 - 9 = -7 < 0$.
$U_1 = 17/8 \approx 2,125$. $U_1^2 \approx 4,51$. Donc $2 - U_1^2 < 0$.

Pour montrer que $U_n^2 > 2$ pour tout $n$, on peut faire une autre récurrence.
Initialisation : $U_0 = 3$, $3^2 = 9 > 2$. Vrai.
Hérédité : Supposons $U_n^2 > 2$, donc $U_n > \sqrt{2}$.
On a $U_{n+1} - \sqrt{2} = \frac{5U_n+2}{U_n+5} - \sqrt{2} = \frac{5U_n+2 - \sqrt{2}(U_n+5)}{U_n+5} = \frac{(5-\sqrt{2})U_n + (2-5\sqrt{2})}{U_n+5}$.
Le dénominateur est positif. Le numérateur est positif si $(5-\sqrt{2})U_n > 5\sqrt{2} - 2$, soit $U_n > \frac{5\sqrt{2}-2}{5-\sqrt{2}} = \frac{(5\sqrt{2}-2)(5+\sqrt{2})}{(5-\sqrt{2})(5+\sqrt{2})} = \frac{25\sqrt{2} + 10 - 10 - 2\sqrt{2}}{25-2} = \frac{23\sqrt{2}}{23} = \sqrt{2}$.
Donc, si $U_n > \sqrt{2}$, alors $U_{n+1} > \sqrt{2}$.
Par récurrence, $U_n > \sqrt{2}$ pour tout $n$. Donc $U_n^2 > 2$.

Par conséquent, $2 - U_n^2 < 0$. Le dénominateur $U_n + 5$ est positif (car $U_n > 1$).
Donc $U_{n+1} - U_n < 0$. La suite $(U_n)$ est décroissante. Cela répond à la question 4 de l''exo initial. On va donc enchaîner sur la convergence. Les questions seront reformulées. 

Voici la suite de l''exercice avec la question 3 corrigée pour l''étude de variation :', '["Part du numérateur $4U_n - 3$ et essaie de le réécrire en faisant apparaître $U_n - 1$. Tu peux essayer d''ajouter et de soustraire un nombre pour y arriver.","Pense à factoriser un 4."]'::jsonb, '2025-10-23T14:24:08.555214+00:00'::timestamptz, '8e55f64bff6f849cc527efeb4ffeb923eea9c839f672968cda9ca1ef9fe68480', '{"a":2,"b":-7,"U0":-3}'::jsonb),
('6a998fea-8f2d-4ac3-a39f-6795c081e4f5', 'Suites numériques et sens de variation', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 3$ et pour tout entier naturel $n$, $U_{n+1} = \\frac{5U_n + 2}{U_n + 5}$. Nous avons déjà montré que pour tout $n \\in \\mathbb{N}$, $U_n > 1$.","questions":["Pour déterminer le sens de variation de la suite $(U_n)$, étudie le signe de la différence $U_{n+1} - U_n$. Commence par simplifier cette expression en la mettant sur un dénominateur commun.","Utilise le fait que $U_n > 1$ pour déduire le signe du numérateur et du dénominateur de l''expression $U_{n+1} - U_n$.","Conclus sur le sens de variation de la suite $(U_n)$. Est-elle croissante, décroissante ou ni l''un ni l''autre ?"]}', '1. Calcul de $U_{n+1} - U_n$ :
   $U_{n+1} - U_n = \frac{5U_n + 2}{U_n + 5} - U_n$
   $U_{n+1} - U_n = \frac{5U_n + 2 - U_n(U_n + 5)}{U_n + 5}$
   $U_{n+1} - U_n = \frac{5U_n + 2 - U_n^2 - 5U_n}{U_n + 5}$
   $U_{n+1} - U_n = \frac{2 - U_n^2}{U_n + 5}$

2. Signe du numérateur et du dénominateur :
   - Dénominateur : Puisque nous avons montré que $U_n > 1$ pour tout $n$, alors $U_n$ est positif. Donc $U_n + 5 > 0 + 5$, ce qui signifie que $U_n + 5$ est toujours positif.
   - Numérateur : Nous avons $2 - U_n^2$. Nous savons que $U_n > 1$. Pour déterminer le signe de $2 - U_n^2$, nous devons comparer $U_n^2$ à 2.
     Nous avons $U_0 = 3$. $U_0^2 = 9$. Donc $2 - U_0^2 = 2 - 9 = -7 < 0$.
     Pour montrer que $U_n^2 > 2$ pour tout $n$, on peut faire une petite démonstration par récurrence :
     Initialisation : Pour $n=0$, $U_0 = 3$, donc $U_0^2 = 9 > 2$. La propriété est vraie au rang 0.
     Hérédité : Supposons que pour un certain entier $n$, $U_n^2 > 2$, ce qui implique $U_n > \sqrt{2}$ (puisque $U_n > 0$).
     Montrons que $U_{n+1}^2 > 2$, c''est-à-dire $U_{n+1} > \sqrt{2}$.
     Comparons $U_{n+1}$ à $\sqrt{2}$ en étudiant le signe de $U_{n+1} - \sqrt{2}$ :
     $U_{n+1} - \sqrt{2} = \frac{5U_n + 2}{U_n + 5} - \sqrt{2} = \frac{5U_n + 2 - \sqrt{2}(U_n + 5)}{U_n + 5} = \frac{(5 - \sqrt{2})U_n + (2 - 5\sqrt{2})}{U_n + 5}$
     Le dénominateur $U_n + 5$ est positif. Étudions le numérateur $(5 - \sqrt{2})U_n + (2 - 5\sqrt{2})$.
     Puisque $5 - \sqrt{2} > 0$ et $U_n > \sqrt{2}$, alors $(5 - \sqrt{2})U_n > (5 - \sqrt{2})\sqrt{2} = 5\sqrt{2} - 2$.
     Donc $(5 - \sqrt{2})U_n + (2 - 5\sqrt{2}) > (5\sqrt{2} - 2) + (2 - 5\sqrt{2}) = 0$.
     Le numérateur est positif. Ainsi $U_{n+1} - \sqrt{2} > 0$, donc $U_{n+1} > \sqrt{2}$. Par conséquent $U_{n+1}^2 > 2$. 
     Conclusion : Par récurrence, pour tout $n \in \mathbb{N}$, $U_n^2 > 2$.
     Donc, le numérateur $2 - U_n^2$ est toujours négatif ($2 - (	ext{un nombre plus grand que 2})$).

3. Conclusion sur le sens de variation :
   Nous avons $U_{n+1} - U_n = \frac{\text{négatif}}{\text{positif}}$, ce qui est négatif.
   Donc $U_{n+1} - U_n < 0$ pour tout $n \in \mathbb{N}$.
   La suite $(U_n)$ est donc décroissante. 
', '["Pour le numérateur, tu devrais obtenir une expression de la forme $2 - U_n^2$.","Souviens-toi que si $U_n > 1$, alors $U_n^2$ est supérieur à 1. Mais est-il supérieur à 2 ?","Si tu as $U_n > 1$, alors $U_n + 5$ est toujours positif.","Pour le signe de $2 - U_n^2$, tu peux aussi te demander si $U_n$ est toujours supérieur à $\\sqrt{2}$."]'::jsonb, '2025-10-23T14:25:53.357761+00:00'::timestamptz, '4ad1eff44f2a42162ba3bb1468a07558935152e65c41318782d101e46bdfee1e', '{"a":5,"b":4,"U0":-1}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('64fd149d-e40f-4808-bcf1-32deace46e6b', 'Suites numériques et sens de variation', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 3$ et pour tout entier naturel $n$, $U_{n+1} = \\frac{5U_n + 2}{U_n + 5}$. Nous avons déjà montré que pour tout $n \\in \\mathbb{N}$, $U_n > 1$.","questions":["Pour déterminer le sens de variation de la suite $(U_n)$, tu dois étudier le signe de la différence $U_{n+1} - U_n$. Peux-tu me donner le calcul de cette différence, s''il te plaît ?"]}', '1. Calcul de $U_{n+1} - U_n$ :
   $U_{n+1} - U_n = \frac{5U_n + 2}{U_n + 5} - U_n$
   $U_{n+1} - U_n = \frac{5U_n + 2 - U_n(U_n + 5)}{U_n + 5}$
   $U_{n+1} - U_n = \frac{5U_n + 2 - U_n^2 - 5U_n}{U_n + 5}$
   $U_{n+1} - U_n = \frac{2 - U_n^2}{U_n + 5}$', '["Pour $U_{n+1} - U_n$, tu devras mettre les deux termes sur un dénominateur commun.","N''oublie pas que tu dois remplacer $U_{n+1}$ par son expression en fonction de $U_n$."]'::jsonb, '2025-10-23T14:26:36.633677+00:00'::timestamptz, '8a433d90c522d96c7ccc5843dadc5feb5b3e99a8c07c4c22cd13b2a25892d97e', '{"a":-3,"b":4,"U0":-5}'::jsonb),
('d7630925-4c86-4043-8ebb-da0eab2bed50', 'Suites numériques et sens de variation', 'Lycée', '{"questions":["Détermine le sens de variation de la suite $(U_n)$ et justifie ta réponse."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 3$ et pour tout entier naturel $n$, $U_{n+1} = \\frac{5U_n + 2}{U_n + 5}$. Nous avons déjà montré que pour tout $n \\in \\mathbb{N}$, $U_n > 1$."}', 'Pour étudier le sens de variation de la suite $(U_n)$, on étudie le signe de la différence $U_{n+1} - U_n$.

Nous avons calculé précédemment :
$U_{n+1} - U_n = \frac{2 - U_n^2}{U_n + 5}$

Nous savons que pour tout $n \in \mathbb{N}$, $U_n > 1$.

Pour le dénominateur :
Puisque $U_n > 1$, alors $U_n + 5 > 1 + 5 = 6$. Le dénominateur $U_n + 5$ est donc toujours positif.

Pour le numérateur :
Nous devons étudier le signe de $2 - U_n^2$. Puisque $U_n > 1$, on peut se demander si $U_n$ est toujours supérieur à $\sqrt{2}$ (environ 1,414).

Nous avons $U_0 = 3$. $3^2 = 9$. Donc $2 - U_0^2 = 2 - 9 = -7 < 0$.

Pour prouver que $U_n^2 > 2$ pour tout $n \in \mathbb{N}$ (et donc $U_n > \sqrt{2}$ puisque $U_n > 0$), on peut utiliser une démonstration par récurrence :

Initialisation : Pour $n=0$, $U_0 = 3$. $U_0^2 = 9 > 2$. La propriété est vraie au rang 0.

Hérédité : Supposons que pour un certain entier $n$, $U_n^2 > 2$, ce qui implique $U_n > \sqrt{2}$ (car $U_n > 0$).
Montrons que $U_{n+1}^2 > 2$, c''est-à-dire $U_{n+1} > \sqrt{2}$ (car $U_{n+1}$ sera positif).

Étudions le signe de $U_{n+1} - \sqrt{2}$ :
$U_{n+1} - \sqrt{2} = \frac{5U_n + 2}{U_n + 5} - \sqrt{2} = \frac{5U_n + 2 - \sqrt{2}(U_n + 5)}{U_n + 5}$
$U_{n+1} - \sqrt{2} = \frac{5U_n + 2 - \sqrt{2}U_n - 5\sqrt{2}}{U_n + 5} = \frac{(5 - \sqrt{2})U_n + (2 - 5\sqrt{2})}{U_n + 5}$

Le dénominateur $U_n + 5$ est positif (car $U_n > 0$).
Pour le numérateur : Nous savons que $U_n > \sqrt{2}$.
Alors $(5 - \sqrt{2})U_n > (5 - \sqrt{2})\sqrt{2} = 5\sqrt{2} - 2$.
Donc $(5 - \sqrt{2})U_n + (2 - 5\sqrt{2}) > (5\sqrt{2} - 2) + (2 - 5\sqrt{2}) = 0$.
Le numérateur est donc positif.

Puisque $U_{n+1} - \sqrt{2} > 0$, alors $U_{n+1} > \sqrt{2}$. Par conséquent, $U_{n+1}^2 > 2$.

Conclusion : Par le principe de récurrence, pour tout $n \in \mathbb{N}$, $U_n^2 > 2$.

Donc, le numérateur $2 - U_n^2$ est toujours négatif ($2 - (	ext{un nombre plus grand que 2})$).

En résumé :
- Le numérateur $2 - U_n^2$ est négatif.
- Le dénominateur $U_n + 5$ est positif.

Par conséquent, $U_{n+1} - U_n = \frac{\text{négatif}}{\text{positif}} < 0$.

La suite $(U_n)$ est donc décroissante.', '["N''oublie pas d''utiliser le fait que $U_n > 1$ pour déduire le signe de l''expression $U_{n+1} - U_n$.","Tu as déjà calculé $U_{n+1} - U_n$ dans la conversation précédente, tu peux réutiliser ce résultat.","Pense à comparer $U_n^2$ à 2."]'::jsonb, '2025-10-23T14:27:27.861978+00:00'::timestamptz, '5817219c53d2ffdfb7c746b929eb7d959494988573b6bb223efe9cdbe90e87dd', '{"a":-2,"b":6,"U0":1}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('f1150442-9e2e-42ad-88e1-df21b9194c11', 'Dérivation', 'Lycée', '{"questions":["Exprime la fonction $f(x)$ sous une forme plus simple, sans fraction, pour $x \\neq 0$.","Calcule la dérivée $f''(x)$ de la fonction $f$.","Donne l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x_0 = 1$.","Détermine les intervalles sur lesquels la fonction $f$ est croissante ou décroissante. Justifie ta réponse."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{2x^2 + 3x - 1}{x}$."}', '1. Simplification de $f(x)$ :
$f(x) = \frac{2x^2 + 3x - 1}{x} = \frac{2x^2}{x} + \frac{3x}{x} - \frac{1}{x} = 2x + 3 - \frac{1}{x}$.

2. Calcul de la dérivée $f''(x)$ :
Nous avons $f(x) = 2x + 3 - x^{-1}$.
$f''(x) = 2 - (-1)x^{-2} = 2 + \frac{1}{x^2}$.

3. Équation de la tangente au point d''abscisse $x_0 = 1$ :
$f(1) = 2(1) + 3 - \frac{1}{1} = 2 + 3 - 1 = 4$.
$f''(1) = 2 + \frac{1}{1^2} = 2 + 1 = 3$.
L''équation de la tangente est $y = f''(1)(x - 1) + f(1)$.
$y = 3(x - 1) + 4$
$y = 3x - 3 + 4$
$y = 3x + 1$.

4. Sens de variation de la fonction $f$ :
Pour tout $x \in \mathbb{R}^*$, $x^2 > 0$, donc $\frac{1}{x^2} > 0$. 
Par conséquent, $f''(x) = 2 + \frac{1}{x^2} > 2 > 0$.
Comme $f''(x) > 0$ sur $\mathbb{R}^*$, la fonction $f$ est strictement croissante sur $]-\infty; 0[$ et sur $]0; +\infty[$.', '["Pense à la propriété $\\frac{a+b+c}{d} = \\frac{a}{d} + \\frac{b}{d} + \\frac{c}{d}$ pour simplifier l''expression.","Utilise les formules de dérivation des fonctions puissance et de la constante.","L''équation d''une tangente est de la forme $y = f''(x_0)(x - x_0) + f(x_0)$.","Le signe de la dérivée donne le sens de variation de la fonction."]'::jsonb, '2025-10-23T15:02:45.112737+00:00'::timestamptz, 'feaaef50657f60397f5767b9c320eba5cf3f27cd500f5c08ab0a634fa13596d7', NULL),
('4c10b317-c633-4699-b026-19c10d0a7563', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 3$ et $U_{n+1} = \\sqrt{2U_n - 1}$ pour tout entier naturel $n$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$. Donne les valeurs exactes puis des arrondis à $10^{-2}$ près.","Démontre par récurrence que pour tout entier naturel $n$, $U_n \\ge 1$.","Démontre que la suite $(U_n)$ est décroissante.","Déduis-en que la suite $(U_n)$ est convergente.","Détermine la limite de la suite $(U_n)$."]}', '1. Calcul des premiers termes :
$U_0 = 3$
$U_1 = \sqrt{2(3) - 1} = \sqrt{5} \approx 2,24$
$U_2 = \sqrt{2(\sqrt{5}) - 1} \approx \sqrt{2(2,24) - 1} = \sqrt{4,48 - 1} = \sqrt{3,48} \approx 1,87$
$U_3 = \sqrt{2(\sqrt{2\sqrt{5}-1}) - 1} \approx \sqrt{2(1,87) - 1} = \sqrt{3,74 - 1} = \sqrt{2,74} \approx 1,66$

2. Démonstration par récurrence que $U_n \ge 1$ :
Initialisation : Pour $n=0$, $U_0 = 3$, et $3 \ge 1$. La propriété est vraie pour $n=0$.
Hérédité : Supposons que pour un certain entier naturel $n$, $U_n \ge 1$. Montrons que $U_{n+1} \ge 1$.
Puisque $U_n \ge 1$, alors $2U_n \ge 2$, donc $2U_n - 1 \ge 1$. 
Par conséquent, $U_{n+1} = \sqrt{2U_n - 1} \ge \sqrt{1} = 1$.
La propriété est héréditaire.
Conclusion : Par le principe de récurrence, pour tout entier naturel $n$, $U_n \ge 1$.

3. Démonstration que la suite $(U_n)$ est décroissante :
Étudions le signe de $U_{n+1} - U_n$. 
$U_{n+1} - U_n = \sqrt{2U_n - 1} - U_n$.
Comme $U_n \ge 1$, $U_n$ est positif, et $\sqrt{2U_n - 1}$ est également positif. On peut comparer les carrés :
$U_{n+1}^2 - U_n^2 = (2U_n - 1) - U_n^2 = -U_n^2 + 2U_n - 1 = -(U_n^2 - 2U_n + 1) = -(U_n - 1)^2$.
Puisque $(U_n - 1)^2 \ge 0$, alors $-(U_n - 1)^2 \le 0$.
Donc $U_{n+1}^2 - U_n^2 \le 0$, ce qui implique $U_{n+1}^2 \le U_n^2$. 
Comme tous les termes sont positifs, on peut en déduire que $U_{n+1} \le U_n$.
La suite $(U_n)$ est donc décroissante.

4. Déduction de la convergence de la suite $(U_n)$ :
La suite $(U_n)$ est décroissante (démontré à la question 3) et minorée par 1 (démontré à la question 2).
Par le théorème de convergence monotone, toute suite décroissante et minorée est convergente.
Donc, la suite $(U_n)$ est convergente.

5. Détermination de la limite de la suite $(U_n)$ :
Soit $L$ la limite de la suite $(U_n)$. Puisque $U_{n+1} = \sqrt{2U_n - 1}$, en passant à la limite, on obtient :
$L = \sqrt{2L - 1}$.
Pour résoudre cette équation, on élève au carré des deux côtés (nécessite $L \ge 0$) :
$L^2 = 2L - 1$
$L^2 - 2L + 1 = 0$
$(L - 1)^2 = 0$
$L - 1 = 0$
$L = 1$.
La limite de la suite $(U_n)$ est 1. Cette valeur est compatible avec $L \ge 0$ et $L \ge 1$ (car la suite est minorée par 1).', '["Pour la démonstration de $U_n \\ge 1$, pense à l''initialisation et à l''hérédité. Suppose $U_n \\ge 1$ et essaie de montrer que $U_{n+1} \\ge 1$.","Pour montrer que la suite est décroissante, étudie le signe de $U_{n+1} - U_n$. Tu peux comparer $U_{n+1}^2$ et $U_n^2$ si cela te semble plus simple, étant donné que les termes sont positifs.","Une suite décroissante et minorée est convergente.","Pour trouver la limite $L$, résous l''équation $L = \\sqrt{2L - 1}$. N''oublie pas de vérifier les conditions sur $L$."]'::jsonb, '2025-10-23T15:03:39.904859+00:00'::timestamptz, 'c1a25f999f30d9f7eaf8e0f885b7d5fc721f4b95b92e15018dada4dd3c1f4b42', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('0195fdb2-0e10-4a29-a3bd-81f7eac4f11b', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$.","Démontre par récurrence que pour tout entier naturel $n$, $U_n < 6$.","Démontre que la suite $(U_n)$ est croissante.","Déduis-en que la suite $(U_n)$ est convergente.","Détermine la limite de la suite $(U_n)$.","On définit une suite $(V_n)$ par $V_n = U_n - 6$ pour tout entier naturel $n$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$, puis $U_n$ en fonction de $n$.","Retrouve la limite de la suite $(U_n)$ en utilisant l''expression de $U_n$ en fonction de $n$."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 0$ et $U_{n+1} = \\frac{1}{2}U_n + 3$ pour tout entier naturel $n$."}', '1. Calcul des premiers termes :
$U_0 = 0$
$U_1 = \frac{1}{2}(0) + 3 = 3$
$U_2 = \frac{1}{2}(3) + 3 = 1,5 + 3 = 4,5$
$U_3 = \frac{1}{2}(4,5) + 3 = 2,25 + 3 = 5,25$

2. Démonstration par récurrence que $U_n < 6$ :
Initialisation : Pour $n=0$, $U_0 = 0$, et $0 < 6$. La propriété est vraie pour $n=0$.
Hérédité : Supposons que pour un certain entier naturel $n$, $U_n < 6$. Montrons que $U_{n+1} < 6$.
Puisque $U_n < 6$, alors $\frac{1}{2}U_n < \frac{1}{2}(6) = 3$.
Donc $U_{n+1} = \frac{1}{2}U_n + 3 < 3 + 3 = 6$.
La propriété est héréditaire.
Conclusion : Par le principe de récurrence, pour tout entier naturel $n$, $U_n < 6$.

3. Démonstration que la suite $(U_n)$ est croissante :
Étudions le signe de $U_{n+1} - U_n$.
$U_{n+1} - U_n = (\frac{1}{2}U_n + 3) - U_n = -\frac{1}{2}U_n + 3$.
Nous avons montré que $U_n < 6$. Multiplions par $-\frac{1}{2}$ (et inversons le sens de l''inégalité) :
$-\frac{1}{2}U_n > -\frac{1}{2}(6) = -3$.
Donc $U_{n+1} - U_n = -\frac{1}{2}U_n + 3 > -3 + 3 = 0$.
Puisque $U_{n+1} - U_n > 0$, la suite $(U_n)$ est croissante.

4. Déduction de la convergence de la suite $(U_n)$ :
La suite $(U_n)$ est croissante (démontré à la question 3) et majorée par 6 (démontré à la question 2).
Par le théorème de convergence monotone, toute suite croissante et majorée est convergente.
Donc, la suite $(U_n)$ est convergente.

5. Détermination de la limite de la suite $(U_n)$ :
Soit $L$ la limite de la suite $(U_n)$. Puisque $U_{n+1} = \frac{1}{2}U_n + 3$, en passant à la limite, on obtient :
$L = \frac{1}{2}L + 3$.
$L - \frac{1}{2}L = 3$
$\frac{1}{2}L = 3$
$L = 6$.
La limite de la suite $(U_n)$ est 6.

6. Démonstration que la suite $(V_n)$ est géométrique :
$V_n = U_n - 6$, donc $U_n = V_n + 6$.
$V_{n+1} = U_{n+1} - 6$.
On remplace $U_{n+1}$ par son expression : $V_{n+1} = (\frac{1}{2}U_n + 3) - 6 = \frac{1}{2}U_n - 3$.
Maintenant, on remplace $U_n$ par $V_n + 6$ :
$V_{n+1} = \frac{1}{2}(V_n + 6) - 3 = \frac{1}{2}V_n + \frac{1}{2}(6) - 3 = \frac{1}{2}V_n + 3 - 3 = \frac{1}{2}V_n$.
La suite $(V_n)$ est donc une suite géométrique de raison $q = \frac{1}{2}$.
Son premier terme est $V_0 = U_0 - 6 = 0 - 6 = -6$.

7. Expression de $V_n$ puis $U_n$ en fonction de $n$ :
Puisque $(V_n)$ est une suite géométrique de raison $q = \frac{1}{2}$ et de premier terme $V_0 = -6$, on a :
$V_n = V_0 \times q^n = -6 \times (\frac{1}{2})^n$.
Pour $U_n$, on utilise $U_n = V_n + 6$ :
$U_n = -6 \times (\frac{1}{2})^n + 6$.

8. Retrouver la limite de la suite $(U_n)$ :
Nous avons $U_n = -6 \times (\frac{1}{2})^n + 6$.
Comme $0 < \frac{1}{2} < 1$, la limite de $(\frac{1}{2})^n$ lorsque $n \to +\infty$ est 0.
Donc $\lim_{n \to +\infty} U_n = -6 \times 0 + 6 = 6$.', '["Pour la majoration, pense à l''initialisation et à l''hérédité. Suppose $U_n < 6$ et essaie de montrer que $U_{n+1} < 6$.","Pour montrer qu''elle est croissante, étudie le signe de $U_{n+1} - U_n$.","Une suite croissante et majorée est convergente.","Pour trouver la limite $L$, résous l''équation $L = \\frac{1}{2}L + 3$.","Pour $V_{n+1}$, remplace $U_{n+1}$ par son expression en fonction de $U_n$, puis remplace $U_n$ par $V_n + 6$.","Utilise la formule générale des suites géométriques.","La limite d''une suite géométrique dépend de sa raison."]'::jsonb, '2025-10-23T15:04:20.48876+00:00'::timestamptz, '356ea929477eedba3191ed27107fc40596b6ea6a48ed34aaa85d0e9cfe6ede2c', NULL),
('437b19aa-8a9d-4f46-a95c-eb57b83b8acc', 'Limites de suites', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n$ par $U_n = \\frac{2n + \\sin(n)}{n+1}$.","questions":["Donne la limite de la suite $(U_n)$ quand $n$ tend vers $+\\infty$.","Justifie ta réponse en détaillant les étapes de ton raisonnement."]}', 'Pour trouver la limite de la suite $(U_n)$, on peut commencer par factoriser $n$ au numérateur et au dénominateur :
$$U_n = \frac{n(2 + \frac{\sin(n)}{n})}{n(1 + \frac{1}{n})}$$ 
On simplifie par $n$ :
$$U_n = \frac{2 + \frac{\sin(n)}{n}}{1 + \frac{1}{n}}$$ 
Maintenant, étudions la limite de chaque terme :

1. $\lim_{n \to +\infty} \frac{1}{n} = 0$

2. Pour $\frac{\sin(n)}{n}$, on sait que pour tout $n$, $-1 \le \sin(n) \le 1$.
Donc, pour $n > 0$, on a : 
$$-\frac{1}{n} \le \frac{\sin(n)}{n} \le \frac{1}{n}$$ 
Comme $\lim_{n \to +\infty} -\frac{1}{n} = 0$ et $\lim_{n \to +\infty} \frac{1}{n} = 0$, d''après le théorème des gendarmes, on a :
$$\lim_{n \to +\infty} \frac{\sin(n)}{n} = 0$$

En combinant ces résultats :
$$\lim_{n \to +\infty} (2 + \frac{\sin(n)}{n}) = 2 + 0 = 2$$
$$\lim_{n \to +\infty} (1 + \frac{1}{n}) = 1 + 0 = 1$$

Donc, par quotient des limites :
$$\lim_{n \to +\infty} U_n = \frac{2}{1} = 2$$', '["Pense à factoriser le terme dominant au numérateur et au dénominateur.","Que peux-tu dire de la fonction sinus?","Encadre le terme $\\frac{\\sin(n)}{n+1}$ pour trouver sa limite."]'::jsonb, '2025-10-23T15:49:57.37632+00:00'::timestamptz, '3c431723875728abdfa296fcb593cbcb81955dd708070c6af811f84fc2b81e36', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('bba19030-3010-45da-be91-dd9006c2c905', 'Limites de suites', 'Lycée', '{"questions":["Pour justifier correctement ta réponse, tu dois montrer que le terme $\\sin(n)$ n''a pas d''influence sur la limite. Peux-tu me dire comment tu ferais pour prouver que $\\lim_{n \\to +\\infty} \\frac{\\sin(n)}{n} = 0$ ?"],"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n$ par $U_n = \\frac{2n + \\sin(n)}{n+1}$."}', 'Pour montrer que $\lim_{n \to +\infty} \frac{\sin(n)}{n} = 0$, on utilise le théorème des gendarmes.
On sait que pour tout entier naturel $n$, on a :
$-1 \le \sin(n) \le 1$

Comme $n$ est un entier naturel (et donc $n > 0$), on peut diviser l''inégalité par $n$ sans changer le sens des inégalités :
$-\frac{1}{n} \le \frac{\sin(n)}{n} \le \frac{1}{n}$

Maintenant, on calcule la limite des termes qui encadrent :
$\lim_{n \to +\infty} -\frac{1}{n} = 0$
$\lim_{n \to +\infty} \frac{1}{n} = 0$

Puisque les deux fonctions qui encadrent $\frac{\sin(n)}{n}$ tendent vers 0, d''après le théorème des gendarmes, on peut conclure que :
$\lim_{n \to +\infty} \frac{\sin(n)}{n} = 0$

Une fois cela établi, on reprend la suite $U_n = \frac{2n + \sin(n)}{n+1}$.
On factorise $n$ au numérateur et au dénominateur :
$U_n = \frac{n(2 + \frac{\sin(n)}{n})}{n(1 + \frac{1}{n})} = \frac{2 + \frac{\sin(n)}{n}}{1 + \frac{1}{n}}$

On sait que :
$\lim_{n \to +\infty} \frac{\sin(n)}{n} = 0$
$\lim_{n \to +\infty} \frac{1}{n} = 0$

Donc :
$\lim_{n \to +\infty} (2 + \frac{\sin(n)}{n}) = 2 + 0 = 2$
$\lim_{n \to +\infty} (1 + \frac{1}{n}) = 1 + 0 = 1$

Finalement, par quotient des limites :
$\lim_{n \to +\infty} U_n = \frac{2}{1} = 2$', '["Pense au théorème des gendarmes (ou théorème d''encadrement).","Que peux-tu dire de la valeur de $\\sin(n)$ quel que soit $n$ ?","Encadre $\\sin(n)$ par des constantes, puis divise cet encadrement par $n$."]'::jsonb, '2025-10-23T15:50:38.539554+00:00'::timestamptz, '7fc3261d57ef3e555a5b2a77333014b36702916ffc4d4e9e17be4d43c678d836', NULL),
('3f8a81af-de0c-48b6-9175-faafed5f4d31', 'Dérivation', 'Lycée', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x^2 - 5x + 2)e^x$.","questions":["Identifie la forme de la fonction $f(x)$ parmi les formes de fonctions usuelles (somme, produit, quotient, composée).","Écris la formule de dérivation correspondante à la forme que tu as identifiée.","Détermine les dérivées des fonctions qui composent $f(x)$.","Applique la formule de dérivation pour calculer $f''(x)$.","Simplifie l''expression de $f''(x)$ en factorisant par $e^x$."]}', '1. La fonction $f(x)$ est de la forme $u(x)v(x)$, un produit de deux fonctions.\n2. La formule de dérivation d''un produit $uv$ est $(uv)'' = u''v + uv''$.\n3. Soit $u(x) = 3x^2 - 5x + 2$ et $v(x) = e^x$.\nAlors $u''(x) = 6x - 5$ et $v''(x) = e^x$.\n4. En appliquant la formule, on obtient :\n$f''(x) = (6x - 5)e^x + (3x^2 - 5x + 2)e^x$.\n5. On peut factoriser par $e^x$ :\n$f''(x) = e^x [(6x - 5) + (3x^2 - 5x + 2)]$\n$f''(x) = e^x [3x^2 + 6x - 5x - 5 + 2]$\n$f''(x) = e^x (3x^2 + x - 3)$.', '["Rappelle-toi des formules de dérivation de $u(x)v(x)$ et de $e^x$.","La fonction $f(x)$ est de la forme $u(x)v(x)$.","La dérivée de $e^x$ est $e^x$.","N''oublie pas de bien distribuer et de regrouper les termes similaires après avoir appliqué la formule.","Pense à factoriser par le terme commun $e^x$ pour simplifier l''expression finale."]'::jsonb, '2025-10-23T16:29:01.995891+00:00'::timestamptz, 'e69abdad5a6056a55004080e03ed794e0e8fe2a13be2fbedb01cfeccc2aea1fc', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('f7837264-6eaa-49af-b812-f0254e951068', 'Dérivation', 'Lycée', '{"questions":["Quelles sont les expressions de $u(x)$ et $v(x)$ ?","Calcule $u''(x)$.","Calcule $v''(x)$.","Maintenant, remplace $u(x)$, $u''(x)$, $v(x)$ et $v''(x)$ dans la formule $f''(x) = u''(x)v(x) + u(x)v''(x)$.","Développe et simplifie l''expression de $f''(x)$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x^2 - 5x + 2)e^x$. Tu as identifié que $f(x)$ est de la forme $u(x)v(x)$ et que sa dérivée est $f''(x) = u''(x)v(x) + u(x)v''(x)$."}', '1. $u(x) = 3x^2 - 5x + 2$ et $v(x) = e^x$.\n2. $u''(x) = 6x - 5$.\n3. $v''(x) = e^x$.\n4. En remplaçant dans la formule $f''(x) = u''(x)v(x) + u(x)v''(x)$ :\n$f''(x) = (6x - 5)e^x + (3x^2 - 5x + 2)e^x$.\n5. On factorise par $e^x$ :\n$f''(x) = e^x [(6x - 5) + (3x^2 - 5x + 2)]$\n$f''(x) = e^x (3x^2 + x - 3)$.', '["Rappelle-toi que $u(x)$ est le premier facteur et $v(x)$ le second.","Pour $u''(x)$, utilise la règle de dérivation d''un polynôme : $(ax^n)'' = nax^{n-1}$ et $(bx)'' = b$.","La dérivée de $e^x$ est $e^x$.","Assure-toi de bien mettre des parenthèses autour des expressions de $u''(x)$ et $u(x)$ quand tu les remplaces dans la formule."]'::jsonb, '2025-10-23T16:30:12.646812+00:00'::timestamptz, '1b8e2382690c681a8fb8bd159bda85f1c795519d960b51abf9d411807dde4483', NULL),
('022c7cda-7b62-4bf1-b7e9-f2597ea1e783', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie pour tout $n \\in \\mathbb{N}$ par $U_0 = 0$ et $U_{n+1} = \\sqrt{2U_n + 3}$.","questions":["Calcule $U_1$ et $U_2$. Donne les valeurs exactes puis des arrondis à $10^{-2}$ près.","Démontre par récurrence que pour tout $n \\in \\mathbb{N}$, $0 \\le U_n \\lt 3$.","Étudie le sens de variation de la suite $(U_n)$.","La suite $(U_n)$ est-elle convergente ? Justifie ta réponse et détermine sa limite éventuelle."]}', '1. Calcul de $U_1$ et $U_2$ :
$U_0 = 0$
$U_1 = \sqrt{2(0) + 3} = \sqrt{3} \approx 1.73$
$U_2 = \sqrt{2(\sqrt{3}) + 3} \approx \sqrt{2(1.73) + 3} = \sqrt{3.46 + 3} = \sqrt{6.46} \approx 2.54$

2. Démonstration par récurrence que pour tout $n \in \mathbb{N}$, $0 \le U_n \lt 3$ :
   Initialisation : Pour $n=0$, $U_0 = 0$, donc $0 \le 0 \lt 3$. La propriété est vraie pour $n=0$.
   Hérédité : Supposons que pour un certain entier $n$, $0 \le U_n \lt 3$. Montrons que $0 \le U_{n+1} \lt 3$.
   Puisque $0 \le U_n \lt 3$, alors $0 \le 2U_n \lt 6$. En ajoutant 3, on obtient $3 \le 2U_n + 3 \lt 9$.
   En prenant la racine carrée (la fonction racine carrée est croissante sur $[0, +\infty[$) :
   $\sqrt{3} \le \sqrt{2U_n + 3} \lt \sqrt{9}$
   $\sqrt{3} \le U_{n+1} \lt 3$.
   Puisque $\sqrt{3} \approx 1.73$, on a bien $0 \le \sqrt{3} \le U_{n+1} \lt 3$. La propriété est donc vraie pour $n+1$.
   Conclusion : Par le principe de récurrence, pour tout $n \in \mathbb{N}$, $0 \le U_n \lt 3$.

3. Étude du sens de variation de la suite $(U_n)$ :
   On étudie le signe de $U_{n+1} - U_n = \sqrt{2U_n + 3} - U_n$.
   On peut aussi comparer $f(x) = \sqrt{2x+3}$ et $y=x$.
   Cherchons les points fixes : $L = \sqrt{2L+3} \implies L^2 = 2L+3 \implies L^2 - 2L - 3 = 0$.
   Les solutions de cette équation sont $L = \frac{2 \pm \sqrt{4 - 4(1)(-3)}}{2} = \frac{2 \pm \sqrt{16}}{2} = \frac{2 \pm 4}{2}$.
   Donc $L = 3$ ou $L = -1$. Puisque $U_n \ge 0$, la limite éventuelle est $3$.
   Comparons $U_{n+1}$ et $U_n$ :
   $U_{n+1} - U_n = \sqrt{2U_n + 3} - U_n = \frac{(\sqrt{2U_n + 3} - U_n)(\sqrt{2U_n + 3} + U_n)}{\sqrt{2U_n + 3} + U_n} = \frac{2U_n + 3 - U_n^2}{\sqrt{2U_n + 3} + U_n} = \frac{-U_n^2 + 2U_n + 3}{\sqrt{2U_n + 3} + U_n}$.
   Le dénominateur est positif. Étudions le signe du numérateur : $-U_n^2 + 2U_n + 3$.
   Les racines de $-x^2 + 2x + 3 = 0$ sont $x=3$ et $x=-1$. Le polynôme est positif entre ses racines.
   Puisque $0 \le U_n \lt 3$, on a $-U_n^2 + 2U_n + 3 \ge 0$. (Pour $U_n=3$, le numérateur est 0, mais $U_n < 3$).
   Donc $U_{n+1} - U_n \ge 0$, ce qui signifie que la suite $(U_n)$ est croissante.

4. Convergence de la suite $(U_n)$ :
   La suite $(U_n)$ est croissante (d''après la question 3) et majorée par 3 (d''après la question 2).
   D''après le théorème de convergence des suites monotones et bornées, la suite $(U_n)$ est convergente.
   Soit $L$ sa limite. Alors $L$ doit satisfaire l''équation $L = \sqrt{2L+3}$.
   $L^2 = 2L+3 \implies L^2 - 2L - 3 = 0$.
   Les solutions sont $L=3$ et $L=-1$. Puisque $U_n \ge 0$ pour tout $n$, la limite ne peut pas être $-1$. De plus, la suite est croissante et $U_0 = 0$, donc la limite doit être supérieure ou égale à $U_0$. La limite est donc $L=3$.', '["Pour la question 2, pense à l''initialisation et à l''hérédité. Pour l''hérédité, tu peux étudier la fonction $f(x) = \\sqrt{2x+3}$ et son sens de variation.","Pour la question 3, tu peux étudier le signe de $U_{n+1} - U_n$. Tu peux aussi comparer $U_{n+1}$ et $U_n$ en utilisant la fonction $f(x) = \\sqrt{2x+3}$ et la droite d''équation $y=x$.","Pour la question 4, rappelle-toi les théorèmes sur les suites monotones et bornées. Si la suite converge vers une limite $L$, cette limite doit satisfaire l''équation $L = \\sqrt{2L+3}$."]'::jsonb, '2025-10-23T16:48:54.075458+00:00'::timestamptz, 'c00b87f111d27ec127716b204bd621495365bebb9659c4f35c1b6dc9ff4ce0d7', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('5cb55481-17bd-4c91-a567-a185a405ff06', 'Théorème de Thalès', 'Lycée', '{"contexte":"Soit un triangle $ABC$. On place un point $D$ sur le segment $[AB]$ et un point $E$ sur le segment $[AC]$ tels que $(DE)$ est parallèle à $(BC)$.\nOn donne les longueurs suivantes : $AB = 9$ cm, $AD = 3$ cm et $AC = 12$ cm.","questions":["Écris les rapports de longueurs égaux d''après le théorème de Thalès dans cette configuration.","Calcule la longueur du segment $AE$.","Si on te dit que $BC = 15$ cm, calcule la longueur du segment $DE$.","Explique comment tu as utilisé le théorème de Thalès pour trouver ces longueurs."]}', 'D''après le théorème de Thalès, puisque $(DE)$ est parallèle à $(BC)$, nous avons :

$\frac{AD}{AB} = \frac{AE}{AC} = \frac{DE}{BC}$

1. Calcul de $AE$ :
Nous avons $\frac{AD}{AB} = \frac{AE}{AC}$.
En remplaçant par les valeurs données : $\frac{3}{9} = \frac{AE}{12}$.
Pour trouver $AE$, on fait un produit en croix : $AE = \frac{3 \times 12}{9} = \frac{36}{9} = 4$ cm.

2. Calcul de $DE$ :
Nous avons $\frac{AD}{AB} = \frac{DE}{BC}$.
En remplaçant par les valeurs données : $\frac{3}{9} = \frac{DE}{15}$.
Pour trouver $DE$, on fait un produit en croix : $DE = \frac{3 \times 15}{9} = \frac{45}{9} = 5$ cm.

3. Explication de l''utilisation du théorème :
Le théorème de Thalès permet de calculer des longueurs inconnues dans des triangles en configuration de Thalès (triangles semblables), à condition que deux droites soient parallèles. Ici, il nous a permis d''établir une relation de proportionnalité entre les côtés des triangles $ADE$ et $ABC$, ce qui a rendu possible le calcul de $AE$ et $DE$ grâce aux longueurs connues.', '["Rappelle-toi la configuration de Thalès : deux triangles emboîtés ou en sablier avec des droites parallèles.","Les rapports sont de la forme $\\frac{\\text{petit côté}}{\\text{grand côté}}$ ou inversement, mais il faut garder la même logique pour tous les rapports.","Une fois que tu as les rapports égaux, tu peux utiliser un produit en croix pour trouver la longueur inconnue."]'::jsonb, '2025-10-23T20:46:30.162689+00:00'::timestamptz, '08e4c62bcd0cb074fbba62a91173d79ee2d7e2f6480a1b9345b52f14a84474c8', NULL),
('3aec4625-4dd2-4b40-a3a8-ee7409342315', 'Équations du second degré', 'Lycée', '{"contexte":"On cherche à résoudre l''équation suivante : $$x^2 - 2 = 0$$","questions":["Tu as bien vu qu''il fallait ajouter 2 de chaque côté. Peux-tu écrire l''équation obtenue après cette première étape ?"]}', '$$x^2 - 2 = 0$$ $$x^2 - 2 + 2 = 0 + 2$$ $$x^2 = 2$$', '["L''objectif est d''isoler le terme $x^2$ d''un côté de l''équation."]'::jsonb, '2025-10-23T22:07:26.640304+00:00'::timestamptz, 'f6212420cca67abc8798daa76fb1d1fb69373e9a060a4fddb26f8dc320e7504e', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('a5f7e497-460b-4e17-939c-7ed3e296d443', 'Équations du second degré', 'Lycée', '{"questions":["Pour résoudre une équation de la forme $x^2 = a$ (où $a$ est un nombre), quelle opération mathématique permet de trouver $x$ ?"],"contexte":"On cherche à résoudre l''équation : $$x^2 = 2$$"}', 'Pour résoudre $x^2 = a$ :
Si $a > 0$, alors $x = \sqrt{a}$ ou $x = -\sqrt{a}$.
Si $a = 0$, alors $x = 0$.
Si $a < 0$, alors il n''y a pas de solution réelle.

Dans notre cas, $x^2 = 2$, donc $a = 2$. Comme $2 > 0$, il y a deux solutions :
$x = \sqrt{2}$ ou $x = -\sqrt{2}$.', '["Réfléchis à l''opération inverse de ''mettre au carré''.","Pense aux nombres qui, multipliés par eux-mêmes, donnent 2."]'::jsonb, '2025-10-23T22:08:08.404435+00:00'::timestamptz, '25e4ce6bda6c329a3f0d3f1bb678a306998c75f611d1f7314ae6135e596be632', NULL),
('3223f014-c74b-41a5-827d-dc4c380ef6a4', 'Équations du second degré', 'Lycée', '{"contexte":"On cherche à résoudre l''équation : $$x^2 = 2$$","questions":["Quand tu as une équation du type $x^2 = a$ (où $a$ est un nombre positif), pour trouver $x$, tu dois utiliser l''opération inverse du carré. Cette opération est la **racine carrée**.","Par exemple, si $x^2 = 9$, alors $x = \\sqrt{9}$ ou $x = -\\sqrt{9}$, ce qui donne $x = 3$ ou $x = -3$.","En t''aidant de cet exemple, peux-tu me donner les solutions de l''équation $x^2 = 2$ ?"]}', 'Pour résoudre $x^2 = 2$ :
On prend la racine carrée de chaque côté, mais il faut penser aux deux solutions, positive et négative.
Les solutions sont donc $x = \sqrt{2}$ et $x = -\sqrt{2}$.', '["Souviens-toi qu''un nombre au carré peut donner un résultat positif, que ce nombre soit positif ou négatif.","Il y a donc souvent deux solutions quand tu prends la racine carrée."]'::jsonb, '2025-10-23T22:08:38.015562+00:00'::timestamptz, '5d173e8db8a92146017f01a3e93e1ae0e2e90f4a0a52b3d803036a75ca2d5aa8', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('7bf6830d-b8f4-43ba-8284-c40d73c568e7', 'Équations du second degré', 'Lycée', '{"questions":["Quand tu as une équation du type $x^2 = a$ (où $a$ est un nombre positif), pour trouver $x$, tu dois utiliser l''opération inverse du carré. Cette opération est la **racine carrée**.","Il est très important de se souvenir que si $x^2 = a$ (avec $a > 0$), alors il y a **deux** solutions possibles pour $x$ : $x = \\sqrt{a}$ et $x = -\\sqrt{a}$.","Par exemple, si $x^2 = 9$, alors $x = \\sqrt{9} = 3$ ou $x = -\\sqrt{9} = -3$. En effet, $3^2 = 9$ et $(-3)^2 = 9$.","Maintenant, en appliquant cette règle à notre équation $x^2 = 2$, quelles sont les deux solutions pour $x$ ?"],"contexte":"On cherche à résoudre l''équation : $$x^2 = 2$$"}', 'Pour l''équation $x^2 = 2$ :
Les deux solutions sont $x = \sqrt{2}$ et $x = -\sqrt{2}$.
On ne peut pas simplifier davantage $\sqrt{2}$, donc ce sont les valeurs exactes des solutions.', '["Pense à la définition de la racine carrée.","N''oublie pas qu''il y a une solution positive et une solution négative."]'::jsonb, '2025-10-23T22:09:16.911257+00:00'::timestamptz, 'c560f1e4ace0bf283801b4583400521c09a8bf8ca91ffeeddb8f60acd53a9698', NULL),
('a67f518a-1bee-4122-9470-d16921c07417', 'Équations du second degré', 'Lycée', '{"contexte":"On a résolu l''équation $x^2 - 2 = 0$ et nous avons trouvé que les solutions sont $x = \\sqrt{2}$ et $x = -\\sqrt{2}$.","questions":["Pour vérifier tes solutions, tu peux les remplacer dans l''équation de départ $x^2 - 2 = 0$.","Peux-tu me montrer comment tu vérifies l''une de ces solutions, par exemple $x = \\sqrt{2}$ ?"]}', 'Si $x = \sqrt{2}$ :
$(\sqrt{2})^2 - 2 = 2 - 2 = 0$. La solution est correcte.
Si $x = -\sqrt{2}$ :
$(-\sqrt{2})^2 - 2 = 2 - 2 = 0$. La solution est correcte.', '["Remplace $x$ par $\\sqrt{2}$ dans l''équation $x^2 - 2 = 0$.","Que vaut $(\\sqrt{2})^2$ ?"]'::jsonb, '2025-10-23T22:10:07.046629+00:00'::timestamptz, '5608d607027f8bf9545d4369c929e7411fc4b1babda526c4b0aa6e23dcd5e4a1', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('8d1aff70-dcb8-4fb5-b0e9-b29ac634bd7b', 'Équations du second degré', 'Lycée', '{"contexte":"Une équation du second degré est une équation que l''on peut écrire sous la forme générale $ax^2 + bx + c = 0$, où $a$, $b$ et $c$ sont des nombres réels, et $a$ est non nul.","questions":["Peux-tu me donner un exemple d''équation du second degré en choisissant tes propres valeurs pour $a$, $b$ et $c$ (avec $a \\neq 0$) ?","Pourquoi est-il important que le coefficient $a$ ne soit pas égal à zéro dans une équation du second degré ?"]}', '1. Exemple d''équation du second degré : $3x^2 - 5x + 2 = 0$.
2. Si $a=0$, l''équation devient $0x^2 + bx + c = 0$, ce qui se simplifie en $bx + c = 0$. Il s''agit alors d''une équation du premier degré, et non du second degré, car le terme en $x^2$ a disparu.', '["Un exemple simple peut être $x^2 + 2x + 1 = 0$.","Que se passerait-il si $a$ était égal à 0 ? Sous quelle forme l''équation se présenterait-elle alors ?"]'::jsonb, '2025-10-23T22:12:00.016452+00:00'::timestamptz, 'e5c9063cb20f74c667ddc47f29af24f43187a0d0abc2182ec0d8d0e9cd309f66', NULL),
('f058226d-92ad-450c-8531-fe34e00011e7', 'Équations du second degré', 'Lycée', '{"questions":["La première étape est d''identifier les coefficients $a$, $b$ et $c$ de l''équation $ax^2 + bx + c = 0$. Quelles sont ces valeurs pour notre équation $x^2 - 4x + 3 = 0$ ?","Une fois les coefficients identifiés, la formule la plus courante pour résoudre une équation du second degré est d''utiliser le **discriminant**, noté $\\Delta$ (delta). La formule du discriminant est : $$\\Delta = b^2 - 4ac$$ Calcule la valeur de $\\Delta$ pour notre équation.","Que signifie la valeur de $\\Delta$ que tu as trouvée ? Combien de solutions l''équation devrait-elle avoir dans ce cas ? (Indice : il y a trois cas possibles pour $\\Delta$)","Maintenant que tu connais $\\Delta$ et que tu sais combien de solutions il doit y avoir, utilise la formule des solutions pour les trouver. Les formules des solutions sont : $$x_1 = \\frac{-b - \\sqrt{\\Delta}}{2a}$$ $$x_2 = \\frac{-b + \\sqrt{\\Delta}}{2a}$$","Pour terminer, peux-tu vérifier l''une de tes solutions en la remplaçant dans l''équation de départ $x^2 - 4x + 3 = 0$ ?"],"contexte":"On veut résoudre l''équation du second degré suivante : $$x^2 - 4x + 3 = 0$$"}', '**1. Identification des coefficients :**
Pour $x^2 - 4x + 3 = 0$ :
$a = 1$
$b = -4$
$c = 3$

**2. Calcul du discriminant $\Delta$ :**
$\Delta = b^2 - 4ac$
$\Delta = (-4)^2 - 4 \times 1 \times 3$
$\Delta = 16 - 12$
$\Delta = 4$

**3. Interprétation de $\Delta$ :**
Puisque $\Delta = 4 > 0$, l''équation possède **deux solutions réelles distinctes**.

**4. Calcul des solutions :**
$x_1 = \frac{-b - \sqrt{\Delta}}{2a} = \frac{-(-4) - \sqrt{4}}{2 \times 1} = \frac{4 - 2}{2} = \frac{2}{2} = 1$
$x_2 = \frac{-b + \sqrt{\Delta}}{2a} = \frac{-(-4) + \sqrt{4}}{2 \times 1} = \frac{4 + 2}{2} = \frac{6}{2} = 3$
Les solutions de l''équation sont donc $x_1 = 1$ et $x_2 = 3$.

**5. Vérification d''une solution (par exemple $x_1 = 1$) :**
$x^2 - 4x + 3 = 0$
$(1)^2 - 4(1) + 3 = 1 - 4 + 3 = 0$
La solution $x_1 = 1$ est correcte.
(Vérification pour $x_2 = 3$ : $(3)^2 - 4(3) + 3 = 9 - 12 + 3 = 0$. La solution $x_2 = 3$ est correcte.)', '["Pour $x^2 - 4x + 3 = 0$, $a$ est le coefficient de $x^2$, $b$ celui de $x$, et $c$ le terme constant.","Fais attention aux signes lorsque tu calcules $\\Delta$. $b$ est $-4$, donc $b^2$ est $(-4)^2$.","Si $\\Delta > 0$, il y a deux solutions réelles distinctes. Si $\\Delta = 0$, il y a une seule solution réelle (double). Si $\\Delta < 0$, il n''y a pas de solution réelle.","N''oublie pas que $\\sqrt{\\Delta}$ doit être calculé avant de faire les additions ou soustractions.","Remplace la valeur de $x$ que tu as trouvée dans l''équation $x^2 - 4x + 3 = 0$ et vérifie si le résultat est bien $0$."]'::jsonb, '2025-10-23T22:12:40.927028+00:00'::timestamptz, '89a6c7ac8744e752f28c3cab80bd5ac51b11cf826007c0a587d975415396e050', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('5b048660-3af7-4e36-9eb7-e6baf4e18921', 'Dérivation et étude de fonctions', 'Lycée', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{(2x+1)^3}{x^2}$.","questions":["Détermine l''expression de la fonction dérivée $f''(x)$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}^*$.","Dresse le tableau de variations complet de la fonction $f$."]}', '$$f(x) = \frac{(2x+1)^3}{x^2}$$', '["Pense à la formule de dérivation d''un quotient : $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas la dérivation des fonctions composées pour $(2x+1)^3$.","Pour le signe de $f''(x)$, essaie de factoriser le numérateur au maximum."]'::jsonb, '2025-10-24T17:14:38.018377+00:00'::timestamptz, '6e0c9ec92b4eae0670034d34066ef92cd58adca0242d611e590fd97b873a1718', NULL),
('471cc1ec-8691-45b9-9922-75c4322136c9', 'Dérivation et étude de fonctions', 'Lycée', '{"questions":["Justifie pourquoi la fonction $f$ est bien définie sur $]0 ; +\\infty[$.","Détermine l''expression de la fonction dérivée $f''(x)$ et simplifie-la au maximum.","Étudie le signe de $f''(x)$ sur $]0 ; +\\infty[$.","Dresse le tableau de variations complet de la fonction $f$ sur son ensemble de définition.","Détermine l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=1$."],"contexte":"Soit la fonction $f$ définie sur $]0 ; +\\infty[$ par $f(x) = x \\sqrt{\\frac{x}{x+1}}$."}', '1. Justification de la définition de $f$ sur $]0 ; +\infty[$ :
Pour que $f(x)$ soit définie, il faut que l''expression sous la racine carrée soit positive ou nulle et que le dénominateur de la fraction soit non nul.
- La racine carrée : $\frac{x}{x+1} \ge 0$.
  - Sur $]0 ; +\infty[$, $x > 0$ et $x+1 > 0$, donc $\frac{x}{x+1} > 0$. La condition est satisfaite.
- Le dénominateur de la fraction : $x+1 \ne 0$. Sur $]0 ; +\infty[$, $x+1 > 0$, donc $x+1 \ne 0$. La condition est satisfaite.
- Le terme $x$ devant la racine ne pose pas de problème sur $]0 ; +\infty[$.
Donc, $f$ est bien définie sur $]0 ; +\infty[$.

2. Détermination de $f''(x)$ :
On peut écrire $f(x) = x \sqrt{\frac{x}{x+1}} = x \frac{\sqrt{x}}{\sqrt{x+1}} = \frac{x^{3/2}}{\sqrt{x+1}}$.
On utilise la formule de dérivation d''un quotient $(\frac{u}{v})'' = \frac{u''v - uv''}{v^2}$.
Posons $u(x) = x^{3/2}$ et $v(x) = (x+1)^{1/2}$.
$u''(x) = \frac{3}{2} x^{1/2} = \frac{3\sqrt{x}}{2}$.
$v''(x) = \frac{1}{2} (x+1)^{-1/2} = \frac{1}{2\sqrt{x+1}}$.

$f''(x) = \frac{\frac{3\sqrt{x}}{2} \sqrt{x+1} - x^{3/2} \frac{1}{2\sqrt{x+1}}}{(\sqrt{x+1})^2}$
$f''(x) = \frac{\frac{3\sqrt{x}\sqrt{x+1}}{2} - \frac{x\sqrt{x}}{2\sqrt{x+1}}}{x+1}$
Mettons le numérateur sur un dénominateur commun $2\sqrt{x+1}$ :
$f''(x) = \frac{\frac{3\sqrt{x}(x+1) - x\sqrt{x}}{2\sqrt{x+1}}}{x+1}$
$f''(x) = \frac{3x\sqrt{x} + 3\sqrt{x} - x\sqrt{x}}{2\sqrt{x+1}(x+1)}$
$f''(x) = \frac{2x\sqrt{x} + 3\sqrt{x}}{2(x+1)^{3/2}}$
$f''(x) = \frac{\sqrt{x}(2x+3)}{2(x+1)^{3/2}}$.

3. Étude du signe de $f''(x)$ sur $]0 ; +\infty[$ :
Sur $]0 ; +\infty[$ :
- $\sqrt{x} > 0$
- $2x+3 > 0$
- $2(x+1)^{3/2} > 0$
Donc, $f''(x) > 0$ sur $]0 ; +\infty[$.

4. Tableau de variations de $f$ :
Puisque $f''(x) > 0$ sur $]0 ; +\infty[$, la fonction $f$ est strictement croissante sur cet intervalle.
Limites :
- $\lim_{x \to 0^+} f(x) = \lim_{x \to 0^+} x \sqrt{\frac{x}{x+1}} = 0 \times \sqrt{0} = 0$.
- $\lim_{x \to +\infty} f(x) = \lim_{x \to +\infty} x \sqrt{\frac{x}{x+1}} = \lim_{x \to +\infty} x \sqrt{\frac{1}{1+\frac{1}{x}}} = +\infty \times \sqrt{1} = +\infty$.

| $x$ | $0$ | $+ \infty$ |
|-----|-----|-------------|
| $f''(x)$ | | $+$ |
| $f(x)$ | $0$ | $\nearrow +\infty$ |

5. Équation de la tangente au point d''abscisse $x=1$ :
- Calcul de $f(1)$ :
$f(1) = 1 \sqrt{\frac{1}{1+1}} = 1 \sqrt{\frac{1}{2}} = \frac{1}{\sqrt{2}} = \frac{\sqrt{2}}{2}$.
- Calcul de $f''(1)$ :
$f''(1) = \frac{\sqrt{1}(2(1)+3)}{2(1+1)^{3/2}} = \frac{1(5)}{2(2)^{3/2}} = \frac{5}{2 \times 2\sqrt{2}} = \frac{5}{4\sqrt{2}} = \frac{5\sqrt{2}}{8}$.
- Équation de la tangente $T$ :
$y = f''(1)(x-1) + f(1)$
$y = \frac{5\sqrt{2}}{8}(x-1) + \frac{\sqrt{2}}{2}$
$y = \frac{5\sqrt{2}}{8}x - \frac{5\sqrt{2}}{8} + \frac{4\sqrt{2}}{8}$
$y = \frac{5\sqrt{2}}{8}x - \frac{\sqrt{2}}{8}$', '["Pour la justification, pense aux conditions d''existence d''une racine carrée et d''un dénominateur non nul.","Pour la dérivation, utilise la formule du produit $(uv)'' = u''v + uv''$ et la formule de dérivation d''une racine carrée $(\\sqrt{u})'' = \\frac{u''}{2\\sqrt{u}}$.","N''oublie pas de simplifier l''expression sous la racine avant de dériver pour faciliter les calculs.","Pour le signe de la dérivée, essaie de tout mettre sur un même dénominateur et de factoriser.","L''équation de la tangente s''écrit $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-10-24T17:15:18.013927+00:00'::timestamptz, '8d06f498e1bce1a1fb8bff313e19298de0c8f73214d6b76373019e3140ce7f09', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('8c2b97b5-932d-449f-bd9d-7f132d13618c', 'Dérivation', 'Lycée', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}^*$.","Déduis-en le tableau de variations de $f$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{1}{x} \\cdot e^{\\frac{1}{x}}$."}', '1. Calcul de la dérivée $f''(x)$ :
Soit $u(x) = \frac{1}{x}$ et $v(x) = e^{\frac{1}{x}}$.
Alors $u''(x) = -\frac{1}{x^2}$.
Pour $v''(x)$, on utilise la formule $(e^w)'' = w''e^w$ avec $w(x) = \frac{1}{x}$.
Donc $w''(x) = -\frac{1}{x^2}$.
$v''(x) = -\frac{1}{x^2}e^{\frac{1}{x}}$.

En utilisant la formule $(uv)'' = u''v + uv''$ :
$f''(x) = \left(-\frac{1}{x^2}\right) \cdot e^{\frac{1}{x}} + \frac{1}{x} \cdot \left(-\frac{1}{x^2}e^{\frac{1}{x}}\right)$
$f''(x) = -\frac{1}{x^2}e^{\frac{1}{x}} - \frac{1}{x^3}e^{\frac{1}{x}}$
$f''(x) = e^{\frac{1}{x}} \left(-\frac{1}{x^2} - \frac{1}{x^3}\right)$
$f''(x) = e^{\frac{1}{x}} \left(-\frac{x}{x^3} - \frac{1}{x^3}\right)$
$f''(x) = -\frac{x+1}{x^3}e^{\frac{1}{x}}$

2. Étude du signe de $f''(x)$ sur $\mathbb{R}^*$ :
Le terme $e^{\frac{1}{x}}$ est toujours strictement positif.
Il faut donc étudier le signe de $-\frac{x+1}{x^3}$.

Signe de $x+1$ :
$x+1 > 0 \implies x > -1$
$x+1 < 0 \implies x < -1$

Signe de $x^3$ :
$x^3 > 0 \implies x > 0$
$x^3 < 0 \implies x < 0$

Tableau de signes de $-\frac{x+1}{x^3}$ :

| $x$             | $-\infty$ | $-1$      | $0$     | $+\infty$ |
|-----------------|------------|-----------|---------|------------|
| $x+1$           | $-$        | $0$       | $+$     | $+$        |
| $x^3$           | $-$        | $-$       | $0$     | $+$        |
| $\frac{x+1}{x^3}$ | $+$        | $0$       | $||$      | $+$        |
| $-\frac{x+1}{x^3}$| $-$        | $0$       | $||$      | $-$        |

Donc $f''(x) > 0$ sur $]-1; 0[$ et $f''(x) < 0$ sur $]-\infty; -1[$ et sur $]0; +\infty[$.

3. Tableau de variations de $f$ :

| $x$             | $-\infty$ | $-1$      | $0$     | $+\infty$ |
|-----------------|------------|-----------|---------|------------|
| $f''(x)$         | $-$        | $0$       | $||$      | $-$        |
| Variations de $f$| Décroissante | $f(-1)$   | $||$      | Décroissante |

Calcul de $f(-1)$ :
$f(-1) = \frac{1}{-1} e^{\frac{1}{-1}} = -1 \cdot e^{-1} = -\frac{1}{e}$.

Il faut aussi déterminer les limites aux bornes de l''ensemble de définition.
$\lim_{x \to -\infty} f(x) = \lim_{x \to -\infty} \frac{1}{x} e^{\frac{1}{x}} = 0 \cdot e^0 = 0 \cdot 1 = 0$
$\lim_{x \to 0^-} f(x) = \lim_{x \to 0^-} \frac{1}{x} e^{\frac{1}{x}}$. Posons $y = \frac{1}{x}$. Quand $x \to 0^-$, $y \to -\infty$.
$\lim_{y \to -\infty} y e^y = 0$ (croissances comparées)
$\lim_{x \to 0^+} f(x) = \lim_{x \to 0^+} \frac{1}{x} e^{\frac{1}{x}}$. Posons $y = \frac{1}{x}$. Quand $x \to 0^+$, $y \to +\infty$.
$\lim_{y \to +\infty} y e^y = +\infty$
$\lim_{x \to +\infty} f(x) = \lim_{x \to +\infty} \frac{1}{x} e^{\frac{1}{x}} = 0 \cdot e^0 = 0 \cdot 1 = 0$

Tableau de variations complet :

| $x$             | $-\infty$ | $-1$        | $0^-$     | $0^+$     | $+\infty$ |
|-----------------|------------|-------------|-----------|-----------|------------|
| $f''(x)$         | $-$        | $0$         | $+$       | $||$      | $-$        |
| Variations de $f$| $0 \searrow$ | $f(-1) = -\frac{1}{e} \nearrow$ | $0$       | $+\infty \searrow$ | $0$        |', '["Pense à la formule de la dérivée d''un produit : $(uv)'' = u''v + uv''$.","N''oublie pas la dérivée de $e^u$, qui est $u''e^u$.","La dérivée de $\\frac{1}{x}$ est $-\\frac{1}{x^2}$."]'::jsonb, '2025-10-24T17:23:13.126462+00:00'::timestamptz, '4e0c4cbe48119f49b5a9f4e32153626371ea1cae57f811673081ace9806c8b79', NULL),
('555dc40a-655a-4d0c-827b-7b1e6a775672', 'Dérivation', 'Lycée', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x \\sqrt{x^2+1}$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}$.","Déduis-en le tableau de variations de $f$."]}', '1. Calcul de la dérivée $f''(x)$ :
Soit $u(x) = x$ et $v(x) = \sqrt{x^2+1}$.
Alors $u''(x) = 1$.
Pour $v''(x)$, on utilise la formule $(\sqrt{w})'' = \frac{w''}{2\sqrt{w}}$ avec $w(x) = x^2+1$.
Donc $w''(x) = 2x$.
$v''(x) = \frac{2x}{2\sqrt{x^2+1}} = \frac{x}{\sqrt{x^2+1}}$.

En utilisant la formule $(uv)'' = u''v + uv''$ :
$f''(x) = 1 \cdot \sqrt{x^2+1} + x \cdot \frac{x}{\sqrt{x^2+1}}$
$f''(x) = \sqrt{x^2+1} + \frac{x^2}{\sqrt{x^2+1}}$
$f''(x) = \frac{(\sqrt{x^2+1})(\sqrt{x^2+1}) + x^2}{\sqrt{x^2+1}}$
$f''(x) = \frac{x^2+1 + x^2}{\sqrt{x^2+1}}$
$f''(x) = \frac{2x^2+1}{\sqrt{x^2+1}}$

2. Étude du signe de $f''(x)$ sur $\mathbb{R}$ :
Le numérateur $2x^2+1$ est toujours strictement positif car $x^2 \ge 0$, donc $2x^2 \ge 0$, et $2x^2+1 \ge 1$.
Le dénominateur $\sqrt{x^2+1}$ est toujours strictement positif car $x^2+1 \ge 1$, donc sa racine carrée est positive.
Par conséquent, $f''(x)$ est toujours strictement positif sur $\mathbb{R}$.

3. Tableau de variations de $f$ :

| $x$             | $-\infty$ | $+\infty$ |
|-----------------|------------|------------|
| $f''(x)$         | $+$        | $+$        |
| Variations de $f$| Croissante | Croissante |

Calcul des limites :
$\lim_{x \to -\infty} f(x) = \lim_{x \to -\infty} x \sqrt{x^2+1}$.
Quand $x \to -\infty$, $x < 0$. On peut écrire $f(x) = -\sqrt{x^2} \sqrt{x^2+1} = -\sqrt{x^2(x^2+1)} = -\sqrt{x^4+x^2}$.
Donc $\lim_{x \to -\infty} f(x) = -\infty$.

$\lim_{x \to +\infty} f(x) = \lim_{x \to +\infty} x \sqrt{x^2+1} = +\infty$.

Tableau de variations complet :

| $x$             | $-\infty$ | $+\infty$ |
|-----------------|------------|------------|
| $f''(x)$         | $+$        | $+$        |
| Variations de $f$| $-\infty \nearrow$ | $+\infty$ |', '["Pense à la formule de la dérivée d''un produit : $(uv)'' = u''v + uv''$.","N''oublie pas la dérivée de $\\sqrt{u}$, qui est $\\frac{u''}{2\\sqrt{u}}$.","Pour le signe de $f''(x)$, essaie de factoriser l''expression."]'::jsonb, '2025-10-24T17:24:01.067595+00:00'::timestamptz, '9ae835500994d3495f15269a9dabb122dfd45588e91139a13feed08b4957b3cf', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('0b9cf362-e135-4e73-8097-d183493d7990', 'Vecteurs et repérage', 'Lycée', '{"questions":["Calcule les coordonnées des vecteurs $\\vec{AB}$ et $\\vec{BC}$.","Démontre que le triangle $ABC$ est un triangle isocèle en $B$.","Détermine les coordonnées du point $D$ tel que $ABCD$ soit un parallélogramme.","Calcule les coordonnées du milieu $M$ du segment $[AC]$. Que peux-tu en déduire pour le point $M$ et le parallélogramme $ABCD$ ?","Calcule la longueur de la médiane issue de $B$ dans le triangle $ABC$."],"contexte":"Dans un repère orthonormé $(O; \\vec{i}, \\vec{j})$, on considère les points $A(-2; 1)$, $B(3; 4)$ et $C(1; -2)$."}', '1. Coordonnées des vecteurs :
$\vec{AB} = (3 - (-2); 4 - 1) = (5; 3)$
$\vec{BC} = (1 - 3; -2 - 4) = (-2; -6)$

2. Nature du triangle $ABC$ :
$AB = \sqrt{(5)^2 + (3)^2} = \sqrt{25 + 9} = \sqrt{34}$
$BC = \sqrt{(-2)^2 + (-6)^2} = \sqrt{4 + 36} = \sqrt{40}$
$AC = \sqrt{(1 - (-2))^2 + (-2 - 1)^2} = \sqrt{(3)^2 + (-3)^2} = \sqrt{9 + 9} = \sqrt{18}$
Le triangle $ABC$ n''est pas isocèle en $B$ car $AB \neq BC$. Il y a eu une erreur dans l''énoncé. Le triangle est isocèle en $C$ si $AC=BC$. Dans ce cas, $AC = \sqrt{18}$ et $BC = \sqrt{40}$. Il n''est pas isocèle. Je te présente mes excuses pour cette erreur dans la conception de l''exercice. Nous allons continuer avec les questions suivantes.

3. Coordonnées du point $D$ :
Pour que $ABCD$ soit un parallélogramme, $\vec{AB} = \vec{DC}$.
Soit $D(x_D; y_D)$. $\vec{DC} = (1 - x_D; -2 - y_D)$.
Donc $1 - x_D = 5 \implies x_D = -4$
Et $-2 - y_D = 3 \implies y_D = -5$
Donc $D(-4; -5)$.

4. Coordonnées du milieu $M$ de $[AC]$ :
$M = (\frac{-2 + 1}{2}; \frac{1 + (-2)}{2}) = (\frac{-1}{2}; \frac{-1}{2})$
Les diagonales d''un parallélogramme se coupent en leur milieu. Donc $M$ est le milieu de $[BD]$ également.

5. Longueur de la médiane issue de $B$ :
La médiane issue de $B$ est le segment $[BM]$.
$BM = \sqrt{(\frac{-1}{2} - 3)^2 + (\frac{-1}{2} - 4)^2} = \sqrt{(\frac{-1 - 6}{2})^2 + (\frac{-1 - 8}{2})^2}$
$BM = \sqrt{(\frac{-7}{2})^2 + (\frac{-9}{2})^2} = \sqrt{\frac{49}{4} + \frac{81}{4}} = \sqrt{\frac{130}{4}} = \frac{\sqrt{130}}{2}$.', '["Pour calculer les coordonnées d''un vecteur $\\vec{AB}$, tu dois faire $(x_B - x_A; y_B - y_A)$.","Pour montrer qu''un triangle est isocèle, tu dois calculer les longueurs des côtés et vérifier si deux côtés sont de même longueur. La formule de la distance entre deux points $P(x_P; y_P)$ et $Q(x_Q; y_Q)$ est $\\sqrt{(x_Q - x_P)^2 + (y_Q - y_P)^2}$.","Pour que $ABCD$ soit un parallélogramme, les vecteurs $\\vec{AB}$ et $\\vec{DC}$ doivent être égaux. Tu peux aussi utiliser le fait que les diagonales se coupent en leur milieu.","Le milieu $M$ d''un segment $[AC]$ a pour coordonnées $(\\frac{x_A + x_C}{2}; \\frac{y_A + y_C}{2})$.","La médiane issue de $B$ est le segment qui relie le sommet $B$ au milieu du côté opposé, c''est-à-dire le point $M$ que tu as calculé précédemment. Il faut donc calculer la distance $BM$."]'::jsonb, '2025-10-24T17:30:12.37387+00:00'::timestamptz, '568eee1b41b2bfef272dbf69820de228b9f802517784e028ef33346ba74aa497', NULL),
('4bad1707-abc6-4ca8-84fc-22eaad46b87b', 'Dérivation', 'Lycée', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Donne l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=0$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x^2 - 5x + 1) e^x$."}', '1. Calcul de la dérivée $f''(x)$ :
On utilise la formule de dérivation d''un produit $(uv)'' = u''v + uv''$ avec :
$u(x) = 3x^2 - 5x + 1 \implies u''(x) = 6x - 5$
$v(x) = e^x \implies v''(x) = e^x$

Donc :
$f''(x) = (6x - 5)e^x + (3x^2 - 5x + 1)e^x$
$f''(x) = e^x (6x - 5 + 3x^2 - 5x + 1)$
$f''(x) = e^x (3x^2 + x - 4)$

2. Équation de la tangente au point d''abscisse $x=0$ :
On utilise la formule $y = f''(a)(x-a) + f(a)$ avec $a=0$.

$f(0) = (3(0)^2 - 5(0) + 1)e^0 = (0 - 0 + 1) \times 1 = 1$
$f''(0) = e^0 (3(0)^2 + 0 - 4) = 1 \times (0 + 0 - 4) = -4$

L''équation de la tangente est donc :
$y = -4(x - 0) + 1$
$y = -4x + 1$', '["N''oublie pas la formule de dérivation d''un produit de fonctions : $(uv)'' = u''v + uv''$.","Pour l''équation de la tangente, utilise la formule $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-10-24T17:30:37.263387+00:00'::timestamptz, '8c513b1b49e98c4efc79e3b6371717c1809ba3a35a06be097861d882179e8100', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('9dccc543-ca46-4a32-b492-d3647ae76262', 'Limites de suites', 'Lycée', '{"questions":["Calcule les trois premiers termes de la suite : $U_0$, $U_1$, $U_2$.","Pour étudier la limite de la suite $(U_n)$ lorsque $n$ tend vers l''infini, quel est le terme de plus haut degré au numérateur et au dénominateur ?","En factorisant par le terme de plus haut degré au numérateur et au dénominateur, écris la suite $(U_n)$ sous une autre forme.","Détermine la limite de $\\frac{1}{n}$ lorsque $n$ tend vers l''infini.","En déduis la limite de la suite $(U_n)$ lorsque $n$ tend vers l''infini et justifie ta réponse."],"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n$ par $U_n = \\frac{2n + 3}{n + 1}$."}', '1. Calcul des premiers termes :
$U_0 = \frac{2(0) + 3}{0 + 1} = \frac{3}{1} = 3$
$U_1 = \frac{2(1) + 3}{1 + 1} = \frac{5}{2} = 2,5$
$U_2 = \frac{2(2) + 3}{2 + 1} = \frac{7}{3} \approx 2,33$

2. Les termes de plus haut degré sont $2n$ au numérateur et $n$ au dénominateur.

3. Factorisation :
$U_n = \frac{n(2 + \frac{3}{n})}{n(1 + \frac{1}{n})} = \frac{2 + \frac{3}{n}}{1 + \frac{1}{n}}$

4. Limite de $\frac{1}{n}$ :
$\lim_{n \to +\infty} \frac{1}{n} = 0$

5. Déduction de la limite de $U_n$ :
Comme $\lim_{n \to +\infty} \frac{3}{n} = 0$ et $\lim_{n \to +\infty} \frac{1}{n} = 0$,
alors $\lim_{n \to +\infty} (2 + \frac{3}{n}) = 2 + 0 = 2$
et $\lim_{n \to +\infty} (1 + \frac{1}{n}) = 1 + 0 = 1$
Par conséquent, par quotient des limites :
$\lim_{n \to +\infty} U_n = \frac{2}{1} = 2$', '["Pour calculer les premiers termes, remplace simplement $n$ par la valeur correspondante.","Pour la limite d''une fonction rationnelle (quotient de polynômes), on peut se concentrer sur les termes de plus haut degré.","Pour factoriser, pense à mettre $n$ en facteur au numérateur et au dénominateur.","La limite de $\\frac{1}{n}$ est une limite de référence que tu dois connaître.","Utilise les propriétés des limites pour les sommes et les quotients."]'::jsonb, '2025-10-25T14:52:17.222504+00:00'::timestamptz, 'ccfa85bf1eba8b88fe8dd81daf798c5963f2e0e0a0e2ff74822dd9744f3e0548', NULL),
('c88e84bd-1531-47de-a43c-db108b67f33e', 'Limites de suites', 'Lycée', '{"questions":["Quel est le terme de plus haut degré au numérateur de $V_n$ ?","Quel est le terme de plus haut degré au dénominateur de $V_n$ ?","En factorisant par le terme de plus haut degré au numérateur et au dénominateur, écris la suite $(V_n)$ sous une forme simplifiée.","Détermine la limite de chaque terme de la forme simplifiée lorsque $n$ tend vers l''infini.","En déduis la limite de la suite $(V_n)$ lorsque $n$ tend vers l''infini et justifie ta réponse."],"contexte":"Soit la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = \\frac{n^2 - 4n + 1}{2n^2 + n - 3}$."}', '1. Le terme de plus haut degré au numérateur est $n^2$.
2. Le terme de plus haut degré au dénominateur est $2n^2$.
3. Factorisation :
$V_n = \frac{n^2(1 - \frac{4}{n} + \frac{1}{n^2})}{n^2(2 + \frac{1}{n} - \frac{3}{n^2})} = \frac{1 - \frac{4}{n} + \frac{1}{n^2}}{2 + \frac{1}{n} - \frac{3}{n^2}}$
4. Limites des termes :
$\lim_{n \to +\infty} \frac{4}{n} = 0$
$\lim_{n \to +\infty} \frac{1}{n^2} = 0$
$\lim_{n \to +\infty} \frac{3}{n^2} = 0$
5. Déduction de la limite de $V_n$ :
$\lim_{n \to +\infty} (1 - \frac{4}{n} + \frac{1}{n^2}) = 1 - 0 + 0 = 1$
$\lim_{n \to +\infty} (2 + \frac{1}{n} - \frac{3}{n^2}) = 2 + 0 - 0 = 2$
Par conséquent, par quotient des limites :
$\lim_{n \to +\infty} V_n = \frac{1}{2}$', '["Concentres-toi sur les puissances de $n$ les plus élevées au numérateur et au dénominateur.","N''oublie pas de factoriser par $n^2$ en haut et en bas.","Pense aux limites des fractions du type $\\frac{k}{n^p}$ quand $n$ tend vers l''infini."]'::jsonb, '2025-10-25T14:52:53.121677+00:00'::timestamptz, '71c88efe731f2687ee6fbf635a5a56a215e49b9a58d61897bcae7fdb67a212fb', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('329b1c28-7eb3-444d-967c-c6a7d0f483b2', 'Suites numériques', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 5$ et, pour tout entier naturel $n$, $U_{n+1} = \\frac{1}{2}U_n + 3$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$.","La suite $(U_n)$ semble-t-elle arithmétique ? Justifie ta réponse.","La suite $(U_n)$ semble-t-elle géométrique ? Justifie ta réponse.","On considère la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n - 6$. Calcule $V_0$, $V_1$ et $V_2$.","Montre que la suite $(V_n)$ est une suite géométrique. Précise sa raison et son premier terme.","Exprime $V_n$ en fonction de $n$.","En déduis l''expression de $U_n$ en fonction de $n$."]}', '1. Calcul des premiers termes :
$U_0 = 5$
$U_1 = \frac{1}{2}(5) + 3 = 2.5 + 3 = 5.5$
$U_2 = \frac{1}{2}(5.5) + 3 = 2.75 + 3 = 5.75$
$U_3 = \frac{1}{2}(5.75) + 3 = 2.875 + 3 = 5.875$

2. La suite $(U_n)$ ne semble pas arithmétique car :
$U_1 - U_0 = 5.5 - 5 = 0.5$
$U_2 - U_1 = 5.75 - 5.5 = 0.25$
La différence n''est pas constante.

3. La suite $(U_n)$ ne semble pas géométrique car :
$\frac{U_1}{U_0} = \frac{5.5}{5} = 1.1$
$\frac{U_2}{U_1} = \frac{5.75}{5.5} \approx 1.045$
Le quotient n''est pas constant.

4. Calcul de $V_0$, $V_1$ et $V_2$ :
$V_0 = U_0 - 6 = 5 - 6 = -1$
$V_1 = U_1 - 6 = 5.5 - 6 = -0.5$
$V_2 = U_2 - 6 = 5.75 - 6 = -0.25$

5. Montrons que la suite $(V_n)$ est géométrique :
On a $V_n = U_n - 6$, donc $U_n = V_n + 6$.
On sait que $U_{n+1} = \frac{1}{2}U_n + 3$.
Remplaçons $U_n$ et $U_{n+1}$ :
$V_{n+1} + 6 = \frac{1}{2}(V_n + 6) + 3$
$V_{n+1} + 6 = \frac{1}{2}V_n + \frac{1}{2}(6) + 3$
$V_{n+1} + 6 = \frac{1}{2}V_n + 3 + 3$
$V_{n+1} + 6 = \frac{1}{2}V_n + 6$
$V_{n+1} = \frac{1}{2}V_n$
La suite $(V_n)$ est donc une suite géométrique de raison $q = \frac{1}{2}$ et de premier terme $V_0 = -1$.

6. Expression de $V_n$ en fonction de $n$ :
Comme $(V_n)$ est une suite géométrique, $V_n = V_0 \times q^n$.
$V_n = -1 \times (\frac{1}{2})^n = -(\frac{1}{2})^n$.

7. Déduction de $U_n$ en fonction de $n$ :
On a $V_n = U_n - 6$, donc $U_n = V_n + 6$.
$U_n = -(\frac{1}{2})^n + 6$.', '["Pour calculer les termes, utilise la relation $U_{n+1} = \\frac{1}{2}U_n + 3$ en partant de $U_0 = 5$.","Pour savoir si une suite est arithmétique, tu dois vérifier si la différence entre deux termes consécutifs est constante. C''est-à-dire si $U_{n+1} - U_n$ est une constante.","Pour savoir si une suite est géométrique, tu dois vérifier si le quotient entre deux termes consécutifs est constant. C''est-à-dire si $\\frac{U_{n+1}}{U_n}$ est une constante.","Pour montrer que $(V_n)$ est géométrique, exprime $V_{n+1}$ en fonction de $V_n$. N''oublie pas d''utiliser l''expression $U_n = V_n + 6$.","Une fois que tu as $V_n$ en fonction de $n$, tu peux facilement trouver $U_n$ en fonction de $n$ grâce à la relation $V_n = U_n - 6$."]'::jsonb, '2025-10-25T15:51:31.889453+00:00'::timestamptz, 'd1cc28a36ecd07576b235e5d3d9e14e40142e916f16ea796104654d127e9543f', NULL),
('d4bad9cc-1eb0-4973-bb36-2d982332e31f', 'Dérivées de fonctions', 'Lycée', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{x^2 + 3}{x}$.","questions":["Détermine l''expression de la fonction dérivée $f''(x)$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}^*$.","Dresse le tableau de variations de la fonction $f$."]}', '1. Dérivation :
$f(x) = \frac{x^2 + 3}{x}$
C''est une fonction de la forme $\frac{u}{v}$ avec $u(x) = x^2 + 3$ et $v(x) = x$.
Alors $u''(x) = 2x$ et $v''(x) = 1$.
La formule de dérivation du quotient est $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{v(x)^2}$.
$f''(x) = \frac{(2x)(x) - (x^2 + 3)(1)}{x^2}$
$f''(x) = \frac{2x^2 - x^2 - 3}{x^2}$
$f''(x) = \frac{x^2 - 3}{x^2}$

2. Étude du signe de $f''(x)$ :
Le dénominateur $x^2$ est toujours positif pour $x \neq 0$.
Il faut donc étudier le signe du numérateur $x^2 - 3$.
$x^2 - 3 = 0 \iff x^2 = 3 \iff x = \sqrt{3}$ ou $x = -\sqrt{3}$.
$x^2 - 3 > 0$ pour $x \in ]-\infty; -\sqrt{3}[ \cup ]\sqrt{3}; +\infty[$.
$x^2 - 3 < 0$ pour $x \in ]-\sqrt{3}; 0[ \cup ]0; \sqrt{3}[$.

3. Tableau de variations :

$x$             $-\infty$    $-\sqrt{3}$       $0$        $\sqrt{3}$    $+\infty$
$x^2 - 3$      $+$         $0$      $-$    $||$     $-$     $0$      $+$ 
$x^2$          $+$         $|$      $+$    $||$     $+$     $|$      $+$ 
$f''(x)$         $+$         $0$      $-$    $||$     $-$     $0$      $+$ 
$f(x)$        croissant    $f(-\sqrt{3})$ décroissant $||$ décroissant $f(\sqrt{3})$ croissant

$f(-\sqrt{3}) = \frac{(-\sqrt{3})^2 + 3}{-\sqrt{3}} = \frac{3 + 3}{-\sqrt{3}} = \frac{6}{-\sqrt{3}} = -2\sqrt{3}$.
$f(\sqrt{3}) = \frac{(\sqrt{3})^2 + 3}{\sqrt{3}} = \frac{3 + 3}{\sqrt{3}} = \frac{6}{\sqrt{3}} = 2\sqrt{3}$.', '["Quelle formule de dérivation dois-tu utiliser pour une fonction de la forme $\\frac{u}{v}$ ?","N''oublie pas que $x^2$ est toujours positif.","La dérivée de $x^2$ est $2x$ et la dérivée de $3$ est $0$.","Attention au domaine de définition de la fonction et de sa dérivée."]'::jsonb, '2025-10-25T16:22:51.217443+00:00'::timestamptz, '01475b13c00f645ad8c4b375656703dc7c33ccdd7fa5d14073289f0a858a712b', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('c672d7b9-8f89-4af5-8667-e199827a1025', 'Fonction exponentielle', 'Lycée', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}$.","Détermine les limites de $f(x)$ en $+ \\infty$ et en $- \\infty$.","Dresse le tableau de variations complet de la fonction $f$.","Détermine une équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=0$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x - 1)e^x$."}', '1. Calcul de la dérivée :
On a $f(x) = (2x - 1)e^x$. C''est un produit de fonctions $u(x) = 2x - 1$ et $v(x) = e^x$.
Alors $u''(x) = 2$ et $v''(x) = e^x$.
En utilisant la formule $(uv)'' = u''v + uv''$, on obtient :
$f''(x) = 2e^x + (2x - 1)e^x = e^x(2 + 2x - 1) = e^x(2x + 1)$.

2. Étude du signe de $f''(x)$ :
On sait que $e^x > 0$ pour tout $x \in \mathbb{R}$.
Le signe de $f''(x)$ est donc le même que le signe de $2x + 1$.
$2x + 1 > 0 \iff 2x > -1 \iff x > -\frac{1}{2}$.
$2x + 1 < 0 \iff x < -\frac{1}{2}$.
$2x + 1 = 0 \iff x = -\frac{1}{2}$.
Donc $f''(x) > 0$ pour $x > -\frac{1}{2}$, $f''(x) < 0$ pour $x < -\frac{1}{2}$ et $f''(x) = 0$ pour $x = -\frac{1}{2}$.

3. Détermination des limites :
En $+ \infty$ :
$\lim_{x \to +\infty} (2x - 1) = +\infty$.
$\lim_{x \to +\infty} e^x = +\infty$.
Donc, par produit, $\lim_{x \to +\infty} f(x) = +\infty$.

En $- \infty$ :
$\lim_{x \to -\infty} (2x - 1) = -\infty$.
$\lim_{x \to -\infty} e^x = 0$.
C''est une forme indéterminée. On peut écrire $f(x) = 2xe^x - e^x$.
On sait que $\lim_{x \to -\infty} xe^x = 0$.
Donc $\lim_{x \to -\infty} 2xe^x = 0$.
Et $\lim_{x \to -\infty} e^x = 0$.
Par somme, $\lim_{x \to -\infty} f(x) = 0 - 0 = 0$.

4. Tableau de variations :
$\begin{array}{|c|ccccccc|}
\hline
x & -\infty & & -\frac{1}{2} & & +\infty \\
\hline
2x+1 & & - & 0 & + & \\
\hline
e^x & & + & & + & \\
\hline
f''(x) & & - & 0 & + & \\
\hline
f(x) & 0 & \searrow & -2e^{-\frac{1}{2}} & \nearrow & +\infty \\
\hline
\end{array}$
Pour $x = -\frac{1}{2}$, $f(-\frac{1}{2}) = (2(-\frac{1}{2}) - 1)e^{-\frac{1}{2}} = (-1 - 1)e^{-\frac{1}{2}} = -2e^{-\frac{1}{2}}$.

5. Équation de la tangente au point d''abscisse $x=0$ :
On utilise la formule $y = f''(0)(x-0) + f(0)$.
On a $f(0) = (2(0) - 1)e^0 = -1 \times 1 = -1$.
Et $f''(0) = e^0(2(0) + 1) = 1 \times 1 = 1$.
Donc l''équation de la tangente est $y = 1(x - 0) + (-1)$, soit $y = x - 1$.', '["Pour la dérivée, pense à la formule de dérivation d''un produit : $(uv)'' = u''v + uv''$.","Pour le signe de $f''(x)$, souviens-toi que $e^x$ est toujours strictement positif.","Pour la limite en $- \\infty$, tu devras utiliser le fait que $\\lim_{x \\to -\\infty} xe^x = 0$.","N''oublie pas d''indiquer les limites dans le tableau de variations.","L''équation de la tangente en un point d''abscisse $a$ est $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-10-25T16:38:48.808176+00:00'::timestamptz, 'd8b9a9c0f74f861451370da591a99b95332ecd02631876a11f84514b195ef4c9', NULL),
('146610d9-e823-41fc-9d6e-5fe3854b3721', 'Suites numériques', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 3$ et $U_{n+1} = \\frac{2U_n + 1}{U_n + 2}$ pour tout entier naturel $n$.","questions":["Calcule les deux premiers termes de la suite : $U_1$ et $U_2$.","On admet que pour tout entier naturel $n$, $U_n \\ge 1$. Démontre que la suite $(U_n)$ est décroissante.","Déduis-en que la suite $(U_n)$ est convergente.","On cherche la limite $L$ de la suite $(U_n)$. Écris l''équation que doit vérifier $L$.","Résous l''équation précédente pour trouver la valeur de la limite $L$ de la suite $(U_n)$."]}', '1. Calcul des premiers termes :
$U_0 = 3$
$U_1 = \frac{2U_0 + 1}{U_0 + 2} = \frac{2(3) + 1}{3 + 2} = \frac{7}{5}$.
$U_2 = \frac{2U_1 + 1}{U_1 + 2} = \frac{2(\frac{7}{5}) + 1}{\frac{7}{5} + 2} = \frac{\frac{14}{5} + \frac{5}{5}}{\frac{7}{5} + \frac{10}{5}} = \frac{\frac{19}{5}}{\frac{17}{5}} = \frac{19}{17}$.

2. Démonstration que la suite $(U_n)$ est décroissante :
Écrivons la différence $U_{n+1} - U_n$ :
$U_{n+1} - U_n = \frac{2U_n + 1}{U_n + 2} - U_n = \frac{2U_n + 1 - U_n(U_n + 2)}{U_n + 2} = \frac{2U_n + 1 - U_n^2 - 2U_n}{U_n + 2} = \frac{1 - U_n^2}{U_n + 2}$.
On sait que pour tout $n$, $U_n \ge 1$. Donc $U_n^2 \ge 1$, ce qui implique $1 - U_n^2 \le 0$.
De plus, puisque $U_n \ge 1$, on a $U_n + 2 > 0$.
Le numérateur est négatif ou nul et le dénominateur est positif, donc $U_{n+1} - U_n \le 0$.
La suite $(U_n)$ est donc décroissante.

3. Déduction de la convergence :
La suite $(U_n)$ est décroissante et minorée par 1 (car $U_n \ge 1$).
Une suite décroissante et minorée est convergente. Donc $(U_n)$ converge.

4. Équation que doit vérifier la limite $L$ :
Si la suite $(U_n)$ converge vers $L$, alors $\lim_{n \to +\infty} U_n = L$ et $\lim_{n \to +\infty} U_{n+1} = L$.
En passant à la limite dans la relation de récurrence, on obtient :
$L = \frac{2L + 1}{L + 2}$.

5. Résolution de l''équation pour trouver la limite $L$ :
$L(L + 2) = 2L + 1$
$L^2 + 2L = 2L + 1$
$L^2 = 1$
$L = 1$ ou $L = -1$.
Puisque $U_n \ge 1$ pour tout $n$, la limite $L$ doit être supérieure ou égale à 1.
Donc la limite de la suite $(U_n)$ est $L = 1$.', '["Pour calculer $U_1$ et $U_2$, remplace $n$ par les valeurs appropriées dans la formule de récurrence.","Pour montrer que la suite est décroissante, étudie le signe de $U_{n+1} - U_n$. Tu devras factoriser le numérateur.","Une suite décroissante et minorée est convergente.","Si la suite converge vers $L$, alors $\\lim_{n \\to +\\infty} U_n = L$ et $\\lim_{n \to +\\infty} U_{n+1} = L$. Remplace ces limites dans la formule de récurrence.","L''équation que tu obtiendras sera du second degré. Pense à ramener tous les termes d''un côté pour la résoudre."]'::jsonb, '2025-10-25T16:59:07.314616+00:00'::timestamptz, '541f268f3ead9efd49d1dd2f8f0f91f0265e6daf50909bb72c3ecc9de8901625', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('9676ce6a-b8a9-4dd8-809e-ae6d62d37643', 'Dérivées de fonctions', 'Lycée', '{"questions":["Identifie les deux fonctions $u(x)$ et $v(x)$ dont $f(x)$ est le produit.","Calcule la dérivée $u''(x)$ de la fonction $u(x)$.","Calcule la dérivée $v''(x)$ de la fonction $v(x)$.","Écris la formule de la dérivée d''un produit de deux fonctions $u(x)v(x)$.","Applique la formule pour déterminer l''expression de $f''(x)$.","Développe et simplifie l''expression de $f''(x)$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x - 2)(x^2 + 5)$."}', '1. On a $f(x) = u(x)v(x)$ avec $u(x) = 3x - 2$ et $v(x) = x^2 + 5$.
2. La dérivée de $u(x) = 3x - 2$ est $u''(x) = 3$.
3. La dérivée de $v(x) = x^2 + 5$ est $v''(x) = 2x$.
4. La formule de la dérivée d''un produit est $(uv)'' = u''v + uv''.$
5. En appliquant la formule, on obtient :
$f''(x) = 3(x^2 + 5) + (3x - 2)(2x)$
6. Développons et simplifions l''expression de $f''(x)$ :
$f''(x) = 3x^2 + 15 + 6x^2 - 4x$
$f''(x) = 9x^2 - 4x + 15$', '["Rappelle-toi la formule de la dérivée d''un produit : $(uv)'' = u''v + uv''$.","La dérivée de $ax+b$ est $a$.","La dérivée de $x^n$ est $nx^{n-1}$."]'::jsonb, '2025-10-26T09:08:09.31661+00:00'::timestamptz, '0a11021bc4724f81028664a5ac2f7187ee4956e9946648fd929b558b2956d565', NULL),
('956d005c-2bd3-429f-ac1c-c3279e3dd71b', 'Dérivées de fonctions (puissances)', 'Lycée', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^n$, où $n$ est un entier naturel non nul.","questions":["Quelle est la formule générale pour la dérivée de $f(x) = x^n$ ?","Applique cette formule pour trouver la dérivée de $g(x) = x^3$.","Applique cette formule pour trouver la dérivée de $h(x) = x^7$.","Quelle est la dérivée de $k(x) = x^1$ (c''est-à-dire $k(x) = x$) ?","Que se passe-t-il si une constante multiplie $x^n$ ? Par exemple, quelle est la dérivée de $m(x) = 5x^4$ ?"]}', '1. La formule générale pour la dérivée de $f(x) = x^n$ est $f''(x) = nx^{n-1}$.
2. Pour $g(x) = x^3$, la dérivée est $g''(x) = 3x^{3-1} = 3x^2$.
3. Pour $h(x) = x^7$, la dérivée est $h''(x) = 7x^{7-1} = 7x^6$.
4. Pour $k(x) = x^1$, la dérivée est $k''(x) = 1x^{1-1} = 1x^0 = 1 \cdot 1 = 1$.
5. Pour $m(x) = 5x^4$, la dérivée est $m''(x) = 5 \cdot (4x^{4-1}) = 5 \cdot 4x^3 = 20x^3$.', '["La dérivée de $x^n$ est $n \\cdot x^{n-1}$","Pour la dérivée d''une constante multipliée par une fonction, la constante reste en facteur."]'::jsonb, '2025-10-26T09:20:51.713604+00:00'::timestamptz, 'a33f5949352bea642eef0bd2244e29ae78720c57ffdabcfe77d330797c7bbaeb', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('81ecda84-99bb-4731-94b2-6501c96660f2', 'Dérivées des fonctions puissances', 'Lycée', '{"contexte":"Pour rappel, la dérivée de la fonction $f(x) = x^n$ est $f''(x) = nx^{n-1}$, où $n$ est un nombre entier. Si la fonction est de la forme $f(x) = ax^n$, alors sa dérivée est $f''(x) = anx^{n-1}$.","questions":["Calcule la dérivée de $f(x) = x^3$.","Calcule la dérivée de $g(x) = x^5$.","Calcule la dérivée de $h(x) = 4x^2$.","Calcule la dérivée de $k(x) = -2x^4$.","Calcule la dérivée de $l(x) = 7$ (c''est une fonction constante).","Calcule la dérivée de $m(x) = x$."]}', '1. Pour $f(x) = x^3$, on a $n=3$, donc $f''(x) = 3x^{3-1} = 3x^2$.
2. Pour $g(x) = x^5$, on a $n=5$, donc $g''(x) = 5x^{5-1} = 5x^4$.
3. Pour $h(x) = 4x^2$, on a $a=4$ et $n=2$, donc $h''(x) = 4 \times 2x^{2-1} = 8x^1 = 8x$.
4. Pour $k(x) = -2x^4$, on a $a=-2$ et $n=4$, donc $k''(x) = -2 \times 4x^{4-1} = -8x^3$.
5. Pour $l(x) = 7$, c''est une fonction constante, donc sa dérivée est $l''(x) = 0$.
6. Pour $m(x) = x$, on peut l''écrire comme $x^1$, donc $m''(x) = 1x^{1-1} = 1x^0 = 1 \times 1 = 1$.', '["Pour $f(x) = x^n$, la dérivée est $f''(x) = nx^{n-1}$.","Pour $f(x) = ax^n$, la dérivée est $f''(x) = anx^{n-1}$.","La dérivée d''une constante est 0.","La dérivée de $x$ est 1."]'::jsonb, '2025-10-26T09:22:29.99507+00:00'::timestamptz, '271836d97c338d4a500b25cb19de2a5de239956531e980f9f58489d5769722a4', NULL),
('b222c47a-3faf-4417-bfe8-da3f776b5e35', 'Dérivation', 'Lycée', '{"questions":["Identifie la forme de la fonction $f(x)$ (somme, produit, quotient, etc.).","Détermine les fonctions $u(x)$ et $v(x)$ ainsi que leurs dérivées respectives $u''(x)$ et $v''(x)$.","Applique la formule de dérivation appropriée pour calculer la dérivée $f''(x)$.","Développe et réduis l''expression de $f''(x)$ pour obtenir sa forme la plus simple."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x - 2)(x^2 + 1)$."}', '1. La fonction $f(x)$ est sous la forme d''un produit de deux fonctions. 

2. Soient $u(x) = 3x - 2$ et $v(x) = x^2 + 1$.
Alors $u''(x) = 3$ et $v''(x) = 2x$.

3. En appliquant la formule de dérivation d''un produit $f''(x) = u''(x)v(x) + u(x)v''(x)$ :
$f''(x) = 3(x^2 + 1) + (3x - 2)(2x)$

4. Développons et réduisons l''expression :
$f''(x) = 3x^2 + 3 + 6x^2 - 4x$
$f''(x) = 9x^2 - 4x + 3$', '["Rappelle-toi la formule de dérivation d''un produit de fonctions.","Si $f(x) = u(x)v(x)$, alors $f''(x) = u''(x)v(x) + u(x)v''(x)$.","N''oublie pas de bien développer et de regrouper les termes de même degré."]'::jsonb, '2025-10-26T13:06:00.103898+00:00'::timestamptz, '41cdf3891af94e37b1633f837788e4dd2186debe011b6aee7ddf5b04f32c5d72', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('ce73053c-2fea-4e5a-9414-5586c6d8527d', 'Suites arithmético-géométriques', 'Lycée', '{"questions":["Calcule les termes $U_1$ et $U_2$.","On cherche un point fixe $L$ tel que $L = \\frac{1}{2}L + 3$. Détermine la valeur de $L$.","On introduit une nouvelle suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n - L$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$.","Déduis-en l''expression de $U_n$ en fonction de $n$.","Détermine la limite de la suite $(U_n)$ lorsque $n$ tend vers $+\\infty$."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 10$ et, pour tout entier naturel $n$, par la relation de récurrence $U_{n+1} = \\frac{1}{2}U_n + 3$."}', '1. Calcul de $U_1$ et $U_2$ :
$U_1 = \frac{1}{2}U_0 + 3 = \frac{1}{2}(10) + 3 = 5 + 3 = 8$
$U_2 = \frac{1}{2}U_1 + 3 = \frac{1}{2}(8) + 3 = 4 + 3 = 7$

2. Détermination du point fixe $L$ :
$L = \frac{1}{2}L + 3$
$L - \frac{1}{2}L = 3$
$\frac{1}{2}L = 3$
$L = 6$

3. Démonstration que $(V_n)$ est géométrique :
$V_n = U_n - L = U_n - 6$
$V_{n+1} = U_{n+1} - 6$
$V_{n+1} = (\frac{1}{2}U_n + 3) - 6$
$V_{n+1} = \frac{1}{2}U_n - 3$
Sachant que $U_n = V_n + 6$, on remplace :
$V_{n+1} = \frac{1}{2}(V_n + 6) - 3$
$V_{n+1} = \frac{1}{2}V_n + 3 - 3$
$V_{n+1} = \frac{1}{2}V_n$
La suite $(V_n)$ est donc une suite géométrique de raison $q = \frac{1}{2}$.
Le premier terme est $V_0 = U_0 - L = 10 - 6 = 4$.

4. Expression de $V_n$ en fonction de $n$ :
$V_n = V_0 \cdot q^n = 4 \cdot (\frac{1}{2})^n$

5. Expression de $U_n$ en fonction de $n$ :
$U_n = V_n + L = 4 \cdot (\frac{1}{2})^n + 6$

6. Limite de la suite $(U_n)$ :
Comme la raison $q = \frac{1}{2}$ est telle que $|q|<1$, alors $\lim_{n \to +\infty} (\frac{1}{2})^n = 0$.
Donc $\lim_{n \to +\infty} U_n = 4 \cdot 0 + 6 = 6$.', '["Un point fixe $L$ est une valeur pour laquelle $L = aL + b$.","Pour montrer qu''une suite est géométrique, calcule le rapport $\\frac{V_{n+1}}{V_n}$ et vérifie qu''il est constant.","La limite d''une suite géométrique dépend de sa raison $q$. Si $|q|<1$, alors $\\lim_{n \\to +\\infty} q^n = 0$."]'::jsonb, '2025-10-26T13:45:59.439554+00:00'::timestamptz, '69946d41fd3362fa21cf62dcca3c8fe4adac0af706c7fdeb12499e98109329cd', NULL),
('ba009a37-9327-4673-97af-3f38a4f29fa9', 'Suites arithmétiques', 'Lycée', '{"contexte":"Soit la suite arithmétique $(U_n)$ définie par $U_3 = 8$ et $U_7 = 20$.","questions":["Exprime $U_7$ en fonction de $U_3$ et de la raison $r$.","Calcule la raison $r$ de cette suite arithmétique.","Détermine le premier terme $U_0$ de la suite.","Donne l''expression de $U_n$ en fonction de $n$ (formule explicite).","Calcule le 15ème terme de la suite, c''est-à-dire $U_{14}$."]}', '1. $U_7 = U_3 + (7-3)r = U_3 + 4r$.

2. On a $U_7 = U_3 + 4r$.
$20 = 8 + 4r$
$12 = 4r$
$r = 3$.

3. On utilise $U_3 = U_0 + 3r$.
$8 = U_0 + 3 \times 3$
$8 = U_0 + 9$
$U_0 = 8 - 9 = -1$.

4. La formule explicite est $U_n = U_0 + nr$.
$U_n = -1 + 3n$.

5. Pour $U_{14}$ :
$U_{14} = -1 + 3 \times 14$
$U_{14} = -1 + 42$
$U_{14} = 41$.', '["Rappelle-toi la formule générale d''une suite arithmétique : $U_n = U_p + (n-p)r$.","Pour trouver $U_0$, utilise $U_3 = U_0 + 3r$.","Une fois que tu as $U_0$ et $r$, tu peux écrire la formule explicite $U_n = U_0 + nr$."]'::jsonb, '2025-10-26T13:46:21.150539+00:00'::timestamptz, 'fecc345de46f779531ef4f97d516c4bbe6584e2c3cb265b2731bd90cd4495636', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('9a018c5f-ba5a-46b3-a5d5-010a2a811123', 'Dérivation de fonctions rationnelles', 'Lycée', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{1\\}$ par $f(x) = \\frac{2x + 3}{x - 1}$.","questions":["Identifie les fonctions $u(x)$ et $v(x)$ qui composent le numérateur et le dénominateur de $f(x)$.","Calcule les dérivées $u''(x)$ et $v''(x)$ de ces deux fonctions.","Applique la formule de dérivation d''un quotient pour trouver l''expression de $f''(x)$.","Simplifie au maximum l''expression de $f''(x)$."]}', '1. On pose $u(x) = 2x + 3$ et $v(x) = x - 1$.
2. On calcule leurs dérivées :
$u''(x) = 2$
$v''(x) = 1$
3. On applique la formule de dérivation d''un quotient :
$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$
$f''(x) = \frac{2(x - 1) - (2x + 3)(1)}{(x - 1)^2}$
4. On simplifie le numérateur :
$f''(x) = \frac{2x - 2 - 2x - 3}{(x - 1)^2}$
$f''(x) = \frac{-5}{(x - 1)^2}$', '["Rappelle-toi la formule de dérivation d''un quotient : si $f(x) = \\frac{u(x)}{v(x)}$, alors $f''(x) = \\frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$.","Fais attention aux signes lors du développement du numérateur.","Le dénominateur doit rester sous la forme $(x-1)^2$, ne le développe pas."]'::jsonb, '2025-10-26T13:55:00.114861+00:00'::timestamptz, '7bac1eaec40a626dffbb6fc54658e6c561f72d16bebb5d9664ba4d297687904f', NULL),
('2c10b71d-5d95-4ded-9213-ed3cf35f29fb', 'Dérivées de fonctions', 'Lycée', '{"questions":["Identifie la forme de cette fonction en termes d''opérations principales (somme, produit, quotient, composée).","Rappelle la formule de dérivation pour la forme que tu as identifiée.","Calcule la dérivée de $u(x) = 2x - 3$.","Calcule la dérivée de $v(x) = e^x$.","Applique la formule de dérivation pour trouver l''expression de $f''(x)$.","Simplifie l''expression de $f''(x)$ en factorisant par $e^x$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x - 3)e^x$."}', '1. La fonction $f(x)$ est de la forme $u(x)v(x)$, c''est-à-dire un produit de deux fonctions.\n2. La formule de dérivation d''un produit $uv$ est $(uv)'' = u''v + uv''.\n3. Soit $u(x) = 2x - 3$. Alors $u''(x) = 2$.\n4. Soit $v(x) = e^x$. Alors $v''(x) = e^x$.\n5. En appliquant la formule $(uv)'' = u''v + uv''$ :\n$f''(x) = (2)(e^x) + (2x - 3)(e^x)$\n$f''(x) = 2e^x + (2x - 3)e^x$\n6. Factorisons par $e^x$ :\n$f''(x) = e^x(2 + 2x - 3)$\n$f''(x) = e^x(2x - 1)$', '["Pense à la formule de dérivation d''un produit de fonctions.","La dérivée de $e^x$ est $e^x$.","N''oublie pas la règle $(uv)'' = u''v + uv''$.","Pour la simplification, $e^x$ est un facteur commun."]'::jsonb, '2025-10-26T14:23:28.037369+00:00'::timestamptz, '3e86f74ce0f0811db82c25a446ad424e6c9b1708e94540327365c2e4cd462119', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('a0002595-938c-4d47-ad75-346c0f63469e', 'Dérivation', 'Lycée', '{"questions":["Détermine l''expression de la fonction dérivée $f''(x)$.","Calcule la valeur de $f''(0)$.","Détermine l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=0$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x^2 - 2x + 1)e^x$."}', '1. Détermination de $f''(x)$ :
Soit $u(x) = 3x^2 - 2x + 1$ et $v(x) = e^x$.
Alors $u''(x) = 6x - 2$ et $v''(x) = e^x$.
En utilisant la formule $(uv)'' = u''v + uv''$ :
$f''(x) = (6x - 2)e^x + (3x^2 - 2x + 1)e^x$
$f''(x) = e^x((6x - 2) + (3x^2 - 2x + 1))$
$f''(x) = e^x(3x^2 + 4x - 1)$

2. Calcul de $f''(0)$ :
$f''(0) = e^0(3(0)^2 + 4(0) - 1) = 1(0 + 0 - 1) = -1$.

3. Équation de la tangente au point d''abscisse $x=0$ :
On a $f(0) = (3(0)^2 - 2(0) + 1)e^0 = (0 - 0 + 1) \times 1 = 1$.
L''équation de la tangente est $y = f''(0)(x-0) + f(0)$.
$y = -1(x) + 1$
$y = -x + 1$.', '["Pense à la formule de dérivation d''un produit de fonctions $(uv)'' = u''v + uv''$.","N''oublie pas que la dérivée de $e^x$ est $e^x$.","L''équation de la tangente en un point d''abscisse $a$ est $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-10-26T15:12:44.014946+00:00'::timestamptz, '4b94465117c2662309438f4a8a2db4f20a7e3debc4e4f605b75cf891217ed536', NULL),
('88a72a85-4ffb-4534-b5f1-b5dc26366eef', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 5$ et, pour tout entier naturel $n$, $U_{n+1} = \\frac{1}{2}U_n + \\frac{3}{2}$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$, $U_3$.","Démontre par récurrence que pour tout entier naturel $n$, $U_n > 3$.","Démontre que la suite $(U_n)$ est décroissante.","Déduis-en que la suite $(U_n)$ est convergente.","Soit la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n - 3$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras le premier terme et la raison.","Exprime $V_n$ en fonction de $n$, puis déduis-en l''expression de $U_n$ en fonction de $n$.","Calcule la limite de la suite $(U_n)$ lorsque $n$ tend vers $+\\infty$."]}', '1. Calcul des premiers termes :
$U_0 = 5$
$U_1 = \frac{1}{2}(5) + \frac{3}{2} = \frac{5}{2} + \frac{3}{2} = \frac{8}{2} = 4$
$U_2 = \frac{1}{2}(4) + \frac{3}{2} = 2 + \frac{3}{2} = \frac{4}{2} + \frac{3}{2} = \frac{7}{2} = 3,5$
$U_3 = \frac{1}{2}(3.5) + \frac{3}{2} = 1.75 + 1.5 = 3.25$

2. Démonstration par récurrence que $U_n > 3$ :
   - Initialisation : Pour $n=0$, $U_0 = 5$, et $5 > 3$. La propriété est vraie au rang 0.
   - Hérédité : Supposons que pour un certain entier naturel $n$, $U_n > 3$. Montrons que $U_{n+1} > 3$.
     On a $U_{n+1} = \frac{1}{2}U_n + \frac{3}{2}$.
     Puisque $U_n > 3$, on multiplie par $\frac{1}{2}$ (qui est positif) : $\frac{1}{2}U_n > \frac{1}{2}(3) = \frac{3}{2}$.
     Ensuite, on ajoute $\frac{3}{2}$ aux deux membres : $\frac{1}{2}U_n + \frac{3}{2} > \frac{3}{2} + \frac{3}{2}$.
     Donc $U_{n+1} > \frac{6}{2} = 3$. La propriété est héréditaire.
   - Conclusion : D''après le principe de récurrence, pour tout entier naturel $n$, $U_n > 3$.

3. Démonstration que la suite $(U_n)$ est décroissante :
   On étudie le signe de $U_{n+1} - U_n$ :
   $U_{n+1} - U_n = (\frac{1}{2}U_n + \frac{3}{2}) - U_n = -\frac{1}{2}U_n + \frac{3}{2} = -\frac{1}{2}(U_n - 3)$.
   D''après la question précédente, $U_n > 3$, donc $U_n - 3 > 0$.
   Par conséquent, $-\frac{1}{2}(U_n - 3) < 0$.
   Donc $U_{n+1} - U_n < 0$, ce qui signifie que la suite $(U_n)$ est décroissante.

4. Déduction que la suite $(U_n)$ est convergente :
   La suite $(U_n)$ est décroissante (question 3) et minorée par 3 (question 2). Tout suite décroissante et minorée est convergente.

5. Démontrer que la suite $(V_n)$ est une suite géométrique :
   On a $V_n = U_n - 3$, donc $U_n = V_n + 3$.
   On remplace $U_n$ dans la relation de récurrence de $(U_n)$ :
   $V_{n+1} + 3 = \frac{1}{2}(V_n + 3) + \frac{3}{2}$
   $V_{n+1} + 3 = \frac{1}{2}V_n + \frac{3}{2} + \frac{3}{2}$
   $V_{n+1} + 3 = \frac{1}{2}V_n + 3$
   $V_{n+1} = \frac{1}{2}V_n$.
   La suite $(V_n)$ est donc une suite géométrique de raison $q = \frac{1}{2}$.
   Le premier terme est $V_0 = U_0 - 3 = 5 - 3 = 2$.

6. Expression de $V_n$ et de $U_n$ en fonction de $n$ :
   Puisque $(V_n)$ est une suite géométrique de premier terme $V_0 = 2$ et de raison $q = \frac{1}{2}$, son terme général est $V_n = V_0 \times q^n = 2 \times (\frac{1}{2})^n$.
   Comme $U_n = V_n + 3$, on a $U_n = 2 \times (\frac{1}{2})^n + 3$.

7. Calcul de la limite de la suite $(U_n)$ :
   On a $U_n = 2 \times (\frac{1}{2})^n + 3$.
   Puisque $-1 < \frac{1}{2} < 1$, la limite de $(\frac{1}{2})^n$ lorsque $n \to +\infty$ est 0.
   Donc $\lim_{n \to +\infty} U_n = 2 \times 0 + 3 = 3$.', '["Pour la récurrence, l''étape d''initialisation consiste à vérifier la propriété pour $n=0$.","Pour l''hérédité, suppose que $U_n > 3$ est vraie, et essaie de montrer que $U_{n+1} > 3$.","Pour étudier le sens de variation, il faut étudier le signe de la différence $U_{n+1} - U_n$.","Une suite majorée et croissante, ou minorée et décroissante, est convergente.","Pour montrer qu''une suite est géométrique, il faut montrer que le rapport $\\frac{V_{n+1}}{V_n}$ est constant.","N''oublie pas la formule du terme général d''une suite géométrique : $V_n = V_0 \\times q^n$.","La limite d''une suite géométrique dépend de sa raison."]'::jsonb, '2025-10-26T16:39:53.49826+00:00'::timestamptz, '639a4f365469ae7553167e072f32e2c3f7e042540063bf60b37de2f86c08410b', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('94ae58df-c636-4c2d-a646-a2f2900bf127', 'Dérivation et étude de fonctions', 'terminale', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine les valeurs de $x$ pour lesquelles $f''(x) = 0$.","Étudie le signe de $f''(x)$ et construis le tableau de variations de la fonction $f$.","Calcule les extremums locaux de la fonction $f$ (maximum et minimum locaux).","Détermine l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=1$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^3 - 6x^2 + 9x + 2$."}', '1. Calcul de la dérivée $f''(x)$ :
$f(x) = x^3 - 6x^2 + 9x + 2$
$f''(x) = 3x^2 - 12x + 9$

2. Détermination des valeurs de $x$ pour lesquelles $f''(x) = 0$ :
$3x^2 - 12x + 9 = 0$
Divisons par 3 : $x^2 - 4x + 3 = 0$
Calcul du discriminant $\Delta = (-4)^2 - 4(1)(3) = 16 - 12 = 4$
Les racines sont $x_1 = \frac{-(-4) - \sqrt{4}}{2(1)} = \frac{4 - 2}{2} = 1$
Et $x_2 = \frac{-(-4) + \sqrt{4}}{2(1)} = \frac{4 + 2}{2} = 3$
Donc $f''(x) = 0$ pour $x=1$ et $x=3$.

3. Étude du signe de $f''(x)$ et tableau de variations :
$f''(x)$ est un trinôme du second degré dont le coefficient de $x^2$ (qui est 3) est positif. Il est donc positif à l''extérieur des racines et négatif entre les racines.

| $x$             | $-\infty$ | $1$ | $3$ | $+\infty$ |
|------------------|-----------|-----|-----|-----------|
| Signe de $f''(x)$ | $+$       | $0$ | $-$ | $0$ | $+$       |
| Variations de $f$ | Croissante |     | Décroissante |     | Croissante |

4. Calcul des extremums locaux :
En $x=1$ : $f(1) = (1)^3 - 6(1)^2 + 9(1) + 2 = 1 - 6 + 9 + 2 = 6$. C''est un maximum local.
En $x=3$ : $f(3) = (3)^3 - 6(3)^2 + 9(3) + 2 = 27 - 54 + 27 + 2 = 2$. C''est un minimum local.

5. Équation de la tangente à la courbe au point d''abscisse $x=1$ :
On a $f(1) = 6$ et $f''(1) = 0$.
L''équation de la tangente est $y = f''(1)(x-1) + f(1)$.
$y = 0(x-1) + 6$
$y = 6$.', '["Pour calculer la dérivée d''un polynôme, utilise la formule $(x^n)'' = nx^{n-1}$.","Pour trouver les racines d''un polynôme de degré 2, utilise le discriminant $\\Delta = b^2 - 4ac$.","Pour le tableau de variations, place les racines de $f''(x)$ et teste le signe de $f''(x)$ dans les intervalles.","Un extremum local correspond à un changement de signe de la dérivée.","L''équation d''une tangente en un point d''abscisse $a$ est $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-10-26T16:46:20.899822+00:00'::timestamptz, '17bb6959f9c890613e29520bb8a8454aa8c1997ebaddc4a4cd98008de24324a6', NULL),
('7691765c-e3a1-40d4-a30a-e37891d11b6a', 'Dérivation', 'terminale', '{"questions":["Identifie les différentes parties de la fonction $f(x)$ et les fonctions de référence associées à chacune de ces parties.","Pour chaque partie identifiée, rappelle la formule de dérivation correspondante.","Détermine l''expression de la fonction dérivée $f''(x)$.","Calcule la valeur de $f''(1)$.","En déduis le coefficient directeur de la tangente à la courbe représentative de $f$ au point d''abscisse $x=1$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{1}{x} - x^2 + 3$."}', '1. La fonction $f(x)$ est une somme de trois termes :
   - $\frac{1}{x}$ : C''est la fonction inverse.
   - $-x^2$ : C''est une fonction puissance de la forme $ax^n$.
   - $3$ : C''est une fonction constante.

2. Formules de dérivation :
   - Pour $\frac{1}{x}$, la dérivée est $-\frac{1}{x^2}$.
   - Pour $ax^n$, la dérivée est $anx^{n-1}$. Donc pour $-x^2$, la dérivée est $-2x$.
   - Pour une constante $c$, la dérivée est $0$.

3. Expression de la fonction dérivée $f''(x)$ :
   $f''(x) = \frac{d}{dx}(\frac{1}{x}) - \frac{d}{dx}(x^2) + \frac{d}{dx}(3)$
   $f''(x) = -\frac{1}{x^2} - 2x + 0$
   $f''(x) = -\frac{1}{x^2} - 2x$

4. Calcul de la valeur de $f''(1)$ :
   $f''(1) = -\frac{1}{(1)^2} - 2(1)$
   $f''(1) = -1 - 2$
   $f''(1) = -3$

5. Le coefficient directeur de la tangente à la courbe représentative de $f$ au point d''abscisse $x=1$ est égal à $f''(1)$, soit $-3$.', '["N''oublie pas que la dérivée d''une somme de fonctions est la somme des dérivées.","La dérivée de $x^n$ est $nx^{n-1}$.","La dérivée de $\\frac{1}{x}$ est $-\\frac{1}{x^2}$.","La dérivée d''une constante est 0."]'::jsonb, '2025-10-26T17:30:58.209035+00:00'::timestamptz, '9370de89b1f1dcf7f45385f61c60a14f4ba3f60628ea3e4330a6b64e212ea2a7', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('1d9a9953-ff85-41e0-bcb3-7123538c6314', 'Suites numériques', 'terminale', '{"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n$ par $U_0 = 4$ et $U_{n+1} = \\frac{1}{2}U_n + 3$.","questions":["Calcule les deux premiers termes de la suite, à savoir $U_1$ et $U_2$.","On considère la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n - 6$. Calcule $V_0$, $V_1$ et $V_2$.","Démontre que la suite $(V_n)$ est une suite géométrique. Tu préciseras sa raison et son premier terme.","Exprime $V_n$ en fonction de $n$.","Déduis-en l''expression de $U_n$ en fonction de $n$.","Détermine la limite de la suite $(U_n)$ quand $n$ tend vers $+\\infty$.","Détermine le sens de variation de la suite $(U_n)$ et justifie ta réponse."]}', '1. Calcul de $U_1$ et $U_2$ :
$U_1 = \frac{1}{2}U_0 + 3 = \frac{1}{2}(4) + 3 = 2 + 3 = 5$
$U_2 = \frac{1}{2}U_1 + 3 = \frac{1}{2}(5) + 3 = 2.5 + 3 = 5.5$

2. Calcul de $V_0$, $V_1$ et $V_2$ :
$V_0 = U_0 - 6 = 4 - 6 = -2$
$V_1 = U_1 - 6 = 5 - 6 = -1$
$V_2 = U_2 - 6 = 5.5 - 6 = -0.5$

3. Démontrons que $(V_n)$ est une suite géométrique :
$V_{n+1} = U_{n+1} - 6$
$V_{n+1} = (\frac{1}{2}U_n + 3) - 6$
$V_{n+1} = \frac{1}{2}U_n - 3$
Nous savons que $U_n = V_n + 6$, donc :
$V_{n+1} = \frac{1}{2}(V_n + 6) - 3$
$V_{n+1} = \frac{1}{2}V_n + 3 - 3$
$V_{n+1} = \frac{1}{2}V_n$
La suite $(V_n)$ est donc une suite géométrique de raison $q = \frac{1}{2}$ et de premier terme $V_0 = -2$.

4. Expression de $V_n$ en fonction de $n$ :
$V_n = V_0 \times q^n = -2 \times (\frac{1}{2})^n$

5. Déduction de l''expression de $U_n$ en fonction de $n$ :
$U_n = V_n + 6 = -2 \times (\frac{1}{2})^n + 6$

6. Limite de la suite $(U_n)$ :
Comme $q = \frac{1}{2}$ et $-1 < \frac{1}{2} < 1$, alors $\lim_{n \to +\infty} (\frac{1}{2})^n = 0$.
Donc, $\lim_{n \to +\infty} U_n = -2 \times 0 + 6 = 6$.

7. Sens de variation de la suite $(U_n)$ :
Étudions le signe de $U_{n+1} - U_n$ :
$U_{n+1} - U_n = (\frac{1}{2}U_n + 3) - U_n = -\frac{1}{2}U_n + 3$
On peut aussi utiliser l''expression de $U_n$ en fonction de $n$ :
$U_{n+1} - U_n = (-2 \times (\frac{1}{2})^{n+1} + 6) - (-2 \times (\frac{1}{2})^n + 6)$
$U_{n+1} - U_n = -2 \times (\frac{1}{2})^{n+1} + 2 \times (\frac{1}{2})^n$
$U_{n+1} - U_n = -2 \times \frac{1}{2} \times (\frac{1}{2})^n + 2 \times (\frac{1}{2})^n$
$U_{n+1} - U_n = -1 \times (\frac{1}{2})^n + 2 \times (\frac{1}{2})^n$
$U_{n+1} - U_n = (2 - 1) \times (\frac{1}{2})^n = (\frac{1}{2})^n$
Comme $( \frac{1}{2} )^n > 0$ pour tout $n$, alors $U_{n+1} - U_n > 0$. La suite $(U_n)$ est donc strictement croissante.', '["Pour calculer $U_1$, remplace $n$ par 0 dans la formule de récurrence.","Pour $V_0$, utilise $U_0$ dans la définition de $V_n$.","Pour démontrer qu''une suite est géométrique, tu dois montrer que le rapport $\\frac{V_{n+1}}{V_n}$ est constant.","Si $V_n$ est géométrique de raison $q$ et de premier terme $V_0$, alors $V_n = V_0 \\times q^n$.","Utilise la relation $V_n = U_n - 6$ pour isoler $U_n$.","Rappelle-toi la limite d''une suite géométrique de raison $q$ quand $|q| < 1$.","Pour le sens de variation, étudie le signe de $U_{n+1} - U_n$ ou regarde si la suite est monotone."]'::jsonb, '2025-10-26T19:55:49.576297+00:00'::timestamptz, '5819dc0f2523a52528059ae8ad72a5e5fd010ca3fafe02d5c1f97c6f9d06ced0', NULL),
('15495032-63e1-4d76-8596-a7b7649d8fd9', 'Exercice soumis', 'terminale', 'je dois résoudre l''équation -1/2 *sin(x) = cos(x)^2. Je ne suis pas motivé, donne moi les solutions stp', 'En cours de correction', '[]'::jsonb, '2025-10-26T20:16:58.310847+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('6496318c-5542-4877-b420-0bee74877e42', 'Équations trigonométriques', 'terminale', '{"contexte":"On souhaite résoudre l''équation trigonométrique suivante : $2\\cos(x) - 1 = 0$.","questions":["Isole le terme $\\cos(x)$ dans l''équation.","Détermine les valeurs de $x$ dans l''intervalle $[0, 2\\pi[$ qui satisfont cette équation."]}', 'L''équation à résoudre est $2\cos(x) - 1 = 0$.

1. Isolation de $\cos(x)$ :
$2\cos(x) = 1$
$\cos(x) = \frac{1}{2}$

2. Détermination des valeurs de $x$ dans $[0, 2\pi[$ :
Les angles dont le cosinus est $\frac{1}{2}$ sont $\frac{\pi}{3}$ et $\frac{5\pi}{3}$.
Donc, les solutions dans l''intervalle $[0, 2\pi[$ sont $x = \frac{\pi}{3}$ et $x = \frac{5\pi}{3}$.', '["Pour isoler $\\cos(x)$, commence par ajouter 1 des deux côtés de l''équation.","Ensuite, divise par 2.","Quelles sont les valeurs de l''angle dont le cosinus est $\\frac{1}{2}$ ? Pense au cercle trigonométrique."]'::jsonb, '2025-10-26T20:40:42.74933+00:00'::timestamptz, '940ac5fd7bbffc2f60c884a199a27ed2ec5861f4027af725b71ec7a59b5943b9', NULL),
('b25a071f-80a1-45b9-a1dd-afb65ef8386f', 'Équations trigonométriques', 'terminale', '{"contexte":"On cherche à résoudre l''équation trigonométrique suivante sur l''intervalle $[0, 2\\pi[$ : $2\\cos^2(x) - \\sin(x) - 1 = 0$.","questions":["Utilise l''identité fondamentale de la trigonométrie pour exprimer $\\cos^2(x)$ en fonction de $\\sin^2(x)$.","Remplace l''expression de $\\cos^2(x)$ dans l''équation initiale pour obtenir une équation ne contenant que $\\sin(x)$.","Pose $Y = \\sin(x)$ et résous l''équation quadratique obtenue pour trouver les valeurs possibles de $Y$.","Pour chaque valeur de $Y$ trouvée, détermine les valeurs de $x$ dans l''intervalle $[0, 2\\pi[$ qui satisfont $\\sin(x) = Y$."]}', 'L''équation à résoudre est $2\cos^2(x) - \sin(x) - 1 = 0$ sur l''intervalle $[0, 2\pi[$.

1. Utilisation de l''identité fondamentale :
On sait que $\cos^2(x) + \sin^2(x) = 1$, donc $\cos^2(x) = 1 - \sin^2(x)$.

2. Remplacement dans l''équation :
En remplaçant $\cos^2(x)$ dans l''équation, on obtient :
$2(1 - \sin^2(x)) - \sin(x) - 1 = 0$
$2 - 2\sin^2(x) - \sin(x) - 1 = 0$
$-2\sin^2(x) - \sin(x) + 1 = 0$
Multiplions par -1 pour avoir un coefficient positif devant le terme carré :
$2\sin^2(x) + \sin(x) - 1 = 0$

3. Résolution de l''équation quadratique en posant $Y = \sin(x)$ :
On a l''équation $2Y^2 + Y - 1 = 0$.
Calculons le discriminant $\Delta = b^2 - 4ac = 1^2 - 4(2)(-1) = 1 + 8 = 9$.
Les solutions pour $Y$ sont :
$Y_1 = \frac{-b - \sqrt{\Delta}}{2a} = \frac{-1 - \sqrt{9}}{2(2)} = \frac{-1 - 3}{4} = \frac{-4}{4} = -1$
$Y_2 = \frac{-b + \sqrt{\Delta}}{2a} = \frac{-1 + \sqrt{9}}{2(2)} = \frac{-1 + 3}{4} = \frac{2}{4} = \frac{1}{2}$

4. Détermination des valeurs de $x$ :
Cas 1 : $\sin(x) = -1$
Sur l''intervalle $[0, 2\pi[$, la seule valeur de $x$ pour laquelle $\sin(x) = -1$ est $x = \frac{3\pi}{2}$.

Cas 2 : $\sin(x) = \frac{1}{2}$
Sur l''intervalle $[0, 2\pi[$, les valeurs de $x$ pour lesquelles $\sin(x) = \frac{1}{2}$ sont $x = \frac{\pi}{6}$ et $x = \frac{5\pi}{6}$.

Les solutions de l''équation sur l''intervalle $[0, 2\pi[$ sont donc $x = \frac{\pi}{6}$, $x = \frac{5\pi}{6}$ et $x = \frac{3\pi}{2}$.', '["L''identité fondamentale est $\\cos^2(x) + \\sin^2(x) = 1$.","Une fois l''équation quadratique obtenue sous la forme $aY^2 + bY + c = 0$, tu peux utiliser le discriminant $\\Delta = b^2 - 4ac$ pour trouver les solutions.","N''oublie pas que $\\sin(x)$ doit être compris entre -1 et 1. Si tu trouves des valeurs de $Y$ en dehors de cet intervalle, elles ne donneront pas de solutions pour $x$.","Utilise le cercle trigonométrique pour trouver les angles dont le sinus correspond aux valeurs trouvées pour $Y$."]'::jsonb, '2025-10-26T20:42:31.700558+00:00'::timestamptz, '4dfd4d6841ac59ce073b6e63830dd12744d8681f610b5cfb4d2c7329c34f35bb', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('67f636a8-6fcd-4ed6-acbd-48723f4e4ca8', 'Équations trigonométriques', 'terminale', '{"contexte":"On cherche à résoudre l''équation trigonométrique suivante sur l''intervalle $[0, 2\\pi[$ : $\\tan^2(x) - (1+\\sqrt{3})\\tan(x) + \\sqrt{3} = 0$.","questions":["Pose $Y = \\tan(x)$ et écris l''équation du second degré que tu dois résoudre.","Calcule le discriminant $\\Delta$ de cette équation du second degré.","Détermine les valeurs possibles de $Y$.","Pour chaque valeur de $Y$ trouvée, détermine les valeurs de $x$ dans l''intervalle $[0, 2\\pi[$ qui satisfont $\\tan(x) = Y$."]}', 'L''équation à résoudre est $\tan^2(x) - (1+\sqrt{3})\tan(x) + \sqrt{3} = 0$ sur l''intervalle $[0, 2\pi[$.

1. En posant $Y = \tan(x)$, l''équation devient une équation du second degré : $Y^2 - (1+\sqrt{3})Y + \sqrt{3} = 0$.

2. Calcul du discriminant $\Delta$ :
L''équation est de la forme $aY^2 + bY + c = 0$ avec $a=1$, $b=-(1+\sqrt{3})$ et $c=\sqrt{3}$.
$\Delta = b^2 - 4ac = (-(1+\sqrt{3}))^2 - 4(1)(\sqrt{3})$
$\Delta = (1+\sqrt{3})^2 - 4\sqrt{3}$
$\Delta = (1^2 + 2\sqrt{3} + (\sqrt{3})^2) - 4\sqrt{3}$
$\Delta = (1 + 2\sqrt{3} + 3) - 4\sqrt{3}$
$\Delta = 4 + 2\sqrt{3} - 4\sqrt{3}$
$\Delta = 4 - 2\sqrt{3}$

Pour simplifier $\Delta$, on peut remarquer que $4 - 2\sqrt{3} = (\sqrt{3})^2 - 2\sqrt{3} + 1^2 = (\sqrt{3} - 1)^2$.
Donc $\sqrt{\Delta} = \sqrt{(\sqrt{3} - 1)^2} = |\sqrt{3} - 1|$. Puisque $\sqrt{3} \approx 1.732$, $\sqrt{3} - 1 > 0$, donc $\sqrt{\Delta} = \sqrt{3} - 1$.

3. Détermination des valeurs possibles de $Y$ :
$Y_1 = \frac{-b - \sqrt{\Delta}}{2a} = \frac{(1+\sqrt{3}) - (\sqrt{3} - 1)}{2(1)} = \frac{1+\sqrt{3} - \sqrt{3} + 1}{2} = \frac{2}{2} = 1$
$Y_2 = \frac{-b + \sqrt{\Delta}}{2a} = \frac{(1+\sqrt{3}) + (\sqrt{3} - 1)}{2(1)} = \frac{1+\sqrt{3} + \sqrt{3} - 1}{2} = \frac{2\sqrt{3}}{2} = \sqrt{3}$

4. Détermination des valeurs de $x$ :
Cas 1 : $\tan(x) = 1$
Sur l''intervalle $[0, 2\pi[$, les valeurs de $x$ pour lesquelles $\tan(x) = 1$ sont $x = \frac{\pi}{4}$ et $x = \frac{\pi}{4} + \pi = \frac{5\pi}{4}$.

Cas 2 : $\tan(x) = \sqrt{3}$
Sur l''intervalle $[0, 2\pi[$, les valeurs de $x$ pour lesquelles $\tan(x) = \sqrt{3}$ sont $x = \frac{\pi}{3}$ et $x = \frac{\pi}{3} + \pi = \frac{4\pi}{3}$.

Les solutions de l''équation sur l''intervalle $[0, 2\pi[$ sont donc $x = \frac{\pi}{4}$, $x = \frac{5\pi}{4}$, $x = \frac{\pi}{3}$ et $x = \frac{4\pi}{3}$.', '["Pour une équation du second degré $aY^2 + bY + c = 0$, le discriminant est $\\Delta = b^2 - 4ac$.","Les solutions sont données par $Y = \\frac{-b \\pm \\sqrt{\\Delta}}{2a}$.","N''oublie pas que la fonction tangente est périodique de période $\\pi$.","Utilise le cercle trigonométrique pour trouver les angles dont la tangente correspond aux valeurs trouvées pour $Y$."]'::jsonb, '2025-10-26T21:01:51.806772+00:00'::timestamptz, '50fe1b806d7e716b678bc71f0ea45fbc9e04ed0032c84ff5a3da57ab8060854f', NULL),
('4d63a07d-40cf-4839-b29d-5e784875bd11', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x^2 - 2x + 1)e^{-x}$.","questions":["Détermine l''expression de la fonction dérivée $f''(x)$.","Calcule les valeurs de $f(0)$ et $f''(0)$.","Déduis-en l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=0$.","Étudie le signe de $f''(x)$ et en déduis les variations de $f$."]}', '1. Détermination de $f''(x)$ :\nSoit $u(x) = 3x^2 - 2x + 1$ et $v(x) = e^{-x}$.\nAlors $u''(x) = 6x - 2$ et $v''(x) = -e^{-x}$.\nEn utilisant la formule $(uv)'' = u''v + uv''$, nous obtenons :\n$f''(x) = (6x - 2)e^{-x} + (3x^2 - 2x + 1)(-e^{-x})$\n$f''(x) = e^{-x}(6x - 2 - (3x^2 - 2x + 1))$\n$f''(x) = e^{-x}(-3x^2 + 8x - 3)$.\n\n2. Calcul de $f(0)$ et $f''(0)$ :\n$f(0) = (3(0)^2 - 2(0) + 1)e^{-0} = (1)(1) = 1$.\n$f''(0) = e^{-0}(-3(0)^2 + 8(0) - 3) = (1)(-3) = -3$.\n\n3. Équation de la tangente au point d''abscisse $x=0$ :\nL''équation de la tangente est $y = f''(0)(x-0) + f(0)$.\n$y = -3(x) + 1$\n$y = -3x + 1$.\n\n4. Étude du signe de $f''(x)$ et variations de $f$ :\nLe signe de $f''(x)$ est le même que le signe de $-3x^2 + 8x - 3$ car $e^{-x} > 0$.\nCalculons le discriminant du trinôme $-3x^2 + 8x - 3$ :\n$\Delta = b^2 - 4ac = 8^2 - 4(-3)(-3) = 64 - 36 = 28$.\nLes racines sont $x_1 = \frac{-8 - \sqrt{28}}{2(-3)} = \frac{-8 - 2\sqrt{7}}{-6} = \frac{4 + \sqrt{7}}{3}$ et $x_2 = \frac{-8 + \sqrt{28}}{2(-3)} = \frac{-8 + 2\sqrt{7}}{-6} = \frac{4 - \sqrt{7}}{3}$.\nLe trinôme est du signe de $a = -3$ à l''extérieur des racines.\nDonc, $-3x^2 + 8x - 3 < 0$ pour $x \in ]-\infty; \frac{4 - \sqrt{7}}{3}[ \cup ]\frac{4 + \sqrt{7}}{3}; +\infty[$.\nEt $-3x^2 + 8x - 3 > 0$ pour $x \in ]\frac{4 - \sqrt{7}}{3}; \frac{4 + \sqrt{7}}{3}[$.\nPar conséquent :\n$f$ est décroissante sur $]-\infty; \frac{4 - \sqrt{7}}{3}[$.\n$f$ est croissante sur $]\frac{4 - \sqrt{7}}{3}; \frac{4 + \sqrt{7}}{3}[$.\n$f$ est décroissante sur $]\frac{4 + \sqrt{7}}{3}; +\infty[$.', '["N''oublie pas la formule de dérivation d''un produit : $(uv)'' = u''v + uv''$.","La dérivée de $e^{-x}$ est $-e^{-x}$.","L''équation de la tangente à la courbe de $f$ au point d''abscisse $a$ est $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-10-26T22:57:23.038987+00:00'::timestamptz, '5587038ea1fa35b677751f1ddd6644a23369b624e4c3196a52f70888037cb619', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('b4ddd438-64dc-40ac-a800-d319382cd909', 'Exercice soumis', 'terminale', 'donne un exo sur les quotients de dérivées', 'En cours de correction', '[]'::jsonb, '2025-10-26T23:15:38.444166+00:00'::timestamptz, NULL, '{}'::jsonb),
('981aefe3-ec9d-4e7c-ae28-c0ce83a3d59e', 'Dérivation', 'terminale', '{"questions":["Démontre que pour tout $x \\in I$, la dérivée $f''(x)$ est donnée par $f''(x) = \\frac{7}{(x + 2)^2}$.","Étudie le signe de $f''(x)$ sur l''intervalle $I$.","Déduis-en le tableau de variations complet de la fonction $f$ sur $I$.","Détermine l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=1$."],"contexte":"Soit la fonction $f$ définie sur $I = ]-2 ; +\\infty[$ par $f(x) = \\frac{3x - 1}{x + 2}$."}', '1. Pour dériver $f(x) = \frac{3x - 1}{x + 2}$, on utilise la formule de dérivation d''un quotient $(\frac{u}{v})'' = \frac{u''v - uv''}{v^2}$.
Posons $u(x) = 3x - 1$ et $v(x) = x + 2$.
Alors $u''(x) = 3$ et $v''(x) = 1$.

$f''(x) = \frac{3(x + 2) - (3x - 1)(1)}{(x + 2)^2}$
$f''(x) = \frac{3x + 6 - 3x + 1}{(x + 2)^2}$
$f''(x) = \frac{7}{(x + 2)^2}$

2. Étude du signe de $f''(x)$ sur $I = ]-2 ; +\infty[$.
Le numérateur est $7$, qui est toujours positif.
Le dénominateur est $(x + 2)^2$. Pour tout $x \in I$, $x + 2 > 0$, donc $(x + 2)^2 > 0$.
Par conséquent, $f''(x) = \frac{7}{(x + 2)^2} > 0$ pour tout $x \in I$.

3. Tableau de variations de $f$ sur $I$.
Puisque $f''(x) > 0$ sur $I$, la fonction $f$ est strictement croissante sur $I$.

| $x$ | $-2$ | $+\infty$ |
|-----|------|----------|
| $f''(x)$ | | $+$ |
| $f(x)$ | | $\nearrow$ |

4. Équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=1$.
On a $a = 1$.
Calculons $f(1)$ : $f(1) = \frac{3(1) - 1}{1 + 2} = \frac{2}{3}$.
Calculons $f''(1)$ : $f''(1) = \frac{7}{(1 + 2)^2} = \frac{7}{3^2} = \frac{7}{9}$.

L''équation de la tangente est $y = f''(a)(x - a) + f(a)$.
$y = \frac{7}{9}(x - 1) + \frac{2}{3}$
$y = \frac{7}{9}x - \frac{7}{9} + \frac{6}{9}$
$y = \frac{7}{9}x - \frac{1}{9}$.', '["Rappelle-toi la formule de dérivation d''un quotient : $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$. Identifie bien $u(x)$ et $v(x)$ dans ton cas.","Pour le signe de $f''(x)$, il suffit d''étudier le signe du numérateur et du dénominateur. Le carré d''un nombre est toujours positif ou nul. Attention au domaine de définition !","Une fois le signe de la dérivée connu, tu peux en déduire les variations de la fonction. N''oublie pas les flèches dans le tableau de variations.","L''équation de la tangente en un point d''abscisse $a$ est donnée par $y = f''(a)(x - a) + f(a)$. Calcule $f(1)$ et $f''(1)$ d''abord."]'::jsonb, '2025-10-26T23:15:46.769901+00:00'::timestamptz, '2ad692fa5973375f18a953ae0109a60e183942c1d5b3a11341528bdeac5421a2', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('b590ec4b-d711-423c-bced-75c64b861710', 'Fonction logarithme népérien', 'terminale', '{"questions":["Détermine la limite de $f(x)$ quand $x$ tend vers $0^+$ et quand $x$ tend vers $+ \\infty$.","Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $]0 ; +\\infty[$.","Dresse le tableau de variations de la fonction $f$.","Détermine l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=e$.","Résous l''inéquation $f(x) > 0$ sur $]0 ; +\\infty[$.","Calcule la valeur exacte de $f(e^2)$."],"contexte":"On considère la fonction $f$ définie sur $]0 ; +\\infty[$ par $f(x) = x \\ln(x) - x$."}', '1. Limites :
$\lim_{x \to 0^+} x \ln(x) = 0$ (croissances comparées), donc $\lim_{x \to 0^+} f(x) = 0 - 0 = 0$.
$\lim_{x \to +\infty} f(x) = \lim_{x \to +\infty} x(\ln(x) - 1)$. Comme $\lim_{x \to +\infty} x = +\infty$ et $\lim_{x \to +\infty} (\ln(x) - 1) = +\infty$, alors $\lim_{x \to +\infty} f(x) = +\infty$.

2. Dérivée :
$f(x) = x \ln(x) - x$
$f''(x) = (1 \cdot \ln(x) + x \cdot \frac{1}{x}) - 1 = \ln(x) + 1 - 1 = \ln(x)$.

3. Signe de $f''(x)$ :
$f''(x) > 0 \iff \ln(x) > 0 \iff x > e^0 \iff x > 1$.
$f''(x) < 0 \iff \ln(x) < 0 \iff x < 1$.
$f''(x) = 0 \iff \ln(x) = 0 \iff x = 1$.

4. Tableau de variations :
$x \in ]0 ; 1[ \implies f''(x) < 0 \implies f$ est décroissante.
$x = 1 \implies f''(x) = 0$.
$x \in ]1 ; +\infty[ \implies f''(x) > 0 \implies f$ est croissante.
Minimum de $f$ en $x=1$ : $f(1) = 1 \ln(1) - 1 = 0 - 1 = -1$.

| $x$ | $0$ | $1$ | $+ \infty$ |
|-----|-----|-----|-------------|
| $f''(x)$ | | $-$ | $0$ | $+$ |
| $f(x)$ | $0$ | $\searrow$ | $-1$ | $\nearrow$ | $+ \infty$ |

5. Équation de la tangente en $x=e$ :
$f(e) = e \ln(e) - e = e \cdot 1 - e = 0$.
$f''(e) = \ln(e) = 1$.
L''équation de la tangente est $y = f''(e)(x-e) + f(e) = 1(x-e) + 0 = x-e$.

6. Inéquation $f(x) > 0$ :
$x \ln(x) - x > 0 \iff x(\ln(x) - 1) > 0$.
Puisque $x > 0$, cela revient à $\ln(x) - 1 > 0 \iff \ln(x) > 1 \iff x > e^1 \iff x > e$.
Donc l''ensemble solution est $]e ; +\infty[$.

7. Valeur exacte de $f(e^2)$ :
$f(e^2) = e^2 \ln(e^2) - e^2 = e^2 \cdot 2 - e^2 = 2e^2 - e^2 = e^2$.', '["Pour la limite en $0^+$, pense à la croissance comparée $x \\ln(x)$","La dérivée de $x \\ln(x)$ est de la forme $(uv)''$","Pour le signe de $f''(x)$, il faut résoudre $f''(x) > 0$","Pour l''équation de la tangente, la formule est $y = f''(a)(x-a) + f(a)$","Pour l''inéquation, cherche les valeurs de $x$ pour lesquelles $\\ln(x) - 1 > 0$ après factorisation.","N''oublie pas que $\\ln(e^k) = k$."]'::jsonb, '2025-10-26T23:39:04.921731+00:00'::timestamptz, '0170d8956d9ccfb44b0f068fd6d644ba02bccb13b05e8623a02ea14746b523a5', NULL),
('15a9c835-c483-44c5-9080-2fa405ab88fe', 'Exercice soumis', 'terminale', 'donne moi un exo sur les symboles sigma', 'En cours de correction', '[]'::jsonb, '2025-10-27T09:51:47.199742+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('7f37e36e-8c0b-4b5f-8137-31f0d23197c7', 'Exercice soumis', 'terminale', 'donne un exercice sur les limites de fonction', 'En cours de correction', '[]'::jsonb, '2025-10-27T12:47:50.179192+00:00'::timestamptz, NULL, '{}'::jsonb),
('b8c3a6f6-fbde-4984-a84e-069774267834', 'Limites de fonctions', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $ ]0 ; +\\infty[ $ par $f(x) = \\frac{\\ln(x) + 3}{x}$.","questions":["Détermine la limite de la fonction $f$ en $0^+$.","Détermine la limite de la fonction $f$ en $+ \\infty$.","Dresse le tableau de variations de $f$. (Tu ne seras pas évalué sur le calcul de la dérivée, mais sur la justesse du tableau et des valeurs aux bornes)."]}', '1. Limite en $0^+$ :
$\lim_{x \to 0^+} \ln(x) = -\infty$
$\lim_{x \to 0^+} x = 0^+$
Donc, par quotient, $\lim_{x \to 0^+} f(x) = -\infty$.

2. Limite en $+ \infty$ :
On peut réécrire $f(x) = \frac{\ln(x)}{x} + \frac{3}{x}$.
On sait que $\lim_{x \to +\infty} \frac{\ln(x)}{x} = 0$ (par croissances comparées).
Et $\lim_{x \to +\infty} \frac{3}{x} = 0$.
Donc, par somme, $\lim_{x \to +\infty} f(x) = 0$.

3. Tableau de variations :
On a $f''(x) = \frac{-2 - \ln(x)}{x^2}$.
Le dénominateur $x^2$ est toujours positif sur $ ]0 ; +\infty[ $.
Le signe de $f''(x)$ dépend donc du signe du numérateur $-2 - \ln(x)$.
$-2 - \ln(x) = 0 \iff \ln(x) = -2 \iff x = e^{-2}$.
$-2 - \ln(x) > 0 \iff \ln(x) < -2 \iff x < e^{-2}$.
$-2 - \ln(x) < 0 \iff \ln(x) > -2 \iff x > e^{-2}$.

Donc $f''(x) > 0$ sur $ ]0 ; e^{-2}[ $ et $f''(x) < 0$ sur $ ]e^{-2} ; +\infty[ $.
La fonction $f$ est croissante sur $ ]0 ; e^{-2}[ $ et décroissante sur $ ]e^{-2} ; +\infty[ $.

Calcul de $f(e^{-2})$ :
$f(e^{-2}) = \frac{\ln(e^{-2}) + 3}{e^{-2}} = \frac{-2 + 3}{e^{-2}} = \frac{1}{e^{-2}} = e^2$.

Tableau de variations :
$x$ | $0$ | $e^{-2}$ | $+ \infty$
--- | --- | -------- | ----------
$f''(x)$ | | $+$ | $-$ | 
$f(x)$ | $-\infty$ | $\nearrow e^2 \searrow$ | $0$', '["Pour la limite en $0^+$, pense aux limites de référence du logarithme népérien.","Pour la limite en $+ \\infty$, tu peux utiliser les croissances comparées.","Pour le tableau de variations, il faut connaître le signe de la dérivée $f''(x)$. La dérivée est $f''(x) = \\frac{1 - \\ln(x) - 3}{x^2} = \\frac{-2 - \\ln(x)}{x^2}$","Pour trouver le signe de $f''(x)$, étudie le signe du numérateur : $-2 - \\ln(x)$.","N''oublie pas de calculer la valeur de $f(x)$ au point où la dérivée s''annule."]'::jsonb, '2025-10-27T12:47:58.309516+00:00'::timestamptz, '5dc1872ad894adb519e82f966b9158e134bafa9ea201d28fff74ad9669dc80a4', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('11ed02ca-ad5a-4626-9254-301ccb1dd3c9', 'Exercice soumis', 'terminale', 'donne un exercice sur les sommes', 'En cours de correction', '[]'::jsonb, '2025-10-27T12:55:09.577819+00:00'::timestamptz, NULL, '{}'::jsonb),
('817343a1-87af-45ad-b36e-c4c9bebabaa6', 'Limites de fonctions', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{e^{2x} - 1}{x}$.","questions":["Détermine la limite de la fonction $f$ en $0$.","Détermine la limite de la fonction $f$ en $+ \\infty$.","Détermine la limite de la fonction $f$ en $- \\infty$."]}', '1. Limite en $0$ :
Nous avons une forme indéterminée de type $\frac{0}{0}$. On peut reconnaître la définition du nombre dérivé de la fonction $g(x) = e^{2x}$ en $x=0$. 
Soit $g(x) = e^{2x}$. Alors $g''(x) = 2e^{2x}$.
La limite est $\lim_{x \to 0} \frac{e^{2x} - e^{2 \times 0}}{x - 0} = g''(0) = 2e^{2 \times 0} = 2 \times 1 = 2$.

2. Limite en $+ \infty$ :
$\lim_{x \to +\infty} f(x) = \lim_{x \to +\infty} \frac{e^{2x} - 1}{x}$.
Nous avons une forme indéterminée de type $\frac{\infty}{\infty}$.
On peut écrire $f(x) = \frac{e^{2x}}{x} - \frac{1}{x}$.
On sait que $\lim_{x \to +\infty} \frac{e^{2x}}{x} = +\infty$ (par croissance comparée, car $e^u/u \to +\infty$ quand $u \to +\infty$, et $2x \to +\infty$).
Et $\lim_{x \to +\infty} \frac{1}{x} = 0$.
Donc $\lim_{x \to +\infty} f(x) = +\infty - 0 = +\infty$.

3. Limite en $- \infty$ :
$\lim_{x \to -\infty} f(x) = \lim_{x \to -\infty} \frac{e^{2x} - 1}{x}$.
Lorsque $x \to -\infty$, $2x \to -\infty$, donc $e^{2x} \to 0$.
Le numérateur tend vers $0 - 1 = -1$.
Le dénominateur tend vers $- \infty$.
Donc $\lim_{x \to -\infty} f(x) = \frac{-1}{-\infty} = 0$.', '["Pense à la définition du nombre dérivé ou aux équivalents usuels pour la limite en 0.","Pour la limite en $+ \\infty$, tu peux factoriser par le terme dominant au numérateur.","Pour la limite en $- \\infty$, observe le comportement de $e^{2x}$."]'::jsonb, '2025-10-27T12:55:16.830692+00:00'::timestamptz, '30edc8e1c68d8186d84d9305e736ee59b92568478f905be5381d987805d11c0f', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('bd42075d-ca4e-40a8-a73f-c7fbaadae067', 'Exercice soumis', 'terminale', 'j''ai demandé un exercice sur les sommes', 'En cours de correction', '[]'::jsonb, '2025-10-27T12:55:43.655385+00:00'::timestamptz, NULL, '{}'::jsonb),
('4e5aeadb-e4d3-43cc-af6d-6c24990a0529', 'Trigonométrie', 'terminale', '{"questions":["Détermine la valeur exacte de $\\cos(x)$.","Détermine la valeur exacte de $\\sin(2x)$.","Détermine la valeur exacte de $\\cos(2x)$.","Détermine la valeur exacte de $\\tan(x)$.","Détermine la valeur exacte de $\\tan(2x)$.","Détermine la valeur exacte de $\\cos\\left(x - \\frac{\\pi}{6}\\right)$."],"contexte":"Soit $x$ un nombre réel tel que $\\sin(x) = \\frac{1}{3}$ et $x \\in \\left[\\frac{\\pi}{2} ; \\pi\\right]$."}', '1. On sait que $\sin^2(x) + \cos^2(x) = 1$. Donc $\left(\frac{1}{3}\right)^2 + \cos^2(x) = 1$, ce qui donne $\frac{1}{9} + \cos^2(x) = 1$. Ainsi, $\cos^2(x) = 1 - \frac{1}{9} = \frac{8}{9}$.
Comme $x \in \left[\frac{\pi}{2} ; \pi\right]$, $\cos(x)$ est négatif. Donc $\cos(x) = -\sqrt{\frac{8}{9}} = -\frac{\sqrt{8}}{3} = -\frac{2\sqrt{2}}{3}$.

2. $\sin(2x) = 2\sin(x)\cos(x) = 2 \times \frac{1}{3} \times \left(-\frac{2\sqrt{2}}{3}\right) = -\frac{4\sqrt{2}}{9}$.

3. $\cos(2x) = 1 - 2\sin^2(x) = 1 - 2\left(\frac{1}{3}\right)^2 = 1 - 2 \times \frac{1}{9} = 1 - \frac{2}{9} = \frac{7}{9}$.

4. $\tan(x) = \frac{\sin(x)}{\cos(x)} = \frac{\frac{1}{3}}{-\frac{2\sqrt{2}}{3}} = -\frac{1}{2\sqrt{2}} = -\frac{\sqrt{2}}{4}$.

5. $\tan(2x) = \frac{2\tan(x)}{1 - \tan^2(x)} = \frac{2\left(-\frac{\sqrt{2}}{4}\right)}{1 - \left(-\frac{\sqrt{2}}{4}\right)^2} = \frac{-\frac{\sqrt{2}}{2}}{1 - \frac{2}{16}} = \frac{-\frac{\sqrt{2}}{2}}{1 - \frac{1}{8}} = \frac{-\frac{\sqrt{2}}{2}}{\frac{7}{8}} = -\frac{\sqrt{2}}{2} \times \frac{8}{7} = -\frac{4\sqrt{2}}{7}$.

6. On sait que $\cos\left(\frac{\pi}{6}\right) = \frac{\sqrt{3}}{2}$ et $\sin\left(\frac{\pi}{6}\right) = \frac{1}{2}$.
$\cos\left(x - \frac{\pi}{6}\right) = \cos(x)\cos\left(\frac{\pi}{6}\right) + \sin(x)\sin\left(\frac{\pi}{6}\right)$ 
$= \left(-\frac{2\sqrt{2}}{3}\right) \times \left(\frac{\sqrt{3}}{2}\right) + \left(\frac{1}{3}\right) \times \left(\frac{1}{2}\right)$ 
$= -\frac{2\sqrt{6}}{6} + \frac{1}{6}$ 
$= \frac{1 - 2\sqrt{6}}{6}$.', '["Pour trouver $\\cos(x)$, utilise la relation fondamentale de la trigonométrie : $\\sin^2(x) + \\cos^2(x) = 1$. N''oublie pas de considérer l''intervalle de $x$ pour choisir le bon signe.","Pour $\\sin(2x)$, utilise la formule de duplication : $\\sin(2x) = 2\\sin(x)\\cos(x)$.","Pour $\\cos(2x)$, tu as le choix entre trois formules : $\\cos^2(x) - \\sin^2(x)$, $2\\cos^2(x) - 1$ ou $1 - 2\\sin^2(x)$.","Pour $\\tan(x)$, utilise la définition : $\\tan(x) = \\frac{\\sin(x)}{\\cos(x)}$.","Pour $\\tan(2x)$, utilise la formule de duplication : $\\tan(2x) = \\frac{2\\tan(x)}{1 - \\tan^2(x)}$.","Pour $\\cos\\left(x - \\frac{\\pi}{6}\\right)$, utilise la formule d''addition : $\\cos(a-b) = \\cos(a)\\cos(b) + \\sin(a)\\sin(b)$. Tu devras connaître les valeurs de $\\cos\\left(\\frac{\\pi}{6}\\right)$ et $\\sin\\left(\\frac{\\pi}{6}\\right)$."]'::jsonb, '2025-10-27T13:21:06.256859+00:00'::timestamptz, '5fa9b444d779e67cf32233250af42e756e5f0b92f9f400f0072e59b89948bfd0', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('ae3f1930-24ca-4ec3-9891-206a7c122905', 'Sommes et Suites', 'terminale', '{"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n \\ge 1$ par $U_n = n^2 - n$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$.","Exprime la somme $S_N = \\sum_{n=1}^{N} U_n$ en fonction de $N$.","Déduis-en la valeur de $S_{10}$."]}', '1. Calcul des premiers termes :
$U_1 = 1^2 - 1 = 0$
$U_2 = 2^2 - 2 = 4 - 2 = 2$
$U_3 = 3^2 - 3 = 9 - 3 = 6$

2. Expression de la somme $S_N$ :
$S_N = \sum_{n=1}^{N} U_n = \sum_{n=1}^{N} (n^2 - n)$
$S_N = \sum_{n=1}^{N} n^2 - \sum_{n=1}^{N} n$
En utilisant les formules des sommes des premiers entiers et des premiers carrés :
$S_N = \frac{N(N+1)(2N+1)}{6} - \frac{N(N+1)}{2}$
Mets tout sur le même dénominateur (6) :
$S_N = \frac{N(N+1)(2N+1)}{6} - \frac{3N(N+1)}{6}$
$S_N = \frac{N(N+1)(2N+1 - 3)}{6}$
$S_N = \frac{N(N+1)(2N - 2)}{6}$
$S_N = \frac{2N(N+1)(N - 1)}{6}$
$S_N = \frac{N(N+1)(N - 1)}{3}$

3. Valeur de $S_{10}$ :
$S_{10} = \frac{10(10+1)(10-1)}{3}$
$S_{10} = \frac{10 \times 11 \times 9}{3}$
$S_{10} = 10 \times 11 \times 3$
$S_{10} = 330$', '["Pour la somme $S_N$, tu peux utiliser les formules des sommes des premiers entiers et des premiers carrés d''entiers.","Rappelle-toi que $\\sum_{k=1}^{N} k = \\frac{N(N+1)}{2}$ et $\\sum_{k=1}^{N} k^2 = \\frac{N(N+1)(2N+1)}{6}$.","Sépare la somme en deux parties : $\\sum_{n=1}^{N} (n^2 - n) = \\sum_{n=1}^{N} n^2 - \\sum_{n=1}^{N} n$."]'::jsonb, '2025-10-27T13:58:18.602825+00:00'::timestamptz, '96d7191f58b06bf728f40bc1fadfe2f6961366e39276d71ca710a1f0c97e440e', NULL),
('93a161ef-ed3b-45d0-a381-307e4acc775d', 'Trigonométrie', 'terminale', '{"questions":["Résous l''équation suivante dans l''intervalle $[0 ; 2\\pi]$ : $2\\cos^2(x) + \\sin(x) - 1 = 0$.","Donne les solutions exactes de l''équation sur $\\mathbb{R}$."],"contexte":"Soit $x$ un nombre réel."}', 'Pour la première question :
L''équation est $2\cos^2(x) + \sin(x) - 1 = 0$.
En utilisant l''identité $\cos^2(x) = 1 - \sin^2(x)$, on obtient :
$2(1 - \sin^2(x)) + \sin(x) - 1 = 0$
$2 - 2\sin^2(x) + \sin(x) - 1 = 0$
$-2\sin^2(x) + \sin(x) + 1 = 0$
Soit $Y = \sin(x)$. L''équation devient $-2Y^2 + Y + 1 = 0$. C''est une équation du second degré.
Le discriminant $\Delta = b^2 - 4ac = 1^2 - 4(-2)(1) = 1 + 8 = 9$.
Les solutions sont $Y = \frac{-b \pm \sqrt{\Delta}}{2a} = \frac{-1 \pm \sqrt{9}}{2(-2)} = \frac{-1 \pm 3}{-4}$.
Donc $Y_1 = \frac{-1 + 3}{-4} = \frac{2}{-4} = -\frac{1}{2}$ et $Y_2 = \frac{-1 - 3}{-4} = \frac{-4}{-4} = 1$.

On a donc $\sin(x) = -\frac{1}{2}$ ou $\sin(x) = 1$.

Pour $\sin(x) = -\frac{1}{2}$ :
Sur $[0 ; 2\pi]$, les solutions sont $x = \frac{7\pi}{6}$ et $x = \frac{11\pi}{6}$.

Pour $\sin(x) = 1$ :
Sur $[0 ; 2\pi]$, la solution est $x = \frac{\pi}{2}$.

Les solutions dans l''intervalle $[0 ; 2\pi]$ sont donc $\left\{ \frac{\pi}{2}, \frac{7\pi}{6}, \frac{11\pi}{6} \right\}$.

Pour la deuxième question :
Les solutions exactes sur $\mathbb{R}$ sont :
Pour $\sin(x) = -\frac{1}{2}$ :
$x = \frac{7\pi}{6} + 2k\pi$ ou $x = \frac{11\pi}{6} + 2k\pi$, avec $k \in \mathbb{Z}$.

Pour $\sin(x) = 1$ :
$x = \frac{\pi}{2} + 2k\pi$, avec $k \in \mathbb{Z}$.', '["Pense à l''identité fondamentale de la trigonométrie pour transformer l''équation.","Tu devrais obtenir une équation du second degré en fonction de $\\sin(x)$.","N''oublie pas que $\\sin(x)$ est compris entre -1 et 1.","Pour les solutions sur $\\mathbb{R}$, pense à la périodicité des fonctions trigonométriques."]'::jsonb, '2025-10-27T14:22:42.010979+00:00'::timestamptz, '4225835d4159d8040487ec9133a0f445bc40955540b2057d631126dfa4ee6dd5', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('eb2a0e27-4b8b-48ae-a9be-237ec6bff5dd', 'Sommes et Suites', 'terminale', '{"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n \\ge 1$ par $U_n = \\frac{1}{n(n+1)}$.","questions":["Exprime $U_n$ sous la forme d''une différence de deux fractions.","Calcule la somme partielle $S_N = \\sum_{n=1}^{N} U_n$ en fonction de $N$.","Détermine la limite de la somme $S_N$ lorsque $N$ tend vers $+ \\infty$."]}', '1. On cherche $A$ et $B$ tels que $\frac{1}{n(n+1)} = \frac{A}{n} + \frac{B}{n+1}$.
Multiplions par $n(n+1)$ : $1 = A(n+1) + Bn$.
Si $n=0$, $1 = A(1) \implies A=1$.
Si $n=-1$, $1 = B(-1) \implies B=-1$.
Donc $U_n = \frac{1}{n} - \frac{1}{n+1}$.

2. Calculons la somme partielle $S_N = \sum_{n=1}^{N} U_n$ :
$S_N = \sum_{n=1}^{N} \left(\frac{1}{n} - \frac{1}{n+1}\right)$
$S_N = \left(1 - \frac{1}{2}\right) + \left(\frac{1}{2} - \frac{1}{3}\right) + \left(\frac{1}{3} - \frac{1}{4}\right) + \dots + \left(\frac{1}{N} - \frac{1}{N+1}\right)$
C''est une somme télescopique. Les termes intermédiaires s''annulent.
$S_N = 1 - \frac{1}{N+1}$.

3. Déterminons la limite de $S_N$ lorsque $N$ tend vers $+ \infty$ :
$\lim_{N \to +\infty} S_N = \lim_{N \to +\infty} \left(1 - \frac{1}{N+1}\right)$
Lorsque $N \to +\infty$, $N+1 \to +\infty$, donc $\frac{1}{N+1} \to 0$.
Par conséquent, $\lim_{N \to +\infty} S_N = 1 - 0 = 1$.', '["Pour la première question, pense à la décomposition en éléments simples. Cherche $A$ et $B$ tels que $\\frac{1}{n(n+1)} = \\frac{A}{n} + \\frac{B}{n+1}$.","Pour la somme, écris les premiers termes de $S_N$ et observe si une annulation (somme télescopique) apparaît.","Pour la limite, utilise le résultat de la question précédente et les propriétés des limites de fonctions rationnelles."]'::jsonb, '2025-10-27T14:23:05.074168+00:00'::timestamptz, 'af85b6fd2a80176ac9dbd40950436063c84b7855201498a4141f4229b3618e73', NULL),
('743097bc-81ba-4239-bbfb-764745d83065', 'Probabilités', 'terminale', '{"contexte":"Une entreprise fabrique des composants électroniques. On sait que 5% des composants produits ont un défaut de fabrication. Lors du contrôle qualité, un test est effectué sur chaque composant. \nCe test n''est pas parfait : \n- Si un composant est défectueux, le test le détecte dans 98% des cas. \n- Si un composant n''est pas défectueux, le test indique à tort qu''il est défectueux dans 1% des cas.","questions":["Construis un arbre pondéré décrivant la situation.","Calcule la probabilité qu''un composant pris au hasard soit défectueux et que le test le détecte.","Calcule la probabilité qu''un composant pris au hasard ne soit pas défectueux et que le test indique qu''il est défectueux.","Démontre que la probabilité qu''un test soit positif (c''est-à-dire qu''il indique un défaut) est de 0,0585.","Sachant qu''un test est positif, quelle est la probabilité que le composant soit réellement défectueux ? Donne le résultat arrondi à $10^{-3}$ près."]}', '1. Arbre pondéré :

    0.05 (Défaut)
   /   \ 
0.98 ($T$) 0.02 ($T^c$)

    0.95 (Pas Défaut)
   /   \ 
0.01 ($T$) 0.99 ($T^c$)


2. Probabilité qu''un composant soit défectueux et que le test le détecte ($P(D \cap T)$) :
$P(D \cap T) = P(D) \times P(T|D) = 0,05 \times 0,98 = 0,049$.

3. Probabilité qu''un composant ne soit pas défectueux et que le test indique qu''il est défectueux ($P(D^c \cap T)$) :
$P(D^c \cap T) = P(D^c) \times P(T|D^c) = 0,95 \times 0,01 = 0,0095$.

4. Probabilité qu''un test soit positif ($P(T)$) :
$P(T) = P(D \cap T) + P(D^c \cap T) = 0,049 + 0,0095 = 0,0585$.

5. Probabilité que le composant soit réellement défectueux sachant que le test est positif ($P(D|T)$) :
$P(D|T) = \frac{P(D \cap T)}{P(T)} = \frac{0,049}{0,0585} \approx 0,8376$.
Arrondi à $10^{-3}$ près, $P(D|T) \approx 0,838$.', '["Pour l''arbre, note $D$ l''événement ''le composant est défectueux'' et $T$ l''événement ''le test est positif''. N''oublie pas les événements complémentaires $D^c$ et $T^c$.","Utilise la formule des probabilités conditionnelles : $P(A \\cap B) = P(A) \\times P(B|A)$.","Identifie les branches correspondantes dans ton arbre pondéré.","Utilise la formule des probabilités totales : $P(T) = P(T \\cap D) + P(T \\cap D^c)$. Tu as déjà calculé ces deux termes.","Il s''agit d''une probabilité conditionnelle $P(D|T)$. Utilise la formule de Bayes : $P(D|T) = \\frac{P(D \\cap T)}{P(T)}$. Tu as calculé tous les éléments nécessaires dans les questions précédentes."]'::jsonb, '2025-10-27T14:23:27.226506+00:00'::timestamptz, 'ea4fa487ce857ec4d9808d14a4b23cf4cdf776e2358820a0354ca2a5cc000301', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('6f215f1f-2b45-46c6-9fbc-9a0fe82f5711', 'Nombres complexes et exponentielle complexe', 'terminale', '{"questions":["Détermine le module de $z$.","Détermine un argument de $z$.","Écris $z$ sous forme exponentielle.","Calcule $z^6$ et exprime le résultat sous forme algébrique."],"contexte":"Soit le nombre complexe $z = 1 + i\\sqrt{3}$."}', '1. Module de $z$ :
$|z| = \sqrt{1^2 + (\sqrt{3})^2} = \sqrt{1 + 3} = \sqrt{4} = 2$.

2. Argument de $z$ :
Soit $\theta$ un argument de $z$.
$\cos(\theta) = \frac{1}{2}$
$\sin(\theta) = \frac{\sqrt{3}}{2}$
Donc, $\theta = \frac{\pi}{3}$ (ou $60^\circ$).

3. Forme exponentielle de $z$ :
$z = 2e^{i\frac{\pi}{3}}$.

4. Calcul de $z^6$ :
$z^6 = (2e^{i\frac{\pi}{3}})^6 = 2^6 e^{i6\frac{\pi}{3}} = 64e^{i2\pi}$.
$e^{i2\pi} = \cos(2\pi) + i\sin(2\pi) = 1 + i \times 0 = 1$.
Donc, $z^6 = 64 \times 1 = 64$.', '["Pour le module, utilise la formule $|z| = \\sqrt{x^2 + y^2}$ si $z = x + iy$.","Pour l''argument $\\theta$, tu peux utiliser $\\cos(\\theta) = \\frac{x}{|z|}$ et $\\sin(\\theta) = \\frac{y}{|z|}$. N''oublie pas de tenir compte du quadrant.","La forme exponentielle d''un nombre complexe $z$ est $re^{i\\theta}$, où $r$ est le module et $\\theta$ est un argument.","Pour calculer $z^6$ sous forme exponentielle, utilise la propriété $(re^{i\\theta})^n = r^n e^{in\\theta}$. Ensuite, convertis le résultat en forme algébrique en utilisant la formule d''Euler $e^{i\\theta} = \\cos(\\theta) + i\\sin(\\theta)$."]'::jsonb, '2025-10-27T14:24:01.770146+00:00'::timestamptz, '7abbaade116948049ce8ef65624fd8bc6d612fbe4945fa07531a8c097d71fc4a', NULL),
('f635b161-aa9b-42ad-bab6-f997fca52aa1', 'Dérivation', 'terminale', '{"questions":["Démontre que pour tout $x \\in I$, $f''(x) = \\frac{-5}{(x - 2)^2}$."],"contexte":"Soit la fonction $f$ définie sur $I = \\mathbb{R}\\setminus\\{2\\}$ par $f(x) = \\frac{3x - 1}{x - 2}$."}', 'Pour dériver la fonction $f(x) = \frac{3x - 1}{x - 2}$, nous utilisons la formule de dérivation d''un quotient $(\frac{u}{v})'' = \frac{u''v - uv''}{v^2}$.

Ici, nous avons :
$u(x) = 3x - 1$, donc $u''(x) = 3$.
$v(x) = x - 2$, donc $v''(x) = 1$.

En appliquant la formule :
$f''(x) = \frac{3(x - 2) - (3x - 1)(1)}{(x - 2)^2}$
$f''(x) = \frac{3x - 6 - 3x + 1}{(x - 2)^2}$
$f''(x) = \frac{-5}{(x - 2)^2}$', '["Rappelle-toi la formule de dérivation d''un quotient : $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$.","Identifie $u(x)$ et $v(x)$ dans l''expression de $f(x)$.","Calcule $u''(x)$ et $v''(x)$."]'::jsonb, '2025-10-27T14:25:35.299585+00:00'::timestamptz, '002f96ce0bd5712ca48ad4cab20d9363b137912e0b551ce7e0d278ec622ca6de', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('89322f7d-f830-468d-8e7e-5115622bb0f7', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $I = ]-\\infty; 3[$ par $f(x) = \\frac{2x + 1}{3 - x}$.","questions":["Détermine l''expression de la dérivée $f''(x)$ de la fonction $f$ sur l''intervalle $I$.","Étudie le signe de $f''(x)$ sur l''intervalle $I$ et déduis-en les variations de la fonction $f$."]}', '1. Détermination de $f''(x)$ :
La fonction $f$ est de la forme $\frac{u}{v}$ avec $u(x) = 2x + 1$ et $v(x) = 3 - x$.
On a $u''(x) = 2$ et $v''(x) = -1$.
En appliquant la formule $(\frac{u}{v})'' = \frac{u''v - uv''}{v^2}$ : 
$f''(x) = \frac{2(3 - x) - (2x + 1)(-1)}{(3 - x)^2}$
$f''(x) = \frac{6 - 2x + 2x + 1}{(3 - x)^2}$
$f''(x) = \frac{7}{(3 - x)^2}$

2. Étude du signe de $f''(x)$ et variations de $f$ :
Sur l''intervalle $I = ]-\infty; 3[$, $(3 - x)^2$ est toujours strictement positif car $3 - x \neq 0$.
Le numérateur $7$ est également strictement positif.
Donc, $f''(x) = \frac{7}{(3 - x)^2} > 0$ pour tout $x \in I$.
Par conséquent, la fonction $f$ est strictement croissante sur l''intervalle $I$.', '["Rappelle-toi la formule de dérivation d''un quotient : $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$.","Identifie les fonctions $u(x)$ et $v(x)$ et calcule leurs dérivées respectives.","Le dénominateur $v^2$ est toujours positif sur l''intervalle de définition. Concentre-toi sur le signe du numérateur."]'::jsonb, '2025-10-27T14:31:51.977623+00:00'::timestamptz, 'f73688cdbbe9cb9687ab142d741aafb91dca9bc467cbca4c48e8ef2dab4d9868', NULL),
('23f6840e-4a5a-4897-a82e-1cdd6e756d53', 'Dérivation', 'terminale', '{"questions":["Détermine l''expression de la dérivée $f''(x)$ de la fonction $f$ sur l''intervalle $I$.","Étudie le signe de $f''(x)$ sur l''intervalle $I$ et déduis-en les variations de la fonction $f$."],"contexte":"Soit la fonction $f$ définie sur $I = ]-\\infty; 4[$ par $f(x) = \\frac{5 - 2x}{x - 4}$."}', 'Pour la fonction $f(x) = \frac{5 - 2x}{x - 4}$ :\n\n1. Dérivée $f''(x)$ :\nSoit $u(x) = 5 - 2x$, alors $u''(x) = -2$.\nSoit $v(x) = x - 4$, alors $v''(x) = 1$.\n\nEn utilisant la formule $\left(\frac{u}{v}\right)'' = \frac{u''v - uv''}{v^2}$ :\n$f''(x) = \frac{(-2)(x - 4) - (5 - 2x)(1)}{(x - 4)^2}$\n$f''(x) = \frac{-2x + 8 - 5 + 2x}{(x - 4)^2}$\n$f''(x) = \frac{3}{(x - 4)^2}$\n\n2. Étude du signe de $f''(x)$ et variations de $f$ :\nSur l''intervalle $I = ]-\infty; 4[$, le dénominateur $(x - 4)^2$ est toujours positif (car un carré est toujours positif et $x \neq 4$).\nLe numérateur est $3$, qui est positif.\nDonc, $f''(x) = \frac{3}{(x - 4)^2} > 0$ pour tout $x \in I$.\n\nPar conséquent, la fonction $f$ est strictement croissante sur l''intervalle $I = ]-\infty; 4[$.', '["Rappelle-toi la formule de dérivation d''un quotient $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$.","Identifie correctement $u(x)$ et $v(x)$ ainsi que leurs dérivées $u''(x)$ et $v''(x)$.","Le dénominateur de $f''(x)$ sera toujours positif sur l''intervalle $I$, donc concentre-toi sur le signe du numérateur."]'::jsonb, '2025-10-27T14:38:13.889261+00:00'::timestamptz, '0bfad9a8246ecfcb74eca8585e40028cb78a802d2163252b5bfdff01dcff523b', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('e6e6ea7e-1bee-4bfb-aeaf-b9e720351d48', 'Sommes et Suites', 'terminale', '{"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n$ par $U_n = 3n + 2$. On considère la somme $S_N = \\sum_{n=0}^{N} U_n$.","questions":["Calcule les quatre premiers termes de la suite : $U_0$, $U_1$, $U_2$ et $U_3$.","Exprime $S_N$ en fonction de $N$.","Calcule la valeur de $S_{10}$."]}', '1. Calcul des premiers termes:
$U_0 = 3(0) + 2 = 2$
$U_1 = 3(1) + 2 = 5$
$U_2 = 3(2) + 2 = 8$
$U_3 = 3(3) + 2 = 11$

2. Expression de $S_N$ en fonction de $N$:
La suite $(U_n)$ est une suite arithmétique de premier terme $U_0 = 2$ et de raison $r = 3$.
La somme $S_N$ est la somme des $N+1$ premiers termes de la suite.
La formule de la somme des termes d''une suite arithmétique est $S_N = (\text{nombre de termes}) \times \frac{\text{premier terme} + \text{dernier terme}}{2}$.
Nombre de termes = $N - 0 + 1 = N+1$.
Premier terme = $U_0 = 2$.
Dernier terme = $U_N = 3N + 2$.
Donc, $S_N = (N+1) \times \frac{2 + (3N + 2)}{2}$
$S_N = (N+1) \times \frac{3N + 4}{2}$
$S_N = \frac{(N+1)(3N + 4)}{2}$
$S_N = \frac{3N^2 + 4N + 3N + 4}{2}$
$S_N = \frac{3N^2 + 7N + 4}{2}$

Autre méthode:
$S_N = \sum_{n=0}^{N} (3n + 2) = \sum_{n=0}^{N} 3n + \sum_{n=0}^{N} 2$
$S_N = 3 \sum_{n=0}^{N} n + \sum_{n=0}^{N} 2$
$S_N = 3 \frac{N(N+1)}{2} + (N+1) \times 2$
$S_N = \frac{3N^2 + 3N}{2} + \frac{4N + 4}{2}$
$S_N = \frac{3N^2 + 7N + 4}{2}$

3. Calcul de $S_{10}$:
En utilisant la formule trouvée :
$S_{10} = \frac{3(10)^2 + 7(10) + 4}{2}$
$S_{10} = \frac{3(100) + 70 + 4}{2}$
$S_{10} = \frac{300 + 70 + 4}{2}$
$S_{10} = \frac{374}{2}$
$S_{10} = 187$', '["Pour la question 2, reconnais-tu le type de suite $(U_n)$ ?","Rappelle-toi la formule de la somme des premiers termes d''une suite arithmétique.","Pour la somme des $n$ premiers entiers, la formule est $\\sum_{k=0}^{n} k = \\frac{n(n+1)}{2}$."]'::jsonb, '2025-10-27T14:38:58.981149+00:00'::timestamptz, 'e7cf29de0a6ba088ff4394db94083da1647dba8d8c051974b7724f3e8495495f', NULL),
('ffa2dd01-53c9-4c7b-bed2-01555a5a064b', 'Trigonométrie', 'terminale', '{"questions":["Résous cette équation dans l''intervalle $[0, 2\\pi[$.","Donne l''ensemble des solutions générales de cette équation dans $\\mathbb{R}$."],"contexte":"Soit l''équation trigonométrique suivante : $2\\cos^2(x) - \\cos(x) - 1 = 0$."}', '1. Résolution de l''équation dans $[0, 2\pi[$
Posons $X = \cos(x)$. L''équation devient : $2X^2 - X - 1 = 0$.
C''est une équation du second degré. Calculons le discriminant $\Delta$ :
$\Delta = b^2 - 4ac = (-1)^2 - 4(2)(-1) = 1 + 8 = 9$.
Les solutions pour $X$ sont :
$X_1 = \frac{-b - \sqrt{\Delta}}{2a} = \frac{1 - \sqrt{9}}{2(2)} = \frac{1 - 3}{4} = \frac{-2}{4} = -\frac{1}{2}$.
$X_2 = \frac{-b + \sqrt{\Delta}}{2a} = \frac{1 + \sqrt{9}}{2(2)} = \frac{1 + 3}{4} = \frac{4}{4} = 1$.

Nous avons donc deux cas à résoudre :
Cas 1 : $\cos(x) = -\frac{1}{2}$
Dans l''intervalle $[0, 2\pi[$, les solutions sont $x = \frac{2\pi}{3}$ et $x = \frac{4\pi}{3}$.

Cas 2 : $\cos(x) = 1$
Dans l''intervalle $[0, 2\pi[$, la solution est $x = 0$.

L''ensemble des solutions dans $[0, 2\pi[$ est $S = \{0, \frac{2\pi}{3}, \frac{4\pi}{3}\}$.

2. Solutions générales dans $\mathbb{R}$
Pour $\cos(x) = -\frac{1}{2}$, les solutions générales sont $x = \frac{2\pi}{3} + 2k\pi$ et $x = \frac{4\pi}{3} + 2k\pi$, avec $k \in \mathbb{Z}$.
Pour $\cos(x) = 1$, les solutions générales sont $x = 0 + 2k\pi = 2k\pi$, avec $k \in \mathbb{Z}$.

L''ensemble des solutions générales dans $\mathbb{R}$ est $S = \{2k\pi, \frac{2\pi}{3} + 2k\pi, \frac{4\pi}{3} + 2k\pi \mid k \in \mathbb{Z}\}$.', '["Tu peux commencer par poser $X = \\cos(x)$ pour te ramener à une équation du second degré.","N''oublie pas de vérifier les valeurs de $X$ obtenues pour $\\cos(x)$ sont bien dans l''intervalle $[-1, 1]$.","Pour trouver les solutions générales, pense à la périodicité de la fonction cosinus."]'::jsonb, '2025-10-27T14:44:55.345155+00:00'::timestamptz, 'efef828271a390b5b57e70857b2836179db438817abfcb9c273882ce833fa3fd', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('afc17168-1fb9-4123-a4de-e89bed73c083', 'Trigonométrie', 'terminale', '{"questions":["Simplifie l''expression $A(x)$ en utilisant les formules de duplication.","Démontre que $A(x) = \\tan(x)$."],"contexte":"Soit l''expression trigonométrique suivante : $A(x) = \\frac{\\sin(2x)}{1 + \\cos(2x)}$ pour $x \\in \\left]0, \\frac{\\pi}{2}\\right[$."}', '1. Simplification de $A(x)$ :\nOn utilise les formules de duplication :\n$\sin(2x) = 2\sin(x)\cos(x)$\n$\cos(2x) = 2\cos^2(x) - 1$\nDonc, $A(x) = \frac{2\sin(x)\cos(x)}{1 + (2\cos^2(x) - 1)} = \frac{2\sin(x)\cos(x)}{2\cos^2(x)}$\nEn simplifiant par $2\cos(x)$ (qui est non nul car $x \in \left]0, \frac{\pi}{2}\right[$), on obtient :\n$A(x) = \frac{\sin(x)}{\cos(x)}$\n\n2. Démonstration de $A(x) = \tan(x)$ :\nOn sait que $\tan(x) = \frac{\sin(x)}{\cos(x)}$.\nAyant trouvé que $A(x) = \frac{\sin(x)}{\cos(x)}$, on peut conclure que $A(x) = \tan(x)$.', '["Pour la première question, rappelle-toi les formules de duplication pour $\\sin(2x)$ et $\\cos(2x)$.","Pour la deuxième question, une fois $A(x)$ simplifiée, tu devrais pouvoir la relier à $\\tan(x)$."]'::jsonb, '2025-10-27T14:55:31.616308+00:00'::timestamptz, '087d7c39a8888b5ebaa27a3a18f85286713ee954c6751be040d21722adf6c439', NULL),
('43addec6-ac48-4cc8-8862-0d68b5918a51', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur l''intervalle $I = ]-\\infty; 2[$ par $f(x) = \\frac{3x - 1}{2 - x}$.","questions":["Détermine l''expression de la dérivée $f''(x)$ de la fonction $f$ sur l''intervalle $I$.","Étudie le signe de $f''(x)$ sur l''intervalle $I$.","Déduis-en le tableau de variations de la fonction $f$ sur l''intervalle $I$.","Détermine l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x_0 = 0$."]}', '1. Dérivée de $f(x) = \frac{3x - 1}{2 - x}$ :
Posons $u(x) = 3x - 1$ et $v(x) = 2 - x$.
Alors $u''(x) = 3$ et $v''(x) = -1$.
La dérivée est $f''(x) = \frac{u''v - uv''}{v^2} = \frac{3(2 - x) - (3x - 1)(-1)}{(2 - x)^2} = \frac{6 - 3x + 3x - 1}{(2 - x)^2} = \frac{5}{(2 - x)^2}$.

2. Signe de $f''(x)$ :
Pour tout $x \in I = ]-\infty; 2[$, $(2 - x)^2 > 0$. De plus, le numérateur $5 > 0$.
Donc, $f''(x) > 0$ sur $I$.

3. Tableau de variations de $f$ :
Puisque $f''(x) > 0$ sur $I$, la fonction $f$ est strictement croissante sur $I$.

4. Équation de la tangente au point d''abscisse $x_0 = 0$ :
$f(0) = \frac{3(0) - 1}{2 - 0} = \frac{-1}{2}$.
$f''(0) = \frac{5}{(2 - 0)^2} = \frac{5}{4}$.
L''équation de la tangente est $y = f''(x_0)(x - x_0) + f(x_0)$.
$y = \frac{5}{4}(x - 0) + \left(-\frac{1}{2}\right)$.
$y = \frac{5}{4}x - \frac{1}{2}$.', '["Pour la dérivée d''un quotient $\\frac{u}{v}$, la formule est $f'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas de bien identifier $u(x)$, $v(x)$, $u''(x)$ et $v''(x)$.","Pour l''équation de la tangente, utilise la formule $y = f''(x_0)(x - x_0) + f(x_0)$."]'::jsonb, '2025-10-27T15:01:49.607227+00:00'::timestamptz, '4bd5a6a571c5173b72d3cf7881540db3f6de42f46ad0f7e39bd69f27bfd196f6', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('211bfab8-eab9-407f-ac09-aeb6a8adfcb1', 'Probabilités', 'terminale', '{"contexte":"Une usine fabrique des ampoules. On sait que 5% des ampoules produites sont défectueuses. Après fabrication, les ampoules sont emballées par lots de 10. On suppose que la production est suffisamment grande pour que le tirage d''une ampoule soit assimilé à un tirage avec remise.","questions":["Justifie que la variable aléatoire $X$ qui compte le nombre d''ampoules défectueuses dans un lot de 10 suit une loi binomiale. Précise ses paramètres.","Calcule la probabilité qu''il n''y ait aucune ampoule défectueuse dans un lot.","Calcule la probabilité qu''il y ait exactement une ampoule défectueuse dans un lot.","Calcule la probabilité qu''il y ait au moins deux ampoules défectueuses dans un lot.","Calcule l''espérance de la variable aléatoire $X$. Interprète ce résultat."]}', '1. Justification de la loi binomiale :
- Il y a $n=10$ tirages identiques et indépendants (choix d''une ampoule).
- Chaque tirage a deux issues possibles : "succès" (l''ampoule est défectueuse) ou "échec" (l''ampoule n''est pas défectueuse).
- La probabilité de succès est constante à chaque tirage : $p = 0.05$. 
Donc $X$ suit une loi binomiale $B(n=10, p=0.05)$.

2. Probabilité qu''il n''y ait aucune ampoule défectueuse :
$P(X=0) = \binom{10}{0} (0.05)^0 (1-0.05)^{10-0} = 1 \times 1 \times (0.95)^{10} \approx 0.5987$

3. Probabilité qu''il y ait exactement une ampoule défectueuse :
$P(X=1) = \binom{10}{1} (0.05)^1 (1-0.05)^{10-1} = 10 \times 0.05 \times (0.95)^9 \approx 0.3151$

4. Probabilité qu''il y ait au moins deux ampoules défectueuses :
$P(X \ge 2) = 1 - P(X < 2) = 1 - (P(X=0) + P(X=1))$
$P(X \ge 2) \approx 1 - (0.5987 + 0.3151) = 1 - 0.9138 = 0.0862$

5. Espérance de la variable aléatoire $X$ :
$E(X) = n \times p = 10 \times 0.05 = 0.5$
Interprétation : En moyenne, sur un grand nombre de lots de 10 ampoules, on devrait trouver 0.5 ampoule défectueuse par lot.', '["Pour justifier qu''il s''agit d''une loi binomiale, pense aux trois conditions à vérifier.","La formule de la probabilité d''une loi binomiale est $P(X=k) = \\binom{n}{k} p^k (1-p)^{n-k}$.","Pour ''au moins deux'', pense à l''événement contraire.","L''espérance d''une loi binomiale de paramètres $n$ et $p$ est $E(X) = n \\times p$."]'::jsonb, '2025-10-27T15:42:50.886632+00:00'::timestamptz, '7136e7695f95d6cc4558ebdab01dba457a53018427a335df9dbfe4065acc2537', NULL),
('a27f6967-6942-4bc7-bfa4-2ee5b38482a4', 'Probabilités', 'terminale', '{"contexte":"Une usine fabrique des composants électroniques. Le taux de défectuosité d''un composant est de $3 \\%$. Pour contrôler la qualité, on prélève au hasard et avec remise un échantillon de $12$ composants. On désigne par $X$ la variable aléatoire qui compte le nombre de composants défectueux dans cet échantillon.","questions":["Identifie clairement les deux issues possibles pour le prélèvement d''un composant et leurs probabilités respectives.","Justifie pourquoi les tirages sont considérés comme indépendants dans ce contexte.","Explique pourquoi la variable aléatoire $X$ suit une loi binomiale. Précise les paramètres $n$ et $p$ de cette loi.","Calcule la probabilité qu''aucun composant ne soit défectueux dans l''échantillon.","Calcule la probabilité qu''exactement deux composants soient défectueux dans l''échantillon."]}', '1. Les deux issues possibles pour le prélèvement d''un composant sont :
   - Le composant est défectueux (succès), avec une probabilité $p = 0,03$.
   - Le composant n''est pas défectueux (échec), avec une probabilité $1-p = 1 - 0,03 = 0,97$.

2. Les tirages sont considérés comme indépendants car le prélèvement est effectué "avec remise". Cela signifie que le fait de prélever un composant ne modifie pas la composition du stock pour le prélèvement suivant.

3. La variable aléatoire $X$ suit une loi binomiale car :
   - L''expérience consiste en une répétition de $n=12$ épreuves identiques et indépendantes (prélèvement avec remise).
   - Chaque épreuve n''a que deux issues possibles : le composant est défectueux (succès) ou il ne l''est pas (échec).
   - La probabilité de succès $p=0,03$ reste constante d''une épreuve à l''autre.
   Les paramètres de cette loi binomiale sont donc $n=12$ (nombre d''épreuves) et $p=0,03$ (probabilité de succès).

4. La probabilité qu''aucun composant ne soit défectueux est $P(X=0)$.
   $P(X=0) = \binom{12}{0} (0,03)^0 (0,97)^{12-0} = 1 \times 1 \times (0,97)^{12} \approx 0,6938$.

5. La probabilité qu''exactement deux composants soient défectueux est $P(X=2)$.
   $P(X=2) = \binom{12}{2} (0,03)^2 (0,97)^{12-2} = \frac{12 \times 11}{2} \times (0,03)^2 \times (0,97)^{10}$.
   $P(X=2) = 66 \times 0,0009 \times (0,97)^{10} \approx 66 \times 0,0009 \times 0,7374 \approx 0,0438$.', '["Pour les issues, pense à ce qui peut arriver à un composant : est-il bon ou défectueux ?","L''indépendance est liée à la manière dont les composants sont prélevés. Y a-t-il remise ?","Une loi binomiale est caractérisée par un nombre fixe d''épreuves, deux issues possibles, des épreuves indépendantes et une probabilité de succès constante.","La formule de la probabilité d''obtenir $k$ succès pour une loi binomiale est $P(X=k) = \\binom{n}{k} p^k (1-p)^{n-k}$.","Pour \"aucun composant défectueux\", cela signifie $k=0$."]'::jsonb, '2025-10-27T15:48:57.764727+00:00'::timestamptz, '20f8e02da6cb85a78c5b0c3c169695029510f9caa719a79b208a5448a6619a62', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('4ae93676-3dd4-4f69-924f-4c39523a0ab5', 'Dérivation', 'terminale', '{"questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Détermine les dérivées $u''(x)$ et $v''(x)$.","Applique la formule de dérivation d''un quotient pour trouver l''expression de $f''(x)$.","Simplifie au maximum l''expression de $f''(x)$.","Étudie le signe de $f''(x)$ sur l''intervalle $I$ et déduis-en le sens de variation de $f$."],"contexte":"Soit la fonction $f$ définie sur l''intervalle $I = ]-\\infty; 3[$ par $f(x) = \\frac{2x + 5}{3 - x}$."}', '1. Identification de $u(x)$ et $v(x)$ :
   $u(x) = 2x + 5$
   $v(x) = 3 - x$

2. Dérivées de $u(x)$ et $v(x)$ :
   $u''(x) = 2$
   $v''(x) = -1$

3. Application de la formule de dérivation du quotient :
   $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$
   $f''(x) = \frac{2(3 - x) - (2x + 5)(-1)}{(3 - x)^2}$

4. Simplification de $f''(x)$ :
   $f''(x) = \frac{6 - 2x + 2x + 5}{(3 - x)^2}$
   $f''(x) = \frac{11}{(3 - x)^2}$

5. Étude du signe de $f''(x)$ et sens de variation de $f$ :
   Pour tout $x \in I = ]-\infty; 3[$, $(3 - x)^2 > 0$. De plus, $11 > 0$.
   Donc, $f''(x) = \frac{11}{(3 - x)^2} > 0$ sur l''intervalle $I$.
   Par conséquent, la fonction $f$ est strictement croissante sur l''intervalle $I$.', '["La formule de dérivation d''un quotient est $(u/v)'' = (u''v - uv'') / v^2$.","N''oublie pas de bien identifier $u(x)$ et $v(x)$ avant de dériver.","Attention au signe moins dans la formule du numérateur.","Pense à bien développer et réduire le numérateur.","Un carré est toujours positif, donc le signe de la dérivée dépendra du numérateur."]'::jsonb, '2025-10-27T16:11:07.53798+00:00'::timestamptz, '4512693874c4bd0576780d1e9598cb8f0c23639a336179ac0920bcd0c817ce5f', NULL),
('595ed1fb-88e4-4424-b65a-eb2e576a50c4', 'Dérivation', 'terminale', '{"questions":["Identifie clairement les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule les dérivées $u''(x)$ et $v''(x)$.","Applique la formule de dérivation d''un quotient : $f''(x) = \\frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$.","Développe et simplifie l''expression de $f''(x)$ au maximum."],"contexte":"Soit la fonction $f$ définie sur l''intervalle $I = ]-\\infty; -1[$ par $f(x) = \\frac{4x + 7}{x + 1}$."}', '1. Identification des fonctions $u(x)$ et $v(x)$ :
   $u(x) = 4x + 7$
   $v(x) = x + 1$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
   $u''(x) = 4$
   $v''(x) = 1$

3. Application de la formule de dérivation d''un quotient :
   $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$
   $f''(x) = \frac{4(x + 1) - (4x + 7)(1)}{(x + 1)^2}$

4. Développement et simplification de $f''(x)$ :
   $f''(x) = \frac{4x + 4 - 4x - 7}{(x + 1)^2}$
   $f''(x) = \frac{-3}{(x + 1)^2}', '["Rappelle-toi la formule de la dérivée d''un quotient.","Fais attention aux signes lors du développement.","La dérivée de $ax+b$ est $a$."]'::jsonb, '2025-10-27T20:35:09.691324+00:00'::timestamptz, '094374e176f2d76c7b3aa9b474f68b92aaf88afd32745420ff46cabedfdee877', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('d6428032-8dc5-46c1-b97c-6364c5655918', 'Trigonométrie', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = \\cos(x) - \\sin(x)$.","questions":["Calcule la valeur de $f(0)$.","Calcule la valeur de $f(\\frac{\\pi}{2})$.","Calcule la valeur de $f(\\pi)$.","Détermine la dérivée $f''(x)$ de la fonction $f$.","Calcule la valeur de $f''(\\frac{\\pi}{4})$.","Résous l''équation $f(x) = 0$ sur l''intervalle $[0, 2\\pi[$.","Vérifie tes solutions en les substituant dans l''équation de départ."]}', '1. Calcul de $f(0)$ : $f(0) = \cos(0) - \sin(0) = 1 - 0 = 1$.
2. Calcul de $f(\frac{\pi}{2})$ : $f(\frac{\pi}{2}) = \cos(\frac{\pi}{2}) - \sin(\frac{\pi}{2}) = 0 - 1 = -1$.
3. Calcul de $f(\pi)$ : $f(\pi) = \cos(\pi) - \sin(\pi) = -1 - 0 = -1$.
4. Dérivée de $f(x)$ : $f''(x) = -\sin(x) - \cos(x)$.
5. Calcul de $f''(\frac{\pi}{4})$ : $f''(\frac{\pi}{4}) = -\sin(\frac{\pi}{4}) - \cos(\frac{\pi}{4}) = -\frac{\sqrt{2}}{2} - \frac{\sqrt{2}}{2} = -\sqrt{2}$.
6. Résolution de $f(x) = 0$ sur $[0, 2\pi[$ :
   $\cos(x) - \sin(x) = 0 \implies \cos(x) = \sin(x)$.
   On peut diviser par $\cos(x)$ si $\cos(x) \neq 0$. Cela donne $\frac{\sin(x)}{\cos(x)} = 1$, soit $\tan(x) = 1$.
   Les solutions pour $\tan(x) = 1$ sur $[0, 2\pi[$ sont $x = \frac{\pi}{4}$ et $x = \frac{5\pi}{4}$.
   Vérifions les cas où $\cos(x) = 0$. Si $\cos(x) = 0$, alors $x = \frac{\pi}{2}$ ou $x = \frac{3\pi}{2}$. Dans ces cas, $\sin(x)$ est soit $1$ soit $-1$, donc $\cos(x) = \sin(x)$ n''est pas vérifié. Les solutions sont donc $x = \frac{\pi}{4}$ et $x = \frac{5\pi}{4}$.
7. Vérification des solutions :
   Pour $x = \frac{\pi}{4}$ : $f(\frac{\pi}{4}) = \cos(\frac{\pi}{4}) - \sin(\frac{\pi}{4}) = \frac{\sqrt{2}}{2} - \frac{\sqrt{2}}{2} = 0$.
   Pour $x = \frac{5\pi}{4}$ : $f(\frac{5\pi}{4}) = \cos(\frac{5\pi}{4}) - \sin(\frac{5\pi}{4}) = -\frac{\sqrt{2}}{2} - (-\frac{\sqrt{2}}{2}) = -\frac{\sqrt{2}}{2} + \frac{\sqrt{2}}{2} = 0$.', '["Pour calculer les valeurs, remplace $x$ par la valeur donnée dans la fonction $f(x)$.","Rappelle-toi les valeurs de $\\cos(x)$ et $\\sin(x)$ pour $0$, $\\frac{\\pi}{2}$ et $\\pi$.","La dérivée de $\\cos(x)$ est $-\\sin(x)$ et la dérivée de $\\sin(x)$ est $\\cos(x)$.","Pour résoudre $f(x) = 0$, tu dois trouver les valeurs de $x$ pour lesquelles $\\cos(x) = \\sin(x)$. Tu peux diviser par $\\cos(x)$ si $\\cos(x) \\neq 0$.","Si $\\cos(x) = 0$, que se passe-t-il pour $\\sin(x)$ ?","Pense au cercle trigonométrique et aux angles où le cosinus et le sinus sont égaux."]'::jsonb, '2025-10-27T20:51:31.344598+00:00'::timestamptz, '906b9810381883d02db7dabe1bf029e69ab50c7d391b970fe24c43ff5d5b62ed', NULL),
('e640147b-8c6b-440a-9127-f24626f354d3', 'Probabilités', 'terminale', '{"questions":["Décris la situation en termes d''épreuves de Bernoulli. Précise ce que représente un succès et un échec dans ce contexte.","Justifie pourquoi le nombre de puces défectueuses dans l''échantillon peut être modélisé par une loi binomiale. Énumère les conditions nécessaires à l''application de cette loi et vérifie qu''elles sont toutes respectées ici.","Précise les paramètres $n$ et $p$ de cette loi binomiale."],"contexte":"Un fabricant de puces électroniques effectue un contrôle qualité. On considère qu''une puce est défectueuse avec une probabilité de $p = 0,05$. On prélève au hasard et de manière indépendante un échantillon de $n = 50$ puces."}', '1. Une épreuve de Bernoulli consiste à tester une puce électronique. Le succès est "la puce est défectueuse" et l''échec est "la puce n''est pas défectueuse".

2. Le nombre de puces défectueuses peut être modélisé par une loi binomiale $B(n, p)$ car :
   - L''expérience est une répétition de $n=50$ épreuves identiques et indépendantes (le prélèvement de chaque puce est indépendant des autres).
   - Chaque épreuve a deux issues possibles : succès (puce défectueuse) ou échec (puce non défectueuse).
   - La probabilité de succès $p=0,05$ est constante pour chaque épreuve.

3. Les paramètres de cette loi binomiale sont $n=50$ (nombre de répétitions) et $p=0,05$ (probabilité de succès).', '["Pense aux quatre conditions fondamentales pour qu''une situation suive une loi binomiale.","Une épreuve de Bernoulli est une expérience aléatoire qui n''a que deux issues possibles.","Les tirages sont indépendants, est-ce une condition importante pour la loi binomiale ?"]'::jsonb, '2025-10-27T20:52:31.228423+00:00'::timestamptz, '6b0daddfed27d174f12248f563e794f479859b3bfc55d66fa34dd534a45d642a', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('7818b38e-31a2-42c8-96ca-a0e8350a07c7', 'Dérivation', 'terminale', '{"questions":["Identifie et écris clairement les fonctions $u(x)$ et $v(x)$ qui composent la fonction $f(x) = \\frac{u(x)}{v(x)}$.","Calcule séparément les dérivées $u''(x)$ et $v''(x)$.","Écris la formule générale de dérivation d''un quotient : $f''(x) = \\frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$.","Applique cette formule avec les expressions de $u(x)$, $v(x)$, $u''(x)$ et $v''(x)$ que tu as trouvées.","Développe et simplifie l''expression de $f''(x)$ au maximum. Assure-toi que le numérateur est bien réduit."],"contexte":"Soit la fonction $f$ définie sur l''intervalle $I = ]-\\infty; 4[$ par $f(x) = \\frac{3x - 1}{4 - x}$."}', 'Pour la fonction $f(x) = \frac{3x - 1}{4 - x}$ :

1.  Identification de $u(x)$ et $v(x)$ :
    $u(x) = 3x - 1$
    $v(x) = 4 - x$

2.  Calcul des dérivées $u''(x)$ et $v''(x)$ :
    $u''(x) = 3$
    $v''(x) = -1$

3.  Formule de dérivation d''un quotient :
    $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$

4.  Application de la formule :
    $f''(x) = \frac{(3)(4 - x) - (3x - 1)(-1)}{(4 - x)^2}$

5.  Développement et simplification de $f''(x)$ :
    $f''(x) = \frac{12 - 3x - (-3x + 1)}{(4 - x)^2}$
    $f''(x) = \frac{12 - 3x + 3x - 1}{(4 - x)^2}$
    $f''(x) = \frac{11}{(4 - x)^2}', '["N''oublie pas que la dérivée de $ax+b$ est $a$ et celle de $a-x$ est $-1$.","Fais attention aux signes lors de l''application de la formule du quotient, surtout le signe moins entre $u''(x)v(x)$ et $u(x)v''(x)$.","Le dénominateur reste sous la forme d''un carré, pas besoin de le développer."]'::jsonb, '2025-10-27T20:53:04.208293+00:00'::timestamptz, 'f759dd4ad243ffe77d4f05c56910e4c8213d98430b3be73424290ed9ca3912f7', NULL),
('155bb754-7a11-4be2-9865-b4d5293f9ac1', 'Dérivation', 'terminale', '{"questions":["Identifie les fonctions $u(x)$ et $v(x)$ qui composent le numérateur et le dénominateur de $f(x)$.","Calcule les dérivées $u''(x)$ et $v''(x)$.","Écris la formule générale de dérivation d''un quotient.","Applique la formule de dérivation d''un quotient pour exprimer $f''(x)$.","Simplifie au maximum l''expression de $f''(x)$."],"contexte":"Soit la fonction $f$ définie sur l''intervalle $I = ]-\\infty; 2[$ par $f(x) = \\frac{-2x + 3}{x - 2}$."}', '1. Identification de $u(x)$ et $v(x)$ :
   $u(x) = -2x + 3$
   $v(x) = x - 2$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
   $u''(x) = -2$
   $v''(x) = 1$

3. Formule générale de dérivation d''un quotient :
   $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$

4. Application de la formule :
   $f''(x) = \frac{(-2)(x - 2) - (-2x + 3)(1)}{(x - 2)^2}$

5. Simplification de l''expression de $f''(x)$ :
   $f''(x) = \frac{-2x + 4 - (-2x + 3)}{(x - 2)^2}$
   $f''(x) = \frac{-2x + 4 + 2x - 3}{(x - 2)^2}$
   $f''(x) = \frac{1}{(x - 2)^2}', '["La dérivée d''une fonction $ax+b$ est $a$.","La formule de dérivation d''un quotient est $f''(x) = \\frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$.","N''oublie pas les parenthèses lors du développement du numérateur."]'::jsonb, '2025-10-27T21:49:08.814184+00:00'::timestamptz, '4370e01ba2b70aa26d4c1d9093adff2c0d7207d188bf012b415002d626302c9e', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('e33456a5-52f6-4049-b60e-8e8cdfa42d13', 'Probabilités', 'terminale', '{"questions":["Identifie et décris l''épreuve de Bernoulli associée à cette situation. Précise ce que représente un succès et un échec, et quelle est la probabilité de succès.","Explique pourquoi cette expérience peut être modélisée par une loi binomiale. Énumère les quatre conditions nécessaires à l''application de cette loi et vérifie qu''elles sont toutes respectées dans ce cas précis.","Précise les paramètres $n$ et $p$ de la loi binomiale qui modélise cette situation."],"contexte":"Un jeu de société contient un sac avec 100 jetons. Parmi ces jetons, 20 sont rouges et 80 sont bleus. Un joueur tire au hasard un jeton, note sa couleur, puis le remet dans le sac. Il répète cette expérience 5 fois de suite."}', '1. L''épreuve de Bernoulli est le tirage d''un jeton du sac, la note de sa couleur et la remise du jeton dans le sac. Un succès est "obtenir un jeton rouge" et un échec est "obtenir un jeton bleu". La probabilité de succès est $p = \frac{20}{100} = 0,2$.
2. Cette expérience peut être modélisée par une loi binomiale car :
   - L''expérience est répétée $n=5$ fois de manière identique.
   - Les tirages sont indépendants car le jeton est remis dans le sac après chaque tirage.
   - Chaque tirage n''a que deux issues possibles : "jeton rouge" (succès) ou "jeton bleu" (échec).
   - La probabilité de succès $p = 0,2$ reste constante à chaque tirage.
3. Les paramètres de cette loi binomiale sont $n=5$ (nombre de répétitions) et $p=0,2$ (probabilité de succès).', '["Une épreuve de Bernoulli est une expérience aléatoire qui n''a que deux issues possibles.","Les conditions d''une loi binomiale sont : répétition d''expériences identiques et indépendantes, deux issues possibles (succès/échec), probabilité de succès constante.","Le paramètre $n$ représente le nombre de répétitions de l''expérience."]'::jsonb, '2025-10-27T21:50:39.829839+00:00'::timestamptz, '6996975ea6eb212e1e481c644bfe4a7c7315a917cebd43701ae865edac539ec8', NULL),
('9211343b-b60c-493b-890c-82eebadd679f', 'Probabilités', 'terminale', '{"questions":["Quelle est la première condition pour qu''une expérience puisse être modélisée par une loi binomiale ? Vérifie si cette condition est respectée dans le contexte de l''exercice.","Quelle est la deuxième condition pour qu''une expérience puisse être modélisée par une loi binomiale ? Justifie si elle est satisfaite ici.","Formule la troisième condition nécessaire pour appliquer la loi binomiale. Explique comment cette condition s''applique à la situation donnée.","Énonce la quatrième et dernière condition pour l''application d''une loi binomiale. Démontre qu''elle est vérifiée dans cet exercice.","Si toutes les conditions sont remplies, identifie clairement les paramètres $n$ et $p$ de la loi binomiale qui modélise le nombre de micro-interrupteurs défectueux dans l''échantillon."],"contexte":"Un fabricant de composants électroniques teste la fiabilité d''un nouveau type de micro-interrupteur. On sait que la probabilité qu''un micro-interrupteur soit défectueux est de $p = 0,02$. Pour un contrôle qualité, on prélève au hasard et de manière indépendante un échantillon de $n = 100$ micro-interrupteurs."}', '1. La première condition est que l''expérience consiste en une répétition de $n$ épreuves identiques.
Dans cet exercice, on prélève 100 micro-interrupteurs, et chaque prélèvement est une épreuve identique (on teste la fiabilité d''un interrupteur).

2. La deuxième condition est que chaque épreuve ne doit avoir que deux issues possibles : un succès ou un échec.
Ici, pour chaque micro-interrupteur testé, il est soit défectueux (succès, par exemple), soit non défectueux (échec).

3. La troisième condition est que les épreuves doivent être indépendantes les unes des autres.
L''énoncé précise que les micro-interrupteurs sont prélevés "de manière indépendante", ce qui signifie que le fait qu''un interrupteur soit défectueux n''influence pas la défaillance d''un autre.

4. La quatrième condition est que la probabilité de succès $p$ doit rester constante d''une épreuve à l''autre.
La probabilité qu''un micro-interrupteur soit défectueux est donnée comme étant $p = 0,02$ et cette probabilité ne change pas pour chaque interrupteur testé.

5. Puisque toutes les conditions sont remplies, le nombre de micro-interrupteurs défectueux suit une loi binomiale de paramètres $n = 100$ (nombre d''épreuves) et $p = 0,02$ (probabilité de succès).', '["Pense à la nature de chaque tirage ou observation.","Le résultat de chaque essai est-il influencé par les précédents ?","Le nombre d''essais est-il fixe ?","La probabilité de succès change-t-elle à chaque essai ?"]'::jsonb, '2025-10-27T21:50:54.077216+00:00'::timestamptz, '7b73ba517dce67de6f6ab79af9708a9b90adf760302d62da597c6190f879c5f5', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('d30bf6b9-de92-4a2c-b3db-99a4f2abcf50', 'Probabilités', 'terminale', '{"questions":["Décris l''épreuve de Bernoulli associée à cette situation. Précise clairement ce qu''est un succès et un échec, ainsi que leurs probabilités respectives.","Explique pourquoi le nombre d''appels de support technique parmi les 20 prochains appels peut être modélisé par une loi binomiale. Détaille chacune des quatre conditions nécessaires à l''application de cette loi et justifie qu''elles sont toutes remplies dans ce contexte.","Identifie et donne les valeurs numériques des paramètres $n$ et $p$ de cette loi binomiale."],"contexte":"Un centre d''appel reçoit des appels. On sait que la probabilité qu''un appel soit une demande de support technique est de $p = 0,15$. On observe les 20 prochains appels de manière indépendante les uns des autres."}', '1. L''épreuve de Bernoulli est l''observation d''un appel. Un \textbf{succès} est l''événement "l''appel est une demande de support technique", avec $P(\text{succès}) = p = 0,15$. Un \textbf{échec} est l''événement "l''appel n''est pas une demande de support technique", avec $P(\text{échec}) = 1 - p = 1 - 0,15 = 0,85$.

2. Le nombre d''appels de support technique peut être modélisé par une loi binomiale car :
    *   \textbf{Répétition d''épreuves identiques} : L''observation de chaque appel est la même épreuve.
    *   \textbf{Indépendance} : Les appels sont observés de manière indépendante les uns des autres.
    *   \textbf{Deux issues possibles} : Chaque appel est soit une demande de support technique (succès), soit il ne l''est pas (échec).
    *   \textbf{Probabilité de succès constante} : La probabilité qu''un appel soit une demande de support technique est de $p = 0,15$ pour chaque appel.

3. Les paramètres de cette loi binomiale sont $n = 20$ (le nombre d''appels observés) et $p = 0,15$ (la probabilité de succès).', '["Une épreuve de Bernoulli est une expérience aléatoire qui n''a que deux issues possibles.","Les quatre conditions pour une loi binomiale sont : répétition d''épreuves identiques et indépendantes, deux issues possibles (succès/échec), probabilité de succès constante.","Le paramètre $n$ est le nombre total d''épreuves, et $p$ est la probabilité de succès d''une seule épreuve."]'::jsonb, '2025-10-27T21:51:15.686676+00:00'::timestamptz, '5b55b972bbcb50b4943373a41e452d5f9082fc583cbd8423762016e2e767aa5e', NULL),
('c2b681a3-2ca6-4b5d-95a4-ec63afabcfbb', 'Trigonométrie', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = 2\\cos(x) + \\sin(x)$.","questions":["Calcule $f(0)$.","Calcule $f(\\frac{\\pi}{2})$.","Calcule $f(\\pi)$.","Détermine la dérivée $f''(x)$ de la fonction $f$.","Calcule $f''(\\frac{\\pi}{3})$.","Résous l''équation $f''(x) = 0$ sur l''intervalle $[0, 2\\pi[$.","Vérifie tes solutions en les substituant dans l''équation $f''(x)=0$."]}', '1. $f(0) = 2\cos(0) + \sin(0) = 2(1) + 0 = 2$
2. $f(\frac{\pi}{2}) = 2\cos(\frac{\pi}{2}) + \sin(\frac{\pi}{2}) = 2(0) + 1 = 1$
3. $f(\pi) = 2\cos(\pi) + \sin(\pi) = 2(-1) + 0 = -2$
4. $f''(x) = -2\sin(x) + \cos(x)$
5. $f''(\frac{\pi}{3}) = -2\sin(\frac{\pi}{3}) + \cos(\frac{\pi}{3}) = -2(\frac{\sqrt{3}}{2}) + \frac{1}{2} = -\sqrt{3} + \frac{1}{2}$
6. Résolvons $f''(x) = 0$, c''est-à-dire $-2\sin(x) + \cos(x) = 0$. On peut réécrire ceci comme $\cos(x) = 2\sin(x)$, ou $\tan(x) = \frac{1}{2}$.
Soit $\alpha = \arc\tan(\frac{1}{2})$. Les solutions sont $x = \alpha + k\pi$ pour $k \in \mathbb{Z}$.
Sur l''intervalle $[0, 2\pi[$, les solutions sont $x = \alpha$ et $x = \alpha + \pi$.', '["La dérivée de $\\cos(x)$ est $-\\sin(x)$.","La dérivée de $\\sin(x)$ est $\\cos(x)$.","Pour résoudre $f''(x) = 0$, tu devras peut-être utiliser une transformation du type $a\\cos(x) + b\\sin(x) = R\\cos(x-\\phi)$.","Pour $a\\cos(x) + b\\sin(x) = R\\cos(x-\\phi)$, on a $R = \\sqrt{a^2 + b^2}$ et $\\cos(\\phi) = \\frac{a}{R}$, $\\sin(\\phi) = \\frac{b}{R}$."]'::jsonb, '2025-10-27T21:52:48.879291+00:00'::timestamptz, '9ebccf1153cf569e43a2ab1f5300a033d856e6be82d5387dc65bd605a4e24a01', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('f57424d0-6486-43be-9569-cceb5f56fe1a', 'Probabilités', 'terminale', '{"contexte":"On lance 5 fois de suite un dé équilibré à six faces. On s''intéresse au nombre de fois où l''on obtient un 6.","questions":["Quelles sont les conditions nécessaires pour qu''une situation puisse être modélisée par une loi binomiale ?","Vérifie si ces conditions sont remplies dans le contexte de cet exercice.","Déduis-en les paramètres $n$ et $p$ de la loi binomiale qui modélise cette situation.","Quelle est la probabilité d''obtenir exactement deux 6 en 5 lancers ?","Quelle est la probabilité d''obtenir au moins un 6 en 5 lancers ?"]}', '1. Les conditions nécessaires pour qu''une situation puisse être modélisée par une loi binomiale sont :
   - La répétition d''une expérience un nombre fixe de fois ($n$).
   - Chaque répétition est une épreuve de Bernoulli, c''est-à-dire qu''elle n''a que deux issues possibles : succès ou échec.
   - La probabilité de succès ($p$) est la même à chaque répétition.
   - Les répétitions sont indépendantes les unes des autres.

2. Vérifions ces conditions dans le contexte de cet exercice :
   - Répétition fixe : On lance le dé 5 fois, donc $n=5$.
   - Épreuve de Bernoulli : Pour chaque lancer, ''obtenir un 6'' peut être considéré comme un succès, ''ne pas obtenir un 6'' comme un échec. Il y a bien deux issues.
   - Probabilité de succès constante : Le dé est équilibré, donc la probabilité d''obtenir un 6 est $p = 1/6$ à chaque lancer.
   - Indépendance des répétitions : Les lancers d''un dé sont indépendants les uns des autres.
   Toutes les conditions sont remplies.

3. Les paramètres de la loi binomiale $B(n, p)$ sont donc $n=5$ et $p=\frac{1}{6}$.

4. La probabilité d''obtenir exactement deux 6 en 5 lancers est $P(X=2)$.
   $P(X=2) = \binom{5}{2} \left(\frac{1}{6}\right)^2 \left(1-\frac{1}{6}\right)^{5-2}$
   $P(X=2) = 10 \times \left(\frac{1}{36}\right) \times \left(\frac{5}{6}\right)^3$
   $P(X=2) = 10 \times \frac{1}{36} \times \frac{125}{216}$
   $P(X=2) = \frac{1250}{7776} \approx 0.1607$

5. La probabilité d''obtenir au moins un 6 en 5 lancers est $P(X \ge 1)$.
   Il est plus simple de calculer l''événement contraire : $P(X \ge 1) = 1 - P(X=0)$.
   $P(X=0) = \binom{5}{0} \left(\frac{1}{6}\right)^0 \left(1-\frac{1}{6}\right)^{5-0}$
   $P(X=0) = 1 \times 1 \times \left(\frac{5}{6}\right)^5$
   $P(X=0) = \frac{3125}{7776} \approx 0.4019$
   Donc $P(X \ge 1) = 1 - \frac{3125}{7776} = \frac{4651}{7776} \approx 0.5981$', '["Une loi binomiale modélise une succession d''épreuves de Bernoulli indépendantes et identiques.","Pour chaque lancer, y a-t-il seulement deux issues possibles (succès/échec) ? Les lancers sont-ils indépendants ?","Le paramètre $n$ représente le nombre d''épreuves répétées. Le paramètre $p$ représente la probabilité de succès à chaque épreuve.","Utilise la formule de probabilité d''une loi binomiale $P(X=k) = \\binom{n}{k} p^k (1-p)^{n-k}$.","Il peut être plus simple de calculer l''événement contraire."]'::jsonb, '2025-10-27T22:04:29.462013+00:00'::timestamptz, 'de7376884439cb8920f2020de2f7c0e2d05390abdff6f1f09d2191d74f56163f', NULL),
('d01be48e-f097-4c82-b4cc-759e6428d3e4', 'Dérivation', 'terminale', '{"questions":["Identifie clairement les fonctions $u(x)$ et $v(x)$ qui composent la fonction $f(x) = \\frac{u(x)}{v(x)}$.","Calcule les dérivées $u''(x)$ et $v''(x)$.","Écris la formule générale de dérivation d''un quotient.","Applique la formule de dérivation d''un quotient pour exprimer $f''(x)$.","Développe et simplifie le numérateur de $f''(x)$ au maximum."],"contexte":"Soit la fonction $f$ définie sur l''intervalle $I = ]-\\infty; 1[$ par $f(x) = \\frac{5x + 2}{1 - x}$."}', '1. Identification de $u(x)$ et $v(x)$ :
   $u(x) = 5x + 2$
   $v(x) = 1 - x$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
   $u''(x) = 5$
   $v''(x) = -1$

3. Formule générale de dérivation d''un quotient :
   $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$

4. Application de la formule pour $f''(x)$ :
   $f''(x) = \frac{5(1 - x) - (5x + 2)(-1)}{(1 - x)^2}$

5. Développement et simplification du numérateur :
   $f''(x) = \frac{5 - 5x - (-5x - 2)}{(1 - x)^2}$
   $f''(x) = \frac{5 - 5x + 5x + 2}{(1 - x)^2}$
   $f''(x) = \frac{7}{(1 - x)^2}', '["La fonction $u(x)$ est le numérateur et $v(x)$ est le dénominateur.","Attention aux signes lors du calcul des dérivées.","La formule est $f''(x) = \\frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$.","N''oublie pas les parenthèses quand tu remplaces $u(x)$, $v(x)$, $u''(x)$ et $v''(x)$ dans la formule.","Développe attentivement le numérateur et regroupe les termes similaires."]'::jsonb, '2025-10-27T22:05:02.470051+00:00'::timestamptz, '912a65ea20883f6fb63c126ad12d9411b35b26fb433f2e76d24284cfd231247c', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('d02b360b-d583-417e-bdc9-2d4c02f247ef', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur l''intervalle $I = ]-\\infty; -3[$ par $f(x) = \\frac{2x - 5}{x + 3}$.","questions":["Écris la fonction $f(x)$ sous la forme d''un quotient de deux fonctions $u(x)$ et $v(x)$. Identifie clairement $u(x)$ et $v(x)$.","Détermine les dérivées $u''(x)$ et $v''(x)$ de ces deux fonctions.","Rappelle la formule générale pour la dérivée d''un quotient $\\left(\\frac{u}{v}\\right)''$.","Applique cette formule pour exprimer $f''(x)$ en utilisant les expressions de $u(x)$, $v(x)$, $u''(x)$ et $v''(x)$ que tu as trouvées.","Simplifie l''expression du numérateur de $f''(x)$ au maximum et écris le résultat final sous la forme la plus réduite."]}', '1. Identification de $u(x)$ et $v(x)$ :
$u(x) = 2x - 5$
$v(x) = x + 3$

2. Dérivées $u''(x)$ et $v''(x)$ :
$u''(x) = 2$
$v''(x) = 1$

3. Formule de dérivation d''un quotient :
$\left(\frac{u}{v}\right)'' = \frac{u''v - uv''}{v^2}$

4. Application de la formule :
$f''(x) = \frac{2(x + 3) - (2x - 5)(1)}{(x + 3)^2}$

5. Simplification du numérateur :
$f''(x) = \frac{2x + 6 - 2x + 5}{(x + 3)^2}$
$f''(x) = \frac{11}{(x + 3)^2}$', '["La formule pour la dérivée d''un quotient est $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$.","Fais attention aux signes lors du développement du numérateur.","N''oublie pas de laisser le dénominateur sous forme carrée."]'::jsonb, '2025-10-27T22:23:09.758902+00:00'::timestamptz, '40e80c24f4666539d90c9bf7e2d7cea361ee74c4c214bd96fa32c884bc5b769a', NULL),
('179f6f2c-11e7-4e1b-9490-abc241aed845', 'Trigonométrie', 'terminale', '{"questions":["En utilisant l''identité trigonométrique fondamentale, exprime $\\cos^2(x)$ en fonction de $\\sin^2(x)$.","Substitute cette expression dans l''équation initiale pour obtenir une équation ne contenant que des termes en $\\sin(x)$.","Pose $Y = \\sin(x)$ et résous l''équation du second degré en $Y$ sur l''intervalle $[-1, 1]$.","Pour chaque valeur de $Y$ trouvée, résous $\\sin(x) = Y$ sur l''intervalle $[0, 2\\pi[$.","Vérifie si les solutions obtenues sont valides en les substituant dans l''équation de départ."],"contexte":"Soit l''équation trigonométrique suivante : $2\\cos^2(x) - \\sin(x) - 1 = 0$."}', '1. L''identité trigonométrique fondamentale est $\cos^2(x) + \sin^2(x) = 1$. Donc, $\cos^2(x) = 1 - \sin^2(x)$.
2. En substituant dans l''équation : $2(1 - \sin^2(x)) - \sin(x) - 1 = 0 \implies 2 - 2\sin^2(x) - \sin(x) - 1 = 0 \implies -2\sin^2(x) - \sin(x) + 1 = 0$.
3. Posons $Y = \sin(x)$. L''équation devient $-2Y^2 - Y + 1 = 0$. C''est une équation du second degré. On calcule le discriminant : $\Delta = (-1)^2 - 4(-2)(1) = 1 + 8 = 9$. Les solutions sont $Y = \frac{-(-1) \pm \sqrt{9}}{2(-2)} = \frac{1 \pm 3}{-4}$.
   $Y_1 = \frac{1 + 3}{-4} = \frac{4}{-4} = -1$.
   $Y_2 = \frac{1 - 3}{-4} = \frac{-2}{-4} = \frac{1}{2}$.
   Les deux solutions $Y_1 = -1$ et $Y_2 = \frac{1}{2}$ sont dans l''intervalle $[-1, 1]$.
4. Résolution de $\sin(x) = Y$ sur $[0, 2\pi[$ :
   a) Pour $Y = -1$ : $\sin(x) = -1 \implies x = \frac{3\pi}{2}$.
   b) Pour $Y = \frac{1}{2}$ : $\sin(x) = \frac{1}{2} \implies x = \frac{\pi}{6}$ ou $x = \pi - \frac{\pi}{6} = \frac{5\pi}{6}$.
   Les solutions sont donc $x = \frac{3\pi}{2}$, $x = \frac{\pi}{6}$, $x = \frac{5\pi}{6}$.
5. Vérification des solutions :
   - Pour $x = \frac{3\pi}{2}$ : $2\cos^2(\frac{3\pi}{2}) - \sin(\frac{3\pi}{2}) - 1 = 2(0)^2 - (-1) - 1 = 0 + 1 - 1 = 0$. Solution valide.
   - Pour $x = \frac{\pi}{6}$ : $2\cos^2(\frac{\pi}{6}) - \sin(\frac{\pi}{6}) - 1 = 2\left(\frac{\sqrt{3}}{2}\right)^2 - \frac{1}{2} - 1 = 2\left(\frac{3}{4}\right) - \frac{1}{2} - 1 = \frac{3}{2} - \frac{1}{2} - 1 = 1 - 1 = 0$. Solution valide.
   - Pour $x = \frac{5\pi}{6}$ : $2\cos^2(\frac{5\pi}{6}) - \sin(\frac{5\pi}{6}) - 1 = 2\left(-\frac{\sqrt{3}}{2}\right)^2 - \frac{1}{2} - 1 = 2\left(\frac{3}{4}\right) - \frac{1}{2} - 1 = \frac{3}{2} - \frac{1}{2} - 1 = 1 - 1 = 0$. Solution valide.', '["Rappelle-toi de l''identité fondamentale : $\\cos^2(x) + \\sin^2(x) = 1$.","L''équation du second degré sera de la forme $aY^2 + bY + c = 0$.","N''oublie pas que $\\sin(x)$ est compris entre -1 et 1.","Pour résoudre $\\sin(x) = k$, tu peux t''aider du cercle trigonométrique ou des valeurs remarquables.","Garde à l''esprit que $\\sin(x) = k$ a souvent deux solutions sur $[0, 2\\pi[$ si $k \\in ]-1, 1[$ (sauf pour $k=\\pm 1$ et $k=0$)."]'::jsonb, '2025-10-27T22:43:00.697554+00:00'::timestamptz, '74af72bee98a7ac6a78a8b9803c41d8f16f036f02e1410774a72c3e5992a8c80', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('03754b59-c0c3-4909-a481-b41b4e311afc', 'Trigonométrie', 'terminale', '{"questions":["Simplifie l''expression $\\frac{\\sin(2x)}{1 + \\cos(2x)}$ en utilisant les formules de duplication.","Résous l''équation trigonométrique obtenue sur l''intervalle $[0, 2\\pi[$.","Vérifie tes solutions en les substituant dans l''équation de départ et en t''assurant que les dénominateurs ne sont pas nuls."],"contexte":"Soit l''équation trigonométrique suivante à résoudre pour $x \\in [0, 2\\pi[$ : $$\\frac{\\sin(2x)}{1 + \\cos(2x)} = \\sqrt{3}$$"}', '1. Simplification de l''expression :\nOn utilise les formules de duplication :\n$\sin(2x) = 2\sin(x)\cos(x)$\n$\cos(2x) = 2\cos^2(x) - 1$\nDonc $1 + \cos(2x) = 1 + (2\cos^2(x) - 1) = 2\cos^2(x)$.\nL''expression devient : $$\frac{\sin(2x)}{1 + \cos(2x)} = \frac{2\sin(x)\cos(x)}{2\cos^2(x)} = \frac{\sin(x)}{\cos(x)} = \tan(x)$$Condition : $1 + \cos(2x) \neq 0$, ce qui signifie $2\cos^2(x) \neq 0$, donc $\cos(x) \neq 0$. Cela implique $x \neq \frac{\pi}{2}$ et $x \neq \frac{3\pi}{2}$.\n\n2. Résolution de l''équation $\tan(x) = \sqrt{3}$ sur $[0, 2\pi[$ :\nOn sait que $\tan(\frac{\pi}{3}) = \sqrt{3}$.\nLa fonction tangente est périodique de période $\pi$. Donc les solutions générales sont $x = \frac{\pi}{3} + k\pi$, où $k \in \mathbb{Z}$.\nPour $x \in [0, 2\pi[$ :\nSi $k=0$, $x = \frac{\pi}{3}$.\nSi $k=1$, $x = \frac{\pi}{3} + \pi = \frac{4\pi}{3}$.\n\n3. Vérification des solutions :\nPour $x = \frac{\pi}{3}$ : $\cos(\frac{\pi}{3}) = \frac{1}{2} \neq 0$. La solution est valide.\nPour $x = \frac{4\pi}{3}$ : $\cos(\frac{4\pi}{3}) = -\frac{1}{2} \neq 0$. La solution est valide.\nLes solutions sont donc $x = \frac{\pi}{3}$ et $x = \frac{4\pi}{3}$.', '["Pense aux formules de duplication pour $\\sin(2x)$ et $\\cos(2x)$ : $\\sin(2x) = 2\\sin(x)\\cos(x)$ et $\\cos(2x) = 2\\cos^2(x) - 1$ ou $\\cos(2x) = 1 - 2\\sin^2(x)$ ou $\\cos(2x) = \\cos^2(x) - \\sin^2(x)$.","Après simplification, tu devrais obtenir une équation avec $\\tan(x)$.","N''oublie pas les valeurs principales de la fonction tangente et la périodicité. Pour $x \\in [0, 2\\pi[$, il peut y avoir plusieurs solutions.","Fais attention aux valeurs de $x$ pour lesquelles $1 + \\cos(2x) = 0$."]'::jsonb, '2025-10-27T22:55:13.041779+00:00'::timestamptz, '49e205e9d484d31280f29e290a1fb2e669e02a399f40762e211b860c9c4e6980', NULL),
('68e2ca0d-64a9-49d4-87b6-4a037d9d9325', 'Probabilités', 'terminale', '{"contexte":"Une usine fabrique des pièces détachées. On sait que 5% des pièces produites sont défectueuses. On prélève au hasard, de manière indépendante, un échantillon de 20 pièces.","questions":["Formule la variable aléatoire $X$ associée au nombre de pièces défectueuses dans l''échantillon.","Quelles sont les conditions nécessaires pour que $X$ suive une loi binomiale ? Vérifie si ces conditions sont remplies dans le contexte de cet exercice.","Dans l''hypothèse où $X$ suit une loi binomiale, quels seraient ses paramètres $n$ et $p$ ?"]}', '1. La variable aléatoire $X$ représente le nombre de pièces défectueuses obtenues dans l''échantillon de 20 pièces.

2. Pour que $X$ suive une loi binomiale $B(n,p)$, les conditions suivantes doivent être remplies :
   - L''expérience doit être une répétition de $n$ épreuves identiques et indépendantes.
   - Chaque épreuve ne doit avoir que deux issues possibles : un "succès" (la pièce est défectueuse) ou un "échec" (la pièce n''est pas défectueuse).
   - La probabilité de succès $p$ doit être la même pour chaque épreuve.

   Dans cet exercice :
   - On prélève 20 pièces : il y a donc 20 répétitions identiques de l''expérience.
   - Le prélèvement est effectué "au hasard, de manière indépendante", ce qui garantit l''indépendance des épreuves.
   - Pour chaque pièce, il y a deux issues : défectueuse ou non défectueuse.
   - La probabilité qu''une pièce soit défectueuse est de 5%, soit $p=0,05$, et cette probabilité est constante pour chaque pièce.
   Toutes les conditions sont remplies.

3. Les paramètres de la loi binomiale seraient :
   - $n = 20$ (nombre de pièces prélevées)
   - $p = 0,05$ (probabilité qu''une pièce soit défectueuse)', '["Pense aux caractéristiques d''une épreuve de Bernoulli.","Pour la loi binomiale, il faut répéter plusieurs fois la même épreuve de Bernoulli de manière indépendante.","Le paramètre $n$ représente le nombre de répétitions, et $p$ la probabilité de succès."]'::jsonb, '2025-10-27T22:58:17.030042+00:00'::timestamptz, 'e0759118b0b85887a172b62c000671376d67250c61f5601bba72398396526b3e', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('21b39118-87b3-43eb-a5a1-3b071996f012', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 4$ et $U_{n+1} = \\frac{1}{2}U_n + 1$ pour tout entier naturel $n$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$.","La suite $(U_n)$ est-elle arithmétique ? Justifie ta réponse.","La suite $(U_n)$ est-elle géométrique ? Justifie ta réponse.","On considère la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n - 2$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme $V_0$.","Exprime $V_n$ en fonction de $n$, puis déduis-en l''expression de $U_n$ en fonction de $n$.","Démontre par récurrence que pour tout entier naturel $n$, $U_n > 2$."]}', '1. Calcul des premiers termes :
$U_0 = 4$
$U_1 = \frac{1}{2}U_0 + 1 = \frac{1}{2}(4) + 1 = 2 + 1 = 3$
$U_2 = \frac{1}{2}U_1 + 1 = \frac{1}{2}(3) + 1 = \frac{3}{2} + 1 = \frac{5}{2}$
$U_3 = \frac{1}{2}U_2 + 1 = \frac{1}{2}(\frac{5}{2}) + 1 = \frac{5}{4} + 1 = \frac{9}{4}$

2. La suite $(U_n)$ n''est pas arithmétique.
$U_1 - U_0 = 3 - 4 = -1$
$U_2 - U_1 = \frac{5}{2} - 3 = -\frac{1}{2}$
Comme $U_1 - U_0 \neq U_2 - U_1$, la suite n''est pas arithmétique.

3. La suite $(U_n)$ n''est pas géométrique.
$\frac{U_1}{U_0} = \frac{3}{4}$
$\frac{U_2}{U_1} = \frac{\frac{5}{2}}{3} = \frac{5}{6}$
Comme $\frac{U_1}{U_0} \neq \frac{U_2}{U_1}$, la suite n''est pas géométrique.

4. Démontrons que $(V_n)$ est géométrique.
$V_n = U_n - 2 \implies U_n = V_n + 2$
On a $U_{n+1} = \frac{1}{2}U_n + 1$. En remplaçant $U_n$ et $U_{n+1}$ par leurs expressions en fonction de $V_n$ et $V_{n+1}$ :
$V_{n+1} + 2 = \frac{1}{2}(V_n + 2) + 1$
$V_{n+1} + 2 = \frac{1}{2}V_n + 1 + 1$
$V_{n+1} + 2 = \frac{1}{2}V_n + 2$
$V_{n+1} = \frac{1}{2}V_n$
La suite $(V_n)$ est bien une suite géométrique de raison $q = \frac{1}{2}$.
Son premier terme est $V_0 = U_0 - 2 = 4 - 2 = 2$.

5. Expression de $V_n$ et $U_n$ en fonction de $n$.
Comme $(V_n)$ est une suite géométrique de premier terme $V_0 = 2$ et de raison $q = \frac{1}{2}$, on a :
$V_n = V_0 \cdot q^n = 2 \cdot (\frac{1}{2})^n$
Et comme $U_n = V_n + 2$ :
$U_n = 2 \cdot (\frac{1}{2})^n + 2$

6. Démontrons par récurrence que pour tout entier naturel $n$, $U_n > 2$.
Propriété $P(n): U_n > 2$.

Initialisation : Pour $n=0$, $U_0 = 4$. Or $4 > 2$, donc $P(0)$ est vraie.

Hérédité : Supposons que $P(n)$ est vraie pour un certain entier naturel $n$, c''est-à-dire $U_n > 2$. Démontrons que $P(n+1)$ est vraie, c''est-à-dire $U_{n+1} > 2$.
On sait que $U_{n+1} = \frac{1}{2}U_n + 1$.
Comme $U_n > 2$, alors $\frac{1}{2}U_n > \frac{1}{2}(2)$, ce qui donne $\frac{1}{2}U_n > 1$.
En ajoutant 1 aux deux membres, on obtient $\frac{1}{2}U_n + 1 > 1 + 1$, soit $U_{n+1} > 2$.
Donc $P(n+1)$ est vraie.

Conclusion : Puisque la propriété est vraie pour $n=0$ et qu''elle est héréditaire, alors d''après le principe de récurrence, pour tout entier naturel $n$, $U_n > 2$.', '["Pour montrer qu''une suite est arithmétique, calcule $U_{n+1} - U_n$ et vois si le résultat est une constante.","Pour montrer qu''une suite est géométrique, calcule $\\frac{U_{n+1}}{U_n}$ et vois si le résultat est une constante.","Pour la suite $(V_n)$, remplace $U_n$ par $V_n + 2$ dans la relation de récurrence de $U_{n+1}$.","Pour la récurrence, l''initialisation consiste à vérifier la propriété pour $n=0$. Pour l''hérédité, suppose $U_n > 2$ et montre que $U_{n+1} > 2$ en utilisant la relation de récurrence.","Pour exprimer $U_n$ en fonction de $n$, utilise la relation entre $U_n$ et $V_n$ et l''expression de $V_n$ en fonction de $n$."]'::jsonb, '2025-10-27T22:58:40.057715+00:00'::timestamptz, '72e6ea59d662400285515d7f019100470f2c146f4d39b85c9c5b0679e4f68ae6', NULL),
('eb30dffc-b28c-4f0c-8efe-e38d68aad238', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n$ par $U_0 = 5$ et $U_{n+1} = 0.5U_n + 3$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$.","La suite $(U_n)$ est-elle arithmétique ? Justifie ta réponse.","La suite $(U_n)$ est-elle géométrique ? Justifie ta réponse.","On considère la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n - 6$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras le premier terme et la raison.","Exprime $V_n$ en fonction de $n$, puis déduis-en l''expression de $U_n$ en fonction de $n$.","Calcule la limite de la suite $(U_n)$ lorsque $n$ tend vers $+\\infty$."]}', '1. Calcul des premiers termes :
$U_0 = 5$
$U_1 = 0.5 \times 5 + 3 = 2.5 + 3 = 5.5$
$U_2 = 0.5 \times 5.5 + 3 = 2.75 + 3 = 5.75$
$U_3 = 0.5 \times 5.75 + 3 = 2.875 + 3 = 5.875$

2. La suite $(U_n)$ est-elle arithmétique ?
Calculons $U_1 - U_0 = 5.5 - 5 = 0.5$
Calculons $U_2 - U_1 = 5.75 - 5.5 = 0.25$
Comme $U_1 - U_0 \neq U_2 - U_1$, la suite $(U_n)$ n''est pas arithmétique.

3. La suite $(U_n)$ est-elle géométrique ?
Calculons $\frac{U_1}{U_0} = \frac{5.5}{5} = 1.1$
Calculons $\frac{U_2}{U_1} = \frac{5.75}{5.5} \approx 1.045$
Comme $\frac{U_1}{U_0} \neq \frac{U_2}{U_1}$, la suite $(U_n)$ n''est pas géométrique.

4. Démontrons que $(V_n)$ est une suite géométrique.
$V_{n+1} = U_{n+1} - 6$
$V_{n+1} = (0.5U_n + 3) - 6$
$V_{n+1} = 0.5U_n - 3$
Nous savons que $U_n = V_n + 6$, donc :
$V_{n+1} = 0.5(V_n + 6) - 3$
$V_{n+1} = 0.5V_n + 3 - 3$
$V_{n+1} = 0.5V_n$
La suite $(V_n)$ est donc une suite géométrique de raison $q = 0.5$.
Son premier terme est $V_0 = U_0 - 6 = 5 - 6 = -1$.

5. Expression de $V_n$ et $U_n$ en fonction de $n$.
Comme $(V_n)$ est géométrique, $V_n = V_0 \times q^n = -1 \times (0.5)^n = -(0.5)^n$.
Pour $U_n$, on a $U_n = V_n + 6$, donc $U_n = -(0.5)^n + 6$.

6. Limite de la suite $(U_n)$.
Comme la raison $q = 0.5$ est telle que $|q| < 1$, alors $\lim_{n \to +\infty} (0.5)^n = 0$.
Donc, $\lim_{n \to +\infty} U_n = \lim_{n \to +\infty} (-(0.5)^n + 6) = -0 + 6 = 6$.', '["Pour calculer les termes, utilise la relation de récurrence.","Pour montrer qu''une suite est arithmétique, il faut que $U_{n+1} - U_n$ soit constant.","Pour montrer qu''une suite est géométrique, il faut que $\\frac{U_{n+1}}{U_n}$ soit constant.","Pour $V_n$, exprime $V_{n+1}$ en fonction de $U_{n+1}$, puis remplace $U_{n+1}$ par son expression en fonction de $U_n$. Essaie ensuite de faire apparaître $V_n$.","Une fois que tu as l''expression de $V_n$ en fonction de $n$, utilise la définition de $V_n$ pour trouver $U_n$.","Rappelle-toi la limite d''une suite géométrique de raison $q$ quand $|q|<1$."]'::jsonb, '2025-10-27T22:59:05.398062+00:00'::timestamptz, '16663462cd40d499e63e4c4973f412600c4881394d02f38dc0d8dd94513e2acb', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('c92b8486-6a2e-4a9b-ab5a-d57a90d6f696', 'Suites numériques et raisonnement par récurrence', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 5$ et $U_{n+1} = \\frac{1}{2}U_n + 3$ pour tout entier naturel $n$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$, $U_3$.","Démontre par récurrence que pour tout entier naturel $n$, $U_n > 0$.","On cherche à étudier la convergence de la suite $(U_n)$. Pour cela, on considère la suite auxiliaire $(V_n)$ définie par $V_n = U_n - 6$.  Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$, puis $U_n$ en fonction de $n$.","Détermine la limite de la suite $(U_n)$ lorsque $n$ tend vers $+\\infty$."]}', '1. Calcul des premiers termes :
$U_0 = 5$
$U_1 = \frac{1}{2}(5) + 3 = 2.5 + 3 = 5.5$
$U_2 = \frac{1}{2}(5.5) + 3 = 2.75 + 3 = 5.75$
$U_3 = \frac{1}{2}(5.75) + 3 = 2.875 + 3 = 5.875$

2. Démonstration par récurrence que $U_n > 0$ :
* Initialisation : Pour $n=0$, $U_0 = 5$, et $5 > 0$. La propriété est vraie pour $n=0$.
* Hérédité : Supposons que pour un certain entier naturel $n$, la propriété $P(n) : U_n > 0$ est vraie. Montrons que $P(n+1) : U_{n+1} > 0$ est vraie.
Nous savons que $U_{n+1} = \frac{1}{2}U_n + 3$.
Puisque $U_n > 0$ (par hypothèse de récurrence), alors $\frac{1}{2}U_n > 0$.
Et comme $3 > 0$, la somme $\frac{1}{2}U_n + 3$ est strictement positive. Donc $U_{n+1} > 0$.
* Conclusion : La propriété est initialisée et héréditaire, donc pour tout entier naturel $n$, $U_n > 0$.

3. Démonstration que $(V_n)$ est une suite géométrique :
On a $V_n = U_n - 6$, donc $U_n = V_n + 6$.
Calculons $V_{n+1}$ :
$V_{n+1} = U_{n+1} - 6$
$V_{n+1} = (\frac{1}{2}U_n + 3) - 6$
$V_{n+1} = \frac{1}{2}U_n - 3$
Substituons $U_n = V_n + 6$ :
$V_{n+1} = \frac{1}{2}(V_n + 6) - 3$
$V_{n+1} = \frac{1}{2}V_n + \frac{1}{2}(6) - 3$
$V_{n+1} = \frac{1}{2}V_n + 3 - 3$
$V_{n+1} = \frac{1}{2}V_n$
La suite $(V_n)$ est une suite géométrique de raison $q = \frac{1}{2}$.
Le premier terme est $V_0 = U_0 - 6 = 5 - 6 = -1$.

4. Expression de $V_n$ et $U_n$ en fonction de $n$ :
Puisque $(V_n)$ est géométrique, $V_n = V_0 \times q^n = -1 \times (\frac{1}{2})^n = - (\frac{1}{2})^n$.
On a $U_n = V_n + 6$, donc $U_n = 6 - (\frac{1}{2})^n$.

5. Limite de la suite $(U_n)$ :
Lorsque $n \to +\infty$, $(\frac{1}{2})^n \to 0$ car $-1 < \frac{1}{2} < 1$.
Donc $\lim_{n \to +\infty} U_n = \lim_{n \to +\infty} (6 - (\frac{1}{2})^n) = 6 - 0 = 6$.', '["Pour le calcul des premiers termes, utilise la formule de récurrence étape par étape.","Pour la récurrence, l''initialisation consiste à vérifier la propriété pour $n=0$. Pour l''hérédité, suppose que $U_n > 0$ et montre que $U_{n+1} > 0$.","Pour montrer que $(V_n)$ est géométrique, exprime $V_{n+1}$ en fonction de $V_n$.","Une fois que tu as $V_n$ en fonction de $n$, utilise la relation $U_n = V_n + 6$ pour trouver $U_n$.","Pour la limite, souviens-toi de la limite d''une suite géométrique."]'::jsonb, '2025-10-27T23:00:19.175453+00:00'::timestamptz, '6c3307700855f91ab97ca638505a99a55eef8d8d7cc8911cc517cec049eac610', NULL),
('e540aa13-d274-4187-a9fb-0ff236f9fbd5', 'Suites numériques', 'terminale', '{"questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$.","On considère la propriété $P(n)$ : $U_n > 2$. Démontre par récurrence que pour tout entier naturel $n$, $P(n)$ est vraie.","Démontre que la suite $(U_n)$ est décroissante.","Déduis-en que la suite $(U_n)$ est convergente."],"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n$ par $U_0 = 3$ et $U_{n+1} = \\frac{1}{2}U_n + 1$."}', '1. Calcul des premiers termes :
$U_0 = 3$
$U_1 = \frac{1}{2}U_0 + 1 = \frac{1}{2}(3) + 1 = \frac{3}{2} + 1 = \frac{5}{2} = 2.5$
$U_2 = \frac{1}{2}U_1 + 1 = \frac{1}{2}(\frac{5}{2}) + 1 = \frac{5}{4} + 1 = \frac{9}{4} = 2.25$
$U_3 = \frac{1}{2}U_2 + 1 = \frac{1}{2}(\frac{9}{4}) + 1 = \frac{9}{8} + 1 = \frac{17}{8} = 2.125$

2. Démonstration par récurrence que pour tout $n \in \mathbb{N}$, $U_n > 2$ :
Initialisation : Pour $n=0$, $U_0 = 3$. Or $3 > 2$, donc $P(0)$ est vraie.
Hérédité : Supposons que $P(n)$ est vraie pour un certain entier naturel $n$, c''est-à-dire $U_n > 2$. Montrons que $P(n+1)$ est vraie, c''est-à-dire $U_{n+1} > 2$.
On a $U_{n+1} = \frac{1}{2}U_n + 1$. Puisque $U_n > 2$, on multiplie par $\frac{1}{2}$ (qui est positif) : $\frac{1}{2}U_n > \frac{1}{2}(2)$, donc $\frac{1}{2}U_n > 1$. En ajoutant 1 aux deux membres, on obtient $\frac{1}{2}U_n + 1 > 1 + 1$, soit $U_{n+1} > 2$. Donc $P(n+1)$ est vraie.
Conclusion : La propriété $P(n)$ est vraie pour tout entier naturel $n$.

3. Démontrons que la suite $(U_n)$ est décroissante :
Nous devons étudier le signe de $U_{n+1} - U_n$.
$U_{n+1} - U_n = (\frac{1}{2}U_n + 1) - U_n = 1 - \frac{1}{2}U_n = \frac{2 - U_n}{2}$.
Nous avons démontré par récurrence que $U_n > 2$ pour tout $n \in \mathbb{N}$.
Donc $2 - U_n < 0$.
Par conséquent, $U_{n+1} - U_n < 0$. La suite $(U_n)$ est décroissante.

4. Déduisons-en que la suite $(U_n)$ est convergente :
La suite $(U_n)$ est décroissante (démontré à la question précédente).
Nous avons également démontré par récurrence que $U_n > 2$ pour tout $n \in \mathbb{N}$. Cela signifie que la suite $(U_n)$ est minorée par 2.
Un théorème de convergence monotone stipule que toute suite décroissante et minorée est convergente. Donc la suite $(U_n)$ est convergente.', '["Pour le calcul des premiers termes, utilise la formule $U_{n+1} = \\frac{1}{2}U_n + 1$.","Pour l''initialisation de la récurrence, vérifie $P(0)$.","Pour l''hérédité, suppose $U_n > 2$ et cherche à montrer $U_{n+1} > 2$.","Pour montrer que la suite est décroissante, étudie le signe de la différence $U_{n+1} - U_n$.","Pour la convergence, pense au théorème de convergence monotone."]'::jsonb, '2025-10-27T23:08:31.312789+00:00'::timestamptz, '7c8617499b8f0043742fffa4cbe5a6826992a564349f5c87e0f095c0cdf3bd02', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('3b64ba98-e889-4bf0-a8fc-4bc999ea9e69', 'Trigonométrie', 'terminale', '{"contexte":"Soit l''expression trigonométrique $A(x) = \\cos(x) + \\cos\\left(x + \\frac{2\\pi}{3}\\right) + \\cos\\left(x + \\frac{4\\pi}{3}\\right)$.","questions":["Utilise la formule de transformation de somme en produit (ou la formule d''addition) pour simplifier l''expression $A(x)$.","Résous l''équation $A(x) = \\frac{1}{2}$ sur l''intervalle $[0, 2\\pi[$.","Donne les solutions exactes."]}', 'Pour la première question, on utilise la formule de transformation de somme en produit : \(\cos p + \cos q = 2\cos\left(\frac{p+q}{2}\right)\cos\left(\frac{p-q}{2}\right)\). On regroupe les deux derniers termes : \begin{align*} \cos\left(x + \frac{2\pi}{3}\right) + \cos\left(x + \frac{4\pi}{3}\right) &= 2\cos\left(\frac{x + \frac{2\pi}{3} + x + \frac{4\pi}{3}}{2}\right)\cos\left(\frac{x + \frac{2\pi}{3} - (x + \frac{4\pi}{3})}{2}\right) \\ &= 2\cos\left(\frac{2x + 2\pi}{2}\right)\cos\left(\frac{-\frac{2\pi}{3}}{2}\right) \\ &= 2\cos(x + \pi)\cos\left(-\frac{\pi}{3}\right) \\ &= 2(-\cos x)\left(\frac{1}{2}\right) \\ &= -\cos x \end{align*} Donc, $A(x) = \cos x - \cos x = 0$. Pour la deuxième question, on doit résoudre l''équation $A(x) = \frac{1}{2}$. Puisque $A(x) = 0$, l''équation devient $0 = \frac{1}{2}$, ce qui est impossible. Il n''y a donc pas de solutions à cette équation sur l''intervalle $[0, 2\pi[$.', '["Rappelle-toi la formule $\\cos p + \\cos q = 2\\cos\\left(\\frac{p+q}{2}\\right)\\cos\\left(\\frac{p-q}{2}\\right)$.","Tu peux regrouper les deux derniers termes de l''expression $A(x)$ pour commencer.","N''oublie pas que $\\cos(\\pi) = -1$ et $\\cos(2\\pi) = 1$."]'::jsonb, '2025-10-27T23:13:08.456166+00:00'::timestamptz, '2c09bd417c3e04688d689f35063a7a2fe33c38290096bafc1778f63b01cb3c2d', NULL),
('20a3a20c-e636-4c64-ace0-65390eb0b6f7', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ -1 \\}$ par $$f(x) = \\frac{2x - 3}{x + 1}$$","questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$ et calcule leurs dérivées respectives $u''(x)$ et $v''(x)$.","Applique la formule de la dérivée d''un quotient pour calculer $f''(x)$.","Simplifie l''expression de $f''(x)$."]}', '1. On a $u(x) = 2x - 3$ et $v(x) = x + 1$. Alors $u''(x) = 2$ et $v''(x) = 1$.
2. En appliquant la formule $(u/v)'' = (u''v - uv'') / v^2$ :
$f''(x) = \frac{2(x + 1) - (2x - 3)(1)}{(x + 1)^2}$
3. Simplification :
$f''(x) = \frac{2x + 2 - 2x + 3}{(x + 1)^2}$
$f''(x) = \frac{5}{(x + 1)^2}$', '["La formule de la dérivée d''un quotient est $(u/v)'' = (u''v - uv'') / v^2$.","N''oublie pas de bien développer et de réduire le numérateur.","La dérivée de $ax+b$ est $a$."]'::jsonb, '2025-10-27T23:22:08.575561+00:00'::timestamptz, '3627f540462f29cf5c2c830b3dfd043d819b18bcd575c9040cadb76e8dd2aa3b', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('65f52777-9b8a-46ca-ba47-a9cb2c08b1b0', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ -2 \\}$ par $$f(x) = \\frac{3x + 5}{x + 2}$$","questions":["Identifie la forme de la fonction $f(x)$ parmi les suivantes : $u \\times v$, $\\frac{u}{v}$, $u+v$, $u-v$.","Détermine les fonctions $u(x)$ et $v(x)$ ainsi que leurs dérivées respectives $u''(x)$ et $v''(x)$.","Applique la formule de la dérivée d''un quotient pour calculer $f''(x)$.","Simplifie l''expression de $f''(x)$."]}', '1. La fonction $f(x)$ est de la forme $\frac{u}{v}$.

2. On a :
$u(x) = 3x + 5$, donc $u''(x) = 3$
$v(x) = x + 2$, donc $v''(x) = 1$

3. En appliquant la formule de la dérivée d''un quotient $f''(x) = \frac{u''v - uv''}{v^2}$ :
$f''(x) = \frac{3(x + 2) - (3x + 5)(1)}{(x + 2)^2}$

4. Simplifions l''expression :
$f''(x) = \frac{3x + 6 - 3x - 5}{(x + 2)^2}$
$f''(x) = \frac{1}{(x + 2)^2}$', '["La formule pour la dérivée d''un quotient $\\frac{u}{v}$ est $\\frac{u''v - uv''}{v^2}$.","N''oublie pas de bien identifier $u(x)$, $v(x)$, $u''(x)$ et $v''(x)$ avant d''appliquer la formule.","Sois attentif aux signes lors du développement du numérateur."]'::jsonb, '2025-10-27T23:46:57.591336+00:00'::timestamptz, '7637d3e56abe97eec47dc761f8514ef0be60c0f14b23c508aec8b694742e7b17', NULL),
('e2068b7e-38ff-43c1-85f0-64bf71344ab6', 'Dérivation', 'terminale', '{"questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$ et calcule leurs dérivées respectives $u''(x)$ et $v''(x)$.","Applique la formule de la dérivée d''un quotient pour calculer $f''(x)$.","Simplifie l''expression de $f''(x)$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ -1 \\}$ par $$f(x) = \\frac{x^2 + 3x}{x + 1}$$"}', '1. Identification des fonctions et calcul des dérivées :
Soit $u(x) = x^2 + 3x$, alors $u''(x) = 2x + 3$.
Soit $v(x) = x + 1$, alors $v''(x) = 1$.

2. Application de la formule de la dérivée d''un quotient :
$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{(v(x))^2}$
$f''(x) = \frac{(2x + 3)(x + 1) - (x^2 + 3x)(1)}{(x + 1)^2}$

3. Simplification de l''expression de $f''(x)$ :
$f''(x) = \frac{(2x^2 + 2x + 3x + 3) - (x^2 + 3x)}{(x + 1)^2}$
$f''(x) = \frac{2x^2 + 5x + 3 - x^2 - 3x}{(x + 1)^2}$
$f''(x) = \frac{x^2 + 2x + 3}{(x + 1)^2}$', '["La formule de la dérivée d''un quotient est $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$","N''oublie pas de développer et de réduire le numérateur après avoir appliqué la formule.","Pense à factoriser le numérateur si possible pour simplifier l''expression finale."]'::jsonb, '2025-10-28T00:36:31.409982+00:00'::timestamptz, '16a3a930245f3a63ad4c9bd1aeaee81e192e01d9514f99a5a14d5559be469410', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('98539025-ce66-41f4-bb19-02497b309ba6', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ 2 \\}$ par $$f(x) = \\frac{4x - 1}{x - 2}$$","questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule les dérivées respectives $u''(x)$ et $v''(x)$.","Applique la formule de la dérivée d''un quotient pour calculer $f''(x)$.","Simplifie l''expression de $f''(x)$."]}', '1. Identification de $u(x)$ et $v(x)$ :
$u(x) = 4x - 1$
$v(x) = x - 2$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
$u''(x) = 4$
$v''(x) = 1$

3. Application de la formule de la dérivée d''un quotient :
$$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{(v(x))^2}$$
$$f''(x) = \frac{4(x - 2) - (4x - 1)(1)}{(x - 2)^2}$$

4. Simplification de l''expression de $f''(x)$ :
$$f''(x) = \frac{4x - 8 - 4x + 1}{(x - 2)^2}$$
$$f''(x) = \frac{-7}{(x - 2)^2}$$', '["La formule de la dérivée d''un quotient est $$\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$$","N''oublie pas de simplifier au maximum l''expression du numérateur.","Fais attention aux signes lors du développement du numérateur."]'::jsonb, '2025-10-28T01:33:45.779802+00:00'::timestamptz, '656933e0c01452204c55b9a3ce703b8a6b1fc7bbb6bcff8226cfb944f211a924', NULL),
('27ba3074-45d8-4128-b9d1-d9cc5e1e4989', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ 1 \\}$ par $$f(x) = \\frac{2x^2 + 3x - 1}{x - 1}$$","questions":["Détermine les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule les dérivées respectives $u''(x)$ et $v''(x)$.","Applique la formule de la dérivée d''un quotient pour calculer $f''(x)$.","Simplifie l''expression de $f''(x)$."]}', '1. Identification de $u(x)$ et $v(x)$ :
   $u(x) = 2x^2 + 3x - 1$
   $v(x) = x - 1$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
   $u''(x) = 4x + 3$
   $v''(x) = 1$

3. Application de la formule de la dérivée d''un quotient :
   $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$
   $f''(x) = \frac{(4x + 3)(x - 1) - (2x^2 + 3x - 1)(1)}{(x - 1)^2}$

4. Simplification de l''expression de $f''(x)$ :
   $f''(x) = \frac{(4x^2 - 4x + 3x - 3) - (2x^2 + 3x - 1)}{(x - 1)^2}$
   $f''(x) = \frac{4x^2 - x - 3 - 2x^2 - 3x + 1}{(x - 1)^2}$
   $f''(x) = \frac{2x^2 - 4x - 2}{(x - 1)^2}', '["Pour la formule de la dérivée d''un quotient, rappelle-toi : $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$","N''oublie pas de bien développer et réduire le numérateur après avoir appliqué la formule.","Sois attentif aux signes lors du développement."]'::jsonb, '2025-10-28T01:36:11.878986+00:00'::timestamptz, 'af120dd9fd9d9dd7ae54ce4b8ae539e146c389f415bc9d7d9097d4f1216593ea', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('02b7175a-ad4a-454a-83d7-9b96f7e296e3', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ -\\frac{1}{2} \\}$ par $$f(x) = \\frac{3x^2 + x - 5}{2x + 1}$$","questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$","Calcule les dérivées respectives $u''(x)$ et $v''(x)$","Applique la formule de la dérivée d''un quotient pour calculer $f''(x)$","Simplifie l''expression de $f''(x)$ au maximum"]}', '1. Identification de $u(x)$ et $v(x)$ :
   $u(x) = 3x^2 + x - 5$
   $v(x) = 2x + 1$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
   $u''(x) = 6x + 1$
   $v''(x) = 2$

3. Application de la formule de la dérivée d''un quotient :
   $f''(x) = \frac{(6x+1)(2x+1) - (3x^2+x-5)(2)}{(2x+1)^2}$

4. Simplification de l''expression de $f''(x)$ :
   $f''(x) = \frac{(12x^2 + 6x + 2x + 1) - (6x^2 + 2x - 10)}{(2x+1)^2}$
   $f''(x) = \frac{12x^2 + 8x + 1 - 6x^2 - 2x + 10}{(2x+1)^2}$
   $f''(x) = \frac{6x^2 + 6x + 11}{(2x+1)^2}', '["La formule de dérivation d''un quotient est : $$\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$$","N''oublie pas les règles de dérivation des polynômes: $(x^n)'' = nx^{n-1}$ et $(ax+b)'' = a$","Fais attention aux signes lors du développement du numérateur."]'::jsonb, '2025-10-28T01:51:00.50469+00:00'::timestamptz, '4587bd83569845b55d1386446ba2c7097559216d67df366d5385461c38a228ca', NULL),
('0223f0ba-79d4-4d53-bb42-add1099a6a5c', 'Dérivation', 'terminale', '{"questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule la dérivée $u''(x)$ de $u(x)$.","Calcule la dérivée $v''(x)$ de $v(x)$.","Applique la formule de la dérivée d''un quotient pour calculer $f''(x)$.","Simplifie l''expression de $f''(x)$ au maximum."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ -\\frac{3}{2} \\}$ par $$f(x) = \\frac{5x - 2}{2x + 3}$$"}', '1. Identification de $u(x)$ et $v(x)$ :
$u(x) = 5x - 2$
$v(x) = 2x + 3$

2. Calcul de $u''(x)$ :
$u''(x) = 5$

3. Calcul de $v''(x)$ :
$v''(x) = 2$

4. Application de la formule de la dérivée d''un quotient :
$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{(v(x))^2}$
$f''(x) = \frac{5(2x + 3) - (5x - 2)(2)}{(2x + 3)^2}$

5. Simplification de l''expression de $f''(x)$ :
$f''(x) = \frac{10x + 15 - (10x - 4)}{(2x + 3)^2}$
$f''(x) = \frac{10x + 15 - 10x + 4}{(2x + 3)^2}$
$f''(x) = \frac{19}{(2x + 3)^2}$', '["La formule de la dérivée d''un quotient est $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas de bien développer et réduire le numérateur.","Vérifie tes calculs attentivement."]'::jsonb, '2025-10-28T02:05:25.448196+00:00'::timestamptz, '9a51edafd82f8dc30ba69b4d8778638c3fa311c47c57f76489952751f34af996', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('0b90abec-3890-40e9-8eab-b3a20fa05571', 'Suites numériques', 'terminale', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 5$ et, pour tout entier naturel $n$, $U_{n+1} = \\frac{2U_n - 3}{U_n - 2}$.","questions":["Calcule $U_1$.","Calcule $U_2$.","On admet que pour tout entier naturel $n$, $U_n \\neq 2$. On considère la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = \\frac{1}{U_n - 3}$. Calcule $V_0$.","Exprime $V_{n+1}$ en fonction de $U_n$.","Démontre que la suite $(V_n)$ est arithmétique de raison $r = -1$.","Exprime $V_n$ en fonction de $n$.","Déduis-en l''expression de $U_n$ en fonction de $n$."]}', '1. $U_1 = \frac{2U_0 - 3}{U_0 - 2} = \frac{2(5) - 3}{5 - 2} = \frac{10 - 3}{3} = \frac{7}{3}$.

2. $U_2 = \frac{2U_1 - 3}{U_1 - 2} = \frac{2(\frac{7}{3}) - 3}{\frac{7}{3} - 2} = \frac{\frac{14}{3} - \frac{9}{3}}{\frac{7}{3} - \frac{6}{3}} = \frac{\frac{5}{3}}{\frac{1}{3}} = 5$.

3. $V_0 = \frac{1}{U_0 - 3} = \frac{1}{5 - 3} = \frac{1}{2}$.

4. $V_{n+1} = \frac{1}{U_{n+1} - 3} = \frac{1}{\frac{2U_n - 3}{U_n - 2} - 3} = \frac{1}{\frac{2U_n - 3 - 3(U_n - 2)}{U_n - 2}} = \frac{U_n - 2}{2U_n - 3 - 3U_n + 6} = \frac{U_n - 2}{-U_n + 3}$.

5. Pour démontrer que $(V_n)$ est arithmétique, on calcule $V_{n+1} - V_n$ :
$V_{n+1} - V_n = \frac{U_n - 2}{-U_n + 3} - \frac{1}{U_n - 3} = \frac{U_n - 2}{-(U_n - 3)} - \frac{1}{U_n - 3} = \frac{-(U_n - 2)}{U_n - 3} - \frac{1}{U_n - 3} = \frac{-U_n + 2 - 1}{U_n - 3} = \frac{-U_n + 1}{U_n - 3}$.
Il y a une erreur dans la justification de la raison. Reprenons à $V_{n+1} = \frac{U_n - 2}{-U_n + 3}$.
On veut montrer que $V_{n+1} = V_n + r$. On sait que $V_n = \frac{1}{U_n - 3}$, donc $U_n - 3 = \frac{1}{V_n}$, d''où $U_n = 3 + \frac{1}{V_n}$.
$V_{n+1} = \frac{(3 + \frac{1}{V_n}) - 2}{-(3 + \frac{1}{V_n}) + 3} = \frac{1 + \frac{1}{V_n}}{-\frac{1}{V_n}} = \frac{\frac{V_n + 1}{V_n}}{-\frac{1}{V_n}} = -(V_n + 1) = -V_n - 1$.
Donc $V_{n+1} = V_n - 1$, ce qui signifie que la suite $(V_n)$ est arithmétique de raison $r = -1$.

6. La suite $(V_n)$ est arithmétique de premier terme $V_0 = \frac{1}{2}$ et de raison $r = -1$. Donc $V_n = V_0 + nr = \frac{1}{2} - n$.

7. On a $V_n = \frac{1}{U_n - 3}$. Donc $U_n - 3 = \frac{1}{V_n}$, ce qui donne $U_n = 3 + \frac{1}{V_n}$.
En remplaçant $V_n$ par son expression en fonction de $n$ :
$U_n = 3 + \frac{1}{\frac{1}{2} - n} = 3 + \frac{2}{1 - 2n} = \frac{3(1 - 2n) + 2}{1 - 2n} = \frac{3 - 6n + 2}{1 - 2n} = \frac{5 - 6n}{1 - 2n}$.', '["Pour le calcul de $U_1$, remplace $n$ par 0 dans la formule de récurrence.","Pour le calcul de $U_2$, utilise la valeur de $U_1$ que tu viens de trouver.","Pour $V_0$, remplace $n$ par 0 dans la définition de $V_n$ et utilise la valeur de $U_0$.","Pour $V_{n+1}$ en fonction de $U_n$, remplace $U_{n+1}$ par son expression en fonction de $U_n$ dans la définition de $V_n$.","Pour démontrer que $(V_n)$ est arithmétique, calcule $V_{n+1} - V_n$ et montre que le résultat est une constante.","Une fois que tu as $V_0$ et la raison $r$, utilise la formule générale d''une suite arithmétique : $V_n = V_0 + nr$.","Pour exprimer $U_n$ en fonction de $n$, isole $U_n$ à partir de l''expression $V_n = \\frac{1}{U_n - 3}$ et utilise l''expression de $V_n$ en fonction de $n$ que tu as trouvée."]'::jsonb, '2025-10-28T02:05:49.37823+00:00'::timestamptz, '8e08d32c8364b72145510fc3cf510456d2f46060a6cd0b79e7b9f392245c610c', NULL),
('23f33bd3-9754-4c39-a22c-e568cbbc6c33', 'Trigonométrie', 'terminale', '{"questions":["Exprime $1 - \\cos(2x)$ en fonction de $\\sin^2(x)$.","Exprime $\\sin(2x)$ en fonction de $\\sin(x)$ et $\\cos(x)$.","Utilise les résultats précédents pour simplifier l''expression $E(x)$.","Donne la valeur exacte de $E\\left(\\frac{\\pi}{6}\\right)$.","Résous l''équation $E(x) = 1$ sur l''intervalle $]0, \\frac{\\pi}{2}[$."],"contexte":"Soit l''expression $E(x) = \\frac{1 - \\cos(2x)}{\\sin(2x)}$ pour $x \\in ]0, \\frac{\\pi}{2}[$."}', '1. On sait que $\cos(2x) = 1 - 2\sin^2(x)$. Donc $1 - \cos(2x) = 1 - (1 - 2\sin^2(x)) = 2\sin^2(x)$.
2. On sait que $\sin(2x) = 2\sin(x)\cos(x)$.
3. En utilisant les résultats précédents :
$E(x) = \frac{2\sin^2(x)}{2\sin(x)\cos(x)} = \frac{\sin(x)}{\cos(x)} = \tan(x)$.
4. Pour $x = \frac{\pi}{6}$, $E\left(\frac{\pi}{6}\right) = \tan\left(\frac{\pi}{6}\right) = \frac{\sqrt{3}}{3}$.
5. On doit résoudre $E(x) = 1$, ce qui signifie $\tan(x) = 1$. Sur l''intervalle $]0, \frac{\pi}{2}[$, la solution est $x = \frac{\pi}{4}$.', '["Pense aux formules de duplication pour $\\cos(2x)$ et $\\sin(2x)$.","La formule de duplication pour $\\cos(2x)$ est $\\cos(2x) = 1 - 2\\sin^2(x)$ ou $\\cos(2x) = 2\\cos^2(x) - 1$ ou $\\cos(2x) = \\cos^2(x) - \\sin^2(x)$.","La formule de duplication pour $\\sin(2x)$ est $\\sin(2x) = 2\\sin(x)\\cos(x)$.","Pour simplifier, pense à la relation $\\frac{\\sin(x)}{\\cos(x)} = \\tan(x)$.","Pour résoudre l''équation, utilise la fonction tangente inverse."]'::jsonb, '2025-10-28T02:07:33.948185+00:00'::timestamptz, '9c32d621e00fd9a640da215faac66c35643a3e5ae05e65a7944dcfa79613172c', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('cb27ac31-e84d-4250-9e1a-922277bb8f90', 'Trigonométrie', 'terminale', '{"questions":["Factorise l''expression $A(x)$ en utilisant une identité remarquable.","Simplifie l''expression factorisée en utilisant l''identité fondamentale de la trigonométrie et une formule de duplication.","Sachant que $A(x) = \\frac{1}{2}$, trouve toutes les solutions de cette équation sur l''intervalle $[0, 2\\pi[$.","Donne la valeur exacte de $A\\left(\\frac{\\pi}{3}\\right)$."],"contexte":"Soit l''expression $A(x) = \\cos^4(x) - \\sin^4(x)$."}', '1. Factorisation de $A(x)$ :
$A(x) = \cos^4(x) - \sin^4(x)$
$A(x) = (\cos^2(x))^2 - (\sin^2(x))^2$
En utilisant $a^2 - b^2 = (a-b)(a+b)$ avec $a = \cos^2(x)$ et $b = \sin^2(x)$ :
$A(x) = (\cos^2(x) - \sin^2(x))(\cos^2(x) + \sin^2(x))$

2. Simplification de $A(x)$ :
On sait que $\cos^2(x) + \sin^2(x) = 1$ et $\cos^2(x) - \sin^2(x) = \cos(2x)$.
Donc, $A(x) = \cos(2x) \times 1 = \cos(2x)$.

3. Résolution de l''équation $A(x) = \frac{1}{2}$ sur $[0, 2\pi[$ :
On a $\cos(2x) = \frac{1}{2}$.
Posons $X = 2x$. L''intervalle pour $x \in [0, 2\pi[$ devient $X \in [0, 4\pi[$.
Les solutions pour $\cos(X) = \frac{1}{2}$ sont $X = \frac{\pi}{3} + 2k\pi$ et $X = -\frac{\pi}{3} + 2k\pi$ (ou $X = \frac{5\pi}{3} + 2k\pi$).

Pour $X = \frac{\pi}{3} + 2k\pi$ :
$2x = \frac{\pi}{3} + 2k\pi \implies x = \frac{\pi}{6} + k\pi$
Si $k=0$, $x = \frac{\pi}{6}$.
Si $k=1$, $x = \frac{\pi}{6} + \pi = \frac{7\pi}{6}$.
Si $k=2$, $x = \frac{\pi}{6} + 2\pi = \frac{13\pi}{6}$ (hors intervalle).

Pour $X = \frac{5\pi}{3} + 2k\pi$ :
$2x = \frac{5\pi}{3} + 2k\pi \implies x = \frac{5\pi}{6} + k\pi$
Si $k=0$, $x = \frac{5\pi}{6}$.
Si $k=1$, $x = \frac{5\pi}{6} + \pi = \frac{11\pi}{6}$.
Si $k=2$, $x = \frac{5\pi}{6} + 2\pi = \frac{17\pi}{6}$ (hors intervalle).

Les solutions sur $[0, 2\pi[$ sont donc $\left\{ \frac{\pi}{6}, \frac{5\pi}{6}, \frac{7\pi}{6}, \frac{11\pi}{6} \right\}$.

4. Valeur exacte de $A\left(\frac{\pi}{3}\right)$ :
On sait que $A(x) = \cos(2x)$.
Donc $A\left(\frac{\pi}{3}\right) = \cos\left(2 \times \frac{\pi}{3}\right) = \cos\left(\frac{2\pi}{3}\right)$.
Du cercle trigonométrique, $\cos\left(\frac{2\pi}{3}\right) = -\frac{1}{2}$.', '["Pour la première question, pense à l''identité $a^2 - b^2 = (a-b)(a+b)$.","Pour la simplification, rappelle-toi que $\\cos^2(x) + \\sin^2(x) = 1$ et que $\\cos(2x) = \\cos^2(x) - \\sin^2(x)$.","Pour la résolution de l''équation, une fois $A(x)$ simplifiée, tu devrais te retrouver avec une équation du type $\\cos(2x) = \\text{constante}$. N''oublie pas de prendre en compte le changement de variable pour l''intervalle de résolution.","Pour la dernière question, remplace $x$ par la valeur donnée dans l''expression simplifiée de $A(x)$ et utilise ton cercle trigonométrique."]'::jsonb, '2025-10-28T02:43:44.259628+00:00'::timestamptz, '243bdab8de81e87829a17a9a8606d7fb757eaf6e84c0d54a4163f2e3675a1c8e', NULL),
('c75904c4-4139-4684-9415-35f8244aea75', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ \\frac{1}{3} \\}$ par $$f(x) = \\frac{2x^2 - 5x + 3}{3x - 1}$$","questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule les dérivées respectives $u''(x)$ et $v''(x)$.","Applique la formule de la dérivée d''un quotient pour calculer $f''(x)$.","Simplifie l''expression de $f''(x)$ au maximum."]}', '1. Identifions $u(x)$ et $v(x)$ : \n   $u(x) = 2x^2 - 5x + 3$ \n   $v(x) = 3x - 1$ \n\n2. Calculons les dérivées $u''(x)$ et $v''(x)$ : \n   $u''(x) = 4x - 5$ \n   $v''(x) = 3$ \n\n3. Appliquons la formule de la dérivée d''un quotient : \n   $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$ \n   $f''(x) = \frac{(4x - 5)(3x - 1) - (2x^2 - 5x + 3)(3)}{(3x - 1)^2}$ \n\n4. Simplifions l''expression de $f''(x)$ : \n   $f''(x) = \frac{(12x^2 - 4x - 15x + 5) - (6x^2 - 15x + 9)}{(3x - 1)^2}$ \n   $f''(x) = \frac{12x^2 - 19x + 5 - 6x^2 + 15x - 9}{(3x - 1)^2}$ \n   $f''(x) = \frac{6x^2 - 4x - 4}{(3x - 1)^2}', '["La formule de la dérivée d''un quotient est $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas de bien distribuer les signes négatifs lors du calcul de $u''v - uv''$.","Factorise le numérateur si possible pour simplifier l''expression finale."]'::jsonb, '2025-10-28T02:44:21.814211+00:00'::timestamptz, 'bd1f9e8bf25ac799265825337c98c1f4f3f1ec86b69f1888d17095f2216d22dc', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('d708a113-8844-48b7-b9bf-e17c73d98746', 'Dérivation des fonctions', 'Lycée', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{-1\\}$ par : $$f(x) = \\frac{5x - 2}{x + 1}$$","questions":["Identifie la forme de la fonction $f(x)$ et rappelle la formule générale de dérivation pour ce type de fonction.","Détermine les fonctions $u(x)$ et $v(x)$ ainsi que leurs dérivées respectives, $u''(x)$ et $v''(x)$.","Applique la formule de dérivation pour un quotient afin de trouver l''expression de $f''(x)$.","Simplifie l''expression de $f''(x)$ au maximum.","Donne la valeur de $f''(0)$."]}', '1. La fonction $f(x)$ est de la forme $\frac{u(x)}{v(x)}$, où $u(x) = 5x - 2$ et $v(x) = x + 1$. La formule de dérivation d''un quotient est $(\frac{u}{v})'' = \frac{u''v - uv''}{v^2}$.

2. On a :
$u(x) = 5x - 2 \implies u''(x) = 5$
$v(x) = x + 1 \implies v''(x) = 1$

3. En appliquant la formule, on obtient :
$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2} = \frac{5(x + 1) - (5x - 2)(1)}{(x + 1)^2}$

4. Simplifions l''expression de $f''(x)$ :
$f''(x) = \frac{5x + 5 - 5x + 2}{(x + 1)^2} = \frac{7}{(x + 1)^2}$

5. Pour trouver $f''(0)$, on remplace $x$ par $0$ dans l''expression de $f''(x)$ :
$f''(0) = \frac{7}{(0 + 1)^2} = \frac{7}{1^2} = 7$', '["La formule de dérivation d''un quotient est $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$.","Attention aux signes lors de la simplification !","N''oublie pas d''identifier correctement $u(x)$ et $v(x)$ avant de dériver."]'::jsonb, '2025-10-28T08:13:22.307861+00:00'::timestamptz, '9d3511957a0ab4cc07be35b6bdc85a82ee623f095446c371a95ec95cf3110b8a', '{"a":5,"b":-2,"U0":2}'::jsonb),
('05d12946-4652-4fcb-8ff1-28b1bbc0e5f2', 'Suites arithmético-géométriques', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 1$ et $U_{n+1} = 3U_n + 6$ pour tout entier naturel $n$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$, $U_3$.","On cherche un point fixe $L$ tel que $L = 3L + 6$. Détermine la valeur de $L$.","On pose une nouvelle suite $(V_n)$ définie par $V_n = U_n - L$. Exprime $V_{n+1}$ en fonction de $U_n$ et $L$.","Démontre que la suite $(V_n)$ est une suite géométrique. Précise sa raison et son premier terme $V_0$.","Exprime $V_n$ en fonction de $n$.","Déduis-en l''expression de $U_n$ en fonction de $n$."]}', '1. Calcul des premiers termes :
$U_0 = 1$
$U_1 = 3U_0 + 6 = 3(1) + 6 = 9$
$U_2 = 3U_1 + 6 = 3(9) + 6 = 27 + 6 = 33$
$U_3 = 3U_2 + 6 = 3(33) + 6 = 99 + 6 = 105$

2. Détermination du point fixe $L$ :
$L = 3L + 6$
$-2L = 6$
$L = -3$

3. Expression de $V_{n+1}$ en fonction de $U_n$ et $L$ :
$V_{n+1} = U_{n+1} - L$
$V_{n+1} = (3U_n + 6) - (-3)$
$V_{n+1} = 3U_n + 9$

4. Démonstration que $(V_n)$ est une suite géométrique :
On a $U_n = V_n + L = V_n - 3$, donc $U_n = V_n - 3$.
En remplaçant dans l''expression de $V_{n+1}$ :
$V_{n+1} = 3(V_n - 3) + 9$
$V_{n+1} = 3V_n - 9 + 9$
$V_{n+1} = 3V_n$
La suite $(V_n)$ est une suite géométrique de raison $q = 3$.
Le premier terme est $V_0 = U_0 - L = 1 - (-3) = 1 + 3 = 4$.

5. Expression de $V_n$ en fonction de $n$ :
$V_n = V_0 \cdot q^n = 4 \cdot 3^n$

6. Déduction de l''expression de $U_n$ en fonction de $n$ :
$U_n = V_n + L$
$U_n = 4 \cdot 3^n - 3$', '["Pour calculer les premiers termes, utilise la relation de récurrence donnée.","Pour trouver le point fixe $L$, résous l''équation $L = aL + b$.","Pour exprimer $V_{n+1}$ en fonction de $U_n$ et $L$, utilise la définition de $V_{n+1}$ et la relation de récurrence de $U_n$.","Pour montrer que $(V_n)$ est géométrique, exprime $V_{n+1}$ en fonction de $V_n$.","La formule générale d''une suite géométrique est $V_n = V_0 \\cdot q^n$.","Utilise la relation $U_n = V_n + L$ pour trouver l''expression de $U_n$."]'::jsonb, '2025-10-28T08:15:24.770338+00:00'::timestamptz, 'eba40de07cbb1e4da8559fe76dac6523c6e783d95ccb014e280b4214e93d0a63', '{"a":3,"b":6,"U0":1}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('0f0e9ab8-7144-4ff9-bbf9-d26060deca61', 'Calcul de sommes', 'Lycée', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = -1$ et $U_{n+1} = 3U_n + 6$ pour tout entier naturel $n$. On a déjà établi que $U_n = 4 \\cdot 3^n - 3$.","questions":["Calcule la somme $S_n = U_0 + U_1 + \\dots + U_n$ en fonction de $n$.","Écris la somme $S_n$ en utilisant la notation Sigma ($\\Sigma$).","Sépare la somme en deux parties distinctes.","Calcule la somme des termes de la suite géométrique.","Calcule la somme des constantes.","Donne l''expression finale de $S_n$."]}', '1. On cherche à calculer $S_n = U_0 + U_1 + \dots + U_n$.
On sait que $U_n = 4 \cdot 3^n - 3$.

2. $S_n = \sum_{k=0}^{n} U_k = \sum_{k=0}^{n} (4 \cdot 3^k - 3)$

3. On peut séparer la somme en deux parties :
$S_n = \sum_{k=0}^{n} (4 \cdot 3^k) - \sum_{k=0}^{n} 3$

4. La première partie est la somme d''une suite géométrique de premier terme $4 \cdot 3^0 = 4$, de raison $3$ et de $n+1$ termes :
$\sum_{k=0}^{n} (4 \cdot 3^k) = 4 \frac{1 - 3^{n+1}}{1 - 3} = 4 \frac{1 - 3^{n+1}}{-2} = -2(1 - 3^{n+1}) = 2(3^{n+1} - 1)$

5. La deuxième partie est la somme d''une constante $-3$ répétée $n+1$ fois :
$\sum_{k=0}^{n} 3 = 3(n+1)$

6. Donc, l''expression finale de $S_n$ est :
$S_n = 2(3^{n+1} - 1) - 3(n+1)$', '["La somme des termes d''une suite géométrique $a + aq + \\dots + aq^n$ est donnée par la formule $a \\frac{1 - q^{n+1}}{1 - q}$.","La somme d''une constante $k$ répétée $n+1$ fois est $(n+1)k$.","N''oublie pas de bien gérer les indices de la somme."]'::jsonb, '2025-10-28T08:15:49.555086+00:00'::timestamptz, '6640328124eaa130a2af42872982f94f5128f9b53303ccfb3688ab1191fb7f03', '{"a":3,"b":6,"U0":-1}'::jsonb),
('cefd9401-3735-44fe-a80c-05485d12336b', 'Introduction au symbole Sigma ($\Sigma$)', 'Lycée', '{"contexte":"Le symbole Sigma ($\\Sigma$) est utilisé en mathématiques pour représenter la somme d''une série de termes. Par exemple, $\\sum_{i=1}^{n} i$ signifie la somme des entiers de 1 à $n$, soit $1 + 2 + 3 + \\dots + n$.","questions":["Écris la somme $1 + 2 + 3 + 4 + 5$ en utilisant le symbole Sigma ($\\Sigma$).","Écris la somme $2^0 + 2^1 + 2^2 + 2^3$ en utilisant le symbole Sigma ($\\Sigma$).","Développe la somme $\\sum_{k=1}^{4} (2k - 1)$.","Développe la somme $\\sum_{j=0}^{3} j^2$.","Si on a la suite $(U_n)$ définie par $U_n = n+1$, écris la somme des quatre premiers termes $U_0 + U_1 + U_2 + U_3$ en utilisant le symbole Sigma ($\\Sigma$)."]}', '1. $\sum_{i=1}^{5} i$

2. $\sum_{i=0}^{3} 2^i$

3. $\sum_{k=1}^{4} (2k - 1) = (2(1) - 1) + (2(2) - 1) + (2(3) - 1) + (2(4) - 1) = 1 + 3 + 5 + 7 = 16$

4. $\sum_{j=0}^{3} j^2 = 0^2 + 1^2 + 2^2 + 3^2 = 0 + 1 + 4 + 9 = 14$

5. $U_0 + U_1 + U_2 + U_3 = \sum_{n=0}^{3} U_n = \sum_{n=0}^{3} (n+1)$', '["Le chiffre en bas du Sigma indique la valeur de départ de l''indice.","Le chiffre en haut du Sigma indique la valeur de fin de l''indice.","La formule après le Sigma est l''expression générale de chaque terme de la somme.","N''oublie pas de bien définir l''indice de départ et l''indice de fin."]'::jsonb, '2025-10-28T08:16:27.89104+00:00'::timestamptz, '529bde4ea00fc0021c4967a9f71d237c036fffecad15289e12162702dc8e3a09', '{"a":3,"b":-6,"U0":-1}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('5ce8a9b0-6b63-49ed-907d-f1ddfa0daf95', 'Trigonométrie et dérivation', 'Lycée', '{"questions":["Identifie la forme de la fonction $f(x)$ et rappelle la formule générale de dérivation d''un quotient.","Détermine les fonctions $u(x)$ et $v(x)$ ainsi que leurs dérivées respectives, $u''(x)$ et $v''(x)$.","Applique la formule de dérivation pour un quotient afin de trouver l''expression de $f''(x)$.","Simplifie l''expression de $f''(x)$ en utilisant la relation fondamentale de la trigonométrie ($\\\\sin^2(x) + \\\\cos^2(x) = 1$).","Montre que $f''(x) = \\\\frac{1}{1 + \\\\cos(x)}$."],"contexte":"Soit la fonction $f$ définie sur $]0, \\pi[$ par : $$f(x) = \\frac{\\sin(x)}{1 + \\cos(x)}$$"}', '1. La fonction $f(x)$ est de la forme $\frac{u(x)}{v(x)}$, où $u(x) = \sin(x)$ et $v(x) = 1 + \cos(x)$. La formule de dérivation d''un quotient est $(\frac{u}{v})'' = \frac{u''v - uv''}{v^2}$.

2. On a :
$u(x) = \sin(x) \implies u''(x) = \cos(x)$
$v(x) = 1 + \cos(x) \implies v''(x) = -\sin(x)$

3. En appliquant la formule, on obtient :
$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2} = \frac{\cos(x)(1 + \cos(x)) - \sin(x)(-\sin(x))}{(1 + \cos(x))^2}$

4. Simplifions l''expression de $f''(x)$ :
$f''(x) = \frac{\cos(x) + \cos^2(x) + \sin^2(x)}{(1 + \cos(x))^2}$
En utilisant $\sin^2(x) + \cos^2(x) = 1$ :
$f''(x) = \frac{\cos(x) + 1}{(1 + \cos(x))^2}$

5. Montrons que $f''(x) = \frac{1}{1 + \cos(x)}$ :
$f''(x) = \frac{1 + \cos(x)}{(1 + \cos(x))^2} = \frac{1}{1 + \cos(x)}$', '["La formule de dérivation d''un quotient est $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$.","Les dérivées de $\\sin(x)$ et $\\cos(x)$ sont respectivement $\\cos(x)$ et $-\\sin(x)$.","Attention aux signes lors de la simplification !","N''oublie pas que $(1 + \\cos(x))^2 = (1 + \\cos(x))(1 + \\cos(x))$.","Utilise l''identité $\\sin^2(x) + \\cos^2(x) = 1$ pour simplifier le numérateur."]'::jsonb, '2025-10-28T08:17:12.200234+00:00'::timestamptz, '7d195e9c5c692d58a524e7328cf948e17a19b5918928bce302d94752fff98b57', '{"a":2,"b":-1,"U0":-1}'::jsonb),
('dba15048-3672-402e-80bb-801ecc493a9d', 'Probabilités', 'terminale', '{"questions":["Identifie la taille de l''échantillon $n$ dans cette expérience.","Identifie la probabilité $p$ qu''une ampoule soit défectueuse.","Explique pourquoi cette situation peut être modélisée par une loi binomiale en citant les trois conditions nécessaires. (Attention, si une condition n''est pas remplie, la loi binomiale n''est pas applicable)","Soit $X$ la variable aléatoire qui compte le nombre d''ampoules défectueuses dans l''échantillon. Donne les paramètres de la loi binomiale que suit $X$.","Donne la formule générale pour calculer $P(X=k)$ dans le cadre d''une loi binomiale de paramètres $n$ et $p$.","Calcule la probabilité qu''il y ait exactement 2 ampoules défectueuses dans l''échantillon (arrondis à $10^{-4}$ près)."],"contexte":"Une usine fabrique des ampoules. On sait que 5% des ampoules produites sont défectueuses. On prélève au hasard et avec remise un échantillon de 10 ampoules pour les tester."}', '1. La taille de l''échantillon est $n=10$.
2. La probabilité qu''une ampoule soit défectueuse est $p=0,05$.
3. Cette situation peut être modélisée par une loi binomiale car :
   - L''expérience est répétée 10 fois de manière identique et indépendante (prélèvement avec remise).
   - Chaque épreuve n''a que deux issues possibles : l''ampoule est défectueuse (succès) ou elle ne l''est pas (échec).
   - La probabilité de succès (ampoule défectueuse) est constante pour chaque épreuve ($p=0,05$).
4. La variable aléatoire $X$ suit une loi binomiale $\mathcal{B}(10; 0,05)$.
5. La formule générale pour calculer $P(X=k)$ est $P(X=k) = \binom{n}{k} p^k (1-p)^{n-k}$.
6. $P(X=2) = \binom{10}{2} (0,05)^2 (1-0,05)^{10-2} = \frac{10 \times 9}{2} \times (0,05)^2 \times (0,95)^8 \approx 45 \times 0,0025 \times 0,6634 \approx 0,0746$.', '["Pense aux caractéristiques d''une épreuve de Bernoulli.","Chaque tirage est-il indépendant ?","Le nombre de répétitions est-il fixe ?","La probabilité de succès est-elle constante ?","La formule fait intervenir le coefficient binomial $\\binom{n}{k}$."]'::jsonb, '2025-10-28T08:54:56.613788+00:00'::timestamptz, '7e0af205bbbaca66f8afd4e40b4ac6de3875f9130b170eac01daacdee2e5a4e0', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('4d6123c5-ff97-4e21-bd33-19daf57f7312', 'Suites numériques', 'terminale', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 7$ et, pour tout entier naturel $n$, $U_{n+1} = \\frac{1}{2}U_n + 3$.","questions":["Calcule les termes $U_1$, $U_2$ et $U_3$ de la suite.","La suite $(U_n)$ semble-t-elle arithmétique ? Géométrique ? Justifie ta réponse.","On considère la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n - 6$. Calcule $V_0$, $V_1$ et $V_2$.","Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$.","Déduis-en l''expression de $U_n$ en fonction de $n$.","Détermine la limite de la suite $(U_n)$ quand $n$ tend vers $+\\infty$."]}', '1. Calcul des termes :
$U_0 = 7$
$U_1 = \frac{1}{2}(7) + 3 = 3.5 + 3 = 6.5$
$U_2 = \frac{1}{2}(6.5) + 3 = 3.25 + 3 = 6.25$
$U_3 = \frac{1}{2}(6.25) + 3 = 3.125 + 3 = 6.125$

2. Nature de la suite :
$U_1 - U_0 = 6.5 - 7 = -0.5$
$U_2 - U_1 = 6.25 - 6.5 = -0.25$
La différence n''est pas constante, donc la suite n''est pas arithmétique.

$\frac{U_1}{U_0} = \frac{6.5}{7} \approx 0.928$
$\frac{U_2}{U_1} = \frac{6.25}{6.5} \approx 0.961$
Le rapport n''est pas constant, donc la suite n''est pas géométrique.

3. Calcul de $V_0$, $V_1$ et $V_2$ :
$V_0 = U_0 - 6 = 7 - 6 = 1$
$V_1 = U_1 - 6 = 6.5 - 6 = 0.5$
$V_2 = U_2 - 6 = 6.25 - 6 = 0.25$

4. Démonstration que $(V_n)$ est géométrique :
On a $V_n = U_n - 6$, donc $U_n = V_n + 6$.
On sait que $U_{n+1} = \frac{1}{2}U_n + 3$.
Remplaçons $U_n$ et $U_{n+1}$ par leurs expressions en fonction de $V_n$ et $V_{n+1}$ :
$V_{n+1} + 6 = \frac{1}{2}(V_n + 6) + 3$
$V_{n+1} + 6 = \frac{1}{2}V_n + 3 + 3$
$V_{n+1} + 6 = \frac{1}{2}V_n + 6$
$V_{n+1} = \frac{1}{2}V_n$
La suite $(V_n)$ est donc une suite géométrique de raison $q = \frac{1}{2}$ et de premier terme $V_0 = 1$.

5. Expression de $V_n$ en fonction de $n$ :
Comme $(V_n)$ est géométrique, $V_n = V_0 \times q^n = 1 \times (\frac{1}{2})^n = (\frac{1}{2})^n$.

6. Expression de $U_n$ en fonction de $n$ :
On a $U_n = V_n + 6$, donc $U_n = (\frac{1}{2})^n + 6$.

7. Limite de la suite $(U_n)$ :
Comme $q = \frac{1}{2}$ et que $-1 < \frac{1}{2} < 1$, on a $\lim_{n \to +\infty} (\frac{1}{2})^n = 0$.
Donc $\lim_{n \to +\infty} U_n = 0 + 6 = 6$.', '["Pour calculer $U_1$, remplace $n$ par 0 dans la formule de récurrence.","Pour vérifier si une suite est arithmétique, regarde si la différence entre deux termes consécutifs est constante. Pour une suite géométrique, regarde si le rapport est constant.","Pour démontrer que $(V_n)$ est géométrique, exprime $V_{n+1}$ en fonction de $V_n$.","La formule générale d''une suite géométrique est $V_n = V_0 \\times q^n$.","Utilise la relation entre $U_n$ et $V_n$ pour trouver $U_n$.","Pour la limite, souviens-toi de la limite de $q^n$ quand $|q| < 1$."]'::jsonb, '2025-10-28T08:55:52.677262+00:00'::timestamptz, '0af4633727bc538bf190150e8660a9dd3df27ec64d4ef0d8faae3b4ac571e634', NULL),
('e8f92bd6-d90a-44a6-bc79-e81ef43d8e77', 'Trigonométrie', 'terminale', '{"questions":["Détermine la dérivée $f''(x)$ de la fonction $f$.","Évalue $f''(0)$.","Évalue $f''(\\frac{\\pi}{2})$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = \\cos(4x + \\frac{\\pi}{3}) - 2\\sin(x)$."}', 'Pour dériver $f(x) = \cos(4x + \frac{\pi}{3}) - 2\sin(x)$:

1. Dérivée de $\cos(4x + \frac{\pi}{3})$:
   On utilise la formule $(\cos(u))'' = -u''\sin(u)$. Ici, $u = 4x + \frac{\pi}{3}$, donc $u'' = 4$.
   La dérivée est $-4\sin(4x + \frac{\pi}{3})$.

2. Dérivée de $-2\sin(x)$:
   On utilise la formule $(k\sin(u))'' = ku''\cos(u)$. Ici, $u = x$, donc $u'' = 1$.
   La dérivée est $-2\cos(x)$.

Donc $f''(x) = -4\sin(4x + \frac{\pi}{3}) - 2\cos(x)$.

Évaluation de $f''(0)$:
$f''(0) = -4\sin(4(0) + \frac{\pi}{3}) - 2\cos(0)$
$f''(0) = -4\sin(\frac{\pi}{3}) - 2(1)$
$f''(0) = -4(\frac{\sqrt{3}}{2}) - 2$
$f''(0) = -2\sqrt{3} - 2$.

Évaluation de $f''(\frac{\pi}{2})$:
$f''(\frac{\pi}{2}) = -4\sin(4(\frac{\pi}{2}) + \frac{\pi}{3}) - 2\cos(\frac{\pi}{2})$
$f''(\frac{\pi}{2}) = -4\sin(2\pi + \frac{\pi}{3}) - 2(0)$
$f''(\frac{\pi}{2}) = -4\sin(\frac{\pi}{3})$ (car $\sin(2\pi + x) = \sin(x)$)
$f''(\frac{\pi}{2}) = -4(\frac{\sqrt{3}}{2})$
$f''(\frac{\pi}{2}) = -2\sqrt{3}$.', '["Rappelle-toi la formule de dérivation de $\\cos(ax+b)$ et $\\sin(ax+b)$.","La dérivée de $\\cos(u)$ est $-u''\\sin(u)$.","La dérivée de $\\sin(u)$ est $u''\\cos(u)$.","N''oublie pas la règle de linéarité de la dérivation : $(u+v)'' = u'' + v''$ et $(ku)'' = ku''$."]'::jsonb, '2025-10-28T08:56:05.976022+00:00'::timestamptz, '4d953cbab3a8b189c499006b0efcad59a3638e20601f63c9cbe4c1051c26dac7', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('3ddcd0eb-17be-4508-bc1d-ff5d3d2389dc', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $]- \\infty; -\\frac{5}{2}[ \\cup ]-\\frac{5}{2}; +\\infty[$ par : $$f(x) = \\frac{2x - 3}{2x + 5}$$","questions":["Identifie la fonction $u(x)$ et la fonction $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule la dérivée $u''(x)$ de $u(x)$ et la dérivée $v''(x)$ de $v(x)$.","Applique la formule de la dérivée d''un quotient pour exprimer $f''(x)$.","Simplifie l''expression de $f''(x)$."]}', '1. Identification de $u(x)$ et $v(x)$ :
   $u(x) = 2x - 3$
   $v(x) = 2x + 5$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
   $u''(x) = 2$
   $v''(x) = 2$

3. Application de la formule de la dérivée d''un quotient :
   $$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{(v(x))^2}$$
   $$f''(x) = \frac{2(2x + 5) - (2x - 3)2}{(2x + 5)^2}$$

4. Simplification de l''expression de $f''(x)$ :
   $$f''(x) = \frac{4x + 10 - (4x - 6)}{(2x + 5)^2}$$
   $$f''(x) = \frac{4x + 10 - 4x + 6}{(2x + 5)^2}$$
   $$f''(x) = \frac{16}{(2x + 5)^2}$$', '["La formule de la dérivée d''un quotient est $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas de bien développer le numérateur et de réduire les termes similaires.","Attention aux signes lors du développement."]'::jsonb, '2025-10-28T09:14:02.359886+00:00'::timestamptz, 'd675155a4f7383be228e0c9875ef59e090070eadd834bfa5f1fa1bf73a66e93c', NULL),
('445a73a8-67f2-4d02-adfe-d259b69bc7d6', 'Dérivation', 'terminale', '{"questions":["Identifie la fonction $u(x)$ et la fonction $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule la dérivée $u''(x)$ de $u(x)$ et la dérivée $v''(x)$ de $v(x)$.","Applique la formule de la dérivée d''un quotient pour exprimer $f''(x)$.","Simplifie l''expression de $f''(x)$."],"contexte":"Soit la fonction $f$ définie sur $]- \\infty; -\\frac{3}{4}[ \\cup ]-\\frac{3}{4}; +\\infty[$ par : $$f(x) = \\frac{3x - 1}{4x + 3}$$"}', '1. Identification de $u(x)$ et $v(x)$ : \(u(x) = 3x - 1\) et \(v(x) = 4x + 3\).
2. Calcul des dérivées $u''(x)$ et $v''(x)$ : \(u''(x) = 3\) et \(v''(x) = 4\).
3. Application de la formule de la dérivée d''un quotient :
   \(f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{(v(x))^2}\)
   \(f''(x) = \frac{3(4x + 3) - (3x - 1)4}{(4x + 3)^2}\)
4. Simplification de l''expression de $f''(x)$ :
   \(f''(x) = \frac{12x + 9 - (12x - 4)}{(4x + 3)^2}\)
   \(f''(x) = \frac{12x + 9 - 12x + 4}{(4x + 3)^2}\)
   \(f''(x) = \frac{13}{(4x + 3)^2}\)', '["Rappelle-toi la formule de la dérivée d''un quotient : $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$.","Fais attention aux signes lors de la simplification du numérateur.","Le dénominateur reste sous la forme $(v(x))^2$."]'::jsonb, '2025-10-28T09:27:53.67668+00:00'::timestamptz, 'e35a903ebcdda383243818e4237cbfbf65e26c87282f603dec8b1c8c427a0064', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('a32f962c-bb6f-44fd-8a77-1613031f7351', 'Dérivation et Trigonométrie', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = 2 \\cos(x) - x$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine le coefficient directeur de la tangente à la courbe de $f$ au point d''abscisse $x = \\frac{\\pi}{2}$.","Donne l''équation de la tangente à la courbe de $f$ au point d''abscisse $x = \\frac{\\pi}{2}$."]}', '1. Dérivée de $f(x) = 2 \cos(x) - x$ :$\newline f''(x) = 2(-\sin(x)) - 1 = -2 \sin(x) - 1$.$\newline \newline$2. Coefficient directeur de la tangente en $x = \frac{\pi}{2}$ :$\newline f''(\frac{\pi}{2}) = -2 \sin(\frac{\pi}{2}) - 1 = -2(1) - 1 = -3$.$\newline \newline$3. Équation de la tangente en $x = \frac{\pi}{2}$ :$\newline$ D''abord, on calcule $f(\frac{\pi}{2}) = 2 \cos(\frac{\pi}{2}) - \frac{\pi}{2} = 2(0) - \frac{\pi}{2} = -\frac{\pi}{2}$.$\newline$ L''équation de la tangente est $y = f''(\frac{\pi}{2})(x - \frac{\pi}{2}) + f(\frac{\pi}{2})$.$\newline y = -3(x - \frac{\pi}{2}) - \frac{\pi}{2}$.$\newline y = -3x + \frac{3\pi}{2} - \frac{\pi}{2}$.$\newline y = -3x + \pi$.', '["Rappelle-toi des formules de dérivation de $\\cos(x)$ et de $x$.","Le coefficient directeur de la tangente est donné par la valeur de la dérivée au point considéré.","L''équation d''une tangente en un point d''abscisse $a$ est $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-10-28T09:34:34.318191+00:00'::timestamptz, '08596f3f6f65d8aa162d4f4e8b0aae5a835662f60cb938b452747a3d9374ac2e', NULL),
('651788e8-26e9-4d29-9efe-4387cdb1f90e', 'Trigonométrie', 'terminale', '{"questions":["Calcule $f(0)$ et $f(\\frac{\\pi}{2})$.","Exprime $f(x)$ en fonction de $\\cos(x)$ et $\\sin(x)$ uniquement.","Détermine l''expression de la dérivée $f''(x)$ de la fonction $f$ sur $\\mathbb{R}$.","Calcule $f''(\\pi)$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = 2\\cos(x) - \\sin(2x)$."}', '1. Calcul de $f(0)$ et $f(\frac{\pi}{2})$ :

$f(0) = 2\cos(0) - \sin(2 \times 0) = 2 \times 1 - \sin(0) = 2 - 0 = 2$.

$f(\frac{\pi}{2}) = 2\cos(\frac{\pi}{2}) - \sin(2 \times \frac{\pi}{2}) = 2 \times 0 - \sin(\pi) = 0 - 0 = 0$.

2. Expression de $f(x)$ en fonction de $\cos(x)$ et $\sin(x)$ uniquement :

On utilise la formule de duplication $\sin(2x) = 2\sin(x)\cos(x)$.

Donc $f(x) = 2\cos(x) - 2\sin(x)\cos(x)$.

3. Détermination de la dérivée $f''(x)$ :

On a $f(x) = 2\cos(x) - \sin(2x)$.

La dérivée de $2\cos(x)$ est $-2\sin(x)$.

La dérivée de $\sin(2x)$ est $2\cos(2x)$ (en utilisant la règle de dérivation des fonctions composées).

Donc $f''(x) = -2\sin(x) - 2\cos(2x)$.

4. Calcul de $f''(\pi)$ :

$f''(\pi) = -2\sin(\pi) - 2\cos(2\pi) = -2 \times 0 - 2 \times 1 = 0 - 2 = -2$.', '["Rappelle-toi les valeurs de $\\cos(0)$, $\\sin(0)$, $\\cos(\\frac{\\pi}{2})$ et $\\sin(\\frac{\\pi}{2})$.","Utilise la formule de duplication du sinus : $\\sin(2x) = 2\\sin(x)\\cos(x)$.","N''oublie pas les règles de dérivation des fonctions trigonométriques : $(\\cos(x))'' = -\\sin(x)$ et $(\\sin(x))'' = \\cos(x)$.","Rappelle-toi les valeurs de $\\cos(\\pi)$ et $\\sin(\\pi)$."]'::jsonb, '2025-10-28T09:49:54.343742+00:00'::timestamptz, '34c33b0b12e370f4b1d7cb744c631e4b9fcd3f2e79269c784ddf5352c14312f5', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('c9856496-86fd-4b71-964f-c460541f3bb3', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $]- \\infty; -\\frac{1}{3}[ \\cup ]-\\frac{1}{3}; +\\infty[$ par : $$f(x) = \\frac{2x + 5}{3x + 1}$$","questions":["Identifie la fonction $u(x)$ et la fonction $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule la dérivée $u''(x)$ de $u(x)$ et la dérivée $v''(x)$ de $v(x)$.","Applique la formule de la dérivée d''un quotient pour exprimer $f''(x)$.","Simplifie l''expression de $f''(x)$."]}', '1. Identification de $u(x)$ et $v(x)$ :
$u(x) = 2x + 5$
$v(x) = 3x + 1$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
$u''(x) = 2$
$v''(x) = 3$

3. Application de la formule de la dérivée d''un quotient :
$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{(v(x))^2}$
$f''(x) = \frac{2(3x + 1) - (2x + 5)(3)}{(3x + 1)^2}$

4. Simplification de $f''(x)$ :
$f''(x) = \frac{6x + 2 - (6x + 15)}{(3x + 1)^2}$
$f''(x) = \frac{6x + 2 - 6x - 15}{(3x + 1)^2}$
$f''(x) = \frac{-13}{(3x + 1)^2}$', '["Pour un quotient $f(x) = \\frac{u(x)}{v(x)}$, la dérivée est $f''(x) = \\frac{u''(x)v(x) - u(x)v''(x)}{(v(x))^2}$.","N''oublie pas de développer et réduire le numérateur après avoir appliqué la formule."]'::jsonb, '2025-10-28T09:50:21.368911+00:00'::timestamptz, '1fd080667222055f3a13003b976a4de7045bb9aa806832c6c4f9b4b851b85ed9', NULL),
('a6d5eb0d-a076-4e2a-9c12-e62979c5155b', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $]-\\infty; -\\frac{5}{3}[ \\cup ]-\\frac{5}{3}; +\\infty[$ par : $$f(x) = \\frac{4x - 1}{3x + 5}$$","questions":["Calcule l''image de $x=0$ par la fonction $f$.","Détermine l''expression de la dérivée $f''(x)$ de la fonction $f$.","Évalue la dérivée $f''(x)$ au point $x=0$.","Donne l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=0$."]}', '1. Calcul de l''image de $x=0$ :
$f(0) = \frac{4(0) - 1}{3(0) + 5} = \frac{-1}{5}$

2. Détermination de la dérivée $f''(x)$ :
Soit $u(x) = 4x - 1$, alors $u''(x) = 4$.
Soit $v(x) = 3x + 5$, alors $v''(x) = 3$.
$f''(x) = \frac{u''v - uv''}{v^2} = \frac{4(3x + 5) - (4x - 1)3}{(3x + 5)^2}$
$f''(x) = \frac{12x + 20 - 12x + 3}{(3x + 5)^2}$
$f''(x) = \frac{23}{(3x + 5)^2}$

3. Évaluation de la dérivée $f''(x)$ au point $x=0$ :
$f''(0) = \frac{23}{(3(0) + 5)^2} = \frac{23}{5^2} = \frac{23}{25}$

4. Équation de la tangente au point d''abscisse $x=0$ :
L''équation de la tangente est $y = f''(0)(x-0) + f(0)$.
$y = \frac{23}{25}x - \frac{1}{5}$', '["Pour la dérivée d''un quotient $\\frac{u}{v}$, la formule est $f'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas que l''équation de la tangente au point d''abscisse $a$ est $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-10-28T09:53:05.877193+00:00'::timestamptz, 'd29ce86222a108035e6e64a5dafc570110f8eca0126b0d8158e241b5254aa136', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('221960d6-0458-4ae5-9ffb-7701d96c0bbe', 'Probabilités', 'terminale', '{"questions":["Décris la situation en termes d''épreuve de Bernoulli, en spécifiant le succès et sa probabilité.","Explique ce qu''est une répétition indépendante d''épreuves de Bernoulli dans ce contexte.","Quel est le nombre $n$ de répétitions si l''on étudie 10 appels consécutifs ?","En utilisant ces informations, justifie si la variable aléatoire $X$ qui compte le nombre d''appels durant plus de 5 minutes parmi ces 10 appels suit une loi binomiale. Si oui, donne ses paramètres $n$ et $p$."],"contexte":"Un centre d''appel reçoit des appels. La probabilité qu''un appel dure plus de 5 minutes est de $P = 0.3$. On considère que la durée de chaque appel est indépendante des autres."}', '1. Une épreuve de Bernoulli est l''observation d''un seul appel. Le succès est "l''appel dure plus de 5 minutes", et la probabilité de succès est $p = 0.3$. L''échec est "l''appel dure 5 minutes ou moins", avec une probabilité de $1-p = 0.7$. 
2. La répétition indépendante d''épreuves de Bernoulli signifie que la durée de chaque appel est indépendante des autres. Le résultat d''un appel (dure plus ou moins de 5 minutes) n''affecte pas la durée des appels suivants. 
3. Si l''on étudie 10 appels consécutifs, le nombre de répétitions est $n = 10$. 
4. Oui, la variable aléatoire $X$ suit une loi binomiale. Les conditions sont remplies : 
   - Il y a $n=10$ répétitions identiques (10 appels). 
   - Chaque répétition est une épreuve de Bernoulli (chaque appel peut durer plus de 5 minutes ou non). 
   - Les répétitions sont indépendantes (la durée d''un appel n''influence pas les autres). 
   - La probabilité de succès est constante pour chaque épreuve ($p=0.3$ pour chaque appel). 
Donc, $X$ suit une loi binomiale $B(10, 0.3)$.', '["Une épreuve de Bernoulli est une expérience aléatoire qui n''a que deux issues possibles : succès ou échec.","La répétition indépendante signifie que le résultat d''une épreuve n''influence pas le résultat d''une autre.","Une variable aléatoire $X$ suit une loi binomiale $B(n,p)$ si elle compte le nombre de succès dans $n$ répétitions indépendantes d''une même épreuve de Bernoulli de probabilité $p$."]'::jsonb, '2025-10-28T10:08:08.293252+00:00'::timestamptz, '782fb1a1ff25310f6d17241db3f694efbba0e614fd985b0e50226a3a4dcafb7a', NULL),
('ee364de8-db51-4613-954e-b237af28ea07', 'Suites numériques et Trigonométrie', 'terminale', '{"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n$ par $U_n = \\sin\\left(\\frac{n\\pi}{3}\\right)$.","questions":["Calcule les quatre premiers termes de la suite : $U_0$, $U_1$, $U_2$, $U_3$.","La suite $(U_n)$ est-elle arithmétique ? Justifie ta réponse.","La suite $(U_n)$ est-elle géométrique ? Justifie ta réponse.","Montre que la suite $(U_n)$ est périodique et détermine sa période."]}', '1. Calcul des premiers termes :
$U_0 = \sin\left(\frac{0\pi}{3}\right) = \sin(0) = 0$
$U_1 = \sin\left(\frac{1\pi}{3}\right) = \frac{\sqrt{3}}{2}$
$U_2 = \sin\left(\frac{2\pi}{3}\right) = \frac{\sqrt{3}}{2}$
$U_3 = \sin\left(\frac{3\pi}{3}\right) = \sin(\pi) = 0$

2. La suite $(U_n)$ est-elle arithmétique ?
$U_1 - U_0 = \frac{\sqrt{3}}{2} - 0 = \frac{\sqrt{3}}{2}$
$U_2 - U_1 = \frac{\sqrt{3}}{2} - \frac{\sqrt{3}}{2} = 0$
Puisque $U_1 - U_0 \neq U_2 - U_1$, la suite $(U_n)$ n''est pas arithmétique.

3. La suite $(U_n)$ est-elle géométrique ?
Si $U_0 = 0$, pour que la suite soit géométrique, tous les termes doivent être nuls, ce qui n''est pas le cas ($U_1 \neq 0$). Donc la suite n''est pas géométrique.

4. Montre que la suite $(U_n)$ est périodique et détermine sa période.
On cherche $p > 0$ tel que $U_{n+p} = U_n$, c''est-à-dire $\sin\left(\frac{(n+p)\pi}{3}\right) = \sin\left(\frac{n\pi}{3}\right)$.
Cela signifie que $\frac{(n+p)\pi}{3} = \frac{n\pi}{3} + 2k\pi$ pour un entier $k$.
$\frac{n\pi}{3} + \frac{p\pi}{3} = \frac{n\pi}{3} + 2k\pi$
$\frac{p\pi}{3} = 2k\pi$
$p = 6k$
La plus petite valeur de $p$ pour $k=1$ est $p=6$. La suite est donc périodique de période 6.', '["Pour calculer les termes, remplace $n$ par la valeur correspondante dans l''expression de $U_n$.","Pour vérifier si une suite est arithmétique, regarde si la différence entre deux termes consécutifs est constante.","Pour vérifier si une suite est géométrique, regarde si le rapport entre deux termes consécutifs est constant.","Pour la périodicité, cherche un entier $p > 0$ tel que $U_{n+p} = U_n$ pour tout $n$."]'::jsonb, '2025-10-28T10:08:38.43471+00:00'::timestamptz, '46a9c91b54fa958be7cc506b277c99567d2896a2bad14a4fcdb36831cfaebd4a', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('bbce1e7e-5968-4587-b1ea-fc6aeebc0397', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $]-\\infty; 4[ \\cup ]4; +\\infty[$ par : $$f(x) = \\frac{7x + 2}{x - 4}$$","questions":["Identifie la fonction $u(x)$ et la fonction $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$ et donne leurs expressions.","Calcule la dérivée $u''(x)$ de $u(x)$ et la dérivée $v''(x)$ de $v(x)$.","Écris la formule générale de la dérivée d''un quotient $\\left(\\frac{u}{v}\\right)''$.","Applique la formule de la dérivée d''un quotient pour exprimer $f''(x)$ en fonction de $u(x)$, $v(x)$, $u''(x)$ et $v''(x)$.","Simplifie l''expression de $f''(x)$."]}', '1. Identification de $u(x)$ et $v(x)$ :
$u(x) = 7x + 2$
$v(x) = x - 4$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
$u''(x) = 7$
$v''(x) = 1$

3. Formule générale de la dérivée d''un quotient :
$\left(\frac{u}{v}\right)'' = \frac{u''v - uv''}{v^2}$

4. Application de la formule :
$f''(x) = \frac{(7)(x - 4) - (7x + 2)(1)}{(x - 4)^2}$

5. Simplification de $f''(x)$ :
$f''(x) = \frac{7x - 28 - 7x - 2}{(x - 4)^2}$
$f''(x) = \frac{-30}{(x - 4)^2}$', '["La fonction $u(x)$ est le numérateur et la fonction $v(x)$ est le dénominateur.","La dérivée d''une fonction de la forme $ax+b$ est $a$.","La formule de la dérivée d''un quotient est $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas de bien distribuer les signes et de regrouper les termes similaires au numérateur."]'::jsonb, '2025-10-28T10:09:14.607509+00:00'::timestamptz, '771f819143e6041091f559fba75bea51f100264297ba15dc24f6ca32d539c227', NULL),
('4f2b7856-3997-4b1b-b833-3c0d3d1aea9a', 'Exercice soumis', 'terminale', 'aide moi à comprendre ce théorème du cours dans le chapitre  géométrie dans l''espace : soient P1 un plan défini par un point et deux vecteurs non colinéaires u1 et v1, P2 un plan défini par un point et deux vecteurs non colinéaires u2 et v2. Dire que les plans P1 et P2 sont parallèles équivaut à dire que les 4 vecteurs  u1, u2, v1 et v2 sont coplanaires', 'En cours de correction', '[]'::jsonb, '2025-10-28T12:28:47.626017+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('722cd286-0aa9-40aa-89cc-25c0b6214d3f', 'Exercice soumis', 'terminale', 'Exercice soumis via image', 'En cours de correction', '[]'::jsonb, '2025-10-28T13:50:30.605214+00:00'::timestamptz, NULL, '{}'::jsonb),
('77014149-17ef-49ef-9d7d-d59e18ce5cb1', 'Exercice soumis', 'terminale', 'aide moi à résoudre cet exercice je galère', 'En cours de correction', '[]'::jsonb, '2025-10-28T17:34:43.955433+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('62a3518e-0e1f-49be-9fae-3de5e19b6263', 'Exercice soumis', 'terminale', 'donne moi une méthode pour résoudre  ces types d''exos', 'En cours de correction', '[]'::jsonb, '2025-10-28T18:10:21.667402+00:00'::timestamptz, NULL, '{}'::jsonb),
('62ec304a-4e16-4b7d-972a-38e648d15ad6', 'Exercice soumis', 'terminale', 'Je suis en terminale mais j''aurais besoin d''un rappel sur le chapitre trigo de première ainsi que des exos pour me remettre dans le bain stp', 'En cours de correction', '[]'::jsonb, '2025-10-28T19:20:18.967006+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('d4762b6a-3dd5-46b3-b94f-60fbfcd5b40a', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $]- \\infty; \\frac{2}{3}[ \\cup ]\\frac{2}{3}; +\\infty[$ par : $$f(x) = \\frac{-5x + 1}{3x - 2}$$","questions":["Identifie la fonction $u(x)$ et la fonction $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$ et donne leurs expressions.","Calcule la dérivée $u''(x)$ de $u(x)$ et la dérivée $v''(x)$ de $v(x)$.","Écris la formule générale de la dérivée d''un quotient $\\left(\\frac{u}{v}\\right)''$.","Applique la formule de la dérivée d''un quotient pour exprimer $f''(x)$ en fonction de $u(x)$, $v(x)$, $u''(x)$ et $v''(x)$.","Simplifie l''expression de $f''(x)$."]}', '1. Identification de $u(x)$ et $v(x)$ :
$u(x) = -5x + 1$
$v(x) = 3x - 2$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
$u''(x) = -5$
$v''(x) = 3$

3. Formule générale de la dérivée d''un quotient :
$\left(\frac{u}{v}\right)'' = \frac{u''v - uv''}{v^2}$

4. Application de la formule :
$f''(x) = \frac{(-5)(3x - 2) - (-5x + 1)(3)}{(3x - 2)^2}$

5. Simplification de $f''(x)$ :
$f''(x) = \frac{-15x + 10 - (-15x + 3)}{(3x - 2)^2}$
$f''(x) = \frac{-15x + 10 + 15x - 3}{(3x - 2)^2}$
$f''(x) = \frac{7}{(3x - 2)^2}$', '["La fonction $u(x)$ est le numérateur et $v(x)$ est le dénominateur.","La dérivée de $ax+b$ est $a$.","La formule est $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$.","Remplace $u$, $v$, $u''$ et $v''$ par leurs expressions dans la formule.","Développe le numérateur et réduis les termes similaires. Attention aux signes !"]'::jsonb, '2025-10-28T20:13:22.50886+00:00'::timestamptz, 'db0b59b8cf11bb47b623a6b351fdfba86562a9bbae7b20c39f4188c242288a58', NULL),
('65224dcf-7ee6-4b20-9e23-fd2031726112', 'Dérivation', 'terminale', '{"questions":["Identifie la fonction $u(x)$ et la fonction $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$ et donne leurs expressions.","Calcule la dérivée $u''(x)$ de $u(x)$ et la dérivée $v''(x)$ de $v(x)$.","Écris la formule générale de la dérivée d''un quotient $\\left(\\frac{u}{v}\\right)''$.","Applique la formule de la dérivée d''un quotient pour exprimer $f''(x)$ en fonction de $u(x)$, $v(x)$, $u''(x)$ et $v''(x)$.","Simplifie l''expression de $f''(x)$."],"contexte":"Soit la fonction $f$ définie sur $]- \\infty; \\frac{1}{2}[ \\cup ]\\frac{1}{2}; +\\infty[$ par : $$f(x) = \\frac{-2x + 7}{2x - 1}$$"}', '1. Identification de $u(x)$ et $v(x)$ :$\quad u(x) = -2x + 7$$\quad v(x) = 2x - 1$2. Calcul des dérivées $u''(x)$ et $v''(x)$ :$\quad u''(x) = -2$$\quad v''(x) = 2$3. Formule générale de la dérivée d''un quotient :$$\left(\frac{u}{v}\right)'' = \frac{u''v - uv''}{v^2}$$4. Application de la formule :$$f''(x) = \frac{(-2)(2x - 1) - (-2x + 7)(2)}{(2x - 1)^2}$$5. Simplification de l''expression de $f''(x)$ :$$f''(x) = \frac{-4x + 2 - (-4x + 14)}{(2x - 1)^2}$$$$f''(x) = \frac{-4x + 2 + 4x - 14}{(2x - 1)^2}$$$$f''(x) = \frac{-12}{(2x - 1)^2}$$', '["La fonction $u(x)$ est le numérateur et $v(x)$ est le dénominateur.","La dérivée d''une fonction de type $ax+b$ est $a$.","La formule est $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas de bien distribuer les signes et de regrouper les termes similaires.","Fais attention aux parenthèses lors du remplacement des expressions."]'::jsonb, '2025-10-28T20:42:18.119268+00:00'::timestamptz, 'd15892a3183abd7190111cb0e26b49eb7eaaa30b52275ff956b45d01af24d286', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('8a518714-240a-4f68-8870-039363b221b3', 'Probabilités', 'terminale', '{"contexte":"Un fabricant de puces électroniques sait que $5\\%$ de ses puces sont défectueuses. Il prélève au hasard un échantillon de 20 puces pour les tester. On note $X$ la variable aléatoire qui représente le nombre de puces défectueuses dans cet échantillon.","questions":["Décris la situation en termes d''épreuves de Bernoulli, en spécifiant le succès et sa probabilité.","Explique ce qu''est une répétition indépendante d''épreuves de Bernoulli dans ce contexte.","Quel est le nombre $n$ de répétitions dans cette situation ?","En utilisant ces informations, justifie si la variable aléatoire $X$ suit une loi binomiale. Si oui, donne ses paramètres $n$ et $p$."]}', '1. Une épreuve de Bernoulli est l''inspection d''une puce. Le succès est "la puce est défectueuse", et sa probabilité est $p = 0.05$. L''échec est "la puce n''est pas défectueuse", de probabilité $1-p = 0.95$.
2. La répétition indépendante d''épreuves de Bernoulli signifie que le fait qu''une puce soit défectueuse ou non n''influence pas le fait qu''une autre puce le soit ou non. Le tirage est fait "au hasard" et l''échantillon est suffisamment petit par rapport à la production totale pour considérer les tirages comme indépendants.
3. Le nombre $n$ de répétitions est le nombre de puces prélevées, soit $n = 20$.
4. La variable aléatoire $X$ compte le nombre de succès (puces défectueuses) sur $n=20$ répétitions indépendantes d''une épreuve de Bernoulli de paramètre $p=0.05$. Donc, $X$ suit une loi binomiale de paramètres $n=20$ et $p=0.05$, notée $B(20; 0.05)$.', '["Une épreuve de Bernoulli est une expérience aléatoire qui n''a que deux issues possibles : succès ou échec.","Les répétitions sont indépendantes si le résultat d''une épreuve n''influence pas le résultat des autres.","La loi binomiale est applicable si les conditions d''une succession d''épreuves de Bernoulli indépendantes sont remplies."]'::jsonb, '2025-10-28T20:51:24.949637+00:00'::timestamptz, '176f7883e3bd6110fd0143a29825a7981c4d335e4fbf84c6e63e4e1683702b7d', NULL),
('6d7350eb-6715-4ebc-a777-6a6a89528f38', 'Intégrales', 'terminale', '{"questions":["Calcule l''intégrale de $f$ sur l''intervalle $[0, 2]$.","Détermine une primitive $F$ de $f$ telle que $F(1) = 5$.","Calcule l''aire de la région délimitée par la courbe de $f$, l''axe des abscisses et les droites d''équations $x = -1$ et $x = 1$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = 2x + 3$."}', '1. Calcul de l''intégrale de $f$ sur $[0, 2]$ :
Une primitive de $f(x) = 2x + 3$ est $F(x) = x^2 + 3x$.
$\int_0^2 (2x + 3) dx = [x^2 + 3x]_0^2 = (2^2 + 3 \times 2) - (0^2 + 3 \times 0) = (4 + 6) - 0 = 10$.

2. Détermination d''une primitive $F$ de $f$ telle que $F(1) = 5$ :
Les primitives de $f(x) = 2x + 3$ sont de la forme $F(x) = x^2 + 3x + C$.
On veut $F(1) = 5$, donc $1^2 + 3 \times 1 + C = 5$.
$1 + 3 + C = 5 \implies 4 + C = 5 \implies C = 1$.
Donc $F(x) = x^2 + 3x + 1$.

3. Calcul de l''aire de la région délimitée par la courbe de $f$, l''axe des abscisses et les droites d''équations $x = -1$ et $x = 1$ :
L''aire est donnée par $\int_{-1}^1 f(x) dx$.
$\int_{-1}^1 (2x + 3) dx = [x^2 + 3x]_{-1}^1 = (1^2 + 3 \times 1) - ((-1)^2 + 3 \times (-1)) = (1 + 3) - (1 - 3) = 4 - (-2) = 6$.', '["Pour calculer l''intégrale, utilise la formule $\\int_a^b f(x) dx = [F(x)]_a^b = F(b) - F(a)$, où $F$ est une primitive de $f$.","Une primitive de $x^n$ est $\\frac{x^{n+1}}{n+1}$.","N''oublie pas la constante d''intégration $C$ lorsque tu cherches une primitive.","L''aire est donnée par $\\int_a^b f(x) dx$. Fais attention au signe de $f(x)$ sur l''intervalle."]'::jsonb, '2025-10-28T21:26:30.481766+00:00'::timestamptz, 'e88c9340cbc553e32d932af2634e2ec72eab4754ed245dbde8a4203738fc2c1f', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('3329fcde-5c55-4415-932c-a7c9ec631ee5', 'Intégrales', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x+1)e^{x^2+x}$.","questions":["Détermine une primitive $F$ de la fonction $f$ sur $\\mathbb{R}$.","Calcule l''intégrale de $f$ sur l''intervalle $[0, 1]$.","On considère la fonction $g(x) = (x^2+x)e^{x^2+x}$. Calcule l''intégrale de $g''(x)$ sur l''intervalle $[0, 1]$.","Détermine la valeur moyenne de la fonction $f$ sur l''intervalle $[0, 1]$."]}', '1. Détermination d''une primitive $F$ de $f(x) = (2x+1)e^{x^2+x}$ :
La fonction $f(x)$ est de la forme $u''e^u$ avec $u(x) = x^2+x$. Une primitive est donc $F(x) = e^{x^2+x}$.

2. Calcul de l''intégrale de $f$ sur $[0, 1]$ :
$\int_0^1 (2x+1)e^{x^2+x} dx = [e^{x^2+x}]_0^1 = e^{1^2+1} - e^{0^2+0} = e^2 - e^0 = e^2 - 1$.

3. Calcul de l''intégrale de $g''(x)$ sur $[0, 1]$ avec $g(x) = (x^2+x)e^{x^2+x}$ :
$\int_0^1 g''(x) dx = [g(x)]_0^1 = g(1) - g(0)$.
$g(1) = (1^2+1)e^{1^2+1} = 2e^2$.
$g(0) = (0^2+0)e^{0^2+0} = 0e^0 = 0$.
Donc $\int_0^1 g''(x) dx = 2e^2 - 0 = 2e^2$.

4. Détermination de la valeur moyenne de $f$ sur $[0, 1]$ :
La valeur moyenne est $\frac{1}{1-0} \int_0^1 f(x) dx = \int_0^1 f(x) dx$.
D''après la question 2, $\int_0^1 f(x) dx = e^2 - 1$.
Donc la valeur moyenne est $e^2 - 1$.', '["Pense à la forme $(u''e^u)''$ pour trouver une primitive.","La valeur moyenne d''une fonction $f$ sur un intervalle $[a, b]$ est donnée par la formule $\\frac{1}{b-a} \\int_a^b f(x) dx$."]'::jsonb, '2025-10-28T21:27:09.105123+00:00'::timestamptz, '10583e5ecf2aea5b77f8789861f78c8b19c21ddac3b25f7bb25d83b81ca27193', NULL),
('d85e351c-7439-4943-86f1-425152c24932', 'Trigonométrie', 'terminale', '{"contexte":"Soit $x$ un nombre réel.","questions":["Détermine la valeur exacte de $\\cos\\left(\\frac{\\pi}{3}\\right)$ et $\\sin\\left(\\frac{\\pi}{3}\\right)$.","Résous l''équation $\\cos(x) = \\frac{1}{2}$ pour $x \\in [0, 2\\pi]$.","Résous l''équation $\\sin(x) = -\\frac{\\sqrt{3}}{2}$ pour $x \\in [0, 2\\pi]$.","Résous l''équation $2\\cos^2(x) - \\cos(x) - 1 = 0$ pour $x \\in [0, 2\\pi]$. Pour cela, tu peux poser $X = \\cos(x)$.","Démontre l''identité trigonométrique suivante : $(\\cos(x) + \\sin(x))^2 = 1 + 2\\sin(x)\\cos(x)$."]}', '1. Valeurs exactes :
$\cos\left(\frac{\pi}{3}\right) = \frac{1}{2}$
$\sin\left(\frac{\pi}{3}\right) = \frac{\sqrt{3}}{2}$

2. Résolution de $\cos(x) = \frac{1}{2}$ pour $x \in [0, 2\pi]$ :
Les solutions sont $x = \frac{\pi}{3}$ et $x = \frac{5\pi}{3}$.

3. Résolution de $\sin(x) = -\frac{\sqrt{3}}{2}$ pour $x \in [0, 2\pi]$ :
Les solutions sont $x = \frac{4\pi}{3}$ et $x = \frac{5\pi}{3}$.

4. Résolution de $2\cos^2(x) - \cos(x) - 1 = 0$ pour $x \in [0, 2\pi]$ :
Posons $X = \cos(x)$. L''équation devient $2X^2 - X - 1 = 0$.
Le discriminant est $\Delta = (-1)^2 - 4(2)(-1) = 1 + 8 = 9$.
Les solutions pour $X$ sont $X_1 = \frac{1 - \sqrt{9}}{4} = \frac{1 - 3}{4} = -\frac{1}{2}$ et $X_2 = \frac{1 + \sqrt{9}}{4} = \frac{1 + 3}{4} = 1$.

Pour $X = \cos(x) = -\frac{1}{2}$ : Les solutions sont $x = \frac{2\pi}{3}$ et $x = \frac{4\pi}{3}$.
Pour $X = \cos(x) = 1$ : La solution est $x = 0$ (ou $2\pi$, mais on reste sur l''intervalle $[0, 2\pi]$).
Les solutions de l''équation sont donc $x = 0$, $x = \frac{2\pi}{3}$ et $x = \frac{4\pi}{3}$.

5. Démonstration de l''identité trigonométrique :
$(\cos(x) + \sin(x))^2 = \cos^2(x) + 2\cos(x)\sin(x) + \sin^2(x)$
En utilisant l''identité fondamentale $\cos^2(x) + \sin^2(x) = 1$, on obtient :
$(\cos(x) + \sin(x))^2 = 1 + 2\sin(x)\cos(x)$.', '["Pour la première question, pense au cercle trigonométrique et aux valeurs remarquables.","Pour résoudre l''équation avec le cosinus, aide-toi du cercle trigonométrique pour trouver les angles correspondants.","Pour l''équation avec le sinus, visualise les points sur le cercle trigonométrique où le sinus prend cette valeur.","Pour la quatrième question, commence par résoudre l''équation du second degré en $X$.","Pour la dernière question, développe le carré et utilise l''identité fondamentale de la trigonométrie."]'::jsonb, '2025-10-28T21:27:42.401704+00:00'::timestamptz, '8d1d2a90c28e6e8bb20469f38202f23fc615da52399f17214ceb45a691cf4d63', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('268b887e-279e-4aa6-afc5-5fdb98866e34', 'Exercice soumis', 'terminale', 'non j’ai un exercice à faire pour demain, amis je ne sais pas faire la question 2 pour faire Sn, aide-moi', 'En cours de correction', '[]'::jsonb, '2025-10-29T09:44:44.850361+00:00'::timestamptz, NULL, '{}'::jsonb),
('0a5bfaa6-aa3f-40e5-9105-2a5466f1af1f', 'Probabilités', 'terminale', '{"questions":["Identifie clairement l''expérience aléatoire répétée et ses caractéristiques (nombre de répétitions, succès, échec).","Explique pourquoi la variable aléatoire $X$ qui compte le nombre de puces défectueuses dans l''échantillon suit une loi binomiale. Détaille chacune des conditions d''application.","Précise les paramètres $n$ et $p$ de cette loi binomiale."],"contexte":"Un fabricant de puces électroniques produit des lots de puces. On sait que $5\\%$ des puces fabriquées sont défectueuses. Pour contrôler la qualité, on prélève au hasard un échantillon de $20$ puces dans un lot. On considère que le prélèvement est assimilé à un tirage avec remise."}', '1. L''expérience aléatoire répétée est le prélèvement d''une puce électronique et la vérification de son état (défectueuse ou non).
   - Nombre de répétitions : $20$ (puisqu''on prélève $20$ puces).
   - Succès : la puce prélevée est défectueuse.
   - Échec : la puce prélevée n''est pas défectueuse.

2. La variable aléatoire $X$ suit une loi binomiale car :
   - L''expérience est répétée $n=20$ fois de manière identique et indépendante (le prélèvement est assimilé à un tirage avec remise, donc le résultat d''un tirage n''influence pas les suivants).
   - À chaque répétition, il n''y a que deux issues possibles : ''succès'' (la puce est défectueuse) ou ''échec'' (la puce n''est pas défectueuse).
   - La probabilité de succès est constante pour chaque tirage : $p = 0.05$ (5\% des puces sont défectueuses).

3. Les paramètres de cette loi binomiale sont $n=20$ et $p=0.05$.', '["Pour l''expérience répétée, pense à ce qui est fait $n$ fois.","Les conditions d''application d''une loi binomiale sont : répétition identique et indépendante, deux issues possibles (succès/échec), probabilité de succès constante.","Le paramètre $n$ est le nombre de répétitions de l''expérience, et $p$ est la probabilité de succès."]'::jsonb, '2025-10-29T10:34:30.597623+00:00'::timestamptz, '5a88382e0cd847930e7ded932070767075429e5870b80a30a27d12f3fbaf3fa8', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('ecdbc12f-4dd2-4ef4-a8aa-e976f083a534', 'Divisions euclidiennes de polynômes complexes', 'terminale', '{"questions":["Effectue la division euclidienne de $A(z)$ par $B(z)$. Tu devras trouver un quotient $Q(z)$ et un reste $R(z)$.","Vérifie ton résultat en calculant $B(z)Q(z) + R(z)$.","Déduis-en une factorisation de $A(z)$ si $R(z) = 0$."],"contexte":"Soient les polynômes $A(z) = z^3 - (1+i)z^2 + (4+i)z - 4i$ et $B(z) = z - i$."}', 'Pour effectuer la division euclidienne de $A(z) = z^3 - (1+i)z^2 + (4+i)z - 4i$ par $B(z) = z - i$, on peut utiliser la méthode de la division longue ou la méthode de Horner (car $B(z)$ est de la forme $z-a$).

**Méthode de la division longue :**

```
        z^2   - z   + 4
      _________________
z - i | z^3 - (1+i)z^2 + (4+i)z - 4i
      - (z^3 - iz^2)
      _________________
            -z^2 + (4+i)z
          - (-z^2 + iz)
          _________________
                   4z - 4i
                 - (4z - 4i)
                 _____________
                          0
```

Donc, le quotient est $Q(z) = z^2 - z + 4$ et le reste est $R(z) = 0$.

**Vérification :**
$B(z)Q(z) + R(z) = (z - i)(z^2 - z + 4) + 0$
$= z(z^2 - z + 4) - i(z^2 - z + 4)$
$= z^3 - z^2 + 4z - iz^2 + iz - 4i$
$= z^3 - (1+i)z^2 + (4+i)z - 4i$
Ceci correspond bien à $A(z)$.

**Factorisation de $A(z)$ :**
Puisque le reste $R(z) = 0$, $B(z)$ est un facteur de $A(z)$. On peut donc écrire :
$A(z) = (z - i)(z^2 - z + 4)$.

Pour trouver les racines du polynôme $Q(z) = z^2 - z + 4$, on calcule le discriminant $\Delta = b^2 - 4ac = (-1)^2 - 4(1)(4) = 1 - 16 = -15$.
Les racines sont $z = \frac{-b \pm \sqrt{\Delta}}{2a} = \frac{1 \pm \sqrt{-15}}{2} = \frac{1 \pm i\sqrt{15}}{2}$.

Donc, $A(z) = (z - i)\left(z - \frac{1 + i\sqrt{15}}{2}\right)\left(z - \frac{1 - i\sqrt{15}}{2}\right)$.', '["La division euclidienne de polynômes se fait de manière similaire à la division euclidienne des nombres réels, mais avec des coefficients complexes.","N''oublie pas de bien gérer les multiplications et soustractions avec les nombres complexes.","Si le reste est nul, alors $B(z)$ est un facteur de $A(z)$.","Tu peux aussi utiliser la méthode de Horner si tu la maîtrises pour la division par un polynôme de la forme $(z-a)$."]'::jsonb, '2025-10-29T10:35:15.114943+00:00'::timestamptz, '6e52b5b7270e0c86e46afd2161ae8fed470e12c4868ae9972abf9701b8c8f9a2', NULL),
('c20ef607-17ae-4cca-a8f9-76a1a5d6338b', 'Probabilités', 'terminale', '{"questions":["Décris l''épreuve de Bernoulli associée à cette situation, en précisant clairement le succès et sa probabilité.","Explique la notion de répétition indépendante d''épreuves de Bernoulli dans ce contexte précis.","Quel est le nombre de répétitions $n$ de cette épreuve dans l''échantillon ?","En utilisant les informations précédentes, justifie si la variable aléatoire $X$ qui compte le nombre d''ampoules défectueuses dans l''échantillon suit une loi binomiale. Si oui, donne les paramètres $n$ et $p$ de cette loi."],"contexte":"Une usine fabrique des ampoules. On sait que $3\\%$ des ampoules produites sont défectueuses. Pour un contrôle qualité, on prélève au hasard un échantillon de $15$ ampoules de la production. On considère que le prélèvement est assimilé à un tirage avec remise."}', '1. L''épreuve de Bernoulli associée est le prélèvement d''une ampoule. \\nLe succès est \"l''ampoule est défectueuse\". Sa probabilité est $p = 0,03$. \\nL''échec est \"l''ampoule n''est pas défectueuse\". Sa probabilité est $1 - p = 0,97$. \\n\\n2. La notion de répétition indépendante signifie que le résultat du tirage d''une ampoule n''influence pas le résultat du tirage des autres ampoules. Le fait que le prélèvement soit assimilé à un tirage avec remise assure cette indépendance. \\n\\n3. Le nombre de répétitions $n$ de cette épreuve est le nombre d''ampoules prélevées dans l''échantillon, soit $n = 15$. \\n\\n4. La variable aléatoire $X$ suit une loi binomiale car : \\n- On répète $n=15$ fois la même épreuve de Bernoulli (prélèvement d''une ampoule). \\n- Chaque épreuve a deux issues possibles (succès : ampoule défectueuse, échec : ampoule non défectueuse). \\n- La probabilité de succès est constante pour chaque épreuve ($p=0,03$). \\n- Les épreuves sont indépendantes (tirage avec remise). \\n\\nLes paramètres de cette loi binomiale sont $n=15$ et $p=0,03$. On note $X \sim B(15; 0,03)$.', '["Une épreuve de Bernoulli est une expérience aléatoire qui n''a que deux issues possibles : succès ou échec.","Un tirage avec remise garantit l''indépendance des épreuves.","La loi binomiale est adaptée quand on répète un certain nombre de fois une même épreuve de Bernoulli de manière indépendante."]'::jsonb, '2025-10-29T15:58:01.506583+00:00'::timestamptz, 'dc4c66461078778f173870f642e0703eb69cd75de50ed32e0eb0a0922ca5c105', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('91cc0534-3536-4eb7-ae4c-cd52e6c57dd5', 'Probabilités', 'terminale', '{"questions":["Décris l''épreuve de Bernoulli associée à cette situation, en précisant clairement le succès et sa probabilité $p$.","Explique pourquoi la répétition de cette épreuve est indépendante dans ce contexte précis.","Quel est le nombre de répétitions $n$ de cette épreuve dans l''échantillon ?","En utilisant les informations précédentes, justifie rigoureusement si la variable aléatoire $X$ qui compte le nombre de composants défectueux dans l''échantillon suit une loi binomiale. Si oui, donne les paramètres $n$ et $p$ de cette loi."],"contexte":"Une entreprise fabrique des composants électroniques. On sait que $2\\%$ des composants produits sont défectueux. Pour un contrôle qualité, on prélève au hasard un échantillon de $12$ composants de la production. On considère que le prélèvement est assimilé à un tirage avec remise."}', '1. L''épreuve de Bernoulli associée est le test d''un composant prélevé au hasard. Le succès est \"le composant est défectueux\", et sa probabilité est $p = 0,02$.
2. Le prélèvement est assimilé à un tirage avec remise. Cela signifie que le fait qu''un composant soit défectueux ou non n''influence pas le résultat du prélèvement suivant. Les épreuves sont donc indépendantes.
3. Le nombre de répétitions $n$ est la taille de l''échantillon, soit $n = 12$.
4. La variable aléatoire $X$ suit une loi binomiale $\mathcal{B}(n; p)$ si :
    - L''expérience consiste en une répétition de $n$ épreuves identiques et indépendantes.
    - Chaque épreuve n''a que deux issues possibles : succès ou échec.
    - La probabilité de succès $p$ est la même pour chaque épreuve.

Dans notre cas :
    - On répète $12$ fois l''épreuve de Bernoulli (tirage d''un composant).
    - Ces répétitions sont indépendantes (tirage avec remise).
    - Chaque tirage a deux issues : \"composant défectueux\" (succès) ou \"composant non défectueux\" (échec).
    - La probabilité de succès est $p = 0,02$ pour chaque tirage.

Donc, la variable aléatoire $X$ suit bien une loi binomiale de paramètres $n = 12$ et $p = 0,02$.', '["Une épreuve de Bernoulli n''a que deux issues possibles.","L''indépendance est souvent assurée quand un tirage est avec remise ou quand l''échantillon est très petit par rapport à la population totale.","Le nombre de répétitions correspond à la taille de l''échantillon.","Une variable aléatoire suit une loi binomiale si elle compte le nombre de succès dans une séquence de $n$ épreuves de Bernoulli indépendantes et identiques."]'::jsonb, '2025-10-29T15:58:23.17529+00:00'::timestamptz, 'acf6fe31c121749e988f25057d75aa17e99c69e7876dbcfd14929097c3de4120', NULL),
('17b8f19b-5c7d-49ca-9bf0-2c6dabf2ad65', 'Probabilités', 'terminale', '{"questions":["Construis un arbre pondéré qui modélise cette situation. Tu noteras $D$ l''événement ''le jouet est défectueux'' et $R$ l''événement ''le jouet est réparé''.","Calcule la probabilité qu''un jouet soit défectueux et réparé.","Calcule la probabilité qu''un jouet soit mis en vente.","Sachant qu''un jouet est mis en vente, quelle est la probabilité qu''il ait été réparé ?"],"contexte":"Une entreprise fabrique des jouets. Sur la chaîne de production, $10\\%$ des jouets sont défectueux. Chaque jouet défectueux est envoyé au service de réparation. Le service de réparation parvient à réparer $80\\%$ des jouets défectueux. Les jouets non défectueux et les jouets réparés sont mis en vente. Les jouets défectueux non réparés sont mis au rebut."}', '1. Arbre pondéré :

```mermaid
graph TD
    A[Début] --> B{Défectueux ?}
    B -->|0.10| C[D]
    B -->|0.90| D[Non D]
    C -->|0.80| E[R]
    C -->|0.20| F[Non R]
```

2. Probabilité qu''un jouet soit défectueux et réparé :
$P(D \cap R) = P(D) \times P(R|D) = 0,10 \times 0,80 = 0,08$

3. Probabilité qu''un jouet soit mis en vente :
Un jouet est mis en vente s''il n''est pas défectueux (Non D) OU s''il est défectueux ET réparé (D et R).
$P(\text{mis en vente}) = P(\text{Non D}) + P(D \cap R)$
$P(\text{Non D}) = 0,90$
$P(D \cap R) = 0,08$
$P(\text{mis en vente}) = 0,90 + 0,08 = 0,98$

4. Sachant qu''un jouet est mis en vente, probabilité qu''il ait été réparé :
On cherche $P(D \cap R | \text{mis en vente})$.
$P(D \cap R | \text{mis en vente}) = \frac{P((D \cap R) \cap (\text{mis en vente}))}{P(\text{mis en vente})}$
Comme $(D \cap R)$ est une condition pour être mis en vente, $(D \cap R) \cap (\text{mis en vente}) = D \cap R$.
Donc, $P(D \cap R | \text{mis en vente}) = \frac{P(D \cap R)}{P(\text{mis en vente})} = \frac{0,08}{0,98} \approx 0,0816$', '["Pour construire l''arbre, commence par la première étape : le jouet est-il défectueux ou non ?","N''oublie pas que la somme des probabilités des branches partant d''un même nœud doit être égale à 1.","Pour calculer $P(D \\cap R)$, suis le chemin correspondant sur l''arbre.","Un jouet est mis en vente s''il n''est pas défectueux OU s''il est défectueux ET réparé.","La probabilité conditionnelle $P(A|B)$ se calcule avec la formule $P(A|B) = \\frac{P(A \\cap B)}{P(B)}$."]'::jsonb, '2025-10-29T15:58:54.795608+00:00'::timestamptz, 'e43d367cc9b638261338db1b46b0fe02dee97954284d3ee112c67ec3a79582be', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('27454bef-d0bb-402b-800a-546f919d8945', 'Probabilités', 'terminale', '{"contexte":"Une entreprise fabrique des composants électroniques. Deux usines, A et B, produisent ces composants. L''usine A produit $60\\%$ des composants et l''usine B produit $40\\%$. La proportion de composants défectueux est de $3\\%$ pour l''usine A et de $5\\%$ pour l''usine B. Un composant est choisi au hasard dans la production totale.","questions":["Construis un arbre pondéré modélisant cette situation. Tu noteras $A$ l''événement ''le composant provient de l''usine A'', $B$ l''événement ''le composant provient de l''usine B'', et $D$ l''événement ''le composant est défectueux''.","Calcule la probabilité que le composant choisi provienne de l''usine A et soit défectueux.","Calcule la probabilité que le composant choisi soit défectueux.","Sachant que le composant choisi est défectueux, quelle est la probabilité qu''il provienne de l''usine A ? Donne la valeur exacte sous forme de fraction irréductible, puis une valeur approchée à $10^{-4}$ près.","Un lot de $10$ composants est prélevé au hasard dans la production totale. On considère que le prélèvement est assimilé à un tirage avec remise. Soit $X$ la variable aléatoire qui compte le nombre de composants défectueux dans ce lot. Explique pourquoi $X$ suit une loi binomiale et précise ses paramètres.","Calcule la probabilité qu''il y ait exactement $2$ composants défectueux dans ce lot de $10$. Donne le résultat arrondi à $10^{-3}$ près."]}', '1. Arbre pondéré :

```mermaid
graph TD
    A[Production totale] --> B{Usine d''origine ?}
    B -->|0.60| C[Usine A]
    B -->|0.40| D[Usine B]
    C -->|0.03| E[Défectueux (D) de A]
    C -->|0.97| F[Non Défectueux (Non D) de A]
    D -->|0.05| G[Défectueux (D) de B]
    D -->|0.95| H[Non Défectueux (Non D) de B]
```

2. Probabilité que le composant provienne de l''usine A et soit défectueux :
$P(A \cap D) = P(A) \times P(D|A) = 0,60 \times 0,03 = 0,018$

3. Probabilité que le composant soit défectueux :
$P(D) = P(A \cap D) + P(B \cap D)$
$P(B \cap D) = P(B) \times P(D|B) = 0,40 \times 0,05 = 0,020$
$P(D) = 0,018 + 0,020 = 0,038$

4. Sachant que le composant est défectueux, probabilité qu''il provienne de l''usine A :
$P(A|D) = \frac{P(A \cap D)}{P(D)} = \frac{0,018}{0,038} = \frac{18}{38} = \frac{9}{19}$
Valeur approchée à $10^{-4}$ près : $\frac{9}{19} \approx 0,4737$

5. La variable aléatoire $X$ suit une loi binomiale car :
   - L''expérience est la répétition de $n=10$ épreuves identiques et indépendantes (prélèvement avec remise).
   - Chaque épreuve a deux issues possibles : succès (le composant est défectueux) ou échec (le composant n''est pas défectueux).
   - La probabilité de succès $p$ (le composant est défectueux) est constante pour chaque épreuve. D''après la question 3, $p = P(D) = 0,038$.
Les paramètres de cette loi binomiale sont donc $n=10$ et $p=0,038$.

6. Probabilité qu''il y ait exactement $2$ composants défectueux dans ce lot de $10$ :
$P(X=2) = \binom{10}{2} (0,038)^2 (1-0,038)^{10-2}$
$P(X=2) = \frac{10!}{2!(10-2)!} \times (0,038)^2 \times (0,962)^8$
$P(X=2) = 45 \times 0,001444 \times 0,72465 \approx 0,047$
Le résultat arrondi à $10^{-3}$ près est $0,047$.', '["Commence par représenter les usines et leurs proportions, puis les taux de défectuosité pour chaque usine.","Utilise la formule des probabilités totales pour trouver la probabilité d''un événement qui peut se produire de plusieurs manières.","La formule de Bayes te sera utile pour la probabilité conditionnelle inverse.","Pour la loi binomiale, pense aux trois conditions essentielles : répétition d''épreuves identiques et indépendantes, deux issues possibles (succès/échec), et probabilité de succès constante.","La formule de la loi binomiale est $P(X=k) = \\binom{n}{k} p^k (1-p)^{n-k}$."]'::jsonb, '2025-10-29T16:02:49.176842+00:00'::timestamptz, '897feaea1c0c9baea993262cf408953f910cbf03cd53e3e979b83e7b22762c2e', NULL),
('3cf08fb1-da67-4c32-b4c8-47c070ab44bc', 'Probabilités', 'terminale', '{"contexte":"Dans une usine, une machine fabrique des pièces. La probabilité qu''une pièce soit défectueuse est de $p = 0,02$. On prélève au hasard et avec remise $15$ pièces de la production.","questions":["Soit $X$ la variable aléatoire qui compte le nombre de pièces défectueuses parmi les $15$ prélevées. Explique en détail pourquoi $X$ suit une loi binomiale.","Précise les paramètres de cette loi binomiale.","Si on changeait le mode de prélèvement pour un tirage sans remise dans un lot de $100$ pièces, $X$ suivrait-elle toujours une loi binomiale ? Justifie ta réponse."]}', '1. Pour qu''une variable aléatoire $X$ suive une loi binomiale, trois conditions doivent être remplies :
   - **Répétition d''expériences identiques et indépendantes** : Ici, on prélève $15$ pièces. Chaque prélèvement d''une pièce est une expérience. Puisque le prélèvement est "avec remise", le résultat d''un prélèvement n''influence pas le suivant. Les $15$ expériences sont donc identiques et indépendantes.
   - **Deux issues possibles par expérience** : Pour chaque pièce prélevée, il y a deux issues possibles : soit la pièce est défectueuse (succès), soit elle n''est pas défectueuse (échec).
   - **Probabilité de succès constante** : La probabilité qu''une pièce soit défectueuse est donnée comme $p = 0,02$. Comme le tirage est avec remise, cette probabilité reste constante pour chacune des $15$ pièces prélevées.

2. Les paramètres de cette loi binomiale sont :
   - $n$ (nombre de répétitions) : $n = 15$ (nombre de pièces prélevées).
   - $p$ (probabilité de succès) : $p = 0,02$ (probabilité qu''une pièce soit défectueuse).
   On note $X \sim B(15 ; 0,02)$.

3. Si le tirage était sans remise dans un lot de $100$ pièces, $X$ ne suivrait plus une loi binomiale. La raison est que la probabilité de succès (obtenir une pièce défectueuse) ne resterait pas constante à chaque tirage. En effet, si on retire une pièce défectueuse du lot, la proportion de pièces défectueuses restantes dans le lot change, et donc la probabilité d''en tirer une autre au tirage suivant est modifiée. Les épreuves ne seraient plus indépendantes.', '["Pense aux trois conditions fondamentales pour qu''une variable aléatoire suive une loi binomiale.","Pour la question sur le tirage sans remise, réfléchis à l''impact de ce type de tirage sur la probabilité de succès à chaque essai."]'::jsonb, '2025-10-29T16:10:33.252933+00:00'::timestamptz, 'f314858db53699b2dc26cf4faaea316ebbc10fb38b8e2e6d7dce733ef5b55a9d', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('0b7ca9e8-28b9-4ff2-adff-6d15a9e7c94f', 'Exercice soumis', 'terminale', 'J’ai un peu de mal avec les vecteurs etc peux tu me faire les exercices 1 à 3 en mettant bien en avant la méthode pour que je comprenne ', 'En cours de correction', '[]'::jsonb, '2025-10-29T16:14:32.599935+00:00'::timestamptz, NULL, '{}'::jsonb),
('ded94197-bb50-499f-a1bb-3533bc1f364a', 'Exercice soumis', 'terminale', 'calcule l''integrale de 0 à 1 de 2xarsin(x) , avec changement de variable et en m''expliquant', 'En cours de correction', '[]'::jsonb, '2025-10-29T17:11:09.319102+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('eac4b7ea-5b3f-4fcb-867d-8defd24bc519', 'Exercice soumis', 'terminale', 'Tu peux m’aider à résoudre cet exercice', 'En cours de correction', '[]'::jsonb, '2025-10-29T19:37:35.422516+00:00'::timestamptz, NULL, '{}'::jsonb),
('618f8257-f173-4d6b-90ef-22f488301e74', 'Exercice soumis', 'terminale', 'Tu peux me corriger la question 1 de l’exo 3', 'En cours de correction', '[]'::jsonb, '2025-10-30T08:04:10.359683+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('0d68435b-aedb-4359-8fb9-79a4f70ce861', 'Exercice soumis', 'terminale', 'On va faire l’exercice 2', 'En cours de correction', '[]'::jsonb, '2025-10-30T11:20:06.664823+00:00'::timestamptz, NULL, '{}'::jsonb),
('77c54ce1-478e-4a11-87b5-0a901d0cf6ca', 'Exercice soumis', 'terminale', 'on va faire l''exercice 9', 'En cours de correction', '[]'::jsonb, '2025-10-31T09:56:41.412747+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('fb5f2ef7-ec9d-4ee4-b5c2-fac2fb74216f', 'Exercice soumis', 'terminale', 'On va faire l’exercice 8 je t’ai envoyé l’énoncé ', 'En cours de correction', '[]'::jsonb, '2025-10-31T11:04:50.671085+00:00'::timestamptz, NULL, '{}'::jsonb),
('6b1ac83a-ea9f-4c7d-a70e-c0cc17b1bd44', 'Systèmes d''équations linéaires', 'Lycée', '{"contexte":"Résous le système d''équations linéaires suivant :","questions":["Détermine les valeurs de $x$, $y$ et $z$ qui vérifient les trois équations simultanément :","$$ \\begin{cases} 2x - y + 3z = 9 \\\\ x + 2y - z = 2 \\\\ 3x + y + 2z = 11 \\end{cases} $$"]}', 'Pour résoudre ce système, nous allons utiliser la méthode par substitution ou par combinaisons linéaires.

### Méthode par substitution :

Reprenons le système :
$$ \begin{cases} (1) \quad 2x - y + 3z = 9 \\ (2) \quad x + 2y - z = 2 \\ (3) \quad 3x + y + 2z = 11 \end{cases} $$

À partir de l''équation (2), exprimons $z$ en fonction de $x$ et $y$ :
$z = x + 2y - 2$

Substituons cette expression de $z$ dans les équations (1) et (3) :

**(1)** $2x - y + 3(x + 2y - 2) = 9$
$2x - y + 3x + 6y - 6 = 9$
$5x + 5y = 15$
Divisons par 5 : $x + y = 3 \quad (4)$

**(3)** $3x + y + 2(x + 2y - 2) = 11$
$3x + y + 2x + 4y - 4 = 11$
$5x + 5y = 15$
Divisons par 5 : $x + y = 3 \quad (5)$

Nous obtenons deux fois la même équation, ce qui signifie que le système original a une infinité de solutions si les équations sont dépendantes, ou qu''il y a une erreur si ce n''est pas le cas. Vérifions les étapes.

Ah, il semble y avoir une erreur dans l''exemple de solution fournie, car les équations (4) et (5) sont identiques. Cela signifie qu''il y a une dépendance linéaire entre les équations. Revoyons les calculs.

Reprenons avec une autre approche pour s''assurer du résultat.

### Méthode par combinaisons linéaires :

$$ \begin{cases} (1) \quad 2x - y + 3z = 9 \\ (2) \quad x + 2y - z = 2 \\ (3) \quad 3x + y + 2z = 11 \end{cases} $$

Multiplions l''équation (1) par 2 et ajoutons-la à l''équation (2) :
$2 \times (1) \implies 4x - 2y + 6z = 18$
$(4x - 2y + 6z) + (x + 2y - z) = 18 + 2$
$5x + 5z = 20 \quad (A)$

Ajoutons l''équation (1) et l''équation (3) :
$(2x - y + 3z) + (3x + y + 2z) = 9 + 11$
$5x + 5z = 20 \quad (B)$

Nous obtenons encore deux fois la même équation $5x + 5z = 20$, ou $x + z = 4$. Cela confirme qu''il y a une dépendance linéaire. Cela signifie que le système n''a pas une solution unique. Il y a en réalité une infinité de solutions.

Pour trouver l''ensemble des solutions, exprimons $z$ en fonction de $x$ à partir de $x + z = 4 \implies z = 4 - x$.

Substituons $z$ dans l''équation (2) : 
$x + 2y - (4 - x) = 2$
$x + 2y - 4 + x = 2$
$2x + 2y = 6$
$x + y = 3 \implies y = 3 - x$

Donc, les solutions sont de la forme $(x, 3-x, 4-x)$ pour tout $x \in \mathbb{R}$.

Vérifions ces solutions dans les équations d''origine :

**(1)** $2x - (3-x) + 3(4-x) = 2x - 3 + x + 12 - 3x = (2+1-3)x + (-3+12) = 0x + 9 = 9$. (Vérifié)

**(2)** $x + 2(3-x) - (4-x) = x + 6 - 2x - 4 + x = (1-2+1)x + (6-4) = 0x + 2 = 2$. (Vérifié)

**(3)** $3x + (3-x) + 2(4-x) = 3x + 3 - x + 8 - 2x = (3-1-2)x + (3+8) = 0x + 11 = 11$. (Vérifié)

L''ensemble des solutions est donc $S = \{(x, 3-x, 4-x) \mid x \in \mathbb{R} \}$.', '["Tu peux commencer par exprimer une variable en fonction des autres à partir d''une des équations.","Substitue ensuite cette expression dans les deux autres équations pour obtenir un système 2x2.","Une fois que tu as un système 2x2, résous-le comme tu en as l''habitude.","N''oublie pas de vérifier tes solutions dans les équations d''origine."]'::jsonb, '2025-11-02T09:20:54.439096+00:00'::timestamptz, 'b4c95aa0a9235e86c2a58f2a37c06f4be490392a0dfc281d44bcddc38b42d586', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('8b6bb29b-b9d2-4be4-a389-a7c5eab6da71', 'Systèmes d''équations linéaires', 'Lycée', '{"contexte":"Résous le système d''équations linéaires suivant :","questions":["$$\\begin{cases} 2x - y + 3z = 9 \\\\ x + 2y - z = 1 \\\\ 3x + y + 2z = 10 \\end{cases}$$"]}', 'Nous allons résoudre le système par la méthode d''élimination.

$$\begin{cases} 2x - y + 3z = 9 \quad (L_1) \\ x + 2y - z = 1 \quad (L_2) \\ 3x + y + 2z = 10 \quad (L_3) \end{cases}$$

Étape 1 : Éliminer $z$ des équations $(L_1)$ et $(L_2)$.
Multiplions $(L_2)$ par 3 : $3(x + 2y - z) = 3(1) \implies 3x + 6y - 3z = 3 \quad (L_2'')$
Ajoutons $(L_1)$ et $(L_2'')$ :
$(2x - y + 3z) + (3x + 6y - 3z) = 9 + 3$
$5x + 5y = 12 \quad (L_4)$

Étape 2 : Éliminer $z$ des équations $(L_2)$ et $(L_3)$.
Multiplions $(L_2)$ par 2 : $2(x + 2y - z) = 2(1) \implies 2x + 4y - 2z = 2 \quad (L_2'''')$
Ajoutons $(L_3)$ et $(L_2'''')$ :
$(3x + y + 2z) + (2x + 4y - 2z) = 10 + 2$
$5x + 5y = 12 \quad (L_5)$

Nous obtenons le système réduit :
$$\begin{cases} 5x + 5y = 12 \quad (L_4) \\ 5x + 5y = 12 \quad (L_5) \end{cases}$$

Les équations $(L_4)$ et $(L_5)$ sont identiques. Cela signifie que le système a une infinité de solutions. Il s''agit d''un cas de figure où le système n''est pas de Cramer.

Exprimons $y$ en fonction de $x$ à partir de $5x + 5y = 12$ :
$5y = 12 - 5x$
$y = \frac{12 - 5x}{5} = \frac{12}{5} - x$

Substituons $y$ dans $(L_2)$ pour trouver $z$ en fonction de $x$ :
$x + 2y - z = 1$
$x + 2(\frac{12}{5} - x) - z = 1$
$x + \frac{24}{5} - 2x - z = 1$
$-x + \frac{24}{5} - z = 1$
$-z = 1 + x - \frac{24}{5}$
$-z = \frac{5 + 5x - 24}{5}$
$-z = \frac{5x - 19}{5}$
$z = \frac{19 - 5x}{5}$

L''ensemble des solutions est donné par les triplets $(x, y, z)$ avec :
$y = \frac{12}{5} - x$
$z = \frac{19}{5} - x$
où $x$ est un nombre réel quelconque.

Vérifions avec $x=1$ :
$y = \frac{12}{5} - 1 = \frac{7}{5}$
$z = \frac{19}{5} - 1 = \frac{14}{5}$

$(L_1) : 2(1) - \frac{7}{5} + 3(\frac{14}{5}) = 2 - \frac{7}{5} + \frac{42}{5} = \frac{10 - 7 + 42}{5} = \frac{45}{5} = 9$ (correct)
$(L_2) : 1 + 2(\frac{7}{5}) - \frac{14}{5} = 1 + \frac{14}{5} - \frac{14}{5} = 1$ (correct)
$(L_3) : 3(1) + \frac{7}{5} + 2(\frac{14}{5}) = 3 + \frac{7}{5} + \frac{28}{5} = \frac{15 + 7 + 28}{5} = \frac{50}{5} = 10$ (correct)

La solution est donc $(x, \frac{12}{5} - x, \frac{19}{5} - x)$ pour tout $x \in \mathbb{R}$.', '["Commence par éliminer une variable dans deux des équations.","Par exemple, tu peux multiplier la deuxième équation par 3 et l''ajouter à la première pour éliminer $z$.","Ensuite, tu auras un système $2 \\times 2$ à résoudre."]'::jsonb, '2025-11-02T09:23:37.467486+00:00'::timestamptz, '34c77b9d65cd6d81c651c10133a409e581141bb741dda1c4cb569f833cbab34f', NULL),
('b6786bbd-c581-4850-9b17-9c2efd25340d', 'Probabilités', 'terminale', '{"questions":["Justifie si la situation peut être modélisée par une loi binomiale. Si oui, précise ses paramètres $n$ et $p$.","Quels sont les trois critères essentiels pour qu''une expérience aléatoire suive une loi binomiale ?"],"contexte":"Un fabricant de composants électroniques produit des puces. On sait que $5\\%$ des puces produites sont défectueuses. Pour un contrôle qualité, on prélève au hasard et avec remise un échantillon de $20$ puces."}', '1. Pour qu''une situation puisse être modélisée par une loi binomiale, trois conditions doivent être remplies :
   - **Répétition d''épreuves identiques et indépendantes :** Ici, on prélève $20$ puces. Les prélèvements sont effectués ''avec remise'', ce qui garantit l''indépendance des épreuves et que la probabilité de défectuosité reste constante pour chaque puce.
   - **Deux issues possibles par épreuve :** Pour chaque puce prélevée, il y a deux issues possibles : ''la puce est défectueuse'' (succès) ou ''la puce n''est pas défectueuse'' (échec).
   - **Probabilité de succès constante :** La probabilité qu''une puce soit défectueuse est de $5\%$, soit $p = 0,05$. Cette probabilité est constante pour chaque prélèvement.

   Les trois conditions sont remplies, donc la situation peut être modélisée par une loi binomiale. Ses paramètres sont :
   - $n = 20$ (nombre de répétitions de l''expérience)
   - $p = 0,05$ (probabilité de succès, c''est-à-dire la probabilité qu''une puce soit défectueuse)

2. Les trois critères essentiels pour qu''une expérience aléatoire suive une loi binomiale sont :
   - L''expérience est une répétition de $n$ épreuves identiques et indépendantes.
   - Chaque épreuve n''a que deux issues possibles : un ''succès'' ou un ''échec''.
   - La probabilité de succès $p$ est la même à chaque épreuve.', '["Réfléchis aux conditions de répétition des épreuves.","Pense à la nature des issues de chaque épreuve.","La probabilité de succès doit être constante.","Les tirages sont effectués ''avec remise''."]'::jsonb, '2025-11-02T09:24:33.58829+00:00'::timestamptz, 'f0573792d411946e5dcffd2e5125dec2502fad33660b80fb38b0a5c1dab45586', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('dbfb7851-a77f-4fe7-9bd5-ca4ec05977ff', 'Systèmes d''équations linéaires', 'terminale', '{"questions":["$$\\begin{cases} x + 2y - z = 5 \\\\ 2x - y + 3z = 0 \\\\ 3x + y + 2z = 3 \\end{cases}$$"],"contexte":"Résous le système d''équations linéaires suivant :"}', 'De l''équation (1), $z = x + 2y - 5$.
Substituons $z$ dans l''équation (2) :
$2x - y + 3(x + 2y - 5) = 0$
$2x - y + 3x + 6y - 15 = 0$
$5x + 5y = 15$
$x + y = 3$ (Équation 4)

Substituons $z$ dans l''équation (3) :
$3x + y + 2(x + 2y - 5) = 3$
$3x + y + 2x + 4y - 10 = 3$
$5x + 5y = 13$ (Équation 5)

Nous avons maintenant un système 2x2 avec les équations (4) et (5) :
$\begin{cases} x + y = 3 \\ 5x + 5y = 13 \end{cases}$

De l''équation (4), $y = 3 - x$. Substituons dans l''équation (5) :
$5x + 5(3 - x) = 13$
$5x + 15 - 5x = 13$
$15 = 13$

Ceci est une contradiction. Le système n''a pas de solution. Il est incompatible.', '["Tu peux commencer par éliminer une variable dans deux des équations pour obtenir un système 2x2. Par exemple, essaie d''éliminer $z$ des deux premières équations.","Une fois le système 2x2 obtenu, résous-le pour trouver les valeurs de deux variables.","Substitue les valeurs trouvées dans l''une des équations originales pour trouver la troisième variable.","N''oublie pas de vérifier ta solution en la remplaçant dans les trois équations de départ."]'::jsonb, '2025-11-02T09:25:07.768015+00:00'::timestamptz, '69cbbf3083ed320758ef1abf4364cc57770247833b30dd8a47192bf071ae3c8b', NULL),
('99a42e8a-63e2-4d53-a935-70a1ff566197', 'Exercice soumis', 'terminale', 'Exercice soumis via image', 'En cours de correction', '[]'::jsonb, '2025-11-02T09:28:56.704818+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('90ea4f40-f74b-4046-832a-07ff92f89630', 'Exercice soumis', 'terminale', 'On considère le cube ABCDEFGH et les points P et Q définis par CP est égal à 2 tiers de CG et EQ est égal à 3 demi de EG. Montrez que les vecteurs AC, EH et QC forment une base de l''espace.', 'En cours de correction', '[]'::jsonb, '2025-11-02T09:42:25.01437+00:00'::timestamptz, NULL, '{}'::jsonb),
('ca141780-f05e-467d-ae4f-13372ab5e353', 'Systèmes d''équations linéaires', 'terminale', '{"questions":["Résous le système d''équations suivant par la méthode de substitution : \n$$ \\begin{cases} 2x + y = 7 \\\\ x - 3y = 0 \\end{cases} $$","Vérifie ta solution en remplaçant les valeurs de $x$ et $y$ dans les deux équations du système."],"contexte":"On considère le système d''équations linéaires suivant :"}', '1. Résolution par substitution :
De la première équation $2x + y = 7$, on peut exprimer $y$ en fonction de $x$ : $y = 7 - 2x$.

Substituons cette expression de $y$ dans la deuxième équation $x - 3y = 0$ :
$x - 3(7 - 2x) = 0$
$x - 21 + 6x = 0$
$7x - 21 = 0$
$7x = 21$
$x = \frac{21}{7}$
$x = 3$

Maintenant, substituons la valeur de $x = 3$ dans l''expression de $y = 7 - 2x$ :
$y = 7 - 2(3)$
$y = 7 - 6$
$y = 1$

La solution du système est donc $x = 3$ et $y = 1$.

2. Vérification de la solution :
Pour la première équation : $2x + y = 2(3) + 1 = 6 + 1 = 7$. L''équation est vérifiée.
Pour la deuxième équation : $x - 3y = 3 - 3(1) = 3 - 3 = 0$. L''équation est vérifiée.
La solution est correcte.', '["Exprime $y$ en fonction de $x$ à partir de la première équation.","Substitue cette expression de $y$ dans la deuxième équation.","Résous l''équation résultante pour trouver la valeur de $x$.","Utilise la valeur de $x$ trouvée pour calculer $y$."]'::jsonb, '2025-11-02T10:16:07.192263+00:00'::timestamptz, 'f85927c803bceb86dcc2ef9c85514aabb7d8200967dca7c3634cdaba7a439f2a', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('21fce65b-e264-47f9-a6d9-3cddcdf27e85', 'Exercice soumis', 'terminale', 'A, B, C un triangle quelconque, A'' le milieu de BC, G le centre de gravité du triangle, D et E les points tels que CD est égal à un tiers de AB, BE est égal à un tiers de AC, on note I le milieu de DE, exprimez AA'' en fonction de AB et AC, démontrez que les points A, A'' et I sont alignés, démontrez que le point G est le milieu de I, prouvez que le droit BC et ED sont parallèles.', 'En cours de correction', '[]'::jsonb, '2025-11-02T10:23:30.699104+00:00'::timestamptz, NULL, '{}'::jsonb),
('a3404227-d57f-47e2-80dc-ba9a3b1bd128', 'Exercice soumis', 'terminale', 'Dans un tetraède ABCD, on note E et F, milieux respectives de AB et AC, et on construit les points M et N tels que CM est égal à 1/2 de BC et AN est égal à DE. Déterminez la nature de MCEF et ADEN. On va démontrer que MCEF est un parallélogramme en montrant que vecteur EF = vecteur CM mais dans la correction il y a écrit EF = 1/2 de BA + 1/2 de AC et je comprends pas explique moi', 'En cours de correction', '[]'::jsonb, '2025-11-02T11:10:42.939171+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('7b7f855c-7eeb-4bdd-88eb-5325c17715e7', 'Probabilités', 'terminale', '{"contexte":"On considère une expérience aléatoire où l''on répète $n$ fois de manière indépendante une épreuve de Bernoulli. Chaque épreuve de Bernoulli a deux issues possibles : un succès $S$ avec une probabilité $p$ et un échec $\\bar{S}$ avec une probabilité $1-p$. Soit $X$ la variable aléatoire qui compte le nombre de succès obtenus au cours de ces $n$ répétitions.","questions":["Quelles sont les quatre conditions nécessaires pour qu''une variable aléatoire suive une loi binomiale $B(n, p)$ ?","Pour chacune des situations suivantes, indique si la variable aléatoire $X$ suit une loi binomiale. Justifie ta réponse en expliquant pourquoi chaque condition est (ou n''est pas) remplie :","Situation 1 : On lance un dé équilibré 5 fois de suite. $X$ est le nombre de fois où l''on obtient un 6.","Situation 2 : On tire 3 cartes d''un jeu de 32 cartes sans remise. $X$ est le nombre d''as obtenus.","Situation 3 : On interroge 100 personnes choisies au hasard dans une grande ville pour savoir si elles utilisent les transports en commun. On estime que 30% des habitants de cette ville utilisent les transports en commun. $X$ est le nombre de personnes ayant déclaré utiliser les transports en commun parmi les 100 interrogées.","Situation 4 : On lance une pièce de monnaie truquée 4 fois. La probabilité d''obtenir Face est de 0,6 au premier lancer, puis de 0,5 au deuxième, 0,7 au troisième et 0,4 au quatrième. $X$ est le nombre de Faces obtenues."]}', 'Une variable aléatoire $X$ suit une loi binomiale $B(n, p)$ si et seulement si :
1. L''expérience est une répétition de $n$ épreuves identiques et indépendantes.
2. Chaque épreuve est une épreuve de Bernoulli, c''est-à-dire qu''elle n''a que deux issues possibles : succès ou échec.
3. La probabilité de succès $p$ est la même pour chaque épreuve.
4. $X$ compte le nombre de succès obtenus sur les $n$ épreuves.

Situation 1 : Lancers de dé
1. Répétition de 5 épreuves identiques (lancer un dé) et indépendantes.
2. Chaque lancer est une épreuve de Bernoulli (succès : obtenir un 6 ; échec : ne pas obtenir un 6).
3. La probabilité de succès est $p = \frac{1}{6}$ pour chaque lancer.
4. $X$ compte le nombre de 6 obtenus.
Conclusion : $X$ suit une loi binomiale $B(5, \frac{1}{6})$.

Situation 2 : Tirage de cartes sans remise
1. Répétition de 3 épreuves (tirer une carte).
2. Chaque tirage est une épreuve de Bernoulli (succès : obtenir un as ; échec : ne pas obtenir un as).
3. La probabilité de succès n''est PAS la même pour chaque épreuve car les tirages se font SANS REMISE. La composition du jeu change après chaque tirage.
Conclusion : $X$ ne suit PAS une loi binomiale.

Situation 3 : Sondage
1. Répétition de 100 épreuves (interroger une personne). Les choix sont considérés comme indépendants car la population est grande.
2. Chaque interrogation est une épreuve de Bernoulli (succès : la personne utilise les transports en commun ; échec : la personne ne les utilise pas).
3. La probabilité de succès est $p = 0,3$ (30%) pour chaque personne interrogée.
4. $X$ compte le nombre de personnes utilisant les transports en commun.
Conclusion : $X$ suit une loi binomiale $B(100, 0,3)$.

Situation 4 : Pièce truquée
1. Répétition de 4 épreuves (lancer une pièce).
2. Chaque lancer est une épreuve de Bernoulli (succès : obtenir Face ; échec : obtenir Pile).
3. La probabilité de succès n''est PAS la même pour chaque épreuve (0,6, 0,5, 0,7, 0,4).
Conclusion : $X$ ne suit PAS une loi binomiale.', '["Réfléchis aux caractéristiques d''une épreuve de Bernoulli.","Pense à l''indépendance des répétitions et à la probabilité de succès.","Pour la situation 2, la remise est-elle importante ?","Pour la situation 4, la probabilité de succès est-elle constante ?"]'::jsonb, '2025-11-02T12:36:01.321221+00:00'::timestamptz, 'a744125b0d8899ec40097201c72cdfa7b7c9bcf018d4afb47d3e5f0a4bcc0bf8', NULL),
('8cd7bf28-15cf-46d9-8897-4fc5da006d06', 'Trigonométrie', 'terminale', '{"questions":["Détermine toutes les valeurs de $x$ dans l''intervalle $[0, 2\\pi[$ telles que $\\cos(x) = -\\frac{\\sqrt{3}}{2}$.","Détermine toutes les valeurs de $x$ dans l''intervalle $[0, 2\\pi[$ telles que $\\sin(x) = \\frac{1}{2}$.","Résous l''équation $2\\cos(x) - \\sqrt{3}\\sin(x) = \\frac{1}{2}$ pour $x \\in [0, 2\\pi[$. Tu pourras utiliser la transformation $a\\cos(x) + b\\sin(x) = R\\cos(x-\\alpha)$ où $R = \\sqrt{a^2+b^2}$ et $\\cos(\\alpha) = \\frac{a}{R}$, $\\sin(\\alpha) = \\frac{b}{R}$.","Détermine la valeur exacte de $\\cos\\left(\\frac{7\\pi}{12}\\right)$ et $\\sin\\left(\\frac{7\\pi}{12}\\right)$ en utilisant les formules d''addition."],"contexte":"Soit $x$ un nombre réel et le cercle trigonométrique associé. On considère également la fonction $f(x) = 2\\cos(x) - \\sqrt{3}\\sin(x)$."}', '1. Pour $\cos(x) = -\frac{\sqrt{3}}{2}$ dans $[0, 2\pi[$, les solutions sont $x = \frac{5\pi}{6}$ et $x = \frac{7\pi}{6}$.

2. Pour $\sin(x) = \frac{1}{2}$ dans $[0, 2\pi[$, les solutions sont $x = \frac{\pi}{6}$ et $x = \frac{5\pi}{6}$.

3. Pour $2\cos(x) - \sqrt{3}\sin(x) = \frac{1}{2}$ :
   $a=2$, $b=-\sqrt{3}$.
   $R = \sqrt{2^2 + (-\sqrt{3})^2} = \sqrt{4+3} = \sqrt{7}$.
   $\cos(\alpha) = \frac{2}{\sqrt{7}}$ et $\sin(\alpha) = -\frac{\sqrt{3}}{\sqrt{7}}$.
   L''équation devient $\sqrt{7}\cos(x-\alpha) = \frac{1}{2}$, soit $\cos(x-\alpha) = \frac{1}{2\sqrt{7}}$.
   Soit $\beta = \arccos\left(\frac{1}{2\sqrt{7}}\right)$.
   Alors $x-\alpha = \beta + 2k\pi$ ou $x-\alpha = -\beta + 2k\pi$.
   Donc $x = \alpha + \beta + 2k\pi$ ou $x = \alpha - \beta + 2k\pi$.
   Il faut ensuite trouver les valeurs dans l''intervalle $[0, 2\pi[$.

4. Pour $\cos\left(\frac{7\pi}{12}\right)$ et $\sin\left(\frac{7\pi}{12}\right)$ :
   On utilise $\frac{7\pi}{12} = \frac{\pi}{4} + \frac{\pi}{3}$.
   $\cos\left(\frac{7\pi}{12}\right) = \cos\left(\frac{\pi}{4} + \frac{\pi}{3}\right) = \cos\left(\frac{\pi}{4}\right)\cos\left(\frac{\pi}{3}\right) - \sin\left(\frac{\pi}{4}\right)\sin\left(\frac{\pi}{3}\right)$
   $= \frac{\sqrt{2}}{2} \times \frac{1}{2} - \frac{\sqrt{2}}{2} \times \frac{\sqrt{3}}{2} = \frac{\sqrt{2} - \sqrt{6}}{4}$.
   $\sin\left(\frac{7\pi}{12}\right) = \sin\left(\frac{\pi}{4} + \frac{\pi}{3}\right) = \sin\left(\frac{\pi}{4}\right)\cos\left(\frac{\pi}{3}\right) + \cos\left(\frac{\pi}{4}\right)\sin\left(\frac{\pi}{3}\right)$
   $= \frac{\sqrt{2}}{2} \times \frac{1}{2} + \frac{\sqrt{2}}{2} \times \frac{\sqrt{3}}{2} = \frac{\sqrt{2} + \sqrt{6}}{4}$.', '["Pour la première question, pense au cercle trigonométrique et aux angles de référence.","Pour la deuxième question, utilise également le cercle trigonométrique.","Pour la troisième question, commence par calculer $R$ et $\\alpha$. Ensuite, résous l''équation en $\\cos(x-\\alpha)$.","Pour la quatrième question, rappelle-toi que $\\frac{7\\pi}{12} = \\frac{3\\pi}{12} + \\frac{4\\pi}{12} = \\frac{\\pi}{4} + \\frac{\\pi}{3}$."]'::jsonb, '2025-11-02T12:36:26.778532+00:00'::timestamptz, '71141e48f8a4645f5ddc6271517c30ebf2488ddf60a573539719610a8b9731b6', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('63e26f8e-6961-413b-b163-4314859935f2', 'Fonctions trigonométriques', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = \\cos(2x) - 2\\cos(x)$.","questions":["Détermine la parité de la fonction $f$.","Démontre que la fonction $f$ est $2\\pi$-périodique.","Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur l''intervalle $[0; \\pi]$ et déduis-en le tableau de variations de $f$ sur cet intervalle."]}', '**1. Parité de la fonction $f$**

Pour tout $x \in \mathbb{R}$, $f(-x) = \cos(2(-x)) - 2\cos(-x) = \cos(-2x) - 2\cos(x)$.
Comme la fonction cosinus est paire, $\cos(-X) = \cos(X)$.
Donc $f(-x) = \cos(2x) - 2\cos(x) = f(x)$.
La fonction $f$ est donc une fonction paire.

**2. Périodicité de la fonction $f$**

Pour tout $x \in \mathbb{R}$, $f(x+2\pi) = \cos(2(x+2\pi)) - 2\cos(x+2\pi)$.
$f(x+2\pi) = \cos(2x+4\pi) - 2\cos(x+2\pi)$.
Comme la fonction cosinus est $2\pi$-périodique, $\cos(X+2k\pi) = \cos(X)$ pour tout $k \in \mathbb{Z}$.
Donc $\cos(2x+4\pi) = \cos(2x)$ et $\cos(x+2\pi) = \cos(x)$.
Par conséquent, $f(x+2\pi) = \cos(2x) - 2\cos(x) = f(x)$.
La fonction $f$ est $2\pi$-périodique.

**3. Calcul de la dérivée $f''(x)$**

La fonction $f$ est dérivable sur $\mathbb{R}$ comme somme et composée de fonctions dérivables.
$f(x) = \cos(2x) - 2\cos(x)$.
La dérivée de $\cos(u(x))$ est $-u''(x)\sin(u(x))$.
La dérivée de $\cos(x)$ est $-\sin(x)$.
$f''(x) = -2\sin(2x) - 2(-\sin(x))$.
$f''(x) = -2\sin(2x) + 2\sin(x)$.

**4. Étude du signe de $f''(x)$ sur $[0; \pi]$ et tableau de variations**

On a $f''(x) = -2\sin(2x) + 2\sin(x)$.
On utilise la formule de duplication $\sin(2x) = 2\sin(x)\cos(x)$.
$f''(x) = -2(2\sin(x)\cos(x)) + 2\sin(x)$.
$f''(x) = -4\sin(x)\cos(x) + 2\sin(x)$.
$f''(x) = 2\sin(x)(-2\cos(x) + 1)$.

Sur l''intervalle $[0; \pi]$ :
- $\sin(x) \ge 0$ pour $x \in [0; \pi]$. $\sin(x) = 0$ si $x=0$ ou $x=\pi$.
- Le signe de $f''(x)$ est donc déterminé par le signe de $(-2\cos(x) + 1)$.

Étudions le signe de $-2\cos(x) + 1$ :
$-2\cos(x) + 1 > 0 \iff 1 > 2\cos(x) \iff \cos(x) < \frac{1}{2}$.
Sur l''intervalle $[0; \pi]$, $\cos(x) < \frac{1}{2}$ pour $x \in (\frac{\pi}{3}; \pi]$.

$-2\cos(x) + 1 < 0 \iff 1 < 2\cos(x) \iff \cos(x) > \frac{1}{2}$.
Sur l''intervalle $[0; \pi]$, $\cos(x) > \frac{1}{2}$ pour $x \in [0; \frac{\pi}{3})$.

$-2\cos(x) + 1 = 0 \iff \cos(x) = \frac{1}{2}$.
Sur l''intervalle $[0; \pi]$, $\cos(x) = \frac{1}{2}$ pour $x = \frac{\pi}{3}$.

Tableau de variations de $f$ sur $[0; \pi]$ :

| $x$ | $0$ | $\frac{\pi}{3}$ | $\pi$ |
|---|---|---|---|
| $\sin(x)$ | $0$ | $+$ | $0$ |
| $-2\cos(x)+1$ | $-$ | $0$ | $+$ |
| $f''(x)$ | $0$ | $-$ | $0$ |
| $f(x)$ | $f(0)$ | $\searrow$ | $f(\frac{\pi}{3})$ | $\nearrow$ | $f(\pi)$ |

Calcul des valeurs :
$f(0) = \cos(0) - 2\cos(0) = 1 - 2(1) = -1$.
$f(\frac{\pi}{3}) = \cos(2\frac{\pi}{3}) - 2\cos(\frac{\pi}{3}) = -\frac{1}{2} - 2(\frac{1}{2}) = -\frac{1}{2} - 1 = -\frac{3}{2}$.
$f(\pi) = \cos(2\pi) - 2\cos(\pi) = 1 - 2(-1) = 1 + 2 = 3$.

Tableau de variations de $f$ sur $[0; \pi]$ :

| $x$ | $0$ | $\frac{\pi}{3}$ | $\pi$ |
|---|---|---|---|
| $\sin(x)$ | $0$ | $+$ | $0$ |
| $-2\cos(x)+1$ | $-$ | $0$ | $+$ |
| $f''(x)$ | $0$ | $-$ | $0$ |
| $f(x)$ | $-1$ | $\searrow$ | $-\frac{3}{2}$ | $\nearrow$ | $3$ |', '["Pour la parité, rappelle-toi des propriétés de $\\cos(-x)$.","Pour la périodicité, utilise la propriété $\\cos(x+2\\pi) = \\cos(x)$.","Pour la dérivée, pense à la règle de dérivation des fonctions composées pour $\\cos(2x)$.","Pour le signe de la dérivée, tu pourrais être amené à factoriser ou à utiliser des identités trigonométriques comme $\\sin(2x) = 2\\sin(x)\\cos(x)$."]'::jsonb, '2025-11-02T12:38:30.761511+00:00'::timestamptz, 'd22cbd7d865b3f9de3445128efdf5db22b68d9c58ccf7d75438262691e84e06e', NULL),
('4da6fb18-b716-4aab-be81-9e3fcdbcab37', 'Inéquations', 'terminale', '{"questions":["Résous l''inéquation $$\\frac{2x - 1}{x + 3} \\ge 1$$","Résous l''inéquation $$|2x - 3| < 5$$"],"contexte":"Résous les inéquations suivantes en utilisant la méthode de disjonction de cas."}', '1. Résolution de $\frac{2x - 1}{x + 3} \ge 1$ :

$\frac{2x - 1}{x + 3} - 1 \ge 0$

$\frac{2x - 1 - (x + 3)}{x + 3} \ge 0$

$\frac{2x - 1 - x - 3}{x + 3} \ge 0$

$\frac{x - 4}{x + 3} \ge 0$

Étude du signe du numérateur $x - 4$ :
$x - 4 = 0 \iff x = 4$
$x - 4 > 0 \iff x > 4$
$x - 4 < 0 \iff x < 4$

Étude du signe du dénominateur $x + 3$ :
$x + 3 = 0 \iff x = -3$
$x + 3 > 0 \iff x > -3$
$x + 3 < 0 \iff x < -3$

Tableau de signes :

| $x$             | $-\infty$ | $-3$      | $4$       | $+\infty$ |
|-----------------|-----------|-----------|-----------|------------|
| $x - 4$         | $-$       | $-$       | $0$       | $+$        |
| $x + 3$         | $-$       | $0$       | $+$       | $+$        |
| $\frac{x - 4}{x + 3}$ | $+$       | $|$       | $0$       | $+$        |

L''ensemble des solutions est $S = ]-\infty ; -3[ \cup [4 ; +\infty[$.

2. Résolution de $|2x - 3| < 5$ :

L''inéquation $|2x - 3| < 5$ est équivalente à :
$-5 < 2x - 3 < 5$

On résout cette double inéquation en deux parties :

Première partie : $-5 < 2x - 3$
$-5 + 3 < 2x$
$-2 < 2x$
$-1 < x$

Deuxième partie : $2x - 3 < 5$
$2x < 5 + 3$
$2x < 8$
$x < 4$

L''ensemble des solutions est l''intersection des deux intervalles : $]-1 ; 4[$.

Donc $S = ]-1 ; 4[$.', '["Pour la première inéquation, commence par ramener tous les termes d''un seul côté pour obtenir un quotient.","Pour la première inéquation, étudie le signe du numérateur et du dénominateur.","Pour la deuxième inéquation, rappelle-toi la définition de la valeur absolue : $|X| < a \\iff -a < X < a$ pour $a > 0$."]'::jsonb, '2025-11-02T14:17:09.074435+00:00'::timestamptz, 'd7ce7a5cfae05fda904ede75dd69c4fb3abe26a2c36aab12ee214e7d4ff47582', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('06961423-7c45-4272-b274-b5fbd8c102c9', 'Inéquations', 'terminale', '{"contexte":"Résous les inéquations suivantes.","questions":["Résous l''inéquation $$\\sqrt{x + 1} < 3$$","Résous l''inéquation $$\\sqrt{2x - 4} \\ge x - 2$$"]}', '1. Résolution de $\sqrt{x + 1} < 3$ :

Conditions d''existence :
Pour que $\sqrt{x + 1}$ soit définie, il faut que $x + 1 \ge 0$, donc $x \ge -1$. L''ensemble de définition est $[-1 ; +\infty[$.

L''inéquation est $\sqrt{x + 1} < 3$.
Les deux membres sont positifs, on peut élever au carré :
$(\sqrt{x + 1})^2 < 3^2$
$x + 1 < 9$
$x < 8$

En combinant avec l''ensemble de définition $x \ge -1$, on obtient l''ensemble solution $S_1 = [-1 ; 8[$.

2. Résolution de $\sqrt{2x - 4} \ge x - 2$ :

Conditions d''existence :
Pour que $\sqrt{2x - 4}$ soit définie, il faut que $2x - 4 \ge 0$, donc $2x \ge 4$, soit $x \ge 2$. L''ensemble de définition est $[2 ; +\infty[$.

Nous allons distinguer deux cas :

**Cas 1 : $x - 2 < 0$**
Si $x - 2 < 0$, alors $x < 2$. Dans ce cas, $x - 2$ est négatif.
Puisque $\sqrt{2x - 4}$ est toujours positif (ou nul) et $x - 2$ est négatif, l''inégalité $\sqrt{2x - 4} \ge x - 2$ est toujours vérifiée.
Cependant, nous devons aussi respecter la condition d''existence $x \ge 2$. Il n''y a donc pas de solution dans ce cas, car l''intersection de $x < 2$ et $x \ge 2$ est vide.

**Cas 2 : $x - 2 \ge 0$**
Si $x - 2 \ge 0$, alors $x \ge 2$. Dans ce cas, les deux membres de l''inégalité sont positifs, on peut donc élever au carré sans changer le sens de l''inégalité :
$(\sqrt{2x - 4})^2 \ge (x - 2)^2$
$2x - 4 \ge x^2 - 4x + 4$
$0 \ge x^2 - 6x + 8$
$x^2 - 6x + 8 \le 0$

Cherchons les racines du trinôme $x^2 - 6x + 8$ :
Le discriminant $\Delta = (-6)^2 - 4 \times 1 \times 8 = 36 - 32 = 4$.
Les racines sont $x_1 = \frac{6 - \sqrt{4}}{2} = \frac{6 - 2}{2} = 2$ et $x_2 = \frac{6 + \sqrt{4}}{2} = \frac{6 + 2}{2} = 4$.

Puisque le coefficient de $x^2$ est positif (1), la parabole est tournée vers le haut. Donc $x^2 - 6x + 8 \le 0$ lorsque $x$ est entre les racines, c''est-à-dire $2 \le x \le 4$.

En combinant cette solution avec la condition du cas 2 ($x \ge 2$), on obtient l''ensemble solution $S_2 = [2 ; 4]$.

L''ensemble solution final est l''union des solutions de tous les cas. Ici, seul le Cas 2 a apporté des solutions valides. Donc $S = [2 ; 4]$.', '["Pour la première inéquation, n''oublie pas les conditions d''existence de la racine carrée.","Pour la première inéquation, élève les deux membres au carré en faisant attention au signe.","Pour la deuxième inéquation, il faudra discuter selon le signe de $x-2$. Pense aux deux cas : $x-2 < 0$ et $x-2 \\ge 0$.","Pour le cas où $x-2 \\ge 0$, tu devras élever au carré les deux membres et résoudre une inéquation du second degré."]'::jsonb, '2025-11-02T14:17:50.807754+00:00'::timestamptz, '8440e96c4cfad298e00916b099aaf3d51f4305b1d688b5a5b355c5f0f9572f6d', NULL),
('2c26fa84-9f4e-4671-aed9-be56de370192', 'Exercice soumis', 'seconde', ' $\sqrt3\times3$ calcul cela ', 'En cours de correction', '[]'::jsonb, '2025-11-02T15:10:28.707394+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('fcdc36fb-2ef8-43a7-ac77-7bb410bee8ea', 'Équations du second degré et inéquations', 'terminale', '{"questions":["Détermine les valeurs de $m$ pour lesquelles l''équation admet exactement deux solutions réelles distinctes.","Dans ce cas, exprime les deux solutions $x_1$ et $x_2$ en fonction de $m$.","On considère l''inéquation $x^2 - (m+1)x + m \\le 0$. Détermine les valeurs de $m$ pour lesquelles l''ensemble des solutions de cette inéquation est un intervalle de longueur strictement supérieure à 2."],"contexte":"Soit l''équation du second degré $x^2 - (m+1)x + m = 0$, où $m$ est un paramètre réel."}', '1. Pour que l''équation admette deux solutions réelles distinctes, le discriminant $\Delta$ doit être strictement positif.
$\Delta = b^2 - 4ac = (-(m+1))^2 - 4(1)(m) = (m+1)^2 - 4m = m^2 + 2m + 1 - 4m = m^2 - 2m + 1 = (m-1)^2$.
Donc, $(m-1)^2 > 0$, ce qui signifie $m \ne 1$.

2. Les solutions sont données par $x = \frac{-b \pm \sqrt{\Delta}}{2a}$.
$x = \frac{(m+1) \pm \sqrt{(m-1)^2}}{2} = \frac{(m+1) \pm |m-1|}{2}$.
Si $m > 1$, alors $|m-1| = m-1$. Les solutions sont $x_1 = \frac{m+1 - (m-1)}{2} = \frac{2}{2} = 1$ et $x_2 = \frac{m+1 + m-1}{2} = \frac{2m}{2} = m$.
Si $m < 1$, alors $|m-1| = -(m-1) = 1-m$. Les solutions sont $x_1 = \frac{m+1 - (1-m)}{2} = \frac{2m}{2} = m$ et $x_2 = \frac{m+1 + 1-m}{2} = \frac{2}{2} = 1$.
Dans les deux cas, les solutions sont $1$ et $m$.

3. L''inéquation $x^2 - (m+1)x + m \le 0$ a pour solutions les valeurs de $x$ comprises entre $x_1$ et $x_2$. L''ensemble des solutions est l''intervalle $[\min(1,m), \max(1,m)]$.
La longueur de cet intervalle est $|m-1|$.
On veut que cette longueur soit strictement supérieure à 2, donc $|m-1| > 2$.
Ceci implique $m-1 > 2$ ou $m-1 < -2$.
$m > 3$ ou $m < -1$.
Donc, l''ensemble des solutions de l''inéquation est un intervalle de longueur strictement supérieure à 2 pour $m \in ]-\infty, -1[ \cup ]3, +\infty[$.', '["Le discriminant doit être strictement positif pour avoir deux solutions réelles distinctes.","Utilise la formule des solutions d''une équation du second degré : $x = \\frac{-b \\pm \\sqrt{\\Delta}}{2a}$.","La longueur de l''intervalle $[x_1, x_2]$ est $|x_2 - x_1|$. Tu devras résoudre une inéquation avec $m$."]'::jsonb, '2025-11-02T15:50:03.379462+00:00'::timestamptz, '4c34655ecd3594579380a567b965239b731a2f78c586aceda747e4ce3a047564', NULL),
('1207223b-4822-49e7-850a-51e5e8d3a23f', 'Probabilités', 'terminale', '{"contexte":"Une usine fabrique des pièces. La probabilité qu''une pièce soit défectueuse est de $p = 0,05$. On prélève un échantillon de $n = 10$ pièces au hasard dans la production. Chaque prélèvement est indépendant des précédents.","questions":["Quelles sont les deux conditions principales pour qu''une situation puisse être modélisée par une loi binomiale ?","Dans le contexte de cet exercice, explique pourquoi l''expérience de prélèvement d''une pièce peut être considérée comme une épreuve de Bernoulli.","Justifie pourquoi la variable aléatoire $X$ qui compte le nombre de pièces défectueuses dans l''échantillon suit une loi binomiale. Précise les paramètres $n$ et $p$."]}', '1. Les deux conditions principales pour qu''une situation puisse être modélisée par une loi binomiale sont :
   - La répétition d''épreuves de Bernoulli identiques et indépendantes.
   - La variable aléatoire compte le nombre de succès parmi ces répétitions.

2. L''expérience de prélèvement d''une pièce peut être considérée comme une épreuve de Bernoulli car il n''y a que deux issues possibles :
   - Succès (la pièce est défectueuse) avec une probabilité $p = 0,05$.
   - Échec (la pièce n''est pas défectueuse) avec une probabilité $1 - p = 0,95$.

3. La variable aléatoire $X$ suit une loi binomiale car :
   - On répète $n = 10$ fois l''épreuve de Bernoulli (prélèvement d''une pièce).
   - Ces répétitions sont identiques (la probabilité $p$ reste la même) et indépendantes (le prélèvement d''une pièce n''influence pas les autres).
   - La variable aléatoire $X$ compte le nombre de succès (pièces défectueuses) parmi ces $n$ répétitions.
   Les paramètres de cette loi binomiale sont $n = 10$ et $p = 0,05$, donc $X \sim \mathcal{B}(10; 0,05)$.', '["Une épreuve de Bernoulli est une expérience aléatoire qui n''a que deux issues possibles : succès ou échec.","Pour la loi binomiale, pense au nombre de répétitions et à l''indépendance des épreuves."]'::jsonb, '2025-11-02T15:52:05.396345+00:00'::timestamptz, 'd8faf8292a2a609fe8ed9694a973366a952a537df5f8febb80627edd5956316f', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('7e128f68-15d8-4222-921b-b8148df410a6', 'Probabilités', 'terminale', '{"contexte":"Un commercial réalise des ventes. La probabilité qu''il réussisse une vente avec un client est de $p = 0,3$. Il rencontre $n = 8$ clients indépendamment les uns des autres.","questions":["Quelles sont les caractéristiques d''une épreuve de Bernoulli ?","Dans le contexte de cet exercice, explique pourquoi la rencontre avec un client peut être assimilée à une épreuve de Bernoulli.","Justifie pourquoi la variable aléatoire $Y$ qui représente le nombre de ventes réussies parmi les 8 clients suit une loi binomiale. Précise ses paramètres $n$ et $p$."]}', '1. Une épreuve de Bernoulli est une expérience aléatoire qui ne possède que deux issues possibles, conventionnellement appelées "succès" et "échec". Chaque issue est associée à une probabilité constante, la probabilité de succès (notée $p$) et la probabilité d''échec ($1-p$).

2. La rencontre avec un client peut être assimilée à une épreuve de Bernoulli car il n''y a que deux issues possibles pour cette rencontre :
   - Succès : Le commercial réussit une vente, avec une probabilité $p = 0,3$.
   - Échec : Le commercial ne réussit pas de vente, avec une probabilité $1 - p = 1 - 0,3 = 0,7$.

3. La variable aléatoire $Y$ suit une loi binomiale car :
   - L''expérience (rencontre avec un client) est répétée $n = 8$ fois de manière identique et indépendante.
   - Chaque répétition est une épreuve de Bernoulli (deux issues : vente réussie ou non).
   - $Y$ compte le nombre de succès (ventes réussies) au cours de ces $n$ répétitions.
   Les paramètres de cette loi binomiale sont donc $n = 8$ (nombre de répétitions) et $p = 0,3$ (probabilité de succès), soit $Y \sim \mathcal{B}(8; 0,3)$.', '["Une épreuve de Bernoulli n''a que deux issues possibles.","Pense à l''indépendance des événements et au nombre de répétitions pour la loi binomiale."]'::jsonb, '2025-11-02T15:55:16.386174+00:00'::timestamptz, 'f6c7a51d79818552d3e23b0b3eea477f1df876dbc459febd4022e67f119eaa42', NULL),
('1ef968ad-6b51-4939-bdca-7dfe30a214fc', 'Inéquations', 'terminale', '{"contexte":"On considère l''inéquation suivante, où $x$ est une variable réelle et $m$ est un paramètre réel : $$\\sqrt{x^2 - (2m+1)x + m(m+1)} \\ge 0$$","questions":["Pour quelles valeurs de $x$ l''expression sous la racine carrée, $P(x) = x^2 - (2m+1)x + m(m+1)$, est-elle définie ? Exprime cela en fonction de $m$.","Détermine les racines du polynôme $P(x)$.","En déduire le tableau de signes de $P(x)$ en fonction des valeurs de $m$.","Résous l''inéquation $\\sqrt{x^2 - (2m+1)x + m(m+1)} \\ge 0$ en fonction du paramètre $m$."]}', '1. Pour que l''expression sous la racine carrée soit définie, il faut que $P(x) = x^2 - (2m+1)x + m(m+1) \ge 0$.

2. Déterminons les racines de $P(x)$. Le discriminant $\Delta$ est :
   $$\Delta = (-(2m+1))^2 - 4(1)(m(m+1))$$
   $$\Delta = (2m+1)^2 - 4m(m+1)$$
   $$\Delta = (4m^2 + 4m + 1) - (4m^2 + 4m)$$
   $$\Delta = 1$$
   Puisque $\Delta = 1 > 0$, le polynôme $P(x)$ a deux racines réelles distinctes :
   $$x_1 = \frac{-( -(2m+1)) - \sqrt{1}}{2(1)} = \frac{2m+1 - 1}{2} = \frac{2m}{2} = m$$
   $$x_2 = \frac{-( -(2m+1)) + \sqrt{1}}{2(1)} = \frac{2m+1 + 1}{2} = \frac{2m+2}{2} = m+1$$

3. Le coefficient de $x^2$ est $1$, qui est positif. Donc le polynôme $P(x)$ est positif à l''extérieur de ses racines et négatif entre ses racines. Les racines sont $m$ et $m+1$. Puisque $m < m+1$, on a :
| $x$ | $-\infty$ | $m$ | $m+1$ | $+\infty$ |
|---|---|---|---|---|
| $P(x)$ | $+$ | $0$ | $-$ | $0$ | $+$ |

4. L''inéquation à résoudre est $\sqrt{P(x)} \ge 0$. Une racine carrée est toujours positive ou nulle lorsqu''elle est définie. Donc cette inéquation est vraie si et seulement si $P(x)$ est défini et $P(x) \ge 0$. D''après le tableau de signes précédent, $P(x) \ge 0$ lorsque $x \in ]-\infty; m] \cup [m+1; +\infty[$. Le domaine de définition de la racine est donc l''ensemble des solutions de l''inéquation.

   L''ensemble des solutions de l''inéquation est donc $S = ]-\infty; m] \cup [m+1; +\infty[$.', '["Pour qu''une racine carrée soit définie, l''expression sous la racine doit être positive ou nulle.","Le discriminant $\\Delta$ d''un polynôme de degré 2 $ax^2 + bx + c$ est $b^2 - 4ac$.","Si $\\Delta > 0$, il y a deux racines distinctes ; si $\\Delta = 0$, une racine double ; si $\\Delta < 0$, pas de racines réelles.","Un polynôme de degré 2 est du signe de $a$ à l''extérieur des racines et du signe opposé entre les racines."]'::jsonb, '2025-11-02T15:56:31.172111+00:00'::timestamptz, 'b7b05e64feaa9186761c58fd37ceea2808c2da6f5c28ae795133a75257d91077', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('254997b8-980e-474d-9b60-59c0acc1a2ce', 'Exercice soumis', 'terminale', 'Exercice soumis via image', 'En cours de correction', '[]'::jsonb, '2025-11-02T17:46:40.894438+00:00'::timestamptz, NULL, '{}'::jsonb),
('6fbe0d8b-91c7-4f95-9f05-e43c9613981f', 'Exercice soumis', 'terminale', 'je veux résoudre  $\int_0^1\frac{1}{x^2-2x+5}\differentialD x$ ', 'En cours de correction', '[]'::jsonb, '2025-11-03T14:05:52.289304+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('fced9072-7435-4558-8735-8290ca408356', 'Exercice soumis', 'terminale', 'je veux résoudre  $\int_0^1\frac{1}{x^2-2x+5}\differentialD x$ ', 'En cours de correction', '[]'::jsonb, '2025-11-03T14:05:52.912408+00:00'::timestamptz, NULL, '{}'::jsonb),
('b84375f8-e299-4bad-ad3a-ded8e02ebdb7', 'Exercice soumis', 'terminale', 'Il faut que je fasse l’exercice 1 sans le produit mixte ', 'En cours de correction', '[]'::jsonb, '2025-11-03T17:46:28.024293+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('bd8bc813-885b-49ff-be05-a45bed0b7dfa', 'Exercice soumis', 'terminale', ' $AM=\frac12AB$ ', 'En cours de correction', '[]'::jsonb, '2025-11-03T19:16:14.872885+00:00'::timestamptz, NULL, '{}'::jsonb),
('21abf459-414b-43f0-8f13-eb1cc5a17ba5', 'Exercice soumis', 'premiere', 'genere moi des exercices de probabilites niveau premiere. J eveux des probabiité conditionnel et formule des probabilite totale', 'En cours de correction', '[]'::jsonb, '2025-11-05T13:49:09.935806+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('638df9f0-0256-4d1c-8b7e-710ecf0001ea', 'Exercice soumis', 'terminale', 'Je n’arrive pas à commencer l’exercice 10', 'En cours de correction', '[]'::jsonb, '2025-11-05T21:25:48.10966+00:00'::timestamptz, NULL, '{}'::jsonb),
('a685d60b-da05-406c-b08a-3f763b20f7d5', 'Exercice soumis', 'terminale', 'Réécris ce que tu vois en plus de me corriger', 'En cours de correction', '[]'::jsonb, '2025-11-09T19:20:33.128996+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('d3d84b7a-7611-4bf7-99d8-04662a56d24a', 'Exercice soumis', 'terminale', 'Voici l''exo sur lequel on va travailler', 'En cours de correction', '[]'::jsonb, '2025-11-09T19:22:08.959595+00:00'::timestamptz, NULL, '{}'::jsonb),
('eb2116a0-a85a-40ee-a745-6f342c114d31', 'Exercice soumis', 'terminale', 'dis moi si tu lis bien tous les exos, et is oui retranscris-les ici', 'En cours de correction', '[]'::jsonb, '2025-11-09T19:49:18.246075+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('e1bac204-703e-4da4-bf01-cadb582af6cf', 'Exercice soumis', 'terminale', 'voilà ma feuille d''exo tu peux me corriger l''exo 12?', 'En cours de correction', '[]'::jsonb, '2025-11-09T19:56:33.457335+00:00'::timestamptz, NULL, '{}'::jsonb),
('ba0d2279-f672-43e6-b301-20fab58af06c', 'Dérivabilité et Convexité', 'terminale', '{"questions":["Calcule la dérivée première $f''(x)$ de la fonction $f$.","Calcule la dérivée seconde $f''''(x)$ de la fonction $f$.","Étudie le signe de $f''''(x)$ sur $\\mathbb{R}$.","Déduis-en les intervalles sur lesquels la fonction $f$ est convexe ou concave.","Détermine les éventuels points d''inflexion de la courbe représentative de $f$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^4 - 6x^2 + 5$. On souhaite étudier la convexité de $f$."}', '**1. Calcul de la dérivée première $f''(x)$ :**
$f(x) = x^4 - 6x^2 + 5$
$f''(x) = 4x^3 - 12x$

**2. Calcul de la dérivée seconde $f''''(x)$ :**
$f''''(x) = 12x^2 - 12$

**3. Étude du signe de $f''''(x)$ sur $\mathbb{R}$ :**
On cherche les racines de $f''''(x) = 0$ :
$12x^2 - 12 = 0$
$12(x^2 - 1) = 0$
$x^2 - 1 = 0$
$(x-1)(x+1) = 0$
Les racines sont $x = 1$ et $x = -1$.
$f''''(x)$ est une parabole ouverte vers le haut (coefficient de $x^2$ positif). Elle est donc positive à l''extérieur des racines et négative entre les racines.

| $x$              | $-\infty$ |       $-1$        |        $1$        | $+\infty$ |
| :--------------- | :-------- | :---------------: | :---------------: | :-------- |
| Signe de $f''''(x)$ |     $+$   |         $0$       |         $0$       |     $+$   |

**4. Intervalles de convexité et concavité :**
*   $f$ est convexe sur $]-\infty; -1]$ et sur $[1; +\infty[$ (où $f''''(x) \ge 0$).
*   $f$ est concave sur $[-1; 1]$ (où $f''''(x) \le 0$).

**5. Points d''inflexion :**
Les points d''inflexion se produisent là où $f''''(x)$ change de signe, c''est-à-dire en $x = -1$ et $x = 1$.
*   Pour $x = -1$ : $f(-1) = (-1)^4 - 6(-1)^2 + 5 = 1 - 6 + 5 = 0$. Le point d''inflexion est $(-1; 0)$.
*   Pour $x = 1$ : $f(1) = (1)^4 - 6(1)^2 + 5 = 1 - 6 + 5 = 0$. Le point d''inflexion est $(1; 0)$.', '["Pour calculer la dérivée seconde, dérive la dérivée première.","Un point d''inflexion correspond à un changement de convexité, c''est-à-dire un changement de signe de la dérivée seconde.","N''oublie pas qu''un polynôme de degré 2 de la forme $ax^2+bx+c$ est du signe de $a$ à l''extérieur de ses racines."]'::jsonb, '2025-11-09T20:02:37.469661+00:00'::timestamptz, '8940710e94a3fd3afae9fb237a2bb4c06c82bb66059d5c11ba7f77cf8eaf246f', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('623410f5-1f48-4cef-9430-1715fa7bd798', 'Exercice soumis', 'seconde', 'transcrire en mode texte', 'En cours de correction', '[]'::jsonb, '2025-11-09T21:27:10.75648+00:00'::timestamptz, NULL, '{}'::jsonb),
('4c0b79d2-86be-4877-9f4b-9bbe3d29f186', 'Exercice soumis', 'terminale', 'lis ces exos', 'En cours de correction', '[]'::jsonb, '2025-11-10T11:14:11.26011+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('6582558c-f9fa-4e22-ad6f-97f75418cfa6', 'Exercice soumis', 'terminale', 'écris les énoncés des exos ici', 'En cours de correction', '[]'::jsonb, '2025-11-10T11:15:00.706081+00:00'::timestamptz, NULL, '{}'::jsonb),
('7830a450-9120-4b64-aeb9-70fa8ef85835', 'Exercice soumis', 'terminale', 'écris les énoncés de tous les exoq', 'En cours de correction', '[]'::jsonb, '2025-11-10T11:18:21.433471+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('caefbb34-cf59-4601-90c1-279ae977594f', 'Exercice soumis', 'seconde', 'je veux pendre de l''avance sur le programme et apprendre les nombres complexes , peux tu me faire un cours pour debutant avec des exervices pour m''accompagner', 'En cours de correction', '[]'::jsonb, '2025-11-10T18:35:11.982883+00:00'::timestamptz, NULL, '{}'::jsonb),
('e5c7c58b-a206-4656-842e-0809bba9b189', 'Identités remarquables', 'premiere', '{"contexte":"Pour cet exercice, nous allons manipuler les identités remarquables.","questions":["Développe et réduis l''expression suivante : $(2x + 3)^2$","Factorise l''expression suivante : $49x^2 - 16$","Développe et réduis l''expression suivante : $(5x - 2)(5x + 2) - (3x - 1)^2$","Factorise l''expression suivante : $x^2 - 10x + 25$"]}', '1. $(2x + 3)^2 = (2x)^2 + 2 \times (2x) \times 3 + 3^2 = 4x^2 + 12x + 9$

2. $49x^2 - 16 = (7x)^2 - 4^2 = (7x - 4)(7x + 4)$

3. $(5x - 2)(5x + 2) - (3x - 1)^2$
$= ( (5x)^2 - 2^2 ) - ( (3x)^2 - 2 \times (3x) \times 1 + 1^2 )$
$= (25x^2 - 4) - (9x^2 - 6x + 1)$
$= 25x^2 - 4 - 9x^2 + 6x - 1$
$= 16x^2 + 6x - 5$

4. $x^2 - 10x + 25 = x^2 - 2 \times x \times 5 + 5^2 = (x - 5)^2$', '["Rappelle-toi la formule $(a+b)^2 = a^2 + 2ab + b^2$.","Reconnais une différence de deux carrés : $a^2 - b^2 = (a-b)(a+b)$.","Fais attention aux signes lors du développement et de la réduction, surtout avec le moins devant la parenthèse.","Reconnais la forme $a^2 - 2ab + b^2$."]'::jsonb, '2025-11-10T19:41:49.063387+00:00'::timestamptz, '4d22b424d9e92066b905d9d5c725e52d106a37ea206f6f36291a6d06001cf6d6', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('3c88a680-02bd-4c7e-951d-c532531c3b91', 'Exercice soumis', 'terminale', 'peux tu me générer des ex complètes sur les fonctions à étudier, sans la fonction ln mais avec l''exponentielle? Je veux des variations, des limites, un peu de valeurs intermédiaires.', 'En cours de correction', '[]'::jsonb, '2025-11-16T19:14:03.469381+00:00'::timestamptz, NULL, '{}'::jsonb),
('035698b8-42d1-4f8b-a12d-d667733343c7', 'Exercice soumis', 'terminale', 'arg $\left(\frac{z-2i}{z-1+2i}\right)=\frac{\pi}{2}$ modulo 2pi', 'En cours de correction', '[]'::jsonb, '2025-11-16T20:53:47.210392+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('d1f69088-1ebe-4860-8fe5-dddd12aeb9b4', 'Intégrales', 'terminale', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine une primitive $F$ de $f$ sur $\\mathbb{R}$ en utilisant une intégration par parties."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x+1)e^{-x}$."}', '1. Calcul de la dérivée $f''(x)$ :
$f(x) = (2x+1)e^{-x}$
On pose $u(x) = 2x+1$ et $v(x) = e^{-x}$.
Alors $u''(x) = 2$ et $v''(x) = -e^{-x}$.
En utilisant la formule de dérivation d''un produit $(uv)'' = u''v + uv''$ :
$f''(x) = 2e^{-x} + (2x+1)(-e^{-x})$
$f''(x) = e^{-x}(2 - (2x+1))$
$f''(x) = e^{-x}(2 - 2x - 1)$
$f''(x) = (1-2x)e^{-x}$

2. Détermination d''une primitive $F$ de $f$ par intégration par parties :
On cherche à calculer $\int (2x+1)e^{-x} dx$.
On pose $u(x) = 2x+1$ et $v''(x) = e^{-x}$.
Alors $u''(x) = 2$ et $v(x) = -e^{-x}$.
En utilisant la formule d''intégration par parties $\int u v'' dx = uv - \int u''v dx$ :
$\int (2x+1)e^{-x} dx = (2x+1)(-e^{-x}) - \int 2(-e^{-x}) dx$
$= -(2x+1)e^{-x} + 2 \int e^{-x} dx$
$= -(2x+1)e^{-x} + 2(-e^{-x}) + C$
$= -2xe^{-x} - e^{-x} - 2e^{-x} + C$
$= -2xe^{-x} - 3e^{-x} + C$
Donc, une primitive de $f$ est $F(x) = (-2x-3)e^{-x}$.', '["Pour la dérivée, pense à la formule de dérivation d''un produit.","Pour l''intégration par parties, tu devras choisir judicieusement $u(x)$ et $v''(x)$. Pense à une fonction facile à dériver et une autre facile à intégrer.","Rappelle-toi la formule de l''intégration par parties : $\\int u v'' dx = uv - \\int u''v dx$"]'::jsonb, '2025-11-17T08:30:12.446986+00:00'::timestamptz, 'bd5fd28d113d9e571ccf108876644f88aa9b7974d04fe2c97d36804adba8e69b', NULL),
('5554527f-6513-4a8c-92c0-164a2a3821c2', 'Intégrales', 'terminale', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine une primitive $F$ de $f$ sur $\\mathbb{R}$.","Calcule la valeur exacte de l''intégrale $I = \\int_0^{\\ln(3)} f(x)dx$."],"contexte":"Soit $f$ la fonction définie sur $\\mathbb{R}$ par $f(x) = \\frac{e^x}{e^x + 1}$. On note $C_f$ sa courbe représentative."}', '1. Dérivée de $f(x)$ :
Soit $f(x) = \frac{e^x}{e^x + 1}$. On pose $u(x) = e^x$ et $v(x) = e^x + 1$.
Alors $u''(x) = e^x$ et $v''(x) = e^x$.
$$f''(x) = \frac{u''v - uv''}{v^2} = \frac{e^x(e^x + 1) - e^x(e^x)}{(e^x + 1)^2} = \frac{e^{2x} + e^x - e^{2x}}{(e^x + 1)^2} = \frac{e^x}{(e^x + 1)^2}$$2. Primitive de $f(x)$ :
On a $f(x) = \frac{e^x}{e^x + 1}$. C''est de la forme $\frac{u''}{u}$ avec $u(x) = e^x + 1$.
Une primitive de $f$ est donc $F(x) = \ln(|e^x + 1|)$.
Comme $e^x + 1 > 0$ pour tout $x \in \mathbb{R}$, on a $F(x) = \ln(e^x + 1)$.
3. Calcul de l''intégrale $I$ :
$$I = \int_0^{\ln(3)} f(x)dx = [F(x)]_0^{\ln(3)} = F(\ln(3)) - F(0)$$
$$F(\ln(3)) = \ln(e^{\ln(3)} + 1) = \ln(3 + 1) = \ln(4)$$
$$F(0) = \ln(e^0 + 1) = \ln(1 + 1) = \ln(2)$$
$$I = \ln(4) - \ln(2) = \ln\left(\frac{4}{2}\right) = \ln(2)$$', '["Pour la dérivée, pense à la formule de dérivation d''un quotient $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$.","Pour la primitive, reconnais la forme $\\frac{u''}{u}$.","Pour l''intégrale, utilise la primitive que tu as trouvée et le théorème fondamental de l''analyse."]'::jsonb, '2025-11-17T09:08:22.649282+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('c9a6dfdb-c142-4cfa-8dbb-9df7c344d0ca', 'Intégrales', 'terminale', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine une primitive $F$ de $f$ sur $\\mathbb{R}$ en utilisant une intégration par parties."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x+2)e^{3x}$."}', '1. Dérivée de $f(x) = (x+2)e^{3x}$ :
On utilise la formule $(uv)'' = u''v + uv''$ avec $u(x) = x+2$ et $v(x) = e^{3x}$.
Alors $u''(x) = 1$ et $v''(x) = 3e^{3x}$.
$f''(x) = 1 \cdot e^{3x} + (x+2) \cdot 3e^{3x}$
$f''(x) = e^{3x} + 3xe^{3x} + 6e^{3x}$
$f''(x) = (3x+7)e^{3x}$

2. Primitive de $f(x) = (x+2)e^{3x}$ par intégration par parties :
On utilise la formule $\int u(x)v''(x)dx = u(x)v(x) - \int u''(x)v(x)dx$.
Choisissons $u(x) = x+2$ et $v''(x) = e^{3x}$.
Alors $u''(x) = 1$ et $v(x) = \frac{1}{3}e^{3x}$.
$\int (x+2)e^{3x}dx = (x+2)\left(\frac{1}{3}e^{3x}\right) - \int 1 \cdot \frac{1}{3}e^{3x}dx$
$= \frac{1}{3}(x+2)e^{3x} - \frac{1}{3}\int e^{3x}dx$
$= \frac{1}{3}(x+2)e^{3x} - \frac{1}{3}\left(\frac{1}{3}e^{3x}\right) + C$
$= \frac{1}{3}(x+2)e^{3x} - \frac{1}{9}e^{3x} + C$
$= e^{3x}\left(\frac{x+2}{3} - \frac{1}{9}\right) + C$
$= e^{3x}\left(\frac{3(x+2)-1}{9}\right) + C$
$= e^{3x}\left(\frac{3x+6-1}{9}\right) + C$
$= \frac{1}{9}(3x+5)e^{3x} + C$', '["Pour la dérivée, pense à la formule de dérivation d''un produit.","Pour la primitive, identifie les parties $u(x)$ et $v''(x)$ de telle sorte que $u''(x)$ et $v(x)$ soient faciles à calculer et que $\\int u''(x)v(x)dx$ soit plus simple à intégrer."]'::jsonb, '2025-11-17T14:13:27.395417+00:00'::timestamptz, '956cd6caf6f9355728a14680d8a549bf1d58aa3140c205a6279dd57512c38151', NULL),
('e1a47b33-0b8d-44cc-b225-38380e6f5139', 'Identités remarquables', 'premiere', '{"questions":["Développe et réduis l''expression suivante : $A = - (3x - 2)^2$","Développe et réduis l''expression suivante : $B = (x + 5)(x - 5) - (2x + 1)^2$","Développe et réduis l''expression suivante : $C = 4 - (x - 3)^2 + 2(x + 1)(x - 1)$"],"contexte":"Pour cet exercice, nous allons revoir ensemble la gestion des signes dans les expressions algébriques, une notion fondamentale pour la suite."}', 'Pour $A = - (3x - 2)^2$ :
$A = - ((3x)^2 - 2 \times 3x \times 2 + 2^2)$
$A = - (9x^2 - 12x + 4)$
$A = -9x^2 + 12x - 4$

Pour $B = (x + 5)(x - 5) - (2x + 1)^2$ :
$B = (x^2 - 5^2) - ((2x)^2 + 2 \times 2x \times 1 + 1^2)$
$B = (x^2 - 25) - (4x^2 + 4x + 1)$
$B = x^2 - 25 - 4x^2 - 4x - 1$
$B = -3x^2 - 4x - 26$

Pour $C = 4 - (x - 3)^2 + 2(x + 1)(x - 1)$ :
$C = 4 - (x^2 - 2 \times x \times 3 + 3^2) + 2(x^2 - 1^2)$
$C = 4 - (x^2 - 6x + 9) + 2(x^2 - 1)$
$C = 4 - x^2 + 6x - 9 + 2x^2 - 2$
$C = x^2 + 6x - 7$', '["Pour $A$, commence par développer $(3x - 2)^2$ puis applique le signe moins à tous les termes du résultat.","Pour $B$, reconnais une identité remarquable pour le premier terme, et développe le second en faisant attention au signe moins devant la parenthèse.","Pour $C$, développe chaque partie séparément en faisant attention aux signes, puis regroupe les termes similaires."]'::jsonb, '2025-11-17T21:54:18.065619+00:00'::timestamptz, '987d55a657fb9a24cd7355bca5879ccbd211f822b8cb46ca25da24d2ee988dc5', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('8e3822a3-bf66-47ff-b119-487fbc6095c6', 'Identités remarquables', 'premiere', '{"contexte":"Pour bien maîtriser le développement et la réduction d''expressions, il est essentiel de bien gérer les signes.","questions":["Développe et réduis l''expression suivante : $A = -(2x - 5)^2 + 3(x+1)(x-1)$","Développe et réduis l''expression suivante : $B = 5 - (3x + 2)^2 - (x - 4)(x + 4)$","Développe et réduis l''expression suivante : $C = -(x + 7)(x - 7) - 2(x - 3)^2$"]}', 'Pour l''expression $A = -(2x - 5)^2 + 3(x+1)(x-1)$ :

  1. On développe d''abord $(2x - 5)^2$ en utilisant l''identité remarquable $(a-b)^2 = a^2 - 2ab + b^2$ :
     $(2x - 5)^2 = (2x)^2 - 2(2x)(5) + 5^2 = 4x^2 - 20x + 25$

  2. Ensuite, on applique le signe moins à cette expression :
     $-(2x - 5)^2 = -(4x^2 - 20x + 25) = -4x^2 + 20x - 25$

  3. On développe $3(x+1)(x-1)$ en utilisant l''identité remarquable $(a+b)(a-b) = a^2 - b^2$ :
     $3(x+1)(x-1) = 3(x^2 - 1^2) = 3(x^2 - 1) = 3x^2 - 3$

  4. Enfin, on regroupe les termes et on réduit :
     $A = -4x^2 + 20x - 25 + 3x^2 - 3$
     $A = (-4x^2 + 3x^2) + 20x + (-25 - 3)$
     $A = -x^2 + 20x - 28$

Pour l''expression $B = 5 - (3x + 2)^2 - (x - 4)(x + 4)$ :

  1. On développe $(3x + 2)^2$ en utilisant $(a+b)^2 = a^2 + 2ab + b^2$ :
     $(3x + 2)^2 = (3x)^2 + 2(3x)(2) + 2^2 = 9x^2 + 12x + 4$

  2. On applique le signe moins :
     $-(3x + 2)^2 = -(9x^2 + 12x + 4) = -9x^2 - 12x - 4$

  3. On développe $(x - 4)(x + 4)$ en utilisant $(a-b)(a+b) = a^2 - b^2$ :
     $(x - 4)(x + 4) = x^2 - 4^2 = x^2 - 16$

  4. On applique le signe moins :
     $-(x - 4)(x + 4) = -(x^2 - 16) = -x^2 + 16$

  5. On regroupe les termes et on réduit :
     $B = 5 - 9x^2 - 12x - 4 - x^2 + 16$
     $B = (-9x^2 - x^2) - 12x + (5 - 4 + 16)$
     $B = -10x^2 - 12x + 17$

Pour l''expression $C = -(x + 7)(x - 7) - 2(x - 3)^2$ :

  1. On développe $(x + 7)(x - 7)$ en utilisant $(a+b)(a-b) = a^2 - b^2$ :
     $(x + 7)(x - 7) = x^2 - 7^2 = x^2 - 49$

  2. On applique le signe moins :
     $-(x + 7)(x - 7) = -(x^2 - 49) = -x^2 + 49$

  3. On développe $(x - 3)^2$ en utilisant $(a-b)^2 = a^2 - 2ab + b^2$ :
     $(x - 3)^2 = x^2 - 2(x)(3) + 3^2 = x^2 - 6x + 9$

  4. On multiplie par $-2$ :
     $-2(x - 3)^2 = -2(x^2 - 6x + 9) = -2x^2 + 12x - 18

  5. On regroupe les termes et on réduit :
     $C = -x^2 + 49 - 2x^2 + 12x - 18$
     $C = (-x^2 - 2x^2) + 12x + (49 - 18)$
     $C = -3x^2 + 12x + 31', '["N''oublie pas que $-(a-b)^2 = -(a^2 - 2ab + b^2)$ et qu''il faut distribuer le signe moins à tous les termes.","Pour $(a+b)(a-b)$, c''est $a^2 - b^2$.","Fais attention à la double distribution du signe moins et du coefficient."]'::jsonb, '2025-11-17T21:54:42.234179+00:00'::timestamptz, '5a1f79fbbea29a2aded0a59e70d957d781cd9ebd26b3c3d0d8719d6ed52b0858', NULL),
('7276918e-503b-4a66-9d49-3dcb9dcdaa04', 'Intégrales', 'terminale', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine une primitive $F$ de $f$ sur $\\mathbb{R}$ en utilisant une intégration par parties."],"contexte":"On considère la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x) \\sin(2x)$."}', '1. Calcul de la dérivée $f''(x)$ :
$f(x) = x \sin(2x)$
On utilise la formule de dérivation d''un produit $(uv)'' = u''v + uv''$.
Soit $u(x) = x$, donc $u''(x) = 1$.
Soit $v(x) = \sin(2x)$, donc $v''(x) = 2\cos(2x)$.
$f''(x) = 1 \cdot \sin(2x) + x \cdot (2\cos(2x)) = \sin(2x) + 2x\cos(2x)$.

2. Détermination d''une primitive $F$ de $f$ par intégration par parties :
On cherche à calculer $\int x \sin(2x) dx$.
On pose :
$u(x) = x \implies u''(x) = 1$
$v''(x) = \sin(2x) \implies v(x) = -\frac{1}{2}\cos(2x)$

La formule d''intégration par parties est $\int u(x)v''(x)dx = u(x)v(x) - \int u''(x)v(x)dx$.

$\int x \sin(2x) dx = x \left(-\frac{1}{2}\cos(2x)\right) - \int 1 \cdot \left(-\frac{1}{2}\cos(2x)\right) dx$
$= -\frac{1}{2}x\cos(2x) + \frac{1}{2} \int \cos(2x) dx$

On sait que $\int \cos(ax)dx = \frac{1}{a}\sin(ax) + C$.
Donc $\int \cos(2x) dx = \frac{1}{2}\sin(2x) + C_1$.

En substituant :
$\int x \sin(2x) dx = -\frac{1}{2}x\cos(2x) + \frac{1}{2} \left(\frac{1}{2}\sin(2x)\right) + C$
$= -\frac{1}{2}x\cos(2x) + \frac{1}{4}\sin(2x) + C$

Une primitive $F$ de $f$ est $F(x) = -\frac{1}{2}x\cos(2x) + \frac{1}{4}\sin(2x)$.', '["Pour la dérivée, pense à la formule de la dérivée d''un produit.","Pour l''intégration par parties, pose $u(x) = x$ et $v''(x) = \\sin(2x)$.","N''oublie pas que la primitive de $\\sin(ax)$ est $-\\frac{1}{a}\\cos(ax)$ et la dérivée de $\\sin(ax)$ est $a\\cos(ax)$."]'::jsonb, '2025-11-18T20:55:18.944765+00:00'::timestamptz, '7a31ca9bac0bd27418bebcf250dc7d4936e43fde19c60be8be5cdf55a11d22f6', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('634a3690-f5c8-45d7-ba65-8482cdad1430', 'Exercice soumis', 'terminale', 'Je vais faire l’exercice 1 mais je ne sais plus comment faire peux tu m’aider ?', 'En cours de correction', '[]'::jsonb, '2025-11-19T16:09:06.967019+00:00'::timestamptz, NULL, '{}'::jsonb),
('1d5ca019-1af3-41b3-b018-2b39492141fb', 'Calcul intégral', 'terminale', '{"contexte":"On considère la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x^2 + 1)e^{-x}$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine une primitive $F$ de $f$ sur $\\mathbb{R}$ en utilisant deux intégrations par parties successives."]}', '1. Calcul de la dérivée $f''(x)$ :
Soit $f(x) = (x^2 + 1)e^{-x}$. Posons $u(x) = x^2+1$ et $v(x) = e^{-x}$.
Alors $u''(x) = 2x$ et $v''(x) = -e^{-x}$.
En utilisant la formule $(uv)'' = u''v + uv''$ :
$f''(x) = (2x)e^{-x} + (x^2+1)(-e^{-x})$
$f''(x) = e^{-x}(2x - (x^2+1))$
$f''(x) = e^{-x}(-x^2 + 2x - 1)$

2. Détermination d''une primitive $F$ de $f$ en utilisant deux intégrations par parties :
On cherche $\int (x^2+1)e^{-x} dx$.

Première intégration par parties :
Posons $u_1(x) = x^2+1 \implies u_1''(x) = 2x$
Posons $v_1''(x) = e^{-x} \implies v_1(x) = -e^{-x}$

$\int (x^2+1)e^{-x} dx = -(x^2+1)e^{-x} - \int (2x)(-e^{-x}) dx$
$= -(x^2+1)e^{-x} + \int 2xe^{-x} dx$

Deuxième intégration par parties (sur $\int 2xe^{-x} dx$) :
Posons $u_2(x) = 2x \implies u_2''(x) = 2$
Posons $v_2''(x) = e^{-x} \implies v_2(x) = -e^{-x}$

$\int 2xe^{-x} dx = (2x)(-e^{-x}) - \int (2)(-e^{-x}) dx$
$= -2xe^{-x} + \int 2e^{-x} dx$
$= -2xe^{-x} - 2e^{-x}$

En remplaçant le résultat de la deuxième IPP dans la première :
$\int (x^2+1)e^{-x} dx = -(x^2+1)e^{-x} + (-2xe^{-x} - 2e^{-x}) + C$
$= -x^2e^{-x} - e^{-x} - 2xe^{-x} - 2e^{-x} + C$
$= (-x^2 - 2x - 3)e^{-x} + C$

Donc, une primitive $F$ de $f$ sur $\mathbb{R}$ est $F(x) = (-x^2 - 2x - 3)e^{-x}$.', '["Pour la dérivée, pense à la formule de dérivation d''un produit $(uv)'' = u''v + uv''$.","Pour la première intégration par parties, choisis $u(x) = x^2+1$ et $v''(x) = e^{-x}$.","Pour la deuxième intégration par parties, tu devras réutiliser la même logique avec la nouvelle intégrale."]'::jsonb, '2025-11-22T14:21:03.650503+00:00'::timestamptz, 'ee1f00630d9a03d8563b5ab25a568cd51baecd4c26e8c088e7aa5e5d8c272536', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('49addb0d-ebe9-4a19-8792-b04490fbc5cf', 'Dérivation', 'terminale', '{"questions":["Détermine l''expression de la fonction dérivée $f''(x)$.","Donne l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x_0 = 2$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ -\\frac{1}{2} \\}$ par $f(x) = \\frac{3x - 5}{2x + 1}$."}', 'Pour la dérivée :
On pose $u(x) = 3x - 5$ et $v(x) = 2x + 1$.
Alors $u''(x) = 3$ et $v''(x) = 2$.

La formule de la dérivée d''un quotient est $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$.

$f''(x) = \frac{3(2x + 1) - (3x - 5)2}{(2x + 1)^2}$
$f''(x) = \frac{6x + 3 - (6x - 10)}{(2x + 1)^2}$
$f''(x) = \frac{6x + 3 - 6x + 10}{(2x + 1)^2}$
$f''(x) = \frac{13}{(2x + 1)^2}$

Pour l''équation de la tangente en $x_0 = 2$ :
$f(2) = \frac{3(2) - 5}{2(2) + 1} = \frac{6 - 5}{4 + 1} = \frac{1}{5}$
$f''(2) = \frac{13}{(2(2) + 1)^2} = \frac{13}{(4 + 1)^2} = \frac{13}{5^2} = \frac{13}{25}$

L''équation de la tangente est $y = f''(x_0)(x - x_0) + f(x_0)$ :
$y = \frac{13}{25}(x - 2) + \frac{1}{5}$
$y = \frac{13}{25}x - \frac{26}{25} + \frac{5}{25}$
$y = \frac{13}{25}x - \frac{21}{25}$', '["Pour la dérivée d''un quotient $\\frac{u}{v}$, la formule est $f'' = \\frac{u''v - uv''}{v^2}$. Identifie correctement $u$, $v$, $u''$ et $v''$.","Pour l''équation de la tangente, utilise la formule $y = f''(x_0)(x - x_0) + f(x_0)$."]'::jsonb, '2025-11-23T13:28:46.808598+00:00'::timestamptz, '0e306e1b833e3c492d624286a9ae8b855b88338169f02a9b6452f4a65631b2e6', NULL),
('25645a38-df1f-462d-9582-a716208af410', 'Dérivation', 'Lycée', '{"questions":["Détermine l''expression de la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur l''intervalle $]-1 ; +\\infty[$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{-1\\}$ par : $$f(x) = \\frac{2x^2 - 3x + 1}{x+1}$$"}', 'Pour dériver $f(x) = \frac{2x^2 - 3x + 1}{x+1}$, on utilise la formule $(\frac{u}{v})'' = \frac{u''v - uv''}{v^2}$.

Soit $u(x) = 2x^2 - 3x + 1$, alors $u''(x) = 4x - 3$.
Soit $v(x) = x+1$, alors $v''(x) = 1$.

$$f''(x) = \frac{(4x-3)(x+1) - (2x^2-3x+1)(1)}{(x+1)^2}$$
$$f''(x) = \frac{4x^2 + 4x - 3x - 3 - 2x^2 + 3x - 1}{(x+1)^2}$$
$$f''(x) = \frac{2x^2 + 4x - 4}{(x+1)^2}$$

Pour étudier le signe de $f''(x)$ sur $]-1 ; +\infty[$, on étudie le signe du numérateur $2x^2 + 4x - 4$, car le dénominateur $(x+1)^2$ est toujours positif sur cet intervalle.

On cherche les racines du trinôme $2x^2 + 4x - 4 = 0$, soit $x^2 + 2x - 2 = 0$.
Le discriminant est $\Delta = b^2 - 4ac = 2^2 - 4(1)(-2) = 4 + 8 = 12$.
Les racines sont $x_1 = \frac{-2 - \sqrt{12}}{2} = \frac{-2 - 2\sqrt{3}}{2} = -1 - \sqrt{3}$ et $x_2 = \frac{-2 + \sqrt{12}}{2} = \frac{-2 + 2\sqrt{3}}{2} = -1 + \sqrt{3}$.

Sur l''intervalle $]-1 ; +\infty[$, on a $-1 - \sqrt{3} \approx -2.73$ (non pertinent) et $-1 + \sqrt{3} \approx 0.73$.

Le trinôme $2x^2 + 4x - 4$ est du signe de $a=2$ (positif) à l''extérieur des racines.

Donc, sur $]-1 ; -1+\sqrt{3}[$, $f''(x) < 0$.
Sur $]-1+\sqrt{3} ; +\infty[$, $f''(x) > 0$.
En $x = -1+\sqrt{3}$, $f''(x) = 0$.', '["Rappelle-toi la formule de dérivation d''un quotient : $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$","Identifie $u(x)$ et $v(x)$ puis calcule leurs dérivées $u''(x)$ et $v''(x)$.","Pour le signe de $f''(x)$, il te faudra étudier le signe du numérateur, car le dénominateur est toujours positif sur l''intervalle considéré."]'::jsonb, '2025-11-23T14:20:44.063225+00:00'::timestamptz, '2aa81cdae63d6bcbfa446c4cbe2ecf61d70485e7dd36dca125829bb3c0d39df4', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('68222726-ebae-4644-a841-130474ee90c0', 'Dérivation', 'Lycée', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{1\\}$ par : $$f(x) = \\frac{2x^2 + 3x - 1}{x - 1}$$","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine le signe de $f''(x)$ sur son ensemble de définition.","Dresse le tableau de variations de la fonction $f$."]}', '1. Calcul de la dérivée $f''(x)$ :
Soit $f(x) = \frac{u(x)}{v(x)}$ avec $u(x) = 2x^2 + 3x - 1$ et $v(x) = x - 1$.
Alors $u''(x) = 4x + 3$ et $v''(x) = 1$.
En utilisant la formule $\left(\frac{u}{v}\right)'' = \frac{u''v - uv''}{v^2}$ :
$f''(x) = \frac{(4x + 3)(x - 1) - (2x^2 + 3x - 1)(1)}{(x - 1)^2}$
$f''(x) = \frac{4x^2 - 4x + 3x - 3 - 2x^2 - 3x + 1}{(x - 1)^2}$
$f''(x) = \frac{2x^2 - 4x - 2}{(x - 1)^2}$

2. Signe de $f''(x)$ :
Le dénominateur $(x - 1)^2$ est toujours positif sur $\mathbb{R} \setminus \{1\}$.
Le signe de $f''(x)$ est donc celui de son numérateur $N(x) = 2x^2 - 4x - 2$.
Calculons le discriminant de $N(x) = 2x^2 - 4x - 2$ :
$\Delta = (-4)^2 - 4(2)(-2) = 16 + 16 = 32$.
Les racines sont $x_1 = \frac{4 - \sqrt{32}}{4} = \frac{4 - 4\sqrt{2}}{4} = 1 - \sqrt{2}$ et $x_2 = \frac{4 + \sqrt{32}}{4} = \frac{4 + 4\sqrt{2}}{4} = 1 + \sqrt{2}$.
Le trinôme $2x^2 - 4x - 2$ est positif à l''extérieur des racines et négatif entre les racines.

3. Tableau de variations de $f$ :

| $x$             | $-\infty$   | $1 - \sqrt{2}$ | $1$           | $1 + \sqrt{2}$ | $+\infty$   |
|-----------------|--------------|-----------------|---------------|-----------------|--------------|
| $f''(x)$        | $+$          | $0$             | $||$          | $0$             | $+$          |
| Variations de $f$ | $\nearrow$ | Maximum local   | $||$          | Minimum local   | $\nearrow$ |', '["Rappelle-toi la formule de dérivation d''un quotient : $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$.","Identifie $u(x)$ et $v(x)$ puis calcule $u''(x)$ et $v''(x)$.","Pour le signe de $f''(x)$, étudie le signe du numérateur et du dénominateur séparément."]'::jsonb, '2025-11-23T14:23:20.856762+00:00'::timestamptz, '0d4f186d447375650cd11af38b2995d5c96f6789ef98a64044247b6d236387e2', NULL),
('8ce77d0d-433e-4084-9219-ce88400e41f3', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ -\\frac{1}{3} \\}$ par : $$f(x) = \\frac{4x - 7}{3x + 1}$$","questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule les dérivées $u''(x)$ et $v''(x)$.","Applique la formule de la dérivée d''un quotient pour trouver l''expression de $f''(x)$.","Simplifie au maximum l''expression de $f''(x)$.","Détermine le signe de $f''(x)$ sur son ensemble de définition."]}', '1. Identification de $u(x)$ et $v(x)$ : \\n   $u(x) = 4x - 7$\\n   $v(x) = 3x + 1$\\n\\n2. Calcul des dérivées $u''(x)$ et $v''(x)$ : \\n   $u''(x) = 4$\\n   $v''(x) = 3$\\n\\n3. Application de la formule de la dérivée d''un quotient : \\n   $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$\\n   $f''(x) = \frac{4(3x + 1) - (4x - 7)(3)}{(3x + 1)^2}$\\n\\n4. Simplification de l''expression de $f''(x)$ : \\n   $f''(x) = \frac{12x + 4 - (12x - 21)}{(3x + 1)^2}$\\n   $f''(x) = \frac{12x + 4 - 12x + 21}{(3x + 1)^2}$\\n   $f''(x) = \frac{25}{(3x + 1)^2}$\\n\\n5. Détermination du signe de $f''(x)$ : \\n   Pour tout $x \in \mathbb{R} \setminus \{ -\frac{1}{3} \}$, on a $(3x + 1)^2 > 0$.\\n   Le numérateur $25$ est positif. \\n   Donc, $f''(x) > 0$ sur $\mathbb{R} \setminus \{ -\frac{1}{3} \}$.', '["La formule de la dérivée d''un quotient est $(u/v)'' = (u''v - uv'')/v^2$.","N''oublie pas les parenthèses lors de l''application de la formule.","Le dénominateur $(3x+1)^2$ est toujours positif sur l''ensemble de définition.","Le signe de $f''(x)$ dépendra uniquement du numérateur après simplification."]'::jsonb, '2025-11-23T14:23:55.720978+00:00'::timestamptz, '6bc172c74e48296f7e67490e3489bfdb0b02a129b0464a87c45e8b7730e0cff9', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('357c9302-450c-43f8-ad99-bd35804c06a9', 'Fonctions', 'premiere', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^3 - 3x^2 + 2$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de la dérivée $f''(x)$ selon les valeurs de $x$.","Dresse le tableau de variations de la fonction $f$.","Calcule les valeurs exactes des extremums locaux de $f$.","Donne l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=1$."]}', '1. Calcul de la dérivée $f''(x)$ :
$f(x) = x^3 - 3x^2 + 2$
$f''(x) = 3x^2 - 3 \times 2x + 0$
$f''(x) = 3x^2 - 6x$

2. Étude du signe de la dérivée $f''(x)$ :
On factorise $f''(x)$ : $f''(x) = 3x(x - 2)$.
Les racines sont $x=0$ et $x=2$.

Tableau de signes de $f''(x)$ :

| $x$             | $-\infty$ | $0$ | $2$ | $+ \infty$ |
|------------------|-----------|-----|-----|-------------|
| Signe de $3x$    | $-$       | $0$ | $+$ | $+$         |
| Signe de $x-2$   | $-$       | $-$ | $0$ | $+$         |
| Signe de $f''(x)$ | $+$       | $0$ | $-$ | $0$ | $+$         |

3. Tableau de variations de la fonction $f$ :

| $x$             | $-\infty$ | $0$ | $2$ | $+ \infty$ |
|------------------|-----------|-----|-----|-------------|
| Signe de $f''(x)$ | $+$       | $0$ | $-$ | $0$ | $+$         |
| Variations de $f$| Croissante| $f(0)$ | Décroissante| $f(2)$ | Croissante  |

4. Calcul des extremums locaux de $f$ :
$f(0) = 0^3 - 3(0)^2 + 2 = 2$. C''est un maximum local.
$f(2) = 2^3 - 3(2)^2 + 2 = 8 - 3(4) + 2 = 8 - 12 + 2 = -2$. C''est un minimum local.

5. Équation de la tangente à la courbe de $f$ au point d''abscisse $x=1$ :
On a $a=1$.
$f(1) = 1^3 - 3(1)^2 + 2 = 1 - 3 + 2 = 0$.
$f''(1) = 3(1)^2 - 6(1) = 3 - 6 = -3$.
L''équation de la tangente est $y = f''(1)(x-1) + f(1)$.
$y = -3(x-1) + 0$
$y = -3x + 3$.', '["Pour la dérivée, rappelle-toi les règles de dérivation des fonctions puissances : $(x^n)'' = nx^{n-1}$.","Pour le signe de la dérivée, tu peux factoriser $f''(x)$ et faire un tableau de signes.","Les extremums locaux se trouvent là où la dérivée s''annule et change de signe.","L''équation de la tangente à la courbe de $f$ au point d''abscisse $a$ est donnée par $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-11-26T15:15:22.207687+00:00'::timestamptz, '6a8041573ba4b0a88d9a0e9f1926350454a9917ada1aff7e46bc683095363af6', NULL),
('40a874c6-6d2c-45b7-bc53-1756e85ca047', 'Dérivation et tangentes', 'premiere', '{"contexte":"Soient les deux paraboles d''équations respectives $P_1: y = x^2 + x + 1$ et $P_2: y = -x^2 + 5x - 8$.","questions":["Montre que les paraboles $P_1$ et $P_2$ n''ont aucun point commun.","Soit $T_1$ la tangente à $P_1$ au point d''abscisse $a$. Détermine l''équation de $T_1$ en fonction de $a$.","Soit $T_2$ la tangente à $P_2$ au point d''abscisse $b$. Détermine l''équation de $T_2$ en fonction de $b$.","Démontre qu''il existe une tangente commune aux deux paraboles. Tu chercheras les valeurs de $a$ et $b$ correspondantes.","Donne l''équation de cette tangente commune."]}', '1. Montrer que les paraboles n''ont aucun point commun :
On cherche les points d''intersection en résolvant l''équation $x^2 + x + 1 = -x^2 + 5x - 8$.
$2x^2 - 4x + 9 = 0$.
Calculons le discriminant : $\Delta = b^2 - 4ac = (-4)^2 - 4(2)(9) = 16 - 72 = -56$.
Puisque $\Delta < 0$, l''équation n''a pas de solution réelle. Les deux paraboles n''ont donc aucun point commun.

2. Équation de $T_1$, tangente à $P_1$ au point d''abscisse $a$ :
Soit $f_1(x) = x^2 + x + 1$. Alors $f_1''(x) = 2x + 1$.
L''équation de $T_1$ est $y = f_1''(a)(x-a) + f_1(a)$.
$y = (2a+1)(x-a) + (a^2+a+1)$
$y = (2a+1)x - a(2a+1) + a^2+a+1$
$y = (2a+1)x - 2a^2 - a + a^2 + a + 1$
$y = (2a+1)x - a^2 + 1$.

3. Équation de $T_2$, tangente à $P_2$ au point d''abscisse $b$ :
Soit $f_2(x) = -x^2 + 5x - 8$. Alors $f_2''(x) = -2x + 5$.
L''équation de $T_2$ est $y = f_2''(b)(x-b) + f_2(b)$.
$y = (-2b+5)(x-b) + (-b^2+5b-8)$
$y = (-2b+5)x - b(-2b+5) - b^2+5b-8$
$y = (-2b+5)x + 2b^2 - 5b - b^2 + 5b - 8$
$y = (-2b+5)x + b^2 - 8$.

4. Démontrer qu''il existe une tangente commune :
Pour que $T_1$ et $T_2$ soient la même droite, leurs coefficients directeurs et leurs ordonnées à l''origine doivent être égaux.
On a donc le système :
(1) $2a+1 = -2b+5$
(2) $-a^2+1 = b^2-8$

De (1) : $2a = -2b+4 \Rightarrow a = -b+2$.
Substituons $a$ dans (2) :
$-(-b+2)^2 + 1 = b^2-8$
$-(b^2 - 4b + 4) + 1 = b^2-8$
$-b^2 + 4b - 4 + 1 = b^2-8$
$-b^2 + 4b - 3 = b^2-8$
$0 = 2b^2 - 4b - 5$.

Calculons le discriminant de cette équation du second degré en $b$ :
$\Delta_b = (-4)^2 - 4(2)(-5) = 16 + 40 = 56$.
$b = \frac{4 \pm \sqrt{56}}{4} = \frac{4 \pm 2\sqrt{14}}{4} = 1 \pm \frac{\sqrt{14}}{2}$.

Il existe deux valeurs réelles pour $b$, donc il existe deux tangentes communes. Prenons la première valeur de $b$ :
$b_1 = 1 + \frac{\sqrt{14}}{2}$.
Alors $a_1 = -b_1+2 = -(1 + \frac{\sqrt{14}}{2})+2 = 1 - \frac{\sqrt{14}}{2}$.

5. Équation de cette tangente commune :
Utilisons $a_1$ dans l''équation de $T_1$ :
$y = (2a_1+1)x - a_1^2 + 1$
$y = (2(1 - \frac{\sqrt{14}}{2})+1)x - (1 - \frac{\sqrt{14}}{2})^2 + 1$
$y = (2 - \sqrt{14} + 1)x - (1 - \sqrt{14} + \frac{14}{4}) + 1$
$y = (3 - \sqrt{14})x - (1 - \sqrt{14} + 3.5) + 1$
$y = (3 - \sqrt{14})x - 4.5 + \sqrt{14} + 1$
$y = (3 - \sqrt{14})x - 3.5 + \sqrt{14}$.

Ou utilisons $b_1$ dans l''équation de $T_2$ :
$y = (-2b_1+5)x + b_1^2 - 8$
$y = (-2(1 + \frac{\sqrt{14}}{2})+5)x + (1 + \frac{\sqrt{14}}{2})^2 - 8$
$y = (-2 - \sqrt{14} + 5)x + (1 + \sqrt{14} + \frac{14}{4}) - 8$
$y = (3 - \sqrt{14})x + (1 + \sqrt{14} + 3.5) - 8$
$y = (3 - \sqrt{14})x + 4.5 + \sqrt{14} - 8$
$y = (3 - \sqrt{14})x - 3.5 + \sqrt{14}$.

L''équation de la tangente commune est $y = (3 - \sqrt{14})x - 3.5 + \sqrt{14}$.
(On pourrait aussi donner la deuxième tangente commune en utilisant l''autre valeur de $b$.)', '["Pour montrer que les paraboles n''ont aucun point commun, essaie de résoudre l''équation $x^2 + x + 1 = -x^2 + 5x - 8$. Que se passe-t-il si le discriminant est négatif ?","L''équation d''une tangente à la courbe d''une fonction $f$ au point d''abscisse $a$ est $y = f''(a)(x-a) + f(a)$.","Deux droites sont confondues (donc une tangente commune) si elles ont le même coefficient directeur et la même ordonnée à l''origine. Tu obtiendras un système de deux équations à deux inconnues ($a$ et $b$).","Pour résoudre le système, tu peux exprimer $a$ en fonction de $b$ (ou l''inverse) à partir de la première équation (celle des coefficients directeurs), puis substituer dans la deuxième (celle des ordonnées à l''origine)."]'::jsonb, '2025-11-26T17:42:43.993292+00:00'::timestamptz, 'aca0cea02c71b7e9282e923d6b3ae2784d58dcf979c3c6ae1c973b6f3a702ecc', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('49da7858-46ae-42ab-a2fc-709f34c14370', 'Fonctions', 'premiere', '{"questions":["Calcule la fonction dérivée $f''(x)$ de $f(x)$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}$.","Dresse le tableau de variations complet de la fonction $f$.","Détermine les extremums locaux de $f$ (valeurs et positions)."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^3 - 3x^2 - 9x + 2$."}', '1. Calcul de la fonction dérivée $f''(x)$ :
$f(x) = x^3 - 3x^2 - 9x + 2$
$f''(x) = 3x^2 - 3(2x) - 9(1) + 0$
$f''(x) = 3x^2 - 6x - 9$

2. Étude du signe de $f''(x)$ :
On cherche les racines de $f''(x) = 3x^2 - 6x - 9 = 0$.
En divisant par 3 : $x^2 - 2x - 3 = 0$.
Calcul du discriminant $\Delta = (-2)^2 - 4(1)(-3) = 4 + 12 = 16$.
Les racines sont $x_1 = \frac{-(-2) - \sqrt{16}}{2(1)} = \frac{2 - 4}{2} = -1$
Et $x_2 = \frac{-(-2) + \sqrt{16}}{2(1)} = \frac{2 + 4}{2} = 3$.

$f''(x)$ est un trinôme du second degré avec $a=3 > 0$. Il est donc positif à l''extérieur des racines et négatif entre les racines.

| $x$             | $-\infty$ |       $-1$        |        $3$        | $+\infty$ |
| :-------------- | :-------- | :---------------: | :---------------: | :-------- |
| Signe de $f''(x)$ |   $+$     |         $0$       |         $-$       |     $0$   |    $+$    |

3. Tableau de variations complet de $f$ :
$f(-1) = (-1)^3 - 3(-1)^2 - 9(-1) + 2 = -1 - 3(1) + 9 + 2 = -1 - 3 + 9 + 2 = 7$
$f(3) = (3)^3 - 3(3)^2 - 9(3) + 2 = 27 - 3(9) - 27 + 2 = 27 - 27 - 27 + 2 = -25$

| $x$             | $-\infty$ |       $-1$        |        $3$        | $+\infty$ |
| :-------------- | :-------- | :---------------: | :---------------: | :-------- |
| Signe de $f''(x)$ |   $+$     |         $0$       |         $-$       |     $0$   |    $+$    |
| Variations de $f$ | $\nearrow$ |       $7$         |    $\searrow$    |   $-25$   | $\nearrow$ |

4. Détermination des extremums locaux :
La fonction $f$ admet un maximum local en $x = -1$, dont la valeur est $f(-1) = 7$.
La fonction $f$ admet un minimum local en $x = 3$, dont la valeur est $f(3) = -25$.', '["Pour calculer la dérivée d''un polynôme, utilise la formule $(x^n)'' = nx^{n-1}$.","Pour étudier le signe de $f''(x)$, tu devras résoudre une inéquation du second degré $f''(x) > 0$. Pense au discriminant et au signe d''un trinôme.","Le tableau de variations doit inclure les intervalles où la fonction est croissante ou décroissante, ainsi que les valeurs des extremums locaux.","Les extremums locaux se trouvent aux points où la dérivée s''annule et change de signe. Calcule les valeurs de $f(x)$ pour ces points."]'::jsonb, '2025-11-26T18:37:04.526133+00:00'::timestamptz, '253cc4d003f8e7ff585af0ed5befa706ff46fddc9c944e5206d29e5bccecc7d2', NULL),
('e49b05d0-ecc6-4734-b641-576bdd757f06', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $]- \\infty ; -\\frac{2}{3}[ \\cup ]-\\frac{2}{3} ; +\\infty[$ par : $$f(x) = \\frac{5x - 1}{3x + 2}$$","questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$ et calcule leurs dérivées respectives.","Applique la formule de la dérivée d''un quotient pour trouver l''expression de $f''(x)$.","Simplifie au maximum l''expression de $f''(x)$."]}', '1. Identification de $u(x)$ et $v(x)$ et calcul de leurs dérivées :
$u(x) = 5x - 1 \implies u''(x) = 5$
$v(x) = 3x + 2 \implies v''(x) = 3$

2. Application de la formule de la dérivée d''un quotient :
$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{(v(x))^2}$
$f''(x) = \frac{5(3x + 2) - (5x - 1)3}{(3x + 2)^2}$

3. Simplification de l''expression de $f''(x)$ :
$f''(x) = \frac{15x + 10 - (15x - 3)}{(3x + 2)^2}$
$f''(x) = \frac{15x + 10 - 15x + 3}{(3x + 2)^2}$
$f''(x) = \frac{13}{(3x + 2)^2}$', '["La formule de la dérivée d''un quotient est $(u/v)'' = \\frac{u''v - uv''}{v^2}$.","Fais attention aux signes lors de la simplification du numérateur.","N''oublie pas de laisser le dénominateur sous forme de carré."]'::jsonb, '2025-11-29T17:09:10.116787+00:00'::timestamptz, '39106796cd549a6c3c25b366227f69433660fa2402df1c2cdf1772b197ffa7eb', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('b26313ab-56bf-4ca6-8c98-19127109e237', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ -\\frac{5}{2} \\}$ par : $$f(x) = \\frac{2x - 3}{5 + 2x}$$","questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$ et calcule leurs dérivées respectives.","Applique la formule de la dérivée d''un quotient pour trouver l''expression de $f''(x)$.","Simplifie au maximum l''expression de $f''(x)$."]}', '1. Identification et dérivées :
Soit $u(x) = 2x - 3$, alors $u''(x) = 2$.
Soit $v(x) = 5 + 2x$, alors $v''(x) = 2$.

2. Application de la formule de la dérivée d''un quotient :
$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$
$f''(x) = \frac{2(5 + 2x) - (2x - 3)2}{(5 + 2x)^2}$

3. Simplification :
$f''(x) = \frac{10 + 4x - (4x - 6)}{(5 + 2x)^2}$
$f''(x) = \frac{10 + 4x - 4x + 6}{(5 + 2x)^2}$
$f''(x) = \frac{16}{(5 + 2x)^2}$', '["La formule de la dérivée d''un quotient est $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas de bien identifier $u(x)$, $v(x)$, $u''(x)$ et $v''(x)$ avant d''appliquer la formule.","Sois attentif aux signes lors du développement du numérateur."]'::jsonb, '2025-11-29T17:19:38.484986+00:00'::timestamptz, 'd774915c6b675fd9366fb4761220776b6d027d988e27112f4714e886077ae93d', NULL),
('568a2285-a462-4efe-a14b-9a09f51f95c7', 'Dérivation (Quotient)', 'Lycée', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ -\\frac{1}{2} \\}$ par $f(x) = \\frac{2x - 3}{4x + 2}$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine le signe de $f''(x)$ sur son ensemble de définition."]}', 'Pour dériver la fonction $f(x) = \frac{2x - 3}{4x + 2}$, on utilise la formule de dérivation d''un quotient : $f''(x) = \frac{u''v - uv''}{v^2}$.
Ici, $u(x) = 2x - 3$ et $v(x) = 4x + 2$.
Donc $u''(x) = 2$ et $v''(x) = 4$.
$f''(x) = \frac{2(4x + 2) - (2x - 3)4}{(4x + 2)^2}$
$f''(x) = \frac{8x + 4 - (8x - 12)}{(4x + 2)^2}$
$f''(x) = \frac{8x + 4 - 8x + 12}{(4x + 2)^2}$
$f''(x) = \frac{16}{(4x + 2)^2}$

Pour le signe de $f''(x)$ :
Le numérateur $16$ est toujours positif.
Le dénominateur $(4x + 2)^2$ est un carré, il est donc toujours positif (et non nul sur l''ensemble de définition).
Par conséquent, $f''(x) > 0$ sur $\mathbb{R} \setminus \{ -\frac{1}{2} \}$.', '["La formule de dérivation d''un quotient est $(u/v)'' = (u''v - uv'')/v^2$.","Identifie $u(x)$ et $v(x)$ puis leurs dérivées.","Pour le signe, un carré est toujours positif."]'::jsonb, '2025-11-29T17:49:06.047901+00:00'::timestamptz, '8c1d713ef9c807ebb70b1f29dd5feb43d83b8474d5420a9e4e5fbc2761d1d425', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('f908b5a9-8c53-4405-8c72-734d88e4ff40', 'Dérivation', 'Lycée', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x^2 - 2x + 1) e^x$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=0$."]}', '1. Calcul de la dérivée $f''(x)$ :
On a $f(x) = (3x^2 - 2x + 1) e^x$. C''est un produit de fonctions de la forme $u(x)v(x)$.
Soit $u(x) = 3x^2 - 2x + 1$, alors $u''(x) = 6x - 2$.
Soit $v(x) = e^x$, alors $v''(x) = e^x$.
En utilisant la formule $(uv)'' = u''v + uv''$ :
$f''(x) = (6x - 2)e^x + (3x^2 - 2x + 1)e^x$
$f''(x) = e^x (6x - 2 + 3x^2 - 2x + 1)$
$f''(x) = e^x (3x^2 + 4x - 1)$

2. Détermination de l''équation de la tangente au point d''abscisse $x=0$ :
On utilise la formule $y = f''(a)(x-a) + f(a)$. Ici $a=0$.
Calculons $f(0)$ :
$f(0) = (3(0)^2 - 2(0) + 1)e^0 = (0 - 0 + 1) 	imes 1 = 1$.
Calculons $f''(0)$ :
$f''(0) = e^0 (3(0)^2 + 4(0) - 1) = 1 (0 + 0 - 1) = -1$.
L''équation de la tangente est donc :
$y = -1(x - 0) + 1$
$y = -x + 1$.', '["Rappelle-toi la formule de dérivation d''un produit de fonctions : $(uv)'' = u''v + uv''$.","Identifie $u(x)$ et $v(x)$ dans l''expression de $f(x)$.","La dérivée de $e^x$ est $e^x$.","La dérivée d''un polynôme de la forme $ax^n + bx + c$ est $nax^{n-1} + b$.","L''équation d''une tangente en un point d''abscisse $a$ est $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-11-29T18:07:29.770634+00:00'::timestamptz, '38ab2253193f667d4cd919ea421700c69b5df6e77dfb3b7ef910d9039a609dc8', NULL),
('8afee4ed-3333-4da3-a3a1-efc7f78df992', 'Dérivation', 'Lycée', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x - 3)e^x$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ et déduis-en les variations de la fonction $f$."]}', '1. Calcul de la dérivée $f''(x)$ :
Nous avons $f(x) = (2x - 3)e^x$. C''est un produit de fonctions $u(x) = 2x - 3$ et $v(x) = e^x$.
Alors $u''(x) = 2$ et $v''(x) = e^x$.
En utilisant la formule $(uv)'' = u''v + uv''$ :
$f''(x) = 2e^x + (2x - 3)e^x$
$f''(x) = e^x (2 + 2x - 3)$
$f''(x) = e^x (2x - 1)$

2. Étude du signe de $f''(x)$ et variations de $f$ :
Nous savons que $e^x > 0$ pour tout $x \in \mathbb{R}$.
Donc le signe de $f''(x)$ est le même que le signe de $(2x - 1)$.
$2x - 1 = 0 \iff 2x = 1 \iff x = \frac{1}{2}$
Si $x < \frac{1}{2}$, alors $2x - 1 < 0$, donc $f''(x) < 0$.
Si $x > \frac{1}{2}$, alors $2x - 1 > 0$, donc $f''(x) > 0$.

Tableau de variations :
$x$             $-\infty$         $\frac{1}{2}$         $+\infty$
$2x - 1$          $-$           $0$           $+
$e^x$             $+$           $|$           $+
$f''(x)$           $-$           $0$           $+
$f(x)$        Décroissante    Minimum    Croissante

La fonction $f$ est décroissante sur $]-\infty; \frac{1}{2}]$ et croissante sur $[rac{1}{2}; +\infty[$.', '["Rappelle-toi la formule de dérivation d''un produit de fonctions : $(uv)'' = u''v + uv''$.","Pour le signe de $f''(x)$, souviens-toi que $e^x$ est toujours positif.","La variation de $f$ dépend du signe de $f''(x)$."]'::jsonb, '2025-11-29T18:10:10.985478+00:00'::timestamptz, '2ac67ffac72c8f5d7693861357aa581dccba6e6864d4720c519adc0419071f4f', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('a2567c72-2498-4863-9294-62245b7fb06d', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ \\frac{1}{2} \\}$ par : $$f(x) = \\frac{4x + 5}{1 - 2x}$$","questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule les dérivées $u''(x)$ et $v''(x)$.","Écris la formule générale de la dérivée d''un quotient $\\left(\\frac{u}{v}\\right)''$.","Applique cette formule pour trouver l''expression de $f''(x)$.","Simplifie au maximum l''expression de $f''(x)$."]}', '1. Identification de $u(x)$ et $v(x)$ :
$u(x) = 4x + 5$
$v(x) = 1 - 2x$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
$u''(x) = 4$
$v''(x) = -2$

3. Formule de la dérivée d''un quotient :
$\left(\frac{u}{v}\right)'' = \frac{u''v - uv''}{v^2}$

4. Application de la formule :
$f''(x) = \frac{(4)(1 - 2x) - (4x + 5)(-2)}{(1 - 2x)^2}$

5. Simplification de $f''(x)$ :
$f''(x) = \frac{4 - 8x - (-8x - 10)}{(1 - 2x)^2}$
$f''(x) = \frac{4 - 8x + 8x + 10}{(1 - 2x)^2}$
$f''(x) = \frac{14}{(1 - 2x)^2}$', '["La fonction $u(x)$ est le numérateur, et $v(x)$ est le dénominateur.","Rappelle-toi que la dérivée de $ax+b$ est $a$.","La formule est $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$.","Fais attention aux signes lors de l''application de la formule.","Développe le numérateur et regroupe les termes similaires."]'::jsonb, '2025-11-29T18:19:15.994177+00:00'::timestamptz, '106526b5df49f258522b3e9c8bb15116d0aa2b7ebc6c7d354bcfbd76de9ec8f8', NULL),
('8e879298-a0ed-47ca-8ab7-785ed7c81ebe', 'Dérivation', 'terminale', '{"questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule les dérivées $u''(x)$ et $v''(x)$.","Applique la formule de la dérivée d''un quotient pour trouver l''expression de $f''(x)$.","Simplifie au maximum l''expression de $f''(x)$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R} \\setminus \\{ -\\frac{3}{2} \\}$ par : $$f(x) = \\frac{2x - 7}{3 + 2x}$$"}', '1. Identification de $u(x)$ et $v(x)$ :
$u(x) = 2x - 7$
$v(x) = 3 + 2x$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
$u''(x) = 2$
$v''(x) = 2$

3. Application de la formule :
$f''(x) = \frac{(2)(3 + 2x) - (2x - 7)(2)}{(3 + 2x)^2}$

4. Simplification de $f''(x)$ :
$f''(x) = \frac{6 + 4x - (4x - 14)}{(3 + 2x)^2}$
$f''(x) = \frac{6 + 4x - 4x + 14}{(3 + 2x)^2}$
$f''(x) = \frac{20}{(3 + 2x)^2}$', '["La fonction $u(x)$ est le numérateur, et $v(x)$ est le dénominateur.","La formule de la dérivée d''un quotient est $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$.","Fais attention aux signes lors de l''application de la formule.","Développe le numérateur et regroupe les termes similaires."]'::jsonb, '2025-11-29T18:21:46.065067+00:00'::timestamptz, '72a8386c8dbc3a24ba55b9e027581765e761b2cd756b5ebaf7b9dae9d0b1edbf', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('7ba83577-ee59-48fc-b122-2f916463eb10', 'Dérivation', 'terminale', '{"questions":["Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule les dérivées $u''(x)$ et $v''(x)$.","Écris la formule de la dérivée d''un quotient.","Applique la formule de la dérivée d''un quotient pour calculer $f''(x)$.","Simplifie l''expression de $f''(x)$."],"contexte":"Soit la fonction $f$ définie sur $I = \\mathbb{R}\\setminus\\{-1\\}$ par $f(x) = \\frac{2x+3}{x+1}$."}', '1. Identification de $u(x)$ et $v(x)$ :
   $u(x) = 2x+3$
   $v(x) = x+1$

2. Calcul des dérivées $u''(x)$ et $v''(x)$ :
   $u''(x) = 2$
   $v''(x) = 1$

3. Formule de la dérivée d''un quotient :
   $$\left(\frac{u}{v}\right)'' = \frac{u''v - uv''}{v^2}$$

4. Application de la formule :
   $$f''(x) = \frac{2(x+1) - (2x+3)(1)}{(x+1)^2}$$

5. Simplification de l''expression :
   $$f''(x) = \frac{2x+2 - 2x-3}{(x+1)^2}$$
   $$f''(x) = \frac{-1}{(x+1)^2}$$', '["La fonction $u(x)$ est le numérateur et $v(x)$ est le dénominateur.","Pour dériver $ax+b$, la dérivée est $a$.","La formule est $$\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$$","Remplace $u$, $v$, $u''$ et $v''$ dans la formule.","Développe le numérateur et regroupe les termes similaires."]'::jsonb, '2025-11-30T10:44:07.036886+00:00'::timestamptz, '061ae866ddfc38f6628aed333d2f06d744be3b7a2721bd2d67d109aeae5a6d08', NULL),
('8af36097-c724-4844-8230-24addc1ba367', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{1}{x} + x$.","questions":["Exprime $f(x)$ sous la forme d''un quotient.","Identifie les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Calcule les dérivées $u''(x)$ et $v''(x)$.","Donne la formule de la dérivée d''un quotient.","Applique la formule pour calculer $f''(x)$.","Simplifie au maximum l''expression de $f''(x)$."]}', '1. Expression de $f(x)$ sous forme d''un quotient :
$$f(x) = \frac{1}{x} + x = \frac{1}{x} + \frac{x^2}{x} = \frac{1+x^2}{x}$$ 
2. Identification de $u(x)$ et $v(x)$ :
Soit $u(x) = 1+x^2$ et $v(x) = x$.

3. Calcul des dérivées $u''(x)$ et $v''(x)$ :
$u''(x) = 2x$
$v''(x) = 1$

4. Formule de la dérivée d''un quotient :
$$(\frac{u}{v})'' = \frac{u''v - uv''}{v^2}$$

5. Application de la formule pour calculer $f''(x)$ :
$$f''(x) = \frac{(2x)(x) - (1+x^2)(1)}{x^2}$$ 
$$f''(x) = \frac{2x^2 - (1+x^2)}{x^2}$$ 
$$f''(x) = \frac{2x^2 - 1 - x^2}{x^2}$$ 

6. Simplification de l''expression de $f''(x)$ :
$$f''(x) = \frac{x^2 - 1}{x^2}$$', '["Pour la première question, pense à mettre les termes sur un dénominateur commun.","La fonction $f(x) = \\frac{1}{x} + x$ peut s''écrire $f(x) = \\frac{1}{x} + \\frac{x}{1}$.","N''oublie pas que la dérivée de $x$ est $1$ et celle de $1$ est $0$.","La formule est $(\\frac{u}{v})'' = \\frac{u''v - uv''}{v^2}$","Fais attention aux signes lors de la simplification."]'::jsonb, '2025-11-30T11:21:07.022135+00:00'::timestamptz, '7fda3b61957a34b5391c281cab9c83f63ff38dcab08542bb89d5127bd1400034', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('e7b95ea9-610b-4f27-863c-37c8aad812e8', 'Exercice soumis', 'premiere', 'genere moi un probleme complet avec une etude de fonctions de tangeantes indetermine est une optimisation a la fin niveau premiere', 'En cours de correction', '[]'::jsonb, '2025-12-03T12:52:13.010415+00:00'::timestamptz, NULL, '{}'::jsonb),
('c377f15f-664e-4660-9f31-2864f023ab1b', 'Exercice soumis', 'seconde', 'Exercice 5', 'En cours de correction', '[]'::jsonb, '2025-12-03T20:40:47.451012+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('569d3c74-42f9-4766-b4a6-c4f4b8737577', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $I = \\mathbb{R}\\setminus\\{2\\}$ par $f(x) = \\frac{3x-5}{2x-4}$.","questions":["Identifie les fonctions $u(x)$ et $v(x)$ qui composent $f(x)$.","Calcule les dérivées $u''(x)$ et $v''(x)$.","Applique la formule de la dérivée d''un quotient pour trouver l''expression de $f''(x)$.","Simplifie au maximum l''expression de $f''(x)$."]}', 'Identifions $u(x)$ et $v(x)$ :
$u(x) = 3x-5 \implies u''(x) = 3$
$v(x) = 2x-4 \implies v''(x) = 2$

Appliquons la formule de la dérivée d''un quotient :
$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{(v(x))^2}$
$f''(x) = \frac{3(2x-4) - (3x-5)(2)}{(2x-4)^2}$

Développons le numérateur :
$3(2x-4) = 6x - 12$
$(3x-5)(2) = 6x - 10$

Donc le numérateur est :
$(6x - 12) - (6x - 10) = 6x - 12 - 6x + 10 = -2$

L''expression simplifiée de $f''(x)$ est :
$$f''(x) = \frac{-2}{(2x-4)^2}$$', '["La formule de la dérivée d''un quotient est $$\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$$","Fais attention aux signes lors du calcul du numérateur.","N''oublie pas de laisser le dénominateur sous la forme $(2x-4)^2$."]'::jsonb, '2025-12-04T13:48:50.510685+00:00'::timestamptz, 'f6f6a6d148d245b3c11f9f4f53e8c113cd6905aa5fbab630c64a6b8c0654d917', NULL),
('2f680d62-2880-4394-9fcb-9f24f96a7f6a', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x^2 - 2x + 1)^4$.","questions":["Identifie la forme de la fonction $f(x)$ parmi les formes usuelles de dérivées (par exemple, $u^n$, $\\sqrt{u}$, $e^u$, $\\ln(u)$).","Définis les fonctions $u(x)$ et $n$ (si applicable) qui composent $f(x)$ selon la forme identifiée.","Calcule la dérivée $u''(x)$ de la fonction $u(x)$.","Applique la formule de dérivation correspondante pour trouver l''expression de $f''(x)$.","Simplifie au maximum l''expression de $f''(x)$."]}', '1. La fonction $f(x)$ est de la forme $u^n$.

2. On a $u(x) = 3x^2 - 2x + 1$ et $n = 4$.

3. La dérivée de $u(x)$ est $u''(x) = 6x - 2$.

4. La formule de dérivation pour $u^n$ est $(u^n)'' = n \cdot u^{n-1} \cdot u''$.
Donc $f''(x) = 4 \cdot (3x^2 - 2x + 1)^{4-1} \cdot (6x - 2)$.
$f''(x) = 4 \cdot (3x^2 - 2x + 1)^3 \cdot (6x - 2)$.

5. On peut factoriser par 2 dans $(6x - 2)$ :
$f''(x) = 4 \cdot (3x^2 - 2x + 1)^3 \cdot 2(3x - 1)$.
$f''(x) = 8(3x - 1)(3x^2 - 2x + 1)^3$.', '["Rappelle-toi la formule de dérivation pour une fonction de la forme $u^n$.","La dérivée de $u^n$ est $n \\cdot u^{n-1} \\cdot u''$.","N''oublie pas de bien dériver $u(x)$ en premier."]'::jsonb, '2025-12-04T14:05:57.167276+00:00'::timestamptz, '1648db1037bb6c0404947e30d6fa0fc53fcfb38b7c42bc6f31362161648d715d', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('204cd1bc-c1d5-4203-a612-653f94b4dc0f', 'Limites de fonctions', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{x^2 - 3x + 2}{x}$ et la fonction $g$ définie sur $]0 ; +\\infty[$ par $g(x) = \\frac{\\ln(x)}{x} - 2x$.","questions":["Calcule la limite de $f(x)$ lorsque $x$ tend vers $0$ en justifiant le résultat.","Détermine les limites de $f(x)$ lorsque $x$ tend vers $+\\infty$ et lorsque $x$ tend vers $-\\infty$. Interprète graphiquement ces résultats.","Calcule la limite de $g(x)$ lorsque $x$ tend vers $0^+$ en justifiant le résultat.","Détermine la limite de $g(x)$ lorsque $x$ tend vers $+\\infty$."]}', '1. Limite de $f(x)$ lorsque $x \to 0$: \\nOn a $f(x) = \frac{x^2 - 3x + 2}{x}$. \\nLorsque $x \to 0$, le numérateur $x^2 - 3x + 2 \to 2$. \\nLe dénominateur $x \to 0$. \\nIl faut étudier le signe du dénominateur : \\nSi $x \to 0^+$ (par valeurs positives), alors $x > 0$. Donc $\lim_{x \to 0^+} f(x) = +\infty$. \\nSi $x \to 0^-$ (par valeurs négatives), alors $x < 0$. Donc $\lim_{x \to 0^-} f(x) = -\infty$. \\n \\n2. Limites de $f(x)$ lorsque $x \to +\infty$ et $x \to -\infty$: \\nPour $x \to +\infty$, $f(x) = \frac{x^2 - 3x + 2}{x} = \frac{x^2(1 - \frac{3}{x} + \frac{2}{x^2})}{x} = x(1 - \frac{3}{x} + \frac{2}{x^2})$. \\nLorsque $x \to +\infty$, $1 - \frac{3}{x} + \frac{2}{x^2} \to 1$. \\nDonc $\lim_{x \to +\infty} f(x) = +\infty$. \\n \\nPour $x \to -\infty$, $f(x) = x(1 - \frac{3}{x} + \frac{2}{x^2})$. \\nLorsque $x \to -\infty$, $1 - \frac{3}{x} + \frac{2}{x^2} \to 1$. \\nDonc $\lim_{x \to -\infty} f(x) = -\infty$. \\n \\nInterprétation graphique : La droite d''équation $x=0$ (l''axe des ordonnées) est une asymptote verticale à la courbe représentative de $f$. \\n \\n3. Limite de $g(x)$ lorsque $x \to 0^+$: \\nOn a $g(x) = \frac{\ln(x)}{x} - 2x$. \\nLorsque $x \to 0^+$, $\ln(x) \to -\infty$. \\nDonc $\lim_{x \to 0^+} \frac{\ln(x)}{x}$. Le numérateur tend vers $-\infty$ et le dénominateur tend vers $0^+$. \\nPar quotient, $\lim_{x \to 0^+} \frac{\ln(x)}{x} = -\infty$. \\nDe plus, $\lim_{x \to 0^+} (-2x) = 0$. \\nPar somme, $\lim_{x \to 0^+} g(x) = -\infty + 0 = -\infty$. \\n \\n4. Limite de $g(x)$ lorsque $x \to +\infty$: \\nOn a $g(x) = \frac{\ln(x)}{x} - 2x$. \\nPar croissance comparée, on sait que $\lim_{x \to +\infty} \frac{\ln(x)}{x} = 0$. \\nDe plus, $\lim_{x \to +\infty} (-2x) = -\infty$. \\nPar somme, $\lim_{x \to +\infty} g(x) = 0 - \infty = -\infty$.', '["Pour la limite en $0$ de $f(x)$, pense à la division par $0$.","Pour les limites de $f(x)$ en l''infini, pense à factoriser par le terme de plus haut degré au numérateur.","Pour la limite de $g(x)$ en $0^+$, souviens-toi de la limite usuelle de $\\ln(x)$ en $0^+$.","Pour la limite de $g(x)$ en $+\\infty$, utilise les croissances comparées pour $\\frac{\\ln(x)}{x}$."]'::jsonb, '2025-12-04T16:42:14.611693+00:00'::timestamptz, 'c0fe0935338ade5d0f8935fc5b50718713dee7225a8f6c3e9004923612d1427b', NULL),
('a5d4c84b-5348-4ecd-a752-f5eef16211ad', 'Limites de fonctions', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $I = \\mathbb{R}\\setminus\\{-1\\}$ par $f(x) = \\frac{2x+3}{x+1}$.","questions":["Calcule la limite de $f(x)$ lorsque $x$ tend vers $-1$ par valeurs supérieures (à droite de $-1$). Justifie ta réponse en détaillant les étapes.","Calcule la limite de $f(x)$ lorsque $x$ tend vers $-1$ par valeurs inférieures (à gauche de $-1$). Justifie ta réponse en détaillant les étapes.","Que peux-tu en déduire pour la courbe représentative de $f$ ?"]}', '1. Limite de $f(x)$ lorsque $x \to -1^+$ :
   - Limite du numérateur : $\lim_{x \to -1^+} (2x+3) = 2(-1)+3 = 1$.
   - Limite du dénominateur : Lorsque $x > -1$, $x+1 > 0$. Donc, $\lim_{x \to -1^+} (x+1) = 0^+$.
   - Par quotient, $\lim_{x \to -1^+} f(x) = \frac{1}{0^+} = +\infty$.

2. Limite de $f(x)$ lorsque $x \to -1^-$ :
   - Limite du numérateur : $\lim_{x \to -1^-} (2x+3) = 2(-1)+3 = 1$.
   - Limite du dénominateur : Lorsque $x < -1$, $x+1 < 0$. Donc, $\lim_{x \to -1^-} (x+1) = 0^-$.
   - Par quotient, $\lim_{x \to -1^-} f(x) = \frac{1}{0^-} = -\infty$.

3. Déduction pour la courbe représentative de $f$ :
   Comme $\lim_{x \to -1} f(x) = +\infty$ et $\lim_{x \to -1} f(x) = -\infty$, la droite d''équation $x=-1$ est une asymptote verticale à la courbe représentative de la fonction $f$.', '["Pour calculer la limite d''un quotient, analyse d''abord la limite du numérateur et la limite du dénominateur séparément.","Attention au signe du dénominateur lorsque $x$ se rapproche de $-1$ par la droite ou par la gauche.","Si la limite est infinie en un point fini, cela indique la présence d''une asymptote verticale."]'::jsonb, '2025-12-05T14:39:11.337416+00:00'::timestamptz, '921bb5ceef221472108dedabf903d2b7b1c8478a487c657a8b64fbf2cfe47bb9', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('94702a26-ddd2-477a-91a0-9f321d142b62', 'Limites de fonctions', 'terminale', '{"questions":["Calcule la limite de $f(x)$ quand $x$ tend vers $0^+$.","Calcule la limite de $f(x)$ quand $x$ tend vers $0^-$.","Calcule la limite de $f(x)$ quand $x$ tend vers $+ \\infty$.","Calcule la limite de $f(x)$ quand $x$ tend vers $- \\infty$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{1}{x} + x$."}', '1. Pour $x \to 0^+$:
$\lim_{x \to 0^+} \frac{1}{x} = +\infty$
$\lim_{x \to 0^+} x = 0$
Donc, $\lim_{x \to 0^+} f(x) = +\infty$.

2. Pour $x \to 0^-$:
$\lim_{x \to 0^-} \frac{1}{x} = -\infty$
$\lim_{x \to 0^-} x = 0$
Donc, $\lim_{x \to 0^-} f(x) = -\infty$.

3. Pour $x \to +\infty$:
$\lim_{x \to +\infty} \frac{1}{x} = 0$
$\lim_{x \to +\infty} x = +\infty$
Donc, $\lim_{x \to +\infty} f(x) = +\infty$.

4. Pour $x \to -\infty$:
$\lim_{x \to -\infty} \frac{1}{x} = 0$
$\lim_{x \to -\infty} x = -\infty$
Donc, $\lim_{x \to -\infty} f(x) = -\infty$.', '["Rappelle-toi les limites des fonctions de référence en $0$ et à l''infini.","Décompose la fonction en une somme de fonctions plus simples.","Fais attention aux signes des infinis."]'::jsonb, '2025-12-05T17:08:31.497818+00:00'::timestamptz, '82753443c3c13cb9dad357fe259d1e224576a41a0d74500093c53bb422cba890', NULL),
('54fe3781-97e2-45ee-92a8-7f68457fe9d7', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x+3)e^{-x}$.","questions":["Identifie clairement les deux fonctions $u(x)$ et $v(x)$ dont $f(x)$ est le produit.","Calcule la dérivée $u''(x)$ de la fonction $u(x)$.","Calcule la dérivée $v''(x)$ de la fonction $v(x)$.","Écris la formule générale de la dérivée d''un produit de deux fonctions $u(x)v(x)$.","Applique cette formule pour trouver l''expression de $f''(x)$.","Factorise l''expression de $f''(x)$ au maximum."]}', '1. Les deux fonctions sont $u(x) = 2x+3$ et $v(x) = e^{-x}$.
2. La dérivée de $u(x) = 2x+3$ est $u''(x) = 2$.
3. La dérivée de $v(x) = e^{-x}$ est $v''(x) = -e^{-x}$.
4. La formule de la dérivée d''un produit est $(uv)'' = u''v + uv''$.
5. En appliquant la formule, on obtient :
$f''(x) = (2)(e^{-x}) + (2x+3)(-e^{-x})$
$f''(x) = 2e^{-x} - (2x+3)e^{-x}$
6. Factorisons par $e^{-x}$ :
$f''(x) = e^{-x}(2 - (2x+3))$
$f''(x) = e^{-x}(2 - 2x - 3)$
$f''(x) = e^{-x}(-2x - 1)$', '["Rappelle-toi la formule $(uv)'' = u''v + uv''$.","La dérivée de $e^{-x}$ est $-e^{-x}$.","N''oublie pas de factoriser par $e^{-x}$ à la fin."]'::jsonb, '2025-12-06T09:58:29.691802+00:00'::timestamptz, '8e00434778d18769c65cf45970bd85bd66a60180cdba5923c0d94d852f71c8e3', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('51f693f3-48fa-43ec-b9c2-29f64a45a099', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $g$ définie sur $\\mathbb{R}$ par $g(x) = (x^2 - x + 1)e^{2x}$.","questions":["Identifie clairement les deux fonctions $u(x)$ et $v(x)$ dont $g(x)$ est le produit.","Calcule la dérivée $u''(x)$ de la fonction $u(x)$.","Calcule la dérivée $v''(x)$ de la fonction $v(x)$.","Écris la formule générale de la dérivée d''un produit de deux fonctions $u(x)v(x)$.","Applique cette formule pour trouver l''expression de $g''(x)$.","Factorise l''expression de $g''(x)$ au maximum."]}', '1. Les deux fonctions sont $u(x) = x^2 - x + 1$ et $v(x) = e^{2x}$.
2. La dérivée de $u(x) = x^2 - x + 1$ est $u''(x) = 2x - 1$.
3. La dérivée de $v(x) = e^{2x}$ est $v''(x) = 2e^{2x}$.
4. La formule de la dérivée d''un produit est $(uv)'' = u''v + uv''$.
5. En appliquant la formule, on obtient :
$g''(x) = (2x - 1)(e^{2x}) + (x^2 - x + 1)(2e^{2x})$
$g''(x) = e^{2x} [ (2x - 1) + 2(x^2 - x + 1) ]$
$g''(x) = e^{2x} [ 2x - 1 + 2x^2 - 2x + 2 ]$
$g''(x) = e^{2x} [ 2x^2 + 1 ]$
6. La factorisation maximale est $g''(x) = (2x^2 + 1)e^{2x}$.', '["Rappelle-toi la formule $(uv)'' = u''v + uv''$.","La dérivée de $e^{ax}$ est $a e^{ax}$.","N''oublie pas de factoriser l''expression finale."]'::jsonb, '2025-12-06T10:18:50.82211+00:00'::timestamptz, '366a8f46ed743f52c1a0f1397f28c2e8826c1f4e693a545c8eeedea8dda79ff4', NULL),
('eac52b93-93fe-4612-9d48-25072ca73354', 'Exercice soumis', 'Terminale', 'j''ai interro bientôt sur dérivées et limites de fonctions, je vais devoir travailler les 2. Tu peux me générer un exo complet et un peu dur de dérivées', 'En cours de correction', '[]'::jsonb, '2025-12-06T12:37:42.886854+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('d4a9c4a1-fc79-420e-9ace-0e9f8800ba17', 'Compléments dérivation', 'Terminale', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=1$.","Étudie les variations de $f$ sur l''intervalle $]0 ; +\\infty[$. (Tu pourras t''aider de la valeur de $f''(1/9)$ pour justifier ton étude)"],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{1}{x} + (3x-2)\\sqrt{x}$."}', 'Calcul de la dérivée $f''(x)$ :

La fonction $f(x)$ peut s''écrire $f(x) = x^{-1} + (3x-2)x^{1/2}$.

On dérive chaque terme séparément :

Dérivée de $x^{-1}$ : $(x^{-1})'' = -1 \cdot x^{-1-1} = -x^{-2} = -\frac{1}{x^2}$.

Dérivée de $(3x-2)\sqrt{x}$ : C''est un produit de la forme $u(x)v(x)$ avec $u(x) = 3x-2$ et $v(x) = \sqrt{x} = x^{1/2}$.
$u''(x) = 3$
$v''(x) = \frac{1}{2}x^{1/2 - 1} = \frac{1}{2}x^{-1/2} = \frac{1}{2\sqrt{x}}$.

Donc, $(uv)'' = u''v + uv'' = 3\sqrt{x} + (3x-2)\frac{1}{2\sqrt{x}}$
$= 3\sqrt{x} + \frac{3x-2}{2\sqrt{x}}$
$= \frac{3\sqrt{x} \cdot 2\sqrt{x} + 3x-2}{2\sqrt{x}}$
$= \frac{6x + 3x-2}{2\sqrt{x}} = \frac{9x-2}{2\sqrt{x}}$.

Finalement, $f''(x) = -\frac{1}{x^2} + \frac{9x-2}{2\sqrt{x}}$.

Équation de la tangente au point d''abscisse $x=1$ :

$f(1) = \frac{1}{1} + (3(1)-2)\sqrt{1} = 1 + (1)(1) = 2$.

$f''(1) = -\frac{1}{1^2} + \frac{9(1)-2}{2\sqrt{1}} = -1 + \frac{7}{2} = \frac{5}{2}$.

L''équation de la tangente est $y = f''(1)(x-1) + f(1)$ :
$y = \frac{5}{2}(x-1) + 2$
$y = \frac{5}{2}x - \frac{5}{2} + 2$
$y = \frac{5}{2}x - \frac{1}{2}$.

Étude des variations de $f$ sur $]0 ; +\infty[$ :

On étudie le signe de $f''(x) = -\frac{1}{x^2} + \frac{9x-2}{2\sqrt{x}}$.

Pour $x > 0$, on peut écrire $f''(x)$ sur un dénominateur commun :
$f''(x) = \frac{-2\sqrt{x} + x^2(9x-2)}{2x^2\sqrt{x}} = \frac{-2x^{1/2} + 9x^3 - 2x^2}{2x^2\sqrt{x}}$.

Il est plus simple d''étudier le signe de $f''(x)$ en cherchant les racines de $f''(x)=0$.

$f''(x) = 0 \iff \frac{9x-2}{2\sqrt{x}} = \frac{1}{x^2}$
$\iff (9x-2)x^2 = 2\sqrt{x}$
$\iff (9x-2)x^{3/2} = 2$. (Ceci n''est pas simple à résoudre directement)

Reprenons $f''(x) = -\frac{1}{x^2} + \frac{9x-2}{2\sqrt{x}}$.

Pour $x \in ]0 ; +\infty[$, $x^2 > 0$ et $2\sqrt{x} > 0$. Le signe de $f''(x)$ dépend du signe de $-2\sqrt{x} + x^2(9x-2)$.

$f''(1/9) = -\frac{1}{(1/9)^2} + \frac{9(1/9)-2}{2\sqrt{1/9}} = -81 + \frac{1-2}{2(1/3)} = -81 + \frac{-1}{2/3} = -81 - \frac{3}{2} < 0$.

Cela signifie que $f$ est décroissante autour de $x=1/9$.

Considérons la limite de $f''(x)$ quand $x \to 0^+$ :
$\lim_{x \to 0^+} -\frac{1}{x^2} = -\infty$
$\lim_{x \to 0^+} \frac{9x-2}{2\sqrt{x}} = \frac{-2}{0^+} = -\infty$
Donc $\lim_{x \to 0^+} f''(x) = -\infty$.

Considérons la limite de $f''(x)$ quand $x \to +\infty$ :
$\lim_{x \to +\infty} -\frac{1}{x^2} = 0$
$\lim_{x \to +\infty} \frac{9x-2}{2\sqrt{x}} = \lim_{x \to +\infty} \frac{9x}{2\sqrt{x}} = \lim_{x \to +\infty} \frac{9}{2}x^{1/2} = +\infty$
Donc $\lim_{x \to +\infty} f''(x) = +\infty$.

Comme $f''(x)$ est continue sur $]0 ; +\infty[$, qu''elle passe de $-\infty$ à $+\infty$, et $f''(1/9) < 0$, il existe un unique réel $x_0 > 0$ tel que $f''(x_0) = 0$. (D''après le théorème des valeurs intermédiaires)

Pour trouver $x_0$, on peut chercher numériquement ou graphiquement. $f''(x)$ est croissante sur $]0 ; +\infty[$.

- Sur $]0 ; x_0[$, $f''(x) < 0$, donc $f$ est décroissante.
- Sur $]x_0 ; +\infty[$, $f''(x) > 0$, donc $f$ est croissante.

On peut vérifier que $f''(1) = 5/2 > 0$, donc $x_0 < 1$.', '["Pour le calcul de $f''(x)$, pense à décomposer la fonction en plusieurs termes et à utiliser les formules de dérivation appropriées : dérivée de $\\frac{1}{x}$, dérivée d''un produit $uv$, et dérivée d''une fonction composée $\\sqrt{u}$.","La formule de l''équation de la tangente est $y = f''(a)(x-a) + f(a)$.","Pour étudier les variations, tu dois déterminer le signe de $f''(x)$. Le calcul de $f''(1/9)$ est une indication pour t''aider à trouver un point où la dérivée change de signe."]'::jsonb, '2025-12-06T12:40:39.70855+00:00'::timestamptz, 'ce454f82b5db865e0962d2959ef753b0d29b8b20765fcbbe807c4fbe791796d3', NULL),
('92cae27c-5578-49c8-8a73-5dc477e6632e', 'Compléments dérivation', 'Terminale', '{"contexte":"Une entreprise fabrique des boîtes de conserve cylindriques. Pour des raisons de coût, elle souhaite minimiser la quantité de métal utilisée, ce qui revient à minimiser l''aire totale du cylindre.\n\nOn considère un cylindre de rayon $r$ et de hauteur $h$. Le volume de la boîte est fixé à $V = 1000 \\text{ cm}^3$.","questions":["Exprime la hauteur $h$ en fonction du rayon $r$ et du volume $V$.","Montre que l''aire totale $A(r)$ du cylindre (aire des deux disques et de la surface latérale) peut s''écrire sous la forme : $A(r) = 2\\pi r^2 + \\frac{2V}{r}$.","Calcule la dérivée $A''(r)$ de cette fonction $A(r)$.","Étudie le signe de $A''(r)$ et déduis-en les variations de la fonction $A(r)$ sur l''intervalle $]0 ; +\\infty[$.","Pour quelle valeur de $r$ l''aire $A(r)$ est-elle minimale ? Calcule la hauteur $h$ correspondante."]}', '1. Expression de la hauteur $h$ en fonction de $r$ et $V$ :
Le volume d''un cylindre est $V = \pi r^2 h$. On isole $h$ : $h = \frac{V}{\pi r^2}$.

2. Expression de l''aire totale $A(r)$ :
L''aire totale du cylindre est la somme de l''aire des deux disques (base et couvercle) et de l''aire latérale.
Aire des deux disques : $2 \times (\pi r^2) = 2\pi r^2$.
Aire latérale : $2\pi r h$.
Donc $A(r) = 2\pi r^2 + 2\pi r h$.
En remplaçant $h$ par son expression en fonction de $r$ et $V$ :
$A(r) = 2\pi r^2 + 2\pi r \left(\frac{V}{\pi r^2}\right) = 2\pi r^2 + \frac{2V r}{\pi r^2} = 2\pi r^2 + \frac{2V}{r}$.

3. Calcul de la dérivée $A''(r)$ :
$A(r) = 2\pi r^2 + 2V r^{-1}$.
$A''(r) = 2\pi (2r) + 2V (-1 r^{-2}) = 4\pi r - \frac{2V}{r^2}$.

4. Étude du signe de $A''(r)$ et variations de $A(r)$ :
On cherche le signe de $A''(r) = 4\pi r - \frac{2V}{r^2}$.
$A''(r) = \frac{4\pi r^3 - 2V}{r^2}$.
Pour $r > 0$, le dénominateur $r^2$ est toujours positif. Le signe de $A''(r)$ est donc celui du numérateur $4\pi r^3 - 2V$.
On cherche quand $4\pi r^3 - 2V > 0$ :
$4\pi r^3 > 2V$
$r^3 > \frac{2V}{4\pi}$
$r^3 > \frac{V}{2\pi}$
$r > \sqrt[3]{\frac{V}{2\pi}}$.

Soit $r_0 = \sqrt[3]{\frac{V}{2\pi}}$.
- Si $0 < r < r_0$, alors $r^3 < r_0^3$, donc $4\pi r^3 - 2V < 0$. Ainsi $A''(r) < 0$, et $A(r)$ est décroissante.
- Si $r > r_0$, alors $r^3 > r_0^3$, donc $4\pi r^3 - 2V > 0$. Ainsi $A''(r) > 0$, et $A(r)$ est croissante.

5. Valeur de $r$ pour laquelle l''aire est minimale et hauteur $h$ correspondante :
L''aire $A(r)$ est minimale lorsque $A''(r)$ change de signe de négatif à positif, c''est-à-dire pour $r = r_0 = \sqrt[3]{\frac{V}{2\pi}}$.
Avec $V = 1000 \text{ cm}^3$ :
$r = \sqrt[3]{\frac{1000}{2\pi}} = \sqrt[3]{\frac{500}{\pi}} \text{ cm}$.

Calcul de $h$ :
$h = \frac{V}{\pi r^2} = \frac{1000}{\pi \left(\sqrt[3]{\frac{500}{\pi}}\right)^2} = \frac{1000}{\pi \left(\frac{500}{\pi}\right)^{2/3}}$.
$h = \frac{1000}{\pi \frac{500^{2/3}}{\pi^{2/3}}} = \frac{1000}{\pi^{1/3} 500^{2/3}}$.

On peut aussi remarquer que $r_0^3 = \frac{V}{2\pi}$ donc $2\pi r_0^3 = V$.
Et $h = \frac{V}{\pi r^2} = \frac{2\pi r_0^3}{\pi r_0^2} = 2r_0$.
Donc la hauteur optimale est le double du rayon optimal.
$h = 2 \sqrt[3]{\frac{500}{\pi}} \text{ cm}$.', '["La formule du volume d''un cylindre est $V = \\pi r^2 h$.","L''aire d''un disque est $\\pi r^2$. L''aire latérale d''un cylindre est $2\\pi r h$.","Pense à la dérivée de $x^n$ et de $\\frac{1}{x}$.","Pour le signe de $A''(r)$, tu devras résoudre une inéquation.","Une fois le rayon $r$ optimal trouvé, utilise l''expression de $h$ en fonction de $r$ et $V$ que tu as trouvée à la première question."]'::jsonb, '2025-12-06T17:15:05.510721+00:00'::timestamptz, '028c994a766436d52eface2a4b71d9868965f0ce5723aa56074d8a6524155066', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('b141a4ef-ab2d-4589-921f-2472934e34c2', 'Calcul intégral (Intégration par parties)', 'Lycée', '{"contexte":"Calcule l''intégrale suivante :","questions":["Détaille toutes les étapes de ton calcul."]}', 'Pour calculer $I = \int_1^e x \ln(x) dx$, nous allons utiliser l''intégration par parties.\n\nNous devons choisir $u(x)$ et $v''(x)$. Selon la règle ALPES, la fonction logarithmique (L) est prioritaire sur la fonction polynomiale (P) pour $u(x)$. Mais ici, si nous choisissons $u(x) = \ln(x)$, alors $v''(x) = x$. Ce choix est généralement le bon car la dérivée de $\ln(x)$ est plus simple.\n\nPosons :\n$u(x) = \ln(x) \implies u''(x) = \frac{1}{x}$\n$v''(x) = x \implies v(x) = \frac{x^2}{2}$ (une primitive de $x$)\n\nAppliquons la formule de l''intégration par parties :\n$\int_a^b u(x)v''(x) dx = [u(x)v(x)]_a^b - \int_a^b u''(x)v(x) dx$\n\n$I = [\ln(x) \cdot \frac{x^2}{2}]_1^e - \int_1^e \frac{1}{x} \cdot \frac{x^2}{2} dx$\n\nCalculons la première partie (le crochet) :\n$[\ln(x) \cdot \frac{x^2}{2}]_1^e = (\ln(e) \cdot \frac{e^2}{2}) - (\ln(1) \cdot \frac{1^2}{2})$\nNous savons que $\ln(e) = 1$ et $\ln(1) = 0$.\nDonc, $[\ln(x) \cdot \frac{x^2}{2}]_1^e = (1 \cdot \frac{e^2}{2}) - (0 \cdot \frac{1}{2}) = \frac{e^2}{2}$\n\nSimplifions et calculons la deuxième partie (l''intégrale restante) :\n$\int_1^e \frac{1}{x} \cdot \frac{x^2}{2} dx = \int_1^e \frac{x}{2} dx$\n$\int_1^e \frac{x}{2} dx = [\frac{x^2}{4}]_1^e = \frac{e^2}{4} - \frac{1^2}{4} = \frac{e^2}{4} - \frac{1}{4}$\n\nMaintenant, combinons les deux parties :\n$I = \frac{e^2}{2} - (\frac{e^2}{4} - \frac{1}{4})$\n$I = \frac{e^2}{2} - \frac{e^2}{4} + \frac{1}{4}$\n$I = \frac{2e^2}{4} - \frac{e^2}{4} + \frac{1}{4}$\n$I = \frac{e^2}{4} + \frac{1}{4}$\n\nLe résultat final est donc :\n$I = \frac{e^2 + 1}{4}$', '["Pense à la règle ALPES pour choisir $u(x)$ et $v''(x)$.","N''oublie pas d''évaluer la partie $[u(x)v(x)]_a^b$ aux bornes.","La dérivée de $\\ln(x)$ est $\\frac{1}{x}$."]'::jsonb, '2025-12-07T15:56:16.270214+00:00'::timestamptz, '0fd3a5c4c3da2a0219b74f3c73956dd7bda11fa79eebb50c5f9b886c9c7f2746', NULL),
('a54e3ede-a2c8-4a66-a89e-95d70ba4c87a', 'Combinatoire et dénombrement', 'terminale', '{"contexte":"Un restaurant propose un menu du jour composé d''une entrée, d''un plat et d''un dessert. Voici les choix disponibles :","questions":["Combien de menus différents peut-on composer ?","Si un client ne veut pas de dessert, combien de repas différents peut-il composer ?","Un client peut choisir un menu complet (entrée + plat + dessert) ou juste un plat. Combien de choix a-t-il au total ?"]}', 'Données :
* Entrées : 3 choix
* Plats : 4 choix
* Desserts : 2 choix

1.  **Nombre de menus différents (entrée + plat + dessert) :**
    Il s''agit d''une séquence de choix (une entrée ET un plat ET un dessert), on utilise donc le principe multiplicatif.
    Nombre de menus = (nombre d''entrées) × (nombre de plats) × (nombre de desserts)
    Nombre de menus = $3 \times 4 \times 2 = 24$
    On peut composer 24 menus différents.

2.  **Nombre de repas sans dessert :**
    Le client choisit une entrée ET un plat. Le dessert n''est pas pris en compte.
    Nombre de repas sans dessert = (nombre d''entrées) × (nombre de plats)
    Nombre de repas sans dessert = $3 \times 4 = 12$
    Il peut composer 12 repas différents sans dessert.

3.  **Nombre total de choix (menu complet OU plat seul) :**
    Il y a deux situations mutuellement exclusives :
    *   Cas 1 : Le client prend un menu complet (entrée + plat + dessert). On a calculé qu''il y a 24 façons de faire ce choix (question 1).
    *   Cas 2 : Le client prend juste un plat. Il n''y a pas d''entrée ni de dessert, donc le nombre de choix est simplement le nombre de plats disponibles, soit 4.

    Puisqu''il s''agit d''un choix "OU BIEN" (menu complet OU plat seul), on utilise le principe additif.
    Nombre total de choix = (nombre de menus complets) + (nombre de plats seuls)
    Nombre total de choix = $24 + 4 = 28$
    Le client a 28 choix au total.', '["Pour la première question, pense au principe multiplicatif. Il s''agit de choisir une entrée ET un plat ET un dessert.","Pour la deuxième question, retire simplement le choix du dessert de ton calcul.","Pour la troisième question, il y a deux cas distincts : soit un menu complet (que tu as calculé à la question 1), soit un plat seul. Ces deux cas s''excluent mutuellement, pense au principe additif."]'::jsonb, '2025-12-07T16:16:28.039986+00:00'::timestamptz, '7f98831400908b6e5ef84ed3d11e713c512fbb0b40bc7e524653cb7013be2a28', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('26a28fe4-c52e-45be-8ee9-f6c173b475b4', 'Calcul intégral (Intégration par parties)', 'terminale', '{"contexte":"On souhaite calculer l''intégrale suivante : $$I = \\int_0^1 (2x+1)e^x dx$$","questions":["Justifie pourquoi cette intégrale peut être calculée par une intégration par parties.","Choisis les fonctions $u(x)$ et $v''(x)$ de manière appropriée pour l''intégration par parties, et calcule $u''(x)$ et $v(x)$.","Écris la formule générale de l''intégration par parties.","Applique la formule de l''intégration par parties pour calculer la valeur de $I$. Détaille toutes les étapes de ton calcul."]}', '1. Justification de l''IPP :
L''intégrale $I = \int_0^1 (2x+1)e^x dx$ est le produit de deux fonctions de types différents : un polynôme ($2x+1$) et une fonction exponentielle ($e^x$). Il n''existe pas de formule directe pour la primitive d''un tel produit. L''intégration par parties est la méthode adaptée pour calculer l''intégrale d''un produit de fonctions.

2. Choix des fonctions pour l''IPP :
Pour l''IPP, on choisit généralement $u(x)$ comme la fonction qui se simplifie par dérivation et $v''(x)$ comme celle dont on connaît facilement une primitive.
On pose :
$u(x) = 2x+1 \implies u''(x) = 2$
$v''(x) = e^x \implies v(x) = e^x$

3. Formule générale de l''intégration par parties :
$$\int_a^b u(x)v''(x)dx = [u(x)v(x)]_a^b - \int_a^b u''(x)v(x)dx$$

4. Application de la formule et calcul de $I$ :
En appliquant la formule avec $a=0$ et $b=1$ :
$I = [(2x+1)e^x]_0^1 - \int_0^1 2e^x dx$

Calcul du premier terme :
$[(2x+1)e^x]_0^1 = (2(1)+1)e^1 - (2(0)+1)e^0$
$= (3)e - (1)(1)$
$= 3e - 1$

Calcul de la deuxième intégrale :
$\int_0^1 2e^x dx = [2e^x]_0^1$
$= 2e^1 - 2e^0$
$= 2e - 2(1)$
$= 2e - 2$

Finalement, en combinant les deux parties :
$I = (3e - 1) - (2e - 2)$
$I = 3e - 1 - 2e + 2$
$I = e + 1$

La valeur de l''intégrale est $I = e+1$.', '["La formule d''intégration par parties est $\\int_a^b u(x)v''(x)dx = [u(x)v(x)]_a^b - \\int_a^b u''(x)v(x)dx$.","Pour choisir $u(x)$ et $v''(x)$, pense au moyen mnémotechnique \"ALPètes\" (Arcsin, Logarithmes, Polynômes, Exponentielles, Sinus/Cosinus) pour faciliter le calcul de $u''(x)$ et $v(x)$. Le polynôme doit être $u(x)$ car sa dérivée est plus simple.","N''oublie pas d''évaluer le terme $[u(x)v(x)]_0^1$ aux bornes.","Le calcul de la deuxième intégrale $\\int_0^1 u''(x)v(x)dx$ doit être direct après ton choix de $u(x)$ et $v''(x)$."]'::jsonb, '2025-12-08T14:33:57.02667+00:00'::timestamptz, '79e706fc846dadf11d59985c22828707bef13951a0484eaa2214c19af8e88a5a', NULL),
('eead8e7c-09ba-410f-84b5-1fc25e944988', 'Exercice soumis', 'terminale', 'Voilà ce que j''ai fait pour l''exercice 3.e, dis-moi si la dérivée est bonne', 'En cours de correction', '[]'::jsonb, '2025-12-09T08:38:49.670623+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('7a6c0f48-8dbe-4926-8231-3a4c368de933', 'Exercice soumis', 'terminale', 'voilà ce que j''ai fait pour l''exercice 3.e dis-moi si c''est correct', 'En cours de correction', '[]'::jsonb, '2025-12-09T08:44:00.500513+00:00'::timestamptz, NULL, '{}'::jsonb),
('811d4d3c-aefa-4ecf-929a-ec0ac87e99c7', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $I = ]-\\infty; -\\frac{1}{2}[$ par $f(x) = \\frac{2x-3}{4x+2}$.","questions":["Identifie clairement les deux fonctions $u(x)$ et $v(x)$ dont $f(x)$ est le quotient.","Calcule la dérivée $u''(x)$ de la fonction $u(x)$.","Calcule la dérivée $v''(x)$ de la fonction $v(x)$.","Écris la formule générale de la dérivée d''un quotient de deux fonctions $u(x)$ et $v(x)$.","Applique cette formule pour trouver l''expression de $f''(x)$.","Simplifie l''expression de $f''(x)$ au maximum."]}', '1. Identification des fonctions :
$u(x) = 2x-3$
$v(x) = 4x+2$

2. Dérivée de $u(x)$ :
$u''(x) = 2$

3. Dérivée de $v(x)$ :
$v''(x) = 4$

4. Formule de la dérivée d''un quotient :
$(u/v)'' = \frac{u''v - uv''}{v^2}$

5. Application de la formule pour $f''(x)$ :
$f''(x) = \frac{2(4x+2) - (2x-3)4}{(4x+2)^2}$
$f''(x) = \frac{8x+4 - (8x-12)}{(4x+2)^2}$
$f''(x) = \frac{8x+4 - 8x + 12}{(4x+2)^2}$
$f''(x) = \frac{16}{(4x+2)^2}$

6. Simplification de $f''(x)$ :
$f''(x) = \frac{16}{(2(2x+1))^2}$
$f''(x) = \frac{16}{4(2x+1)^2}$
$f''(x) = \frac{4}{(2x+1)^2}$', '["La formule de la dérivée d''un quotient est $(u/v)'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas de bien distribuer les signes négatifs lors du développement du numérateur.","Vérifie que tu peux simplifier la fraction finale en divisant le numérateur et le dénominateur par un même nombre."]'::jsonb, '2025-12-09T09:14:15.061985+00:00'::timestamptz, '819d28d5227a1cddba5f746d968f932f1be53db4edc43dc834a0d528b166f054', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('233e46ea-99b6-4835-8671-9c1b95b525ac', 'Exercice soumis', 'terminale', 'voilà l''énoncé et ce que j''ai fait pour cet exo, c''est juste?', 'En cours de correction', '[]'::jsonb, '2025-12-10T08:17:20.283015+00:00'::timestamptz, NULL, '{}'::jsonb),
('8eb2c4b3-b96b-453d-9d04-da824cacf24d', 'Exercice soumis', 'terminale', 'voilà ce que j''ai fait, c''est correct?', 'En cours de correction', '[]'::jsonb, '2025-12-10T08:47:10.076471+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('ef08c9c6-c5a5-4f21-b482-5f40943524a9', 'Exercice soumis', 'terminale', 'c''est juste', 'En cours de correction', '[]'::jsonb, '2025-12-10T08:48:50.083155+00:00'::timestamptz, NULL, '{}'::jsonb),
('ea052a75-5741-47e7-8739-f57c89cc6ac8', 'Exercice', 'terminale', '{"contexte":"","questions":["Tu as bien appliqué la formule de la dérivée d''un quotient $(u/v)'' = \\\\frac{u''v - uv''}{v^2}$","Tu as correctement dérivé les fonctions usuelles, notamment $x'' = 1$ et $(\\\\sqrt{x})'' = \\\\frac{1}{2\\\\sqrt{x}}$","La simplification de $\\\\frac{x}{2\\\\sqrt{x}}$ en $\\\\frac{\\\\sqrt{x}}{2}$ est impeccable"]}', 'À résoudre', '[]'::jsonb, '2025-12-10T08:49:22.03568+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('52182e33-84b3-425e-a1fa-1c0189c7bfd3', 'Exercice soumis', 'terminale', 'dis moi si c''est bon', 'En cours de correction', '[]'::jsonb, '2025-12-10T10:07:18.961183+00:00'::timestamptz, NULL, '{}'::jsonb),
('65924542-fb3e-4090-9043-0302a8651d35', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Calcule la dérivée de la fonction $f(x) = e^{x^2 + 3x - 1}$ et simplifie ton résultat.","questions":["Détaille toutes les étapes de ton calcul."]}', 'Pour calculer la dérivée de $f(x) = e^{x^2 + 3x - 1}$ :\n\n1. **Identifier $u(x)$** : \n   Dans ce cas, $u(x) = x^2 + 3x - 1$.\n\n2. **Calculer $u''(x)$** : \n   La dérivée de $u(x)$ est $u''(x) = 2x + 3$.\n\n3. **Appliquer la formule de dérivation des fonctions composées** : \n   La formule pour la dérivée de $e^{u(x)}$ est $(e^{u(x)})'' = u''(x)e^{u(x)}$.\n\n   Donc, $f''(x) = (2x + 3)e^{x^2 + 3x - 1}$.\n\nLe résultat est déjà sous une forme simplifiée.', '["Pense à la formule de dérivation d''une fonction composée de la forme $e^{u(x)}$. Quel est $u(x)$ dans ce cas ?","Quelle est la dérivée de $u(x)$ ?","Applique la formule $(e^{u(x)})'' = u''(x)e^{u(x)}$."]'::jsonb, '2025-12-10T10:16:02.552178+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('d44868e3-6b39-4700-bb93-df9084c3cb32', 'Exercice soumis', 'terminale', 'dis moi si c''est juste', 'En cours de correction', '[]'::jsonb, '2025-12-10T10:41:17.621859+00:00'::timestamptz, NULL, '{}'::jsonb),
('3299ab22-7c54-4065-9053-4cc22459dbd9', 'Exercice soumis', 'terminale', 'est-ce que c''est juste?', 'En cours de correction', '[]'::jsonb, '2025-12-10T10:55:12.931863+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('715917aa-ce1f-4175-bacb-3888cff020b7', 'Exercice soumis', 'terminale', 'c''est juste?', 'En cours de correction', '[]'::jsonb, '2025-12-10T10:58:04.10489+00:00'::timestamptz, NULL, '{}'::jsonb),
('718a02d6-344c-4e26-bdd5-63ba74a5bc56', 'Exercice soumis', 'terminale', 'dis moi si c''est bon', 'En cours de correction', '[]'::jsonb, '2025-12-10T14:14:57.220136+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('de9f2e4c-7600-4c02-a9a7-b5768c3e74c3', 'Exercice soumis', 'terminale', 'dis moi si c''est bon', 'En cours de correction', '[]'::jsonb, '2025-12-10T14:39:10.299754+00:00'::timestamptz, NULL, '{}'::jsonb),
('22ee7756-2f68-45ad-8647-24f2916e5431', 'Exercice soumis', 'terminale', 'c''est correct?', 'En cours de correction', '[]'::jsonb, '2025-12-10T15:15:22.880219+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('b18f60ba-f013-48f4-a5ab-80c2f2251741', 'Exercice soumis', 'terminale', 'voici mes calculs pour l''exo, dis-moi si c''est correct', 'En cours de correction', '[]'::jsonb, '2025-12-11T07:59:37.765005+00:00'::timestamptz, NULL, '{}'::jsonb),
('0e244f7e-7a90-41dc-b93c-5927e5e25e12', 'Exercice soumis', 'terminale', 'dis moi si c''est juste', 'En cours de correction', '[]'::jsonb, '2025-12-11T08:02:50.908417+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('cf281826-e5cc-4cac-80f2-fc60de05c303', 'Exercice soumis', 'terminale', 'c''est correct?', 'En cours de correction', '[]'::jsonb, '2025-12-11T08:08:56.696421+00:00'::timestamptz, NULL, '{}'::jsonb),
('ec8cdeb5-9ffa-435b-9d7c-3a4c00a609d4', 'Exercice soumis', 'terminale', 'vérifie mes calculs', 'En cours de correction', '[]'::jsonb, '2025-12-11T08:22:04.045691+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('3e74d33f-2d92-4886-9db7-6b687e047760', 'Exercice soumis', 'terminale', 'vérifie mes calculs', 'En cours de correction', '[]'::jsonb, '2025-12-11T08:30:26.590982+00:00'::timestamptz, NULL, '{}'::jsonb),
('033e0e0c-c0cd-46e6-a9b3-5c110de6a8f5', 'Exercice soumis', 'terminale', 'vérifie les calculs', 'En cours de correction', '[]'::jsonb, '2025-12-11T08:35:48.247408+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('312c7fbf-6a83-448c-84ab-d1e073b7c4f6', 'Exercice soumis', 'terminale', 'c''est correct?', 'En cours de correction', '[]'::jsonb, '2025-12-11T08:40:04.432843+00:00'::timestamptz, NULL, '{}'::jsonb),
('d96b9539-f2ab-4ef3-8f4c-b02e86d18508', 'Exercice soumis', 'terminale', 'c''est juste?', 'En cours de correction', '[]'::jsonb, '2025-12-11T09:06:25.901817+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('a6e1acea-32f4-47b2-ba8a-bfa90a33e42e', 'Exercice soumis', 'terminale', 'mes calculs sont bons?', 'En cours de correction', '[]'::jsonb, '2025-12-11T10:55:33.176471+00:00'::timestamptz, NULL, '{}'::jsonb),
('cd408d60-9df2-42b8-951a-c86f4e9ff36c', 'Exercice soumis', 'terminale', 'est-ce que c''est juste?', 'En cours de correction', '[]'::jsonb, '2025-12-11T15:07:48.755664+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('146659ff-63cd-4afe-a5b0-90afdc3bd723', 'Exercice soumis', 'premiere', 'est ce que tu peux me generer 10 exercices d''automatisme type bac sur la trigonometri, second degre, probabilites conditionelles, dervivation ', 'En cours de correction', '[]'::jsonb, '2025-12-11T23:11:28.02777+00:00'::timestamptz, NULL, '{}'::jsonb),
('5ad41388-49d1-4c5f-be0b-b3d1e9ce1fde', 'Trigonométrie', 'premiere', '{"contexte":"Détermine la valeur exacte de $\\cos\\left(\\frac{2\\pi}{3}\\right)$.","questions":["Détaille toutes les étapes de ton raisonnement et de ton calcul. Utilise le cercle trigonométrique si besoin pour visualiser."]}', '1. **Positionnement sur le cercle trigonométrique** : L''angle $\frac{2\pi}{3}$ est dans le deuxième quadrant du cercle trigonométrique. Il peut être vu comme $\pi - \frac{\pi}{3}$.

2. **Utilisation de la symétrie** : Nous savons que $\cos(\pi - x) = -\cos(x)$.

3. **Application de la formule** : Donc, $\cos\left(\frac{2\pi}{3}\right) = \cos\left(\pi - \frac{\pi}{3}\right) = -\cos\left(\frac{\pi}{3}\right)$.

4. **Valeur de $\cos(\pi/3)$** : On sait que $\cos\left(\frac{\pi}{3}\right) = \frac{1}{2}$.

5. **Conclusion** : Par conséquent, $\cos\left(\frac{2\pi}{3}\right) = -\frac{1}{2}$.', '["Pense aux angles remarquables et à la symétrie sur le cercle trigonométrique.","Place le point correspondant à l''angle $2\\pi/3$ sur le cercle trigonométrique. Quelle est la valeur de son abscisse ?"]'::jsonb, '2025-12-11T23:11:37.528701+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('b548cd9b-7406-43ca-93c6-f2c278bf4899', 'Fonctions trigonométriques', 'premiere', '{"contexte":"Détermine la valeur exacte de $\\sin\\left(\\frac{5\\pi}{6}\\right)$.","questions":["Détaille toutes les étapes de ton raisonnement et de ton calcul. Utilise le cercle trigonométrique si besoin pour visualiser."]}', '1. **Positionnement sur le cercle trigonométrique** : L''angle $\frac{5\pi}{6}$ est dans le deuxième quadrant du cercle trigonométrique. Il peut être vu comme $\pi - \frac{\pi}{6}$.

2. **Utilisation de la symétrie** : Nous savons que $\sin(\pi - x) = \sin(x)$.

3. **Application de la formule** : Donc, $\sin\left(\frac{5\pi}{6}\right) = \sin\left(\pi - \frac{\pi}{6}\right) = \sin\left(\frac{\pi}{6}\right)$.

4. **Valeur de $\sin(\pi/6)$** : On sait que $\sin\left(\frac{\pi}{6}\right) = \frac{1}{2}$.

5. **Conclusion** : Par conséquent, $\sin\left(\frac{5\pi}{6}\right) = \frac{1}{2}$.', '["Pense aux angles remarquables et à la symétrie sur le cercle trigonométrique.","Place le point correspondant à l''angle $\\frac{5\\pi}{6}$ sur le cercle trigonométrique. Quelle est la valeur de son ordonnée ?"]'::jsonb, '2025-12-11T23:27:09.047882+00:00'::timestamptz, NULL, '{}'::jsonb),
('694e6f99-f583-420c-8f74-c739d98633d2', 'Dérivation', 'terminale', '{"questions":["Identifie clairement les deux fonctions $u(x)$ et $v(x)$ dont $f(x)$ est le produit.","Calcule la dérivée $u''(x)$ de la fonction $u(x)$.","Calcule la dérivée $v''(x)$ de la fonction $v(x)$.","Écris la formule générale de la dérivée d''un produit de deux fonctions $u(x)$ et $v(x)$.","Applique cette formule pour trouver l''expression de $f''(x)$.","Simplifie l''expression de $f''(x)$ au maximum."],"contexte":"Soit la fonction $f$ définie sur $I = ]0; +\\infty[$ par $f(x) = (3x-1)\\sqrt{x}$."}', '1. Les deux fonctions sont $u(x) = 3x-1$ et $v(x) = \sqrt{x}$.
2. La dérivée de $u(x) = 3x-1$ est $u''(x) = 3$.
3. La dérivée de $v(x) = \sqrt{x} = x^{1/2}$ est $v''(x) = \frac{1}{2}x^{1/2 - 1} = \frac{1}{2}x^{-1/2} = \frac{1}{2\sqrt{x}}$.
4. La formule générale de la dérivée d''un produit est $(uv)'' = u''v + uv''$.
5. En appliquant la formule :
$f''(x) = (3)(\sqrt{x}) + (3x-1)(\frac{1}{2\sqrt{x}})$
$f''(x) = 3\sqrt{x} + \frac{3x-1}{2\sqrt{x}}$
6. Pour simplifier, mets sur le même dénominateur $2\sqrt{x}$ :
$f''(x) = \frac{3\sqrt{x} \times 2\sqrt{x}}{2\sqrt{x}} + \frac{3x-1}{2\sqrt{x}}$
$f''(x) = \frac{6x}{2\sqrt{x}} + \frac{3x-1}{2\sqrt{x}}$
$f''(x) = \frac{6x + 3x - 1}{2\sqrt{x}}$
$f''(x) = \frac{9x - 1}{2\sqrt{x}}$', '["Pour $v(x) = \\sqrt{x}$, rappelle-toi que $v(x) = x^{1/2}$. La dérivée de $x^n$ est $nx^{n-1}$.","N''oublie pas de mettre $f''(x)$ sur un dénominateur commun pour la simplification.","Vérifie tes calculs de dérivées usuelles avant d''appliquer la formule du produit."]'::jsonb, '2025-12-12T07:39:52.2966+00:00'::timestamptz, 'a001adf84f151eb4a0811d73e60e4a1bece6f638bc3760b782bf279a69d0428b', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('08a74636-6bf1-41a7-8eb9-7198d2509e10', 'Exercice soumis', 'terminale', 'c''est correct?', 'En cours de correction', '[]'::jsonb, '2025-12-12T12:31:38.830088+00:00'::timestamptz, NULL, '{}'::jsonb),
('ddc7ceab-3e1c-4002-b6a2-bcd481feb35c', 'Exercice soumis', 'terminale', 'c''est juste?', 'En cours de correction', '[]'::jsonb, '2025-12-12T12:45:12.61323+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('861a58ee-1eec-40b7-91e9-e043583e96de', 'Exercice soumis', 'terminale', 'c''est juste?', 'En cours de correction', '[]'::jsonb, '2025-12-12T12:49:39.317346+00:00'::timestamptz, NULL, '{}'::jsonb),
('3c9b3097-9909-4b16-996b-99a9c5b2df86', 'Exercice soumis', 'terminale', 'vérifie si c''est bon', 'En cours de correction', '[]'::jsonb, '2025-12-12T12:52:53.178517+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('9aed34b7-dbf0-4142-8e39-286f12cb273d', 'Exercice soumis', 'terminale', 'c''est juste?', 'En cours de correction', '[]'::jsonb, '2025-12-12T13:39:45.531377+00:00'::timestamptz, NULL, '{}'::jsonb),
('fbb28920-57b7-4671-b51f-8de937b2280a', 'Exercice soumis', 'terminale', 'est-ce que c''est juste?', 'En cours de correction', '[]'::jsonb, '2025-12-12T14:02:20.455601+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('3a1f0dea-85d9-4f70-9bde-35b90a7b86f8', 'Exercice soumis', 'terminale', 'c''est juste?', 'En cours de correction', '[]'::jsonb, '2025-12-12T14:07:13.104605+00:00'::timestamptz, NULL, '{}'::jsonb),
('a892faad-ac5d-45bb-af0e-1e50b3e9b5b3', 'Exercice soumis', 'terminale', 'aide moi pour la 4
', 'En cours de correction', '[]'::jsonb, '2025-12-12T18:24:17.921186+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('a57d4d54-1c49-417f-a184-9d7ff2747e6e', 'Exercice', 'Terminale', '{"contexte":"exercice ! On va prendre le temps de bien distinguer les objectifs.\nLa question sur laquelle nous sommes actuellement (1.c) est de montrer par récurrence que pour tout $n \\in \\mathbb{N}$, on a $1 \\leq u_n \\leq 2$. C''est ce qu''on appelle un **encadrement** de la suite.\nCe que tu mentionnes, \"$u_{n+1}$ soit compris entre $1$ et $u_n$\", c''est une propriété qui permet de montrer que la suite est **décroissante** et **minorée par 1**. Ça, c''est l''objectif de la question 2.a, qui vient juste après !\nC''est très facile de mélanger les deux, car les preuves par récurrence se ressemblent souvent.\nPour l''instant, restons concentrés sur la question 1.c : \"Montrer par récurrence que pour tout $n \\in \\mathbb{N}$, $1 \\leq u_n \\leq 2$\".\n**Reprenons l''initialisation de cette question 1.c :**","questions":["**Initialisation :** On doit vérifier la propriété pour $n=0$."]}', 'À résoudre', '[]'::jsonb, '2025-12-12T18:31:51.253695+00:00'::timestamptz, NULL, '{}'::jsonb),
('22cddd18-886a-4da1-ab26-ed58402e752e', 'Exercice soumis', 'Terminale', 'aidde moi à la question 2', 'En cours de correction', '[]'::jsonb, '2025-12-12T18:43:44.003205+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('16a8f0b4-c878-409c-bb8b-d029d7acffd7', 'Suites numériques', 'Terminale', '{"questions":["Calcule $U_1$ et $U_2$.","Émets une conjecture sur le sens de variation de la suite $(U_n)$.","Démontre par récurrence que pour tout entier naturel $n$, $U_n > 2$.","Démontre que la suite $(U_n)$ est décroissante.","Que peux-tu en déduire quant à la convergence de la suite $(U_n)$ ?"],"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n$ par $U_0 = 3$ et $U_{n+1} = \\frac{1}{2}U_n + 1$."}', '1. Calcul de $U_1$ et $U_2$ :
$U_1 = \frac{1}{2}U_0 + 1 = \frac{1}{2}(3) + 1 = 1.5 + 1 = 2.5$
$U_2 = \frac{1}{2}U_1 + 1 = \frac{1}{2}(2.5) + 1 = 1.25 + 1 = 2.25$

2. Conjecture sur le sens de variation :
On observe que $U_0 = 3$, $U_1 = 2.5$, $U_2 = 2.25$. Les termes semblent diminuer. On peut conjecturer que la suite $(U_n)$ est décroissante.

3. Démonstration par récurrence que pour tout entier naturel $n$, $U_n > 2$ :
  * Initialisation : Pour $n=0$, $U_0 = 3$. Or $3 > 2$, donc la propriété est vraie au rang 0.
  * Hérédité : Supposons que pour un certain entier naturel $n$, la propriété est vraie, c''est-à-dire $U_n > 2$. Montrons qu''alors $U_{n+1} > 2$.
    Puisque $U_n > 2$, en multipliant par $\frac{1}{2}$ (qui est positif), on obtient $\frac{1}{2}U_n > \frac{1}{2}(2)$, soit $\frac{1}{2}U_n > 1$.
    En ajoutant 1 aux deux membres, on a $\frac{1}{2}U_n + 1 > 1 + 1$, ce qui donne $U_{n+1} > 2$.
    La propriété est donc héréditaire.
  * Conclusion : D''après le principe de récurrence, la propriété $U_n > 2$ est vraie pour tout entier naturel $n$.

4. Démonstration que la suite $(U_n)$ est décroissante :
Pour étudier le sens de variation, calculons $U_{n+1} - U_n$ :
$U_{n+1} - U_n = (\frac{1}{2}U_n + 1) - U_n = 1 - \frac{1}{2}U_n = \frac{2 - U_n}{2}$
On sait d''après la question précédente que $U_n > 2$. Cela signifie que $2 - U_n < 0$.
Donc, $U_{n+1} - U_n = \frac{2 - U_n}{2} < 0$.
Puisque $U_{n+1} - U_n < 0$, la suite $(U_n)$ est décroissante.

5. Que peux-tu en déduire quant à la convergence de la suite $(U_n)$ ?
La suite $(U_n)$ est décroissante et minorée par 2 (puisque $U_n > 2$ pour tout $n$).
Donc, d''après le théorème de convergence monotone, la suite $(U_n)$ converge.', '["Pour calculer $U_1$, remplace $n$ par 0 dans la formule de récurrence. Fais de même pour $U_2$.","Pour la conjecture, regarde si les termes augmentent ou diminuent.","Pour l''initialisation de la récurrence, vérifie la propriété pour $n=0$. Pour l''hérédité, suppose $U_n > 2$ et essaie de montrer $U_{n+1} > 2$.","Pour montrer que la suite est décroissante, étudie le signe de $U_{n+1} - U_n$. Utilise le résultat de la question précédente ($U_n > 2$).","Une suite décroissante et minorée (c''est-à-dire qu''elle ne peut pas descendre en dessous d''une certaine valeur) est forcément convergente."]'::jsonb, '2025-12-12T18:53:25.858723+00:00'::timestamptz, 'e4187ef69fb0f39868b6c7b59a5cfd648acafb3eb367ca14f011dd74596e460a', NULL),
('dafd213d-b0c6-4f32-8feb-af251ba1b414', 'Suites numériques', 'Terminale', '{"questions":["Calcule $U_1$ et $U_2$.","Émets une conjecture sur le sens de variation de la suite $(U_n)$.","Démontre par récurrence que pour tout entier naturel $n$, $U_n > 3$.","Démontre que la suite $(U_n)$ est décroissante.","Que peux-tu en déduire quant à la convergence de la suite $(U_n)$ ?"],"contexte":"Soit la suite $(U_n)$ définie pour tout entier naturel $n$ par $U_0 = 5$ et $U_{n+1} = \\frac{1}{3}U_n + 2$."}', '1. Calcul de $U_1$ et $U_2$ :
$U_1 = \frac{1}{3}U_0 + 2 = \frac{1}{3}(5) + 2 = \frac{5}{3} + 2 = \frac{5+6}{3} = \frac{11}{3} \approx 3.67$
$U_2 = \frac{1}{3}U_1 + 2 = \frac{1}{3}(\frac{11}{3}) + 2 = \frac{11}{9} + 2 = \frac{11+18}{9} = \frac{29}{9} \approx 3.22$

2. Conjecture sur le sens de variation :
On observe que $U_0 = 5$, $U_1 \approx 3.67$, $U_2 \approx 3.22$. Les termes semblent diminuer. On peut conjecturer que la suite $(U_n)$ est décroissante.

3. Démonstration par récurrence que pour tout entier naturel $n$, $U_n > 3$ :
  * Initialisation : Pour $n=0$, $U_0 = 5$. Or $5 > 3$, donc la propriété est vraie au rang 0.
  * Hérédité : Supposons que pour un certain entier naturel $n$, la propriété est vraie, c''est-à-dire $U_n > 3$. Montrons qu''alors $U_{n+1} > 3$.
    Puisque $U_n > 3$, en multipliant par $\frac{1}{3}$ (qui est positif), on obtient $\frac{1}{3}U_n > \frac{1}{3}(3)$, soit $\frac{1}{3}U_n > 1$.
    En ajoutant 2 aux deux membres, on a $\frac{1}{3}U_n + 2 > 1 + 2$, ce qui donne $U_{n+1} > 3$.
    La propriété est donc héréditaire.
  * Conclusion : D''après le principe de récurrence, la propriété $U_n > 3$ est vraie pour tout entier naturel $n$.

4. Démonstration que la suite $(U_n)$ est décroissante :
Pour étudier le sens de variation, calculons $U_{n+1} - U_n$ :
$U_{n+1} - U_n = (\frac{1}{3}U_n + 2) - U_n = 2 - \frac{2}{3}U_n = \frac{6 - 2U_n}{3} = \frac{2(3 - U_n)}{3}$
On sait d''après la question précédente que $U_n > 3$. Cela signifie que $3 - U_n < 0$.
Donc, $U_{n+1} - U_n = \frac{2(3 - U_n)}{3} < 0$.
Puisque $U_{n+1} - U_n < 0$, la suite $(U_n)$ est décroissante.

5. Que peux-tu en déduire quant à la convergence de la suite $(U_n)$ ?
La suite $(U_n)$ est décroissante et minorée par 3 (puisque $U_n > 3$ pour tout $n$).
Donc, d''après le théorème de convergence monotone, la suite $(U_n)$ converge.', '["Pour calculer $U_1$, remplace $n$ par 0 dans la formule de récurrence. Fais de même pour $U_2$.","Pour la conjecture, regarde si les termes augmentent ou diminuent.","Pour l''initialisation de la récurrence, vérifie la propriété pour $n=0$. Pour l''hérédité, suppose $U_n > 3$ et essaie de montrer $U_{n+1} > 3$.","Pour montrer que la suite est décroissante, étudie le signe de $U_{n+1} - U_n$. Utilise le résultat de la question précédente ($U_n > 3$).","Une suite décroissante et minorée (c''est-à-dire qu''elle ne peut pas descendre en dessous d''une certaine valeur) est forcément convergente."]'::jsonb, '2025-12-12T18:54:13.709484+00:00'::timestamptz, '04fabaa31f8dd6d65bd3c89c1692de7541a566788f4ae1c18b5e6719bc0d84d6', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('0476c774-6b7c-427b-b132-f3f7f832a1c0', 'Exercice', 'Première', '{"contexte":"un exercice complet pour bien t''entraîner. Prends ton temps pour chaque question. N''hésite pas si tu bloques !\",\n  \"chapitre\": \"Dérivation\",\n  \"enonce\": {\n    \"contexte\": \"On considère la fonction $f$ définie sur $\\\\mathbb{R}$ par $f(x) = x^3 - 3x^2 - 9x + 5$.\",\n    \"questions\": [\n      \"1. Calculer la fonction dérivée $f''$ de $f$.\",\n      \"2. Étudier le signe de la dérivée $f''(x)$.\",\n      \"3. En déduire le tableau de variations de la fonction $f$.\",\n      \"4. Calculer les extremums locaux (valeurs maximales et minimales) de la fonction $f$.\"\n    ]\n  },\n  \"indices\": [\n    \"Pour la question 1, rappelle-toi les formules de dérivation des puissances : $(x^n)'' = nx^{n-1}$ et la dérivée d''une constante : $(c)'' = 0$.\",\n    \"Pour la question 2, $f''(x)$ est un polynôme du second degré. Pense à calculer le discriminant $\\\\Delta$ pour trouver ses racines et en déduire le signe.\",\n    \"Pour la question 3, si $f''(x) > 0$, la fonction $f$ est croissante. Si $f''(x) < 0$, la fonction $f$ est décroissante.\",\n    \"Pour la question 4, les extremums locaux se trouvent aux points où la dérivée s''annule en changeant de signe. Il suffit de calculer $f(x)$ pour ces valeurs de $x$.\"\n  ],\n  \"solution_complete\": \"1. La fonction $f$ est définie par $f(x) = x^3 - 3x^2 - 9x + 5$. Sa dérivée est $f''(x) = 3x^2 - 6x - 9$.\\n\\n2. Pour étudier le signe de $f''(x) = 3x^2 - 6x - 9$, on cherche ses racines. C''est un polynôme du second degré de la forme $ax^2 + bx + c$ avec $a=3$, $b=-6$, $c=-9$. Le discriminant est $\\\\Delta = b^2 - 4ac = (-6)^2 - 4(3)(-9) = 36 + 108 = 144$. Les racines sont $x_1 = \\\\frac{-b - \\\\sqrt{\\\\Delta}}{2a} = \\\\frac{6 - \\\\sqrt{144}}{2(3)} = \\\\frac{6 - 12}{6} = \\\\frac{-6}{6} = -1$ et $x_2 = \\\\frac{-b + \\\\sqrt{\\\\Delta}}{2a} = \\\\frac{6 + 12}{6} = \\\\frac{18}{6} = 3$. Puisque $a=3 > 0$, $f''(x)$ est positive à l''extérieur des racines et négative entre les racines. Donc $f''(x) > 0$ sur $]-\\\\infty, -1[ \\\\cup ]3, +\\\\infty[$ et $f''(x) < 0$ sur $]-1, 3[$.\\n\\n3. Tableau de variations :\\n$x$         $|-\\\\infty$    $-1$    $3$    $+\\\\infty|$\\n$f''(x)$     $|+$    $0$    $-$    $0$    $+|$\\n$f(x)$      $|\\\\nearrow$    $10$    $\\\\searrow$    $-22$    $\\\\nearrow|$\\n\\n4. La fonction $f$ admet un maximum local en $x = -1$ et un minimum local en $x = 3$. Les valeurs de ces extremums sont :\\nMaximum local : $f(-1) = (-1)^3 - 3(-1)^2 - 9(-1) + 5 = -1 - 3(1) + 9 + 5 = -1 - 3 + 9 + 5 = 10$.\\nMinimum local : $f(3) = (3)^3 - 3(3)^2 - 9(3) + 5 = 27 - 3(9) - 27 + 5 = 27 - 27 - 27 + 5 = -22$.\",\n  \"difficulte\": \"moyen\"\n}\nCORRECT: Super idée, Mam ! L''étude de fonctions est un chapitre central en Première. Je t''ai préparé un exercice complet pour bien t''entraîner. Prends ton temps pour chaque question. N''hésite pas si tu bloques !\nOn considère la fonction $f$ définie sur $\\\\mathbb{R}$ par $f(x) = x^3 - 3x^2 - 9x + 5$.","questions":["Calculer la fonction dérivée $f''$ de $f$.","Étudier le signe de la dérivée $f''(x)$.","En déduire le tableau de variations de la fonction $f$.","Calculer les extremums locaux (valeurs maximales et minimales) de la fonction $f$."]}', 'À résoudre', '[]'::jsonb, '2025-12-13T15:59:29.844912+00:00'::timestamptz, NULL, '{}'::jsonb),
('2f403951-e5cd-4002-af53-88dfc67fd4fe', 'Dérivation', 'terminale', '{"questions":["Identifie clairement les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Détermine l''expression de la dérivée $u''(x)$ de la fonction $u(x)$.","Détermine l''expression de la dérivée $v''(x)$ de la fonction $v(x)$, en utilisant la forme $x^n$ pour $\\sqrt{x}$.","Écris la formule générale de la dérivée d''un quotient de deux fonctions $u(x)$ et $v(x)$.","Applique cette formule pour trouver l''expression de $f''(x)$.","Simplifie l''expression de $f''(x)$ au maximum, en veillant à ne pas faire d''erreur de calcul."],"contexte":"Soit la fonction $f$ définie sur $I = ]0; +\\infty[$ par $f(x) = \\frac{2x^2 + 5}{3\\sqrt{x}}$."}', 'Pour la fonction $f(x) = \frac{2x^2 + 5}{3\sqrt{x}}$:

1.  **Identification de $u(x)$ et $v(x)$**:
    $u(x) = 2x^2 + 5$
    $v(x) = 3\sqrt{x} = 3x^{\frac{1}{2}}$

2.  **Dérivée de $u(x)$**:
    $u''(x) = 2 \times 2x^{2-1} + 0 = 4x$

3.  **Dérivée de $v(x)$**:
    $v''(x) = 3 \times \frac{1}{2}x^{\frac{1}{2}-1} = \frac{3}{2}x^{-\frac{1}{2}} = \frac{3}{2\sqrt{x}}$

4.  **Formule de la dérivée d''un quotient**:
    $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$

5.  **Application de la formule**:
    $f''(x) = \frac{(4x)(3\sqrt{x}) - (2x^2 + 5)(\frac{3}{2\sqrt{x}})}{(3\sqrt{x})^2}$
    $f''(x) = \frac{12x\sqrt{x} - \frac{3(2x^2 + 5)}{2\sqrt{x}}}{9x}$

6.  **Simplification de $f''(x)$**:
    Pour simplifier, on met le numérateur sur un dénominateur commun $2\sqrt{x}$:
    $12x\sqrt{x} = \frac{12x\sqrt{x} \times 2\sqrt{x}}{2\sqrt{x}} = \frac{24x^2}{2\sqrt{x}}$
    Donc, le numérateur devient:
    $\frac{24x^2 - 3(2x^2 + 5)}{2\sqrt{x}} = \frac{24x^2 - 6x^2 - 15}{2\sqrt{x}} = \frac{18x^2 - 15}{2\sqrt{x}}$
    Maintenant, on divise par $9x$:
    $f''(x) = \frac{\frac{18x^2 - 15}{2\sqrt{x}}}{9x} = \frac{18x^2 - 15}{2\sqrt{x} \times 9x} = \frac{18x^2 - 15}{18x\sqrt{x}}$
    On peut factoriser par 3 au numérateur:
    $f''(x) = \frac{3(6x^2 - 5)}{18x\sqrt{x}} = \frac{6x^2 - 5}{6x\sqrt{x}}$
    On peut aussi écrire $\sqrt{x}$ comme $x^{1/2}$ pour une simplification plus poussée:
    $f''(x) = \frac{6x^2 - 5}{6x^{3/2}}$', '["Rappelle-toi que $\\sqrt{x} = x^{\\frac{1}{2}}$ pour la dérivation.","La formule de dérivation d''un quotient est $(u/v)'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas de factoriser le numérateur pour simplifier au maximum.","Vérifie tes calculs d''opérations sur les fractions."]'::jsonb, '2025-12-13T16:04:17.132359+00:00'::timestamptz, '53795a2961d55e34750f84d33f975c3affaceb70ea583b4290d25b12e35a5226', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('29aa2648-fdeb-41ce-a3fe-2873b60a7b78', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $I = ]0; +\\infty[$ par $f(x) = \\frac{2x^2 + 5}{3\\sqrt{x}}$.","questions":["Identifie clairement les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Détermine l''expression de la dérivée $u''(x)$ de la fonction $u(x)$.","Détermine l''expression de la dérivée $v''(x)$ de la fonction $v(x)$, en utilisant la forme $x^n$ pour $\\sqrt{x}$.","Écris la formule générale de la dérivée d''un quotient de deux fonctions $u(x)$ et $v(x)$.","Applique cette formule pour trouver l''expression de $f''(x)$.","Simplifie l''expression de $f''(x)$ au maximum, en veillant à ne pas faire d''erreur de calcul."]}', 'Pour la fonction $f(x) = \frac{2x^2 + 5}{3\sqrt{x}}$:

1.  **Identification de $u(x)$ et $v(x)$**:
    $u(x) = 2x^2 + 5$
    $v(x) = 3\sqrt{x} = 3x^{\frac{1}{2}}$

2.  **Dérivée de $u(x)$**:
    $u''(x) = 2 \times 2x^{2-1} + 0 = 4x$

3.  **Dérivée de $v(x)$**:
    $v''(x) = 3 \times \frac{1}{2}x^{\frac{1}{2}-1} = \frac{3}{2}x^{-\frac{1}{2}} = \frac{3}{2\sqrt{x}}$

4.  **Formule de la dérivée d''un quotient**:
    $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$

5.  **Application de la formule**:
    $f''(x) = \frac{(4x)(3\sqrt{x}) - (2x^2 + 5)(\frac{3}{2\sqrt{x}})}{(3\sqrt{x})^2}$
    $f''(x) = \frac{12x\sqrt{x} - \frac{3(2x^2 + 5)}{2\sqrt{x}}}{9x}$

6.  **Simplification de $f''(x)$**:
    Pour simplifier, on met le numérateur sur un dénominateur commun $2\sqrt{x}$:
    $12x\sqrt{x} = \frac{12x\sqrt{x} \times 2\sqrt{x}}{2\sqrt{x}} = \frac{24x^2}{2\sqrt{x}}$
    Donc, le numérateur devient:
    $\frac{24x^2 - 3(2x^2 + 5)}{2\sqrt{x}} = \frac{24x^2 - 6x^2 - 15}{2\sqrt{x}} = \frac{18x^2 - 15}{2\sqrt{x}}$
    Maintenant, on divise par $9x$:
    $f''(x) = \frac{\frac{18x^2 - 15}{2\sqrt{x}}}{9x} = \frac{18x^2 - 15}{2\sqrt{x} \times 9x} = \frac{18x^2 - 15}{18x\sqrt{x}}$
    On peut factoriser par 3 au numérateur:
    $f''(x) = \frac{3(6x^2 - 5)}{18x\sqrt{x}} = \frac{6x^2 - 5}{6x\sqrt{x}}$
    On peut aussi écrire $\sqrt{x}$ comme $x^{1/2}$ pour une simplification plus poussée:
    $f''(x) = \frac{6x^2 - 5}{6x^{3/2}}$', '["Rappelle-toi que $\\sqrt{x} = x^{\\frac{1}{2}}$ pour la dérivation.","La formule de dérivation d''un quotient est $(u/v)'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas de factoriser le numérateur pour simplifier au maximum.","Vérifie tes calculs d''opérations sur les fractions."]'::jsonb, '2025-12-13T23:56:23.682604+00:00'::timestamptz, NULL, '{}'::jsonb),
('c656013f-dbb7-4395-8c13-e5317d6bdbac', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $I = ]0; +\\infty[$ par $f(x) = \\frac{2x^2 + 5}{3\\sqrt{x}}$.","questions":["Identifie clairement les fonctions $u(x)$ et $v(x)$ telles que $f(x) = \\frac{u(x)}{v(x)}$.","Détermine l''expression de la dérivée $u''(x)$ de la fonction $u(x)$.","Détermine l''expression de la dérivée $v''(x)$ de la fonction $v(x)$, en utilisant la forme $x^n$ pour $\\sqrt{x}$.","Écris la formule générale de la dérivée d''un quotient de deux fonctions $u(x)$ et $v(x)$.","Applique cette formule pour trouver l''expression de $f''(x)$.","Simplifie l''expression de $f''(x)$ au maximum, en veillant à ne pas faire d''erreur de calcul."]}', 'Pour la fonction $f(x) = \frac{2x^2 + 5}{3\sqrt{x}}$:

1.  **Identification de $u(x)$ et $v(x)$**:
    $u(x) = 2x^2 + 5$
    $v(x) = 3\sqrt{x} = 3x^{\frac{1}{2}}$

2.  **Dérivée de $u(x)$**:
    $u''(x) = 2 \times 2x^{2-1} + 0 = 4x$

3.  **Dérivée de $v(x)$**:
    $v''(x) = 3 \times \frac{1}{2}x^{\frac{1}{2}-1} = \frac{3}{2}x^{-\frac{1}{2}} = \frac{3}{2\sqrt{x}}$

4.  **Formule de la dérivée d''un quotient**:
    $f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2}$

5.  **Application de la formule**:
    $f''(x) = \frac{(4x)(3\sqrt{x}) - (2x^2 + 5)(\frac{3}{2\sqrt{x}})}{(3\sqrt{x})^2}$
    $f''(x) = \frac{12x\sqrt{x} - \frac{3(2x^2 + 5)}{2\sqrt{x}}}{9x}$

6.  **Simplification de $f''(x)$**:
    Pour simplifier, on met le numérateur sur un dénominateur commun $2\sqrt{x}$:
    $12x\sqrt{x} = \frac{12x\sqrt{x} \times 2\sqrt{x}}{2\sqrt{x}} = \frac{24x^2}{2\sqrt{x}}$
    Donc, le numérateur devient:
    $\frac{24x^2 - 3(2x^2 + 5)}{2\sqrt{x}} = \frac{24x^2 - 6x^2 - 15}{2\sqrt{x}} = \frac{18x^2 - 15}{2\sqrt{x}}$
    Maintenant, on divise par $9x$:
    $f''(x) = \frac{\frac{18x^2 - 15}{2\sqrt{x}}}{9x} = \frac{18x^2 - 15}{2\sqrt{x} \times 9x} = \frac{18x^2 - 15}{18x\sqrt{x}}$
    On peut factoriser par 3 au numérateur:
    $f''(x) = \frac{3(6x^2 - 5)}{18x\sqrt{x}} = \frac{6x^2 - 5}{6x\sqrt{x}}$
    On peut aussi écrire $\sqrt{x}$ comme $x^{1/2}$ pour une simplification plus poussée:
    $f''(x) = \frac{6x^2 - 5}{6x^{3/2}}$', '["Rappelle-toi que $\\sqrt{x} = x^{\\frac{1}{2}}$ pour la dérivation.","La formule de dérivation d''un quotient est $(u/v)'' = \\frac{u''v - uv''}{v^2}$.","N''oublie pas de factoriser le numérateur pour simplifier au maximum.","Vérifie tes calculs d''opérations sur les fractions."]'::jsonb, '2025-12-13T23:57:05.7525+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('301bb637-c672-4d6f-9068-f97bf22c3ec1', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = \\frac{3x^2 + 2x - 1}{x^2 + 4}$.","questions":["Identifie clairement les fonctions $u(x)$ et $v(x)$ qui composent $f(x)$.","Détermine l''expression de la dérivée $u''(x)$ de la fonction $u(x)$.","Détermine l''expression de la dérivée $v''(x)$ de la fonction $v(x)$.","Écris la formule générale de la dérivée d''un quotient de deux fonctions $u(x)$ et $v(x)$.","Applique cette formule pour trouver l''expression de $f''(x)$.","Simplifie l''expression de $f''(x)$ au maximum."]}', 'Pour la fonction $f(x) = \frac{3x^2 + 2x - 1}{x^2 + 4}$ :

- On identifie $u(x) = 3x^2 + 2x - 1$ et $v(x) = x^2 + 4$.

- On calcule leurs dérivées :
  $u''(x) = 6x + 2$
  $v''(x) = 2x$

- La formule de la dérivée d''un quotient est $f''(x) = \frac{u''v - uv''}{v^2}$.

- On applique la formule :
  $f''(x) = \frac{(6x+2)(x^2+4) - (3x^2+2x-1)(2x)}{(x^2+4)^2}$

- On développe le numérateur :
  $(6x^3 + 24x + 2x^2 + 8) - (6x^3 + 4x^2 - 2x)$
  $= 6x^3 + 2x^2 + 24x + 8 - 6x^3 - 4x^2 + 2x$
  $= -2x^2 + 26x + 8$

- Donc, $f''(x) = \frac{-2x^2 + 26x + 8}{(x^2+4)^2}$.', '["Rappelle-toi que la dérivée d''un quotient $\\frac{u}{v}$ est $\\frac{u''v - uv''}{v^2}$.","Fais attention aux signes lors de la simplification du numérateur.","N''oublie pas de développer et de réduire le numérateur."]'::jsonb, '2025-12-13T23:57:25.282981+00:00'::timestamptz, '17ff0aa4b5bc31f7badfb6c1ff08483b803c870aa70843bcf876d32d2a4d3ce0', NULL),
('c21362b2-0c9d-4f03-93af-a93c7cfe7535', 'Intégrales', 'terminale', '{"contexte":"On considère la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = 3x^2 + 2x - 1$.","questions":["Détermine une primitive $F$ de $f$ sur $\\mathbb{R}$.","Calcule l''intégrale de $f$ entre $0$ et $2$, c''est-à-dire $\\int_0^2 f(x)dx$."]}', '1. Pour déterminer une primitive $F$ de $f(x) = 3x^2 + 2x - 1$ :
Les primitives de $3x^2$ sont $3 \times \frac{x^{2+1}}{2+1} = 3 \times \frac{x^3}{3} = x^3$.
Les primitives de $2x$ sont $2 \times \frac{x^{1+1}}{1+1} = 2 \times \frac{x^2}{2} = x^2$.
Les primitives de $-1$ sont $-x$.
Donc, une primitive $F$ de $f$ est $F(x) = x^3 + x^2 - x + C$, où $C$ est une constante.

2. Pour calculer l''intégrale de $f$ entre $0$ et $2$ :
$\int_0^2 f(x)dx = [F(x)]_0^2 = F(2) - F(0)$.
$F(2) = 2^3 + 2^2 - 2 = 8 + 4 - 2 = 10$.
$F(0) = 0^3 + 0^2 - 0 = 0$.
Donc, $\int_0^2 f(x)dx = 10 - 0 = 10$.', '["Pour trouver une primitive d''une fonction polynomiale, tu peux utiliser la règle de puissance : $\\int x^n dx = \\frac{x^{n+1}}{n+1} + C$.","N''oublie pas d''appliquer la formule du calcul d''intégrale : $\\int_a^b f(x)dx = F(b) - F(a)$."]'::jsonb, '2025-12-14T00:55:31.151569+00:00'::timestamptz, '7a6f3254c54165f2b2e239447b8e3d7731fdfb0a2e813da40c4cac8e68099711', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('02ab299c-fc28-4de5-8562-19fbda37b6fa', 'Intégrales', 'terminale', '{"contexte":"On considère la fonction $f$ définie sur $[1; e]$ par $f(x) = x \\ln(x)$.","questions":["Justifie pourquoi la fonction $f$ est continue sur l''intervalle $[1; e]$.","Pour calculer l''intégrale $\\int_1^e x \\ln(x) dx$, propose le choix de $u(x)$ et $v''(x)$ si tu utilises l''intégration par parties.","Calcule $u''(x)$ et $v(x)$ à partir de tes choix précédents.","Applique la formule d''intégration par parties pour exprimer l''intégrale $\\int_1^e x \\ln(x) dx$.","Calcule la valeur exacte de cette intégrale."]}', '1. La fonction $f(x) = x \ln(x)$ est le produit de deux fonctions continues sur $[1; e]$ :
- La fonction $g(x) = x$ est une fonction polynomiale, donc elle est continue sur $\mathbb{R}$, et par conséquent sur $[1; e]$.
- La fonction $h(x) = \ln(x)$ est la fonction logarithme népérien, qui est continue sur $]0; +\infty[$, et donc sur $[1; e]$.
Le produit de deux fonctions continues est continu, donc $f(x) = x \ln(x)$ est continue sur $[1; e]$.

2. Pour l''intégration par parties, on choisit :
$u(x) = \ln(x)$ (car sa dérivée est plus simple)
$v''(x) = x$

3. On calcule :
$u''(x) = \frac{1}{x}$
$v(x) = \frac{x^2}{2}$

4. Application de la formule d''intégration par parties :
$\int_1^e x \ln(x) dx = [\ln(x) \frac{x^2}{2}]_1^e - \int_1^e \frac{1}{x} \frac{x^2}{2} dx$
$= [\frac{x^2 \ln(x)}{2}]_1^e - \int_1^e \frac{x}{2} dx$
$= [\frac{x^2 \ln(x)}{2}]_1^e - [\frac{x^2}{4}]_1^e$

5. Calcul de la valeur exacte de l''intégrale :
$[\frac{x^2 \ln(x)}{2}]_1^e = (\frac{e^2 \ln(e)}{2}) - (\frac{1^2 \ln(1)}{2}) = \frac{e^2 \times 1}{2} - \frac{1 \times 0}{2} = \frac{e^2}{2}$
$[\frac{x^2}{4}]_1^e = (\frac{e^2}{4}) - (\frac{1^2}{4}) = \frac{e^2}{4} - \frac{1}{4}$
Donc, $\int_1^e x \ln(x) dx = \frac{e^2}{2} - (\frac{e^2}{4} - \frac{1}{4})$
$= \frac{2e^2}{4} - \frac{e^2}{4} + \frac{1}{4}$
$= \frac{e^2 + 1}{4}$', '["La continuité d''une fonction est essentielle pour définir une intégrale. Rappelle-toi les propriétés des fonctions usuelles.","La formule d''intégration par parties est $\\int_a^b u(x)v''(x)dx = [u(x)v(x)]_a^b - \\int_a^b u''(x)v(x)dx$. Il est souvent judicieux de choisir $u(x)$ comme la fonction qui se simplifie par dérivation.","La primitive de $x^n$ est $\\frac{x^{n+1}}{n+1}$.","N''oublie pas que $\\ln(e) = 1$ et $\\ln(1) = 0$."]'::jsonb, '2025-12-14T00:56:07.153287+00:00'::timestamptz, 'f417bde025b83d267ec2a21144e8e4d8fcc5a94a05d6cc8ed7bb5890e7fce139', NULL),
('08f8e005-a1c7-4cd1-8d1e-9c979f934e4b', 'Calcul intégral', 'terminale', '{"contexte":"On considère la fonction $f$ définie sur $[1; e]$ par $f(x) = x \\ln(x)$.","questions":["Justifie pourquoi la fonction $f$ est continue sur l''intervalle $[1; e]$.","Pour calculer l''intégrale $\\int_1^e x \\ln(x) dx$, propose le choix de $u(x)$ et $v''(x)$ si tu utilises l''intégration par parties.","Calcule $u''(x)$ et $v(x)$ à partir de tes choix précédents.","Applique la formule d''intégration par parties pour exprimer l''intégrale $\\int_1^e x \\ln(x) dx$.","Calcule la valeur exacte de cette intégrale."]}', '1. La fonction $f(x) = x \ln(x)$ est le produit de deux fonctions continues sur $[1; e]$ :
- La fonction $g(x) = x$ est une fonction polynomiale, donc elle est continue sur $\mathbb{R}$, et par conséquent sur $[1; e]$.
- La fonction $h(x) = \ln(x)$ est la fonction logarithme népérien, qui est continue sur $]0; +\infty[$, et donc sur $[1; e]$.
Le produit de deux fonctions continues est continu, donc $f(x) = x \ln(x)$ est continue sur $[1; e]$.

2. Pour l''intégration par parties, on choisit :
$u(x) = \ln(x)$ (car sa dérivée est plus simple)
$v''(x) = x$

3. On calcule :
$u''(x) = \frac{1}{x}$
$v(x) = \frac{x^2}{2}$

4. Application de la formule d''intégration par parties :
$\int_1^e x \ln(x) dx = [\ln(x) \frac{x^2}{2}]_1^e - \int_1^e \frac{1}{x} \frac{x^2}{2} dx$
$= [\frac{x^2 \ln(x)}{2}]_1^e - \int_1^e \frac{x}{2} dx$
$= [\frac{x^2 \ln(x)}{2}]_1^e - [\frac{x^2}{4}]_1^e$

5. Calcul de la valeur exacte de l''intégrale :
$[\frac{x^2 \ln(x)}{2}]_1^e = (\frac{e^2 \ln(e)}{2}) - (\frac{1^2 \ln(1)}{2}) = \frac{e^2 \times 1}{2} - \frac{1 \times 0}{2} = \frac{e^2}{2}$
$[\frac{x^2}{4}]_1^e = (\frac{e^2}{4}) - (\frac{1^2}{4}) = \frac{e^2}{4} - \frac{1}{4}$
Donc, $\int_1^e x \ln(x) dx = \frac{e^2}{2} - (\frac{e^2}{4} - \frac{1}{4})$
$= \frac{2e^2}{4} - \frac{e^2}{4} + \frac{1}{4}$
$= \frac{e^2 + 1}{4}$', '["La continuité d''une fonction est essentielle pour définir une intégrale. Rappelle-toi les propriétés des fonctions usuelles.","La formule d''intégration par parties est $\\int_a^b u(x)v''(x)dx = [u(x)v(x)]_a^b - \\int_a^b u''(x)v(x)dx$. Il est souvent judicieux de choisir $u(x)$ comme la fonction qui se simplifie par dérivation.","La primitive de $x^n$ est $\\frac{x^{n+1}}{n+1}$.","N''oublie pas que $\\ln(e) = 1$ et $\\ln(1) = 0$."]'::jsonb, '2025-12-14T00:56:43.859001+00:00'::timestamptz, NULL, '{}'::jsonb);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('61840297-f16a-4b42-b57c-2559c85092c1', 'Calcul intégral', 'terminale', '{"questions":["Justifie la continuité de la fonction $f$ sur l''intervalle $[0; \\pi]$. Explique clairement ton raisonnement.","Pour calculer l''intégrale $\\int_0^{\\pi} x \\cos(x) dx$ en utilisant l''intégration par parties, identifie les fonctions $u(x)$ et $v''(x)$. Explique ton choix.","Calcule la dérivée $u''(x)$ et la primitive $v(x)$ à partir de tes choix précédents. Détaille tes calculs.","Applique la formule d''intégration par parties et exprime l''intégrale $\\int_0^{\\pi} x \\cos(x) dx$ sous une forme simplifiée.","Calcule la valeur exacte de cette intégrale. N''oublie pas les valeurs remarquables de $\\sin$ et $\\cos$."],"contexte":"On considère la fonction $f$ définie sur $[0; \\pi]$ par $f(x) = x \\cos(x)$."}', '1. La fonction $f(x) = x \cos(x)$ est le produit de deux fonctions continues sur $[0; \pi]$ :
- La fonction $g(x) = x$ est une fonction polynomiale, donc elle est continue sur $\mathbb{R}$, et par conséquent sur $[0; \pi]$.
- La fonction $h(x) = \cos(x)$ est une fonction trigonométrique, qui est continue sur $\mathbb{R}$, et donc sur $[0; \pi]$.
Le produit de deux fonctions continues est continu, donc $f(x) = x \cos(x)$ est continue sur $[0; \pi]$.

2. Pour l''intégration par parties, on choisit :
$u(x) = x$ (car sa dérivée est $1$, ce qui simplifie le calcul)
$v''(x) = \cos(x)$

3. On calcule :
$u''(x) = 1$
$v(x) = \sin(x)$

4. Application de la formule d''intégration par parties :
$\int_0^{\pi} x \cos(x) dx = [x \sin(x)]_0^{\pi} - \int_0^{\pi} 1 \cdot \sin(x) dx$
$= [x \sin(x)]_0^{\pi} - \int_0^{\pi} \sin(x) dx$
$= [x \sin(x)]_0^{\pi} - [-\cos(x)]_0^{\pi}$
$= [x \sin(x)]_0^{\pi} + [\cos(x)]_0^{\pi}$

5. Calcul de la valeur exacte de l''intégrale :
$[x \sin(x)]_0^{\pi} = (\pi \sin(\pi)) - (0 \cdot \sin(0)) = (\pi \cdot 0) - (0 \cdot 0) = 0 - 0 = 0$
$[\cos(x)]_0^{\pi} = \cos(\pi) - \cos(0) = -1 - 1 = -2$
Donc, $\int_0^{\pi} x \cos(x) dx = 0 + (-2) = -2$', '["Rappelle-toi que les fonctions polynomiales et trigonométriques sont continues sur leur domaine de définition. Le produit de fonctions continues est aussi continu.","Pour l''intégration par parties, une astuce est de choisir $u(x)$ comme la fonction qui se simplifie après dérivation, et $v''(x)$ comme la fonction dont la primitive est facile à trouver.","La primitive de $\\cos(x)$ est $\\sin(x)$. La dérivée de $x$ est $1$.","La formule d''intégration par parties est $\\int_a^b u(x)v''(x)dx = [u(x)v(x)]_a^b - \\int_a^b u''(x)v(x)dx$.","N''oublie pas que $\\cos(\\pi) = -1$, $\\cos(0) = 1$, $\\sin(\\pi) = 0$ et $\\sin(0) = 0$."]'::jsonb, '2025-12-14T02:11:11.935036+00:00'::timestamptz, '720cf8f52a87d5eab82b83f5ee41e494ccbddcc3c7fda22b3e5c67c23f2f8f08', NULL),
('311bbff0-a412-4449-88d3-40fd1bc2a8c6', 'Probabilités', 'terminale', '{"questions":["Précise la population et le caractère étudié dans cette expérience.","Définis clairement l''épreuve de Bernoulli et son succès dans ce contexte.","Donne la probabilité $p$ du succès de cette épreuve.","Justifie pourquoi la variable aléatoire $X$ qui compte le nombre d''élèves intéressés parmi les $10$ interrogés suit une loi binomiale. Énonce les trois conditions nécessaires et vérifie-les une par une.","Donne les paramètres $n$ et $p$ de cette loi binomiale."],"contexte":"Un lycée organise une élection pour élire les délégués de classe. On sait que $60\\%$ des élèves sont intéressés par la participation à la vie scolaire. On interroge au hasard $10$ élèves de ce lycée."}', '1. La population est l''ensemble de tous les élèves du lycée. Le caractère étudié est l''intérêt pour la participation à la vie scolaire.
2. L''épreuve de Bernoulli est l''interrogation d''un élève au hasard. Le succès est l''événement "L''élève est intéressé par la participation à la vie scolaire".
3. La probabilité de succès est $p = 0,6$.
4. La variable aléatoire $X$ suit une loi binomiale car :
    - L''expérience consiste en la répétition de $10$ épreuves identiques (interroger un élève) et indépendantes (le choix d''un élève n''influence pas le choix des autres).
    - Chaque épreuve n''a que deux issues possibles : succès (l''élève est intéressé) ou échec (l''élève n''est pas intéressé).
    - La probabilité de succès $p = 0,6$ reste constante pour chaque épreuve.
5. Les paramètres de cette loi binomiale sont $n = 10$ et $p = 0,6$.', '["Pour la population, pense à l''ensemble de tous les individus que l''on pourrait interroger.","Pour le caractère, pense à ce qui est observé chez chaque individu.","Une épreuve de Bernoulli doit avoir seulement deux issues.","Le succès est l''issue qui nous intéresse spécifiquement.","Les trois conditions pour une loi binomiale sont : répétition d''épreuves identiques et indépendantes, deux issues (succès/échec), et la probabilité de succès doit être constante.","Le paramètre $n$ est le nombre de répétitions de l''épreuve et $p$ est la probabilité de succès."]'::jsonb, '2025-12-14T02:32:14.236929+00:00'::timestamptz, '1843430c695cb75db24cd9fa5b84435a0d3ef4563dedefe7903f386c327b3dbd', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('7c6eb789-bc1c-4e8a-bfc5-783ed7d746bb', 'Combinatoire et dénombrement', 'terminale', '{"contexte":"Une association organise une tombola. Pour cela, elle imprime des tickets numérotés de $1$ à $150$. Un tirage au sort est effectué pour désigner les gagnants.\n\nOn définit les événements suivants :\n- $A$ : \"Le ticket tiré porte un numéro pair.\"\n- $B$ : \"Le ticket tiré porte un numéro multiple de $5$.\"\n- $C$ : \"Le ticket tiré porte un numéro qui est un carré parfait.\"","questions":["Détermine le nombre de tickets qui réalisent l''événement $A$.","Détermine le nombre de tickets qui réalisent l''événement $B$.","Détermine le nombre de tickets qui réalisent l''événement $C$.","Représente par une liste les numéros de tickets qui réalisent l''événement $C$.","Détermine le nombre de tickets qui réalisent l''événement $A \\cap B$ (numéro pair ET multiple de $5$).","Détermine le nombre de tickets qui réalisent l''événement $A \\cup B$ (numéro pair OU multiple de $5$).","Un ticket est tiré au hasard. Calcule la probabilité de l''événement $C$. Donne le résultat sous forme de fraction irréductible."]}', '1. Événement $A$ (numéro pair) : Il y a $150 / 2 = 75$ tickets pairs.
2. Événement $B$ (numéro multiple de $5$) : Il y a $150 / 5 = 30$ tickets multiples de $5$.
3. Événement $C$ (numéro carré parfait) : Les carrés parfaits inférieurs ou égaux à $150$ sont $1^2=1, 2^2=4, 3^2=9, 4^2=16, 5^2=25, 6^2=36, 7^2=49, 8^2=64, 9^2=81, 10^2=100, 11^2=121, 12^2=144$. Il y a $12$ tickets qui réalisent l''événement $C$.
4. Liste des tickets pour l''événement $C$ : $[1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144]$.
5. Événement $A \cap B$ (numéro pair ET multiple de $5$) : C''est un multiple de $10$. Il y a $150 / 10 = 15$ tickets.
6. Événement $A \cup B$ (numéro pair OU multiple de $5$) : Nombre de tickets $N(A \cup B) = N(A) + N(B) - N(A \cap B) = 75 + 30 - 15 = 90$ tickets.
7. Probabilité de l''événement $C$ : $P(C) = \frac{\text{Nombre de tickets dans } C}{\text{Nombre total de tickets}} = \frac{12}{150} = \frac{2}{25}$.', '["Pour trouver le nombre de pairs, pense à la division par $2$.","Pour les multiples de $5$, utilise la division par $5$.","Les carrés parfaits sont les nombres de la forme $k^2$. Liste-les jusqu''à ce que $k^2$ dépasse $150$.","Pour $A \\cap B$, cherche les nombres qui sont à la fois pairs et multiples de $5$. Quel type de nombre est-ce ?","Pour $A \\cup B$, utilise la formule $P(A \\cup B) = P(A) + P(B) - P(A \\cap B)$. Adapte-la en termes de nombre de tickets.","La probabilité d''un événement est le nombre de cas favorables divisé par le nombre total de cas possibles."]'::jsonb, '2025-12-14T02:40:24.253147+00:00'::timestamptz, 'd9992b5e476b84a91d132e449f876d679932124d910e803eacce85f2fb32456c', NULL),
('945c399f-6b82-4e19-a258-7e99efdc4078', 'Nombres complexes', 'terminale', '{"contexte":"Le plan complexe est muni d''un repère orthonormé direct $(O; \\vec{u}, \\vec{v})$. On considère les points $A$, $B$ et $C$ d''affixes respectives $z_A = 1 + i\\sqrt{3}$, $z_B = -1 + i$ et $z_C = 2i$.","questions":["Donne la forme exponentielle des nombres complexes $z_A$ et $z_B$.","Calcule le nombre complexe $Z = \\frac{z_A}{z_B}$ et donne-le sous forme algébrique, puis sous forme exponentielle.","Déduis-en la valeur exacte de $\\cos\\left(\\frac{11\\pi}{12}\\right)$ et $\\sin\\left(\\frac{11\\pi}{12}\\right)$.","Détermine la nature du triangle $OAB$. Justifie ta réponse."]}', '1. Formes exponentielles :
$|z_A| = |1 + i\sqrt{3}| = \sqrt{1^2 + (\sqrt{3})^2} = \sqrt{1+3} = \sqrt{4} = 2$.
Un argument $\theta_A$ tel que $\cos(\theta_A) = \frac{1}{2}$ et $\sin(\theta_A) = \frac{\sqrt{3}}{2}$, on peut choisir $\theta_A = \frac{\pi}{3}$.
Donc $z_A = 2e^{i\frac{\pi}{3}}$.

$|z_B| = |-1 + i| = \sqrt{(-1)^2 + 1^2} = \sqrt{1+1} = \sqrt{2}$.
Un argument $\theta_B$ tel que $\cos(\theta_B) = -\frac{1}{\sqrt{2}} = -\frac{\sqrt{2}}{2}$ et $\sin(\theta_B) = \frac{1}{\sqrt{2}} = \frac{\sqrt{2}}{2}$, on peut choisir $\theta_B = \frac{3\pi}{4}$.
Donc $z_B = \sqrt{2}e^{i\frac{3\pi}{4}}$.

2. Calcul de $Z = \frac{z_A}{z_B}$ :
Forme algébrique :
$Z = \frac{1 + i\sqrt{3}}{-1 + i} = \frac{(1 + i\sqrt{3})(-1 - i)}{(-1 + i)(-1 - i)} = \frac{-1 - i - i\sqrt{3} - i^2\sqrt{3}}{(-1)^2 + 1^2} = \frac{-1 - i - i\sqrt{3} + \sqrt{3}}{1 + 1} = \frac{(\sqrt{3} - 1) + i(-\sqrt{3} - 1)}{2} = \frac{\sqrt{3} - 1}{2} - i\frac{\sqrt{3} + 1}{2}$.

Forme exponentielle :
$Z = \frac{2e^{i\frac{\pi}{3}}}{\sqrt{2}e^{i\frac{3\pi}{4}}} = \frac{2}{\sqrt{2}} e^{i(\frac{\pi}{3} - \frac{3\pi}{4})} = \sqrt{2} e^{i(\frac{4\pi}{12} - \frac{9\pi}{12})} = \sqrt{2} e^{-i\frac{5\pi}{12}}$.

3. Déduction des valeurs exactes de $\cos\left(\frac{11\pi}{12}\right)$ et $\sin\left(\frac{11\pi}{12}\right)$ :
On a $Z = \sqrt{2} e^{-i\frac{5\pi}{12}} = \sqrt{2} \left(\cos\left(-\frac{5\pi}{12}\right) + i\sin\left(-\frac{5\pi}{12}\right)\right) = \sqrt{2} \left(\cos\left(\frac{5\pi}{12}\right) - i\sin\left(\frac{5\pi}{12}\right)\right)$.
En comparant avec la forme algébrique de $Z$ :
$\sqrt{2} \cos\left(\frac{5\pi}{12}\right) = \frac{\sqrt{3} - 1}{2} \implies \cos\left(\frac{5\pi}{12}\right) = \frac{\sqrt{3} - 1}{2\sqrt{2}} = \frac{\sqrt{6} - \sqrt{2}}{4}$.
$-\sqrt{2} \sin\left(\frac{5\pi}{12}\right) = -\frac{\sqrt{3} + 1}{2} \implies \sin\left(\frac{5\pi}{12}\right) = \frac{\sqrt{3} + 1}{2\sqrt{2}} = \frac{\sqrt{6} + \sqrt{2}}{4}$.

On sait que $\cos(\pi - x) = -\cos(x)$ et $\sin(\pi - x) = \sin(x)$.
$\frac{11\pi}{12} = \pi - \frac{\pi}{12}$. Ce n''est pas ce qui est attendu.
Reprenons $Z = \sqrt{2} e^{-i\frac{5\pi}{12}}$. On peut aussi écrire $Z = \sqrt{2} e^{i(-\frac{5\pi}{12} + 2\pi)} = \sqrt{2} e^{i\frac{19\pi}{12}}$.
L''énoncé demande $\cos\left(\frac{11\pi}{12}\right)$ et $\sin\left(\frac{11\pi}{12}\right)$.
On a $\frac{z_B}{z_A} = \frac{1}{Z} = \frac{1}{\sqrt{2}} e^{i\frac{5\pi}{12}}$.
$\frac{z_B}{z_A} = \frac{-1+i}{1+i\sqrt{3}} = \frac{(-1+i)(1-i\sqrt{3})}{(1+i\sqrt{3})(1-i\sqrt{3})} = \frac{-1+i\sqrt{3}+i-i^2\sqrt{3}}{1+3} = \frac{-1+i\sqrt{3}+i+\sqrt{3}}{4} = \frac{\sqrt{3}-1}{4} + i\frac{\sqrt{3}+1}{4}$.

Donc $\frac{1}{\sqrt{2}} \cos\left(\frac{5\pi}{12}\right) = \frac{\sqrt{3}-1}{4} \implies \cos\left(\frac{5\pi}{12}\right) = \frac{\sqrt{6}-\sqrt{2}}{4}$.
$\frac{1}{\sqrt{2}} \sin\left(\frac{5\pi}{12}\right) = \frac{\sqrt{3}+1}{4} \implies \sin\left(\frac{5\pi}{12}\right) = \frac{\sqrt{6}+\sqrt{2}}{4}$.

On sait que $\frac{11\pi}{12} = \frac{5\pi}{12} + \frac{6\pi}{12} = \frac{5\pi}{12} + \frac{\pi}{2}$.
$\cos\left(\frac{11\pi}{12}\right) = \cos\left(\frac{5\pi}{12} + \frac{\pi}{2}\right) = -\sin\left(\frac{5\pi}{12}\right) = -\frac{\sqrt{6} + \sqrt{2}}{4}$.
$\sin\left(\frac{11\pi}{12}\right) = \sin\left(\frac{5\pi}{12} + \frac{\pi}{2}\right) = \cos\left(\frac{5\pi}{12}\right) = \frac{\sqrt{6} - \sqrt{2}}{4}$.

4. Nature du triangle $OAB$ :
On a $|z_A| = 2$ et $|z_B| = \sqrt{2}$. Donc $OA = 2$ et $OB = \sqrt{2}$.
$\|z_B - z_A\| = \|-1+i - (1+i\sqrt{3})\| = \|-2 + i(1-\sqrt{3})\| = \sqrt{(-2)^2 + (1-\sqrt{3})^2} = \sqrt{4 + 1 - 2\sqrt{3} + 3} = \sqrt{8 - 2\sqrt{3}}$.

Calculons l''argument de $\frac{z_B}{z_A} = \frac{\sqrt{2}e^{i\frac{3\pi}{4}}}{2e^{i\frac{\pi}{3}}} = \frac{\sqrt{2}}{2} e^{i(\frac{3\pi}{4} - \frac{\pi}{3})} = \frac{\sqrt{2}}{2} e^{i(\frac{9\pi}{12} - \frac{4\pi}{12})} = \frac{\sqrt{2}}{2} e^{i\frac{5\pi}{12}}$.
L''angle $(\vec{OA}, \vec{OB})$ a pour mesure $\arg\left(\frac{z_B}{z_A}\right) = \frac{5\pi}{12} \neq \pm \frac{\pi}{2}$ et $OA \neq OB$. Le triangle n''est ni rectangle ni isocèle.
Le triangle $OAB$ est un triangle quelconque.', '["Pour la forme exponentielle, commence par calculer le module et un argument de chaque nombre complexe.","Pour calculer $Z$ sous forme algébrique, multiplie le numérateur et le dénominateur par le conjugué du dénominateur.","Pour la forme exponentielle de $Z$, utilise les propriétés du quotient des modules et des arguments.","Pour déduire les valeurs exactes, compare les deux formes de $Z$.","Pour la nature du triangle $OAB$, pense aux modules des affixes et à l''argument de $\\frac{z_B}{z_A}$ (ou $\\frac{z_A}{z_B}$)."]'::jsonb, '2025-12-14T08:40:21.506125+00:00'::timestamptz, 'f906747d034605fd25af8d6aec5dd7200c0960a0cd16cd60c0019e82d061effb', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('83bb9e20-b2fa-440c-92e9-70afc53b7011', 'Suites numériques - Théorème du point fixe', 'terminale', '{"contexte":"Imagine que tu as une fonction $f(x) = \\frac{1}{2}x + 3$. On cherche un point fixe pour cette fonction, c''est-à-dire un nombre $L$ tel que $f(L) = L$. C''est un peu comme trouver un équilibre !","questions":["Écris l''équation qui te permettrait de trouver ce point fixe $L$.","Résous cette équation pour trouver la valeur exacte de $L$."]}', 'Pour trouver le point fixe $L$, on pose $f(L) = L$.

On a donc : $L = \frac{1}{2}L + 3$

Pour résoudre cette équation :
$L - \frac{1}{2}L = 3$
$\frac{1}{2}L = 3$
$L = 3 \times 2$
$L = 6$

Le point fixe de la fonction $f(x) = \frac{1}{2}x + 3$ est $L=6$.', '["Pour trouver le point fixe, tu dois poser $f(L) = L$.","Une fois que tu as l''équation, il suffit de la résoudre comme une équation du premier degré.","Rassemble les termes en $L$ d''un côté de l''équation."]'::jsonb, '2025-12-14T10:56:32.212201+00:00'::timestamptz, '6112f7ef6bc1bf3871f11d6cccce86fb9444bf7f6223b7b62e730177ca3d8679', NULL),
('c73466f5-d1fc-434b-827e-d528418a6fcd', 'Compléments sur la dérivation', 'terminale', '{"questions":["Justifie pourquoi la fonction $f$ est bien définie sur $\\mathbb{R}$.","Identifie la fonction intérieure $u(x)$ et la fonction extérieure $v(y)$ telles que $f(x) = v(u(x))$.","Calcule la dérivée $u''(x)$ de la fonction intérieure.","Calcule la dérivée $v''(y)$ de la fonction extérieure.","Applique la formule de dérivation des fonctions composées pour déterminer l''expression de $f''(x)$.","Donne l''expression simplifiée de $f''(x)$."],"contexte":"On considère la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = \\sqrt{x^2 + 5x + 7}$."}', '1. Pour que $f(x) = \sqrt{x^2 + 5x + 7}$ soit définie, il faut que l''expression sous la racine soit positive ou nulle : $x^2 + 5x + 7 \ge 0$.
Calculons le discriminant $\Delta$ du trinôme $x^2 + 5x + 7$ :
$\Delta = b^2 - 4ac = 5^2 - 4 \times 1 \times 7 = 25 - 28 = -3$.
Puisque $\Delta < 0$ et que le coefficient de $x^2$ (qui est $1$) est positif, le trinôme $x^2 + 5x + 7$ est toujours strictement positif pour tout $x \in \mathbb{R}$.
Donc, la fonction $f$ est bien définie sur $\mathbb{R}$.

2. La fonction intérieure est $u(x) = x^2 + 5x + 7$. La fonction extérieure est $v(y) = \sqrt{y}$.

3. La dérivée de la fonction intérieure $u(x) = x^2 + 5x + 7$ est $u''(x) = 2x + 5$.

4. La dérivée de la fonction extérieure $v(y) = \sqrt{y}$ est $v''(y) = \frac{1}{2\sqrt{y}}$.

5. En appliquant la formule $f''(x) = u''(x) \times v''(u(x))$ :
$f''(x) = (2x + 5) \times \frac{1}{2\sqrt{x^2 + 5x + 7}}$.

6. L''expression simplifiée de $f''(x)$ est $f''(x) = \frac{2x + 5}{2\sqrt{x^2 + 5x + 7}}$.', '["Pour qu''une racine carrée soit définie, son argument doit être positif ou nul. Tu peux étudier le discriminant du trinôme sous la racine.","La fonction extérieure est de la forme $\\sqrt{y}$.","La dérivée de $\\sqrt{y}$ est $\\frac{1}{2\\sqrt{y}}$."]'::jsonb, '2025-12-14T13:03:27.366215+00:00'::timestamptz, 'cffbc38652085f41222235bd05c75d99116b8dc9b9f4c6faf992ee93b199f487', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('f3625957-00eb-48ed-8552-9c5c0977bdfe', 'Suites numériques', 'Terminale', '{"questions":["Calcule $U_1$ et $U_2$.","On considère la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n - 6$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$, puis $U_n$ en fonction de $n$.","Détermine la limite de la suite $(U_n)$."],"contexte":"On considère la suite $(U_n)$ définie par $U_0 = 5$ et, pour tout entier naturel $n$, $U_{n+1} = \\frac{1}{2}U_n + 3$."}', '1. Calcul de $U_1$ et $U_2$ :
$U_1 = \frac{1}{2}U_0 + 3 = \frac{1}{2}(5) + 3 = 2.5 + 3 = 5.5$
$U_2 = \frac{1}{2}U_1 + 3 = \frac{1}{2}(5.5) + 3 = 2.75 + 3 = 5.75$

2. Démontrons que $(V_n)$ est une suite géométrique :
On a $V_n = U_n - 6$, donc $U_n = V_n + 6$.
$V_{n+1} = U_{n+1} - 6$
$V_{n+1} = (\frac{1}{2}U_n + 3) - 6$
$V_{n+1} = \frac{1}{2}U_n - 3$
En remplaçant $U_n$ par $V_n + 6$ :
$V_{n+1} = \frac{1}{2}(V_n + 6) - 3$
$V_{n+1} = \frac{1}{2}V_n + \frac{1}{2}(6) - 3$
$V_{n+1} = \frac{1}{2}V_n + 3 - 3$
$V_{n+1} = \frac{1}{2}V_n$
La suite $(V_n)$ est donc une suite géométrique de raison $q = \frac{1}{2}$.
Son premier terme est $V_0 = U_0 - 6 = 5 - 6 = -1$.

3. Expression de $V_n$ et $U_n$ en fonction de $n$ :
Comme $(V_n)$ est une suite géométrique de raison $q = \frac{1}{2}$ et de premier terme $V_0 = -1$, on a :
$V_n = V_0 \times q^n = -1 \times (\frac{1}{2})^n = -(\frac{1}{2})^n$

Pour $U_n$, on sait que $U_n = V_n + 6$, donc :
$U_n = -(\frac{1}{2})^n + 6$

4. Limite de la suite $(U_n)$ :
On cherche $\lim_{n \to +\infty} U_n$.
On a $U_n = -(\frac{1}{2})^n + 6$.
Comme $0 < \frac{1}{2} < 1$, on sait que $\lim_{n \to +\infty} (\frac{1}{2})^n = 0$.
Donc $\lim_{n \to +\infty} -(\frac{1}{2})^n = 0$.
Par conséquent, $\lim_{n \to +\infty} U_n = 0 + 6 = 6$.', '["Pour calculer $U_1$ et $U_2$, utilise la formule de récurrence $U_{n+1} = \\frac{1}{2}U_n + 3$.","Pour démontrer que $(V_n)$ est géométrique, exprime $V_{n+1}$ en fonction de $V_n$.","Une suite géométrique de raison $q$ et de premier terme $V_0$ s''écrit $V_n = V_0 \\times q^n$.","Pour la limite, souviens-toi de la limite de $q^n$ quand $n \\to +\\infty$ pour $|q| < 1$."]'::jsonb, '2025-12-14T13:15:58.191049+00:00'::timestamptz, 'eea0a3df7052e719c9230b90668234d810d309237228cb4c420906ada92f60d5', NULL),
('45c765dc-faa7-4084-8e2f-d8f35dd61bca', 'Intégrales', 'Terminale', '{"contexte":"Soit $f$ la fonction définie sur $\\mathbb{R}$ par $f(x) = x^2 - 4x + 3$. On note $\\mathcal{C}_f$ sa courbe représentative dans un repère orthogonal.","questions":["Détermine les points d''intersection de la courbe $\\mathcal{C}_f$ avec l''axe des abscisses.","Calcule la valeur exacte de l''intégrale $I = \\int_0^3 f(x) dx$.","Interprète graphiquement le résultat obtenu à la question précédente."]}', '1. Points d''intersection avec l''axe des abscisses :
Il faut résoudre $f(x) = 0$, c''est-à-dire $x^2 - 4x + 3 = 0$.
C''est une équation du second degré. On calcule le discriminant $\Delta = b^2 - 4ac = (-4)^2 - 4(1)(3) = 16 - 12 = 4$.
Les solutions sont $x_1 = \frac{-b - \sqrt{\Delta}}{2a} = \frac{4 - \sqrt{4}}{2} = \frac{4 - 2}{2} = \frac{2}{2} = 1$.
Et $x_2 = \frac{-b + \sqrt{\Delta}}{2a} = \frac{4 + \sqrt{4}}{2} = \frac{4 + 2}{2} = \frac{6}{2} = 3$.
Les points d''intersection sont $(1, 0)$ et $(3, 0)$.

2. Calcul de l''intégrale $I = \int_0^3 f(x) dx$ :
Une primitive de $f(x) = x^2 - 4x + 3$ est $F(x) = \frac{x^3}{3} - 4\frac{x^2}{2} + 3x = \frac{x^3}{3} - 2x^2 + 3x$.
$I = F(3) - F(0)$
$F(3) = \frac{3^3}{3} - 2(3^2) + 3(3) = \frac{27}{3} - 2(9) + 9 = 9 - 18 + 9 = 0$.
$F(0) = \frac{0^3}{3} - 2(0^2) + 3(0) = 0$.
Donc $I = 0 - 0 = 0$.

3. Interprétation graphique :
Le résultat $I = 0$ signifie que l''aire algébrique entre la courbe $\mathcal{C}_f$ et l''axe des abscisses sur l''intervalle $[0, 3]$ est nulle. 
Cela est dû au fait que sur cet intervalle, la fonction $f(x)$ prend des valeurs positives et négatives, et les aires correspondantes se compensent. 
Plus précisément, $f(x) \ge 0$ sur $[0, 1]$ et $f(x) \le 0$ sur $[1, 3]$. L''aire au-dessus de l''axe des abscisses sur $[0, 1]$ est égale à l''aire en dessous de l''axe des abscisses sur $[1, 3]$.', '["Pour les points d''intersection avec l''axe des abscisses, il faut résoudre $f(x) = 0$.","Pour calculer l''intégrale, trouve une primitive de $f(x)$.","L''intégrale d''une fonction représente l''aire entre la courbe et l''axe des abscisses."]'::jsonb, '2025-12-14T13:23:00.112242+00:00'::timestamptz, '1ca5011a9783ff7fdef42ec6c0a4cea2277f60e812bfbcda44ac41d61ba64a9d', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('a51e8119-a20c-4f92-916c-006768b2f94f', 'Calcul intégral', 'terminale', '{"questions":["Justifie pourquoi la fonction $f(x) = x e^{2x}$ est continue sur l''intervalle $[1; 2]$.","Pour calculer cette intégrale en utilisant l''intégration par parties (IPP), propose un choix pour les fonctions $u(x)$ et $v''(x)$. Justifie ton choix en expliquant pourquoi il est pertinent.","Calcule la dérivée $u''(x)$ et une primitive $v(x)$ à partir de tes choix précédents. Détaille tes calculs.","Applique la formule d''intégration par parties pour exprimer l''intégrale $I$ sous une forme simplifiée.","Calcule la valeur exacte de cette intégrale."],"contexte":"On considère l''intégrale $I = \\int_1^2 x e^{2x} dx$."}', '1. La fonction $f(x) = x e^{2x}$ est le produit de deux fonctions continues sur $[1; 2]$ : la fonction $x \maps\to x$ (fonction polynomiale) et la fonction $x \maps\to e^{2x}$ (composée d''une fonction polynomiale et de la fonction exponentielle, toutes deux continues). Le produit de fonctions continues est continu, donc $f$ est continue sur $[1; 2]$.

2. Pour l''intégration par parties, on choisit généralement $u(x)$ comme la fonction qui se simplifie par dérivation et $v''(x)$ comme la fonction dont on sait facilement trouver une primitive. Ici, on peut poser :
$u(x) = x$ (car sa dérivée est simple : $u''(x) = 1$)
$v''(x) = e^{2x}$ (car sa primitive est facile à trouver : $v(x) = \frac{1}{2}e^{2x}$)

3. Calcul des dérivées et primitives :
$u''(x) = 1$
$v(x) = \frac{1}{2}e^{2x}$ (Vérification : $(\frac{1}{2}e^{2x})'' = \frac{1}{2} \times 2e^{2x} = e^{2x}$)

4. Application de la formule d''IPP :
$I = [u(x)v(x)]_1^2 - \int_1^2 u''(x)v(x) dx$
$I = [x \cdot \frac{1}{2}e^{2x}]_1^2 - \int_1^2 1 \cdot \frac{1}{2}e^{2x} dx$
$I = [\frac{1}{2}xe^{2x}]_1^2 - \frac{1}{2} \int_1^2 e^{2x} dx$

5. Calcul de la valeur exacte de l''intégrale :
$[\frac{1}{2}xe^{2x}]_1^2 = (\frac{1}{2} \cdot 2 e^{2 \cdot 2}) - (\frac{1}{2} \cdot 1 e^{2 \cdot 1}) = e^4 - \frac{1}{2}e^2$

Pour la deuxième partie de l''intégrale :
$\frac{1}{2} \int_1^2 e^{2x} dx = \frac{1}{2} [\frac{1}{2}e^{2x}]_1^2 = \frac{1}{4} [e^{2x}]_1^2 = \frac{1}{4} (e^{2 \cdot 2} - e^{2 \cdot 1}) = \frac{1}{4} (e^4 - e^2)$

Donc, $I = (e^4 - \frac{1}{2}e^2) - \frac{1}{4} (e^4 - e^2)$
$I = e^4 - \frac{1}{2}e^2 - \frac{1}{4}e^4 + \frac{1}{4}e^2$
$I = (1 - \frac{1}{4})e^4 + (-\frac{1}{2} + \frac{1}{4})e^2$
$I = \frac{3}{4}e^4 - \frac{1}{4}e^2$
$I = \frac{e^2(3e^2 - 1)}{4}$', '["Pour la continuité, pense aux fonctions usuelles (polynômes, exponentielles).","Pour l''IPP, essaie de choisir $u(x)$ de manière à ce que $u''(x)$ simplifie l''expression, et $v''(x)$ de manière à ce que $v(x)$ soit facile à trouver.","La formule d''IPP est $\\int_a^b u(x)v''(x) dx = [u(x)v(x)]_a^b - \\int_a^b u''(x)v(x) dx$.","N''oublie pas de bien évaluer la partie $[u(x)v(x)]_a^b$ aux bornes de l''intégrale."]'::jsonb, '2025-12-14T13:56:01.452569+00:00'::timestamptz, 'c526e110363aaec582aeefad24dfe3549e791c19a34ceb9dd5fdb461743386f1', NULL),
('e4ed526b-12d3-4d41-a587-858832a7e8f9', 'Probabilités conditionnelles', 'Première', '{"contexte":"Dans une usine, on produit des pièces mécaniques. On sait que 2% des pièces produites sont défectueuses. Le contrôle qualité est effectué par une machine.\n\nLes informations importantes sont :\n- Si une pièce est défectueuse, la machine la détecte avec une probabilité de 90%.\n- Si une pièce n''est pas défectueuse, la machine la déclare non défectueuse avec une probabilité de 95%.","questions":["Définis les événements $D$ (la pièce est défectueuse) et $T$ (la machine détecte la pièce comme défectueuse).","Donne les probabilités connues directement à partir de l''énoncé en utilisant la notation $P(A)$, $P(A \\cap B)$ ou $P_A(B)$.","Construis un arbre pondéré représentant la situation. N''oublie pas de bien placer les probabilités sur chaque branche.","Calcule la probabilité qu''une pièce soit défectueuse ET que la machine la détecte comme défectueuse. Explique ton calcul.","Calcule la probabilité qu''une pièce ne soit pas défectueuse ET que la machine la déclare défectueuse. Explique ton calcul.","Démontre que la probabilité qu''une pièce soit détectée comme défectueuse par la machine est de $P(T) = 0,069$. Justifie ta réponse en utilisant la formule des probabilités totales.","Sachant qu''une pièce est détectée comme défectueuse par la machine, quelle est la probabilité qu''elle soit réellement défectueuse ? Donne la valeur arrondie à $10^{-3}$."]}', 'Soient les événements :
- $D$ : la pièce est défectueuse.
- $\bar{D}$ : la pièce n''est pas défectueuse.
- $T$ : la machine détecte la pièce comme défectueuse.
- $\bar{T}$ : la machine détecte la pièce comme non défectueuse.

Probabilités données par l''énoncé :
- $P(D) = 0,02$
- $P(\bar{D}) = 1 - P(D) = 1 - 0,02 = 0,98$
- $P_D(T) = 0,90$ (si une pièce est défectueuse, la machine la détecte avec 90%)
- $P_{\bar{D}}(\bar{T}) = 0,95$ (si une pièce n''est pas défectueuse, la machine la déclare non défectueuse avec 95%)

Arbre pondéré :
(D, 0.02) --(T, 0.90)--> (D et T, 0.02*0.90=0.018)
             \(Tbar, 0.10)--> (D et Tbar, 0.02*0.10=0.002)
(Dbar, 0.98) --(T, 0.05)--> (Dbar et T, 0.98*0.05=0.049)
             \(Tbar, 0.95)--> (Dbar et Tbar, 0.98*0.95=0.931)

Calculs :

1. Probabilité qu''une pièce soit défectueuse ET que la machine la détecte comme défectueuse :
$P(D \cap T) = P(D) \times P_D(T) = 0,02 \times 0,90 = 0,018$

2. Probabilité qu''une pièce ne soit pas défectueuse ET que la machine la déclare défectueuse :
$P_{\bar{D}}(T) = 1 - P_{\bar{D}}(\bar{T}) = 1 - 0,95 = 0,05$
$P(\bar{D} \cap T) = P(\bar{D}) \times P_{\bar{D}}(T) = 0,98 \times 0,05 = 0,049$

3. Probabilité qu''une pièce soit détectée comme défectueuse par la machine (formule des probabilités totales) :
$P(T) = P(D \cap T) + P(\bar{D} \cap T) = 0,018 + 0,049 = 0,067$

4. Probabilité qu''une pièce soit réellement défectueuse SACHANT qu''elle est détectée comme défectueuse :
$P_T(D) = \frac{P(D \cap T)}{P(T)} = \frac{0,018}{0,067} \approx 0,26865...$
Arrondi à $10^{-3}$ : $P_T(D) \approx 0,269$', '["Pour l''arbre, commence par les événements D et $\\bar{D}$.","Utilise la formule $P(A \\cap B) = P(A) \\times P_A(B)$.","La formule des probabilités totales est $P(T) = P(T \\cap D) + P(T \\cap \\bar{D})$.","Pour la dernière question, il faut utiliser la formule de Bayes : $P_T(D) = \\frac{P(T \\cap D)}{P(T)}$."]'::jsonb, '2025-12-14T15:33:15.993216+00:00'::timestamptz, 'b6dbf2d1a2467ab896fda027247351af81d740e7b7a5e0beb8cca8030438c67b', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('1f07dca2-99ca-49f8-a773-b92f49a34a93', 'Ensembles de nombres', 'Première', '{"contexte":"Soit $A$ l''ensemble des nombres entiers naturels pairs inférieurs à 15. Soit $B$ l''ensemble des nombres entiers relatifs multiples de 3 compris entre -10 et 10 (inclus). Soit $C$ l''ensemble des nombres réels $x$ tels que $x^2 < 9$.","questions":["Décris l''ensemble $A$ en extension (en listant tous ses éléments). Explique pourquoi chaque élément appartient à $A$.","Décris l''ensemble $B$ en extension. Justifie la présence ou l''absence de chaque élément.","Décris l''ensemble $C$ en utilisant la notation d''intervalle. Explique comment tu as trouvé cet intervalle.","Donne la nature de chacun des nombres suivants : $-5$, $\\frac{1}{2}$, $\\sqrt{4}$, $\\pi$. Justifie ta réponse pour chaque nombre en précisant à quels ensembles de nombres il appartient ($\\mathbb{N}$, $\\mathbb{Z}$, $\\mathbb{D}$, $\\mathbb{Q}$, $\\mathbb{R}$).","Explique la différence entre un nombre rationnel et un nombre irrationnel. Donne un exemple pour chacun."]}', '**1. Ensemble A :**
L''ensemble des nombres entiers naturels pairs inférieurs à 15 est $A = \{0, 2, 4, 6, 8, 10, 12, 14\}$.
- $0$ est un entier naturel pair.
- $2, 4, ..., 14$ sont des entiers naturels pairs et sont tous inférieurs à 15.

**2. Ensemble B :**
L''ensemble des nombres entiers relatifs multiples de 3 compris entre -10 et 10 est $B = \{-9, -6, -3, 0, 3, 6, 9\}$.
- Les multiples de 3 sont $..., -9, -6, -3, 0, 3, 6, 9, ...$
- On ne garde que ceux qui sont entre -10 et 10 inclus.

**3. Ensemble C :**
L''ensemble des nombres réels $x$ tels que $x^2 < 9$ signifie que $\sqrt{x^2} < \sqrt{9}$, soit $|x| < 3$. Donc $C = ]-3, 3[$.
- Si $x=2$, $2^2=4 < 9$. $2 \in C$.
- Si $x=-2$, $(-2)^2=4 < 9$. $-2 \in C$.
- Si $x=3$, $3^2=9$, donc $3 \notin C$.

**4. Nature des nombres :**
- **$-5$ :** C''est un entier relatif ($\mathbb{Z}$), donc aussi un nombre rationnel ($\mathbb{Q}$) et un nombre réel ($\mathbb{R}$). Il n''est pas naturel ($\mathbb{N}$) car négatif.
- **$\frac{1}{2}$ :** C''est un nombre décimal ($\mathbb{D}$) car $0,5$. C''est donc aussi un nombre rationnel ($\mathbb{Q}$) et un nombre réel ($\mathbb{R}$). Il n''est ni naturel, ni relatif.
- **$\sqrt{4}$ :** $\sqrt{4} = 2$. C''est un entier naturel ($\mathbb{N}$), donc aussi un entier relatif ($\mathbb{Z}$), un nombre décimal ($\mathbb{D}$), un nombre rationnel ($\mathbb{Q}$) et un nombre réel ($\mathbb{R}$). 
- **$\pi$ :** C''est un nombre irrationnel, donc un nombre réel ($\mathbb{R}$). Il n''appartient à aucun autre ensemble cité ($\mathbb{N}$, $\mathbb{Z}$, $\mathbb{D}$, $\mathbb{Q}$) car sa partie décimale est infinie et non périodique.

**5. Différence entre rationnel et irrationnel :**
- Un **nombre rationnel** est un nombre qui peut s''écrire sous la forme d''une fraction $\frac{p}{q}$, où $p$ est un entier relatif et $q$ est un entier relatif non nul. Leur écriture décimale est finie ou illimitée mais périodique.
  *Exemple :* $0,75 = \frac{3}{4}$, $0,333... = \frac{1}{3}$.
- Un **nombre irrationnel** est un nombre réel qui ne peut pas s''écrire sous la forme d''une fraction. Leur écriture décimale est illimitée et non périodique.
  *Exemple :* $\sqrt{2}$, $\pi$.', '["Pour l''ensemble $A$, pense aux nombres entiers positifs qui sont divisibles par 2.","Pour l''ensemble $B$, liste les multiples de 3 et vérifie s''ils sont entre -10 et 10.","Pour l''ensemble $C$, résous l''inéquation $x^2 < 9$.","Pour la nature des nombres, pense à la définition de chaque ensemble : naturels, relatifs, décimaux, rationnels, réels.","Un nombre rationnel peut s''écrire sous forme de fraction $p/q$ avec $q \\neq 0$."]'::jsonb, '2025-12-14T15:34:50.157843+00:00'::timestamptz, 'bd84d61d7bedeb9b527cd942acf5099ce50aaa0f2bf4c31cfe7fa04c2530821e', NULL),
('5e684189-0428-4d7d-8bf1-68238fe5c364', 'Arithmétique', 'Première', '{"questions":["Décompose les nombres $a$ et $b$ en produits de facteurs premiers. Explique comment tu procèdes pour trouver ces facteurs.","Détermine le plus grand commun diviseur (PGCD) de $a$ et $b$. Justifie ta méthode.","Détermine le plus petit commun multiple (PPCM) de $a$ et $b$. Explique comment tu l''as calculé.","Les nombres $a$ et $b$ sont-ils premiers entre eux ? Justifie ta réponse en te basant sur le PGCD."],"contexte":"On considère deux nombres entiers $a = 72$ et $b = 108$."}', '**1. Décomposition en facteurs premiers :**
- Pour $a = 72$ :
  $72 \div 2 = 36$
  $36 \div 2 = 18$
  $18 \div 2 = 9$
  $9 \div 3 = 3$
  $3 \div 3 = 1$
  Donc $a = 72 = 2^3 \times 3^2$.

- Pour $b = 108$ :
  $108 \div 2 = 54$
  $54 \div 2 = 27$
  $27 \div 3 = 9$
  $9 \div 3 = 3$
  $3 \div 3 = 1$
  Donc $b = 108 = 2^2 \times 3^3$.

**2. Plus grand commun diviseur (PGCD) :**
Pour trouver le PGCD, on prend les facteurs premiers communs aux deux décompositions, affectés de la plus petite de leurs puissances.
Les facteurs communs sont 2 et 3.
- Pour 2 : la plus petite puissance est $2^2$ (dans la décomposition de 108).
- Pour 3 : la plus petite puissance est $3^2$ (dans la décomposition de 72).
Donc $PGCD(72, 108) = 2^2 \times 3^2 = 4 \times 9 = 36$.

**3. Plus petit commun multiple (PPCM) :**
Pour trouver le PPCM, on prend tous les facteurs premiers (communs ou non), affectés de la plus grande de leurs puissances.
Les facteurs sont 2 et 3.
- Pour 2 : la plus grande puissance est $2^3$ (dans la décomposition de 72).
- Pour 3 : la plus grande puissance est $3^3$ (dans la décomposition de 108).
Donc $PPCM(72, 108) = 2^3 \times 3^3 = 8 \times 27 = 216$.

**4. Nombres premiers entre eux ?**
Non, les nombres $a$ et $b$ ne sont pas premiers entre eux.
Deux nombres sont premiers entre eux si leur PGCD est égal à 1. Or, nous avons trouvé que $PGCD(72, 108) = 36$, qui est différent de 1.', '["Pour la décomposition en facteurs premiers, commence par diviser par les plus petits nombres premiers (2, 3, 5, ...).","Le PGCD s''obtient en multipliant les facteurs premiers communs, pris avec leur plus petite puissance.","Le PPCM s''obtient en multipliant tous les facteurs premiers (communs ou non), pris avec leur plus grande puissance.","Deux nombres sont premiers entre eux si leur PGCD est égal à 1."]'::jsonb, '2025-12-14T15:38:15.180593+00:00'::timestamptz, '2b4ebc96aa5fbf3dc865fabe1785a636b15114a26be413f0ae887ec723c34da3', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('14bc69e5-9fb8-4fb7-8475-fa1e7d861f9e', 'Arithmétique et suites', 'Première', '{"contexte":"Le nombre d''or, noté $\\varphi$ (phi), est une constante mathématique célèbre. Il vérifie l''équation $x^2 - x - 1 = 0$. Il est également lié à la suite de Fibonacci, définie par $F_0 = 0$, $F_1 = 1$ et $F_{n+2} = F_{n+1} + F_n$ pour tout $n \\in \\mathbb{N}$.","questions":["Démontre que $\\varphi = \\frac{1 + \\sqrt{5}}{2}$. Explique comment tu arrives à ce résultat en détaillant les étapes de résolution.","Vérifie que $\\varphi^2 = \\varphi + 1$. Explique clairement ta démarche.","On considère la suite $(U_n)$ définie par $U_n = \\varphi^n$. Montre que cette suite vérifie la relation de récurrence $U_{n+2} = U_{n+1} + U_n$. Explique ton raisonnement.","Sachant que les termes de la suite de Fibonacci sont des entiers, explique pourquoi la relation $F_{n+2} = F_{n+1} + F_n$ est une relation de récurrence arithmétique. Justifie ta réponse en t''appuyant sur la définition d''une suite arithmétique.","Donne les cinq premiers termes de la suite de Fibonacci : $F_0, F_1, F_2, F_3, F_4$. Explique comment tu les as calculés."]}', '**1. Démonstration de $\varphi = \frac{1 + \sqrt{5}}{2}$ :**
L''équation est $x^2 - x - 1 = 0$. C''est une équation du second degré de la forme $ax^2 + bx + c = 0$ avec $a=1$, $b=-1$ et $c=-1$.
Le discriminant est $\Delta = b^2 - 4ac = (-1)^2 - 4(1)(-1) = 1 + 4 = 5$.
Puisque $\Delta > 0$, il y a deux solutions réelles :
$x_1 = \frac{-b - \sqrt{\Delta}}{2a} = \frac{-(-1) - \sqrt{5}}{2(1)} = \frac{1 - \sqrt{5}}{2}$
$x_2 = \frac{-b + \sqrt{\Delta}}{2a} = \frac{-(-1) + \sqrt{5}}{2(1)} = \frac{1 + \sqrt{5}}{2}$
Par convention, le nombre d''or $\varphi$ est la solution positive, donc $\varphi = \frac{1 + \sqrt{5}}{2}$.

**2. Vérification de $\varphi^2 = \varphi + 1$ :**
On sait que $\varphi$ est solution de $x^2 - x - 1 = 0$, donc en remplaçant $x$ par $\varphi$, on a $\varphi^2 - \varphi - 1 = 0$. En ajoutant $\varphi + 1$ des deux côtés de l''égalité, on obtient $\varphi^2 = \varphi + 1$.

**3. La suite $(U_n)$ vérifie $U_{n+2} = U_{n+1} + U_n$ :**
On a $U_n = \varphi^n$.
On veut montrer $U_{n+2} = U_{n+1} + U_n$, c''est-à-dire $\varphi^{n+2} = \varphi^{n+1} + \varphi^n$.
Divisons tous les termes par $\varphi^n$ (qui est non nul car $\varphi \neq 0$) : $\frac{\varphi^{n+2}}{\varphi^n} = \frac{\varphi^{n+1}}{\varphi^n} + \frac{\varphi^n}{\varphi^n}$.
Ceci simplifie en $\varphi^2 = \varphi + 1$. Nous avons vérifié cette propriété à la question précédente. Donc, la suite $(U_n)$ vérifie bien la relation de récurrence.

**4. Pourquoi la relation $F_{n+2} = F_{n+1} + F_n$ n''est pas une relation de récurrence arithmétique :**
Une suite arithmétique est une suite où la différence entre deux termes consécutifs est constante. C''est-à-dire $F_{n+1} - F_n = r$ (une constante $r$).
La relation $F_{n+2} = F_{n+1} + F_n$ peut s''écrire $F_{n+2} - F_{n+1} = F_n$. La différence entre deux termes consécutifs, $F_{n+2} - F_{n+1}$, n''est pas une constante $r$ mais dépend de $n$ (elle est égale à $F_n$). Donc, la suite de Fibonacci n''est pas une suite arithmétique.

**5. Les cinq premiers termes de la suite de Fibonacci :**
- $F_0 = 0$ (donné)
- $F_1 = 1$ (donné)
- $F_2 = F_1 + F_0 = 1 + 0 = 1$
- $F_3 = F_2 + F_1 = 1 + 1 = 2$
- $F_4 = F_3 + F_2 = 2 + 1 = 3$', '["Pour la première question, utilise la formule de résolution des équations du second degré $ax^2 + bx + c = 0$.","Pour la deuxième question, remplace $\\varphi$ par son expression dans $\\varphi^2$ et simplifie.","Pour la troisième question, utilise la propriété $\\varphi^2 = \\varphi + 1$ et la définition de $U_n$.","Rappelle-toi la définition d''une suite arithmétique : chaque terme s''obtient en ajoutant une constante au précédent. Est-ce le cas ici ?","Pour la dernière question, utilise la relation de récurrence $F_{n+2} = F_{n+1} + F_n$ en partant de $F_0$ et $F_1$."]'::jsonb, '2025-12-14T15:50:52.88661+00:00'::timestamptz, 'f3818be03536538c26722fc7233292206aff24e1100d5c9eb5cc541f88a17fd8', NULL),
('56bda214-500e-4959-84ea-192a67e602e2', 'Exercice', 'terminale', '{"contexte":"exercice sur le nombre d''or et la suite de Fibonacci !\nTes réponses aux questions 1, 2 et 5 sont parfaites :","questions":["Tu as correctement résolu l''équation du second degré $x^2 - x - 1 = 0$ en utilisant le discriminant $\\Delta$ et tu as bien identifié $\\varphi = \\frac{1+\\\\sqrt{5}}{2}$ comme étant la solution positive.","Tu as parfaitement vérifié que $\\varphi^2 = \\varphi + 1$ en te basant sur le fait que $\\varphi$ est solution de l''équation. C''est une excellente déduction !","Tu as calculé les cinq premiers termes de la suite de Fibonacci ($F_0 = 0$, $F_1 = 1$, $F_2 = 1$, $F_3 = 2$, $F_4 = 3$) sans aucune erreur."]}', 'À résoudre', '[]'::jsonb, '2025-12-14T16:30:29.506358+00:00'::timestamptz, '34ca09a05243b49e47750a361c740278601a50afe134d4dab1ec536b6b8a10e6', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('010f1b11-e493-4e94-8864-f595b71b7e5a', 'Exercice', 'premiere', '{"contexte":"","questions":["**Mon rôle est de t''enseigner, pas juste de te donner des réponses","**Je suis ta prof personnelle","**L''apprentissage est un chemin"]}', 'À résoudre', '[]'::jsonb, '2025-12-15T14:27:35.651729+00:00'::timestamptz, '0adc457f7811cef7b13ffd6b7434bcf6799c20378186e1160f1fba936b676eef', NULL),
('0f244efe-3b7d-42d2-adef-388ff29de117', 'Dérivation', 'Première', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^3 - 3x^2 + 4$. On note $\\mathcal{C}_f$ sa courbe représentative dans un repère orthogonal.","questions":["1. Calcule la dérivée $f''(x)$ de la fonction $f$.","2. Étudie le signe de $f''(x)$ et déduis-en les variations de la fonction $f$.","3. Calcule les extremums locaux de $f$ (valeurs et positions).","4. Détermine l''équation de la tangente à la courbe $\\mathcal{C}_f$ au point d''abscisse $x=1$.","5. Détermine l''équation de la tangente à la courbe $\\mathcal{C}_f$ au point d''abscisse $x=0$."]}', '**1. Calcul de la dérivée $f''(x)$ :**
$f(x) = x^3 - 3x^2 + 4$
$f''(x) = 3x^2 - 3(2x) + 0 = 3x^2 - 6x$

**2. Étude du signe de $f''(x)$ et variations de $f$ :**
On cherche les racines de $f''(x) = 3x^2 - 6x = 0$.
$3x(x - 2) = 0$
Les racines sont $x=0$ et $x=2$.
$f''(x)$ est un polynôme du second degré avec $a=3 > 0$. Il est donc positif à l''extérieur des racines et négatif entre les racines.
- Pour $x \in ]-\infty, 0[$, $f''(x) > 0$, donc $f$ est strictement croissante.
- Pour $x \in ]0, 2[$, $f''(x) < 0$, donc $f$ est strictement décroissante.
- Pour $x \in ]2, +\infty[$, $f''(x) > 0$, donc $f$ est strictement croissante.

**3. Calcul des extremums locaux de $f$ :**
- En $x=0$ : $f''(0)=0$. La fonction passe de croissante à décroissante, il s''agit d''un maximum local.
$f(0) = 0^3 - 3(0)^2 + 4 = 4$. Le maximum local est $(0, 4)$.
- En $x=2$ : $f''(2)=0$. La fonction passe de décroissante à croissante, il s''agit d''un minimum local.
$f(2) = 2^3 - 3(2)^2 + 4 = 8 - 3(4) + 4 = 8 - 12 + 4 = 0$. Le minimum local est $(2, 0)$.

**4. Équation de la tangente à $\mathcal{C}_f$ au point d''abscisse $x=1$ :**
La formule est $y = f''(a)(x-a) + f(a)$. Ici $a=1$.
$f(1) = 1^3 - 3(1)^2 + 4 = 1 - 3 + 4 = 2$.
$f''(1) = 3(1)^2 - 6(1) = 3 - 6 = -3$.
L''équation de la tangente est $y = -3(x-1) + 2 = -3x + 3 + 2 = -3x + 5$.

**5. Équation de la tangente à $\mathcal{C}_f$ au point d''abscisse $x=0$ :**
Ici $a=0$.
$f(0) = 4$ (calculé précédemment).
$f''(0) = 0$ (calculé précédemment).
L''équation de la tangente est $y = 0(x-0) + 4 = 4$. C''est une tangente horizontale.', '["Pour la question 1, rappelle-toi les règles de dérivation des fonctions puissance : $(x^n)'' = nx^{n-1}$.","Pour la question 2, une fois que tu as $f''(x)$, c''est un polynôme du second degré. Cherche ses racines pour étudier son signe. Le signe de $f''(x)$ te donne les variations de $f$.","Pour la question 3, les extremums locaux se trouvent aux points où la dérivée s''annule et change de signe. Calcule les valeurs de $f(x)$ à ces points.","Pour la question 4 et 5, l''équation de la tangente à une courbe au point d''abscisse $a$ est donnée par la formule : $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-12-15T20:50:03.637561+00:00'::timestamptz, 'f66340d63204bbd1200e1b47960b4a0690ec287486ed35ac564536e38f25b54b', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('5bdd6802-efa8-4121-af82-52370f1b1648', 'Exercice', 'Première', '{"contexte":"","questions":["Tu as parfaitement calculé la dérivée $f''(x) = 3x^2 - 6x$ et tu as eu l''excellente idée de la factoriser en $3x(x-2)$, ce qui simplifie l''étude de son signe","Ton tableau de variations est juste, avec les bonnes racines, les bons signes pour $f''(x)$ et les variations de $f$ qui en découlent","Tu as correctement identifié le maximum local en $f(0)=4$ et le minimum local en $f(2)=0$","Pour les tangentes, tes calculs sont exacts"]}', 'À résoudre', '[]'::jsonb, '2025-12-15T20:59:27.659724+00:00'::timestamptz, '27ecddee0ca529ba2cc7aa3a17aef22fa797676277f71a944e8f4c61d945a0df', NULL),
('fbfdd83b-b0e4-4f20-a78d-841a5abb4d97', 'Suites numériques', 'terminale', '{"questions":["Calcule $U_1$ et $U_2$.","On admet que la suite $(U_n)$ est majorée par 3. Démontre par récurrence que pour tout entier naturel $n$, $U_n < U_{n+1}$.","Déduis-en la nature de la suite $(U_n)$.","On considère la fonction $f$ définie sur $[-1, +\\infty[$ par $f(x) = \\sqrt{2x+3}$. Détermine les points fixes de $f$.","On pose pour tout entier naturel $n$, $V_n = U_n - 3$. Démontre que la suite $(V_n)$ est géométrique."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 1$ et, pour tout entier naturel $n$, $U_{n+1} = \\sqrt{2U_n + 3}$."}', '1. Calcul de $U_1$ et $U_2$ :
$U_1 = \sqrt{2U_0 + 3} = \sqrt{2(1) + 3} = \sqrt{5}$.
$U_2 = \sqrt{2U_1 + 3} = \sqrt{2\sqrt{5} + 3}$.

2. Démontrons par récurrence que pour tout entier naturel $n$, $U_n < U_{n+1}$ (la suite est croissante).
Initialisation : Pour $n=0$, $U_0 = 1$ et $U_1 = \sqrt{5} \approx 2.23$. On a bien $U_0 < U_1$.
Hérédité : Supposons que pour un certain entier $k \ge 0$, $U_k < U_{k+1}$.
On veut montrer que $U_{k+1} < U_{k+2}$.
On a $U_k < U_{k+1}$.
En multipliant par 2 : $2U_k < 2U_{k+1}$.
En ajoutant 3 : $2U_k + 3 < 2U_{k+1} + 3$.
Comme la fonction racine carrée est croissante sur $[0, +\infty[$ :
$\sqrt{2U_k + 3} < \sqrt{2U_{k+1} + 3}$.
Donc $U_{k+1} < U_{k+2}$.
La propriété est héréditaire.
Conclusion : Par le principe de récurrence, pour tout entier naturel $n$, $U_n < U_{n+1}$. La suite $(U_n)$ est croissante.

3. La suite $(U_n)$ est croissante et majorée par 3 (admis). D''après le théorème de convergence monotone, la suite $(U_n)$ est convergente.

4. Déterminons les points fixes de $f(x) = \sqrt{2x+3}$.
On résout $f(x) = x$, soit $\sqrt{2x+3} = x$.
Pour que l''équation ait un sens, il faut $2x+3 \ge 0 \implies x \ge -3/2$ et $x \ge 0$.
Donc $x \ge 0$.
En élevant au carré : $2x+3 = x^2$.
$x^2 - 2x - 3 = 0$.
Calculons le discriminant $\Delta = (-2)^2 - 4(1)(-3) = 4 + 12 = 16$.
Les solutions sont $x = \frac{-(-2) \pm \sqrt{16}}{2(1)} = \frac{2 \pm 4}{2}$.
$x_1 = \frac{2-4}{2} = -1$ (à rejeter car $x \ge 0$).
$x_2 = \frac{2+4}{2} = 3$.
Le seul point fixe est $x=3$.

5. Démontrons que la suite $(V_n)$ est géométrique.
On a $V_n = U_n - 3$, donc $U_n = V_n + 3$.
$V_{n+1} = U_{n+1} - 3 = \sqrt{2U_n + 3} - 3$.
Remplaçons $U_n$ par $V_n + 3$ :
$V_{n+1} = \sqrt{2(V_n + 3) + 3} - 3 = \sqrt{2V_n + 6 + 3} - 3 = \sqrt{2V_n + 9} - 3$.
Pour faire apparaître $V_n$, on peut utiliser la quantité conjuguée :
$V_{n+1} = (\sqrt{2V_n + 9} - 3) \times \frac{\sqrt{2V_n + 9} + 3}{\sqrt{2V_n + 9} + 3} = \frac{(2V_n + 9) - 3^2}{\sqrt{2V_n + 9} + 3} = \frac{2V_n + 9 - 9}{\sqrt{2V_n + 9} + 3} = \frac{2V_n}{\sqrt{2V_n + 9} + 3}$.
Ceci ne donne pas directement une suite géométrique. Reprenons autrement.

On sait que la limite de $U_n$ est le point fixe 3. Si $U_n$ converge vers 3, alors $V_n$ converge vers 0.
On a $U_{n+1} - 3 = \sqrt{2U_n + 3} - 3$.
On sait que $U_n - 3 = V_n$.
$U_{n+1} - 3 = \frac{(2U_n + 3) - 9}{\sqrt{2U_n + 3} + 3} = \frac{2U_n - 6}{\sqrt{2U_n + 3} + 3} = \frac{2(U_n - 3)}{\sqrt{2U_n + 3} + 3} = \frac{2V_n}{\sqrt{2U_n + 3} + 3}$.
Donc $V_{n+1} = \frac{2V_n}{\sqrt{2U_n + 3} + 3}$.
Pour que $V_n$ soit géométrique, il faut que $V_{n+1} = q V_n$, où $q$ est une constante.
Ici, le dénominateur $\sqrt{2U_n + 3} + 3$ dépend de $n$, donc $V_n$ n''est pas une suite géométrique.', '["Pour la question sur la récurrence, tu peux étudier le signe de $U_{n+1} - U_n$ ou comparer $U_{n+1}$ et $U_n$ en utilisant la fonction $f$.","Pour les points fixes, tu dois résoudre l''équation $f(x) = x$.","Pour la suite géométrique, exprime $V_{n+1}$ en fonction de $V_n$."]'::jsonb, '2025-12-15T21:00:46.312049+00:00'::timestamptz, 'dcd365efdbb280cae0608f16c9c5e7ac386f034cd0f30511ad11cc4a492d6617', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('b1f48eb1-e7ce-4236-9a7f-2d196b77b95f', 'Exercice', 'terminale', '{"contexte":"exercice sur l''étude de fonction. C''est un excellent entraînement pour la dérivation et l''analyse de fonction.\n**Énoncé de l''exercice**\nSoit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^3 - 3x^2 + 4$. On note $C_f$ sa courbe représentative dans un repère orthogonal.\n**Correction détaillée :**","questions":["**Calcul de la dérivée $f''(x)$ de la fonction $f$**","**Étude du signe de $f''(x)$ et déduction des variations de la fonction $f$**","**Calcul des extremums locaux de $f$ (valeurs et positions)**","**Détermination de l''équation de la tangente à la courbe $C_f$ au point d''abscisse $x = 1$**","**Détermination de l''équation de la tangente à la courbe $C_f$ au point d''abscisse $x = 0$**"]}', 'À résoudre', '[]'::jsonb, '2025-12-15T21:06:12.078046+00:00'::timestamptz, '490704692b677909684fc9e8479708bd56e1009dddf88b1ff6ea16aef88e0613', NULL),
('dd445525-b858-461d-907a-8652095db580', 'Exercice', 'terminale', '{"contexte":"","questions":["**Dérivée et factorisation** : Tu as correctement calculé $f''(x) = 3x^2 - 6x$ et tu as eu le bon réflexe de la factoriser en $3x(x-2)$, ce qui simplifie grandement l''étude du signe","**Tableau de variations** : Ton tableau est impeccable, avec les bonnes racines, les bons signes pour $f''(x)$ et les variations cohérentes de $f(x)$","**Extremums locaux** : Tu as identifié correctement le maximum local en $x=0$ et le minimum local en $x=2$","**Tangentes** : L''application de la formule de l''équation de la tangente $y = f''(a)(x-a) + f(a)$ est parfaite pour les deux cas, $x=1$ et $x=0$"]}', 'À résoudre', '[]'::jsonb, '2025-12-15T21:07:56.841877+00:00'::timestamptz, '2f827b24b8fea16999deddf98e0bfce67de027f002356d41cca33250993d620f', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('e1ce7e40-715d-400b-9dc4-74d5bea08c6d', 'Calcul intégral', 'terminale', '{"questions":["Détermine une primitive $F$ de $f$ sur $\\mathbb{R}$.","Calcule la valeur exacte de l''intégrale $I = \\int_0^1 f(x) dx$. Interprète graphiquement le résultat.","On cherche à déterminer l''aire $\\mathcal{A}$ de la région du plan délimitée par la courbe $\\mathcal{C}_f$, l''axe des abscisses et les droites d''équations $x=0$ et $x=1$. Représente cette région sur un graphique et explique comment tu peux calculer cette aire."],"contexte":"On considère la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x+1)e^{-x}$. On note $\\mathcal{C}_f$ sa courbe représentative dans un repère orthogonal."}', '1. Déterminons une primitive $F$ de $f(x) = (2x+1)e^{-x}$ sur $\mathbb{R}$.
On utilise l''intégration par parties (IPP) : $\int u(x)v''(x)dx = u(x)v(x) - \int u''(x)v(x)dx$.
Posons $u(x) = 2x+1$ et $v''(x) = e^{-x}$.
Alors $u''(x) = 2$ et $v(x) = -e^{-x}$.

$\int (2x+1)e^{-x}dx = (2x+1)(-e^{-x}) - \int 2(-e^{-x})dx$
$= -(2x+1)e^{-x} + 2\int e^{-x}dx$
$= -(2x+1)e^{-x} - 2e^{-x} + C$
$= (-2x-1-2)e^{-x} + C$
$= (-2x-3)e^{-x} + C$

Donc, une primitive de $f$ est $F(x) = (-2x-3)e^{-x}$.

2. Calculons la valeur exacte de l''intégrale $I = \int_0^1 f(x) dx$.
$I = [F(x)]_0^1 = F(1) - F(0)$
$F(1) = (-2(1)-3)e^{-1} = -5e^{-1}$
$F(0) = (-2(0)-3)e^{0} = -3(1) = -3$

$I = -5e^{-1} - (-3) = 3 - 5e^{-1}$.

Interprétation graphique : Sur l''intervalle $[0,1]$, la fonction $f(x) = (2x+1)e^{-x}$ est positive (car $2x+1 > 0$ et $e^{-x} > 0$ pour $x \in [0,1]$). L''intégrale $I$ représente donc l''aire de la région du plan délimitée par la courbe $\mathcal{C}_f$, l''axe des abscisses et les droites d''équations $x=0$ et $x=1$.

3. Représentation et calcul de l''aire $\mathcal{A}$.

(Il faudrait ici un graphique montrant la courbe de $f$ sur $[0,1]$ et la région hachurée entre la courbe, l''axe des abscisses, $x=0$ et $x=1$).

La fonction $f(x)$ est positive sur l''intervalle $[0,1]$. Par conséquent, l''aire $\mathcal{A}$ de la région délimitée par la courbe $\mathcal{C}_f$, l''axe des abscisses et les droites d''équations $x=0$ et $x=1$ est donnée directement par l''intégrale de $f$ sur cet intervalle.

$\mathcal{A} = \int_0^1 f(x) dx = I = 3 - 5e^{-1}$ unités d''aire.', '["Pour trouver une primitive, pense à l''intégration par parties. Pose $u(x) = 2x+1$ et $v''(x) = e^{-x}$.","Pour l''interprétation graphique, rappelle-toi ce que représente une intégrale d''une fonction continue et positive.","Pour la représentation, trace la courbe de $f$ sur l''intervalle $[0,1]$ et hachure la région concernée. L''aire est donnée par l''intégrale de la fonction sur cet intervalle."]'::jsonb, '2025-12-16T22:32:36.791074+00:00'::timestamptz, 'a993add5029c6257eddfd50401093eeeb842d873df33d4918741d7040cffc98e', NULL),
('e69f0d35-1cfd-4003-a809-d2db5c868b36', 'Exercice', 'terminale', '{"contexte":"","questions":["**Choix de $u(x)$ et $v''(x)$** :","**Application de la formule d''IPP** :","**Calcul de la nouvelle intégrale** :","**Assemblage des résultats** :","**Calcul de $F(1)$** :","**Calcul de $F(0)$** :","**Calcul de $I$** :","**Représentation graphique** :","**Explication du calcul de l''aire $\\\\mathcal{A}$** :"]}', 'À résoudre', '[]'::jsonb, '2025-12-16T22:33:06.124356+00:00'::timestamptz, 'f4adbbde0af70cb9af476df0a06813b5f42a3f190e341729a8d8c8e0681e179f', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('4ebf4b77-234c-4827-ac45-66b24a8be519', 'Calcul intégral', 'terminale', '{"contexte":"On considère la fonction $f$ définie sur $[0; +\\infty[$ par $f(x) = x^2 e^{-x}$. On note $\\mathcal{C}_f$ sa courbe représentative dans un repère orthogonal.\n\nOn définit l''intégrale $I = \\int_0^1 x^2 e^{-x} dx$.","questions":["Justifie pourquoi la fonction $f$ est continue sur l''intervalle $[0; 1]$.","Pour calculer l''intégrale $I$ en utilisant l''intégration par parties (IPP), tu devras l''appliquer deux fois. Propose un premier choix judicieux pour les fonctions $u(x)$ et $v''(x)$ pour la première IPP, en justifiant ton choix.","Applique une première fois la formule d''intégration par parties. Tu obtiendras une nouvelle intégrale. Exprime $I$ en fonction de cette nouvelle intégrale.","Applique une seconde fois l''intégration par parties à la nouvelle intégrale obtenue à l''étape précédente. Détaille toutes les étapes de ce calcul.","Déduis-en la valeur exacte de l''intégrale $I$.","Interprète graphiquement la valeur de $I$ dans le contexte de la fonction $f$ et de son intervalle de définition."]}', '1. La fonction $x \maps\to x^2$ est une fonction polynomiale, donc elle est continue sur $\mathbb{R}$, et par conséquent sur $[0; 1]$.
La fonction $x \maps\to e^{-x}$ est une fonction exponentielle, donc elle est continue sur $\mathbb{R}$, et par conséquent sur $[0; 1]$.
Le produit de deux fonctions continues est une fonction continue. Donc $f(x) = x^2 e^{-x}$ est continue sur $[0; 1]$.

2. Pour la première IPP, on choisit :
$u(x) = x^2 \implies u''(x) = 2x$
$v''(x) = e^{-x} \implies v(x) = -e^{-x}$
Ce choix est judicieux car en dérivant $x^2$, on réduit son degré, ce qui simplifie l''expression, et $e^{-x}$ est facile à intégrer.

3. Application de la première IPP :
$I = [-x^2 e^{-x}]_0^1 - \int_0^1 (2x)(-e^{-x}) dx$
$I = (-(1)^2 e^{-1}) - (-(0)^2 e^{-0}) + \int_0^1 2x e^{-x} dx$
$I = -e^{-1} + 0 + 2 \int_0^1 x e^{-x} dx$
$I = -e^{-1} + 2 J$, où $J = \int_0^1 x e^{-x} dx$.

4. Application de la seconde IPP pour $J = \int_0^1 x e^{-x} dx$ :
On choisit :
$u(x) = x \implies u''(x) = 1$
$v''(x) = e^{-x} \implies v(x) = -e^{-x}$
$J = [-x e^{-x}]_0^1 - \int_0^1 (1)(-e^{-x}) dx$
$J = (-(1)e^{-1}) - (-(0)e^{-0}) + \int_0^1 e^{-x} dx$
$J = -e^{-1} + [-e^{-x}]_0^1$
$J = -e^{-1} + (-e^{-1} - (-e^0))$
$J = -e^{-1} - e^{-1} + 1$
$J = 1 - 2e^{-1}$

5. Déduction de la valeur exacte de $I$ :
On a $I = -e^{-1} + 2J$
$I = -e^{-1} + 2(1 - 2e^{-1})$
$I = -e^{-1} + 2 - 4e^{-1}$
$I = 2 - 5e^{-1}$
$I = 2 - \frac{5}{e}$

6. Interprétation graphique :
Puisque $f(x) = x^2 e^{-x}$ est une fonction positive sur $[0; 1]$, la valeur de l''intégrale $I = 2 - \frac{5}{e}$ représente l''aire, en unités d''aire, de la région du plan délimitée par la courbe $\mathcal{C}_f$, l''axe des abscisses et les droites verticales d''équations $x=0$ et $x=1$.', '["Pour le premier choix de $u(x)$ et $v''(x)$, pense à quelle partie de l''expression devient plus simple en la dérivant et quelle partie est facile à intégrer.","La formule d''intégration par parties est $\\int_a^b u(x)v''(x)dx = [u(x)v(x)]_a^b - \\int_a^b u''(x)v(x)dx$.","N''oublie pas de bien gérer les signes lors de l''application de la formule.","La continuité d''un produit de fonctions continues est un bon point de départ.","L''interprétation graphique d''une intégrale est souvent liée à une aire."]'::jsonb, '2025-12-16T22:51:03.135989+00:00'::timestamptz, 'a267e7e5946adb1ce909f91e71f390cfcc0232b9ff94d42f300880468b64b3ce', NULL),
('1318b05d-0249-4a27-95fb-05088286b562', 'Suites d''intégrales', 'terminale', '{"questions":["Calcule $I_0$.","Démontre que pour tout entier naturel $n$, $I_{n+1} = (n+1)I_n - 1$.","Déduis-en $I_1$ et $I_2$.","Montre que pour tout entier naturel $n$, $0 \\le I_n \\le \\frac{e}{n+1}$.","Déduis-en la limite de la suite $(I_n)$ lorsque $n$ tend vers $+\\infty$."],"contexte":"Pour tout entier naturel $n$, on définit la suite $(I_n)$ par l''intégrale suivante : $$I_n = \\int_0^1 x^n e^{1-x} dx$$"}', '1. Calcul de $I_0$ :
$$I_0 = \int_0^1 e^{1-x} dx = [-e^{1-x}]_0^1 = -e^0 - (-e^1) = -1 + e$$ 

2. Démonstration de la relation de récurrence $I_{n+1} = (n+1)I_n - 1$ :
On utilise l''intégration par parties pour $I_{n+1} = \int_0^1 x^{n+1} e^{1-x} dx$.
Posons $u(x) = x^{n+1}$ et $v''(x) = e^{1-x}$.
Alors $u''(x) = (n+1)x^n$ et $v(x) = -e^{1-x}$.
$$I_{n+1} = [-x^{n+1}e^{1-x}]_0^1 - \int_0^1 (n+1)x^n (-e^{1-x}) dx$$
$$I_{n+1} = (-1^{n+1}e^0 - 0) + (n+1)\int_0^1 x^n e^{1-x} dx$$
$$I_{n+1} = -1 + (n+1)I_n$$
Donc, pour tout entier naturel $n$, $I_{n+1} = (n+1)I_n - 1$.

3. Déduction de $I_1$ et $I_2$ :
Avec $n=0$, $I_1 = (0+1)I_0 - 1 = I_0 - 1 = (e-1) - 1 = e-2$.
Avec $n=1$, $I_2 = (1+1)I_1 - 1 = 2I_1 - 1 = 2(e-2) - 1 = 2e - 4 - 1 = 2e - 5$.

4. Démonstration de $0 \le I_n \le \frac{e}{n+1}$ :
Sur l''intervalle $[0, 1]$, on a $x^n \ge 0$ et $e^{1-x} > 0$, donc $x^n e^{1-x} \ge 0$. Par propriété de l''intégrale, $I_n \ge 0$.
Pour la majoration, sur $[0, 1]$, la fonction $f(x) = e^{1-x}$ est décroissante. Donc $e^{1-x} \le e^{1-0} = e$.
Alors $x^n e^{1-x} \le x^n e$.
$$I_n = \int_0^1 x^n e^{1-x} dx \le \int_0^1 x^n e dx = e \int_0^1 x^n dx$$
$$I_n \le e \left[\frac{x^{n+1}}{n+1}\right]_0^1 = e \left(\frac{1^{n+1}}{n+1} - 0\right) = \frac{e}{n+1}$$
Donc, pour tout entier naturel $n$, $0 \le I_n \le \frac{e}{n+1}$.

5. Déduction de la limite de $(I_n)$ :
On a $0 \le I_n \le \frac{e}{n+1}$.
On sait que $\lim_{n \to +\infty} 0 = 0$ et $\lim_{n \to +\infty} \frac{e}{n+1} = 0$.
D''après le théorème des gendarmes, on peut conclure que $\lim_{n \to +\infty} I_n = 0$.', '["Pour le calcul de $I_0$, pense à la primitive de $e^{u(x)}$.","Pour la relation de récurrence, utilise une intégration par parties. Pose $u(x) = x^{n+1}$ et $v''(x) = e^{1-x}$.","Pour l''encadrement, tu peux majorer $e^{1-x}$ sur l''intervalle $[0, 1]$.","Pour la limite, utilise le théorème des gendarmes."]'::jsonb, '2025-12-16T22:58:48.496322+00:00'::timestamptz, 'daa2ba31b167975018466f547ac5fad45302e32e4beaf8a0de8a93200cb10333', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('fe9c3b81-0fb6-4638-bbcf-372660f3be5c', 'Suites numériques', 'terminale', '{"questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$.","Démontre par récurrence que pour tout entier naturel $n$, $U_n > 0$.","Démontre que la suite $(U_n)$ est strictement croissante.","Démontre par récurrence que pour tout entier naturel $n$, $U_n \\ge n+1$.","Déduis-en la limite de la suite $(U_n)$ lorsque $n$ tend vers $+\\infty$."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 1$ et $U_{n+1} = \\sqrt{U_n^2 + 2U_n + 2}$ pour tout entier naturel $n$."}', '1. Calcul des premiers termes :
$U_0 = 1$
$U_1 = \sqrt{1^2 + 2(1) + 2} = \sqrt{1+2+2} = \sqrt{5}$
$U_2 = \sqrt{(\sqrt{5})^2 + 2\sqrt{5} + 2} = \sqrt{5 + 2\sqrt{5} + 2} = \sqrt{7 + 2\sqrt{5}}$
$U_3 = \sqrt{(\sqrt{7 + 2\sqrt{5}})^2 + 2\sqrt{7 + 2\sqrt{5}} + 2} = \sqrt{7 + 2\sqrt{5} + 2\sqrt{7 + 2\sqrt{5}} + 2} = \sqrt{9 + 2\sqrt{5} + 2\sqrt{7 + 2\sqrt{5}}}$

2. Démontrons par récurrence que pour tout entier naturel $n$, $U_n > 0$.
Initialisation : Pour $n=0$, $U_0 = 1 > 0$. La propriété est vraie au rang 0.
Hérédité : Supposons que pour un certain entier naturel $k$, $U_k > 0$. Montrons que $U_{k+1} > 0$. 
$U_{k+1} = \sqrt{U_k^2 + 2U_k + 2}$. Comme $U_k > 0$, alors $U_k^2 > 0$, $2U_k > 0$, et $2 > 0$. Donc $U_k^2 + 2U_k + 2 > 0$. La racine carrée d''un nombre strictement positif est un nombre strictement positif. Donc $U_{k+1} > 0$. 
Conclusion : Par le principe de récurrence, pour tout entier naturel $n$, $U_n > 0$.

3. Démontrons que la suite $(U_n)$ est strictement croissante.
Étudions le signe de $U_{n+1}^2 - U_n^2$: 
$U_{n+1}^2 - U_n^2 = (U_n^2 + 2U_n + 2) - U_n^2 = 2U_n + 2$. 
Comme $U_n > 0$ (démontré précédemment), alors $2U_n > 0$, et donc $2U_n + 2 > 2 > 0$. 
Ainsi, $U_{n+1}^2 - U_n^2 > 0$, ce qui implique $U_{n+1}^2 > U_n^2$. 
Puisque tous les termes de la suite sont positifs, on peut prendre la racine carrée sans changer le sens de l''inégalité : $\sqrt{U_{n+1}^2} > \sqrt{U_n^2}$, soit $U_{n+1} > U_n$. 
Donc la suite $(U_n)$ est strictement croissante.

4. Démontrons par récurrence que pour tout entier naturel $n$, $U_n \ge n+1$.
Initialisation : Pour $n=0$, $U_0 = 1$ et $0+1 = 1$. Donc $U_0 \ge 0+1$. La propriété est vraie au rang 0.
Hérédité : Supposons que pour un certain entier naturel $k$, $U_k \ge k+1$. Montrons que $U_{k+1} \ge k+2$. 
On sait que $U_k \ge k+1$. En élevant au carré (les termes sont positifs), on a $U_k^2 \ge (k+1)^2 = k^2 + 2k + 1$. 
Alors $U_{k+1}^2 = U_k^2 + 2U_k + 2$. 
En utilisant l''hypothèse de récurrence $U_k \ge k+1$ :
$U_{k+1}^2 \ge (k+1)^2 + 2(k+1) + 2 = k^2 + 2k + 1 + 2k + 2 + 2 = k^2 + 4k + 5$. 
Nous voulons montrer que $U_{k+1} \ge k+2$, ce qui équivaut à $U_{k+1}^2 \ge (k+2)^2 = k^2 + 4k + 4$. 
Comparons $k^2 + 4k + 5$ et $k^2 + 4k + 4$. On a $k^2 + 4k + 5 > k^2 + 4k + 4$. 
Donc $U_{k+1}^2 \ge k^2 + 4k + 5 > k^2 + 4k + 4 = (k+2)^2$. 
Comme $U_{k+1} > 0$ et $k+2 > 0$, on peut prendre la racine carrée : $U_{k+1} > \sqrt{(k+2)^2} = k+2$. 
Conclusion : Par le principe de récurrence, pour tout entier naturel $n$, $U_n \ge n+1$.

5. Déduisons la limite de la suite $(U_n)$.
Nous avons démontré que pour tout entier naturel $n$, $U_n \ge n+1$. 
Nous savons que $\lim_{n \to +\infty} (n+1) = +\infty$. 
Puisque $U_n \ge n+1$ et que $n+1$ tend vers $+\infty$, par le théorème de comparaison, la suite $(U_n)$ tend également vers $+\infty$. 
Donc $\lim_{n \to +\infty} U_n = +\infty$.', '["Pour le calcul des premiers termes, remplace $n$ par les valeurs appropriées dans la formule de récurrence.","Pour la récurrence, l''initialisation est simple. Pour l''hérédité, pense à la propriété de la fonction racine carrée.","Pour le sens de variation, étudie le signe de $U_{n+1} - U_n$. Tu peux aussi comparer $U_{n+1}^2$ et $U_n^2$.","Pour la récurrence de $U_n \\ge n+1$, l''hérédité nécessite de montrer que $\\sqrt{U_n^2 + 2U_n + 2} \\ge n+2$ si $U_n \\ge n+1$. Pense à élever au carré.","Si une suite est croissante et tend vers l''infini, que peux-tu en déduire ?"]'::jsonb, '2025-12-17T13:27:04.463005+00:00'::timestamptz, '53aae3239d392bde3df3c6ecc4242063eca07fdd169ecb77d36429a7c5e10fc6', NULL),
('3fb86ce4-c6cb-44fc-887b-45a728efb3cc', 'Suites numériques', 'terminale', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 0$ et $U_{n+1} = \\frac{2U_n + 1}{U_n + 2}$ pour tout entier naturel $n$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$.","On admet que pour tout $n \\in \\mathbb{N}$, $U_n \\ge 0$. Démontre par récurrence que pour tout entier naturel $n$, $U_n < 1$.","Établis le sens de variation de la suite $(U_n)$. Pour cela, étudie le signe de la différence $U_{n+1} - U_n$.","Que peux-tu en déduire quant à la convergence de la suite $(U_n)$ ?","On considère la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = \\frac{U_n - 1}{U_n + 1}$. Démontre que la suite $(V_n)$ est une suite géométrique. Tu devras déterminer sa raison et son premier terme.","Exprime $V_n$ en fonction de $n$, puis déduis-en l''expression de $U_n$ en fonction de $n$.","Détermine la limite de la suite $(U_n)$ lorsque $n$ tend vers $+\\infty$."]}', '1. Calcul des premiers termes :
$U_0 = 0$
$U_1 = \frac{2(0) + 1}{0 + 2} = \frac{1}{2}$
$U_2 = \frac{2(\frac{1}{2}) + 1}{\frac{1}{2} + 2} = \frac{1 + 1}{\frac{5}{2}} = \frac{2}{\frac{5}{2}} = \frac{4}{5}$
$U_3 = \frac{2(\frac{4}{5}) + 1}{\frac{4}{5} + 2} = \frac{\frac{8}{5} + 1}{\frac{4}{5} + \frac{10}{5}} = \frac{\frac{13}{5}}{\frac{14}{5}} = \frac{13}{14}$

2. Démontrons par récurrence que pour tout $n \in \mathbb{N}$, $U_n < 1$.
Initialisation : Pour $n=0$, $U_0 = 0 < 1$. La propriété est vraie pour $n=0$.
Hérédité : Supposons que pour un certain entier naturel $n$, $U_n < 1$. (Hypothèse de récurrence)
Nous savons aussi que $U_n \ge 0$.
Nous voulons montrer que $U_{n+1} < 1$.
$U_{n+1} - 1 = \frac{2U_n + 1}{U_n + 2} - 1 = \frac{2U_n + 1 - (U_n + 2)}{U_n + 2} = \frac{2U_n + 1 - U_n - 2}{U_n + 2} = \frac{U_n - 1}{U_n + 2}$.
Puisque $U_n < 1$, alors $U_n - 1 < 0$.
Puisque $U_n \ge 0$, alors $U_n + 2 > 0$.
Donc, $U_{n+1} - 1 < 0$, ce qui signifie $U_{n+1} < 1$.
Conclusion : La propriété est vraie pour tout entier naturel $n$.

3. Sens de variation de la suite $(U_n)$.
Étudions le signe de $U_{n+1} - U_n$ :
$U_{n+1} - U_n = \frac{2U_n + 1}{U_n + 2} - U_n = \frac{2U_n + 1 - U_n(U_n + 2)}{U_n + 2} = \frac{2U_n + 1 - U_n^2 - 2U_n}{U_n + 2} = \frac{1 - U_n^2}{U_n + 2}$.
Nous savons que $U_n \ge 0$ et $U_n < 1$.
Donc $U_n^2 < 1$, ce qui implique $1 - U_n^2 > 0$.
De plus, $U_n + 2 > 0$.
Par conséquent, $U_{n+1} - U_n > 0$. La suite $(U_n)$ est strictement croissante.

4. Convergence de la suite $(U_n)$.
La suite $(U_n)$ est croissante et majorée par 1 (démontré en question 2). D''après le théorème de convergence monotone, la suite $(U_n)$ converge.

5. Démontrons que la suite $(V_n)$ est une suite géométrique.
$V_n = \frac{U_n - 1}{U_n + 1}$
$V_{n+1} = \frac{U_{n+1} - 1}{U_{n+1} + 1}$
On remplace $U_{n+1}$ par son expression : $U_{n+1} = \frac{2U_n + 1}{U_n + 2}$
$U_{n+1} - 1 = \frac{2U_n + 1}{U_n + 2} - 1 = \frac{2U_n + 1 - (U_n + 2)}{U_n + 2} = \frac{U_n - 1}{U_n + 2}$
$U_{n+1} + 1 = \frac{2U_n + 1}{U_n + 2} + 1 = \frac{2U_n + 1 + (U_n + 2)}{U_n + 2} = \frac{3U_n + 3}{U_n + 2}$
Donc, $V_{n+1} = \frac{\frac{U_n - 1}{U_n + 2}}{\frac{3U_n + 3}{U_n + 2}} = \frac{U_n - 1}{3U_n + 3} = \frac{U_n - 1}{3(U_n + 1)} = \frac{1}{3} \times \frac{U_n - 1}{U_n + 1} = \frac{1}{3} V_n$.
La suite $(V_n)$ est une suite géométrique de raison $q = \frac{1}{3}$.
Calculons son premier terme $V_0$ :
$V_0 = \frac{U_0 - 1}{U_0 + 1} = \frac{0 - 1}{0 + 1} = -1$.

6. Expression de $V_n$ et $U_n$ en fonction de $n$.
Comme $(V_n)$ est une suite géométrique, $V_n = V_0 q^n = -1 \times (\frac{1}{3})^n = -(\frac{1}{3})^n$.
Maintenant, exprimons $U_n$ en fonction de $V_n$ :
$V_n = \frac{U_n - 1}{U_n + 1}$
$V_n(U_n + 1) = U_n - 1$
$V_n U_n + V_n = U_n - 1$
$V_n U_n - U_n = -1 - V_n$
$U_n(V_n - 1) = -(1 + V_n)$
$U_n = \frac{-(1 + V_n)}{V_n - 1} = \frac{1 + V_n}{1 - V_n}$.
En remplaçant $V_n$ par son expression :
$U_n = \frac{1 - (\frac{1}{3})^n}{1 - (-( \frac{1}{3})^n)} = \frac{1 - (\frac{1}{3})^n}{1 + (\frac{1}{3})^n}$.

7. Limite de la suite $(U_n)$.
Lorsque $n \to +\infty$, $(\frac{1}{3})^n \to 0$ car $-1 < \frac{1}{3} < 1$.
Donc, $\lim_{n \to +\infty} U_n = \frac{1 - 0}{1 + 0} = 1$.', '["Pour la récurrence, tu dois d''abord vérifier l''initialisation, puis supposer que la propriété est vraie pour un certain $n$ et la prouver pour $n+1$.","Pour le sens de variation, réduis $U_{n+1} - U_n$ au même dénominateur et utilise la question précédente.","Pour la suite géométrique, calcule $V_{n+1}$ en fonction de $U_{n+1}$, puis remplace $U_{n+1}$ par son expression en fonction de $U_n$. Ensuite, essaie de faire apparaître $V_n$.","Pour la limite de $U_n$, utilise l''expression de $U_n$ en fonction de $n$ que tu auras trouvée."]'::jsonb, '2025-12-17T16:52:03.138359+00:00'::timestamptz, '0ed700a627976fbf5bb604db7ba434ff3cdd91ff65a20adfed460610440865a2', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('09b4a9a4-d79c-40c5-94ce-08458b839c6a', 'Limites de fonctions', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $]0; +\\infty[$ par $f(x) = x \\ln(x) - x^2$.","questions":["Détermine la limite de $f(x)$ quand $x$ tend vers $0$ par valeurs supérieures.","Détermine la limite de $f(x)$ quand $x$ tend vers $+ \\infty$."]}', '1. Limite en $0$ par valeurs supérieures :
On sait que $\lim_{x \to 0^+} x \ln(x) = 0$ (croissance comparée).
De plus, $\lim_{x \to 0^+} -x^2 = 0$.
Donc, par somme, $\lim_{x \to 0^+} f(x) = 0 + 0 = 0$.

2. Limite en $+ \infty$ :
On a $f(x) = x \ln(x) - x^2$. C''est une forme indéterminée $$\infty - \infty$$.
Factorisons par $x^2$ : $f(x) = x^2 \left( \frac{\ln(x)}{x} - 1 \right)$.
On sait que $\lim_{x \to +\infty} \frac{\ln(x)}{x} = 0$ (croissance comparée).
Donc $\lim_{x \to +\infty} \left( \frac{\ln(x)}{x} - 1 \right) = 0 - 1 = -1$.
Et $\lim_{x \to +\infty} x^2 = +\infty$.
Par produit, $\lim_{x \to +\infty} f(x) = (+\infty) \times (-1) = -\infty$.', '["Pour la limite en $0$, pense à la croissance comparée de $x \\ln(x)$.","Pour la limite en $+ \\infty$, factorise par le terme dominant et utilise les croissances comparées."]'::jsonb, '2025-12-17T17:00:40.648031+00:00'::timestamptz, '4be6992cd80ba5ef0af3473ce9418c9db4cc94153c0f22cb1b25d7662ac71d0d', NULL),
('c407ba85-d51c-4318-8c5f-d25b8df662d8', 'Fonctions', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x^2 + 2x + 1)e^{-x}$. On note $\\mathcal{C}_f$ sa courbe représentative dans un repère orthogonal.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}$.","Dresse le tableau de variations de la fonction $f$ sur $\\mathbb{R}$.","Détermine la limite de $f(x)$ lorsque $x$ tend vers $+ \\infty$.","Détermine la limite de $f(x)$ lorsque $x$ tend vers $- \\infty$."]}', '1. Calcul de la dérivée $f''(x)$ :
La fonction $f(x)$ est de la forme $u(x)v(x)$ avec $u(x) = x^2 + 2x + 1$ et $v(x) = e^{-x}$.
On a $u''(x) = 2x + 2$ et $v''(x) = -e^{-x}$.
En utilisant la formule $(uv)'' = u''v + uv''$ :
$f''(x) = (2x + 2)e^{-x} + (x^2 + 2x + 1)(-e^{-x})$
$f''(x) = e^{-x} [(2x + 2) - (x^2 + 2x + 1)]$
$f''(x) = e^{-x} [2x + 2 - x^2 - 2x - 1]$
$f''(x) = e^{-x} (-x^2 + 1)$
$f''(x) = -e^{-x} (x^2 - 1)$
$f''(x) = -e^{-x} (x-1)(x+1)$

2. Étude du signe de $f''(x)$ :
Comme $e^{-x} > 0$ pour tout $x \in \mathbb{R}$, le signe de $f''(x)$ est celui de $-(x^2 - 1)$.
On étudie le signe de $x^2 - 1 = (x-1)(x+1)$ :
$x^2 - 1 = 0$ pour $x = 1$ ou $x = -1$.
$x^2 - 1 > 0$ pour $x \in ]- \infty; -1[ \cup ]1; + \infty[$
$x^2 - 1 < 0$ pour $x \in ]-1; 1[$

Donc, le signe de $-(x^2 - 1)$ est :
$f''(x) < 0$ pour $x \in ]- \infty; -1[ \cup ]1; + \infty[$
$f''(x) > 0$ pour $x \in ]-1; 1[$
$f''(x) = 0$ pour $x = -1$ ou $x = 1$

3. Tableau de variations de $f$ :

$x$         $- \infty$         $-1$         $1$         $+ \infty$
$f''(x)$     $-$         $0$     $+$     $0$     $-$
$f(x)$      $\searrow$         $f(-1)$         $\nearrow$         $f(1)$         $\searrow$

Calcul des valeurs :
$f(-1) = ((-1)^2 + 2(-1) + 1)e^{-(-1)} = (1 - 2 + 1)e^1 = 0 \times e = 0$
$f(1) = (1^2 + 2(1) + 1)e^{-1} = (1 + 2 + 1)e^{-1} = 4e^{-1} = \frac{4}{e}$

4. Limite de $f(x)$ quand $x \to + \infty$ :
$f(x) = (x^2 + 2x + 1)e^{-x} = \frac{x^2 + 2x + 1}{e^x}$
C''est une forme indéterminée de type $\frac{\infty}{\infty}$.
Par croissances comparées, on sait que $\lim_{x \to + \infty} \frac{e^x}{x^n} = + \infty$ pour tout $n > 0$. Donc $\lim_{x \to + \infty} \frac{x^n}{e^x} = 0$.
Ici, on a un polynôme de degré 2 au numérateur. La limite est donc $0$.
$\lim_{x \to + \infty} f(x) = 0$

5. Limite de $f(x)$ quand $x \to - \infty$ :
Posons $X = -x$. Quand $x \to - \infty$, $X \to + \infty$.
$f(x) = ((-X)^2 + 2(-X) + 1)e^{-(-X)} = (X^2 - 2X + 1)e^X$
$\lim_{X \to + \infty} (X^2 - 2X + 1) = + \infty$
$\lim_{X \to + \infty} e^X = + \infty$
Donc, par produit des limites :
$\lim_{x \to - \infty} f(x) = + \infty$', '["Pour calculer la dérivée, pense à la formule de dérivation d''un produit $(uv)'' = u''v + uv''$ et à la dérivée de $e^{-x}$.","Pour le signe de $f''(x)$, factorise l''expression et rappelle-toi que $e^{-x}$ est toujours positif.","Pour la limite en $+ \\infty$, tu pourrais avoir une forme indéterminée. Pense aux croissances comparées.","Pour la limite en $- \\infty$, il n''y a pas de forme indéterminée, remplace $x$ par de très grandes valeurs négatives."]'::jsonb, '2025-12-17T17:05:44.765043+00:00'::timestamptz, 'ea7ee387094d14a297ee23cf151eb0b391a6406045bdd90f4fa9352bb83aca12', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('dc680c4e-a0a0-4d5e-894b-eca56a823974', 'Géométrie repérée dans l''espace - Équation cartésienne d''un plan', 'terminale', '{"contexte":"Dans un repère orthonormé de l''espace $(O; \\vec{i}, \\vec{j}, \\vec{k})$, on considère les points $A(2, -1, 3)$, $B(1, 1, 1)$ et $C(0, 2, 5)$.","questions":["Détermine les coordonnées des vecteurs $\\vec{AB}$ et $\\vec{AC}$.","Montre que les points $A$, $B$ et $C$ ne sont pas alignés.","Détermine un vecteur normal $\\vec{n}(a, b, c)$ au plan $(ABC)$.","Déduis-en une équation cartésienne du plan $(ABC)$.","Vérifie que les coordonnées des points $A$, $B$ et $C$ satisfont bien l''équation trouvée."]}', '1. Coordonnées des vecteurs :
$\vec{AB} = (1-2, 1-(-1), 1-3) = (-1, 2, -2)$
$\vec{AC} = (0-2, 2-(-1), 5-3) = (-2, 3, 2)$

2. Les points $A$, $B$ et $C$ ne sont pas alignés si les vecteurs $\vec{AB}$ et $\vec{AC}$ ne sont pas colinéaires.
On vérifie si les coordonnées sont proportionnelles :
$\frac{-1}{-2} = \frac{1}{2}$
$\frac{2}{3}$
Comme $\frac{1}{2} \neq \frac{2}{3}$, les vecteurs $\vec{AB}$ et $\vec{AC}$ ne sont pas colinéaires. Donc les points $A$, $B$ et $C$ ne sont pas alignés.

3. Détermination d''un vecteur normal $\vec{n}(a, b, c)$ au plan $(ABC)$ :
$\vec{n} \cdot \vec{AB} = 0 \Rightarrow -a + 2b - 2c = 0$ (1)
$\vec{n} \cdot \vec{AC} = 0 \Rightarrow -2a + 3b + 2c = 0$ (2)

Additionnons (1) et (2) :
$(-a + 2b - 2c) + (-2a + 3b + 2c) = 0$
$-3a + 5b = 0 \Rightarrow 5b = 3a \Rightarrow b = \frac{3}{5}a$

Substituons $b$ dans (1) :
$-a + 2(\frac{3}{5}a) - 2c = 0$
$-a + \frac{6}{5}a - 2c = 0$
$\frac{1}{5}a - 2c = 0 \Rightarrow 2c = \frac{1}{5}a \Rightarrow c = \frac{1}{10}a$

Choisissons $a = 10$ pour avoir des entiers :
$b = \frac{3}{5}(10) = 6$
$c = \frac{1}{10}(10) = 1$
Donc, un vecteur normal est $\vec{n}(10, 6, 1)$.

4. Équation cartésienne du plan $(ABC)$ :
Le plan a pour équation $10x + 6y + z + d = 0$.
Utilisons le point $A(2, -1, 3)$ :
$10(2) + 6(-1) + 3 + d = 0$
$20 - 6 + 3 + d = 0$
$17 + d = 0 \Rightarrow d = -17$
L''équation cartésienne du plan $(ABC)$ est $10x + 6y + z - 17 = 0$.

5. Vérification :
Pour $A(2, -1, 3)$ : $10(2) + 6(-1) + 3 - 17 = 20 - 6 + 3 - 17 = 14 + 3 - 17 = 17 - 17 = 0$. OK.
Pour $B(1, 1, 1)$ : $10(1) + 6(1) + 1 - 17 = 10 + 6 + 1 - 17 = 17 - 17 = 0$. OK.
Pour $C(0, 2, 5)$ : $10(0) + 6(2) + 5 - 17 = 0 + 12 + 5 - 17 = 17 - 17 = 0$. OK.', '["Pour trouver un vecteur normal, pense au produit scalaire avec les vecteurs directeurs du plan.","Un vecteur normal est orthogonal à deux vecteurs non colinéaires du plan.","Pour la vérification, remplace les coordonnées de chaque point dans l''équation du plan et assure-toi que l''égalité est vraie."]'::jsonb, '2025-12-17T17:19:07.890984+00:00'::timestamptz, '68ae12e5d81ee5507169b9651e18438a5504d0458462dacaf30ee3ba41914762', NULL),
('c90ee47f-2435-4427-abed-566f51897ebf', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x+1)e^{-x}$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}$.","Dresse le tableau de variations de la fonction $f$."]}', '1. Calcul de la dérivée $f''(x)$ :
La fonction $f(x) = (2x+1)e^{-x}$ est de la forme $uv$ avec $u(x) = 2x+1$ et $v(x) = e^{-x}$.
On a $u''(x) = 2$ et $v''(x) = -e^{-x}$.
Donc $f''(x) = u''(x)v(x) + u(x)v''(x) = 2e^{-x} + (2x+1)(-e^{-x}) = e^{-x}(2 - (2x+1)) = e^{-x}(2 - 2x - 1) = e^{-x}(1 - 2x)$.

2. Étude du signe de $f''(x)$ :
On sait que $e^{-x} > 0$ pour tout $x \in \mathbb{R}$.
Le signe de $f''(x)$ est donc le même que le signe de $1 - 2x$.
$1 - 2x > 0 \iff 1 > 2x \iff x < \frac{1}{2}$
$1 - 2x = 0 \iff x = \frac{1}{2}$
$1 - 2x < 0 \iff x > \frac{1}{2}$

3. Tableau de variations de la fonction $f$ :

| $x$             | $-\infty$ | $1/2$ | $+\infty$ |
|-----------------|-----------|-------|-----------|
| Signe de $f''(x)$ | $+$       | $0$   | $-$       |
| Variations de $f$ | Croissante| $f(1/2)$ | Décroissante|

$f(\frac{1}{2}) = (2(\frac{1}{2})+1)e^{-\frac{1}{2}} = (1+1)e^{-\frac{1}{2}} = 2e^{-\frac{1}{2}} = \frac{2}{\sqrt{e}}$.', '["Pense à la formule de dérivation d''un produit $ (uv)'' = u''v + uv'' $.","N''oublie pas que la dérivée de $e^{-x}$ est $-e^{-x}$.","Pour le signe de $f''(x)$, souviens-toi que $e^{-x}$ est toujours positif."]'::jsonb, '2025-12-17T18:42:06.333489+00:00'::timestamptz, 'b51c309fe5104bb54d10b85bc617d8cbaf32b74d98b6e3e63d1f2479e85cc4e2', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('b96db1d3-7bff-47ab-9d38-a9a0cca4f8dc', 'Calcul intégral', 'terminale', '{"contexte":"Calcule l''intégrale suivante : $$J = \\int_0^{\\frac{\\pi}{2}} x^2 \\sin(x) dx$$","questions":["Détaille toutes les étapes de ton calcul, en précisant bien tes choix pour $u(x)$, $v''(x)$, $u''(x)$ et $v(x)$ à chaque fois."]}', 'Pour calculer $J = \int_0^{\frac{\pi}{2}} x^2 \sin(x) dx$, nous allons utiliser l''intégration par parties (IPP) deux fois.

**Première IPP :**
Posons :
$u(x) = x^2 \implies u''(x) = 2x$
$v''(x) = \sin(x) \implies v(x) = -\cos(x)$

En appliquant la formule d''IPP : $\int_a^b u(x)v''(x) dx = [u(x)v(x)]_a^b - \int_a^b u''(x)v(x) dx$

$J = [-x^2 \cos(x)]_0^{\frac{\pi}{2}} - \int_0^{\frac{\pi}{2}} 2x(-\cos(x)) dx$
$J = [-((\frac{\pi}{2})^2 \cos(\frac{\pi}{2})) - (-(0)^2 \cos(0))] + 2 \int_0^{\frac{\pi}{2}} x \cos(x) dx$
$J = [-((\frac{\pi}{2})^2 \cdot 0) - (0)] + 2 \int_0^{\frac{\pi}{2}} x \cos(x) dx$
$J = 2 \int_0^{\frac{\pi}{2}} x \cos(x) dx$

**Deuxième IPP (sur l''intégrale restante) :**
Appelons $K = \int_0^{\frac{\pi}{2}} x \cos(x) dx$.
Posons :
$u(x) = x \implies u''(x) = 1$
$v''(x) = \cos(x) \implies v(x) = \sin(x)$

En appliquant la formule d''IPP à $K$ :
$K = [x \sin(x)]_0^{\frac{\pi}{2}} - \int_0^{\frac{\pi}{2}} 1 \cdot \sin(x) dx$
$K = [(\frac{\pi}{2} \sin(\frac{\pi}{2})) - (0 \cdot \sin(0))] - \int_0^{\frac{\pi}{2}} \sin(x) dx$
$K = [\frac{\pi}{2} \cdot 1 - 0] - [-\cos(x)]_0^{\frac{\pi}{2}}$
$K = \frac{\pi}{2} - [-\cos(\frac{\pi}{2}) - (-\cos(0))]$
$K = \frac{\pi}{2} - [-0 - (-1)]$
$K = \frac{\pi}{2} - 1$

**Conclusion :**
Nous avons trouvé $J = 2K$.
Donc, $J = 2(\frac{\pi}{2} - 1) = \pi - 2$.

L''intégrale $J$ est égale à $\pi - 2$.', '["Pense à la formule de l''intégration par parties : $\\int_a^b u(x)v''(x) dx = [u(x)v(x)]_a^b - \\int_a^b u''(x)v(x) dx$.","Tu devras probablement appliquer l''intégration par parties deux fois de suite.","Pour le premier choix, essaie de poser $u(x) = x^2$ et $v''(x) = \\sin(x)$."]'::jsonb, '2025-12-17T23:15:45.117309+00:00'::timestamptz, '3ff05df9c916ac7c708abbe5577d74f623d7e109274a16972889e074da4d1605', NULL),
('4b77a8ed-84b6-4777-9429-4e9198a0583f', 'Calcul intégral', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x+1)e^x$.","questions":["Détermine une primitive $F$ de $f$ sur $\\mathbb{R}$.","Calcule la valeur exacte de l''intégrale $I = \\int_0^1 f(x)dx$."]}', 'Pour déterminer une primitive de $f(x) = (2x+1)e^x$, nous allons utiliser l''intégration par parties.
Posons $u(x) = 2x+1$ et $v''(x) = e^x$.
Alors $u''(x) = 2$ et $v(x) = e^x$.

La formule d''intégration par parties pour une primitive est $\int u(x)v''(x)dx = u(x)v(x) - \int u''(x)v(x)dx$.
Donc, $\int (2x+1)e^x dx = (2x+1)e^x - \int 2e^x dx$.
$\int (2x+1)e^x dx = (2x+1)e^x - 2e^x + C$.
$F(x) = (2x+1-2)e^x + C = (2x-1)e^x + C$.

Pour la deuxième question, nous calculons l''intégrale $I = \int_0^1 f(x)dx$.
$I = [ (2x-1)e^x ]_0^1$.
$I = (2(1)-1)e^1 - (2(0)-1)e^0$.
$I = (1)e - (-1)(1)$.
$I = e + 1$.', '["Pense à l''intégration par parties. La formule est $\\int_a^b u''(x)v(x)dx = [u(x)v(x)]_a^b - \\int_a^b u(x)v''(x)dx$.","Choisis judicieusement $u''(x)$ et $v(x)$.","N''oublie pas la constante d''intégration pour la primitive."]'::jsonb, '2025-12-18T15:29:09.210732+00:00'::timestamptz, 'b431519554b31f55954bb8eef978dee620fe2780c431daaf31cadfae47c293fd', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('03ea4144-41d0-4a2c-98c9-63625a5e1eca', 'Exercice', 'terminale', '{"contexte":"","questions":["Calculer deux vecteurs non colinéaires formés par ces points, par exemple $\\vec{AB}$ et $\\vec{AC}$","Chercher un vecteur normal $\\vec{n}(a; b; c)$ qui est orthogonal à $\\vec{AB}$ et à $\\vec{AC}$","Utiliser un des points (par exemple $A$) et le vecteur normal $\\vec{n}$ trouvé pour appliquer la Méthode 1","Calcul des vecteurs :","Recherche d''un vecteur normal $\\vec{n}(a; b; c)$ :","Utilisation de $A(1; 0; 0)$ et $\\vec{n}(1; 1; 1)$ :"]}', 'À résoudre', '[]'::jsonb, '2025-12-18T22:48:13.334716+00:00'::timestamptz, 'bcc67f598c688b29200d39e91486fdf80ba13c1bee75f1ebb7b05a529ad067aa', NULL),
('0d387e5b-a58c-4773-9841-5f50dbab218c', 'Dérivation et étude de fonctions', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{e^{2x}}{x}$. On note $\\mathcal{C}_f$ sa courbe représentative dans un repère orthogonal.","questions":["Détermine les limites de la fonction $f$ aux bornes de son ensemble de définition.","Calcule la dérivée $f''(x)$ de la fonction $f$ et étudie son signe.","Dresse le tableau de variations complet de la fonction $f$.","Démontre que l''équation $f(x) = 2e^2$ admet une unique solution sur l''intervalle $]0 ; 1[$ et une unique solution sur l''intervalle $]1 ; +\\infty[$. On ne cherchera pas à calculer ces solutions.","Détermine l''équation de la tangente à la courbe $\\mathcal{C}_f$ au point d''abscisse $x=1$."]}', '1. Limites de la fonction $f$ :\n- En $-\infty$ : $\lim_{x \to -\infty} e^{2x} = 0$ et $\lim_{x \to -\infty} \frac{1}{x} = 0$. Par produit, $\lim_{x \to -\infty} f(x) = 0$.\n- En $0^-$ : $\lim_{x \to 0^-} e^{2x} = 1$ et $\lim_{x \to 0^-} \frac{1}{x} = -\infty$. Par produit, $\lim_{x \to 0^-} f(x) = -\infty$.\n- En $0^+$ : $\lim_{x \to 0^+} e^{2x} = 1$ et $\lim_{x \to 0^+} \frac{1}{x} = +\infty$. Par produit, $\lim_{x \to 0^+} f(x) = +\infty$.\n- En $+\infty$ : On a une forme indéterminée de type $\frac{\infty}{\infty}$. On peut écrire $f(x) = 2 \frac{e^{2x}}{2x}$. En posant $X=2x$, on a $\lim_{X \to +\infty} \frac{e^X}{X} = +\infty$ (croissance comparée). Donc $\lim_{x \to +\infty} f(x) = +\infty$.\n\n2. Calcul de la dérivée $f''(x)$ et étude de son signe :\nLa fonction $f$ est de la forme $\frac{u}{v}$ avec $u(x) = e^{2x}$ et $v(x) = x$. Alors $u''(x) = 2e^{2x}$ et $v''(x) = 1$.\n$f''(x) = \frac{u''(x)v(x) - u(x)v''(x)}{[v(x)]^2} = \frac{2e^{2x} \cdot x - e^{2x} \cdot 1}{x^2} = \frac{e^{2x}(2x - 1)}{x^2}$.\nPour étudier le signe de $f''(x)$, on étudie le signe de $2x-1$ car $e^{2x} > 0$ et $x^2 > 0$ pour $x \in \mathbb{R}^*$.\n$2x - 1 = 0 \iff x = \frac{1}{2}$.\n$2x - 1 > 0 \iff x > \frac{1}{2}$.\n$2x - 1 < 0 \iff x < \frac{1}{2}$.\n\n3. Tableau de variations de la fonction $f$ :\n$x$ | $-\infty$ | $0$ | $\frac{1}{2}$ | $+\infty$\n--- | --- | --- | --- | ---\n$2x-1$ | $-$ | $-$ | $0$ | $+$\n$x^2$ | $+$ | $0$ | $+$ | $+$\n$f''(x)$ | $-$ | $||$ | $-$ | $0$ | $+$\n$f(x)$ | $0 \searrow -\infty$ | $||$ | $+\infty \searrow 2e \nearrow +\infty$\nNote : $f(\frac{1}{2}) = \frac{e^{2 \cdot \frac{1}{2}}}{\frac{1}{2}} = \frac{e}{\frac{1}{2}} = 2e$.\n\n4. Démonstration de l''existence et l''unicité des solutions de $f(x) = 2e^2$ :\n- Sur $]0 ; 1[$ :\n  La fonction $f$ est continue et strictement décroissante sur $]0 ; 1[$. (D''après le tableau de variations, $f$ est décroissante sur $]0 ; \frac{1}{2}]$ et $f(\frac{1}{2}) = 2e \approx 5.43$. $1$ est dans l''intervalle $]\frac{1}{2} ; +\infty[$ où $f$ est croissante. Il faut donc être plus précis sur les intervalles de stricte monotonie. $f$ est strictement décroissante sur $]0 ; \frac{1}{2}]$. Donc sur $]0 ; 1[$, $f$ n''est pas strictement monotone. Reprenons :\n  Sur $]0 ; \frac{1}{2}]$, $f$ est continue et strictement décroissante. $f(]0 ; \frac{1}{2}]) = [2e ; +\infty[$. $2e^2 \approx 14.78$. $2e^2 \in [2e ; +\infty[$. Donc, d''après le TVI, l''équation $f(x) = 2e^2$ admet une unique solution sur $]0 ; \frac{1}{2}]$. Comme $\frac{1}{2} \in ]0 ; 1[$, on a bien une solution sur $]0 ; 1[$. \n  Sur $[\frac{1}{2} ; 1[$, $f$ est continue et strictement croissante. $f([\frac{1}{2} ; 1[) = [2e ; f(1)[ = [2e ; e^2[$. $2e^2 \notin [2e ; e^2[$. Donc pas de solution sur $[\frac{1}{2} ; 1[$. \n  Finalement, l''équation $f(x) = 2e^2$ admet une unique solution sur $]0 ; 1[$.\n- Sur $]1 ; +\infty[$ :\n  La fonction $f$ est continue et strictement croissante sur $]1 ; +\infty[$. (Puisque $1 > \frac{1}{2}$, $f$ est croissante sur $[\frac{1}{2} ; +\infty[$, donc sur $]1 ; +\infty[$).\n  $f(1) = \frac{e^2}{1} = e^2$. $\lim_{x \to +\infty} f(x) = +\infty$.\n  L''intervalle image est $f(]1 ; +\infty[) = ]e^2 ; +\infty[$. \n  On compare $2e^2$ et $e^2$. Puisque $2e^2 > e^2$, $2e^2 \in ]e^2 ; +\infty[$. \n  D''après le théorème des valeurs intermédiaires, l''équation $f(x) = 2e^2$ admet une unique solution sur $]1 ; +\infty[$.\n\n5. Équation de la tangente à la courbe $\mathcal{C}_f$ au point d''abscisse $x=1$ :\nL''équation de la tangente est $y = f''(1)(x-1) + f(1)$.\nOn calcule $f(1) = \frac{e^{2 \cdot 1}}{1} = e^2$.\nOn calcule $f''(1) = \frac{e^{2 \cdot 1}(2 \cdot 1 - 1)}{1^2} = \frac{e^2(1)}{1} = e^2$.\nDonc l''équation de la tangente est $y = e^2(x-1) + e^2 = e^2x - e^2 + e^2 = e^2x$.', '["Pour les limites en l''infini, pense aux croissances comparées.","La dérivée d''un quotient $\\frac{u}{v}$ est $\\frac{u''v - uv''}{v^2}$.","Pour le signe de la dérivée, étudie le signe du numérateur.","Pour démontrer l''existence et l''unicité des solutions, utilise le théorème des valeurs intermédiaires et la stricte monotonie de la fonction sur les intervalles considérés.","L''équation de la tangente en un point d''abscisse $a$ est $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-12-19T13:57:22.380253+00:00'::timestamptz, 'c623841c8d749ecb232ef82b100da837243854fa1326d13c11ac1352d9ae68ec', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('918887d0-91c6-4f95-993a-ed928a6d09ba', 'Intégration par parties et Suites', 'terminale', '{"contexte":"Pour tout entier naturel $n$, on définit l''intégrale $I_n$ par : $$I_n = \\int_0^1 x^n e^{1-x} dx$$","questions":["Calcule la valeur exacte de $I_0$.","Démontre que pour tout entier naturel $n$, $I_{n+1} = (n+1)I_n - 1$.","En utilisant la relation de récurrence précédente, calcule la valeur exacte de $I_1$ et $I_2$.","Établis le sens de variation de la suite $(I_n)$.","Démontre que pour tout entier naturel $n$, $0 \\le I_n \\le \\frac{e}{n+1}$.","Déduis-en la limite de la suite $(I_n)$ lorsque $n$ tend vers $+\\infty$."]}', '1. Calcul de $I_0$ : 
$$I_0 = \int_0^1 x^0 e^{1-x} dx = \int_0^1 e^{1-x} dx$$ 
Une primitive de $e^{1-x}$ est $-e^{1-x}$. 
$$I_0 = [-e^{1-x}]_0^1 = (-e^{1-1}) - (-e^{1-0}) = -e^0 + e^1 = -1 + e$$ 
Donc $I_0 = e-1$.

2. Démonstration de la relation de récurrence : 
On utilise l''intégration par parties pour $I_{n+1} = \int_0^1 x^{n+1} e^{1-x} dx$. 
Posons $u(x) = x^{n+1}$ et $v''(x) = e^{1-x}$. 
Alors $u''(x) = (n+1)x^n$ et $v(x) = -e^{1-x}$. 
$$I_{n+1} = [u(x)v(x)]_0^1 - \int_0^1 u''(x)v(x) dx$$ 
$$I_{n+1} = [-x^{n+1}e^{1-x}]_0^1 - \int_0^1 (n+1)x^n (-e^{1-x}) dx$$ 
$$I_{n+1} = (-(1)^{n+1}e^{1-1}) - (-(0)^{n+1}e^{1-0}) + (n+1)\int_0^1 x^n e^{1-x} dx$$ 
$$I_{n+1} = -1e^0 - 0 + (n+1)I_n$$ 
$$I_{n+1} = -1 + (n+1)I_n$$ 
Donc $I_{n+1} = (n+1)I_n - 1$.

3. Calcul de $I_1$ et $I_2$ : 
Avec $n=0$ dans la relation de récurrence : 
$I_1 = (0+1)I_0 - 1 = I_0 - 1 = (e-1) - 1 = e-2$. 
Avec $n=1$ dans la relation de récurrence : 
$I_2 = (1+1)I_1 - 1 = 2I_1 - 1 = 2(e-2) - 1 = 2e - 4 - 1 = 2e - 5$.

4. Sens de variation de la suite $(I_n)$ : 
Étudions le signe de $I_{n+1} - I_n$. 
$$I_{n+1} - I_n = ((n+1)I_n - 1) - I_n = nI_n - 1$$ 
On sait que pour $x \in [0,1]$, $x^n \ge 0$ et $e^{1-x} > 0$, donc $I_n = \int_0^1 x^n e^{1-x} dx > 0$ pour tout $n$. 
De plus, $I_0 = e-1 \approx 1.718 > 0$. 
$I_1 = e-2 \approx 0.718 > 0$. 
$I_2 = 2e-5 \approx 0.436 > 0$. 
Il est difficile de conclure directement sur le signe de $nI_n - 1$ sans un encadrement plus précis de $I_n$. 

Reprenons avec $I_{n+1} - I_n = \int_0^1 x^{n+1} e^{1-x} dx - \int_0^1 x^n e^{1-x} dx = \int_0^1 (x^{n+1} - x^n) e^{1-x} dx = \int_0^1 x^n(x-1) e^{1-x} dx$. 
Pour $x \in [0,1]$, $x^n \ge 0$, $x-1 \le 0$ et $e^{1-x} > 0$. 
Donc $x^n(x-1)e^{1-x} \le 0$ sur $[0,1]$. 
Par conséquent, $I_{n+1} - I_n = \int_0^1 x^n(x-1) e^{1-x} dx \le 0$. 
La suite $(I_n)$ est décroissante.

5. Démonstration de l''encadrement : 
Pour $x \in [0,1]$, on a $0 \le x^n \le 1$. 
De plus, $0 \le 1-x \le 1$, donc $e^0 \le e^{1-x} \le e^1$, c''est-à-dire $1 \le e^{1-x} \le e$. 
En multipliant les inégalités (tous les termes sont positifs) : 
$0 \cdot 1 \le x^n e^{1-x} \le 1 \cdot e$ 
$0 \le x^n e^{1-x} \le e$. 
En intégrant sur l''intervalle $[0,1]$ : 
$$\int_0^1 0 dx \le \int_0^1 x^n e^{1-x} dx \le \int_0^1 e dx$$ 
$$0 \le I_n \le [ex]_0^1$$ 
$$0 \le I_n \le e(1) - e(0)$$ 
$$0 \le I_n \le e$$ 
Ceci est un premier encadrement. Pour obtenir l''encadrement demandé, on peut affiner. 

Reprenons : $0 \le x \le 1$. 
On a $e^{1-x} \le e^1 = e$ pour $x \in [0,1]$. 
Donc $x^n e^{1-x} \le x^n e$. 
En intégrant : 
$$I_n = \int_0^1 x^n e^{1-x} dx \le \int_0^1 x^n e dx$$ 
$$I_n \le e \int_0^1 x^n dx$$ 
$$I_n \le e \left[\frac{x^{n+1}}{n+1}\right]_0^1$$ 
$$I_n \le e \left(\frac{1^{n+1}}{n+1} - \frac{0^{n+1}}{n+1}\right)$$ 
$$I_n \le e \frac{1}{n+1}$$ 
Comme $x^n e^{1-x} \ge 0$ sur $[0,1]$, on a $I_n \ge 0$. 
Donc, pour tout entier naturel $n$, $0 \le I_n \le \frac{e}{n+1}$.

6. Limite de la suite $(I_n)$ : 
On a démontré que pour tout entier naturel $n$, $0 \le I_n \le \frac{e}{n+1}$. 
On sait que $\lim_{n \to +\infty} 0 = 0$. 
On sait aussi que $\lim_{n \to +\infty} \frac{e}{n+1} = 0$ (car $e$ est une constante et le dénominateur tend vers $+\infty$). 
D''après le théorème des gendarmes, on peut en déduire que $\lim_{n \to +\infty} I_n = 0$.', '["Pour calculer $I_0$, pense à la primitive de $e^{1-x}$.","Pour $I_{n+1}$, utilise l''intégration par parties en posant $u(x) = x^{n+1}$ et $v''(x) = e^{1-x}$.","Pour le sens de variation, étudie le signe de $I_{n+1} - I_n$.","Pour l''encadrement, utilise le fait que $x \\in [0,1]$ et $e^{1-x} \\le e$ sur cet intervalle.","Le théorème des gendarmes sera utile pour la limite."]'::jsonb, '2025-12-19T20:31:16.939894+00:00'::timestamptz, '50208d0659b8f97aed43ab97b0a7085970ccc266e557e5612b11cb7f1b414975', NULL),
('bdd04333-979b-4647-ba09-3b055a4e14b9', 'Primitives et équations différentielles', 'Terminale', '{"contexte":"On considère l''équation différentielle $(E): y'' = 2y - 6$.","questions":["Détermine la solution particulière constante de l''équation $(E)$.","Démontre que si $f$ est une solution de $(E)$, alors la fonction $g$ définie par $g(x) = f(x) - 3$ est une solution de l''équation différentielle $(E''): y'' = 2y$.","En déduis l''expression de $f(x)$ en fonction de $x$ et d''une constante $C$ pour les solutions de l''équation $(E)$.","Détermine la solution $f$ de $(E)$ qui vérifie la condition initiale $f(0) = 1$."]}', '1. Soit $y(x) = k$ une solution particulière constante. Alors $y''(x) = 0$. En remplaçant dans $(E)$: $0 = 2k - 6$, donc $2k = 6$, ce qui donne $k = 3$. La solution particulière constante est $y(x) = 3$.

2. Si $f$ est une solution de $(E)$, alors $f''(x) = 2f(x) - 6$. On définit $g(x) = f(x) - 3$. Alors $g''(x) = f''(x)$.
On veut montrer que $g$ est solution de $(E''): y'' = 2y$. C''est-à-dire que $g''(x) = 2g(x)$.
On a $g''(x) = f''(x)$. Puisque $f$ est solution de $(E)$, $f''(x) = 2f(x) - 6$.
Donc $g''(x) = 2f(x) - 6$. Or $f(x) = g(x) + 3$.
En substituant $f(x)$ dans l''expression de $g''(x)$: $g''(x) = 2(g(x) + 3) - 6 = 2g(x) + 6 - 6 = 2g(x)$.
Donc $g''(x) = 2g(x)$, ce qui signifie que $g$ est bien une solution de $(E''): y'' = 2y$.

3. L''équation $(E''): y'' = 2y$ est du type $y'' = ay$ avec $a=2$. Ses solutions sont de la forme $g(x) = C e^{2x}$.
Puisque $g(x) = f(x) - 3$, on a $f(x) = g(x) + 3$. 
Donc $f(x) = C e^{2x} + 3$.

4. On cherche la solution $f$ de $(E)$ qui vérifie $f(0) = 1$. On utilise l''expression générale $f(x) = C e^{2x} + 3$.
$f(0) = C e^{2 \times 0} + 3 = 1$.
$C e^0 + 3 = 1$.
$C \times 1 + 3 = 1$.
$C = 1 - 3$, donc $C = -2$.
La solution particulière est $f(x) = -2e^{2x} + 3$.', '["Pour la solution particulière constante, cherche une fonction $y(x) = k$ (où $k$ est une constante) qui vérifie l''équation.","Calcule $g''(x)$ en fonction de $f''(x)$ et remplace dans l''équation $(E'')$. Utilise ensuite le fait que $f$ est solution de $(E)$.","Utilise la forme des solutions de $y''=ay$ pour $g(x)$, puis exprime $f(x)$ à partir de $g(x)$.","Utilise la condition initiale $f(0)=1$ pour trouver la valeur de la constante $C$ dans l''expression générale de $f(x)$."]'::jsonb, '2025-12-19T20:59:03.505658+00:00'::timestamptz, '7b99817836549e131732283e055d107dccdcc671a5b233fd344e9e55d43084f6', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('e04a3cc1-ccd7-4249-859a-a4dc173ac151', 'Primitives et équations différentielles', 'Terminale', '{"contexte":"On considère l''équation différentielle $(E): y'' = -3y + 9$.","questions":["Détermine la solution particulière constante de l''équation $(E)$.","Soit $f$ une solution de l''équation $(E)$. On pose $z(x) = f(x) - 3$. Démontre que la fonction $z$ est solution d''une équation différentielle du type $z'' = az$, et précise la valeur de $a$.","En déduis l''expression de $f(x)$ en fonction de $x$ et d''une constante $C$.","Détermine la solution $f$ de $(E)$ qui vérifie la condition initiale $f(1) = 2$."]}', '1. Soit $y(x) = k$ une solution particulière constante. Alors $y''(x) = 0$. En remplaçant dans $(E)$: $0 = -3k + 9$, donc $3k = 9$, ce qui donne $k = 3$. La solution particulière constante est $y(x) = 3$.

2. Si $f$ est une solution de $(E)$, alors $f''(x) = -3f(x) + 9$. On pose $z(x) = f(x) - 3$. Alors $f(x) = z(x) + 3$. En dérivant, on obtient $f''(x) = z''(x)$.
En remplaçant $f(x)$ et $f''(x)$ dans l''équation $(E)$: $z''(x) = -3(z(x) + 3) + 9$.
$z''(x) = -3z(x) - 9 + 9$.
$z''(x) = -3z(x)$.
Donc la fonction $z$ est solution de l''équation différentielle $z'' = -3z$, avec $a = -3$.

3. L''équation $z'' = -3z$ est du type $y'' = ay$ avec $a=-3$. Ses solutions sont de la forme $z(x) = C e^{-3x}$.
Puisque $z(x) = f(x) - 3$, on a $f(x) = z(x) + 3$. 
Donc $f(x) = C e^{-3x} + 3$.

4. On cherche la solution $f$ de $(E)$ qui vérifie $f(1) = 2$. On utilise l''expression générale $f(x) = C e^{-3x} + 3$.
$f(1) = C e^{-3 \times 1} + 3 = 2$.
$C e^{-3} + 3 = 2$.
$C e^{-3} = 2 - 3$.
$C e^{-3} = -1$.
$C = -1 e^3$.
La solution particulière est $f(x) = -e^3 e^{-3x} + 3$, ou $f(x) = -e^{3-3x} + 3$.', '["Pour la solution particulière constante, cherche une fonction $y(x) = k$ (où $k$ est une constante) qui vérifie l''équation.","Exprime $f(x)$ en fonction de $z(x)$, puis dérive $f(x)$. Remplace ensuite $f(x)$ et $f''(x)$ dans l''équation $(E)$ pour trouver l''équation différentielle vérifiée par $z(x)$.","Utilise la forme des solutions de $z''=az$ pour $z(x)$, puis exprime $f(x)$ à partir de $z(x)$.","Utilise la condition initiale $f(1)=2$ pour trouver la valeur de la constante $C$ dans l''expression générale de $f(x)$."]'::jsonb, '2025-12-19T21:11:45.711572+00:00'::timestamptz, 'fcfc2caf0d57113cac155c08d81604622b1396342a9662b06eff81a45cb9010b', NULL),
('857a46ad-da96-4bd7-b5c6-393a8af04860', 'Calcul intégral', 'Terminale', '{"contexte":"Calcule l''intégrale suivante : $$\\int_1^2 (3x^2 - 2x + 1) dx$$","questions":["Détaille toutes les étapes de ton calcul. N''oublie pas de trouver une primitive de la fonction avant de l''évaluer aux bornes."]}', 'Pour calculer l''intégrale $\int_1^2 (3x^2 - 2x + 1) dx$ :

1. **Trouver une primitive $F(x)$ de $f(x) = 3x^2 - 2x + 1$** :
   - Une primitive de $3x^2$ est $3 \times \frac{x^{2+1}}{2+1} = 3 \times \frac{x^3}{3} = x^3$.
   - Une primitive de $-2x$ est $-2 \times \frac{x^{1+1}}{1+1} = -2 \times \frac{x^2}{2} = -x^2$.
   - Une primitive de $1$ est $x$.
   Donc, une primitive $F(x)$ de $f(x)$ est $F(x) = x^3 - x^2 + x$.

2. **Évaluer la primitive aux bornes de l''intégrale** :
   L''intégrale est égale à $F(2) - F(1)$.
   - $F(2) = (2)^3 - (2)^2 + 2 = 8 - 4 + 2 = 6$.
   - $F(1) = (1)^3 - (1)^2 + 1 = 1 - 1 + 1 = 1$.

3. **Calculer la différence** :
   $\int_1^2 (3x^2 - 2x + 1) dx = F(2) - F(1) = 6 - 1 = 5$.

L''intégrale est donc égale à $5$.', '["Commence par trouver une primitive de la fonction $f(x) = 3x^2 - 2x + 1$.","Rappelle-toi que $\\int_a^b f(x) dx = [F(x)]_a^b = F(b) - F(a)$, où $F$ est une primitive de $f$."]'::jsonb, '2025-12-19T21:18:35.698457+00:00'::timestamptz, '885ec61984e9cdaecc0159768ca0d9c9916098817e5ec3faef22666586c0e9c1', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('6ed3c037-26fb-4da2-8257-234cfccb937f', 'Exercice', 'Terminale', '{"contexte":"exercice avec toutes les étapes détaillées. Tu as vu ça en cours récemment, donc c''est l''occasion de bien fixer la méthode.\n**Pour calculer l''intégrale $\\\\int_1^2 (3x^2 - 2x + 1) dx$ :**","questions":["**Trouver une primitive $F(x)$ de la fonction $f(x) = 3x^2 - 2x + 1$**","**Évaluer la primitive aux bornes de l''intégrale**","**Calculer la différence $F(b) - F(a)$**"]}', 'À résoudre', '[]'::jsonb, '2025-12-19T21:21:30.591379+00:00'::timestamptz, 'e0489d8496ff2415445e29a896fb39f416c1074ca9b7c357f8d3942f3739abcf', NULL),
('d6ccbaa7-a7cc-4548-bf2e-bd8e34b9d39f', 'Dérivation et étude de fonctions', 'terminale', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}$.","Dresse le tableau de variations complet de la fonction $f$ sur $\\mathbb{R}$ (tu ne calculeras pas les limites aux bornes pour cette fois).","Détermine l''équation de la tangente à la courbe $\\mathcal{C}_f$ au point d''abscisse $x=1$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x - 3)e^{-x+1}$. On note $\\mathcal{C}_f$ sa courbe représentative dans un repère orthogonal."}', '1. Calcul de la dérivée $f''(x)$ :
La fonction $f$ est de la forme $u(x)v(x)$ avec $u(x) = 2x - 3$ et $v(x) = e^{-x+1}$.
On a $u''(x) = 2$ et $v''(x) = -e^{-x+1}$.
Donc $f''(x) = u''(x)v(x) + u(x)v''(x) = 2e^{-x+1} + (2x - 3)(-e^{-x+1})$
$f''(x) = e^{-x+1}(2 - (2x - 3)) = e^{-x+1}(2 - 2x + 3) = e^{-x+1}(-2x + 5)$.

2. Étude du signe de $f''(x)$ :
Comme $e^{-x+1} > 0$ pour tout $x \in \mathbb{R}$, le signe de $f''(x)$ est celui de $(-2x + 5)$.
$-2x + 5 > 0 \iff -2x > -5 \iff x < \frac{5}{2}$
$-2x + 5 < 0 \iff -2x < -5 \iff x > \frac{5}{2}$
$-2x + 5 = 0 \iff x = \frac{5}{2}$

3. Tableau de variations de $f$ :
$f(\frac{5}{2}) = (2 \times \frac{5}{2} - 3)e^{-\frac{5}{2}+1} = (5 - 3)e^{-\frac{3}{2}} = 2e^{-\frac{3}{2}}$.

| $x$ | $-\infty$ | | $\frac{5}{2}$ | | $+\infty$ |
|---|---|---|---|---|---|
| Signe de $f''(x)$ | | $+$ | $0$ | $-$ | |
| Variations de $f$ | | $\nearrow$ | $2e^{-\frac{3}{2}}$ | $\searrow$ | |

4. Équation de la tangente à $\mathcal{C}_f$ au point d''abscisse $x=1$ :
$f(1) = (2 \times 1 - 3)e^{-1+1} = (2 - 3)e^0 = -1 \times 1 = -1$.
$f''(1) = e^{-1+1}(-2 \times 1 + 5) = e^0(-2 + 5) = 1 \times 3 = 3$.
L''équation de la tangente est $y = f''(1)(x-1) + f(1)$.
$y = 3(x-1) - 1$
$y = 3x - 3 - 1$
$y = 3x - 4$.', '["Pour la dérivée, pense à la formule de dérivation d''un produit $(uv)'' = u''v + uv''$.","Pour le signe de $f''(x)$, n''oublie pas que $e^X$ est toujours strictement positif.","L''équation de la tangente au point d''abscisse $a$ est $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-12-19T21:44:36.595995+00:00'::timestamptz, 'dde731c0d44ea6b1c5816b31d05c4e6c4907a6f11b31ad4220a75537b46a548d', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('031a5dbe-0542-4b8e-bce3-5898ce22d08c', 'Dérivation et étude de fonctions', 'terminale', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}$.","Dresse le tableau de variations complet de la fonction $f$.","Détermine l''équation de la tangente à la courbe $C_f$ au point d''abscisse $x=0$.","Calcule les limites de $f(x)$ en $+\\infty$ et en $-\\infty$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x^2 + 2x + 3)e^{-x}$. On note $C_f$ sa courbe représentative dans un repère orthogonal."}', '1. Calcul de la dérivée $f''(x)$ :
Soit $f(x) = (x^2 + 2x + 3)e^{-x}$.
On utilise la formule $(uv)'' = u''v + uv''$ avec $u(x) = x^2 + 2x + 3$ et $v(x) = e^{-x}$.
Alors $u''(x) = 2x + 2$ et $v''(x) = -e^{-x}$.
$f''(x) = (2x + 2)e^{-x} + (x^2 + 2x + 3)(-e^{-x})$
$f''(x) = e^{-x} [(2x + 2) - (x^2 + 2x + 3)]$
$f''(x) = e^{-x} [2x + 2 - x^2 - 2x - 3]$
$f''(x) = e^{-x} (-x^2 - 1)$
$f''(x) = -(x^2 + 1)e^{-x}$

2. Étude du signe de $f''(x)$ sur $\mathbb{R}$ :
Pour tout $x \in \mathbb{R}$, $e^{-x} > 0$. 
De plus, $x^2 \ge 0$, donc $x^2 + 1 \ge 1 > 0$.
Par conséquent, $-(x^2 + 1) < 0$ pour tout $x \in \mathbb{R}$.
Ainsi, $f''(x) = -(x^2 + 1)e^{-x} < 0$ pour tout $x \in \mathbb{R}$.

3. Tableau de variations complet de la fonction $f$ :
Comme $f''(x) < 0$ sur $\mathbb{R}$, la fonction $f$ est strictement décroissante sur $\mathbb{R}$.

4. Équation de la tangente à la courbe $C_f$ au point d''abscisse $x=0$ :
L''équation de la tangente est $y = f''(0)(x-0) + f(0)$.
$f(0) = (0^2 + 2(0) + 3)e^{-0} = (3)(1) = 3$.
$f''(0) = -(0^2 + 1)e^{-0} = -(1)(1) = -1$.
Donc, $y = -1(x - 0) + 3$
$y = -x + 3$.

5. Calcul des limites de $f(x)$ en $+\infty$ et en $-\infty$ :
En $+\infty$ :
$\lim_{x \to +\infty} (x^2 + 2x + 3) = +\infty$
$\lim_{x \to +\infty} e^{-x} = 0$
C''est une forme indéterminée de type $$\infty \times 0$$. On utilise les croissances comparées.
On sait que $\lim_{x \to +\infty} x^n e^{-x} = 0$ pour tout $n \in \mathbb{N}$.
$f(x) = x^2 e^{-x} + 2x e^{-x} + 3e^{-x}$.
Par croissances comparées, $\lim_{x \to +\infty} x^2 e^{-x} = 0$, $\lim_{x \to +\infty} 2x e^{-x} = 0$, et $\lim_{x \to +\infty} 3e^{-x} = 0$.
Donc $\lim_{x \to +\infty} f(x) = 0$.

En $-\infty$ :
$\lim_{x \to -\infty} (x^2 + 2x + 3) = +\infty$ (car le terme de plus haut degré est $x^2$)
$\lim_{x \to -\infty} e^{-x} = +\infty$ (car $-x \to +\infty$)
Donc $\lim_{x \to -\infty} f(x) = (+\infty) \times (+\infty) = +\infty$.', '["Pour la dérivée, pense à la formule de dérivation d''un produit : $(uv)'' = u''v + uv''$.","N''oublie pas que la dérivée de $e^{-x}$ est $-e^{-x}$.","Pour le signe de $f''(x)$, souviens-toi que $e^{-x}$ est toujours positif.","Pour les limites, en $+\\infty$, tu pourrais avoir une forme indéterminée de type \"$\\infty \\times 0$\", pense aux croissances comparées. En $-\\infty$, c''est plus direct.","L''équation de la tangente au point d''abscisse $a$ est $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-12-19T21:44:38.133579+00:00'::timestamptz, 'a4c481749464a2c43482cbcaf58d14f41b6b5a6d73d90280c26071c3ee6f1b77', NULL),
('7d5c0736-34fd-42b9-9528-352f18d87f67', 'Dérivation et étude de fonctions', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x^2 + 2x - 1)e^{-x}$. On note $\\mathcal{C}_f$ sa courbe représentative dans un repère orthogonal.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ et dresse le tableau de variations de $f$.","Détermine l''équation de la tangente à la courbe $\\mathcal{C}_f$ au point d''abscisse $x=0$.","Calcule les limites de $f(x)$ en $-\\infty$ et en $+\\infty$.","Démontre que l''équation $f(x) = 0$ admet une unique solution $\\alpha$ sur l''intervalle $[0, 1]$. Donne une valeur approchée de $\\alpha$ à $10^{-2}$ près."]}', '1. Calcul de la dérivée $f''(x)$ :
Soit $u(x) = x^2 + 2x - 1$ et $v(x) = e^{-x}$.
Alors $u''(x) = 2x + 2$ et $v''(x) = -e^{-x}$.
En utilisant la formule $(uv)'' = u''v + uv''$ :
$f''(x) = (2x + 2)e^{-x} + (x^2 + 2x - 1)(-e^{-x})$
$f''(x) = e^{-x}[(2x + 2) - (x^2 + 2x - 1)]$
$f''(x) = e^{-x}(-x^2 + 3)$

2. Étude du signe de $f''(x)$ et tableau de variations :
Le signe de $f''(x)$ est celui de $-x^2 + 3$ car $e^{-x} > 0$ pour tout $x \in \mathbb{R}$.
On cherche les racines de $-x^2 + 3 = 0 \iff x^2 = 3 \iff x = \sqrt{3}$ ou $x = -\sqrt{3}$.
Le trinôme $-x^2 + 3$ est une parabole ouverte vers le bas, donc il est positif entre ses racines.
$f''(x) > 0$ sur $]-\sqrt{3}; \sqrt{3}[$
$f''(x) < 0$ sur $]-\infty; -\sqrt{3}[ \cup ]\sqrt{3}; +\infty[$

Tableau de variations :
$x$         $|-\infty$     $-\sqrt{3}$     $\sqrt{3}$     $+\infty|$
$f''(x)$    $|-$           $0$     $+$     $0$     $-|$
$f(x)$      $|\searrow$    $f(-\sqrt{3})$    $\nearrow$    $f(\sqrt{3})$    $\searrow|$

$f(-\sqrt{3}) = ((- \sqrt{3})^2 + 2(-\sqrt{3}) - 1)e^{-(-\sqrt{3})} = (3 - 2\sqrt{3} - 1)e^{\sqrt{3}} = (2 - 2\sqrt{3})e^{\sqrt{3}}$
$f(\sqrt{3}) = ((\sqrt{3})^2 + 2(\sqrt{3}) - 1)e^{-\sqrt{3}} = (3 + 2\sqrt{3} - 1)e^{-\sqrt{3}} = (2 + 2\sqrt{3})e^{-\sqrt{3}}$

3. Équation de la tangente à la courbe $\mathcal{C}_f$ au point d''abscisse $x=0$ :
L''équation de la tangente est $y = f''(0)(x - 0) + f(0)$.
$f(0) = (0^2 + 2(0) - 1)e^{-0} = -1 \times 1 = -1$.
$f''(0) = e^{-0}(-0^2 + 3) = 1 \times 3 = 3$.
Donc $y = 3(x - 0) + (-1) \implies y = 3x - 1$.

4. Limites de $f(x)$ en $-\infty$ et en $+\infty$ :
En $-\infty$ :
$\lim_{x \to -\infty} (x^2 + 2x - 1) = +\infty$
$\lim_{x \to -\infty} e^{-x} = +\infty$
Donc $\lim_{x \to -\infty} f(x) = +\infty$.

En $+\infty$ :
$f(x) = \frac{x^2 + 2x - 1}{e^x} = \frac{x^2}{e^x} + \frac{2x}{e^x} - \frac{1}{e^x}$.
Par croissances comparées, $\lim_{x \to +\infty} \frac{x^2}{e^x} = 0$ et $\lim_{x \to +\infty} \frac{2x}{e^x} = 0$.
Et $\lim_{x \to +\infty} \frac{1}{e^x} = 0$.
Donc $\lim_{x \to +\infty} f(x) = 0$.

5. Démonstration que l''équation $f(x) = 0$ admet une unique solution $\alpha$ sur l''intervalle $[0, 1]$ :
Sur l''intervalle $[0, 1]$, la fonction $f$ est continue et strictement croissante (car $0 \in ]-\sqrt{3}; \sqrt{3}[$).
$f(0) = -1$.
$f(1) = (1^2 + 2(1) - 1)e^{-1} = (1 + 2 - 1)e^{-1} = 2e^{-1} = \frac{2}{e} \approx 0.736$.
Comme $f(0) < 0$ et $f(1) > 0$, et que $f$ est continue et strictement croissante sur $[0, 1]$, d''après le théorème des valeurs intermédiaires, l''équation $f(x) = 0$ admet une unique solution $\alpha$ sur l''intervalle $[0, 1]$.

Pour une valeur approchée à $10^{-2}$ près, on peut utiliser la calculatrice ou une méthode de dichotomie :
$f(0.5) = (0.25 + 1 - 1)e^{-0.5} = 0.25e^{-0.5} \approx 0.15$
$f(0.4) = (0.16 + 0.8 - 1)e^{-0.4} = -0.04e^{-0.4} \approx -0.026$
Donc $\alpha \in [0.4, 0.5]$.
$f(0.45) = (0.45^2 + 2(0.45) - 1)e^{-0.45} = (0.2025 + 0.9 - 1)e^{-0.45} = 0.1025e^{-0.45} \approx 0.065$
$f(0.43) \approx 0.02$
$f(0.42) \approx -0.003$
Donc $\alpha \approx 0.42$ à $10^{-2}$ près.', '["Pour la dérivée, pense à la formule de dérivation d''un produit : $(uv)'' = u''v + uv''$.","Pour les limites en l''infini, n''oublie pas les croissances comparées.","Pour prouver l''existence et l''unicité d''une solution, utilise le théorème des valeurs intermédiaires."]'::jsonb, '2025-12-19T21:44:39.22015+00:00'::timestamptz, 'c6426e83629a1f5e2e178b5d09407f08c4fc9e511c178344b979786b037d08ca', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('6230ff9a-b1ba-4ceb-aecf-7b9923d5c244', 'Dérivation et étude de fonctions', 'terminale', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}$.","Dresse le tableau de variations complet de la fonction $f$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x^2 - 3x + 1)e^x$."}', '1. Calcul de la dérivée $f''(x)$ :
La fonction $f$ est de la forme $uv$ avec $u(x) = x^2 - 3x + 1$ et $v(x) = e^x$.
On a $u''(x) = 2x - 3$ et $v''(x) = e^x$.
Donc $f''(x) = u''(x)v(x) + u(x)v''(x) = (2x - 3)e^x + (x^2 - 3x + 1)e^x$.
En factorisant par $e^x$, on obtient $f''(x) = (2x - 3 + x^2 - 3x + 1)e^x = (x^2 - x - 2)e^x$.

2. Étude du signe de $f''(x)$ :
Comme $e^x > 0$ pour tout $x \in \mathbb{R}$, le signe de $f''(x)$ est celui de $x^2 - x - 2$.
Calculons les racines du trinôme $x^2 - x - 2$ :
Le discriminant est $\Delta = (-1)^2 - 4(1)(-2) = 1 + 8 = 9$.
Les racines sont $x_1 = \frac{-(-1) - \sqrt{9}}{2(1)} = \frac{1 - 3}{2} = -1$ et $x_2 = \frac{-(-1) + \sqrt{9}}{2(1)} = \frac{1 + 3}{2} = 2$.
Le trinôme $x^2 - x - 2$ est positif à l''extérieur des racines et négatif entre les racines.
Donc :
- $f''(x) > 0$ pour $x \in ]-\infty; -1[ \cup ]2; +\infty[$
- $f''(x) < 0$ pour $x \in ]-1; 2[$
- $f''(x) = 0$ pour $x = -1$ ou $x = 2$

3. Tableau de variations de $f$ :

| $x$         | $-\infty$ |       $-1$       |        $2$        | $+\infty$ |
|-------------|-----------|------------------|-------------------|------------|
| $f''(x)$    |     $+$   |        $0$       |         $0$       |      $+$   |
| Variations  |           | $f(-1) = 5e^{-1}$|                   |            |
| de $f$      | $\nearrow$ |                  | $f(2) = -e^2$     | $\nearrow$|
|             |           |                  |                   |            |

Calcul des valeurs aux points critiques :
$f(-1) = ((-1)^2 - 3(-1) + 1)e^{-1} = (1 + 3 + 1)e^{-1} = 5e^{-1}$
$f(2) = (2^2 - 3(2) + 1)e^2 = (4 - 6 + 1)e^2 = -e^2$

Limites aux bornes :
$\lim_{x \to +\infty} (x^2 - 3x + 1)e^x = +\infty$ (produit de $+\infty$ par $+\infty$)
$\lim_{x \to -\infty} (x^2 - 3x + 1)e^x$
On peut écrire $f(x) = x^2e^x - 3xe^x + e^x$.
On sait que $\lim_{x \to -\infty} x^2e^x = 0$ et $\lim_{x \to -\infty} xe^x = 0$ (croissances comparées).
Donc $\lim_{x \to -\infty} f(x) = 0 - 0 + 0 = 0$.', '["Pense à la formule de dérivation d''un produit de fonctions : $(uv)'' = u''v + uv''$.","Pour le signe de $f''(x)$, n''oublie pas que $e^x$ est toujours positif.","Factorise l''expression de $f''(x)$ pour faciliter l''étude de son signe."]'::jsonb, '2025-12-19T21:44:41.572459+00:00'::timestamptz, '0df6ed22fc8f9ceb4c820092d291099bc140af678cd90162fc17c61865660daf', NULL),
('283e3d5f-7b55-447d-97bd-e2f8e8f29056', 'Dérivation et étude de fonctions', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x - 3)e^{-x+1}$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}$.","Déduis-en le tableau de variations de la fonction $f$."]}', '1. Calcul de la dérivée $f''(x)$ :
Soit $f(x) = (2x - 3)e^{-x+1}$.
On pose $u(x) = 2x - 3$ et $v(x) = e^{-x+1}$.
Alors $u''(x) = 2$ et $v''(x) = -e^{-x+1}$.
En utilisant la formule $(uv)'' = u''v + uv''$ :
$f''(x) = 2e^{-x+1} + (2x - 3)(-e^{-x+1})$
$f''(x) = e^{-x+1}(2 - (2x - 3))$
$f''(x) = e^{-x+1}(2 - 2x + 3)$
$f''(x) = e^{-x+1}(5 - 2x)$

2. Étude du signe de $f''(x)$ :
Le terme $e^{-x+1}$ est toujours strictement positif sur $\mathbb{R}$.
Le signe de $f''(x)$ est donc le même que le signe de $(5 - 2x)$.
$5 - 2x > 0 \iff 5 > 2x \iff x < \frac{5}{2}$
$5 - 2x < 0 \iff 5 < 2x \iff x > \frac{5}{2}$
$5 - 2x = 0 \iff x = \frac{5}{2}$

3. Tableau de variations de $f$ :

| $x$             | $-\infty$ |              $\frac{5}{2}$              | $+\infty$ |
|-----------------|-----------|-----------------------------------------|-----------|
| Signe de $5-2x$ | $+$       | $0$                                     | $-$       |
| Signe de $f''(x)$ | $+$       | $0$                                     | $-$       |
| Variations de $f$ | Croissante| $f(\frac{5}{2})$ (Maximum) | Décroissante|

Calcul de $f(\frac{5}{2})$ :
$f(\frac{5}{2}) = (2 \times \frac{5}{2} - 3)e^{-\frac{5}{2}+1}$
$f(\frac{5}{2}) = (5 - 3)e^{-\frac{3}{2}}$
$f(\frac{5}{2}) = 2e^{-\frac{3}{2}}$', '["Rappelle-toi la formule de dérivation d''un produit de fonctions $(uv)'' = u''v + uv''$.","N''oublie pas la dérivée de $e^u$, c''est $u''e^u$.","Pour le signe de $f''(x)$, il faut étudier le signe de chaque facteur."]'::jsonb, '2025-12-19T21:44:43.725305+00:00'::timestamptz, 'fe746b277926aab532a39f4f394ba46ef3ab2e651d81d2422563118e4d3d84e8', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('2b18ecd2-5068-4da7-aaeb-4a5209a6622b', 'Dérivation et étude de fonctions', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x^2 - 3x + 1)e^{-x}$. On note $\\mathcal{C}_f$ sa courbe représentative dans un repère orthogonal.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $\\mathbb{R}$.","Dresse le tableau de variations complet de la fonction $f$.","Détermine l''équation de la tangente à la courbe $\\mathcal{C}_f$ au point d''abscisse $x=0$."]}', '1. Calcul de la dérivée $f''(x)$ :
La fonction $f$ est de la forme $uv$ avec $u(x) = 2x^2 - 3x + 1$ et $v(x) = e^{-x}$.
On a $u''(x) = 4x - 3$ et $v''(x) = -e^{-x}$.
Donc $f''(x) = u''(x)v(x) + u(x)v''(x) = (4x - 3)e^{-x} + (2x^2 - 3x + 1)(-e^{-x})$
$f''(x) = e^{-x} [ (4x - 3) - (2x^2 - 3x + 1) ]$
$f''(x) = e^{-x} [ 4x - 3 - 2x^2 + 3x - 1 ]$
$f''(x) = e^{-x} ( -2x^2 + 7x - 4 )$

2. Étude du signe de $f''(x)$ :
Comme $e^{-x} > 0$ pour tout $x \in \mathbb{R}$, le signe de $f''(x)$ est celui de $-2x^2 + 7x - 4$.
Calculons le discriminant $\Delta$ du trinôme $-2x^2 + 7x - 4$ :
$\Delta = b^2 - 4ac = 7^2 - 4(-2)(-4) = 49 - 32 = 17$.
Les racines sont $x_1 = \frac{-7 - \sqrt{17}}{2(-2)} = \frac{-7 - \sqrt{17}}{-4} = \frac{7 + \sqrt{17}}{4}$ et $x_2 = \frac{-7 + \sqrt{17}}{2(-2)} = \frac{-7 + \sqrt{17}}{-4} = \frac{7 - \sqrt{17}}{4}$.
Approximativement, $x_1 \approx \frac{7 + 4.12}{4} \approx 2.78$ et $x_2 \approx \frac{7 - 4.12}{4} \approx 0.72$.
Le trinôme $-2x^2 + 7x - 4$ est du signe de $-a$ (donc négatif) à l''extérieur des racines et du signe de $a$ (donc positif) entre les racines.
Donc, $f''(x) < 0$ sur $]-\infty; \frac{7 - \sqrt{17}}{4}[ \cup ]\frac{7 + \sqrt{17}}{4}; +\infty[$.
Et $f''(x) > 0$ sur $]\frac{7 - \sqrt{17}}{4}; \frac{7 + \sqrt{17}}{4}[$.
$f''(x) = 0$ pour $x = \frac{7 - \sqrt{17}}{4}$ et $x = \frac{7 + \sqrt{17}}{4}$.

3. Tableau de variations de $f$ :
$\lim_{x \to +\infty} (2x^2 - 3x + 1)e^{-x} = \lim_{x \to +\infty} \frac{2x^2 - 3x + 1}{e^x} = 0$ (par croissances comparées).
$\lim_{x \to -\infty} (2x^2 - 3x + 1)e^{-x} = +\infty$ car $\lim_{x \to -\infty} (2x^2 - 3x + 1) = +\infty$ et $\lim_{x \to -\infty} e^{-x} = +\infty$.

| $x$ | $-\infty$ | $x_2 = \frac{7 - \sqrt{17}}{4}$ | $x_1 = \frac{7 + \sqrt{17}}{4}$ | $+\infty$ |
|---|---|---|---|---|
| $f''(x)$ | $-$ | $0$ | $+$ | $0$ | $-$ |
| $f(x)$ | $+\infty$ | $\searrow$ | $f(x_2)$ | $\nearrow$ | $f(x_1)$ | $\searrow$ | $0$ |

4. Équation de la tangente à $\mathcal{C}_f$ au point d''abscisse $x=0$ :
L''équation de la tangente est $y = f''(0)(x-0) + f(0)$.
$f(0) = (2(0)^2 - 3(0) + 1)e^{-0} = 1 \times 1 = 1$.
$f''(0) = e^{-0}(-2(0)^2 + 7(0) - 4) = 1 \times (-4) = -4$.
Donc l''équation de la tangente est $y = -4(x-0) + 1$, soit $y = -4x + 1$.', '["Pour calculer $f''(x)$, pense à utiliser la formule de dérivation d''un produit de fonctions $(uv)'' = u''v + uv''$.","N''oublie pas que la dérivée de $e^{-x}$ est $-e^{-x}$.","Pour l''étude du signe de $f''(x)$, factorise $e^{-x}$ et étudie le signe du polynôme restant.","Pour le tableau de variations, utilise les racines du polynôme pour délimiter les intervalles.","L''équation de la tangente en un point d''abscisse $a$ est donnée par $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-12-19T21:44:45.291715+00:00'::timestamptz, '0572e6dbd5d437d926ac3817eb4469a4df945ccc1b185228775c2980f10bf3d6', NULL),
('e132b03d-4a1e-479a-93e0-4dbf03cfbe1a', 'Vecteurs et géométrie plane', 'terminale', '{"questions":["Calcule les coordonnées du vecteur $\\vec{AB}$.","Calcule les coordonnées du vecteur $\\vec{BC}$.","Calcule les coordonnées du vecteur $\\vec{AC}$.","Détermine si les vecteurs $\\vec{AB}$ et $\\vec{BC}$ sont colinéaires. Justifie ta réponse."],"contexte":"Dans un repère orthonormé $(O; \\vec{i}, \\vec{j})$, on considère les points $A(1; 2)$, $B(4; 3)$ et $C(2; 5)$."}', '1. Coordonnées du vecteur $\vec{AB}$ :
$\vec{AB} = (x_B - x_A; y_B - y_A) = (4 - 1; 3 - 2) = (3; 1)$.

2. Coordonnées du vecteur $\vec{BC}$ :
$\vec{BC} = (x_C - x_B; y_C - y_B) = (2 - 4; 5 - 3) = (-2; 2)$.

3. Coordonnées du vecteur $\vec{AC}$ :
$\vec{AC} = (x_C - x_A; y_C - y_A) = (2 - 1; 5 - 2) = (1; 3)$.

4. Colinéarité des vecteurs $\vec{AB}$ et $\vec{BC}$ :
Pour déterminer si $\vec{AB}(3; 1)$ et $\vec{BC}(-2; 2)$ sont colinéaires, on calcule le déterminant $xy'' - yx''$ :
$3 \times 2 - 1 \times (-2) = 6 - (-2) = 6 + 2 = 8$.
Puisque $8 \neq 0$, les vecteurs $\vec{AB}$ et $\vec{BC}$ ne sont pas colinéaires. Les points A, B, C ne sont donc pas alignés.', '["Pour calculer les coordonnées d''un vecteur $\\vec{AB}$, utilise la formule $(x_B - x_A; y_B - y_A)$.","Deux vecteurs $\\vec{u}(x;y)$ et $\\vec{v}(x'';y'')$ sont colinéaires si et seulement si $xy'' - yx'' = 0$ (ou si l''un est un multiple de l''autre)."]'::jsonb, '2025-12-19T21:45:37.718666+00:00'::timestamptz, 'a3f39b7f9b88b0b78fd9a4fcfa348eb2a3a295ca6932cc152527fbe945b483ee', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('ba0073bc-39ce-4fd4-b587-82e803241fd4', 'Compléments sur la dérivation', 'terminale', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine la dérivée seconde $f''''(x)$ de la fonction $f$.","Étudie la convexité de la fonction $f$ sur $\\mathbb{R}$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x^2 + 1)e^{-x}$."}', '1. Calcul de la dérivée $f''(x)$ :
Soit $f(x) = (x^2 + 1)e^{-x}$.
On pose $u(x) = x^2 + 1$ et $v(x) = e^{-x}$.
Alors $u''(x) = 2x$ et $v''(x) = -e^{-x}$.
En utilisant la formule $(uv)'' = u''v + uv''$ :
$f''(x) = 2x \cdot e^{-x} + (x^2 + 1) \cdot (-e^{-x})$
$f''(x) = e^{-x}(2x - (x^2 + 1))$
$f''(x) = e^{-x}(-x^2 + 2x - 1)$
$f''(x) = -e^{-x}(x^2 - 2x + 1)$
$f''(x) = -e^{-x}(x-1)^2$

2. Calcul de la dérivée seconde $f''''(x)$ :
Soit $f''(x) = -e^{-x}(x-1)^2$.
On pose $u(x) = -e^{-x}$ et $v(x) = (x-1)^2$.
Alors $u''(x) = -(-e^{-x}) = e^{-x}$ et $v''(x) = 2(x-1)$.
En utilisant la formule $(uv)'' = u''v + uv''$ :
$f''''(x) = e^{-x}(x-1)^2 + (-e^{-x}) \cdot 2(x-1)$
$f''''(x) = e^{-x}(x-1)^2 - 2e^{-x}(x-1)$
$f''''(x) = e^{-x}(x-1)[(x-1) - 2]$
$f''''(x) = e^{-x}(x-1)(x-3)$

3. Étude de la convexité de la fonction $f$ :
La convexité de $f$ est donnée par le signe de $f''''(x)$.
On a $f''''(x) = e^{-x}(x-1)(x-3)$.
Comme $e^{-x} > 0$ pour tout $x \in \mathbb{R}$, le signe de $f''''(x)$ dépend du signe de $(x-1)(x-3)$.
On cherche les racines de $(x-1)(x-3) = 0$, qui sont $x=1$ et $x=3$.

Tableau de signes de $f''''(x)$ :

| $x$             | $-\infty$ | $1$ | $3$ | $+\infty$ |
|-----------------|-----------|-----|-----|------------|
| $x-1$           | $-$       | $0$ | $+$ | $+$        |
| $x-3$           | $-$       | $-$ | $0$ | $+$        |
| $(x-1)(x-3)$    | $+$       | $0$ | $-$ | $0$ | $+$        |
| $f''''(x)$        | $+$       | $0$ | $-$ | $0$ | $+$        |

- Sur $]-\infty; 1[$, $f''''(x) > 0$, donc $f$ est convexe.
- Sur $]1; 3[$, $f''''(x) < 0$, donc $f$ est concave.
- Sur $]3; +\infty[$, $f''''(x) > 0$, donc $f$ est convexe.

Les points d''inflexion sont en $x=1$ et $x=3$.', '["Pour $f''(x)$, pense à la formule de dérivation d''un produit $(uv)'' = u''v + uv''$.","Pour $f''''(x)$, tu devras dériver $f''(x)$ qui est aussi un produit de fonctions. N''oublie pas la dérivée de $e^{-x}$ qui est $-e^{-x}$.","La convexité est liée au signe de la dérivée seconde $f''''(x)$. Si $f''''(x) > 0$, la fonction est convexe. Si $f''''(x) < 0$, elle est concave."]'::jsonb, '2025-12-19T22:38:45.95798+00:00'::timestamptz, '9ba1bec145f6acc5b16c87683c64dad90a7c98800b2e625b424e6127b53901a8', NULL),
('2a056a92-affb-4b35-a7e2-e37eb24b9ccf', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x^2 - 4x + 5)e^{x}$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine la dérivée seconde $f''''(x)$ de la fonction $f$.","Étudie le signe de $f''''(x)$ sur $\\mathbb{R}$.","Déduis-en les intervalles sur lesquels la fonction $f$ est convexe ou concave."]}', '1. Calcul de la dérivée $f''(x)$ :
Soit $u(x) = x^2 - 4x + 5$ et $v(x) = e^x$.
Alors $u''(x) = 2x - 4$ et $v''(x) = e^x$.
$f''(x) = u''(x)v(x) + u(x)v''(x) = (2x - 4)e^x + (x^2 - 4x + 5)e^x = (2x - 4 + x^2 - 4x + 5)e^x = (x^2 - 2x + 1)e^x$.

2. Calcul de la dérivée seconde $f''''(x)$ :
Soit $u(x) = x^2 - 2x + 1$ et $v(x) = e^x$.
Alors $u''(x) = 2x - 2$ et $v''(x) = e^x$.
$f''''(x) = u''(x)v(x) + u(x)v''(x) = (2x - 2)e^x + (x^2 - 2x + 1)e^x = (2x - 2 + x^2 - 2x + 1)e^x = (x^2 - 1)e^x$.

3. Étude du signe de $f''''(x)$ :
On a $f''''(x) = (x^2 - 1)e^x$. Comme $e^x > 0$ pour tout $x \in \mathbb{R}$, le signe de $f''''(x)$ est celui de $x^2 - 1$.
$x^2 - 1 = 0 \iff x^2 = 1 \iff x = 1$ ou $x = -1$.
Le trinôme $x^2 - 1$ est positif à l''extérieur de ses racines et négatif entre ses racines.
Donc $x^2 - 1 > 0$ pour $x \in ]-\infty; -1[ \cup ]1; +\infty[$.
Et $x^2 - 1 < 0$ pour $x \in ]-1; 1[$.

4. Déduction des intervalles de convexité et concavité :
- Sur $]-\infty; -1[$ et $]1; +\infty[$, $f''''(x) > 0$, donc $f$ est convexe.
- Sur $]-1; 1[$, $f''''(x) < 0$, donc $f$ est concave.
- Les points d''abscisse $x = -1$ et $x = 1$ sont des points d''inflexion.', '["Pour calculer $f''(x)$, utilise la formule de dérivation d''un produit $(uv)'' = u''v + uv''$.","Pour $f''''(x)$, applique la même formule de dérivation d''un produit à $f''(x)$.","Pour étudier le signe de $f''''(x)$, rappelle-toi que $e^x > 0$ pour tout $x \\in \\mathbb{R}$.","La convexité est liée au signe de la dérivée seconde."]'::jsonb, '2025-12-20T08:53:00.836748+00:00'::timestamptz, 'c47ff90d6ba72d54c22230b23d0604babbc3926b67be92aed70fa6a021c31e37', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('3d3a52d8-70a3-4d3e-b8ea-f4021e44e93b', 'Suites numériques', 'terminale', '{"questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$. Donne les valeurs exactes puis des valeurs approchées à $10^{-2}$ près.","Démontre par récurrence que pour tout entier naturel $n$, $0 \\le U_n \\le 3$.","Démontre que la suite $(U_n)$ est croissante. Tu pourras étudier le signe de $U_{n+1} - U_n$ en factorisant par $U_n - 3$ ou en utilisant la quantité conjuguée.","Que peux-tu en déduire quant à la convergence de la suite $(U_n)$ ? Justifie ta réponse."],"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 1$ et, pour tout entier naturel $n$, $U_{n+1} = \\sqrt{2U_n + 3}$."}', '1. Calcul des premiers termes :
$U_0 = 1$
$U_1 = \sqrt{2U_0 + 3} = \sqrt{2(1) + 3} = \sqrt{5} \approx 2,24$
$U_2 = \sqrt{2U_1 + 3} = \sqrt{2\sqrt{5} + 3} \approx \sqrt{2(2,236) + 3} = \sqrt{4,472 + 3} = \sqrt{7,472} \approx 2,73$
$U_3 = \sqrt{2U_2 + 3} = \sqrt{2\sqrt{2\sqrt{5} + 3} + 3} \approx \sqrt{2(2,734) + 3} = \sqrt{5,468 + 3} = \sqrt{8,468} \approx 2,91$

2. Démontrons par récurrence que pour tout entier naturel $n$, $0 \le U_n \le 3$.
   *   Initialisation : Pour $n=0$, $U_0 = 1$. On a bien $0 \le 1 \le 3$. La propriété est vraie pour $n=0$.
   *   Hérédité : Supposons que pour un entier $k \ge 0$, la propriété $0 \le U_k \le 3$ est vraie. Démontrons que $0 \le U_{k+1} \le 3$.
       Puisque $0 \le U_k \le 3$, on a :
       $2(0) \le 2U_k \le 2(3)$
       $0 \le 2U_k \le 6$
       $0+3 \le 2U_k + 3 \le 6+3$
       $3 \le 2U_k + 3 \le 9$
       En prenant la racine carrée (la fonction racine carrée est croissante sur $[0, +\infty[$) :
       $\sqrt{3} \le \sqrt{2U_k + 3} \le \sqrt{9}$
       $\sqrt{3} \le U_{k+1} \le 3$
       Comme $\sqrt{3} \approx 1,732$, on a bien $0 \le \sqrt{3} \le U_{k+1} \le 3$. La propriété est donc vraie pour $k+1$.
   *   Conclusion : D''après le principe de récurrence, pour tout entier naturel $n$, $0 \le U_n \le 3$.

3. Démontrons que la suite $(U_n)$ est croissante.
   Étudions le signe de $U_{n+1} - U_n$ :
   $U_{n+1} - U_n = \sqrt{2U_n + 3} - U_n$
   Multiplions par la quantité conjuguée :
   $U_{n+1} - U_n = (\sqrt{2U_n + 3} - U_n) \times \frac{\sqrt{2U_n + 3} + U_n}{\sqrt{2U_n + 3} + U_n}$
   $U_{n+1} - U_n = \frac{(2U_n + 3) - U_n^2}{\sqrt{2U_n + 3} + U_n}$
   $U_{n+1} - U_n = \frac{-U_n^2 + 2U_n + 3}{\sqrt{2U_n + 3} + U_n}$
   Le dénominateur $\sqrt{2U_n + 3} + U_n$ est toujours positif (car $U_n \ge 0$).
   Il faut donc étudier le signe du numérateur $-U_n^2 + 2U_n + 3$.
   Cherchons les racines du trinôme $-x^2 + 2x + 3 = 0$.
   Le discriminant $\Delta = b^2 - 4ac = 2^2 - 4(-1)(3) = 4 + 12 = 16$.
   Les racines sont $x_1 = \frac{-2 - \sqrt{16}}{2(-1)} = \frac{-2 - 4}{-2} = \frac{-6}{-2} = 3$ et $x_2 = \frac{-2 + \sqrt{16}}{2(-1)} = \frac{-2 + 4}{-2} = \frac{2}{-2} = -1$.
   Le trinôme $-x^2 + 2x + 3$ est une parabole tournée vers le bas (coefficient de $x^2$ négatif). Il est positif entre ses racines $-1$ et $3$.
   On a démontré à la question précédente que $0 \le U_n \le 3$. Donc $U_n$ est dans l''intervalle $[-1, 3]$ (plus précisément $[0,3]$).
   Sur cet intervalle, $-U_n^2 + 2U_n + 3 \ge 0$.
   Par conséquent, $U_{n+1} - U_n \ge 0$. La suite $(U_n)$ est croissante.

4. Que peux-tu en déduire quant à la convergence de la suite $(U_n)$ ?
   La suite $(U_n)$ est croissante (démontré en question 3) et majorée par 3 (démontré en question 2).
   D''après le théorème de convergence des suites monotones et bornées, toute suite croissante et majorée converge.
   Donc la suite $(U_n)$ converge.', '["Pour la question 2, n''oublie pas l''initialisation et l''hérédité. Pour l''hérédité, pars de l''hypothèse $0 \\le U_k \\le 3$ et essaie d''encadrer $U_{k+1}$.","Pour la question 3, étudie le signe de $U_{n+1} - U_n$. Tu peux écrire $U_{n+1} - U_n = \\sqrt{2U_n + 3} - U_n$. Multiplie par la quantité conjuguée $(\\sqrt{2U_n + 3} + U_n)$ pour simplifier l''expression.","Pour la question 4, rappelle-toi le théorème de convergence des suites monotones et bornées."]'::jsonb, '2025-12-20T17:43:30.179746+00:00'::timestamptz, '88b562575d5e91720aa9417613519e32367ccbdd0dce797ce2b0131dd9d9c248', NULL),
('97c192eb-08c3-4be4-8620-cc5fbb97f805', 'Calcul intégral', 'terminale', '{"contexte":"Soit $f$ la fonction définie sur $\\mathbb{R}$ par $f(x) = x^2 e^{-x}$. On souhaite calculer l''intégrale $I = \\int_0^1 x^2 e^{-x} dx$.","questions":["Calcule l''intégrale $I$ en utilisant une intégration par parties. Tu devras probablement l''appliquer deux fois.","Donne la valeur exacte de $I$ puis une valeur approchée à $10^{-2}$ près."]}', 'On souhaite calculer $I = \int_0^1 x^2 e^{-x} dx$.

Première intégration par parties :
On pose :
$u(x) = x^2 \implies u''(x) = 2x$
$v''(x) = e^{-x} \implies v(x) = -e^{-x}$

Alors :
$I = [-x^2 e^{-x}]_0^1 - \int_0^1 (2x)(-e^{-x}) dx$
$I = (-1^2 e^{-1} - 0) + 2 \int_0^1 x e^{-x} dx$
$I = -e^{-1} + 2 J$, où $J = \int_0^1 x e^{-x} dx$

Deuxième intégration par parties (pour $J$) :
On pose :
$u(x) = x \implies u''(x) = 1$
$v''(x) = e^{-x} \implies v(x) = -e^{-x}$

Alors :
$J = [-x e^{-x}]_0^1 - \int_0^1 (1)(-e^{-x}) dx$
$J = (-1 e^{-1} - 0) + \int_0^1 e^{-x} dx$
$J = -e^{-1} + [-e^{-x}]_0^1$
$J = -e^{-1} + (-e^{-1} - (-e^0))$
$J = -e^{-1} - e^{-1} + 1$
$J = 1 - 2e^{-1}$

Maintenant, on remplace $J$ dans l''expression de $I$ :
$I = -e^{-1} + 2 (1 - 2e^{-1})$
$I = -e^{-1} + 2 - 4e^{-1}$
$I = 2 - 5e^{-1}$

Valeur exacte de $I$: $2 - 5e^{-1}$
Valeur approchée à $10^{-2}$ près : $e^{-1} \approx 0.36788$
$I \approx 2 - 5 \times 0.36788 \approx 2 - 1.8394 \approx 0.1606$
Donc $I \approx 0.16$.', '["Pour la première intégration par parties, tu peux poser $u(x) = x^2$ et $v''(x) = e^{-x}$.","N''oublie pas de bien calculer $u''(x)$ et $v(x)$.","La deuxième intégration par parties se fera sur l''intégrale restante, en posant $u(x)$ comme le terme en $x$ et $v''(x)$ comme l''exponentielle.","La formule de l''intégration par parties est $\\int_a^b u(x)v''(x)dx = [u(x)v(x)]_a^b - \\int_a^b u''(x)v(x)dx$."]'::jsonb, '2025-12-20T17:50:27.347645+00:00'::timestamptz, '565d7d180b363d037462046c729d615af865882cb2a5ea1d8f1255a35cf73057', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('661d087f-222b-424d-bf78-ca9ff3f685fe', 'Calcul intégral', 'terminale', '{"contexte":"On considère l''intégrale $I = \\int_1^e x \\ln(x) dx$.","questions":["Calcule cette intégrale en utilisant la méthode d''intégration par parties.","Donne la valeur exacte de $I$."]}', 'Pour calculer l''intégrale $I = \int_1^e x \ln(x) dx$, nous allons utiliser l''intégration par parties.

Posons :
$v(x) = \ln(x) \implies v''(x) = \frac{1}{x}$
$u''(x) = x \implies u(x) = \frac{x^2}{2}$

En appliquant la formule d''intégration par parties $\int u''(x)v(x)dx = [u(x)v(x)] - \int u(x)v''(x)dx$ :
$I = \left[\frac{x^2}{2} \ln(x)\right]_1^e - \int_1^e \frac{x^2}{2} \cdot \frac{1}{x} dx$

Calculons la première partie :
$\left[\frac{x^2}{2} \ln(x)\right]_1^e = \left(\frac{e^2}{2} \ln(e)\right) - \left(\frac{1^2}{2} \ln(1)\right)$
Comme $\ln(e) = 1$ et $\ln(1) = 0$ :
$= \frac{e^2}{2} \cdot 1 - \frac{1}{2} \cdot 0 = \frac{e^2}{2}$

Calculons la deuxième partie :
$\int_1^e \frac{x^2}{2} \cdot \frac{1}{x} dx = \int_1^e \frac{x}{2} dx$
$= \left[\frac{x^2}{4}\right]_1^e$
$= \frac{e^2}{4} - \frac{1^2}{4} = \frac{e^2}{4} - \frac{1}{4}$

Maintenant, combinons les deux parties pour trouver $I$ :
$I = \frac{e^2}{2} - \left(\frac{e^2}{4} - \frac{1}{4}\right)$
$I = \frac{e^2}{2} - \frac{e^2}{4} + \frac{1}{4}$
$I = \frac{2e^2}{4} - \frac{e^2}{4} + \frac{1}{4}$
$I = \frac{e^2}{4} + \frac{1}{4}$
$I = \frac{e^2 + 1}{4}$', '["Rappelle-toi la formule d''intégration par parties : $\\int u''(x)v(x)dx = [u(x)v(x)] - \\int u(x)v''(x)dx$.","Pour choisir $u''(x)$ et $v(x)$, pense à la règle de l''ILATE (Inverse, Logarithme, Algébrique, Trigonométrique, Exponentielle) pour déterminer qui sera $v(x)$ (celle qui se dérive facilement) et qui sera $u''(x)$ (celle qui s''intègre facilement)."]'::jsonb, '2025-12-20T17:51:42.455915+00:00'::timestamptz, '827be7a27ea8d9dda7df688e70cd62edbe678720b3a5fc1874eb140fd8cd552a', NULL),
('f36f8dd9-c64f-47bf-bb14-d9dca976ea53', 'Calcul intégral', 'terminale', '{"questions":["Détermine une primitive $F$ de $f$ sur $\\mathbb{R}$ en utilisant l''intégration par parties.","Calcule la valeur exacte de l''intégrale $I = \\int_{-1}^0 f(x)dx$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x+3)e^{2x}$."}', '1. Détermination d''une primitive $F$ de $f$ sur $\mathbb{R}$ par intégration par parties :
Posons $u(x) = x+3$ et $v''(x) = e^{2x}$.
Alors $u''(x) = 1$ et $v(x) = \frac{1}{2}e^{2x}$.
En appliquant la formule de l''intégration par parties :
$\int (x+3)e^{2x}dx = (x+3)\frac{1}{2}e^{2x} - \int 1 \cdot \frac{1}{2}e^{2x}dx$
$= \frac{1}{2}(x+3)e^{2x} - \frac{1}{2}\int e^{2x}dx$
$= \frac{1}{2}(x+3)e^{2x} - \frac{1}{2} \left( \frac{1}{2}e^{2x} \right) + C$
$= \frac{1}{2}(x+3)e^{2x} - \frac{1}{4}e^{2x} + C$
$= e^{2x} \left( \frac{1}{2}(x+3) - \frac{1}{4} \right) + C$
$= e^{2x} \left( \frac{2x+6-1}{4} \right) + C$
$F(x) = \frac{1}{4}(2x+5)e^{2x} + C$

2. Calcul de l''intégrale $I = \int_{-1}^0 f(x)dx$ :
$I = \left[ \frac{1}{4}(2x+5)e^{2x} \right]_{-1}^0$
$I = \left( \frac{1}{4}(2(0)+5)e^{2(0)} \right) - \left( \frac{1}{4}(2(-1)+5)e^{2(-1)} \right)$
$I = \left( \frac{1}{4}(5)e^0 \right) - \left( \frac{1}{4}(3)e^{-2} \right)$
$I = \frac{5}{4} - \frac{3}{4}e^{-2}$
$I = \frac{5}{4} - \frac{3}{4e^2}$', '["Pour la première question, choisis $u(x) = x+3$ et $v''(x) = e^{2x}$.","N''oublie pas la formule de l''intégration par parties : $\\int u(x)v''(x)dx = u(x)v(x) - \\int u''(x)v(x)dx$.","Pour la deuxième question, applique le théorème fondamental de l''analyse : $I = F(0) - F(-1)$."]'::jsonb, '2025-12-20T20:20:23.306485+00:00'::timestamptz, '461b8f24409d61d872d4c77e37e747c58776f9fbd48a98063c8847d8075bc584', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('783eb1ce-8a1b-417c-9ae1-665910a86fd9', 'Géométrie dans l''espace et relation de Chasles', 'terminale', '{"contexte":"Dans un repère orthonormé de l''espace $(O; \\vec{i}, \\vec{j}, \\vec{k})$, on considère les points $A(1; 2; 3)$, $B(3; -1; 1)$ et $C(-1; 0; 5)$.","questions":["Détermine les coordonnées des vecteurs $\\overrightarrow{AB}$ et $\\overrightarrow{BC}$.","Calcule les longueurs $AB$ et $BC$.","Détermine les coordonnées du point $D$ tel que $ABCD$ soit un parallélogramme.","Calcule les coordonnées du milieu $I$ du segment $[AC]$. Explique pourquoi $I$ est aussi le milieu du segment $[BD]$.","Soit le point $E(x; y; z)$ tel que $\\overrightarrow{AE} = 2\\overrightarrow{AB} - \\overrightarrow{AC}$. Détermine les coordonnées du point $E$ en utilisant la relation de Chasles."]}', '1. Coordonnées des vecteurs :
$\overrightarrow{AB} = (3-1; -1-2; 1-3) = (2; -3; -2)$
$\overrightarrow{BC} = (-1-3; 0-(-1); 5-1) = (-4; 1; 4)$

2. Longueurs des segments :
$AB = \sqrt{2^2 + (-3)^2 + (-2)^2} = \sqrt{4 + 9 + 4} = \sqrt{17}$
$BC = \sqrt{(-4)^2 + 1^2 + 4^2} = \sqrt{16 + 1 + 16} = \sqrt{33}$

3. Coordonnées du point $D$ :
Pour que $ABCD$ soit un parallélogramme, $\overrightarrow{AB} = \overrightarrow{DC}$.
Soit $D(x_D; y_D; z_D)$. Alors $\overrightarrow{DC} = (-1-x_D; 0-y_D; 5-z_D)$.
On a donc :
$2 = -1-x_D \implies x_D = -3$
$-3 = -y_D \implies y_D = 3$
$-2 = 5-z_D \implies z_D = 7$
Donc $D(-3; 3; 7)$.

4. Coordonnées du milieu $I$ du segment $[AC]$ :
$I\left(\frac{1+(-1)}{2}; \frac{2+0}{2}; \frac{3+5}{2}\right) = I(0; 1; 4)$.
Si $ABCD$ est un parallélogramme, alors ses diagonales se coupent en leur milieu. Puisque $I$ est le milieu de $[AC]$, il est aussi le milieu de $[BD]$.

5. Coordonnées du point $E$ :
$\overrightarrow{AE} = 2\overrightarrow{AB} - \overrightarrow{AC}$
On a $\overrightarrow{AE} = (x_E-1; y_E-2; z_E-3)$.
$2\overrightarrow{AB} = 2(2; -3; -2) = (4; -6; -4)$.
$\overrightarrow{AC} = (-1-1; 0-2; 5-3) = (-2; -2; 2)$.
Donc $2\overrightarrow{AB} - \overrightarrow{AC} = (4 - (-2); -6 - (-2); -4 - 2) = (6; -4; -6)$.
En égalant les coordonnées :
$x_E-1 = 6 \implies x_E = 7$
$y_E-2 = -4 \implies y_E = -2$
$z_E-3 = -6 \implies z_E = -3$
Donc $E(7; -2; -3)$.', '["Pour les coordonnées d''un vecteur $\\overrightarrow{MN}$, il faut faire (coordonnées de N) - (coordonnées de M).","La longueur d''un segment $[MN]$ est donnée par la formule $\\sqrt{(x_N - x_M)^2 + (y_N - y_M)^2 + (z_N - z_M)^2}$.","Pour qu''un quadrilatère $ABCD$ soit un parallélogramme, il faut que $\\overrightarrow{AB} = \\overrightarrow{DC}$ ou $\\overrightarrow{AD} = \\overrightarrow{BC}$.","Le milieu d''un segment $[MN]$ a pour coordonnées $\\left(\\frac{x_M+x_N}{2}; \\frac{y_M+y_N}{2}; \\frac{z_M+z_N}{2}\\right)$.","Pour la relation de Chasles, tu peux décomposer les vecteurs en passant par un point intermédiaire, par exemple $\\overrightarrow{AE} = \\overrightarrow{AO} + \\overrightarrow{OE}$."]'::jsonb, '2025-12-20T21:12:09.566748+00:00'::timestamptz, '72192bb42b7f6696f6c8aa4db3ca744b1d8737cc3a728affa546d70e4388eef0', NULL),
('7b4edeae-7851-40b7-a9b9-89d40cfb7c6e', 'Exercice', 'terminale', '{"contexte":"","questions":["**$\\overrightarrow{AB} = \\overrightarrow{DC}$** : C''est la définition vectorielle la plus couramment utilisée","**$\\overrightarrow{AD} = \\overrightarrow{BC}$** : Une autre façon de l''exprimer, en utilisant les autres côtés","**Les diagonales se coupent en leur milieu** : Si $I$ est le milieu de $[AC]$ et $J$ est le milieu de $[BD]$, alors $I = J$","**Calcul des coordonnées de $\\overrightarrow{AB}$** :","**Calcul des coordonnées de $\\overrightarrow{DC}$** :","**Égalité des vecteurs** :"]}', 'À résoudre', '[]'::jsonb, '2025-12-20T21:12:52.663402+00:00'::timestamptz, 'dfc2b88a735536987df0fc627103945711aba4fc52e67c766fee75ce44e25f9a', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('61ea69b3-7ea7-4276-80f3-317c30fc18ea', 'Dérivation', 'premiere', '{"questions":["Détermine l''expression de la fonction dérivée $f''(x)$.","Étudie le signe de $f''(x)$ et déduis-en les variations de la fonction $f$.","Détermine l''équation de la tangente à la courbe $\\mathcal{C}_f$ au point d''abscisse $x_0 = 1$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = \\frac{x^2 - 3x + 1}{x}$. On note $\\mathcal{C}_f$ sa courbe représentative dans un repère orthogonal."}', '1. Détermination de $f''(x)$ :
On a $f(x) = \frac{x^2 - 3x + 1}{x}$. On peut écrire $f(x) = x - 3 + \frac{1}{x}$.
Alors $f''(x) = \frac{d}{dx}(x) - \frac{d}{dx}(3) + \frac{d}{dx}\left(\frac{1}{x}\right) = 1 - 0 - \frac{1}{x^2} = 1 - \frac{1}{x^2}$.
On peut aussi utiliser la formule du quotient avec $u(x) = x^2 - 3x + 1$ et $v(x) = x$.
$u''(x) = 2x - 3$ et $v''(x) = 1$.
$f''(x) = \frac{(2x - 3)x - (x^2 - 3x + 1)(1)}{x^2} = \frac{2x^2 - 3x - x^2 + 3x - 1}{x^2} = \frac{x^2 - 1}{x^2}$.

2. Étude du signe de $f''(x)$ et variations de $f$ :
$f''(x) = \frac{x^2 - 1}{x^2}$.
Le dénominateur $x^2$ est toujours positif sur $\mathbb{R}^*$.
Le signe de $f''(x)$ est donc celui de $x^2 - 1$.
$x^2 - 1 = 0 \implies x^2 = 1 \implies x = 1$ ou $x = -1$.
Tableau de signes :
| $x$             | $-\infty$ | $-1$    | $0$     | $1$     | $+\infty$ |
|-----------------|-----------|---------|---------|---------|------------|
| $x^2 - 1$       | $+$       | $0$     | $-$     | $0$     | $+$        |
| $x^2$           | $+$       | $+$     | $0$     | $+$     | $+$        |
| $f''(x)$         | $+$       | $0$     | $-$     | $0$     | $+$        |
| Variations de $f$ | Croissante| Maximum | Décroissante| Minimum | Croissante |

La fonction $f$ est croissante sur $]-\infty; -1]$ et sur $[1; +\infty[$.
La fonction $f$ est décroissante sur $[-1; 0[$ et sur $]0; 1]$.

3. Équation de la tangente à $\mathcal{C}_f$ au point d''abscisse $x_0 = 1$ :
On a $x_0 = 1$.
$f(x_0) = f(1) = \frac{1^2 - 3(1) + 1}{1} = \frac{1 - 3 + 1}{1} = -1$.
$f''(x_0) = f''(1) = \frac{1^2 - 1}{1^2} = \frac{0}{1} = 0$.
L''équation de la tangente est $y = f''(x_0)(x - x_0) + f(x_0)$.
$y = 0(x - 1) + (-1)$.
$y = -1$.', '["Pour la dérivée, pense à la formule de dérivation d''un quotient $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$.","Pour les variations, une fois que tu as $f''(x)$, il faut étudier son signe.","L''équation de la tangente en un point $x_0$ est donnée par $y = f''(x_0)(x - x_0) + f(x_0)$."]'::jsonb, '2025-12-20T21:30:42.282012+00:00'::timestamptz, '640df29555ba649b920fe34d69fe090966690190cd3fc9d583d41bf2c9bc7185', NULL),
('7620ba4d-f912-4f16-9ea9-21c256308a04', 'Calcul intégral', 'terminale', '{"questions":["Détermine la primitive $F$ de $f$ sur $\\mathbb{R}$ telle que $F(1) = 5$.","Vérifie ta réponse en calculant $F''(x)$ et $F(1)$.","Représente graphiquement la fonction $f$ et une primitive $F_0$ de $f$ s''annulant en $0$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = 3x^2 - 2x + 1$."}', '1. Pour trouver la primitive $F$ de $f(x) = 3x^2 - 2x + 1$, on intègre terme par terme :
$F(x) = \int (3x^2 - 2x + 1)dx = 3\frac{x^3}{3} - 2\frac{x^2}{2} + x + C = x^3 - x^2 + x + C$
On utilise la condition $F(1) = 5$ pour trouver $C$ :
$F(1) = 1^3 - 1^2 + 1 + C = 1 - 1 + 1 + C = 1 + C$
Comme $F(1) = 5$, on a $1 + C = 5$, donc $C = 4$.
La primitive est donc $F(x) = x^3 - x^2 + x + 4$.

2. Vérification :
Calcul de $F''(x)$ :
$F''(x) = \frac{d}{dx}(x^3 - x^2 + x + 4) = 3x^2 - 2x + 1$, ce qui correspond bien à $f(x)$.
Calcul de $F(1)$ :
$F(1) = 1^3 - 1^2 + 1 + 4 = 1 - 1 + 1 + 4 = 5$. La condition est bien respectée.

3. Représentation graphique :
La fonction $f(x) = 3x^2 - 2x + 1$ est une parabole (ouverte vers le haut). Son sommet est en $x = -(-2)/(2*3) = 2/6 = 1/3$.
La primitive $F_0$ s''annulant en $0$ est $F_0(x) = x^3 - x^2 + x$. Elle passe par l''origine $(0,0)$.
(Le graphique montrerait une parabole pour $f$ et une courbe cubique pour $F_0$, passant par l''origine et ayant des tangentes horizontales là où $f(x)=0$ si $f$ avait des racines réelles.)', '["Rappelle-toi que si $F$ est une primitive de $f$, alors $F(x) = \\int f(x)dx + C$, où $C$ est une constante.","Pour trouver la constante $C$, utilise la condition $F(1) = 5$.","Pour la représentation graphique, tu peux esquisser les courbes ou utiliser un outil graphique si tu le souhaites."]'::jsonb, '2025-12-20T21:52:00.61183+00:00'::timestamptz, '4630654bebde80ed628d9d5459ad08d4d0db1ca8467dfe659a2221db5fa0efa3', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('0791d098-a2d8-4e4f-a6a4-eb354e9c0de7', 'Exercice', 'terminale', '{"contexte":"","questions":["**Recherche de la forme générale de la primitive** :","**Détermination de la constante $C$** :","**Calcul de $F''(x)$** :","**Calcul de $F(1)$** :","**La fonction $f(x)$** :","**La primitive $F_0$ s''annulant en $0$** :","**Représentation graphique** :"]}', 'À résoudre', '[]'::jsonb, '2025-12-20T21:52:22.253505+00:00'::timestamptz, '75371aa0dea1248d709ee0272bcada8bb9dbb46d517ae50ad81feedcf97d037d', NULL),
('ea960aa6-4fdc-4938-a1ce-7eaa004213e1', 'Utiliser le calcul littéral', 'seconde', '{"contexte":"Résous l''équation suivante dans $\\mathbb{R}$ : $3x - 7 = 5x + 3$","questions":["Détaille toutes les étapes de ton calcul."]}', 'Pour résoudre l''équation $3x - 7 = 5x + 3$ :

1. Regroupe les termes en $x$ d''un côté et les constantes de l''autre.
   On peut soustraire $3x$ des deux côtés : 
   $3x - 7 - 3x = 5x + 3 - 3x$
   $-7 = 2x + 3$

2. Ensuite, soustrais $3$ des deux côtés :
   $-7 - 3 = 2x + 3 - 3$
   $-10 = 2x$

3. Enfin, divise par $2$ pour isoler $x$ :
   $\frac{-10}{2} = \frac{2x}{2}$
   $-5 = x$

La solution de l''équation est $x = -5$.', '["L''objectif est d''isoler $x$ d''un côté de l''équation. Commence par regrouper tous les termes en $x$ d''un côté et les nombres de l''autre.","Pour déplacer un terme d''un côté à l''autre de l''équation, tu dois effectuer l''opération inverse. Par exemple, si tu as $+7$ d''un côté, tu peux faire $-7$ des deux côtés.","Une fois que tu as $ax = b$, comment trouves-tu $x$ ?"]'::jsonb, '2025-12-20T22:16:28.002908+00:00'::timestamptz, '738676a4405e742397dab98818ab9452289b4afadd1f97a0db985fc9e581187a', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('cc9c4ca7-d4b5-4adb-b24e-fee9f3a50d0d', 'Suites numériques', 'premiere', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 5$ et, pour tout entier naturel $n$, $U_{n+1} = \\frac{1}{2}U_n + 3$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$.","On considère la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = U_n - 6$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$, puis déduis-en l''expression de $U_n$ en fonction de $n$.","Détermine la limite de la suite $(U_n)$ quand $n$ tend vers l''infini. Justifie ta réponse."]}', '1. Calcul des premiers termes :
$U_0 = 5$
$U_1 = \frac{1}{2}(5) + 3 = 2.5 + 3 = 5.5$
$U_2 = \frac{1}{2}(5.5) + 3 = 2.75 + 3 = 5.75$
$U_3 = \frac{1}{2}(5.75) + 3 = 2.875 + 3 = 5.875$

2. Démonstration que $(V_n)$ est une suite géométrique :
$V_n = U_n - 6 \implies U_n = V_n + 6$
$V_{n+1} = U_{n+1} - 6$
On remplace $U_{n+1}$ par son expression : $V_{n+1} = (\frac{1}{2}U_n + 3) - 6 = \frac{1}{2}U_n - 3$
On remplace $U_n$ par $V_n + 6$ : $V_{n+1} = \frac{1}{2}(V_n + 6) - 3 = \frac{1}{2}V_n + 3 - 3 = \frac{1}{2}V_n$
Donc, $(V_n)$ est une suite géométrique de raison $q = \frac{1}{2}$.
Son premier terme est $V_0 = U_0 - 6 = 5 - 6 = -1$.

3. Expression de $V_n$ et $U_n$ en fonction de $n$ :
Comme $(V_n)$ est géométrique, $V_n = V_0 \times q^n = -1 \times (\frac{1}{2})^n = -(\frac{1}{2})^n$.
On a $U_n = V_n + 6$, donc $U_n = -(\frac{1}{2})^n + 6$.

4. Limite de la suite $(U_n)$ :
La suite $(V_n)$ est une suite géométrique de raison $q = \frac{1}{2}$. Comme $-1 < \frac{1}{2} < 1$, la limite de $V_n$ quand $n \to +\infty$ est 0.
Par conséquent, $\lim_{n \to +\infty} U_n = \lim_{n \to +\infty} (-(\frac{1}{2})^n + 6) = 0 + 6 = 6$.', '["Pour calculer les premiers termes, utilise la relation de récurrence $U_{n+1} = \\frac{1}{2}U_n + 3$.","Pour montrer que $(V_n)$ est géométrique, exprime $V_{n+1}$ en fonction de $V_n$.","La limite d''une suite géométrique dépend de sa raison.","Pense à la propriété des limites pour les suites géométriques de raison $q$ telle que $|q| < 1$."]'::jsonb, '2025-12-20T23:58:37.721976+00:00'::timestamptz, '65f1be468555352ce5a0c7e6d48860bcb737833dce5461003f999f3d84705e1c', NULL),
('5cd28cc9-4d17-47cc-96b5-06a554753545', 'Intégration par parties', 'premiere', '{"contexte":"L''intégration par parties (IPP) est une technique utile pour calculer certaines intégrales. Elle est basée sur la formule : $$\\int u''(x)v(x) dx = u(x)v(x) - \\int u(x)v''(x) dx$$","questions":["En utilisant une intégration par parties, calcule l''intégrale suivante : $$\\int_1^e x \\ln(x) dx$$","Justifie le choix de $u''(x)$ et $v(x)$ que tu as fait pour cette intégration par parties."]}', 'Pour calculer $\int_1^e x \ln(x) dx$, nous allons utiliser l''intégration par parties.

Choix de $u''(x)$ et $v(x)$ :
On pose $v(x) = \ln(x)$ et $u''(x) = x$.
Alors $v''(x) = \frac{1}{x}$ et $u(x) = \frac{x^2}{2}$.

Application de la formule d''intégration par parties :
$$\int_1^e x \ln(x) dx = \left[ \frac{x^2}{2} \ln(x) \right]_1^e - \int_1^e \frac{x^2}{2} \cdot \frac{1}{x} dx$$
$$\int_1^e x \ln(x) dx = \left[ \frac{x^2}{2} \ln(x) \right]_1^e - \int_1^e \frac{x}{2} dx$$

Calcul du premier terme :
$$\left[ \frac{x^2}{2} \ln(x) \right]_1^e = \left( \frac{e^2}{2} \ln(e) \right) - \left( \frac{1^2}{2} \ln(1) \right)$$
Comme $\ln(e) = 1$ et $\ln(1) = 0$ :
$$\left[ \frac{x^2}{2} \ln(x) \right]_1^e = \frac{e^2}{2} - 0 = \frac{e^2}{2}$$

Calcul de la deuxième intégrale :
$$\int_1^e \frac{x}{2} dx = \left[ \frac{x^2}{4} \right]_1^e = \frac{e^2}{4} - \frac{1^2}{4} = \frac{e^2}{4} - \frac{1}{4}$$

Finalement :
$$\int_1^e x \ln(x) dx = \frac{e^2}{2} - \left( \frac{e^2}{4} - \frac{1}{4} \right)$$
$$\int_1^e x \ln(x) dx = \frac{2e^2}{4} - \frac{e^2}{4} + \frac{1}{4}$$
$$\int_1^e x \ln(x) dx = \frac{e^2}{4} + \frac{1}{4} = \frac{e^2 + 1}{4}$$

Justification du choix de $u''(x)$ et $v(x)$ :
Nous avons choisi $v(x) = \ln(x)$ car c''est une fonction qui se simplifie lorsqu''on la dérive (sa dérivée est $\frac{1}{x}$). Si nous avions choisi $u(x) = \ln(x)$, nous aurions dû intégrer $\ln(x)$, ce qui est plus complexe et nécessite déjà une IPP. Le choix de $u''(x) = x$ est logique car son intégrale $u(x) = \frac{x^2}{2}$ est simple à calculer et ne complique pas l''expression globale.', '["Pour choisir $u''(x)$ et $v(x)$, pense à la fonction que tu sais facilement dériver et intégrer.","Une astuce est de choisir $v(x)$ comme la fonction qui se simplifie par dérivation (comme $\\ln(x)$).","N''oublie pas d''évaluer les termes entre les bornes après l''intégration par parties."]'::jsonb, '2025-12-20T23:59:44.033984+00:00'::timestamptz, '81497dcf2ce8dd847cddd06871f435c45e9a9a00185b734a9cf68e19946675e5', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('dfdade8c-cb08-41f8-837e-138f1fd4f4b4', 'Dérivation', 'premiere', '{"contexte":"Calcule la dérivée de la fonction $f(x) = (3x+2)e^x$.","questions":["Détaille toutes les étapes de ton calcul."]}', 'Pour calculer la dérivée de $f(x) = (3x+2)e^x$, on utilise la formule de dérivation d''un produit $(uv)'' = u''v + uv''$.

1.  **Identification de $u(x)$ et $v(x)$** :
    On pose $u(x) = 3x+2$.
    On pose $v(x) = e^x$.

2.  **Calcul des dérivées $u''(x)$ et $v''(x)$** :
    La dérivée de $u(x) = 3x+2$ est $u''(x) = 3$.
    La dérivée de $v(x) = e^x$ est $v''(x) = e^x$.

3.  **Application de la formule** :
    $f''(x) = u''(x)v(x) + u(x)v''(x)$
    $f''(x) = 3 \cdot e^x + (3x+2) \cdot e^x$

4.  **Simplification du résultat** :
    On peut factoriser par $e^x$ :
    $f''(x) = e^x (3 + 3x + 2)$
    $f''(x) = e^x (3x + 5)$

Donc, la dérivée de $f(x) = (3x+2)e^x$ est $f''(x) = (3x+5)e^x$.', '["Identifie bien tes fonctions $u(x)$ et $v(x)$ dans l''expression $f(x) = u(x)v(x)$.","N''oublie pas la dérivée de $e^x$.","Factorise ton résultat final pour le simplifier."]'::jsonb, '2025-12-21T00:00:58.428743+00:00'::timestamptz, 'f7d75c177279c6aa41d1236b5c272c2f6589c30e0a36cc43237d4c303f7237c4', NULL),
('e8b54370-ae6f-4c57-92b3-4e9bada7c117', 'Exercice', 'terminale', '{"contexte":"exercice pour toi :\nSoit la suite $(U_n)$ définie par $U_0 = 1$ et, pour tout entier naturel $n$, par la relation de récurrence $U_{n+1} = \\frac{U_n}{U_n + 1}$.","questions":["Calcule les trois premiers termes de la suite : $U_1$, $U_2$ et $U_3$.","Que peux-tu conjecturer sur le sens de variation de la suite $(U_n)$ ?"]}', 'À résoudre', '[]'::jsonb, '2025-12-21T10:07:35.823821+00:00'::timestamptz, '6fad0f202f20eb7c1cebde4264533a9fc009ff0999b14cbcd114a0576b178990', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('aeb59246-e6b0-4b2a-93fc-301614589bc1', 'Suites numériques', 'terminale', '{"contexte":"Soit la suite $(V_n)$ définie par $V_0 = 2$ et, pour tout entier naturel $n$, par la relation de récurrence $V_{n+1} = \\frac{V_n}{2V_n + 1}$.","questions":["1. Calcule les trois premiers termes de la suite : $V_1$, $V_2$ et $V_3$.","2. Que peux-tu conjecturer sur le sens de variation de la suite $(V_n)$ ?"]}', '1. **Calcul des termes :**
   - $V_1 = \frac{V_0}{2V_0 + 1} = \frac{2}{2(2) + 1} = \frac{2}{5}$
   - $V_2 = \frac{V_1}{2V_1 + 1} = \frac{\frac{2}{5}}{2(\frac{2}{5}) + 1} = \frac{\frac{2}{5}}{\frac{4}{5} + \frac{5}{5}} = \frac{\frac{2}{5}}{\frac{9}{5}} = \frac{2}{9}$
   - $V_3 = \frac{V_2}{2V_2 + 1} = \frac{\frac{2}{9}}{2(\frac{2}{9}) + 1} = \frac{\frac{2}{9}}{\frac{4}{9} + \frac{9}{9}} = \frac{\frac{2}{9}}{\frac{13}{9}} = \frac{2}{13}$

2. **Conjecture sur le sens de variation :**
   $V_0 = 2$, $V_1 = 0.4$, $V_2 \approx 0.22$, $V_3 \approx 0.15$. La suite semble être **décroissante**.', '["Pour calculer $V_1$, remplace $n$ par 0 dans la formule de récurrence.","Pour $V_2$, utilise la valeur de $V_1$ que tu as trouvée.","Pour la conjecture, compare les valeurs des termes que tu as calculés."]'::jsonb, '2025-12-21T10:07:54.29068+00:00'::timestamptz, '098376b7f6fd21312748bcbb162e19eeca5b0401e426b9829171f1b1c374c46f', NULL),
('861edef4-c5dd-4031-9ff7-8d815aed5dfa', ':', 'terminale', '{"contexte":"un exercice pour consolider ces notions.\nVoici un exercice pour toi sur la **fonction logarithme népérien** 💪.\nSoit $f$ la fonction définie sur $]0 ; +\\infty[$ par $f(x) = x \\ln(x) - x$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $]0 ; +\\infty[$.","Déduis-en le tableau de variations de $f$."]}', 'À résoudre', '[]'::jsonb, '2025-12-21T10:41:59.053338+00:00'::timestamptz, '9d9e33529180df0f98684b00381f87bbbcb1dcff4c0e41278825f52c8bcd158d', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('989fedf2-9e0e-4f77-b08e-4bd036c7b682', 'Fonction logarithme népérien', 'terminale', '{"questions":["Exprime $A$ sous la forme $\\ln(k)$ où $k$ est un entier.","Exprime $B$ sous la forme $\\ln(m)$ où $m$ est un entier.","Calcule la valeur exacte de $e^{A+B}$."],"contexte":"Soit $A$ et $B$ deux expressions définies par :\\n$$A = \\ln(27) - 2\\ln(3)$$\\n$$B = \\frac{1}{2}\\ln(16) + \\ln(5) - \\ln(20)$$"}', '1. Expression de $A$ sous la forme $\ln(k)$ :\n$$A = \ln(27) - 2\ln(3)$$\n$$A = \ln(3^3) - \ln(3^2)$$\n$$A = 3\ln(3) - 2\ln(3)$$\n$$A = (3-2)\ln(3)$$\n$$A = \ln(3)$$\nDonc $k=3$.\n\n2. Expression de $B$ sous la forme $\ln(m)$ :\n$$B = \frac{1}{2}\ln(16) + \ln(5) - \ln(20)$$\n$$B = \ln(16^{\frac{1}{2}}) + \ln(5) - \ln(20)$$\n$$B = \ln(\sqrt{16}) + \ln(5) - \ln(20)$$\n$$B = \ln(4) + \ln(5) - \ln(20)$$\n$$B = \ln(4 \times 5) - \ln(20)$$\n$$B = \ln(20) - \ln(20)$$\n$$B = \ln(\frac{20}{20})$$\n$$B = \ln(1)$$\nDonc $m=1$.\n\n3. Calcul de $e^{A+B}$ :\nNous avons $A = \ln(3)$ et $B = \ln(1)$.\n$$A+B = \ln(3) + \ln(1) = \ln(3 \times 1) = \ln(3)$$\nAlors :\n$$e^{A+B} = e^{\ln(3)} = 3$$', '["Pour la première question, pense à la propriété $n\\ln(x) = \\ln(x^n)$ et $\\ln(a) - \\ln(b) = \\ln(\\frac{a}{b})$.","Pour la deuxième question, utilise les propriétés $n\\ln(x) = \\ln(x^n)$ et $\\ln(a) + \\ln(b) = \\ln(ab)$, puis $\\ln(a) - \\ln(b) = \\ln(\\frac{a}{b})$.","Pour la troisième question, rappelle-toi que $e^{\\ln(x)} = x$ et utilise les formes simplifiées de $A$ et $B$ que tu auras trouvées."]'::jsonb, '2025-12-21T10:44:43.001673+00:00'::timestamptz, '9a859a7e597aed4d86cdaaaa7725b75f54764ca047af28fc52043c7833bd109f', NULL),
('efa03b70-a194-403e-afe7-588f02ff1082', 'Combinatoire et dénombrement', 'terminale', '{"questions":["Combien de tirages de 3 boules au total sont possibles ?","Combien de tirages de 3 boules de couleurs différentes sont possibles ?","Combien de tirages de 3 boules comportant au moins 2 boules rouges sont possibles ?","Combien de tirages de 3 boules ne comportant aucune boule verte sont possibles ?","Combien de tirages de 3 boules comportant exactement 2 boules vertes sont possibles ?"],"contexte":"Une urne contient 12 boules indiscernables au toucher : 5 boules rouges, 4 boules vertes et 3 boules bleues."}', '1. Nombre total de tirages de 3 boules parmi 12 : $\binom{12}{3} = \frac{12 \times 11 \times 10}{3 \times 2 \times 1} = 220$ tirages.

2. Tirages de 3 boules de couleurs différentes : 1 rouge, 1 verte, 1 bleue.
Nombre de façons de choisir 1 rouge parmi 5 : $\binom{5}{1} = 5$
Nombre de façons de choisir 1 verte parmi 4 : $\binom{4}{1} = 4$
Nombre de façons de choisir 1 bleue parmi 3 : $\binom{3}{1} = 3$
Par le principe multiplicatif : $5 \times 4 \times 3 = 60$ tirages.

3. Tirages de 3 boules comportant au moins 2 boules rouges :
   Cas 1 : 2 boules rouges et 1 boule non rouge.
   Nombre de façons de choisir 2 rouges parmi 5 : $\binom{5}{2} = \frac{5 \times 4}{2 \times 1} = 10$
   Nombre de façons de choisir 1 non rouge parmi les $4+3=7$ boules : $\binom{7}{1} = 7$
   Par le principe multiplicatif : $10 \times 7 = 70$
   Cas 2 : 3 boules rouges.
   Nombre de façons de choisir 3 rouges parmi 5 : $\binom{5}{3} = \frac{5 \times 4 \times 3}{3 \times 2 \times 1} = 10$
   Par le principe additif : $70 + 10 = 80$ tirages.

4. Tirages de 3 boules ne comportant aucune boule verte :
   Il y a $12 - 4 = 8$ boules qui ne sont pas vertes (5 rouges et 3 bleues).
   Nombre de tirages de 3 boules parmi ces 8 boules : $\binom{8}{3} = \frac{8 \times 7 \times 6}{3 \times 2 \times 1} = 56$ tirages.

5. Tirages de 3 boules comportant exactement 2 boules vertes :
   Nombre de façons de choisir 2 vertes parmi 4 : $\binom{4}{2} = \frac{4 \times 3}{2 \times 1} = 6$
   Nombre de façons de choisir 1 boule non verte parmi les $5+3=8$ boules : $\binom{8}{1} = 8$
   Par le principe multiplicatif : $6 \times 8 = 48$ tirages.', '["Pour le nombre total de tirages, pense aux combinaisons. L''ordre n''a pas d''importance et il n''y a pas de répétition.","Pour les boules de couleurs différentes, tu dois choisir une boule de chaque couleur.","Pour ''au moins 2 boules rouges'', pense aux cas possibles : 2 rouges et 1 non rouge, ou 3 rouges.","Pour ''aucune boule verte'', considère le nombre total de boules qui ne sont pas vertes.","Pour ''exactement 2 boules vertes'', choisis 2 boules vertes et 1 boule d''une autre couleur."]'::jsonb, '2025-12-21T11:08:35.644381+00:00'::timestamptz, '7f29bb6507f40d73f6f1c80f0bc4a64f2f5108651b7904310a3892e1e4d43664', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('f339a7fd-c669-4604-9b04-78c397f395c7', 'Combinatoire et dénombrement', 'terminale', '{"contexte":"Un restaurant propose un menu avec 3 entrées différentes, 4 plats principaux différents et 2 desserts différents. Les boissons ne sont pas incluses dans le menu.","questions":["Combien de menus différents un client peut-il composer ?","Si un client doit choisir une entrée et un plat principal, mais qu''il a le choix entre 3 entrées, 4 plats principaux et 5 boissons différentes (les boissons sont indépendantes du menu), combien de combinaisons ''entrée-plat-boisson'' sont possibles ?","Pour un repas complet (entrée, plat, dessert), si l''une des entrées est une salade et l''un des plats principaux est un poisson, combien de menus contiennent la salade OU le poisson (ou les deux) ?","Le restaurant propose aussi un ''menu dégustation'' où le client choisit 2 entrées différentes parmi les 3, 2 plats principaux différents parmi les 4, et 1 dessert parmi les 2. Combien de ''menus dégustation'' différents sont possibles ?"]}', '1. Pour composer un menu, un client choisit une entrée, un plat principal et un dessert.
Nombre d''entrées : 3
Nombre de plats principaux : 4
Nombre de desserts : 2
Par le principe multiplicatif : $3 \times 4 \times 2 = 24$ menus différents.

2. Le client choisit une entrée, un plat principal et une boisson.
Nombre d''entrées : 3
Nombre de plats principaux : 4
Nombre de boissons : 5
Par le principe multiplicatif : $3 \times 4 \times 5 = 60$ combinaisons ''entrée-plat-boisson''.

3. Soit A l''événement ''le menu contient la salade'' et B l''événement ''le menu contient le poisson''.

Cas 1 : Menus contenant la salade.
Si l''entrée est la salade (1 choix), il reste 4 choix de plats et 2 choix de desserts.
Nombre de menus avec salade : $1 \times 4 \times 2 = 8$.

Cas 2 : Menus contenant le poisson.
Si le plat est le poisson (1 choix), il reste 3 choix d''entrées et 2 choix de desserts.
Nombre de menus avec poisson : $3 \times 1 \times 2 = 6$.

Cas 3 : Menus contenant la salade ET le poisson.
Si l''entrée est la salade (1 choix) ET le plat est le poisson (1 choix), il reste 2 choix de desserts.
Nombre de menus avec salade ET poisson : $1 \times 1 \times 2 = 2$.

Nombre de menus contenant la salade OU le poisson : $8 + 6 - 2 = 12$.

Alternativement, on peut lister les cas :
- Salade + Plat (non poisson) + Dessert : $1 \times 3 \times 2 = 6$
- Entrée (non salade) + Poisson + Dessert : $2 \times 1 \times 2 = 4$
- Salade + Poisson + Dessert : $1 \times 1 \times 2 = 2$
Total : $6 + 4 + 2 = 12$.

4. Pour le ''menu dégustation'' :
Choix de 2 entrées différentes parmi 3 : $\binom{3}{2} = \frac{3 \times 2}{2 \times 1} = 3$
Choix de 2 plats principaux différents parmi 4 : $\binom{4}{2} = \frac{4 \times 3}{2 \times 1} = 6$
Choix de 1 dessert parmi 2 : $\binom{2}{1} = 2$
Par le principe multiplicatif : $3 \times 6 \times 2 = 36$ ''menus dégustation'' différents.', '["Pense au principe multiplicatif pour les choix indépendants.","Pour ''OU'', tu peux utiliser la formule $P(A \\cup B) = P(A) + P(B) - P(A \\cap B)$ ou compter directement les cas.","Pour le menu dégustation, il s''agit de choisir des groupes d''éléments, l''ordre n''a pas d''importance."]'::jsonb, '2025-12-21T11:09:04.013305+00:00'::timestamptz, '6713d8a9a0fb306792f0de6d7ef64c775da5007fab899ca515e8116ca59ff8cb', NULL),
('648a008d-2bb2-4d76-9de2-b8ef6e4362cd', 'Probabilités', 'terminale', '{"questions":["Représente cette situation par un arbre pondéré.","Quelle est la probabilité qu''une ampoule choisie au hasard soit défectueuse ET que la machine la détecte comme telle ?","Quelle est la probabilité qu''une ampoule choisie au hasard soit sans défaut ET que la machine l''indique comme défectueuse ?","Quelle est la probabilité qu''une ampoule choisie au hasard soit déclarée défectueuse par la machine ?","Sachant qu''une ampoule a été déclarée défectueuse par la machine, quelle est la probabilité qu''elle soit réellement défectueuse ? Donne le résultat arrondi à $10^{-3}$ près."],"contexte":"Une usine fabrique des ampoules. On sait que 5% des ampoules produites ont un défaut de fabrication. Pour contrôler la qualité, l''usine utilise une machine de test. Cette machine détecte le défaut d''une ampoule défectueuse dans 90% des cas. Cependant, elle indique à tort un défaut pour 2% des ampoules qui sont en réalité sans défaut."}', 'Soient les événements :
$D$ : l''ampoule est défectueuse
$S$ : l''ampoule est sans défaut (c''est-à-dire $\bar{D}$)
$T$ : la machine déclare l''ampoule défectueuse
$\bar{T}$ : la machine déclare l''ampoule sans défaut

On a les probabilités suivantes :
$P(D) = 0,05$ (5% des ampoules sont défectueuses)
$P(S) = 1 - P(D) = 1 - 0,05 = 0,95$
$P(T|D) = 0,90$ (la machine détecte le défaut d''une ampoule défectueuse dans 90% des cas)
$P(T|S) = 0,02$ (la machine indique à tort un défaut pour 2% des ampoules sans défaut)

1. Arbre pondéré :
(D, 0.05) --(T, 0.90)--> (D et T, 0.05 * 0.90 = 0.045)
         \--(T barre, 0.10)--> (D et T barre, 0.05 * 0.10 = 0.005)
(S, 0.95) --(T, 0.02)--> (S et T, 0.95 * 0.02 = 0.019)
         \--(T barre, 0.98)--> (S et T barre, 0.95 * 0.98 = 0.931)

2. Probabilité qu''une ampoule soit défectueuse ET que la machine la détecte comme telle :
C''est $P(D \cap T) = P(D) \times P(T|D) = 0,05 \times 0,90 = 0,045$.

3. Probabilité qu''une ampoule soit sans défaut ET que la machine l''indique comme défectueuse :
C''est $P(S \cap T) = P(S) \times P(T|S) = 0,95 \times 0,02 = 0,019$.

4. Probabilité qu''une ampoule soit déclarée défectueuse par la machine :
C''est $P(T)$. On utilise la formule des probabilités totales :
$P(T) = P(D \cap T) + P(S \cap T) = 0,045 + 0,019 = 0,064$.

5. Sachant qu''une ampoule a été déclarée défectueuse par la machine, quelle est la probabilité qu''elle soit réellement défectueuse ?
C''est $P(D|T)$. On utilise la formule de Bayes :
$P(D|T) = \frac{P(D \cap T)}{P(T)} = \frac{0,045}{0,064} \approx 0,703125$.
Arrondi à $10^{-3}$ près, $P(D|T) \approx 0,703$.', '["Commence par définir les événements : D pour \"défectueuse\", S pour \"sans défaut\", T pour \"testée défectueuse\", T barre pour \"testée sans défaut\".","N''oublie pas que la somme des probabilités des branches partant d''un même nœud doit être égale à 1.","Pour les probabilités conditionnelles, utilise la formule de Bayes si nécessaire : $P(A|B) = \\frac{P(A \\cap B)}{P(B)}$"]'::jsonb, '2025-12-21T11:09:29.373935+00:00'::timestamptz, '713949106c3cc81ea33b35feac37bd4f8d4006a0f36dc7d018078ace9a654e41', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('e9793faf-7fa2-46bc-863b-4efb278a0a72', 'Dérivation', 'terminale', '{"questions":["Détermine l''expression de la fonction dérivée $f''(x)$.","Établis le tableau de signes de $f''(x)$.","Déduis-en le tableau de variations de la fonction $f$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x - 3)e^{x}$."}', '1. Dérivation de $f(x)$ :
La fonction $f$ est de la forme $uv$ avec $u(x) = 2x - 3$ et $v(x) = e^x$.
Alors $u''(x) = 2$ et $v''(x) = e^x$.
$f''(x) = u''(x)v(x) + u(x)v''(x) = 2e^x + (2x - 3)e^x = e^x(2 + 2x - 3) = e^x(2x - 1)$.

2. Tableau de signes de $f''(x)$ :
On étudie le signe de $2x - 1$ car $e^x > 0$ pour tout $x \in \mathbb{R}$.
$2x - 1 > 0 \iff 2x > 1 \iff x > \frac{1}{2}$.
$2x - 1 < 0 \iff x < \frac{1}{2}$.
$2x - 1 = 0 \iff x = \frac{1}{2}$.

Tableau de signes de $f''(x)$ :

| $x$             | $-\infty$ | $1/2$ | $+\infty$ |
|-----------------|-----------|-------|-----------|
| Signe de $2x-1$ | $-$       | $0$   | $+$       |
| Signe de $e^x$  | $+$       | $+$   | $+$       |
| Signe de $f''(x)$ | $-$       | $0$   | $+$       |

3. Tableau de variations de $f$ :

| $x$             | $-\infty$ | $1/2$ | $+\infty$ |
|-----------------|-----------|-------|-----------|
| Signe de $f''(x)$ | $-$       | $0$   | $+$       |
| Variations de $f$ | $\searrow$ | $f(1/2)$ | $\nearrow$ |

Calcul de $f(1/2) = (2(\frac{1}{2}) - 3)e^{\frac{1}{2}} = (1 - 3)e^{\frac{1}{2}} = -2\sqrt{e}$.', '["Pour dériver $f(x)$, utilise la formule de dérivation d''un produit $(uv)'' = u''v + uv''$.","N''oublie pas que la dérivée de $e^x$ est $e^x$.","L''exponentielle $e^x$ est toujours positive."]'::jsonb, '2025-12-21T11:45:56.754067+00:00'::timestamptz, '7654e1f45bcedaac07b5b3959ac69ffd4d8f593030b23b9a03de331b84bdcd4d', NULL),
('ce6c2b59-f7a5-487d-86fb-4b3d627f0eef', 'Dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $]0 ; +\\infty[$ par $f(x) = x^2 \\ln(x) - \\frac{3}{2}x^2$.","questions":["Détermine l''expression de la fonction dérivée $f''(x)$.","Étudie le signe de $f''(x)$ sur $]0 ; +\\infty[$.","Déduis-en le tableau de variations de la fonction $f$ sur $]0 ; +\\infty[$.","Détermine l''équation de la tangente à la courbe représentative de $f$ au point d''abscisse $x=e$."]}', '1. Dérivée de $f(x)$ :
$f(x) = x^2 \ln(x) - \frac{3}{2}x^2$
Pour dériver $x^2 \ln(x)$, on utilise la formule $(uv)'' = u''v + uv''$ avec $u(x) = x^2$ et $v(x) = \ln(x)$.
$u''(x) = 2x$
$v''(x) = \frac{1}{x}$
Donc $(x^2 \ln(x))'' = 2x \ln(x) + x^2 \left(\frac{1}{x}\right) = 2x \ln(x) + x$.
La dérivée de $-\frac{3}{2}x^2$ est $-3x$.
Ainsi, $f''(x) = 2x \ln(x) + x - 3x = 2x \ln(x) - 2x = 2x(\ln(x) - 1)$.

2. Signe de $f''(x)$ :
On cherche le signe de $2x(\ln(x) - 1)$ sur $]0 ; +\infty[$.
Comme $x \in ]0 ; +\infty[$, $2x > 0$.
Il faut donc étudier le signe de $\ln(x) - 1$.
$\ln(x) - 1 > 0 \iff \ln(x) > 1 \iff x > e$.
$\ln(x) - 1 < 0 \iff \ln(x) < 1 \iff x < e$.
$\ln(x) - 1 = 0 \iff \ln(x) = 1 \iff x = e$.

3. Tableau de variations de $f$ :
Sur $]0 ; e[$, $f''(x) < 0$, donc $f$ est décroissante.
Sur $]e ; +\infty[$, $f''(x) > 0$, donc $f$ est croissante.
En $x=e$, $f''(x) = 0$, donc $f$ admet un minimum local.
$f(e) = e^2 \ln(e) - \frac{3}{2}e^2 = e^2 - \frac{3}{2}e^2 = -\frac{1}{2}e^2$.

Tableau de variations :

$x$ | $0$ | $e$ | $+\infty$
---|---|---|---
$\ln(x)-1$ | $-$ | $0$ | $+
$2x$ | $+$ | $+$ | $+
$f''(x)$ | $-$ | $0$ | $+
$f(x)$ | $\searrow$ | $- \frac{1}{2}e^2$ | $\nearrow$

4. Équation de la tangente en $x=e$ :
L''équation de la tangente est $y = f''(e)(x-e) + f(e)$.
On a $f''(e) = 2e(\ln(e) - 1) = 2e(1-1) = 0$.
Et $f(e) = -\frac{1}{2}e^2$.
Donc $y = 0(x-e) - \frac{1}{2}e^2$, soit $y = -\frac{1}{2}e^2$.', '["Pense à la formule de dérivation d''un produit $(uv)'' = u''v + uv''$.","N''oublie pas que la dérivée de $\\ln(x)$ est $\\frac{1}{x}$.","Pour le signe de $f''(x)$, cherche les valeurs qui annulent l''expression.","L''équation de la tangente en un point $a$ est donnée par $y = f''(a)(x-a) + f(a)$."]'::jsonb, '2025-12-21T14:12:12.780557+00:00'::timestamptz, '9f4b9af691b4f1e81026cc8dc49b11ae99addd92eb9aa0a29b63004b4dd85d53', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('96be3998-7e95-437d-8886-8b9a54584815', 'Compléments sur la dérivation', 'terminale', '{"questions":["Identifie la fonction intérieure $u(x)$ et la fonction extérieure $g(u)$ de la fonction $f(x)$.","Détermine la dérivée de la fonction intérieure $u''(x)$.","Détermine la dérivée de la fonction extérieure $g''(u)$.","En utilisant la formule de dérivation des fonctions composées, $f''(x) = u''(x) \\times g''(u(x))$, calcule la dérivée $f''(x)$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x - 2)^4$."}', '1. La fonction intérieure est $u(x) = 3x - 2$. La fonction extérieure est $g(u) = u^4$.
2. La dérivée de la fonction intérieure est $u''(x) = 3$.
3. La dérivée de la fonction extérieure est $g''(u) = 4u^3$.
4. En utilisant la formule $f''(x) = u''(x) \times g''(u(x))$ :
$f''(x) = 3 \times 4(3x - 2)^3$
$f''(x) = 12(3x - 2)^3$', '["La fonction composée est de la forme $g(u(x))$","La dérivée de $u^n$ est $n u^{n-1} u''$","N''oublie pas de remplacer $u$ par son expression en fonction de $x$ à la fin."]'::jsonb, '2025-12-22T13:27:42.35901+00:00'::timestamptz, '93f26ef1905e10d9df957e57c3f579b1d49e6a0115ab9abd7bd34fc3f113aa97', NULL),
('c64c2a82-80a9-4b4b-832b-3a6c86e786f2', 'Exercice', 'seconde', '{"contexte":"","questions":["Que je te propose un nouvel exercice sur un chapitre en particulier ?","Me poser une question sur un cours que tu n''as pas compris ?"]}', 'À résoudre', '[]'::jsonb, '2025-12-22T17:19:41.145263+00:00'::timestamptz, 'eba00cb98ccda3c6702898b81a83b964a1583b0dfc19da6030b59c3ba6e99a54', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('7c934a6c-7839-42fe-995a-c1a93393a35c', 'Vocabulaire ensembliste et logique', 'seconde', '{"contexte":"Pour chacune des propositions suivantes, tu devras déterminer si elle est vraie ou fausse, puis écrire sa négation de manière claire et précise.","questions":["Soit la proposition $P_1$ : \"Tous les nombres premiers sont impairs.\"","Soit la proposition $P_2$ : \"Il existe un nombre réel $x$ tel que $x^2 < 0$.\"","Soit la proposition $P_3$ : \"Pour tout nombre entier $n$, si $n$ est pair, alors $n+1$ est impair.\"","Soit la proposition $P_4$ : \"La somme de deux nombres impairs est toujours impaire.\""]}', '**Proposition $P_1$ : "Tous les nombres premiers sont impairs."**
*   **Valeur de vérité :** Fausse. Le nombre 2 est un nombre premier et il est pair.
*   **Négation de $P_1$ :** "Il existe au moins un nombre premier qui est pair."

**Proposition $P_2$ : "Il existe un nombre réel $x$ tel que $x^2 < 0$."**
*   **Valeur de vérité :** Fausse. Le carré d''un nombre réel est toujours positif ou nul ($x^2 \ge 0$).
*   **Négation de $P_2$ :** "Pour tout nombre réel $x$, $x^2 \ge 0$."

**Proposition $P_3$ : "Pour tout nombre entier $n$, si $n$ est pair, alors $n+1$ est impair."**
*   **Valeur de vérité :** Vraie. Si $n$ est pair, il peut s''écrire $n = 2k$ pour un entier $k$. Alors $n+1 = 2k+1$, ce qui est la définition d''un nombre impair.
*   **Négation de $P_3$ :** "Il existe un nombre entier $n$ tel que $n$ est pair et $n+1$ est pair." (ou "... et $n+1$ n''est pas impair.")

**Proposition $P_4$ : "La somme de deux nombres impairs est toujours impaire."**
*   **Valeur de vérité :** Fausse. Prenons deux nombres impairs : $3$ et $5$. Leur somme est $3+5=8$, qui est un nombre pair.
*   **Négation de $P_4$ :** "Il existe deux nombres impairs dont la somme est paire."', '["Pour nier une proposition universelle (qui commence par \"Tous\" ou \"Pour tout\"), tu devras utiliser une existence (il existe au moins un).","Pour nier une proposition existentielle (qui commence par \"Il existe\"), tu devras utiliser une universalité (pour tout).","La négation de \"Si A, alors B\" est \"A et non B\".","Pense aux définitions de nombres pairs et impairs."]'::jsonb, '2025-12-22T17:26:48.775725+00:00'::timestamptz, '36dd64cf34d9f8bd56feb5350a3afbe5f4ec9665f8644d39ac96bae5a2af4dab', NULL),
('352f29c3-bbb1-4905-9a80-6cfb0d3f0907', 'Trigonométrie', 'terminale', '{"questions":["Démontre que pour tout réel $x$, $f(x) = -2\\sin^2(x) - 2\\sin(x) + 2$.","Résous l''équation $f(x) = 0$ sur l''intervalle $[0, 2\\pi]$.","Déduis-en les solutions de l''équation $f(x) = 0$ sur $\\mathbb{R}$."],"contexte":"On considère la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = \\cos(2x) - 2\\sin(x) + 1$."}', '1. On sait que $\cos(2x) = 1 - 2\sin^2(x)$.
Donc $f(x) = (1 - 2\sin^2(x)) - 2\sin(x) + 1 = -2\sin^2(x) - 2\sin(x) + 2$.

2. On résout $f(x) = 0$, soit $-2\sin^2(x) - 2\sin(x) + 2 = 0$.
En divisant par $-2$, on obtient $\sin^2(x) + \sin(x) - 1 = 0$.
Posons $X = \sin(x)$. L''équation devient $X^2 + X - 1 = 0$.
Le discriminant est $\Delta = 1^2 - 4(1)(-1) = 1 + 4 = 5$.
Les solutions sont $X_1 = \frac{-1 - \sqrt{5}}{2}$ et $X_2 = \frac{-1 + \sqrt{5}}{2}$.

On a donc $\sin(x) = \frac{-1 - \sqrt{5}}{2}$ ou $\sin(x) = \frac{-1 + \sqrt{5}}{2}$.
Comme $-1 \le \sin(x) \le 1$, et que $\frac{-1 - \sqrt{5}}{2} \approx -1.618$, la première solution est impossible.
Pour la deuxième solution, $\sin(x) = \frac{-1 + \sqrt{5}}{2} \approx 0.618$.
Soit $\alpha = \arcsin\left(\frac{-1 + \sqrt{5}}{2}\right)$.
Sur $[0, 2\pi]$, les solutions sont $x_1 = \alpha$ et $x_2 = \pi - \alpha$.

3. Les solutions sur $\mathbb{R}$ sont $x = \alpha + 2k\pi$ ou $x = \pi - \alpha + 2k\pi$, où $k \in \mathbb{Z}$.', '["Utilise la formule de duplication du cosinus : $\\cos(2x) = 1 - 2\\sin^2(x)$.","Pose $X = \\sin(x)$ pour résoudre l''équation du second degré.","N''oublie pas que $\\sin(x) = k$ a des solutions périodiques."]'::jsonb, '2025-12-24T14:53:18.209273+00:00'::timestamptz, '54a33992c84e4b2ccefb30ed8069999513bd6f1376303634e4e3ceecfa5462e0', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('23a5a808-f1d5-4678-b320-bc2276a036e3', 'Fonctions', 'terminale', '{"questions":["Calcule la limite de $f(x)$ lorsque $x$ tend vers $0^+$.","Calcule la limite de $f(x)$ lorsque $x$ tend vers $+ \\infty$.","Montre que la droite $\\mathcal{D}$ d''équation $y = x^2 - 2x + 1$ est une asymptote oblique à la courbe représentative de $f$ en $+ \\infty$.","Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ sur $]0 ; +\\infty[$ et dresse le tableau de variations de $f$."],"contexte":"On considère la fonction $f$ définie sur $]0 ; +\\infty[$ par $f(x) = x^2 - 2x + 1 - \\frac{2}{x}$."}', '1. Limite en $0^+$ :
$\lim_{x \to 0^+} (x^2 - 2x + 1) = 1$
$\lim_{x \to 0^+} \frac{2}{x} = +\infty$
Donc $\lim_{x \to 0^+} f(x) = 1 - (+\infty) = -\infty$.

2. Limite en $+ \infty$ :
$\lim_{x \to +\infty} (x^2 - 2x + 1) = +\infty$ (terme de plus haut degré $x^2$)
$\lim_{x \to +\infty} \frac{2}{x} = 0$
Donc $\lim_{x \to +\infty} f(x) = +\infty - 0 = +\infty$.

3. Asymptote oblique :
On étudie la limite de $f(x) - (x^2 - 2x + 1)$ lorsque $x \to +\infty$.
$f(x) - (x^2 - 2x + 1) = (x^2 - 2x + 1 - \frac{2}{x}) - (x^2 - 2x + 1) = -\frac{2}{x}$.
$\lim_{x \to +\infty} -\frac{2}{x} = 0$.
Puisque la limite de la différence est 0, la droite $\mathcal{D}$ d''équation $y = x^2 - 2x + 1$ est bien une asymptote oblique à la courbe représentative de $f$ en $+ \infty$.

4. Dérivée $f''(x)$ :
$f(x) = x^2 - 2x + 1 - 2x^{-1}$
$f''(x) = 2x - 2 - 2(-1)x^{-2} = 2x - 2 + \frac{2}{x^2}$.

5. Signe de $f''(x)$ et tableau de variations :
$f''(x) = 2x - 2 + \frac{2}{x^2} = \frac{2x^3 - 2x^2 + 2}{x^2}$.
Sur $]0 ; +\infty[$, $x^2 > 0$, donc le signe de $f''(x)$ est le même que le signe de $2x^3 - 2x^2 + 2$. Soit $g(x) = 2x^3 - 2x^2 + 2$.
On peut remarquer que $g(1) = 2(1)^3 - 2(1)^2 + 2 = 2 - 2 + 2 = 2$.
En fait, il y a une erreur dans l''énoncé, la fonction n''est pas simple à étudier. Reprenons la dérivée :
$f''(x) = 2x - 2 + \frac{2}{x^2}$.
Pour $x \in ]0, 1]$, $2x - 2 \le 0$. Cependant $\frac{2}{x^2} > 0$. Il faut étudier plus précisément.
Soit $h(x) = 2x^3 - 2x^2 + 2$. $h''(x) = 6x^2 - 4x = 2x(3x-2)$.
Sur $]0, +\infty[$, $h''(x)$ s''annule en $x = 2/3$. $h''(x) < 0$ sur $]0, 2/3[$ et $h''(x) > 0$ sur $]2/3, +\infty[$.
$h(2/3) = 2(8/27) - 2(4/9) + 2 = 16/27 - 24/27 + 54/27 = 46/27 > 0$.
Comme $h(x)$ décroît puis croît, et son minimum est positif, $h(x) > 0$ pour tout $x > 0$.
Donc $f''(x) > 0$ sur $]0 ; +\infty[$.
La fonction $f$ est strictement croissante sur $]0 ; +\infty[$.

Tableau de variations :
$x$ | $0$ | $+ \infty$
--- | --- | ---
$f''(x)$ | | $+
$f(x)$ | $- \infty$ | $\nearrow$ | $+ \infty$', '["Pour la limite en $0^+$, fais attention au signe de $\\frac{2}{x}$.","Pour la limite en $+ \\infty$, tu peux factoriser par le terme de plus haut degré ou utiliser les croissances comparées si besoin, mais ici c''est plus simple.","Pour montrer qu''une droite est asymptote oblique, étudie la limite de la différence $f(x) - (ax+b)$ ou $f(x) - P(x)$ si c''est une asymptote parabolique.","N''oublie pas la règle de dérivation de $\\frac{1}{x}$.","Pour le signe de $f''(x)$, mets tout au même dénominateur."]'::jsonb, '2025-12-24T14:55:25.324737+00:00'::timestamptz, '3cd1e0a9c57b4cb7b69ba7fe105cf70ea9f8f50590b52b6e0bdefeeb14dcb791', NULL),
('3f7db321-9149-4e4a-9dd4-e7bb43e85c28', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit $f$ la fonction définie sur $\\mathbb{R}$ par $f(x) = x^4 - 2x^3 - 12x^2 + 1$.","questions":["1. Calcule la dérivée première $f''(x)$ de la fonction $f$.","2. Calcule la dérivée seconde $f''''(x)$ de la fonction $f$.","3. Étudie le signe de $f''''(x)$ et détermine les intervalles sur lesquels $f$ est convexe ou concave.","4. Détermine les coordonnées des points d''inflexion de la courbe représentative de $f$."]}', '1. $f''(x) = 4x^3 - 6x^2 - 24x$. 
2. $f''''(x) = 12x^2 - 12x - 24$. 
3. $f''''(x) = 12(x^2 - x - 2) = 12(x-2)(x+1)$. $f''''(x) \geq 0$ pour $x \in ]-\infty, -1] \cup [2, +\infty[$, donc $f$ est convexe sur ces intervalles. $f''''(x) \leq 0$ pour $x \in [-1, 2]$, donc $f$ est concave sur cet intervalle. 
4. Les points d''inflexion sont en $x = -1$ et $x = 2$. Les coordonnées sont $(-1, f(-1)) = (-1, -8)$ et $(2, f(2)) = (2, -47)$.', '["Pour la dérivée d''un polynôme $ax^n$, la formule est $nax^{n-1}$.","Pour trouver les points d''inflexion, il faut résoudre $f''''(x) = 0$ et vérifier que $f''''$ change de signe autour de ces points."]'::jsonb, '2025-12-25T10:11:03.047472+00:00'::timestamptz, '7079e9fa3592eacccabbc48bc7315c6d8e58e5b90bc84ae63b2c6b770665f973', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('41c6a333-dfb1-4a30-b7be-4feb41844fdd', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x^2 - 2x + 1)^4$.","questions":["Identifie la fonction extérieure $u$ et la fonction intérieure $v$ telles que $f(x) = u(v(x))$.","Détermine les expressions de $u''(y)$ et $v''(x)$.","Applique la formule de dérivation des fonctions composées pour trouver $f''(x)$.","Développe et simplifie l''expression de $f''(x)$."]}', '1. Identification des fonctions :
   Soit $v(x) = 3x^2 - 2x + 1$. Alors $u(y) = y^4$.

2. Dérivées des fonctions :
   $v''(x) = 6x - 2$
   $u''(y) = 4y^3$

3. Application de la formule :
   $f''(x) = u''(v(x)) \times v''(x) = 4(3x^2 - 2x + 1)^3 \times (6x - 2)$

4. Simplification :
   $f''(x) = (24x - 8)(3x^2 - 2x + 1)^3$', '["Rappelle-toi la formule de dérivation d''une fonction composée : $(u \\circ v)''(x) = u''(v(x)) \\times v''(x)$.","Pour $u(y) = y^n$, sa dérivée est $u''(y) = ny^{n-1}$.","La dérivée d''un polynôme $ax^n$ est $nax^{n-1}$."]'::jsonb, '2025-12-27T10:10:15.119808+00:00'::timestamptz, 'd9fdf489e95accea1cc96f998b3ad22d7e2045e89cdf744af0195cc01059d3c8', NULL),
('7621733f-e5e2-4c62-9bf4-d72262222e58', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^3 - 3x^2 + 4$.","questions":["1. Détermine l''ensemble de définition de $f$.","2. Calcule la dérivée $f''(x)$ de $f$.","3. Étudie le signe de $f''(x)$ et déduis-en le tableau de variations de $f$.","4. Calcule la dérivée seconde $f''''(x)$ de $f$.","5. Étudie le signe de $f''''(x)$ et déduis-en la convexité de $f$ et les éventuels points d''inflexion."]}', '1. La fonction $f(x) = x^3 - 3x^2 + 4$ est une fonction polynôme. Son ensemble de définition est donc $D_f = \mathbb{R}$.

2. Calcul de la dérivée $f''(x)$ :
$f''(x) = (x^3)'' - (3x^2)'' + (4)''$
$f''(x) = 3x^2 - 3 \times 2x + 0$
$f''(x) = 3x^2 - 6x$

3. Étude du signe de $f''(x)$ et tableau de variations :
On factorise $f''(x) = 3x(x - 2)$.
Les racines sont $x = 0$ et $x = 2$.
$f''(x)$ est un polynôme du second degré avec un coefficient dominant positif ($3 > 0$).
Donc $f''(x) > 0$ pour $x \in ]-\infty, 0[ \cup ]2, +\infty[$
$f''(x) < 0$ pour $x \in ]0, 2[$
$f''(x) = 0$ pour $x = 0$ et $x = 2$.

Valeurs de $f$ aux points critiques :
$f(0) = 0^3 - 3(0)^2 + 4 = 4$
$f(2) = 2^3 - 3(2)^2 + 4 = 8 - 12 + 4 = 0$

Limites aux bornes :
$\lim_{x \to -\infty} (x^3 - 3x^2 + 4) = \lim_{x \to -\infty} x^3 = -\infty$
$\lim_{x \to +\infty} (x^3 - 3x^2 + 4) = \lim_{x \to +\infty} x^3 = +\infty$

Tableau de variations :

:::TABLEAU_JSON
{
  "variable": "x",
  "bornes": ["-\infty", "0", "2", "+\infty"],
  "lignes": [
    { "nom": "f''(x)", "valeurs": ["+", "0", "-", "0", "+"], "type": "signes" },
    { "nom": "f(x)", "valeurs": ["-\infty", "↗", "4", "↘", "0", "↗", "+\infty"], "type": "variations" }
  ]
}
:::

4. Calcul de la dérivée seconde $f''''(x)$ :
$f''''(x) = (3x^2 - 6x)''$
$f''''(x) = 6x - 6$

5. Étude du signe de $f''''(x)$ et convexité :
On cherche quand $f''''(x) = 0$ :
$6x - 6 = 0 \implies 6x = 6 \implies x = 1$

$f''''(x) > 0$ pour $6x - 6 > 0 \implies 6x > 6 \implies x > 1$
$f''''(x) < 0$ pour $6x - 6 < 0 \implies 6x < 6 \implies x < 1$

La fonction $f$ est concave sur $]-\infty, 1[$ et convexe sur $]1, +\infty[$.
Le point d''abscisse $x=1$ est un point d''inflexion car $f''''(x)$ change de signe en $x=1$.
L''ordonnée du point d''inflexion est $f(1) = 1^3 - 3(1)^2 + 4 = 1 - 3 + 4 = 2$. Le point d''inflexion est $(1, 2)$.', '["Pour l''ensemble de définition, pense à la nature de la fonction (polynôme, rationnelle, etc.).","Pour la dérivée, utilise les règles de dérivation des fonctions puissance : $(x^n)'' = nx^{n-1}$.","Pour le signe de $f''(x)$, factorise $f''(x)$ pour trouver ses racines.","Pour la dérivée seconde, dérive $f''(x)$ comme tu as dérivé $f(x)$.","Pour la convexité, souviens-toi : $f''''(x) > 0$ signifie convexe, $f''''(x) < 0$ signifie concave."]'::jsonb, '2025-12-27T10:21:33.252058+00:00'::timestamptz, '9cc5c11afcf8ae2730d0b4a03ad8434cd816681bb30da715b3aec4ae374da44e', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('f95626ac-727b-4659-9fff-88eb7af6ae85', 'Compléments sur la dérivation', 'terminale', '{"questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Détermine le signe de $f''(x)$ sur $\\mathbb{R}$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x-1)^4$."}', '$$f(x) = (3x-1)^4$$ 
La fonction $f$ est de la forme $u^n$ avec $u(x) = 3x-1$ et $n=4$.
Alors $u''(x) = 3$.
La dérivée est $f''(x) = n u''(x) u(x)^{n-1} = 4 \times 3 \times (3x-1)^{4-1} = 12(3x-1)^3$.

Pour le signe de $f''(x)$ :
$12 > 0$.
Le signe de $f''(x)$ est donc le même que le signe de $(3x-1)^3$.
Le signe de $(3x-1)^3$ est le même que le signe de $3x-1$.
$3x-1 > 0 \iff 3x > 1 \iff x > \frac{1}{3}$.
$3x-1 < 0 \iff 3x < 1 \iff x < \frac{1}{3}$.
$3x-1 = 0 \iff x = \frac{1}{3}$.
Donc :
- Si $x < \frac{1}{3}$, $f''(x) < 0$.
- Si $x > \frac{1}{3}$, $f''(x) > 0$.
- Si $x = \frac{1}{3}$, $f''(x) = 0$.', '["Rappelle-toi la formule de dérivation d''une fonction composée $(u^n)'' = n u'' u^{n-1}$.","Identifie $u(x)$ et $n$ dans l''expression de $f(x)$.","Pour le signe, un carré est toujours positif."]'::jsonb, '2025-12-27T10:23:46.897476+00:00'::timestamptz, 'c3b33a1ad57e319d1dc1fd1e0085be75f342044f0ffcdef035d037cb939350e6', NULL),
('39c0e56c-90e4-4616-b53d-17ef26a3b165', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x - 3)e^x$.","questions":["1. Détermine l''expression de la dérivée $f''(x)$.","2. Étudie le signe de $f''(x)$.","3. Calcule les limites de $f(x)$ en $-\\infty$ et en $+\\infty$.","4. Construis le tableau de variations de $f$."]}', '1. **Dérivée $f''(x)$** :
   La fonction $f(x) = (2x - 3)e^x$ est de la forme $u(x)v(x)$ avec :
   $u(x) = 2x - 3 \implies u''(x) = 2$
   $v(x) = e^x \implies v''(x) = e^x$
   Donc $f''(x) = u''(x)v(x) + u(x)v''(x) = 2e^x + (2x - 3)e^x = e^x(2 + 2x - 3) = e^x(2x - 1)$.

2. **Signe de $f''(x)$** :
   On sait que $e^x > 0$ pour tout $x \in \mathbb{R}$.
   Le signe de $f''(x)$ est donc le même que celui de $2x - 1$.
   $2x - 1 > 0 \iff 2x > 1 \iff x > 1/2$.
   $2x - 1 < 0 \iff x < 1/2$.
   $2x - 1 = 0 \iff x = 1/2$.

3. **Limites de $f(x)$** :
   *   En $-\infty$ :
      $\lim_{x \to -\infty} (2x - 3) = -\infty$
      $\lim_{x \to -\infty} e^x = 0$
      C''est une forme indéterminée $0 \times \infty$. On peut réécrire $f(x) = 2xe^x - 3e^x$.
      Par croissances comparées, $\lim_{x \to -\infty} xe^x = 0$. Donc $\lim_{x \to -\infty} 2xe^x = 0$.
      Et $\lim_{x \to -\infty} 3e^x = 0$.
      Donc $\lim_{x \to -\infty} f(x) = 0 - 0 = 0$.
   *   En $+\infty$ :
      $\lim_{x \to +\infty} (2x - 3) = +\infty$
      $\lim_{x \to +\infty} e^x = +\infty$
      Donc $\lim_{x \to +\infty} f(x) = +\infty \times +\infty = +\infty$.

4. **Tableau de variations** :
   On calcule la valeur de $f(x)$ en $x = 1/2$ :
   $f(1/2) = (2(1/2) - 3)e^{1/2} = (1 - 3)e^{1/2} = -2\sqrt{e}$.

   :::TABLEAU_JSON
{
  "variable": "x",
  "bornes": ["-\infty", "1/2", "+\infty"],
  "lignes": [
    { "nom": "$f''(x)$", "valeurs": ["-", "0", "+"], "type": "signes" },
    { "nom": "$f(x)$", "valeurs": ["0", "\searrow", "$-2\sqrt{e}$", "
earrow", "+\infty"], "type": "variations" }
  ]
}
:::

   La fonction $f$ est décroissante sur $]-\infty, 1/2]$ et croissante sur $[1/2, +\infty[$. Elle admet un minimum local en $x = 1/2$, qui vaut $-2\sqrt{e}$.', '["Pour la dérivée, pense à la formule $(uv)'' = u''v + uv''$. Identifie bien $u(x)$ et $v(x)$.","Pour le signe de $f''(x)$, souviens-toi que $e^x$ est toujours positif. Le signe de $f''(x)$ dépendra donc du signe de l''autre facteur.","Pour la limite en $-\\infty$, tu vas rencontrer une forme indéterminée de type $0 \\times \\infty$. Pense aux croissances comparées : l''exponentielle l''emporte sur les polynômes en $-\\infty$ (c''est-à-dire que $xe^x \\to 0$ quand $x \\to -\\infty$).","N''oublie pas de calculer la valeur de $f(x)$ au point où la dérivée s''annule pour compléter ton tableau."]'::jsonb, '2025-12-27T10:37:08.337833+00:00'::timestamptz, '4d71642f57968cfcdbd69b8ef80c016e206d2b35692375a0be5ab0a8fed3c175', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('a7c974bb-611c-4dcf-9b83-d4829b7ecfed', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit la fonction $g$ définie sur $]0, +\\infty[$ par $g(x) = x - 1 + \\frac{1}{x}$.","questions":["1. Détermine l''expression de la dérivée $g''(x)$.","2. Étudie le signe de $g''(x)$.","3. Calcule les limites de $g(x)$ en $0$ (à droite) et en $+\\infty$.","4. Construis le tableau de variations de $g$."]}', '1. **Dérivée $g''(x)$** :
   La fonction $g(x) = x - 1 + \frac{1}{x}$.
   La dérivée de $x$ est $1$.
   La dérivée de $-1$ est $0$.
   La dérivée de $\frac{1}{x}$ est $-\frac{1}{x^2}$.
   Donc $g''(x) = 1 - \frac{1}{x^2}$.

2. **Signe de $g''(x)$** :
   On met $g''(x)$ au même dénominateur :
   $g''(x) = \frac{x^2}{x^2} - \frac{1}{x^2} = \frac{x^2 - 1}{x^2}$.
   Le dénominateur $x^2$ est toujours positif sur $]0, +\infty[$.
   Le signe de $g''(x)$ dépend donc du signe du numérateur $x^2 - 1$.
   On cherche les racines de $x^2 - 1 = 0 \iff x^2 = 1 \iff x = 1$ (car $x > 0$).
   On étudie le signe de $x^2 - 1$ :
   *   Si $x \in ]0, 1[$, $x^2 - 1 < 0$, donc $g''(x) < 0$.
   *   Si $x = 1$, $x^2 - 1 = 0$, donc $g''(x) = 0$.
   *   Si $x \in ]1, +\infty[$, $x^2 - 1 > 0$, donc $g''(x) > 0$.

3. **Limites de $g(x)$** :
   *   En $0^+$ :
      $\lim_{x \to 0^+} (x - 1) = -1$
      $\lim_{x \to 0^+} \frac{1}{x} = +\infty$
      Donc $\lim_{x \to 0^+} g(x) = -1 + (+\infty) = +\infty$.
   *   En $+\infty$ :
      $\lim_{x \to +\infty} (x - 1) = +\infty$
      $\lim_{x \to +\infty} \frac{1}{x} = 0$
      Donc $\lim_{x \to +\infty} g(x) = +\infty + 0 = +\infty$.

4. **Tableau de variations** :
   On calcule la valeur de $g(x)$ en $x = 1$ :
   $g(1) = 1 - 1 + \frac{1}{1} = 1$.

   :::TABLEAU_JSON
{
  "variable": "x",
  "bornes": ["0", "1", "+\infty"],
  "lignes": [
    { "nom": "$g''(x)$", "valeurs": ["-", "0", "+"], "type": "signes" },
    { "nom": "$g(x)$", "valeurs": ["+\infty", "\searrow", "1", "
earrow", "+\infty"], "type": "variations" }
  ]
}
:::

   La fonction $g$ est décroissante sur $]0, 1]$ et croissante sur $[1, +\infty[$. Elle admet un minimum local en $x = 1$, qui vaut $1$.', '["Pour la dérivée de $\\frac{1}{x}$, souviens-toi que c''est une fonction de référence. Tu peux aussi la voir comme $x^{-1}$.","Pour étudier le signe de $g''(x)$, mets les termes au même dénominateur pour avoir une seule fraction. Ensuite, étudie le signe du numérateur et du dénominateur séparément.","Pour la limite en $0^+$ (à droite de 0), pense à la limite de $\\frac{1}{x}$ quand $x \\to 0^+$.","N''oublie pas de calculer la valeur de $g(x)$ au(x) point(s) où la dérivée s''annule pour compléter ton tableau."]'::jsonb, '2025-12-27T11:28:41.399979+00:00'::timestamptz, '1812abe92f85f6ee7faf6a909be735566b19437e886015a2f30c9f46912acc4c', NULL),
('193e55c4-b48d-4016-9ce8-04c0b83b9b5a', 'Compléments sur la dérivation', 'terminale', '{"questions":["1. Détermine l''expression de la dérivée $h''(x)$.","2. Étudie le signe de $h''(x)$.","3. Calcule les limites de $h(x)$ aux bornes de son ensemble de définition (en $-2^+$ et en $+\\infty$).","4. Construis le tableau de variations de $h$."],"contexte":"Soit la fonction $h$ définie sur $]-2, +\\infty[$ par $h(x) = \\frac{x^2 - 3x + 1}{x + 2}$."}', '1. **Dérivée $h''(x)$** :
   La fonction $h(x) = \frac{x^2 - 3x + 1}{x + 2}$ est de la forme $\frac{u(x)}{v(x)}$ avec :
   $u(x) = x^2 - 3x + 1 \implies u''(x) = 2x - 3$
   $v(x) = x + 2 \implies v''(x) = 1$
   En utilisant la formule $\left(\frac{u}{v}\right)'' = \frac{u''v - uv''}{v^2}$ :
   $h''(x) = \frac{(2x - 3)(x + 2) - (x^2 - 3x + 1)(1)}{(x + 2)^2}$
   $h''(x) = \frac{(2x^2 + 4x - 3x - 6) - (x^2 - 3x + 1)}{(x + 2)^2}$
   $h''(x) = \frac{2x^2 + x - 6 - x^2 + 3x - 1}{(x + 2)^2}$
   $h''(x) = \frac{x^2 + 4x - 7}{(x + 2)^2}$.

2. **Signe de $h''(x)$** :
   Sur $]-2, +\infty[$, le dénominateur $(x + 2)^2$ est toujours strictement positif.
   Le signe de $h''(x)$ dépend donc du signe du numérateur $N(x) = x^2 + 4x - 7$.
   Calculons le discriminant $\Delta$ de ce polynôme du second degré :
   $\Delta = b^2 - 4ac = 4^2 - 4(1)(-7) = 16 + 28 = 44$.
   Les racines sont $x_1 = \frac{-4 - \sqrt{44}}{2} = \frac{-4 - 2\sqrt{11}}{2} = -2 - \sqrt{11}$ et $x_2 = \frac{-4 + \sqrt{44}}{2} = \frac{-4 + 2\sqrt{11}}{2} = -2 + \sqrt{11}$.
   On a $\sqrt{11} \approx 3.31$.
   Donc $x_1 \approx -2 - 3.31 = -5.31$ et $x_2 \approx -2 + 3.31 = 1.31$.
   Puisque l''ensemble de définition est $]-2, +\infty[$, seule la racine $x_2 = -2 + \sqrt{11}$ est pertinente.
   Le polynôme $N(x)$ est positif à l''extérieur de ses racines et négatif entre ses racines. Comme $a=1>0$, $N(x)$ est positif sur $]-\infty, x_1[ \cup ]x_2, +\infty[$ et négatif sur $]x_1, x_2[$.
   Sur l''intervalle $]-2, +\infty[$ :
   *   Si $x \in ]-2, -2 + \sqrt{11}[$, $h''(x) < 0$.
   *   Si $x = -2 + \sqrt{11}$, $h''(x) = 0$.
   *   Si $x \in ]-2 + \sqrt{11}, +\infty[$, $h''(x) > 0$.

3. **Limites de $h(x)$** :
   *   En $-2^+$ :
      $\lim_{x \to -2^+} (x^2 - 3x + 1) = (-2)^2 - 3(-2) + 1 = 4 + 6 + 1 = 11$.
      $\lim_{x \to -2^+} (x + 2) = 0^+$.
      Donc $\lim_{x \to -2^+} h(x) = \frac{11}{0^+} = +\infty$.
   *   En $+\infty$ :
      $h(x) = \frac{x^2 - 3x + 1}{x + 2}$. C''est une fonction rationnelle. La limite en $+\infty$ est celle du rapport des termes de plus haut degré :
      $\lim_{x \to +\infty} h(x) = \lim_{x \to +\infty} \frac{x^2}{x} = \lim_{x \to +\infty} x = +\infty$.

4. **Tableau de variations** :
   On calcule la valeur de $h(x)$ en $x = -2 + \sqrt{11}$ (valeur exacte ou approchée) :
   $h(-2 + \sqrt{11}) = \frac{(-2 + \sqrt{11})^2 - 3(-2 + \sqrt{11}) + 1}{(-2 + \sqrt{11}) + 2} = \frac{4 - 4\sqrt{11} + 11 + 6 - 3\sqrt{11} + 1}{\sqrt{11}} = \frac{22 - 7\sqrt{11}}{\sqrt{11}} = \frac{22\sqrt{11} - 77}{11} = 2\sqrt{11} - 7$.
   $2\sqrt{11} - 7 \approx 2(3.317) - 7 = 6.634 - 7 = -0.366$.

   :::TABLEAU_JSON
{
  "variable": "x",
  "bornes": ["-2", "-2 + \sqrt{11}", "+\infty"],
  "lignes": [
    { "nom": "$h''(x)$", "valeurs": ["-", "0", "+"], "type": "signes" },
    { "nom": "$h(x)$", "valeurs": ["+\infty", "\\searrow", "$2\sqrt{11} - 7$", "\\nearrow", "+\infty"], "type": "variations" }
  ]
}
:::

   La fonction $h$ est décroissante sur $]-2, -2 + \sqrt{11}]$ et croissante sur $[-2 + \sqrt{11}, +\infty[$. Elle admet un minimum local en $x = -2 + \sqrt{11}$, qui vaut $2\sqrt{11} - 7$.', '["Pour la dérivée, utilise la formule de dérivation d''un quotient : $\\left(\\frac{u}{v}\\right)'' = \\frac{u''v - uv''}{v^2}$. Identifie bien $u(x)$ et $v(x)$.","Pour le signe de $h''(x)$, le dénominateur est toujours positif. Il faudra étudier le signe du numérateur, qui sera un polynôme du second degré. Pense à calculer le discriminant $\\Delta$ pour trouver les racines.","Pour la limite en $-2^+$, le numérateur tend vers une valeur finie non nulle, et le dénominateur tend vers $0^+$.","Pour la limite en $+\\infty$, factorise par le terme de plus haut degré au numérateur et au dénominateur, ou utilise la règle des termes de plus haut degré pour les fonctions rationnelles.","N''oublie pas de calculer les valeurs de $h(x)$ aux points où la dérivée s''annule pour compléter ton tableau."]'::jsonb, '2025-12-27T11:29:17.048463+00:00'::timestamptz, '687b0d7c3542afbef2294bfbd7224197fa250bfff51b70d0bce15616b035ffe7', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('0a3ec64d-73f7-4118-bc92-9b5521d2597e', 'Calcul intégral', 'terminale', '{"contexte":"On considère l''intégrale suivante : $$I = \\int_0^1 (2x+1)e^x dx$$","questions":["Identifie les fonctions $u(x)$ et $v''(x)$ que tu vas utiliser pour l''intégration par parties. Justifie ton choix.","Détermine les expressions de $u''(x)$ et $v(x)$.","Applique la formule d''intégration par parties pour exprimer $I$.","Calcule la valeur exacte de l''intégrale $I$. Explique chaque étape de ton calcul."]}', 'Pour calculer l''intégrale $I = \int_0^1 (2x+1)e^x dx$, nous allons utiliser l''intégration par parties.

1. **Choix de $u(x)$ et $v''(x)$** :
Nous choisissons :
$u(x) = 2x+1$ (fonction algébrique, facile à dériver)
$v''(x) = e^x$ (fonction exponentielle, facile à intégrer)

2. **Détermination de $u''(x)$ et $v(x)$** :
Nous dérivons $u(x)$ et intégrons $v''(x)$ :
$u''(x) = 2$
$v(x) = e^x$

3. **Application de la formule d''intégration par parties** :
La formule est $\int_a^b u(x)v''(x)dx = [u(x)v(x)]_a^b - \int_a^b u''(x)v(x)dx$.
En l''appliquant ici :
$I = [(2x+1)e^x]_0^1 - \int_0^1 2e^x dx$

4. **Calcul de l''intégrale** :
Calculons d''abord la partie évaluée :
$[(2x+1)e^x]_0^1 = (2(1)+1)e^1 - (2(0)+1)e^0 = 3e - 1e^0 = 3e - 1$

Ensuite, calculons la deuxième intégrale :
$\int_0^1 2e^x dx = [2e^x]_0^1 = 2e^1 - 2e^0 = 2e - 2$

Enfin, combinons les deux parties pour trouver $I$ :
$I = (3e - 1) - (2e - 2)$
$I = 3e - 1 - 2e + 2$
$I = e + 1$

La valeur exacte de l''intégrale est $e+1$.', '["La formule d''intégration par parties est $\\int_a^b u(x)v''(x)dx = [u(x)v(x)]_a^b - \\int_a^b u''(x)v(x)dx$.","Pour choisir $u(x)$ et $v''(x)$, pense à la règle ''LIATE'' (Logarithme, Inverse trigonométrique, Algébrique, Trigonométrique, Exponentielle) pour la fonction $u(x)$.","N''oublie pas d''évaluer la partie $[u(x)v(x)]_a^b$ aux bornes de l''intégrale."]'::jsonb, '2025-12-27T16:46:15.472173+00:00'::timestamptz, '325ffe0bdb74ee7afd8fb96ed0e22e688ecb2eda8671ecb7f8055911a2c1656c', NULL),
('90771c72-7c70-4e0c-bfb5-c817e0632d2f', 'Compléments sur la dérivation', 'terminale', '{"questions":["Identifie clairement la fonction intérieure $v(x)$ et la fonction extérieure $u(X)$.","Calcule la dérivée $v''(x)$ de la fonction intérieure $v(x)$.","Calcule la dérivée $u''(X)$ de la fonction extérieure $u(X)$.","En utilisant la formule de dérivation des fonctions composées, détermine l''expression de $f''(x)$.","Simplifie l''expression de $f''(x)$ au maximum."],"contexte":"Soit la fonction $f$ définie sur $I = ]-\\frac{1}{2}; +\\infty[$ par $f(x) = \\sqrt{4x^2 + 4x + 10}$."}', '1. Identification des fonctions :
   Fonction intérieure : $v(x) = 4x^2 + 4x + 10$
   Fonction extérieure : $u(X) = \sqrt{X}$

2. Dérivée de la fonction intérieure :
   $v(x) = 4x^2 + 4x + 10$
   $v''(x) = 8x + 4$

3. Dérivée de la fonction extérieure :
   $u(X) = \sqrt{X}$
   $u''(X) = \frac{1}{2\sqrt{X}}$

4. Application de la formule de dérivation des fonctions composées :
   $f''(x) = u''(v(x)) \times v''(x)$
   $f''(x) = \frac{1}{2\sqrt{4x^2 + 4x + 10}} \times (8x + 4)$

5. Simplification de l''expression de $f''(x)$ :
   $f''(x) = \frac{8x + 4}{2\sqrt{4x^2 + 4x + 10}}$
   $f''(x) = \frac{4(2x + 1)}{2\sqrt{4x^2 + 4x + 10}}$
   $f''(x) = \frac{2(2x + 1)}{\sqrt{4x^2 + 4x + 10}}$', '["Rappelle-toi que la dérivée de $\\sqrt{X}$ est $\\frac{1}{2\\sqrt{X}}$.","Applique la formule $f''(x) = u''(v(x)) \\times v''(x)$.","N''oublie pas de simplifier les fractions et les termes communs."]'::jsonb, '2025-12-27T17:00:11.70852+00:00'::timestamptz, '1b67dcaed62fa36ab61b68df7327c4f0add099c71e31d387aa399abfef2e3908', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('57f07b6d-53d6-4052-a385-f96ffb7e8036', 'Fonctions', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^3 - 3x^2 + 2x + 1$.","questions":["Calcule la dérivée première $f''(x)$ de la fonction $f$.","Calcule la dérivée seconde $f''''(x)$ de la fonction $f$.","Étudie le signe de $f''''(x)$.","Détermine les intervalles sur lesquels la fonction $f$ est convexe ou concave.","Donne les coordonnées des points d''inflexion de la courbe représentative de $f$."]}', '1. Dérivée première :
$f(x) = x^3 - 3x^2 + 2x + 1$
$f''(x) = 3x^2 - 6x + 2$

2. Dérivée seconde :
$f''''(x) = 6x - 6$

3. Signe de $f''''(x)$ :
$f''''(x) = 0 \iff 6x - 6 = 0 \iff 6x = 6 \iff x = 1$
Si $x > 1$, $f''''(x) > 0$
Si $x < 1$, $f''''(x) < 0$

4. Convexité et concavité :
La fonction $f$ est concave sur $]-\infty, 1]$ car $f''''(x) \le 0$ sur cet intervalle.
La fonction $f$ est convexe sur $[1, +\infty[$ car $f''''(x) \ge 0$ sur cet intervalle.

5. Points d''inflexion :
La dérivée seconde $f''''(x)$ change de signe en $x = 1$. Il y a donc un point d''inflexion en $x=1$.
Pour trouver l''ordonnée du point d''inflexion, on calcule $f(1)$ :
$f(1) = 1^3 - 3(1)^2 + 2(1) + 1 = 1 - 3 + 2 + 1 = 1$
Le point d''inflexion a pour coordonnées $(1, 1)$.', '["Pour la dérivée première, utilise la formule de dérivation des polynômes.","Pour la dérivée seconde, dérive $f''(x)$.","Pour le signe de $f''''(x)$, résous $f''''(x) > 0$ et $f''''(x) < 0$.","La fonction est convexe lorsque $f''''(x) \\ge 0$ et concave lorsque $f''''(x) \\le 0$.","Les points d''inflexion se trouvent là où la dérivée seconde change de signe."]'::jsonb, '2025-12-27T17:57:24.196492+00:00'::timestamptz, '276f014566752d1839b6ce43d2220699f1f33d84ad1da7bb49bf9d4335bded5e', NULL),
('0e793b15-1787-4320-9305-5e97eeffbfcd', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x^2 - 4x + 5)e^x$.","questions":["Calcule la dérivée première $f''(x)$ de la fonction $f$.","Calcule la dérivée seconde $f''''(x)$ de la fonction $f$.","Étudie le signe de $f''''(x)$.","Détermine les intervalles sur lesquels la fonction $f$ est convexe ou concave.","Donne les coordonnées du point d''inflexion de la courbe représentative de $f$."]}', '1. Calcul de la dérivée première $f''(x)$ :
Soit $u(x) = x^2 - 4x + 5$ et $v(x) = e^x$.
Alors $u''(x) = 2x - 4$ et $v''(x) = e^x$.
$f''(x) = u''(x)v(x) + u(x)v''(x) = (2x - 4)e^x + (x^2 - 4x + 5)e^x = (2x - 4 + x^2 - 4x + 5)e^x = (x^2 - 2x + 1)e^x = (x-1)^2e^x$.

2. Calcul de la dérivée seconde $f''''(x)$ :
Soit $u(x) = (x-1)^2$ et $v(x) = e^x$.
Alors $u''(x) = 2(x-1)$ et $v''(x) = e^x$.
$f''''(x) = u''(x)v(x) + u(x)v''(x) = 2(x-1)e^x + (x-1)^2e^x = (x-1)(2 + x - 1)e^x = (x-1)(x+1)e^x = (x^2 - 1)e^x$.

3. Étude du signe de $f''''(x)$ :
On sait que $e^x > 0$ pour tout $x \in \mathbb{R}$. Le signe de $f''''(x)$ est donc celui de $x^2 - 1$.
$x^2 - 1 = 0 \Leftrightarrow x = 1$ ou $x = -1$.
Le trinôme $x^2 - 1$ est positif à l''extérieur de ses racines et négatif entre ses racines.
Donc :
- $f''''(x) > 0$ pour $x \in ]-\infty, -1[ \cup ]1, +\infty[$
- $f''''(x) < 0$ pour $x \in ]-1, 1[$
- $f''''(x) = 0$ pour $x = -1$ ou $x = 1$.

4. Détermination des intervalles de convexité et concavité :
- Sur $]-\infty, -1[ \cup ]1, +\infty[$, $f''''(x) > 0$, donc $f$ est convexe.
- Sur $]-1, 1[$, $f''''(x) < 0$, donc $f$ est concave.

5. Coordonnées des points d''inflexion :
Les points d''inflexion se produisent lorsque $f''''(x)$ change de signe.
Cela se produit en $x = -1$ et $x = 1$.
- Pour $x = -1$ :
$f(-1) = ((-1)^2 - 4(-1) + 5)e^{-1} = (1 + 4 + 5)e^{-1} = 10e^{-1} = \frac{10}{e}$.
Le premier point d''inflexion est $A(-1, \frac{10}{e})$.
- Pour $x = 1$ :
$f(1) = (1^2 - 4(1) + 5)e^1 = (1 - 4 + 5)e = 2e$.
Le second point d''inflexion est $B(1, 2e)$.', '["Pour $f''(x)$, utilise la formule de dérivation d''un produit $(uv)'' = u''v + uv''$.","Pour $f''''(x)$, tu devras à nouveau utiliser la formule de dérivation d''un produit.","Pour le signe de $f''''(x)$, rappelle-toi que $e^x$ est toujours positif.","Un point d''inflexion se produit là où la convexité change, c''est-à-dire là où $f''''(x)$ change de signe."]'::jsonb, '2025-12-27T17:58:37.962077+00:00'::timestamptz, '2fdfbcfe269ce12dcbd6cc375ae2122cd84947e96b52ec7bde6e3a199cb28711', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('af7aa2d9-4e22-4d27-b1f2-33ea23367e76', 'Compléments sur la dérivation', 'terminale', '{"questions":["Calcule la dérivée première $f''(x)$ de la fonction $f$.","Calcule la dérivée seconde $f''''(x)$ de la fonction $f$.","Étudie le signe de $f''''(x)$.","Détermine les intervalles sur lesquels la fonction $f$ est convexe ou concave.","Donne les coordonnées des points d''inflexion de la courbe représentative de $f$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (x^2 + 2x + 2)e^{-x}$."}', '1. Calcul de la dérivée première $f''(x)$ :
Soit $u(x) = x^2 + 2x + 2$ et $v(x) = e^{-x}$.
Alors $u''(x) = 2x + 2$ et $v''(x) = -e^{-x}$.
$f''(x) = u''(x)v(x) + u(x)v''(x) = (2x + 2)e^{-x} + (x^2 + 2x + 2)(-e^{-x}) = (2x + 2 - x^2 - 2x - 2)e^{-x} = (-x^2)e^{-x}$.

2. Calcul de la dérivée seconde $f''''(x)$ :
Soit $u(x) = -x^2$ et $v(x) = e^{-x}$.
Alors $u''(x) = -2x$ et $v''(x) = -e^{-x}$.
$f''''(x) = u''(x)v(x) + u(x)v''(x) = (-2x)e^{-x} + (-x^2)(-e^{-x}) = (-2x + x^2)e^{-x} = x(x - 2)e^{-x}$.

3. Étude du signe de $f''''(x)$ :
On sait que $e^{-x} > 0$ pour tout $x \in \mathbb{R}$. Le signe de $f''''(x)$ est donc celui de $x(x - 2)$.
$x(x - 2) = 0 \Leftrightarrow x = 0$ ou $x = 2$.
Le trinôme $x(x - 2)$ est positif à l''extérieur de ses racines et négatif entre ses racines.
Donc :
- $f''''(x) > 0$ pour $x \in ]-\infty, 0[ \cup ]2, +\infty[$
- $f''''(x) < 0$ pour $x \in ]0, 2[$
- $f''''(x) = 0$ pour $x = 0$ ou $x = 2$.

4. Détermination des intervalles de convexité et concavité :
- Sur $]-\infty, 0[ \cup ]2, +\infty[$, $f''''(x) > 0$, donc $f$ est convexe.
- Sur $]0, 2[$, $f''''(x) < 0$, donc $f$ est concave.

5. Coordonnées des points d''inflexion :
Les points d''inflexion se produisent lorsque $f''''(x)$ change de signe.
Cela se produit en $x = 0$ et $x = 2$.
- Pour $x = 0$ :
$f(0) = (0^2 + 2(0) + 2)e^{-0} = 2e^0 = 2$.
Le premier point d''inflexion est $A(0, 2)$.
- Pour $x = 2$ :
$f(2) = (2^2 + 2(2) + 2)e^{-2} = (4 + 4 + 2)e^{-2} = 10e^{-2} = \frac{10}{e^2}$.
Le second point d''inflexion est $B(2, \frac{10}{e^2})$.', '["Pour $f''(x)$, utilise la formule de dérivation d''un produit $(uv)'' = u''v + uv''$. Fais attention à la dérivée de $e^{-x}$.","Pour $f''''(x)$, tu devras à nouveau utiliser la formule de dérivation d''un produit. Simplifie bien les expressions.","Pour le signe de $f''''(x)$, rappelle-toi que $e^{-x}$ est toujours positif. Concentre-toi sur le signe du polynôme.","Un point d''inflexion se produit là où la convexité change, c''est-à-dire là où $f''''(x)$ s''annule et change de signe."]'::jsonb, '2025-12-27T18:04:35.130109+00:00'::timestamptz, 'cd877abad14f45dc9121b55059ad1c40d6c8ea1d56f6929eaad49656d8c53832', NULL),
('b2897b83-4a05-4c95-9d4a-b30a6c489ec5', 'Suites numériques et raisonnement par récurrence', 'terminale', '{"contexte":"Soit la suite $(U_n)$ définie par $U_0 = 1$ et $U_{n+1} = \\frac{4U_n + 2}{U_n + 3}$ pour tout entier naturel $n$.","questions":["Démontre par récurrence que pour tout entier naturel $n$, $U_n \\ge 1$.","Démontre par récurrence que pour tout entier naturel $n$, $U_n < 2$.","Démontre que la suite $(U_n)$ est strictement croissante.","Déduis-en que la suite $(U_n)$ converge et détermine sa limite.","Soit la suite $(V_n)$ définie pour tout entier naturel $n$ par $V_n = \\frac{U_n - 2}{U_n + 1}$. Démontre que la suite $(V_n)$ est une suite géométrique dont tu préciseras la raison et le premier terme.","Exprime $V_n$ en fonction de $n$, puis $U_n$ en fonction de $n$."]}', '1. Démontrons par récurrence que pour tout $n \in \mathbb{N}$, $U_n \ge 1$.
Initialisation : Pour $n=0$, $U_0 = 1$, donc $U_0 \ge 1$. La propriété est vraie au rang 0.
Hérédité : Supposons que pour un certain $k \in \mathbb{N}$, $U_k \ge 1$. Montrons que $U_{k+1} \ge 1$.
$U_{k+1} - 1 = \frac{4U_k + 2}{U_k + 3} - 1 = \frac{4U_k + 2 - (U_k + 3)}{U_k + 3} = \frac{3U_k - 1}{U_k + 3}$.
Puisque $U_k \ge 1$, alors $3U_k - 1 \ge 3(1) - 1 = 2 > 0$. De plus, $U_k + 3 \ge 1 + 3 = 4 > 0$.
Donc $U_{k+1} - 1 > 0$, ce qui signifie $U_{k+1} \ge 1$. La propriété est héréditaire.
Conclusion : Par le principe de récurrence, pour tout $n \in \mathbb{N}$, $U_n \ge 1$.

2. Démontrons par récurrence que pour tout $n \in \mathbb{N}$, $U_n < 2$.
Initialisation : Pour $n=0$, $U_0 = 1$, donc $U_0 < 2$. La propriété est vraie au rang 0.
Hérédité : Supposons que pour un certain $k \in \mathbb{N}$, $U_k < 2$. Montrons que $U_{k+1} < 2$.
$U_{k+1} - 2 = \frac{4U_k + 2}{U_k + 3} - 2 = \frac{4U_k + 2 - 2(U_k + 3)}{U_k + 3} = \frac{4U_k + 2 - 2U_k - 6}{U_k + 3} = \frac{2U_k - 4}{U_k + 3} = \frac{2(U_k - 2)}{U_k + 3}$.
Puisque $U_k < 2$, alors $U_k - 2 < 0$. De plus, d''après la question 1, $U_k \ge 1$, donc $U_k + 3 > 0$.
Donc $U_{k+1} - 2 < 0$, ce qui signifie $U_{k+1} < 2$. La propriété est héréditaire.
Conclusion : Par le principe de récurrence, pour tout $n \in \mathbb{N}$, $U_n < 2$.

3. Démontrons que la suite $(U_n)$ est strictement croissante.
Étudions le signe de $U_{n+1} - U_n$ :
$U_{n+1} - U_n = \frac{4U_n + 2}{U_n + 3} - U_n = \frac{4U_n + 2 - U_n(U_n + 3)}{U_n + 3} = \frac{4U_n + 2 - U_n^2 - 3U_n}{U_n + 3} = \frac{-U_n^2 + U_n + 2}{U_n + 3}$.
Le dénominateur $U_n + 3$ est positif puisque $U_n \ge 1$.
Étudions le signe du numérateur $-U_n^2 + U_n + 2$. Cherchons les racines du trinôme $-x^2 + x + 2 = 0$. Le discriminant est $\Delta = 1^2 - 4(-1)(2) = 1 + 8 = 9$. Les racines sont $x_1 = \frac{-1 - \sqrt{9}}{2(-1)} = \frac{-1 - 3}{-2} = 2$ et $x_2 = \frac{-1 + \sqrt{9}}{2(-1)} = \frac{-1 + 3}{-2} = -1$.
Le trinôme $-x^2 + x + 2$ est positif entre ses racines $-1$ et $2$. Puisque pour tout $n$, $1 \le U_n < 2$, on a $-1 < U_n < 2$. Donc $-U_n^2 + U_n + 2 > 0$.
Par conséquent, $U_{n+1} - U_n > 0$, ce qui signifie que la suite $(U_n)$ est strictement croissante.

4. Déduisons-en que la suite $(U_n)$ converge et déterminons sa limite.
La suite $(U_n)$ est croissante (question 3) et majorée par 2 (question 2). D''après le théorème de convergence des suites monotones et bornées, la suite $(U_n)$ converge vers une limite $\ell$.
Puisque $U_{n+1} = \frac{4U_n + 2}{U_n + 3}$, en passant à la limite, on a $\ell = \frac{4\ell + 2}{\ell + 3}$.
$\ell(\ell + 3) = 4\ell + 2$
$\ell^2 + 3\ell = 4\ell + 2$
$\ell^2 - \ell - 2 = 0$.
Les racines de cette équation sont $\ell_1 = \frac{1 - \sqrt{1 - 4(1)(-2)}}{2} = \frac{1 - \sqrt{9}}{2} = \frac{1 - 3}{2} = -1$ et $\ell_2 = \frac{1 + \sqrt{9}}{2} = \frac{1 + 3}{2} = 2$.
Puisque $U_n \ge 1$ pour tout $n$, la limite $\ell$ doit être supérieure ou égale à 1. Donc $\ell = 2$.

5. Démontrons que la suite $(V_n)$ est une suite géométrique.
$V_{n+1} = \frac{U_{n+1} - 2}{U_{n+1} + 1}$.
On remplace $U_{n+1}$ par son expression : $U_{n+1} = \frac{4U_n + 2}{U_n + 3}$.
$U_{n+1} - 2 = \frac{4U_n + 2}{U_n + 3} - 2 = \frac{4U_n + 2 - 2(U_n + 3)}{U_n + 3} = \frac{2U_n - 4}{U_n + 3}$.
$U_{n+1} + 1 = \frac{4U_n + 2}{U_n + 3} + 1 = \frac{4U_n + 2 + (U_n + 3)}{U_n + 3} = \frac{5U_n + 5}{U_n + 3}$.
Donc $V_{n+1} = \frac{\frac{2U_n - 4}{U_n + 3}}{\frac{5U_n + 5}{U_n + 3}} = \frac{2U_n - 4}{5U_n + 5} = \frac{2(U_n - 2)}{5(U_n + 1)} = \frac{2}{5} \times \frac{U_n - 2}{U_n + 1} = \frac{2}{5} V_n$.
La suite $(V_n)$ est une suite géométrique de raison $q = \frac{2}{5}$.
Calculons le premier terme $V_0$ :
$V_0 = \frac{U_0 - 2}{U_0 + 1} = \frac{1 - 2}{1 + 1} = \frac{-1}{2}$.

6. Exprimons $V_n$ en fonction de $n$, puis $U_n$ en fonction de $n$.
Puisque $(V_n)$ est une suite géométrique de premier terme $V_0 = -\frac{1}{2}$ et de raison $q = \frac{2}{5}$, on a $V_n = V_0 q^n = -\frac{1}{2} \left(\frac{2}{5}\right)^n$.
Maintenant, exprimons $U_n$ en fonction de $n$ :
$V_n = \frac{U_n - 2}{U_n + 1}$.
$V_n(U_n + 1) = U_n - 2$
$V_n U_n + V_n = U_n - 2$
$V_n U_n - U_n = -2 - V_n$
$U_n(V_n - 1) = -2 - V_n$
$U_n = \frac{-2 - V_n}{V_n - 1} = \frac{2 + V_n}{1 - V_n}$.
En remplaçant $V_n$ par son expression :
$U_n = \frac{2 - \frac{1}{2} \left(\frac{2}{5}\right)^n}{1 - \left(-\frac{1}{2} \left(\frac{2}{5}\right)^n\right)} = \frac{2 - \frac{1}{2} \left(\frac{2}{5}\right)^n}{1 + \frac{1}{2} \left(\frac{2}{5}\right)^n}$.', '["Pour la première question, pense à étudier la fonction $f(x) = \\frac{4x+2}{x+3}$ sur l''intervalle $[1, 2]$.","Pour démontrer que $U_n < 2$, tu peux aussi étudier le signe de $U_{n+1} - 2$.","Pour la monotonie, étudie le signe de $U_{n+1} - U_n$.","Pour la convergence, rappelle-toi le théorème de convergence des suites monotones et bornées.","Pour la suite géométrique, calcule $V_{n+1}$ en fonction de $V_n$ et simplifie l''expression."]'::jsonb, '2025-12-28T15:16:45.226112+00:00'::timestamptz, 'ec77a0bf8f42b75dfb5d4af59860700cefce5de9a0cef3beca039681dd54faa3', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('131be2f3-aa5e-4c6d-89a2-fbff6fbc0620', 'Exercice', 'terminale', '{"contexte":"","questions":["Me poser une question sur cette expression ?","Me demander de calculer quelque chose avec ?"]}', 'À résoudre', '[]'::jsonb, '2025-12-28T15:19:18.434358+00:00'::timestamptz, '56172591a992aed9ae4212de695af142b780dcc936a51b68659887c8e9b4373d', NULL),
('09738b07-8767-44c1-99c2-4bdc8c977848', 'Fonction logarithme népérien', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $]0 ; +\\infty[$ par $f(x) = x \\ln(x) - x$.","questions":["Calcule la dérivée $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ et détermine les variations de $f$.","Calcule la limite de $f(x)$ quand $x \\to 0^+$ et quand $x \\to +\\infty$.","Dresse le tableau de variations complet de $f$.","Montre que l''équation $f(x) = 0$ admet une unique solution $\\alpha$ sur $]0 ; +\\infty[$. Justifie ta réponse en utilisant le théorème des valeurs intermédiaires.","Donne un encadrement de $\\alpha$ à $10^{-2}$ près."]}', '1. Dérivée de $f(x) = x \ln(x) - x$ :
   On utilise la formule $(uv)'' = u''v + uv''$ pour $x \ln(x)$ avec $u(x) = x$ et $v(x) = \ln(x)$.
   $u''(x) = 1$ et $v''(x) = \frac{1}{x}$.
   Donc $(x \ln(x))'' = 1 \cdot \ln(x) + x \cdot \frac{1}{x} = \ln(x) + 1$.
   La dérivée de $-x$ est $-1$.
   Ainsi, $f''(x) = \ln(x) + 1 - 1 = \ln(x)$.

2. Signe de $f''(x)$ et variations de $f$ :
   $f''(x) = \ln(x)$.
   $f''(x) > 0 \iff \ln(x) > 0 \iff x > e^0 \iff x > 1$.
   $f''(x) < 0 \iff \ln(x) < 0 \iff x < e^0 \iff x < 1$.
   $f''(x) = 0 \iff \ln(x) = 0 \iff x = 1$.
   Donc $f$ est décroissante sur $]0 ; 1]$ et croissante sur $[1 ; +\infty[$.

3. Limites :
   Quand $x \to 0^+$ :
   $\lim_{x \to 0^+} x \ln(x) = 0$ (limite de référence).
   $\lim_{x \to 0^+} -x = 0$.
   Donc $\lim_{x \to 0^+} f(x) = 0$.
   Quand $x \to +\infty$ :
   $f(x) = x(\ln(x) - 1)$.
   $\lim_{x \to +\infty} x = +\infty$.
   $\lim_{x \to +\infty} (\ln(x) - 1) = +\infty$.
   Donc $\lim_{x \to +\infty} f(x) = +\infty$.

4. Tableau de variations :
   $x$ | $0$ | $1$ | $+ \infty$
   ---|---|---|---
   $f''(x)$ | | $-$ | $0$ | $+$ |
   $f(x)$ | $0$ | $\searrow$ | $-1$ | $\nearrow$ | $+ \infty$
   (Note : $f(1) = 1 \ln(1) - 1 = 0 - 1 = -1$)

5. Solution de $f(x) = 0$ :
   Sur $]0 ; 1]$, $f$ est continue et strictement décroissante de $0$ à $-1$. L''équation $f(x) = 0$ n''admet donc pas de solution sur cet intervalle (car $0$ n''est pas compris entre $0$ et $-1$ si on considère l''image de l''intervalle).
   Sur $[1 ; +\infty[$, $f$ est continue et strictement croissante de $-1$ à $+ \infty$.
   Comme $0 \in [-1 ; +\infty[$, d''après le théorème des valeurs intermédiaires, l''équation $f(x) = 0$ admet une unique solution $\alpha$ sur $[1 ; +\infty[$.
   Donc, l''équation $f(x) = 0$ admet une unique solution $\alpha$ sur $]0 ; +\infty[$.

6. Encadrement de $\alpha$ à $10^{-2}$ près :
   $f(3.59) \approx -0.003$
   $f(3.60) \approx 0.002$
   Donc $3.59 < \alpha < 3.60$.', '["Pour la dérivée de $x \\ln(x)$, pense à la formule de dérivation d''un produit.","Pour la limite en $0^+$, la limite de $x \\ln(x)$ est une limite de référence.","Pour l''encadrement de $\\alpha$, tu peux utiliser une calculatrice et le théorème des valeurs intermédiaires.","N''oublie pas de bien justifier l''unicité de la solution avec la stricte monotonie de la fonction."]'::jsonb, '2025-12-29T23:14:44.182742+00:00'::timestamptz, 'e76b1f1b79c335a4fc36cc77bc4a721145d34bfb487800fffca65c385f6ec0c7', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('d83a5f33-4002-457a-92ab-35a01afd94fc', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x^2 - 2x + 1)^4$.","questions":["Identifie la fonction extérieure $u$ et la fonction intérieure $v$ telles que $f(x) = u(v(x))$.","Calcule la dérivée $v''(x)$ de la fonction $v$.","Calcule la dérivée $u''(y)$ de la fonction $u$ (où $y = v(x)$).","En utilisant la formule de dérivation des fonctions composées, donne l''expression de $f''(x)$.","Simplifie l''expression de $f''(x)$."]}', '1. On a $f(x) = u(v(x))$ avec $v(x) = 3x^2 - 2x + 1$ et $u(y) = y^4$.
2. La dérivée de $v(x)$ est $v''(x) = 6x - 2$.
3. La dérivée de $u(y)$ est $u''(y) = 4y^3$.
4. En utilisant la formule $(u(v(x)))'' = u''(v(x)) \times v''(x)$, on obtient :
$f''(x) = 4(3x^2 - 2x + 1)^3 \times (6x - 2)$.
5. On peut simplifier en factorisant par 2 dans $(6x-2)$ :
$f''(x) = 4(3x^2 - 2x + 1)^3 \times 2(3x - 1)$
$f''(x) = 8(3x - 1)(3x^2 - 2x + 1)^3$.', '["La fonction $f$ est de la forme $y^n$. Quel est $y$ et quel est $n$ ?","La dérivée de $x^n$ est $nx^{n-1}$.","La formule de dérivation d''une fonction composée est $(u(v(x)))'' = u''(v(x)) \\times v''(x)$.","N''oublie pas de laisser l''expression de $v(x)$ intacte dans $u''(v(x))$ avant de multiplier par $v''(x)$."]'::jsonb, '2025-12-30T10:47:03.40064+00:00'::timestamptz, 'fbd1d1d86e6b3ccfe8d7365b5dc327c03899e0a3da4658084cb21961e7dcefce', NULL),
('bf6f29a3-6a8e-4920-86a7-857fe515478b', 'Compléments sur la dérivation', 'terminale', '{"questions":["Identifie la fonction extérieure $u$ et la fonction intérieure $v$ telles que $f(x) = u(v(x))$.","Détermine les expressions de $u''(y)$ et $v''(x)$.","Utilise la formule de dérivation d''une fonction composée pour calculer $f''(x)$.","Simplifie l''expression de $f''(x)$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x^2 - 5x + 1)^4$."}', '1. Identification des fonctions :
La fonction $f(x) = (3x^2 - 5x + 1)^4$ est de la forme $u(v(x))$.
On pose $v(x) = 3x^2 - 5x + 1$ (fonction intérieure).
On pose $u(y) = y^4$ (fonction extérieure).

2. Dérivées des fonctions :
Pour $u(y) = y^4$, la dérivée est $u''(y) = 4y^3$.
Pour $v(x) = 3x^2 - 5x + 1$, la dérivée est $v''(x) = 6x - 5$.

3. Calcul de $f''(x)$ :
En utilisant la formule $(u \circ v)''(x) = u''(v(x)) \times v''(x)$ :
$f''(x) = 4(3x^2 - 5x + 1)^3 \times (6x - 5)$.

4. Simplification de $f''(x)$ :
$f''(x) = (24x - 20)(3x^2 - 5x + 1)^3$.', '["La formule de dérivation d''une fonction composée est $(u \\circ v)''(x) = u''(v(x)) \\times v''(x)$.","Pour $u(y) = y^n$, la dérivée est $u''(y) = ny^{n-1}$.","N''oublie pas de dériver $v(x)$ correctement."]'::jsonb, '2025-12-30T10:49:11.390027+00:00'::timestamptz, 'b4b955f9e2b2f207a403b2b2deea8f30c357783a8f1cc2c990b13127df7bd952', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('deab79b7-b213-4b8e-a705-fb2c2e8adb53', 'Calcul intégral', 'terminale', '{"questions":["Détermine une primitive $F$ de la fonction $f$ sur $\\mathbb{R}$.","Calcule l''intégrale $I = \\int_0^1 f(x)dx$."],"contexte":"On considère la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (2x+1)e^{x^2+x}$."}', '1. On reconnaît la forme $u''e^u$ avec $u(x) = x^2+x$. La dérivée de $u(x)$ est $u''(x) = 2x+1$. 
Donc, une primitive de $f(x) = (2x+1)e^{x^2+x}$ est $F(x) = e^{x^2+x}$.

2. Pour calculer l''intégrale $I = \int_0^1 f(x)dx$, on utilise la primitive $F(x) = e^{x^2+x}$.
$I = [F(x)]_0^1 = F(1) - F(0)$
$F(1) = e^{1^2+1} = e^2$
$F(0) = e^{0^2+0} = e^0 = 1$
Donc $I = e^2 - 1$.', '["Pense à la forme $u''e^u$.","Pour le calcul de l''intégrale, utilise la primitive que tu as trouvée et le théorème fondamental de l''analyse."]'::jsonb, '2025-12-30T10:51:19.271981+00:00'::timestamptz, 'f6ff981577627259889e74e733e53074beae71d334b11d1497019100bef3b423', NULL),
('07d77dc1-bc67-4dc9-8626-f47f43e6c1cb', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^4 - 6x^2 + 2x - 1$.","questions":["Calcule la dérivée première $f''(x)$ de la fonction $f$.","Calcule la dérivée seconde $f''''(x)$ de la fonction $f$.","Étudie le signe de la dérivée seconde $f''''(x)$.","Déduis-en les intervalles sur lesquels la fonction $f$ est convexe ou concave.","Détermine les éventuels points d''inflexion de la courbe représentative de $f$."]}', '1. Calcul de la dérivée première :
$f(x) = x^4 - 6x^2 + 2x - 1$
$f''(x) = 4x^3 - 12x + 2$

2. Calcul de la dérivée seconde :
$f''''(x) = 12x^2 - 12$

3. Étude du signe de la dérivée seconde :
On cherche quand $f''''(x) > 0$
$12x^2 - 12 > 0$
$12(x^2 - 1) > 0$
$x^2 - 1 > 0$
$(x-1)(x+1) > 0$
Le trinôme $x^2 - 1$ est positif à l''extérieur de ses racines $-1$ et $1$.
Donc $f''''(x) > 0$ pour $x \in ]-\infty; -1[ \cup ]1; +\infty[$.
Et $f''''(x) < 0$ pour $x \in ]-1; 1[$.

4. Déduction des intervalles de convexité et concavité :
La fonction $f$ est convexe sur $]-\infty; -1[ \cup ]1; +\infty[$ car $f''''(x) > 0$.
La fonction $f$ est concave sur $]-1; 1[$ car $f''''(x) < 0$.

5. Détermination des points d''inflexion :
Les points d''inflexion se produisent lorsque la dérivée seconde s''annule et change de signe.
$f''''(x) = 0 \implies 12x^2 - 12 = 0 \implies x^2 = 1 \implies x = -1$ ou $x = 1$.
Pour $x = -1$ :
$f(-1) = (-1)^4 - 6(-1)^2 + 2(-1) - 1 = 1 - 6 - 2 - 1 = -8$.
Le point d''inflexion est $(-1; -8)$.
Pour $x = 1$ :
$f(1) = (1)^4 - 6(1)^2 + 2(1) - 1 = 1 - 6 + 2 - 1 = -4$.
Le point d''inflexion est $(1; -4)$.', '["Pour la dérivée d''un polynôme, souviens-toi de la règle $(x^n)'' = nx^{n-1}$.","La convexité est liée au signe de la dérivée seconde.","Un point d''inflexion est un point où la convexité change."]'::jsonb, '2025-12-31T13:08:54.206044+00:00'::timestamptz, '92d3129087d031d137fa66e14487f078dcaad8c09aeeb936c3c799a073871097', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('91bdaac3-d22a-4d74-881e-682e8461fe31', 'Compléments sur la dérivation', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = (3x^2 - 5x + 1)^4$.","questions":["Identifie la fonction extérieure $u$ et la fonction intérieure $v$ telles que $f(x) = u(v(x))$.","Calcule la dérivée de la fonction intérieure $v''(x)$.","Calcule la dérivée de la fonction extérieure $u''(y)$ (où $y = v(x)$).","En utilisant la formule de dérivation des fonctions composées, $f''(x) = u''(v(x)) \\times v''(x)$, détermine l''expression de $f''(x)$."]}', '1. On a $f(x) = (3x^2 - 5x + 1)^4$. On peut identifier :
   - La fonction intérieure $v(x) = 3x^2 - 5x + 1$
   - La fonction extérieure $u(y) = y^4$

2. Dérivée de la fonction intérieure $v(x)$ :
   $v''(x) = \frac{d}{dx}(3x^2 - 5x + 1) = 6x - 5$

3. Dérivée de la fonction extérieure $u(y)$ :
   $u''(y) = \frac{d}{dy}(y^4) = 4y^3$

4. Application de la formule $f''(x) = u''(v(x)) \times v''(x)$ :
   $f''(x) = 4(3x^2 - 5x + 1)^3 \times (6x - 5)$
   $f''(x) = (24x - 20)(3x^2 - 5x + 1)^3$', '["Rappelle-toi la forme générale de la dérivée d''une fonction composée : $(u \\circ v)'' = u'' \\circ v \\times v''$.","Pour $u(y) = y^n$, la dérivée est $u''(y) = ny^{n-1}$.","Pour $v(x) = ax^2 + bx + c$, la dérivée est $v''(x) = 2ax + b$."]'::jsonb, '2025-12-31T13:09:15.802886+00:00'::timestamptz, '4f186f1a5327e4c73e5447ccaac6c5512c16b953f80a5fd5191a667f87faacc9', NULL),
('a1fda3a0-5926-46e4-a95a-1127f87dd66c', 'Géométrie repérée dans l''espace', 'terminale', '{"contexte":"Résous le système d''équations linéaires suivant en utilisant la méthode du pivot de Gauss : \n\n$$\\begin{cases} x + 2y - z = 1 \\ 2x - y + 3z = 4 \\ 3x + y + 2z = 5 \\end{cases}$$","questions":["1. Écris la matrice augmentée associée au système.","2. Applique les opérations élémentaires sur les lignes pour obtenir une forme échelonnée.","3. Résous le système échelonné pour trouver les valeurs de $x$, $y$ et $z$."]}', '1. La matrice augmentée est : 
$$\begin{pmatrix} 1 & 2 & -1 & | & 1 \ 2 & -1 & 3 & | & 4 \ 3 & 1 & 2 & | & 5 \end{pmatrix}$$

2. Opérations élémentaires sur les lignes :
   - $L_2 \leftarrow L_2 - 2L_1$ : 
   $$\begin{pmatrix} 1 & 2 & -1 & | & 1 \ 0 & -5 & 5 & | & 2 \ 3 & 1 & 2 & | & 5 \end{pmatrix}$$
   - $L_3 \leftarrow L_3 - 3L_1$ : 
   $$\begin{pmatrix} 1 & 2 & -1 & | & 1 \ 0 & -5 & 5 & | & 2 \ 0 & -5 & 5 & | & 2 \end{pmatrix}$$
   - $L_3 \leftarrow L_3 - L_2$ : 
   $$\begin{pmatrix} 1 & 2 & -1 & | & 1 \ 0 & -5 & 5 & | & 2 \ 0 & 0 & 0 & | & 0 \end{pmatrix}$$

3. Le système échelonné correspondant est : 
   $$\begin{cases} x + 2y - z = 1 \ -5y + 5z = 2 \ 0 = 0 \end{cases}$$
   La dernière équation $0=0$ indique que le système admet une infinité de solutions. On peut exprimer $y$ en fonction de $z$ à partir de la deuxième équation : 
   $-5y = 2 - 5z \Rightarrow y = -\frac{2}{5} + z$
   Ensuite, on substitue $y$ dans la première équation : 
   $x + 2(-\frac{2}{5} + z) - z = 1$
   $x - \frac{4}{5} + 2z - z = 1$
   $x + z = 1 + \frac{4}{5}$
   $x = \frac{9}{5} - z$

   Les solutions sont de la forme $(x, y, z) = (\frac{9}{5} - z, -\frac{2}{5} + z, z)$, où $z$ est un réel quelconque. On peut aussi écrire les solutions sous forme paramétrique en posant $z = k$ (avec $k \in \mathbb{R}$) : 
   $$\begin{cases} x = \frac{9}{5} - k \ y = -\frac{2}{5} + k \ z = k \end{cases}$$', '["Pour la première étape, transforme le système en une matrice augmentée. Chaque ligne de la matrice correspond à une équation, et chaque colonne correspond à une variable ($x$, $y$, $z$) ou au terme constant.","Pour la deuxième étape, l''objectif est de faire apparaître des zéros sous la diagonale principale. Commence par utiliser la première ligne pour éliminer les $x$ dans les lignes suivantes. Ensuite, utilise la nouvelle deuxième ligne pour éliminer le $y$ dans la troisième ligne.","Pour la troisième étape, une fois que ta matrice est sous forme échelonnée, tu peux résoudre le système en commençant par la dernière équation (qui ne contient qu''une seule variable), puis remonter pour trouver les autres variables."]'::jsonb, '2026-01-02T13:48:54.51338+00:00'::timestamptz, '0cc956bb4543751261980fbe3a20e38c81b6e7e21c45903c61ba68c939647e58', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('ba3b7c41-01ba-4108-8f14-36d895e46173', 'Suites numériques', 'premiere', '{"contexte":"Soit la suite $(u_n)$ définie par $u_0 = 1$ et, pour tout entier naturel $n$, $u_{n+1} = 2u_n + 3$. On définit la suite $(v_n)$ par $v_n = u_n + 3$.","questions":["1. Calcule les trois premiers termes de la suite $(u_n)$ : $u_0$, $u_1$ et $u_2$.","2. Démontre que la suite $(v_n)$ est une suite géométrique. Précise sa raison et son premier terme.","3. Exprime $v_n$ en fonction de $n$, puis $u_n$ en fonction de $n$."]}', '1. $u_0 = 1$
$u_1 = 2u_0 + 3 = 2(1) + 3 = 5$
$u_2 = 2u_1 + 3 = 2(5) + 3 = 13$

2. On sait que $v_n = u_n + 3$, donc $u_n = v_n - 3$. 
$v_{n+1} = u_{n+1} + 3$
$v_{n+1} = (2u_n + 3) + 3$
$v_{n+1} = 2u_n + 6$
En remplaçant $u_n$ par $v_n - 3$ :
$v_{n+1} = 2(v_n - 3) + 6$
$v_{n+1} = 2v_n - 6 + 6$
$v_{n+1} = 2v_n$
La suite $(v_n)$ est donc une suite géométrique de raison $q = 2$. 
Son premier terme est $v_0 = u_0 + 3 = 1 + 3 = 4$.

3. Puisque $(v_n)$ est une suite géométrique de raison $q=2$ et de premier terme $v_0=4$, on a $v_n = v_0 \times q^n = 4 \times 2^n$.
Comme $u_n = v_n - 3$, on a $u_n = 4 \times 2^n - 3$.', '["Pour la question 2, exprime $v_{n+1}$ en fonction de $u_{n+1}$, puis remplace $u_{n+1}$ par son expression en fonction de $u_n$. Ensuite, essaie de faire apparaître $v_n$ dans l''expression.","Pour la question 3, utilise la formule du terme général d''une suite géométrique pour $v_n$, puis déduis-en $u_n$ grâce à la relation entre $u_n$ et $v_n$."]'::jsonb, '2026-01-02T15:15:20.430831+00:00'::timestamptz, '3b23c02456f108435fe4867567f2a36e3b3f76ed30609e978f44e6a8de0392db', NULL),
('9a65b2a8-79f3-49c6-b44c-55f8215e73e4', 'Compléments sur la dérivation', 'terminale', '{"questions":["Calcule $f''(x)$ pour tout réel $x$ de $[0; +\\infty[$. Rappelle-toi que la dérivée de $e^{u(x)}$ est $u''(x)e^{u(x)}$."],"contexte":"Le nombre d''abonnés à un journal (en milliers) est donné par la fonction $f$ définie sur $[0; +\\infty[$ par $f(x) = 3e^{-0,1x^2+0,7x}$ où $x$ est le temps (en années) écoulé depuis le 1er janvier 2015. On nomme $\\mathcal{C}_f$ la courbe représentative de $f$."}', 'Pour calculer $f''(x)$, on utilise la formule de dérivation de $k \cdot e^{u(x)}$, qui est $k \cdot u''(x)e^{u(x)}$.
Ici, $k=3$ et $u(x) = -0,1x^2 + 0,7x$.
Calculons $u''(x)$ :
$u''(x) = (-0,1x^2)'' + (0,7x)''$
$u''(x) = -0,1 \cdot (2x) + 0,7 \cdot 1$
$u''(x) = -0,2x + 0,7$

Maintenant, on peut calculer $f''(x)$ :
$f''(x) = 3 \cdot (-0,2x + 0,7)e^{-0,1x^2+0,7x}$
$f''(x) = ( -0,6x + 2,1)e^{-0,1x^2+0,7x}$', '["La fonction $u(x)$ dans $e^{u(x)}$ est $u(x) = -0,1x^2 + 0,7x$.","Pour dériver $u(x)$, utilise la formule de dérivation d''un polynôme : $(ax^n)'' = nax^{n-1}$ et $(ax)'' = a$."]'::jsonb, '2026-01-06T13:03:24.890198+00:00'::timestamptz, '5f3b6c60615036ec6fd0784d5b8d7d430f8cd5a773e061b16021b34f532cc3e4', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('bdeecc34-e72a-4c15-bbda-db3199db4260', 'Compléments sur la dérivation', 'terminale', '{"questions":["Calcule la dérivée première $f''(x)$ de la fonction $f$.","Calcule la dérivée seconde $f''''(x)$ de la fonction $f$.","Étudie le signe de la dérivée seconde $f''''(x)$.","Déduis-en les intervalles sur lesquels la fonction $f$ est convexe ou concave. Pour cela, tu peux représenter le tableau de signes de $f''''(x)$.","Détermine les éventuels points d''inflexion de la courbe représentative de $f$ en précisant leurs coordonnées."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^3 - 9x^2 + 24x - 10$."}', '1. Calcul de la dérivée première $f''(x)$ :
$f''(x) = 3x^2 - 18x + 24$

2. Calcul de la dérivée seconde $f''''(x)$ :
$f''''(x) = 6x - 18$

3. Étude du signe de la dérivée seconde $f''''(x)$ :
$f''''(x) = 0 \Leftrightarrow 6x - 18 = 0 \Leftrightarrow 6x = 18 \Leftrightarrow x = 3$.

*   Si $x < 3$, $f''''(x) < 0$.
*   Si $x > 3$, $f''''(x) > 0$.

4. Déduction des intervalles de convexité/concavité :

| $x$             | $-\infty$ | $3$ | $+\infty$ |
|-----------------|-----------|-----|-----------|
| Signe de $f''''(x)$ | $-$       | $0$ | $+$       |
| Convexité de $f$  | Concave   |     | Convexe   |

La fonction $f$ est concave sur $]-\infty, 3]$ et convexe sur $[3, +\infty[$.

5. Détermination des points d''inflexion :
La dérivée seconde $f''''(x)$ s''annule et change de signe en $x=3$. Il y a donc un point d''inflexion pour $x=3$.
Pour trouver l''ordonnée du point d''inflexion, on calcule $f(3)$ :
$f(3) = (3)^3 - 9(3)^2 + 24(3) - 10 = 27 - 81 + 72 - 10 = 8$.
Le point d''inflexion a pour coordonnées $(3, 8)$.', '["Pour la dérivée seconde, dérive $f''(x)$ comme tu as dérivé $f(x)$.","Pour le signe de $f''''(x)$, c''est une fonction affine, tu peux trouver sa racine et en déduire le signe.","Un point d''inflexion est là où la dérivée seconde s''annule et change de signe."]'::jsonb, '2026-01-08T15:53:46.013297+00:00'::timestamptz, '33da9edbf89603f440f237973730d887617e41cd27f3c9c03c882751bbe054d0', NULL),
('68ede3bd-4757-454c-b7a0-6e30d96f8d1b', 'Continuité', 'terminale', '{"questions":["Calcule la dérivée première $f''(x)$ de la fonction $f$.","Étudie le signe de $f''(x)$ pour déterminer le sens de variation de $f$.","Dresse le tableau de variations de la fonction $f$.","En utilisant le tableau de variations, démontre que l''équation $f(x) = 0$ admet une unique solution sur l''intervalle $[-2, 0]$.","Démontre que l''équation $f(x) = 0$ admet une unique solution sur l''intervalle $[0, 2]$.","Déduis-en le nombre total de solutions de l''équation $f(x) = 0$ sur $\\mathbb{R}$."],"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}$ par $f(x) = x^3 - 3x + 1$."}', '1. Calcul de la dérivée première :
$f''(x) = 3x^2 - 3$

2. Étude du signe de $f''(x)$ :
$f''(x) = 3(x^2 - 1) = 3(x-1)(x+1)$
$f''(x) = 0$ pour $x = 1$ et $x = -1$.
$f''(x) > 0$ sur $]-\infty, -1[ \cup ]1, +\infty[$
$f''(x) < 0$ sur $]-1, 1[$

3. Tableau de variations :
$f(-1) = (-1)^3 - 3(-1) + 1 = -1 + 3 + 1 = 3$
$f(1) = (1)^3 - 3(1) + 1 = 1 - 3 + 1 = -1$
$\lim_{x \to -\infty} f(x) = -\infty$
$\lim_{x \to +\infty} f(x) = +\infty$

| $x$ | $-\infty$ | $-1$ | $1$ | $+\infty$ |
|---|:---:|:---:|:---:|:---:|
| $f''(x)$ | $+$ | $0$ | $-$ | $0$ | $+$ |
| $f(x)$ | $-\infty$ $\nearrow$ $3$ $\searrow$ $-1$ $\nearrow$ $+\infty$ |

4. Sur l''intervalle $[-2, 0]$ :
La fonction $f$ est continue sur $[-2, 0]$.
Sur $[-2, -1]$, $f$ est strictement croissante de $f(-2) = (-2)^3 - 3(-2) + 1 = -8 + 6 + 1 = -1$ à $f(-1) = 3$. Puisque $0 \in [-1, 3]$, l''équation $f(x) = 0$ admet une unique solution sur $[-2, -1]$.
Sur $[-1, 0]$, $f$ est strictement décroissante de $f(-1) = 3$ à $f(0) = 1$. Puisque $0 \notin [1, 3]$, l''équation $f(x) = 0$ n''admet pas de solution sur $[-1, 0]$.
Donc, l''équation $f(x) = 0$ admet une unique solution sur $[-2, 0]$.

5. Sur l''intervalle $[0, 2]$ :
La fonction $f$ est continue sur $[0, 2]$.
Sur $[0, 1]$, $f$ est strictement décroissante de $f(0) = 1$ à $f(1) = -1$. Puisque $0 \in [-1, 1]$, l''équation $f(x) = 0$ admet une unique solution sur $[0, 1]$.
Sur $[1, 2]$, $f$ est strictement croissante de $f(1) = -1$ à $f(2) = (2)^3 - 3(2) + 1 = 8 - 6 + 1 = 3$. Puisque $0 \in [-1, 3]$, l''équation $f(x) = 0$ admet une unique solution sur $[1, 2]$.
Donc, l''équation $f(x) = 0$ admet une unique solution sur $[0, 2]$.

6. Conclusion :
En combinant les résultats des intervalles, l''équation $f(x) = 0$ admet trois solutions distinctes sur $\mathbb{R}$.', '["Pour le sens de variation, il faut étudier le signe de la dérivée.","N''oublie pas de calculer les images aux bornes des intervalles pour le tableau de variations.","Le Théorème des Valeurs Intermédiaires nécessite que la fonction soit continue et strictement monotone sur l''intervalle considéré."]'::jsonb, '2026-01-08T19:02:07.095632+00:00'::timestamptz, '1efac4eb841f15d3a79c472a10821ee9e416a66ef02558f2457ce0a9e6148a5b', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('4a3ae4f5-384d-4be6-bbf4-a9bd19735757', 'Continuité', 'terminale', '{"contexte":"Soit la fonction $f$ définie sur $\\mathbb{R}^*$ par $f(x) = x^2 + 1 + \\frac{1}{x}$.","questions":["1. Calcule la dérivée première $f''(x)$ de la fonction $f$.","2. Étudie le signe de $f''(x)$ pour déterminer le sens de variation de $f$.","3. Calcule les limites de $f(x)$ aux bornes de son ensemble de définition.","4. Dresse le tableau de variations de la fonction $f$.","5. En utilisant le tableau de variations, démontre que l''équation $f(x) = 0$ admet une unique solution sur l''intervalle $]-2, -1[$. On notera $\\alpha$ cette solution.","6. Déduis-en le nombre total de solutions de l''équation $f(x) = 0$ sur $\\mathbb{R}^*$."]}', '1. Calcul de la dérivée première :
$f''(x) = 2x - \frac{1}{x^2}$

2. Étude du signe de $f''(x)$ :
$f''(x) = \frac{2x^3 - 1}{x^2}$
Le signe de $f''(x)$ dépend du signe de $2x^3 - 1$ car $x^2 > 0$ sur $\mathbb{R}^*$.
Soit $g(x) = 2x^3 - 1$. $g''(x) = 6x^2 \geq 0$, donc $g$ est croissante sur $\mathbb{R}$.
$g(x) = 0 \iff 2x^3 = 1 \iff x^3 = \frac{1}{2} \iff x = \sqrt[3]{\frac{1}{2}} = \frac{1}{\sqrt[3]{2}}$.
Soit $x_0 = \frac{1}{\sqrt[3]{2}} \approx 0.79$.
$f''(x) < 0$ pour $x < x_0$ et $f''(x) > 0$ pour $x > x_0$.

3. Calcul des limites :
$\lim_{x \to -\infty} f(x) = \lim_{x \to -\infty} (x^2 + 1 + \frac{1}{x}) = +\infty + 1 + 0 = +\infty$
$\lim_{x \to 0^-} f(x) = \lim_{x \to 0^-} (x^2 + 1 + \frac{1}{x}) = 0 + 1 - \infty = -\infty$
$\lim_{x \to 0^+} f(x) = \lim_{x \to 0^+} (x^2 + 1 + \frac{1}{x}) = 0 + 1 + \infty = +\infty$
$\lim_{x \to +\infty} f(x) = \lim_{x \to +\infty} (x^2 + 1 + \frac{1}{x}) = +\infty + 1 + 0 = +\infty$

4. Tableau de variations :
$f(x_0) = (\frac{1}{\sqrt[3]{2}})^2 + 1 + \sqrt[3]{2} = \frac{1}{\sqrt[3]{4}} + 1 + \sqrt[3]{2} \approx 0.63 + 1 + 1.26 = 2.89$

| $x$ | $-\infty$ | $0$ | $x_0$ | $+\infty$ |
|---|:---:|:---:|:---:|:---:|
| $f''(x)$ | $-$ | $||$ | $-$ | $0$ | $+$ |
| $f(x)$ | $+\infty$ $\searrow$ $-\infty$ $||$ $+\infty$ $\searrow$ $f(x_0)$ $
earrow$ $+\infty$ |

5. Solution sur $]-2, -1[$ :
La fonction $f$ est continue sur $]-2, -1[$.
$f(-2) = (-2)^2 + 1 + \frac{1}{-2} = 4 + 1 - 0.5 = 4.5$
$f(-1) = (-1)^2 + 1 + \frac{1}{-1} = 1 + 1 - 1 = 1$
Sur $]-2, -1[$, la fonction $f$ est strictement décroissante (car $x_0 \approx 0.79$ est à droite de cet intervalle, et $f''(x) < 0$ pour $x < x_0$).
$f(-2) = 4.5$ et $f(-1) = 1$.
Puisque $0 
otin [1, 4.5]$, l''équation $f(x) = 0$ n''admet pas de solution sur $]-2, -1[$. Il y a une erreur dans l''énoncé de la question 5, qui devrait plutôt être $]-2, 0[$.

Reprenons la question 5 avec l''intervalle $]-\infty, 0[$ :
Sur $]-\infty, 0[$, $f$ est continue et strictement décroissante de $+\infty$ à $-\infty$. Puisque $0 \in ]-\infty, +\infty[$, l''équation $f(x) = 0$ admet une unique solution sur $]-\infty, 0[$. Cette solution est $\alpha$.  On peut affiner en disant que $f(-1) = 1$ et $f(-2) = 4.5$, donc $\alpha$ n''est pas dans $]-2, -1[$. Par contre $f(-1) = 1$ et $\lim_{x \to 0^-} f(x) = -\infty$. Donc $\alpha \in ]-1, 0[$.

6. Nombre total de solutions sur $\mathbb{R}^*$ :
Sur $]-\infty, 0[$, $f$ est continue et strictement décroissante de $+\infty$ à $-\infty$. Puisque $0 \in ]-\infty, +\infty[$, l''équation $f(x) = 0$ admet une unique solution $\alpha$ sur $]-\infty, 0[$.
Sur $]0, x_0[$, $f$ est continue et strictement décroissante de $+\infty$ à $f(x_0) \approx 2.89$. Puisque $0 
otin [2.89, +\infty[$, l''équation $f(x) = 0$ n''admet pas de solution sur $]0, x_0[$.
Sur $]x_0, +\infty[$, $f$ est continue et strictement croissante de $f(x_0) \approx 2.89$ à $+\infty$. Puisque $0 
otin [2.89, +\infty[$, l''équation $f(x) = 0$ n''admet pas de solution sur $]x_0, +\infty[$.

En conclusion, l''équation $f(x) = 0$ admet une unique solution sur $\mathbb{R}^*$ (cette solution est $\alpha$, et $\alpha \in ]-1, 0[$).', '["Pour la dérivée de $1/x$, souviens-toi de la formule $(1/u)'' = -u''/u^2$.","Pour étudier le signe de $f''(x)$, il peut être utile de factoriser l''expression ou de la mettre sur un dénominateur commun.","N''oublie pas de calculer les images aux bornes des intervalles pour le tableau de variations, ainsi que les limites aux bornes de l''ensemble de définition.","Le Théorème des Valeurs Intermédiaires nécessite que la fonction soit continue et strictement monotone sur l''intervalle considéré. Pense aussi à vérifier que 0 est bien compris entre les images des bornes de l''intervalle."]'::jsonb, '2026-01-08T19:06:14.664864+00:00'::timestamptz, '4d031fdcc4e5131aa59ee3ea70c50788e1762a459cf13980eb0a4d34c49fca14', NULL),
('85c51ed4-bdc3-483f-8c25-2849be03f79c', 'Exercice', 'terminale', '{"contexte":"","questions":["**Produit :** $\\ln(a \\times b) = \\ln(a) + \\ln(b)$","**Quotient :** $\\ln\\left(\\frac{a}{b}\\right) = \\ln(a) - \\ln(b)$","**Puissance :** $\\ln(a^n) = n \\times \\ln(a)$","**Inverse :** $\\ln\\left(\\frac{1}{a}\\right) = -\\ln(a)$","**Racine carrée :** $\\ln(\\sqrt{a}) = \\frac{1}{2}\\ln(a)$","**Conditions d''existence :**","**Égalité :**","**Vérification :** $x=4$ est bien supérieur à $\\frac{3}{2}$","On applique $\\ln$ des deux côtés :","$x = \\ln(5)$","**Condition d''existence :** $x > 0$","**Transformation :** On doit comparer $\\ln(x)$ avec un $\\ln$ de quelque chose","**Inégalité :**","**Intersection avec la condition d''existence :** $x > 0$ et $x < e^2$"]}', 'À résoudre', '[]'::jsonb, '2026-01-09T17:06:13.479982+00:00'::timestamptz, '5fa6fd34d3197082c479cd7035b35f3a3fcba82268263ba28bf0585e7607e668', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('1a34c804-145f-4143-b279-ae84a05827f3', 'Suites numériques', 'Première', '{"contexte":"Soit $(U_n)$ une suite arithmétique de premier terme $U_0 = 5$ et de raison $r = 3$.","questions":["1. Calcule les quatre premiers termes de la suite : $U_0$, $U_1$, $U_2$, $U_3$.","2. Exprime $U_n$ en fonction de $n$.","3. Calcule $U_{10}$.","4. Détermine si le nombre $50$ est un terme de la suite. Si oui, précise son rang."]}', '1. Les quatre premiers termes sont :
   $U_0 = 5$
   $U_1 = U_0 + r = 5 + 3 = 8$
   $U_2 = U_1 + r = 8 + 3 = 11$
   $U_3 = U_2 + r = 11 + 3 = 14$

2. La formule générale d''une suite arithmétique est $U_n = U_0 + nr$. En remplaçant les valeurs données :
   $U_n = 5 + 3n$

3. Pour calculer $U_{10}$, on remplace $n$ par $10$ dans la formule :
   $U_{10} = 5 + 3 \times 10 = 5 + 30 = 35$

4. Pour déterminer si $50$ est un terme de la suite, on résout l''équation $U_n = 50$ :
   $5 + 3n = 50$
   $3n = 50 - 5$
   $3n = 45$
   $n = \frac{45}{3}$
   $n = 15$
   Puisque $n=15$ est un entier naturel, $50$ est bien un terme de la suite. C''est le $15^e$ terme (ou le terme de rang 15, si on commence à $U_0$).', '["Pour la question 1, utilise la définition d''une suite arithmétique : $U_{n+1} = U_n + r$.","Pour la question 2, rappelle-toi la formule générale du terme de rang $n$ d''une suite arithmétique : $U_n = U_p + (n-p)r$. Ici, $p=0$.","Pour la question 3, utilise la formule que tu as trouvée à la question 2 en remplaçant $n$ par la valeur appropriée.","Pour la question 4, pose l''équation $U_n = 50$ et résous-la pour trouver $n$. N''oublie pas que $n$ doit être un entier naturel."]'::jsonb, '2026-01-11T11:02:01.768733+00:00'::timestamptz, '41dd6cb463a981c83379de8f2ec1842f7118c12eb759ccd7164f441017cc1306', NULL),
('292b234e-ce3a-406c-bb71-e7226ae4fe36', 'Exercice', 'terminale', '{"contexte":"","questions":["**Signe de $v_n$** : Tu as démontré à la question $3","**Signe de $(u_{n+1} - 1)$** : Tu as également démontré que $u_{n+1} - 1 < 0$","**Conclusion sur le produit** : Tu as un produit d''un nombre positif ($v_n$) et d''un nombre négatif ($u_{n+1} - 1$)"]}', 'À résoudre', '[]'::jsonb, '2026-01-12T20:22:29.660089+00:00'::timestamptz, '2562e051c5288aae344acee80b6f2f67a63d8833662632d95205a5b1d240b687', NULL);

INSERT INTO public.exercices (id, chapitre, niveau, enonce, solution, indices, created_at, content_hash, params) VALUES
('efc8d36b-5c29-44eb-8aeb-6ae9ed1dc485', 'Exercice', 'terminale', '{"contexte":"Exercice 2, juste après la question 1.**\nTu y vois cette partie :\n```\nOn considère la suite $(u_n)$ définie par $\\begin{cases} u_0 = \\frac{1}{2} \\\\ u_{n+1} = \\frac{1}{2} g(u_n) \\end{cases}$ pour tout entier naturel n.\n```\nCette écriture avec l''accolade est une manière standard de définir une suite :","questions":["La première ligne, $u_0 = \\frac{1}{2}$, te donne la **valeur du tout premier terme** de la suite. C''est le point de départ.","La deuxième ligne, $u_{n+1} = \\frac{1}{2} g(u_n)$, te donne la **règle pour passer d''un terme au suivant**. C''est la \"recette\" pour calculer $u_1$ à partir de $u_0$, $u_2$ à partir de $u_1$, etc."]}', 'À résoudre', '[]'::jsonb, '2026-01-13T19:11:06.374991+00:00'::timestamptz, 'e0e47dbffb29231067c4c0c14bc6f0531bf76d0ddf727be3854c1848ed0a6c07', NULL);

-- ============================================
-- SEQUENCES
-- ============================================
-- No sequences needed (using UUIDs)

-- ============================================
-- END OF EXPORT
-- ============================================
