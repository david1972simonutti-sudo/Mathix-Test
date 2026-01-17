-- ============================================================================
-- TABLE: interventions_pedagogiques
-- Date d'export: 2026-01-16
-- Nombre de lignes: 20
-- ============================================================================

-- 1. DROP TABLE (si existe)
DROP TABLE IF EXISTS interventions_pedagogiques CASCADE;

-- 2. CREATE TABLE avec structure complète
CREATE TABLE interventions_pedagogiques (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    interaction_id uuid,
    notion_actuelle text NOT NULL,
    chapitre_actuel text NOT NULL,
    niveau text NOT NULL,
    prerequis_manquant text NOT NULL,
    niveau_prerequis text,
    gravite integer,
    type_erreur text,
    message_affiche text,
    explication text,
    recommandation_action text,
    statut text DEFAULT 'proposee'::text,
    mode_aide_renforcee boolean DEFAULT false,
    nb_nouvelles_erreurs_apres_refus integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    
    CONSTRAINT interventions_pedagogiques_pkey PRIMARY KEY (id)
);

-- 3. FOREIGN KEYS
-- Aucune foreign key définie

-- 4. INDEX
CREATE INDEX idx_interventions_user_statut ON interventions_pedagogiques USING btree (user_id, statut, created_at DESC);
CREATE INDEX idx_interventions_prerequis ON interventions_pedagogiques USING btree (prerequis_manquant, statut);

-- 5. ROW LEVEL SECURITY
ALTER TABLE interventions_pedagogiques ENABLE ROW LEVEL SECURITY;

-- 6. POLICIES
CREATE POLICY "Users can view their own interventions"
ON interventions_pedagogiques
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own interventions"
ON interventions_pedagogiques
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own interventions"
ON interventions_pedagogiques
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own interventions"
ON interventions_pedagogiques
FOR DELETE
USING (auth.uid() = user_id);

-- 7. TRIGGERS
-- Aucun trigger défini

