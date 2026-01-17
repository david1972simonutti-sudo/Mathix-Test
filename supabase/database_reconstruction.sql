-- =====================================================================================
-- FICHIER DE RECONSTRUCTION DE LA BASE DE DONNÉES SUPABASE - SIIMPLY
-- =====================================================================================
-- Généré le : 2026-01-15
-- Version : 1.0
-- Projet : Siimply - Plateforme d'apprentissage des mathématiques
-- 
-- Ce fichier permet de reconstruire entièrement la base de données Supabase.
-- Il est organisé en sections logiques pour faciliter la maintenance.
-- 
-- IMPORTANT : 
-- - Ce fichier ne contient PAS les données utilisateurs (uniquement la structure)
-- - Les données de référence (BO) sont incluses car essentielles
-- - L'ordre d'exécution doit être respecté
-- - Les secrets et configurations auth ne sont pas inclus (gérés par Supabase)
-- =====================================================================================

-- =====================================================================================
-- SECTION 1 : TYPES ET ENUMS
-- =====================================================================================
-- Description : Définition des types personnalisés utilisés dans la base de données

-- Type enum pour les rôles utilisateurs
-- Les rôles possibles sont : eleve, parent, administrateur
DO $$ BEGIN
    CREATE TYPE public.app_role AS ENUM ('eleve', 'parent', 'administrateur');
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

-- Type enum pour les groupes de test A/B
-- Utilisé pour comparer les performances des modèles IA
DO $$ BEGIN
    CREATE TYPE public.groupe_test AS ENUM ('gemini', 'o4mini');
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

-- =====================================================================================
-- SECTION 2 : FONCTIONS UTILITAIRES
-- =====================================================================================
-- Description : Fonctions de base utilisées par les triggers et les politiques RLS

-- Fonction : Mise à jour automatique du champ updated_at
-- Utilisée par les triggers pour maintenir la date de dernière modification
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- Fonction : Vérification des rôles utilisateurs
-- Utilisée par les politiques RLS pour contrôler l'accès basé sur les rôles
-- SECURITY DEFINER pour éviter les boucles récursives avec RLS
CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role app_role)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.user_roles
        WHERE user_id = _user_id AND role = _role
    )
$$;

-- Fonction : Vérification du nombre maximum de parents par élève
-- Un élève ne peut avoir que 2 parents maximum
CREATE OR REPLACE FUNCTION public.check_max_parents()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM parent_eleve_relations WHERE eleve_user_id = NEW.eleve_user_id) >= 2 THEN
        RAISE EXCEPTION 'Un élève ne peut avoir que 2 parents maximum';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- =====================================================================================
-- SECTION 3 : TABLES PRINCIPALES (21 tables)
-- =====================================================================================
-- Description : Définition de toutes les tables de l'application

-- -----------------------------------------------------------------------------
-- Table : profiles
-- Description : Profils utilisateurs (élèves et parents)
-- Relation : Lié à auth.users via user_id
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    email text NOT NULL,
    nom text NOT NULL,
    prenom text NOT NULL,
    classe text NOT NULL,
    paiement_valide boolean DEFAULT false,
    date_paiement timestamp with time zone,
    premiere_utilisation_chat timestamp with time zone,
    reception_news boolean DEFAULT false,
    has_seen_welcome_popup boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);

-- Contrainte d'unicité sur user_id
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_user_id_key;
ALTER TABLE public.profiles ADD CONSTRAINT profiles_user_id_key UNIQUE (user_id);

-- -----------------------------------------------------------------------------
-- Table : student_profiles
-- Description : Données pédagogiques des élèves (compétences, lacunes, etc.)
-- Relation : Lié à auth.users via user_id
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.student_profiles (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    competences jsonb DEFAULT '{}'::jsonb,
    lacunes_identifiees jsonb DEFAULT '[]'::jsonb,
    recent_cours_context jsonb DEFAULT '{}'::jsonb,
    style_apprentissage text,
    updated_at timestamp with time zone DEFAULT now()
);

-- Contrainte d'unicité sur user_id
ALTER TABLE public.student_profiles DROP CONSTRAINT IF EXISTS student_profiles_user_id_key;
ALTER TABLE public.student_profiles ADD CONSTRAINT student_profiles_user_id_key UNIQUE (user_id);

-- -----------------------------------------------------------------------------
-- Table : user_roles
-- Description : Rôles des utilisateurs (eleve, parent, administrateur)
-- Relation : Lié à auth.users via user_id
-- IMPORTANT : Séparé de profiles pour des raisons de sécurité
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_roles (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    role app_role NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_roles_user_id_role_key UNIQUE (user_id, role)
);

-- -----------------------------------------------------------------------------
-- Table : sessions
-- Description : Sessions d'apprentissage des élèves
-- Relation : Lié à auth.users via user_id
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.sessions (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    date_debut timestamp with time zone DEFAULT now(),
    date_fin timestamp with time zone,
    duree_totale integer,
    nb_exercices integer DEFAULT 0,
    progression jsonb DEFAULT '{}'::jsonb,
    humeur_du_jour text,
    humeur_timestamp timestamp with time zone
);

-- -----------------------------------------------------------------------------
-- Table : exercices
-- Description : Exercices générés par l'IA
-- Accessible en lecture publique
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.exercices (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    chapitre text NOT NULL,
    niveau text NOT NULL,
    enonce text NOT NULL,
    solution text NOT NULL,
    indices jsonb DEFAULT '[]'::jsonb,
    params jsonb DEFAULT '{}'::jsonb,
    content_hash text,
    created_at timestamp with time zone DEFAULT now()
);

-- Contrainte d'unicité sur content_hash (évite les doublons)
ALTER TABLE public.exercices DROP CONSTRAINT IF EXISTS exercices_content_hash_key;
ALTER TABLE public.exercices ADD CONSTRAINT exercices_content_hash_key UNIQUE (content_hash);

