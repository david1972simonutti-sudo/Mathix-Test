-- Ajouter la colonne recent_cours_context pour stocker le contexte récent des cours
ALTER TABLE public.student_profiles
ADD COLUMN IF NOT EXISTS recent_cours_context JSONB DEFAULT '{}'::jsonb;

-- Commenter la colonne pour la documentation
COMMENT ON COLUMN public.student_profiles.recent_cours_context IS 'Stocke les notions récemment expliquées sur /cours pour continuité pédagogique avec /exercise. Structure: {chapitres_abordes: [], sous_notions_expliquees: [], resume_court: string, derniere_mise_a_jour: timestamp}';