-- 8. INSERT DES DONNÉES (20 lignes, par lots de 5)
INSERT INTO interventions_pedagogiques (id, user_id, interaction_id, notion_actuelle, chapitre_actuel, niveau, prerequis_manquant, niveau_prerequis, gravite, type_erreur, message_affiche, explication, recommandation_action, statut, mode_aide_renforcee, nb_nouvelles_erreurs_apres_refus, created_at, updated_at) VALUES
('9b78d4a1-a8c6-4e4c-8c30-fc229b5b665e', 'ce842f9b-e38b-421d-b5f8-8e0570a149d6', NULL, 'Géométrie repérée', 'Géométrie repérée', 'premiere', 'Développement et factorisation', '4eme', 5, 'calcul', '🚨 Claire, je remarque quelque chose d''important !

Tu as fait **2 erreurs** sur **Développement et factorisation** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Géométrie repérée.

📚 Je te recommande **FORTEMENT** de réviser **Développement et factorisation** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 2 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-01 21:52:45.950269+00', '2025-12-01 21:52:45.950269+00'),
('af4172f6-d6f3-4516-a090-0fd813d0715a', 'ce842f9b-e38b-421d-b5f8-8e0570a149d6', NULL, 'Géométrie repérée', 'Géométrie repérée', 'premiere', 'Développement et factorisation', '4eme', 5, 'calcul', '🚨 Claire, je remarque quelque chose d''important !

Tu as fait **3 erreurs** sur **Développement et factorisation** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Géométrie repérée.

📚 Je te recommande **FORTEMENT** de réviser **Développement et factorisation** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 3 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-01 21:54:12.463669+00', '2025-12-01 21:54:12.463669+00'),
('0e0441a8-955f-4813-aeda-baedb1dc89ba', '45be8e26-8733-46c8-a568-d4b869fe4b3d', NULL, 'Nombres et calculs', 'Nombres et calculs', 'seconde', 'Développement et factorisation', '4eme', 5, 'conceptuelle', '🚨 Léor, je remarque quelque chose d''important !

Tu as fait **2 erreurs** sur **Développement et factorisation** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Nombres et calculs.

📚 Je te recommande **FORTEMENT** de réviser **Développement et factorisation** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 2 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-02 21:52:31.442239+00', '2025-12-02 21:52:31.442239+00'),
('72505604-a696-40b2-a49e-594e94f106da', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'calcul', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **2 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 2 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-09 09:02:50.529424+00', '2025-12-09 09:02:50.529424+00'),
('0b9cf8eb-e338-4ffb-87f1-355a3bb21509', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'calcul', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **3 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 3 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-09 09:20:16.956051+00', '2025-12-09 09:20:16.956051+00');

INSERT INTO interventions_pedagogiques (id, user_id, interaction_id, notion_actuelle, chapitre_actuel, niveau, prerequis_manquant, niveau_prerequis, gravite, type_erreur, message_affiche, explication, recommandation_action, statut, mode_aide_renforcee, nb_nouvelles_erreurs_apres_refus, created_at, updated_at) VALUES
('63a46529-669b-4c31-aa9a-540d592f95ba', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'conceptuelle', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **4 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 4 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-09 09:22:53.760557+00', '2025-12-09 09:22:53.760557+00'),
('113fc9a7-b549-4c74-8e13-6b0a8fc6f955', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'conceptuelle', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **5 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 5 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-09 09:32:33.275315+00', '2025-12-09 09:32:33.275315+00'),
('7c1d9186-4d35-46c3-977c-9d2c46b53f1e', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'calcul', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **6 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 6 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-09 09:34:06.70351+00', '2025-12-09 09:34:06.70351+00'),
('dc7614b5-0768-4470-873d-893e2be5786b', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'calcul', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **8 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 8 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-10 10:10:33.087201+00', '2025-12-10 10:10:33.087201+00'),
('49638979-abda-4e24-ac86-db80bee724fd', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'conceptuelle', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **9 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 9 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-10 10:12:58.741328+00', '2025-12-10 10:12:58.741328+00');

INSERT INTO interventions_pedagogiques (id, user_id, interaction_id, notion_actuelle, chapitre_actuel, niveau, prerequis_manquant, niveau_prerequis, gravite, type_erreur, message_affiche, explication, recommandation_action, statut, mode_aide_renforcee, nb_nouvelles_erreurs_apres_refus, created_at, updated_at) VALUES
('7134c556-7a12-49cb-955c-58ff5478cd0e', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'conceptuelle', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **10 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 10 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-10 10:15:29.074615+00', '2025-12-10 10:15:29.074615+00'),
('3cf82614-5cc4-49b4-a016-80dcf387e381', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'calcul', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **9 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 9 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-10 14:15:09.86095+00', '2025-12-10 14:15:09.86095+00'),
('9d9e42dc-193c-45dd-8721-12782a6c37ab', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'calcul', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **8 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 8 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-10 15:16:16.254706+00', '2025-12-10 15:16:16.254706+00'),
('e218d26d-e4e2-4eda-a5c0-11efb4c0b84b', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'calcul', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **8 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 8 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-11 08:00:23.316121+00', '2025-12-11 08:00:23.316121+00'),
('0c32c952-90a0-4b5d-8ca6-b36676927ca0', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'methodologique', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **7 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 7 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-11 09:06:39.580009+00', '2025-12-11 09:06:39.580009+00');

INSERT INTO interventions_pedagogiques (id, user_id, interaction_id, notion_actuelle, chapitre_actuel, niveau, prerequis_manquant, niveau_prerequis, gravite, type_erreur, message_affiche, explication, recommandation_action, statut, mode_aide_renforcee, nb_nouvelles_erreurs_apres_refus, created_at, updated_at) VALUES
('2074c97b-c0b4-4c3e-9e49-5fb9a9766fb3', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Dérivées de fonctions usuelles', 'premiere', 5, 'conceptuelle', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **2 erreurs** sur **Dérivées de fonctions usuelles** (notion de premiere).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Dérivées de fonctions usuelles** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 2 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-11 10:57:43.591175+00', '2025-12-11 10:57:43.591175+00'),
('d924a4d4-ee3d-4858-a775-e56f88961631', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'methodologique', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **4 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 4 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-12 12:45:25.032004+00', '2025-12-12 12:45:25.032004+00'),
('202dc4ee-1981-4379-a520-05cb7adb1c7f', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Opérations sur les fractions', '4eme', 5, 'methodologique', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **4 erreurs** sur **Opérations sur les fractions** (notion de 4eme).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Opérations sur les fractions** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 4 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-12 13:46:10.150179+00', '2025-12-12 13:46:10.150179+00'),
('94203ebb-2095-4f4f-9489-e0816d18f57e', 'e732120d-bb2d-4671-840d-2f74213bf0cc', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Définition de fonction et domaine de définition', 'seconde', 5, 'conceptuelle', '🚨 Raphaël, je remarque quelque chose d''important !

Tu as fait **2 erreurs** sur **Définition de fonction et domaine de définition** (notion de seconde).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Définition de fonction et domaine de définition** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 2 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-20 17:11:32.879129+00', '2025-12-20 17:11:32.879129+00'),
('f55fcbc4-aeb9-4c04-b7dd-53286c5bde10', '306093a9-efc0-4370-a917-35ca259ae261', NULL, 'Compléments sur la dérivation', 'Compléments sur la dérivation', 'terminale', 'Dérivées de fonctions usuelles', 'premiere', 5, 'methodologique', '🚨 Test0, je remarque quelque chose d''important !

Tu as fait **2 erreurs** sur **Dérivées de fonctions usuelles** (notion de premiere).

C''est un pré-requis **ESSENTIEL** pour bien comprendre Compléments sur la dérivation.

📚 Je te recommande **FORTEMENT** de réviser **Dérivées de fonctions usuelles** maintenant, sinon tu risques de continuer à bloquer sur les prochains exercices.

**Qu''est-ce que tu préfères ?**', 'Détecté automatiquement après 2 erreurs (gravité: 5)', 'revoir_prerequis', 'proposee', false, 0, '2025-12-21 12:16:38.906004+00', '2025-12-21 12:16:38.906004+00');

-- 9. SEQUENCES
-- Aucune séquence (id utilise gen_random_uuid())

-- ============================================================================
-- FIN DU BACKUP - interventions_pedagogiques
-- ============================================================================