-- -----------------------------------------------------------------------------
-- Table : chats
-- Description : Conversations (exercices ou cours)
-- Relation : Lié à sessions, exercices, et auth.users
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.chats (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    exercice_id uuid,
    session_id uuid,
    chat_type text DEFAULT 'exercice'::text,
    titre text,
    exercise_context jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- Contrainte d'unicité sur exercice_id (un exercice = un chat)
ALTER TABLE public.chats DROP CONSTRAINT IF EXISTS chats_exercice_id_key;
ALTER TABLE public.chats ADD CONSTRAINT chats_exercice_id_key UNIQUE (exercice_id);

-- -----------------------------------------------------------------------------
-- Table : chat_history
-- Description : Historique des messages dans les conversations
-- Relation : Lié à chats via chat_id
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.chat_history (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    chat_id uuid,
    role text NOT NULL,
    content text NOT NULL,
    image_url text,
    created_at timestamp with time zone NOT NULL DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- Table : interactions
-- Description : Interactions élève-IA (réponses, corrections, analyses)
-- Relation : Lié à chats, exercices, sessions, et auth.users
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.interactions (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    session_id uuid,
    exercice_id uuid,
    chat_id uuid,
    chapitre text,
    exercice_enonce text,
    reponse_eleve text,
    correction text,
    analyse_erreur jsonb,
    modele_utilise text,
    tokens_utilises integer,
    duree_interaction integer,
    satisfaction_eleve integer,
    image_url text,
    chat_type text DEFAULT 'exercice'::text,
    created_at timestamp with time zone DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- Table : interventions_pedagogiques
-- Description : Interventions pédagogiques (recommandations de prérequis)
-- Relation : Lié à interactions via interaction_id
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.interventions_pedagogiques (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    interaction_id uuid,
    notion_actuelle text NOT NULL,
    chapitre_actuel text NOT NULL,
    niveau text NOT NULL,
    prerequis_manquant text NOT NULL,
    niveau_prerequis text,
    type_erreur text,
    gravite integer,
    message_affiche text,
    explication text,
    recommandation_action text,
    statut text DEFAULT 'proposee'::text,
    mode_aide_renforcee boolean DEFAULT false,
    nb_nouvelles_erreurs_apres_refus integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- Table : parent_invitations
-- Description : Invitations envoyées aux parents par les élèves
-- Relation : Lié à auth.users via eleve_user_id
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.parent_invitations (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    eleve_user_id uuid NOT NULL,
    parent_email text NOT NULL,
    token uuid NOT NULL DEFAULT gen_random_uuid(),
    status text DEFAULT 'pending'::text,
    created_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + interval '7 days')
);

-- Contrainte d'unicité sur token
ALTER TABLE public.parent_invitations DROP CONSTRAINT IF EXISTS parent_invitations_token_key;
ALTER TABLE public.parent_invitations ADD CONSTRAINT parent_invitations_token_key UNIQUE (token);

-- -----------------------------------------------------------------------------
-- Table : parent_eleve_relations
-- Description : Relations parent-élève
-- Relation : Lié à auth.users via parent_user_id et eleve_user_id
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.parent_eleve_relations (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    parent_user_id uuid NOT NULL,
    eleve_user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

-- Contrainte d'unicité sur la paire parent-élève
ALTER TABLE public.parent_eleve_relations DROP CONSTRAINT IF EXISTS parent_eleve_relations_parent_eleve_key;
ALTER TABLE public.parent_eleve_relations ADD CONSTRAINT parent_eleve_relations_parent_eleve_key UNIQUE (parent_user_id, eleve_user_id);

-- -----------------------------------------------------------------------------
-- Table : email_confirmations
-- Description : Tokens de confirmation d'email
-- Accès : Service role uniquement
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.email_confirmations (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    email text NOT NULL,
    token uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    confirmed_at timestamp with time zone,
    expires_at timestamp with time zone NOT NULL DEFAULT (now() + interval '15 minutes')
);

-- Contrainte d'unicité sur token
ALTER TABLE public.email_confirmations DROP CONSTRAINT IF EXISTS email_confirmations_token_key;
ALTER TABLE public.email_confirmations ADD CONSTRAINT email_confirmations_token_key UNIQUE (token);

-- -----------------------------------------------------------------------------
-- Table : pending_signups
-- Description : Inscriptions en attente de confirmation email
-- Accès : Service role uniquement (données chiffrées)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.pending_signups (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    encrypted_data text NOT NULL,
    parent_emails_encrypted text,
    token uuid NOT NULL DEFAULT gen_random_uuid(),
    reception_news boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + interval '15 minutes')
);

-- Contrainte d'unicité sur token
ALTER TABLE public.pending_signups DROP CONSTRAINT IF EXISTS pending_signups_token_key;
ALTER TABLE public.pending_signups ADD CONSTRAINT pending_signups_token_key UNIQUE (token);

-- -----------------------------------------------------------------------------
-- Table : password_reset_tokens
-- Description : Tokens de réinitialisation de mot de passe
-- Accès : Service role uniquement
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.password_reset_tokens (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    email text NOT NULL,
    token uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone DEFAULT (now() + interval '15 minutes'),
    used_at timestamp with time zone
);

-- Contrainte d'unicité sur token
ALTER TABLE public.password_reset_tokens DROP CONSTRAINT IF EXISTS password_reset_tokens_token_key;
ALTER TABLE public.password_reset_tokens ADD CONSTRAINT password_reset_tokens_token_key UNIQUE (token);

-- -----------------------------------------------------------------------------
-- Table : user_feedback
-- Description : Feedback CSAT des utilisateurs
-- Relation : Lié à auth.users via user_id
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_feedback (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    csat_score integer NOT NULL,
    difficulty text,
    comment text,
    created_at timestamp with time zone DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- Table : chat_feedback
-- Description : Feedback sur les messages IA (thumbs up/down)
-- Relation : Lié à chats via conversation_id
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.chat_feedback (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    conversation_id uuid,
    user_id uuid NOT NULL,
    message_id text NOT NULL,
    rating text NOT NULL,
    comment text,
    message_content text,
    created_at timestamp with time zone DEFAULT now()
);

-- -----------------------------------------------------------------------------
-- Table : competences_snapshots
-- Description : Snapshots quotidiens des compétences (pour suivi parental)
-- Relation : Lié à auth.users via user_id
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.competences_snapshots (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    snapshot_date date NOT NULL DEFAULT CURRENT_DATE,
    competences jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);

-- Contrainte d'unicité sur user_id + date
ALTER TABLE public.competences_snapshots DROP CONSTRAINT IF EXISTS competences_snapshots_user_id_snapshot_date_key;
ALTER TABLE public.competences_snapshots ADD CONSTRAINT competences_snapshots_user_id_snapshot_date_key UNIQUE (user_id, snapshot_date);

-- -----------------------------------------------------------------------------
-- Tables : Programme Officiel (BO = Bulletin Officiel)
-- Description : Référentiels des compétences par niveau
-- Accès : Lecture publique
-- -----------------------------------------------------------------------------

-- Table : bo_seconde
CREATE TABLE IF NOT EXISTS public.bo_seconde (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    chapitre text NOT NULL,
    sous_notion text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

-- Contrainte d'unicité
ALTER TABLE public.bo_seconde DROP CONSTRAINT IF EXISTS bo_seconde_chapitre_sous_notion_key;
ALTER TABLE public.bo_seconde ADD CONSTRAINT bo_seconde_chapitre_sous_notion_key UNIQUE (chapitre, sous_notion);

-- Table : bo_premiere
CREATE TABLE IF NOT EXISTS public.bo_premiere (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    chapitre text NOT NULL,
    sous_notion text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

-- Contrainte d'unicité
ALTER TABLE public.bo_premiere DROP CONSTRAINT IF EXISTS bo_premiere_chapitre_sous_notion_key;
ALTER TABLE public.bo_premiere ADD CONSTRAINT bo_premiere_chapitre_sous_notion_key UNIQUE (chapitre, sous_notion);

-- Table : bo_terminale
CREATE TABLE IF NOT EXISTS public.bo_terminale (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    chapitre text NOT NULL,
    sous_notion text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

-- Contrainte d'unicité
ALTER TABLE public.bo_terminale DROP CONSTRAINT IF EXISTS bo_terminale_chapitre_sous_notion_key;
ALTER TABLE public.bo_terminale ADD CONSTRAINT bo_terminale_chapitre_sous_notion_key UNIQUE (chapitre, sous_notion);

-- -----------------------------------------------------------------------------
-- Table : hors_programme_classe
-- Description : Notions hors programme par classe (pour éviter confusions)
-- Accès : Lecture publique
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.hors_programme_classe (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    classe text NOT NULL,
    notion text NOT NULL,
    niveau_cible text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

-- Contrainte d'unicité
ALTER TABLE public.hors_programme_classe DROP CONSTRAINT IF EXISTS idx_hors_programme_unique;
CREATE UNIQUE INDEX IF NOT EXISTS idx_hors_programme_unique ON public.hors_programme_classe (classe, notion);

-- =====================================================================================
-- SECTION 4 : INDEX DE PERFORMANCE
-- =====================================================================================
-- Description : Index pour optimiser les requêtes fréquentes

-- Index sur profiles
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON public.profiles (user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles (email);

-- Index sur student_profiles
CREATE INDEX IF NOT EXISTS idx_student_profiles_user_id ON public.student_profiles (user_id);

-- Index sur sessions
CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON public.sessions (user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_date_debut ON public.sessions (date_debut DESC);

-- Index sur chats
CREATE INDEX IF NOT EXISTS idx_chats_user_id ON public.chats (user_id);
CREATE INDEX IF NOT EXISTS idx_chats_session_id ON public.chats (session_id);
CREATE INDEX IF NOT EXISTS idx_chats_exercice_id ON public.chats (exercice_id);
CREATE INDEX IF NOT EXISTS idx_chats_chat_type ON public.chats (chat_type);

-- Index sur chat_history
CREATE INDEX IF NOT EXISTS idx_chat_history_chat_id ON public.chat_history (chat_id);
CREATE INDEX IF NOT EXISTS idx_chat_history_user ON public.chat_history (user_id, created_at);

-- Index sur interactions
CREATE INDEX IF NOT EXISTS idx_interactions_user_id ON public.interactions (user_id);
CREATE INDEX IF NOT EXISTS idx_interactions_chat_id ON public.interactions (chat_id);
CREATE INDEX IF NOT EXISTS idx_interactions_user_created ON public.interactions (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_interactions_user_chapitre ON public.interactions (user_id, chapitre);
CREATE INDEX IF NOT EXISTS idx_interactions_user_exercice ON public.interactions (user_id, exercice_id);

-- Index sur interventions_pedagogiques
CREATE INDEX IF NOT EXISTS idx_interventions_user_id ON public.interventions_pedagogiques (user_id);
CREATE INDEX IF NOT EXISTS idx_interventions_interaction_id ON public.interventions_pedagogiques (interaction_id);

-- Index sur exercices
CREATE INDEX IF NOT EXISTS idx_exercices_content_hash ON public.exercices (content_hash);
CREATE INDEX IF NOT EXISTS idx_exercices_chapitre ON public.exercices (chapitre);

-- Index sur parent_invitations
CREATE INDEX IF NOT EXISTS idx_parent_invitations_eleve ON public.parent_invitations (eleve_user_id);
CREATE INDEX IF NOT EXISTS idx_parent_invitations_token ON public.parent_invitations (token);

-- Index sur parent_eleve_relations
CREATE INDEX IF NOT EXISTS idx_parent_eleve_parent ON public.parent_eleve_relations (parent_user_id);
CREATE INDEX IF NOT EXISTS idx_parent_eleve_eleve ON public.parent_eleve_relations (eleve_user_id);

-- Index sur chat_feedback
CREATE INDEX IF NOT EXISTS idx_chat_feedback_user ON public.chat_feedback (user_id);
CREATE INDEX IF NOT EXISTS idx_chat_feedback_conversation ON public.chat_feedback (conversation_id);
CREATE INDEX IF NOT EXISTS idx_chat_feedback_created ON public.chat_feedback (created_at);

-- Index sur competences_snapshots
CREATE INDEX IF NOT EXISTS idx_snapshots_user_date ON public.competences_snapshots (user_id, snapshot_date DESC);

-- =====================================================================================
-- SECTION 5 : CLÉS ÉTRANGÈRES ET CONTRAINTES
-- =====================================================================================
-- Description : Relations entre les tables

-- Clés étrangères vers auth.users
ALTER TABLE public.user_roles 
    DROP CONSTRAINT IF EXISTS user_roles_user_id_fkey,
    ADD CONSTRAINT user_roles_user_id_fkey 
    FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.chats 
    DROP CONSTRAINT IF EXISTS chats_user_id_fkey,
    ADD CONSTRAINT chats_user_id_fkey 
    FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.parent_invitations 
    DROP CONSTRAINT IF EXISTS parent_invitations_eleve_user_id_fkey,
    ADD CONSTRAINT parent_invitations_eleve_user_id_fkey 
    FOREIGN KEY (eleve_user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.parent_eleve_relations 
    DROP CONSTRAINT IF EXISTS parent_eleve_relations_parent_user_id_fkey,
    ADD CONSTRAINT parent_eleve_relations_parent_user_id_fkey 
    FOREIGN KEY (parent_user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.parent_eleve_relations 
    DROP CONSTRAINT IF EXISTS parent_eleve_relations_eleve_user_id_fkey,
    ADD CONSTRAINT parent_eleve_relations_eleve_user_id_fkey 
    FOREIGN KEY (eleve_user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

ALTER TABLE public.email_confirmations 
    DROP CONSTRAINT IF EXISTS email_confirmations_user_id_fkey,
    ADD CONSTRAINT email_confirmations_user_id_fkey 
    FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Clés étrangères entre tables publiques
ALTER TABLE public.chats 
    DROP CONSTRAINT IF EXISTS chats_session_id_fkey,
    ADD CONSTRAINT chats_session_id_fkey 
    FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON DELETE SET NULL;

ALTER TABLE public.chats 
    DROP CONSTRAINT IF EXISTS chats_exercice_id_fkey,
    ADD CONSTRAINT chats_exercice_id_fkey 
    FOREIGN KEY (exercice_id) REFERENCES public.exercices(id) ON DELETE CASCADE;

ALTER TABLE public.chat_history 
    DROP CONSTRAINT IF EXISTS chat_history_chat_id_fkey,
    ADD CONSTRAINT chat_history_chat_id_fkey 
    FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON DELETE CASCADE;

ALTER TABLE public.interactions 
    DROP CONSTRAINT IF EXISTS interactions_chat_id_fkey,
    ADD CONSTRAINT interactions_chat_id_fkey 
    FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON DELETE SET NULL;

ALTER TABLE public.interactions 
    DROP CONSTRAINT IF EXISTS interactions_exercice_id_fkey,
    ADD CONSTRAINT interactions_exercice_id_fkey 
    FOREIGN KEY (exercice_id) REFERENCES public.exercices(id);

ALTER TABLE public.interventions_pedagogiques 
    DROP CONSTRAINT IF EXISTS interventions_pedagogiques_interaction_id_fkey,
    ADD CONSTRAINT interventions_pedagogiques_interaction_id_fkey 
    FOREIGN KEY (interaction_id) REFERENCES public.interactions(id) ON DELETE CASCADE;

ALTER TABLE public.chat_feedback 
    DROP CONSTRAINT IF EXISTS chat_feedback_conversation_id_fkey,
    ADD CONSTRAINT chat_feedback_conversation_id_fkey 
    FOREIGN KEY (conversation_id) REFERENCES public.chats(id) ON DELETE CASCADE;

-- =====================================================================================
-- SECTION 6 : TRIGGERS
-- =====================================================================================
-- Description : Déclencheurs automatiques

-- Trigger : Mise à jour automatique de updated_at sur student_profiles
DROP TRIGGER IF EXISTS update_student_profiles_updated_at ON public.student_profiles;
CREATE TRIGGER update_student_profiles_updated_at
    BEFORE UPDATE ON public.student_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- Trigger : Mise à jour automatique de updated_at sur chats
DROP TRIGGER IF EXISTS update_chats_updated_at ON public.chats;
CREATE TRIGGER update_chats_updated_at
    BEFORE UPDATE ON public.chats
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- Trigger : Limitation à 2 parents par élève
DROP TRIGGER IF EXISTS enforce_max_parents ON public.parent_eleve_relations;
CREATE TRIGGER enforce_max_parents
    BEFORE INSERT ON public.parent_eleve_relations
    FOR EACH ROW
    EXECUTE FUNCTION public.check_max_parents();

-- =====================================================================================
-- SECTION 7 : ACTIVATION ROW LEVEL SECURITY (RLS)
-- =====================================================================================
-- Description : Activation de la sécurité au niveau des lignes

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interventions_pedagogiques ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parent_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parent_eleve_relations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_confirmations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pending_signups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.password_reset_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.competences_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bo_seconde ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bo_premiere ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bo_terminale ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hors_programme_classe ENABLE ROW LEVEL SECURITY;

-- =====================================================================================
-- SECTION 8 : POLITIQUES RLS (57 policies)
-- =====================================================================================
-- Description : Règles de sécurité au niveau des lignes

-- -----------------------------------------------------------------------------
-- Policies : profiles
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own profile" ON public.profiles;
CREATE POLICY "Users can view their own profile" ON public.profiles
    FOR SELECT USING ((auth.uid())::text = (user_id)::text);

DROP POLICY IF EXISTS "Parents can view their children's profiles" ON public.profiles;
CREATE POLICY "Parents can view their children's profiles" ON public.profiles
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM parent_eleve_relations
        WHERE parent_eleve_relations.parent_user_id = auth.uid()
        AND parent_eleve_relations.eleve_user_id = profiles.user_id
    ));

DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
CREATE POLICY "Users can insert their own profile" ON public.profiles
    FOR INSERT WITH CHECK ((auth.uid())::text = (user_id)::text);

DROP POLICY IF EXISTS "Users can update their own profile" ON public.profiles;
CREATE POLICY "Users can update their own profile" ON public.profiles
    FOR UPDATE USING ((auth.uid())::text = (user_id)::text);

DROP POLICY IF EXISTS "Users can update their payment info" ON public.profiles;
CREATE POLICY "Users can update their payment info" ON public.profiles
    FOR UPDATE USING ((auth.uid())::text = (user_id)::text)
    WITH CHECK ((auth.uid())::text = (user_id)::text);

-- -----------------------------------------------------------------------------
-- Policies : student_profiles
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own student profile" ON public.student_profiles;
CREATE POLICY "Users can view their own student profile" ON public.student_profiles
    FOR SELECT USING ((auth.uid())::text = (user_id)::text);

DROP POLICY IF EXISTS "Parents can view their children's student profiles" ON public.student_profiles;
CREATE POLICY "Parents can view their children's student profiles" ON public.student_profiles
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM parent_eleve_relations
        WHERE parent_eleve_relations.parent_user_id = auth.uid()
        AND parent_eleve_relations.eleve_user_id = student_profiles.user_id
    ));

DROP POLICY IF EXISTS "Users can insert their own student profile" ON public.student_profiles;
CREATE POLICY "Users can insert their own student profile" ON public.student_profiles
    FOR INSERT WITH CHECK ((auth.uid())::text = (user_id)::text);

DROP POLICY IF EXISTS "Users can update their own student profile" ON public.student_profiles;
CREATE POLICY "Users can update their own student profile" ON public.student_profiles
    FOR UPDATE USING ((auth.uid())::text = (user_id)::text);

DROP POLICY IF EXISTS "Users can delete their own student profile" ON public.student_profiles;
CREATE POLICY "Users can delete their own student profile" ON public.student_profiles
    FOR DELETE USING (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- Policies : user_roles
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own roles" ON public.user_roles;
CREATE POLICY "Users can view their own roles" ON public.user_roles
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Admins can view all roles" ON public.user_roles;
CREATE POLICY "Admins can view all roles" ON public.user_roles
    FOR SELECT USING (has_role(auth.uid(), 'administrateur'::app_role));

DROP POLICY IF EXISTS "Users can only self-assign eleve role during signup" ON public.user_roles;
CREATE POLICY "Users can only self-assign eleve role during signup" ON public.user_roles
    FOR INSERT WITH CHECK ((auth.uid() = user_id) AND (role = 'eleve'::app_role));

DROP POLICY IF EXISTS "Admins can manage all roles" ON public.user_roles;
CREATE POLICY "Admins can manage all roles" ON public.user_roles
    FOR ALL USING (has_role(auth.uid(), 'administrateur'::app_role))
    WITH CHECK (has_role(auth.uid(), 'administrateur'::app_role));

-- -----------------------------------------------------------------------------
-- Policies : sessions
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own sessions" ON public.sessions;
CREATE POLICY "Users can view their own sessions" ON public.sessions
    FOR SELECT USING ((auth.uid())::text = (user_id)::text);

DROP POLICY IF EXISTS "Parents can view their children's sessions" ON public.sessions;
CREATE POLICY "Parents can view their children's sessions" ON public.sessions
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM parent_eleve_relations
        WHERE parent_eleve_relations.parent_user_id = auth.uid()
        AND parent_eleve_relations.eleve_user_id = sessions.user_id
    ));

DROP POLICY IF EXISTS "Users can insert their own sessions" ON public.sessions;
CREATE POLICY "Users can insert their own sessions" ON public.sessions
    FOR INSERT WITH CHECK ((auth.uid())::text = (user_id)::text);

DROP POLICY IF EXISTS "Users can update their own sessions" ON public.sessions;
CREATE POLICY "Users can update their own sessions" ON public.sessions
    FOR UPDATE USING ((auth.uid())::text = (user_id)::text);

DROP POLICY IF EXISTS "Users can delete their own sessions" ON public.sessions;
CREATE POLICY "Users can delete their own sessions" ON public.sessions
    FOR DELETE USING (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- Policies : exercices (lecture publique)
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Everyone can view exercices" ON public.exercices;
CREATE POLICY "Everyone can view exercices" ON public.exercices
    FOR SELECT USING (true);

-- -----------------------------------------------------------------------------
-- Policies : chats
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own chats" ON public.chats;
CREATE POLICY "Users can view their own chats" ON public.chats
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert their own chats" ON public.chats;
CREATE POLICY "Users can insert their own chats" ON public.chats
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own chats" ON public.chats;
CREATE POLICY "Users can update their own chats" ON public.chats
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own chats" ON public.chats;
CREATE POLICY "Users can delete their own chats" ON public.chats
    FOR DELETE USING (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- Policies : chat_history
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their chat messages" ON public.chat_history;
CREATE POLICY "Users can view their chat messages" ON public.chat_history
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM chats
        WHERE chats.id = chat_history.chat_id
        AND chats.user_id = auth.uid()
    ));

DROP POLICY IF EXISTS "Users can insert their chat messages" ON public.chat_history;
CREATE POLICY "Users can insert their chat messages" ON public.chat_history
    FOR INSERT WITH CHECK (EXISTS (
        SELECT 1 FROM chats
        WHERE chats.id = chat_history.chat_id
        AND chats.user_id = auth.uid()
    ));

DROP POLICY IF EXISTS "Users can delete their chat messages" ON public.chat_history;
CREATE POLICY "Users can delete their chat messages" ON public.chat_history
    FOR DELETE USING (EXISTS (
        SELECT 1 FROM chats
        WHERE chats.id = chat_history.chat_id
        AND chats.user_id = auth.uid()
    ));

-- -----------------------------------------------------------------------------
-- Policies : interactions
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own interactions" ON public.interactions;
CREATE POLICY "Users can view their own interactions" ON public.interactions
    FOR SELECT USING ((auth.uid())::text = (user_id)::text);

DROP POLICY IF EXISTS "Parents can view their children's interactions" ON public.interactions;
CREATE POLICY "Parents can view their children's interactions" ON public.interactions
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM parent_eleve_relations
        WHERE parent_eleve_relations.parent_user_id = auth.uid()
        AND parent_eleve_relations.eleve_user_id = interactions.user_id
    ));

DROP POLICY IF EXISTS "Users can insert their own interactions" ON public.interactions;
CREATE POLICY "Users can insert their own interactions" ON public.interactions
    FOR INSERT WITH CHECK ((auth.uid())::text = (user_id)::text);

DROP POLICY IF EXISTS "Service role can insert interactions" ON public.interactions;
CREATE POLICY "Service role can insert interactions" ON public.interactions
    FOR INSERT WITH CHECK (true);

-- -----------------------------------------------------------------------------
-- Policies : interventions_pedagogiques
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own interventions" ON public.interventions_pedagogiques;
CREATE POLICY "Users can view their own interventions" ON public.interventions_pedagogiques
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert their own interventions" ON public.interventions_pedagogiques;
CREATE POLICY "Users can insert their own interventions" ON public.interventions_pedagogiques
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own interventions" ON public.interventions_pedagogiques;
CREATE POLICY "Users can update their own interventions" ON public.interventions_pedagogiques
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own interventions" ON public.interventions_pedagogiques;
CREATE POLICY "Users can delete their own interventions" ON public.interventions_pedagogiques
    FOR DELETE USING (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- Policies : parent_invitations
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Eleves can view their own invitations" ON public.parent_invitations;
CREATE POLICY "Eleves can view their own invitations" ON public.parent_invitations
    FOR SELECT USING ((auth.uid() = eleve_user_id) OR has_role(auth.uid(), 'administrateur'::app_role));

DROP POLICY IF EXISTS "Eleves can create invitations" ON public.parent_invitations;
CREATE POLICY "Eleves can create invitations" ON public.parent_invitations
    FOR INSERT WITH CHECK (auth.uid() = eleve_user_id);

DROP POLICY IF EXISTS "Eleves can update their own invitations" ON public.parent_invitations;
CREATE POLICY "Eleves can update their own invitations" ON public.parent_invitations
    FOR UPDATE USING (auth.uid() = eleve_user_id);

DROP POLICY IF EXISTS "Students can delete their own invitations" ON public.parent_invitations;
CREATE POLICY "Students can delete their own invitations" ON public.parent_invitations
    FOR DELETE USING ((auth.uid() = eleve_user_id) OR has_role(auth.uid(), 'administrateur'::app_role));

DROP POLICY IF EXISTS "Admins can manage all invitations" ON public.parent_invitations;
CREATE POLICY "Admins can manage all invitations" ON public.parent_invitations
    FOR ALL USING (has_role(auth.uid(), 'administrateur'::app_role))
    WITH CHECK (has_role(auth.uid(), 'administrateur'::app_role));

-- -----------------------------------------------------------------------------
-- Policies : parent_eleve_relations
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own relations" ON public.parent_eleve_relations;
CREATE POLICY "Users can view their own relations" ON public.parent_eleve_relations
    FOR SELECT USING (
        (auth.uid() = parent_user_id) 
        OR (auth.uid() = eleve_user_id) 
        OR has_role(auth.uid(), 'administrateur'::app_role)
    );

DROP POLICY IF EXISTS "Students can delete their parent relations" ON public.parent_eleve_relations;
CREATE POLICY "Students can delete their parent relations" ON public.parent_eleve_relations
    FOR DELETE USING ((auth.uid() = eleve_user_id) OR has_role(auth.uid(), 'administrateur'::app_role));

DROP POLICY IF EXISTS "Admins can manage all relations" ON public.parent_eleve_relations;
CREATE POLICY "Admins can manage all relations" ON public.parent_eleve_relations
    FOR ALL USING (has_role(auth.uid(), 'administrateur'::app_role))
    WITH CHECK (has_role(auth.uid(), 'administrateur'::app_role));

-- -----------------------------------------------------------------------------
-- Policies : Tables sensibles (service role only)
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Service role only - no direct access" ON public.email_confirmations;
CREATE POLICY "Service role only - no direct access" ON public.email_confirmations
    FOR ALL USING (false);

DROP POLICY IF EXISTS "Service role only - no direct access" ON public.pending_signups;
CREATE POLICY "Service role only - no direct access" ON public.pending_signups
    FOR ALL USING (false);

DROP POLICY IF EXISTS "Service role only - no direct access" ON public.password_reset_tokens;
CREATE POLICY "Service role only - no direct access" ON public.password_reset_tokens
    FOR ALL USING (false);

-- -----------------------------------------------------------------------------
-- Policies : user_feedback
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own feedback" ON public.user_feedback;
CREATE POLICY "Users can view their own feedback" ON public.user_feedback
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert their own feedback" ON public.user_feedback;
CREATE POLICY "Users can insert their own feedback" ON public.user_feedback
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- Policies : chat_feedback
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own feedback" ON public.chat_feedback;
CREATE POLICY "Users can view their own feedback" ON public.chat_feedback
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert their own feedback" ON public.chat_feedback;
CREATE POLICY "Users can insert their own feedback" ON public.chat_feedback
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- Policies : competences_snapshots
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Users can view their own snapshots" ON public.competences_snapshots;
CREATE POLICY "Users can view their own snapshots" ON public.competences_snapshots
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Parents can view children snapshots" ON public.competences_snapshots;
CREATE POLICY "Parents can view children snapshots" ON public.competences_snapshots
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM parent_eleve_relations
        WHERE parent_eleve_relations.parent_user_id = auth.uid()
        AND parent_eleve_relations.eleve_user_id = competences_snapshots.user_id
    ));

DROP POLICY IF EXISTS "Service role can insert snapshots" ON public.competences_snapshots;
CREATE POLICY "Service role can insert snapshots" ON public.competences_snapshots
    FOR INSERT WITH CHECK (true);

-- -----------------------------------------------------------------------------
-- Policies : Tables BO (lecture publique)
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "Lecture publique bo_seconde" ON public.bo_seconde;
CREATE POLICY "Lecture publique bo_seconde" ON public.bo_seconde
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Lecture publique bo_premiere" ON public.bo_premiere;
CREATE POLICY "Lecture publique bo_premiere" ON public.bo_premiere
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Lecture publique bo_terminale" ON public.bo_terminale;
CREATE POLICY "Lecture publique bo_terminale" ON public.bo_terminale
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public read access" ON public.hors_programme_classe;
CREATE POLICY "Public read access" ON public.hors_programme_classe
    FOR SELECT USING (true);

-- =====================================================================================
-- SECTION 9 : STORAGE (Buckets et Policies)
-- =====================================================================================
-- Description : Configuration du stockage de fichiers

-- Création du bucket pour les réponses étudiants (images uploadées)
INSERT INTO storage.buckets (id, name, public)
VALUES ('student-responses', 'student-responses', false)
ON CONFLICT (id) DO NOTHING;

-- Policies de storage pour student-responses
-- Les utilisateurs peuvent uploader leurs propres fichiers
DROP POLICY IF EXISTS "Users can upload their own response images" ON storage.objects;
CREATE POLICY "Users can upload their own response images" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'student-responses' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- Les utilisateurs peuvent voir leurs propres fichiers
DROP POLICY IF EXISTS "Users can view their own response images" ON storage.objects;
CREATE POLICY "Users can view their own response images" ON storage.objects
    FOR SELECT USING (
        bucket_id = 'student-responses' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- Les utilisateurs peuvent supprimer leurs propres fichiers
DROP POLICY IF EXISTS "Users can delete their own response images" ON storage.objects;
CREATE POLICY "Users can delete their own response images" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'student-responses' 
        AND auth.uid()::text = (storage.foldername(name))[1]
    );

-- =====================================================================================
-- SECTION 10 : DONNÉES DE RÉFÉRENCE - PROGRAMME OFFICIEL SECONDE
-- =====================================================================================
-- Description : 54 sous-notions du programme de mathématiques de Seconde

-- Suppression des données existantes pour éviter les doublons
DELETE FROM public.bo_seconde;

-- Insertion des données
INSERT INTO public.bo_seconde (chapitre, sous_notion) VALUES
-- Manipuler les nombres réels (5)
('Manipuler les nombres réels', 'Ensemble ℝ et ses sous-ensembles'),
('Manipuler les nombres réels', 'Intervalles de ℝ'),
('Manipuler les nombres réels', 'Nombres rationnels et irrationnels'),
('Manipuler les nombres réels', 'Valeur absolue'),
('Manipuler les nombres réels', 'Encadrements et approximations'),

-- Utiliser le calcul littéral (4)
('Utiliser le calcul littéral', 'Identités remarquables'),
('Utiliser le calcul littéral', 'Puissances entières et fractionnaires'),
('Utiliser le calcul littéral', 'Calculs avec radicaux'),
('Utiliser le calcul littéral', 'Résolution d''équations et inéquations'),

-- Utiliser les notions de multiple, diviseur et de nombre premier (3)
('Utiliser les notions de multiple, diviseur et de nombre premier', 'Multiples et diviseurs'),
('Utiliser les notions de multiple, diviseur et de nombre premier', 'Nombres premiers'),
('Utiliser les notions de multiple, diviseur et de nombre premier', 'Décomposition en produit de facteurs premiers'),

-- Vocabulaire ensembliste et logique (6)
('Vocabulaire ensembliste et logique', 'Appartenance (∈), inclusion (⊂)'),
('Vocabulaire ensembliste et logique', 'Intersection (⋂), réunion (⋃)'),
('Vocabulaire ensembliste et logique', 'Couples et produit cartésien'),
('Vocabulaire ensembliste et logique', 'Implication'),
('Vocabulaire ensembliste et logique', 'Contre-exemples'),
('Vocabulaire ensembliste et logique', 'Quantificateurs (∀, ∃)'),

-- Représenter et caractériser les droites du plan (4)
('Représenter et caractériser les droites du plan', 'Équation cartésienne de droite'),
('Représenter et caractériser les droites du plan', 'Équation réduite'),
('Représenter et caractériser les droites du plan', 'Pente et ordonnée à l''origine'),
('Représenter et caractériser les droites du plan', 'Systèmes linéaires 2×2'),

-- Manipuler les vecteurs du plan (4)
('Manipuler les vecteurs du plan', 'Somme de vecteurs'),
('Manipuler les vecteurs du plan', 'Coordonnées dans un repère'),
('Manipuler les vecteurs du plan', 'Colinéarité'),
('Manipuler les vecteurs du plan', 'Déterminant de deux vecteurs'),

-- Résoudre des problèmes de géométrie (1)
('Résoudre des problèmes de géométrie', 'Projeté orthogonal d''un point sur une droite'),

-- Se constituer un répertoire de fonctions de référence (4)
('Se constituer un répertoire de fonctions de référence', 'Fonction carré'),
('Se constituer un répertoire de fonctions de référence', 'Fonction cube'),
('Se constituer un répertoire de fonctions de référence', 'Fonction inverse'),
('Se constituer un répertoire de fonctions de référence', 'Fonction racine carrée'),

-- Représenter algébriquement et graphiquement les fonctions (3)
('Représenter algébriquement et graphiquement les fonctions', 'Courbe représentative'),
('Représenter algébriquement et graphiquement les fonctions', 'Représentation graphique'),
('Représenter algébriquement et graphiquement les fonctions', 'Parité (fonctions paires et impaires)'),

-- Résoudre des problèmes de variations et d'extremum (3)
('Résoudre des problèmes de variations et d''extremum', 'Sens de variation'),
('Résoudre des problèmes de variations et d''extremum', 'Tableau de variations'),
('Résoudre des problèmes de variations et d''extremum', 'Maximum et minimum'),

-- Exploiter la notion d'information chiffrée (4)
('Exploiter la notion d''information chiffrée', 'Proportions et pourcentages'),
('Exploiter la notion d''information chiffrée', 'Évolutions successives et réciproques'),
('Exploiter la notion d''information chiffrée', 'Moyenne pondérée'),
('Exploiter la notion d''information chiffrée', 'Écart-type'),

-- Modéliser le hasard (4)
('Modéliser le hasard', 'Univers et événements'),
('Modéliser le hasard', 'Loi de probabilité'),
('Modéliser le hasard', 'Réunion, intersection, contraire'),
('Modéliser le hasard', 'Dénombrement par arbres ou tableaux'),

-- Échantillonnage (2)
('Échantillonnage', 'Principe de l''estimation'),
('Échantillonnage', 'Loi des grands nombres'),

-- Utiliser les variables et les instructions élémentaires (4)
('Utiliser les variables et les instructions élémentaires', 'Types de variables'),
('Utiliser les variables et les instructions élémentaires', 'Affectation'),
('Utiliser les variables et les instructions élémentaires', 'Instructions conditionnelles (if)'),
('Utiliser les variables et les instructions élémentaires', 'Boucles (for, while)'),

-- Concevoir et utiliser des fonctions (2)
('Concevoir et utiliser des fonctions', 'Fonctions avec arguments'),
('Concevoir et utiliser des fonctions', 'Fonctions Python de génération aléatoire');

-- =====================================================================================
-- SECTION 10 (suite) : DONNÉES DE RÉFÉRENCE - PROGRAMME OFFICIEL PREMIÈRE
-- =====================================================================================
-- Description : 67 sous-notions du programme de mathématiques de Première

DELETE FROM public.bo_premiere;

INSERT INTO public.bo_premiere (chapitre, sous_notion) VALUES
-- Suites numériques (6)
('Suites numériques', 'Modes de génération (explicite, récurrence)'),
('Suites numériques', 'Suites arithmétiques'),
('Suites numériques', 'Suites géométriques'),
('Suites numériques', 'Sens de variation'),
('Suites numériques', 'Représentation graphique'),
('Suites numériques', 'Limite intuitive (convergence, divergence vers l''infini)'),

-- Polynômes du second degré (5)
('Polynômes du second degré', 'Forme développée, canonique, factorisée'),
('Polynômes du second degré', 'Discriminant'),
('Polynômes du second degré', 'Résolution d''équations du second degré'),
('Polynômes du second degré', 'Signe du trinôme'),
('Polynômes du second degré', 'Somme et produit des racines'),

-- Dérivation (9)
('Dérivation', 'Taux de variation'),
('Dérivation', 'Nombre dérivé en un point'),
('Dérivation', 'Fonction dérivée'),
('Dérivation', 'Dérivées des fonctions usuelles'),
('Dérivation', 'Opérations sur les dérivées'),
('Dérivation', 'Dérivée de fonctions composées (du type u^n, 1/u)'),
('Dérivation', 'Fonction dérivée de x ↦ g(ax+b)'),
('Dérivation', 'Lien entre signe de la dérivée et variations'),
('Dérivation', 'Équation de tangente'),

-- Fonction exponentielle (5)
('Fonction exponentielle', 'Définition (f'' = f et f(0) = 1)'),
('Fonction exponentielle', 'Notation exp(x) = e^x'),
('Fonction exponentielle', 'Nombre e'),
('Fonction exponentielle', 'Propriétés algébriques'),
('Fonction exponentielle', 'Lien avec les suites géométriques'),

-- Fonctions trigonométriques (6)
('Fonctions trigonométriques', 'Cercle trigonométrique'),
('Fonctions trigonométriques', 'Radian'),
('Fonctions trigonométriques', 'Enroulement de la droite sur le cercle'),
('Fonctions trigonométriques', 'Fonctions cosinus et sinus'),
('Fonctions trigonométriques', 'Parité et périodicité'),
('Fonctions trigonométriques', 'Valeurs remarquables'),

-- Produit scalaire (6)
('Produit scalaire', 'Définition à partir de la projection orthogonale'),
('Produit scalaire', 'Formule avec le cosinus'),
('Produit scalaire', 'Expression dans une base orthonormée'),
('Produit scalaire', 'Bilinéarité et symétrie'),
('Produit scalaire', 'Transformation d''écritures vectorielles'),
('Produit scalaire', 'Théorème d''Al-Kashi'),

-- Géométrie repérée (3)
('Géométrie repérée', 'Vecteur normal à une droite'),
('Géométrie repérée', 'Parabole représentant une fonction du second degré'),
('Géométrie repérée', 'Équation du cercle'),

-- Probabilités conditionnelles (6)
('Probabilités conditionnelles', 'Notation P_A(B)'),
('Probabilités conditionnelles', 'Arbres pondérés'),
('Probabilités conditionnelles', 'Partition de l''univers'),
('Probabilités conditionnelles', 'Formule des probabilités totales'),
('Probabilités conditionnelles', 'Indépendance de deux événements'),
('Probabilités conditionnelles', 'Succession de deux épreuves indépendantes'),

-- Variables aléatoires réelles (4)
('Variables aléatoires réelles', 'Définition (fonction sur l''univers)'),
('Variables aléatoires réelles', 'Loi de probabilité'),
('Variables aléatoires réelles', 'Espérance'),
('Variables aléatoires réelles', 'Variance et écart-type'),

-- Expérimentations et simulations (4)
('Expérimentations et simulations', 'Simulations en Python'),
('Expérimentations et simulations', 'Moyenne d''un échantillon'),
('Expérimentations et simulations', 'Distance entre moyenne et espérance'),
('Expérimentations et simulations', 'Proportion de valeurs dans l''intervalle [μ - 2σ/√n ; μ + 2σ/√n]'),

-- Vocabulaire ensembliste et logique (4)
('Vocabulaire ensembliste et logique', 'Connecteurs logiques "et" / "ou"'),
('Vocabulaire ensembliste et logique', 'Complémentaire d''une partie'),
('Vocabulaire ensembliste et logique', 'Condition nécessaire et condition suffisante'),
('Vocabulaire ensembliste et logique', 'Raisonnement par récurrence'),

-- Manipuler les listes (4)
('Manipuler les listes', 'Génération par extension et en compréhension'),
('Manipuler les listes', 'Manipulation d''éléments et d''indices'),
('Manipuler les listes', 'Itération sur les éléments'),
('Manipuler les listes', 'Parcours de listes');

-- =====================================================================================
-- SECTION 10 (suite) : DONNÉES DE RÉFÉRENCE - PROGRAMME OFFICIEL TERMINALE
-- =====================================================================================
-- Description : 80 sous-notions du programme de mathématiques de Terminale

DELETE FROM public.bo_terminale;

INSERT INTO public.bo_terminale (chapitre, sous_notion) VALUES
-- Suites et récurrence (7)
('Suites et récurrence', 'Définition par récurrence'),
('Suites et récurrence', 'Raisonnement par récurrence'),
('Suites et récurrence', 'Limite d''une suite'),
('Suites et récurrence', 'Suites arithmétiques et géométriques'),
('Suites et récurrence', 'Opérations sur les limites'),
('Suites et récurrence', 'Comparaison de suites'),
('Suites et récurrence', 'Théorème de convergence monotone'),

-- Limites de fonctions (4)
('Limites de fonctions', 'Limite finie ou infinie en l''infini ou en un point'),
('Limites de fonctions', 'Asymptotes'),
('Limites de fonctions', 'Opérations sur les limites'),
('Limites de fonctions', 'Croissances comparées'),

-- Continuité (5)
('Continuité', 'Définition par les limites'),
('Continuité', 'Théorème des valeurs intermédiaires'),
('Continuité', 'Cas des fonctions continues strictement monotones'),
('Continuité', 'Image d''une suite convergente'),
('Continuité', 'Fonction dérivable continue'),

-- Compléments sur la dérivation (4)
('Compléments sur la dérivation', 'Dérivée d''une fonction composée'),
('Compléments sur la dérivation', 'Dérivée seconde'),
('Compléments sur la dérivation', 'Convexité'),
('Compléments sur la dérivation', 'Point d''inflexion'),

-- Fonction logarithme népérien (5)
('Fonction logarithme népérien', 'Fonction réciproque de l''exponentielle'),
('Fonction logarithme népérien', 'Propriétés algébriques'),
('Fonction logarithme népérien', 'Dérivée'),
('Fonction logarithme népérien', 'Limites en 0 et en +∞'),
('Fonction logarithme népérien', 'Croissances comparées'),

-- Fonctions sinus et cosinus (3)
('Fonctions sinus et cosinus', 'Dérivées'),
('Fonctions sinus et cosinus', 'Variations'),
('Fonctions sinus et cosinus', 'Résolution d''équations trigonométriques'),

-- Primitives et équations différentielles (4)
('Primitives et équations différentielles', 'Primitives des fonctions usuelles'),
('Primitives et équations différentielles', 'Équations du type y'' = f'),
('Primitives et équations différentielles', 'Équations différentielles y'' = ay'),
('Primitives et équations différentielles', 'Équations différentielles y'' = ay + b'),

-- Calcul intégral (8)
('Calcul intégral', 'Intégrale d''une fonction continue positive'),
('Calcul intégral', 'Notation ∫ₐᵇ f(x)dx'),
('Calcul intégral', 'Linéarité de l''intégrale'),
('Calcul intégral', 'Relation de Chasles'),
('Calcul intégral', 'Calcul d''intégrale à l''aide de primitives'),
('Calcul intégral', 'Valeur moyenne'),
('Calcul intégral', 'Intégration par parties'),
('Calcul intégral', 'Primitive s''annulant en a'),

-- Nombres complexes (6)
('Nombres complexes', 'Forme algébrique'),
('Nombres complexes', 'Conjugué d''un nombre complexe'),
('Nombres complexes', 'Module et argument'),
('Nombres complexes', 'Forme trigonométrique'),
('Nombres complexes', 'Forme exponentielle'),
('Nombres complexes', 'Interprétation géométrique'),

-- Géométrie repérée dans l'espace (3)
('Géométrie repérée dans l''espace', 'Représentation paramétrique d''une droite'),
('Géométrie repérée dans l''espace', 'Équation cartésienne d''un plan'),
('Géométrie repérée dans l''espace', 'Systèmes d''équations linéaires'),

-- Manipuler les vecteurs de l'espace (4)
('Manipuler les vecteurs de l''espace', 'Repérage dans l''espace'),
('Manipuler les vecteurs de l''espace', 'Décomposition dans une base'),
('Manipuler les vecteurs de l''espace', 'Coplanarité'),
('Manipuler les vecteurs de l''espace', 'Translation dans l''espace'),

-- Produit scalaire dans l'espace (5)
('Produit scalaire dans l''espace', 'Définition et propriétés'),
('Produit scalaire dans l''espace', 'Expression dans une base orthonormée'),
('Produit scalaire dans l''espace', 'Orthogonalité dans l''espace'),
('Produit scalaire dans l''espace', 'Vecteur normal à un plan'),
('Produit scalaire dans l''espace', 'Projeté orthogonal sur un plan'),

-- Combinatoire et dénombrement (6)
('Combinatoire et dénombrement', 'Principe additif et principe multiplicatif'),
('Combinatoire et dénombrement', 'Permutations et factorielle'),
('Combinatoire et dénombrement', 'Combinaisons'),
('Combinatoire et dénombrement', 'k-uplets'),
('Combinatoire et dénombrement', 'Nombre de parties d''un ensemble fini'),
('Combinatoire et dénombrement', 'Triangle de Pascal'),

-- Sommes de variables aléatoires (5)
('Sommes de variables aléatoires', 'Espérance et variance d''une somme'),
('Sommes de variables aléatoires', 'Loi binomiale'),
('Sommes de variables aléatoires', 'Échantillon et moyenne empirique'),
('Sommes de variables aléatoires', 'Schéma de Bernoulli'),
('Sommes de variables aléatoires', 'Loi des grands nombres (pour les variables aléatoires)'),

-- Concentration et loi des grands nombres (3)
('Concentration et loi des grands nombres', 'Inégalité de Bienaymé-Tchebychev'),
('Concentration et loi des grands nombres', 'Inégalité de concentration'),
('Concentration et loi des grands nombres', 'Loi des grands nombres'),

-- Manipuler les listes (4)
('Manipuler les listes', 'Génération par extension et en compréhension'),
('Manipuler les listes', 'Manipulation d''éléments et d''indices'),
('Manipuler les listes', 'Itération sur les éléments'),
('Manipuler les listes', 'Parcours de listes');

-- =====================================================================================
-- SECTION 10 (suite) : DONNÉES DE RÉFÉRENCE - HORS PROGRAMME CLASSE
-- =====================================================================================
-- Description : Notions hors programme par classe pour éviter les confusions

DELETE FROM public.hors_programme_classe;

INSERT INTO public.hors_programme_classe (classe, notion, niveau_cible) VALUES
-- Seconde : notions hors programme (vu en Première)
('Seconde', 'Dérivation', 'Première'),
('Seconde', 'Nombre dérivé', 'Première'),
('Seconde', 'Fonction dérivée', 'Première'),
('Seconde', 'Tangente à une courbe', 'Première'),
('Seconde', 'Suites numériques', 'Première'),
('Seconde', 'Suite arithmétique', 'Première'),
('Seconde', 'Suite géométrique', 'Première'),
('Seconde', 'Récurrence', 'Première'),
('Seconde', 'Second degré discriminant', 'Première'),
('Seconde', 'Produit scalaire', 'Première'),
('Seconde', 'Trigonométrie cercle trigonométrique', 'Première'),
('Seconde', 'Probabilités conditionnelles', 'Première'),
('Seconde', 'Fonction exponentielle', 'Première'),

-- Seconde : notions hors programme (vu en Terminale)
('Seconde', 'Limites de fonctions', 'Terminale'),
('Seconde', 'Continuité', 'Terminale'),
('Seconde', 'Asymptotes', 'Terminale'),
('Seconde', 'Logarithme népérien', 'Terminale'),
('Seconde', 'Nombres complexes', 'Terminale'),
('Seconde', 'Primitives', 'Terminale'),
('Seconde', 'Calcul intégral', 'Terminale'),
('Seconde', 'Équations différentielles', 'Terminale'),
('Seconde', 'Loi normale', 'Terminale'),

-- Première : notions hors programme (vu en Terminale)
('Première', 'Limites de fonctions', 'Terminale'),
('Première', 'Continuité', 'Terminale'),
('Première', 'Asymptotes', 'Terminale'),
('Première', 'Croissances comparées', 'Terminale'),
('Première', 'Logarithme népérien', 'Terminale'),
('Première', 'Nombres complexes', 'Terminale'),
('Première', 'Primitives', 'Terminale'),
('Première', 'Calcul intégral', 'Terminale'),
('Première', 'Équations différentielles', 'Terminale'),
('Première', 'Géométrie dans l''espace vecteurs', 'Terminale'),
('Première', 'Plans et droites dans l''espace', 'Terminale'),
('Première', 'Loi normale', 'Terminale'),
('Première', 'Intervalle de confiance', 'Terminale'),

-- Terminale : notions hors programme (Prépa/Université)
('Terminale', 'Développements limités', 'Prépa/Université'),
('Terminale', 'Formule de Taylor', 'Prépa/Université'),
('Terminale', 'Séries numériques', 'Prépa/Université'),
('Terminale', 'Séries entières', 'Prépa/Université'),
('Terminale', 'Intégrales généralisées', 'Prépa/Université'),
('Terminale', 'Intégrales doubles', 'Prépa/Université'),
('Terminale', 'Intégrales triples', 'Prépa/Université'),
('Terminale', 'Équations différentielles ordre 2', 'Prépa/Université'),
('Terminale', 'Espaces vectoriels', 'Prépa/Université'),
('Terminale', 'Calcul matriciel avancé', 'Prépa/Université'),
('Terminale', 'Déterminants', 'Prépa/Université'),
('Terminale', 'Valeurs propres et vecteurs propres', 'Prépa/Université'),
('Terminale', 'Fonctions de plusieurs variables', 'Prépa/Université'),
('Terminale', 'Dérivées partielles', 'Prépa/Université'),
('Terminale', 'Topologie', 'Prépa/Université');

-- =====================================================================================
-- SECTION 11 : RÉVOCATION DES PRIVILÈGES ANONYMES
-- =====================================================================================
-- Description : Sécurisation en révoquant l'accès anonyme aux tables sensibles

REVOKE ALL ON public.profiles FROM anon;
REVOKE ALL ON public.student_profiles FROM anon;
REVOKE ALL ON public.user_roles FROM anon;
REVOKE ALL ON public.sessions FROM anon;
REVOKE ALL ON public.chats FROM anon;
REVOKE ALL ON public.chat_history FROM anon;
REVOKE ALL ON public.interactions FROM anon;
REVOKE ALL ON public.interventions_pedagogiques FROM anon;
REVOKE ALL ON public.parent_invitations FROM anon;
REVOKE ALL ON public.parent_eleve_relations FROM anon;
REVOKE ALL ON public.email_confirmations FROM anon;
REVOKE ALL ON public.pending_signups FROM anon;
REVOKE ALL ON public.password_reset_tokens FROM anon;
REVOKE ALL ON public.user_feedback FROM anon;
REVOKE ALL ON public.chat_feedback FROM anon;
REVOKE ALL ON public.competences_snapshots FROM anon;

-- Les tables BO restent accessibles en lecture (publiques)
GRANT SELECT ON public.bo_seconde TO anon;
GRANT SELECT ON public.bo_premiere TO anon;
GRANT SELECT ON public.bo_terminale TO anon;
GRANT SELECT ON public.hors_programme_classe TO anon;
GRANT SELECT ON public.exercices TO anon;

-- =====================================================================================
-- SECTION 12 : EXEMPLES DE DONNÉES JSONB
-- =====================================================================================
-- Description : Exemples complets de la structure des colonnes JSONB

/*
=============================================================================
EXEMPLE 1 : student_profiles.competences
=============================================================================
Structure : Objet avec chapitres comme clés, contenant des sous-notions avec stats

{
  "Suites numériques": {
    "echecs_globaux": 3,
    "reussites_globales": 12,
    "sous_notions": {
      "Suites arithmétiques": {
        "echecs": 1,
        "reussites": 5,
        "statut": "maitrise",
        "derniere_maj": "2026-01-15T10:30:00.000Z",
        "decroissance_appliquee": false
      },
      "Suites géométriques": {
        "echecs": 2,
        "reussites": 4,
        "statut": "en_cours",
        "derniere_maj": "2026-01-14T14:20:00.000Z",
        "decroissance_appliquee": false
      },
      "Modes de génération (explicite, récurrence)": {
        "echecs": 0,
        "reussites": 3,
        "statut": "maitrise",
        "derniere_maj": "2026-01-10T09:00:00.000Z",
        "decroissance_appliquee": true
      }
    }
  },
  "Dérivation": {
    "echecs_globaux": 5,
    "reussites_globales": 8,
    "sous_notions": {
      "Nombre dérivé en un point": {
        "echecs": 2,
        "reussites": 3,
        "statut": "en_cours",
        "derniere_maj": "2026-01-15T11:00:00.000Z"
      },
      "Équation de tangente": {
        "echecs": 3,
        "reussites": 2,
        "statut": "en_difficulte",
        "derniere_maj": "2026-01-15T11:30:00.000Z"
      },
      "Lien entre signe de la dérivée et variations": {
        "echecs": 0,
        "reussites": 3,
        "statut": "maitrise",
        "derniere_maj": "2026-01-13T16:00:00.000Z"
      }
    }
  },
  "Nombres complexes": {
    "echecs_globaux": 0,
    "reussites_globales": 0,
    "sous_notions": {
      "Forme algébrique": {
        "echecs": 0,
        "reussites": 0,
        "statut": "non_evalue"
      },
      "Forme exponentielle": {
        "echecs": 0,
        "reussites": 0,
        "statut": "non_evalue"
      }
    }
  }
}

Statuts possibles :
- "non_evalue" : Jamais travaillé
- "en_cours" : En cours d'apprentissage  
- "maitrise" : Maîtrisé (≥3 réussites consécutives)
- "en_difficulte" : Difficultés identifiées (≥3 échecs)

=============================================================================
EXEMPLE 2 : student_profiles.lacunes_identifiees
=============================================================================
Structure : Tableau d'objets décrivant les lacunes détectées

[
  {
    "chapitre": "Dérivation",
    "sous_notion": "Équation de tangente",
    "type_erreur": "application_formule",
    "description": "Confusion entre f(a) et f'(a) dans l'équation y = f'(a)(x-a) + f(a)",
    "gravite": 3,
    "date_detection": "2026-01-15T11:30:00.000Z",
    "exercices_concernes": 3,
    "prerequis_manquant": "Nombre dérivé en un point"
  },
  {
    "chapitre": "Suites numériques",
    "sous_notion": "Suites géométriques",
    "type_erreur": "calcul",
    "description": "Erreur de manipulation des puissances dans q^n",
    "gravite": 2,
    "date_detection": "2026-01-14T14:20:00.000Z",
    "exercices_concernes": 2,
    "prerequis_manquant": null
  }
]

Niveaux de gravité :
- 1 : Légère (erreur d'inattention)
- 2 : Modérée (incompréhension partielle)
- 3 : Importante (lacune fondamentale)

=============================================================================
EXEMPLE 3 : student_profiles.recent_cours_context
=============================================================================
Structure : Contexte des derniers cours consultés pour personnalisation

{
  "dernier_chapitre": "Calcul intégral",
  "dernieres_notions_vues": [
    "Notation ∫ₐᵇ f(x)dx",
    "Linéarité de l'intégrale",
    "Relation de Chasles"
  ],
  "derniere_session_cours": "2026-01-15T10:00:00.000Z",
  "questions_posees": [
    "Comment calculer une intégrale avec des bornes ?",
    "Quelle est la différence entre primitive et intégrale ?"
  ],
  "points_clarifies": [
    "La primitive F vérifie F'(x) = f(x)",
    "L'intégrale ∫ₐᵇ f(x)dx = F(b) - F(a)"
  ],
  "difficultes_identifiees": [
    "Confusion entre intégration et dérivation"
  ],
  "exemples_donnes": [
    {
      "fonction": "f(x) = 2x",
      "primitive": "F(x) = x²",
      "integrale_0_1": 1
    }
  ]
}

=============================================================================
EXEMPLE 4 : chats.exercise_context
=============================================================================
Structure : Contexte complet d'un exercice en cours

{
  "enonce_original": "Soit f la fonction définie sur ℝ par f(x) = x³ - 3x² + 4.\n1. Calculer f'(x).\n2. Dresser le tableau de variations de f.\n3. Déterminer les extremums locaux.\n4. Calculer l'équation de la tangente en x = 1.\n5. Calculer l'équation de la tangente en x = 0.",
  "solution_complete": "1. f'(x) = 3x² - 6x = 3x(x-2)\n2. f'(x) = 0 ⟺ x = 0 ou x = 2\n   Sur ]-∞;0[: f'(x) > 0, f croissante\n   Sur ]0;2[: f'(x) < 0, f décroissante\n   Sur ]2;+∞[: f'(x) > 0, f croissante\n3. Maximum local: f(0) = 4\n   Minimum local: f(2) = 0\n4. (T₁): y = f'(1)(x-1) + f(1) = -3(x-1) + 2 = -3x + 5\n5. (T₀): y = f'(0)(x-0) + f(0) = 0 + 4 = 4",
  "resolution_eleve": "f(x) = x³ - 3x² + 4\n1. f'(x) = 3x² - 6x = 3x(x-2)\n2. Tableau de variations correct\n3. Maximum f(0) = 4, Minimum f(2) = 0\n4. (T₁): y = -3(x-1) + 2\n5. (T₀): y = 4",
  "corrections_remarques": "✅ Travail correct et complet",
  "etapes_validees": [1, 2, 3, 4, 5],
  "etapes_en_erreur": [],
  "indices_donnes": 0,
  "tentatives": 1,
  "derniere_maj": "2026-01-15T10:30:00.000Z",
  "statut": "termine_correct"
}

Statuts possibles :
- "en_cours" : Exercice non terminé
- "termine_correct" : Toutes les étapes validées
- "termine_partiel" : Terminé avec des erreurs
- "abandonne" : Élève a abandonné

=============================================================================
EXEMPLE 5 : interactions.analyse_erreur
=============================================================================
Structure : Analyse détaillée d'une interaction élève-IA

{
  "est_correct": false,
  "type": "analyse",
  "timestamp": "2026-01-15T11:30:00.000Z",
  "analyse_fine": {
    "chapitre": "Dérivation",
    "sous_notion": "Équation de tangente",
    "etapes_analysees": [
      {
        "numero": 1,
        "attendu": "y = f'(a)(x-a) + f(a)",
        "reponse_eleve": "y = f(a)(x-a) + f'(a)",
        "correct": false,
        "type_erreur": "inversion_termes",
        "explication": "Tu as inversé f(a) et f'(a) dans la formule"
      }
    ],
    "erreurs_identifiees": [
      {
        "type": "conceptuel",
        "description": "Confusion entre la valeur de la fonction et sa dérivée",
        "gravite": 3,
        "prerequis_manquant": "Nombre dérivé en un point"
      }
    ],
    "points_positifs": [
      "Tu as correctement identifié que tu dois utiliser la formule de la tangente"
    ]
  },
  "reponse_naturelle": "Tu as fait une petite confusion dans la formule de la tangente. La formule correcte est :\n\ny = f'(a)(x - a) + f(a)\n\nOù f'(a) est la **pente** (le nombre dérivé en a) et f(a) est l'**ordonnée du point de tangence**.\n\nTu as inversé ces deux valeurs. Essaie de te souvenir : la pente vient de la dérivée, c'est donc f'(a) qui multiplie (x-a).\n\nPeux-tu réessayer avec cette formule ? 😊",
  "score_confiance": 0.92,
  "tokens_utilises": 847
}

Types d'erreurs :
- "conceptuel" : Mauvaise compréhension du concept
- "calcul" : Erreur de calcul
- "inattention" : Erreur d'étourderie
- "notation" : Erreur de notation/écriture
- "methode" : Mauvaise méthode utilisée

=============================================================================
EXEMPLE 6 : sessions.progression
=============================================================================
Structure : Progression durant une session d'apprentissage

{
  "exercices_realises": 5,
  "exercices_reussis": 3,
  "exercices_echoues": 2,
  "chapitres_travailles": [
    "Suites numériques",
    "Dérivation"
  ],
  "temps_par_exercice": [
    {"exercice_id": "uuid-1", "duree_minutes": 8, "reussi": true},
    {"exercice_id": "uuid-2", "duree_minutes": 12, "reussi": false},
    {"exercice_id": "uuid-3", "duree_minutes": 6, "reussi": true},
    {"exercice_id": "uuid-4", "duree_minutes": 15, "reussi": false},
    {"exercice_id": "uuid-5", "duree_minutes": 7, "reussi": true}
  ],
  "competences_ameliorees": [
    "Suites arithmétiques",
    "Nombre dérivé en un point"
  ],
  "lacunes_detectees": [
    "Équation de tangente"
  ]
}

=============================================================================
EXEMPLE 7 : exercices.indices
=============================================================================
Structure : Tableau d'indices progressifs pour un exercice

[
  "Pour calculer U₁, utilise la formule U_{n+1} = 3U_n - 4 avec n=0.",
  "Pour l'initialisation de la récurrence, remplace n par 0 dans P(n) et vérifie si elle correspond à U₀.",
  "Pour l'hérédité, pars de U_n = 3^n + 1 et montre que U_{n+1} = 3^{n+1} + 1."
]

=============================================================================
EXEMPLE 8 : exercices.params
=============================================================================
Structure : Paramètres de génération de l'exercice

{
  "difficulte": "moyen",
  "type": "application",
  "temps_estime_minutes": 10,
  "competences_ciblees": [
    "Suites géométriques",
    "Raisonnement par récurrence"
  ],
  "prerequis": [
    "Suites arithmétiques",
    "Puissances"
  ],
  "variantes_possibles": 3,
  "source": "genere_ia",
  "date_generation": "2026-01-15T09:00:00.000Z"
}

*/

-- =====================================================================================
-- SECTION 13 : TABLES SUPPLÉMENTAIRES (si existantes)
-- =====================================================================================
-- Description : Tables additionnelles non listées dans le schéma principal

/*
NOTE : Les tables suivantes N'EXISTENT PAS actuellement dans la base de données :
- chat_rules : Non implémentée
- learning_queue : Non implémentée

Si ces tables doivent être créées à l'avenir, voici des modèles suggérés :
*/

-- Table suggérée : chat_rules (règles de modération du chat)
/*
CREATE TABLE IF NOT EXISTS public.chat_rules (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    rule_name text NOT NULL UNIQUE,
    rule_description text NOT NULL,
    is_active boolean DEFAULT true,
    priority integer DEFAULT 0,
    conditions jsonb DEFAULT '{}'::jsonb,
    actions jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- Exemple de données :
INSERT INTO public.chat_rules (rule_name, rule_description, conditions, actions) VALUES
('block_inappropriate', 'Bloquer le contenu inapproprié', 
 '{"keywords": ["insulte1", "insulte2"], "threshold": 0.8}',
 '{"action": "block", "message": "Ce message ne peut pas être envoyé."}'),
('encourage_struggling', 'Encourager les élèves en difficulté',
 '{"consecutive_errors": 3, "mood": "stressed"}',
 '{"action": "soften_tone", "add_encouragement": true}');
*/

-- Table suggérée : learning_queue (file d'attente d'apprentissage adaptatif)
/*
CREATE TABLE IF NOT EXISTS public.learning_queue (
    id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid NOT NULL,
    chapitre text NOT NULL,
    sous_notion text NOT NULL,
    priorite integer DEFAULT 0,
    raison text,
    date_ajout timestamp with time zone DEFAULT now(),
    date_revue_prevue timestamp with time zone,
    nb_revisions integer DEFAULT 0,
    statut text DEFAULT 'en_attente',
    CONSTRAINT fk_learning_queue_user FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

CREATE INDEX idx_learning_queue_user ON public.learning_queue (user_id, priorite DESC);

ALTER TABLE public.learning_queue ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own queue" ON public.learning_queue
    FOR ALL USING (auth.uid() = user_id);
*/

-- =====================================================================================
-- SECTION 14 : VIEWS (Vues)
-- =====================================================================================
-- Description : Aucune vue n'existe actuellement dans la base de données

/*
NOTE : Il n'y a actuellement AUCUNE vue (VIEW) définie dans le schéma public.

Si des vues doivent être créées à l'avenir, voici des exemples utiles :
*/

-- Vue suggérée : v_student_progress (vue synthétique de la progression des élèves)
/*
CREATE OR REPLACE VIEW public.v_student_progress AS
SELECT 
    p.user_id,
    p.prenom,
    p.nom,
    p.classe,
    sp.competences,
    sp.lacunes_identifiees,
    sp.updated_at AS derniere_activite,
    (SELECT COUNT(*) FROM sessions s WHERE s.user_id = p.user_id) AS nb_sessions,
    (SELECT COUNT(*) FROM interactions i WHERE i.user_id = p.user_id) AS nb_interactions,
    (SELECT COUNT(*) FROM interactions i 
     WHERE i.user_id = p.user_id 
     AND i.analyse_erreur->>'est_correct' = 'true') AS nb_reussites
FROM profiles p
LEFT JOIN student_profiles sp ON sp.user_id = p.user_id
WHERE EXISTS (SELECT 1 FROM user_roles ur WHERE ur.user_id = p.user_id AND ur.role = 'eleve');
*/

-- Vue suggérée : v_parent_children (vue des enfants pour les parents)
/*
CREATE OR REPLACE VIEW public.v_parent_children AS
SELECT 
    per.parent_user_id,
    per.eleve_user_id,
    p.prenom AS enfant_prenom,
    p.nom AS enfant_nom,
    p.classe AS enfant_classe,
    sp.competences,
    (SELECT MAX(s.date_debut) FROM sessions s WHERE s.user_id = per.eleve_user_id) AS derniere_session
FROM parent_eleve_relations per
JOIN profiles p ON p.user_id = per.eleve_user_id
LEFT JOIN student_profiles sp ON sp.user_id = per.eleve_user_id;
*/

-- Vue suggérée : v_chapter_stats (statistiques par chapitre)
/*
CREATE OR REPLACE VIEW public.v_chapter_stats AS
SELECT 
    i.chapitre,
    COUNT(*) AS nb_interactions,
    COUNT(DISTINCT i.user_id) AS nb_eleves,
    SUM(CASE WHEN i.analyse_erreur->>'est_correct' = 'true' THEN 1 ELSE 0 END) AS nb_reussites,
    SUM(CASE WHEN i.analyse_erreur->>'est_correct' = 'false' THEN 1 ELSE 0 END) AS nb_echecs,
    ROUND(
        100.0 * SUM(CASE WHEN i.analyse_erreur->>'est_correct' = 'true' THEN 1 ELSE 0 END) / 
        NULLIF(COUNT(*), 0), 
        2
    ) AS taux_reussite_pct
FROM interactions i
WHERE i.chapitre IS NOT NULL
GROUP BY i.chapitre
ORDER BY nb_interactions DESC;
*/

-- =====================================================================================
-- FIN DU FICHIER DE RECONSTRUCTION
-- =====================================================================================
-- 
-- INSTRUCTIONS D'UTILISATION :
-- 1. Exécuter ce fichier sur une base Supabase vierge
-- 2. Les sections doivent être exécutées dans l'ordre
-- 3. Vérifier que l'extension pgcrypto est activée (gen_random_uuid)
-- 4. Les edge functions doivent être déployées séparément
-- 5. Les secrets doivent être configurés dans le dashboard Supabase
--
-- AVERTISSEMENTS :
-- - Ce fichier ne contient pas les données utilisateurs
-- - Les backups de données doivent être faits séparément
-- - Tester sur un environnement de développement avant production
--
-- =====================================================================================
