-- Supprimer les colonnes redondantes de user_feedback
ALTER TABLE public.user_feedback 
  DROP COLUMN IF EXISTS user_email,
  DROP COLUMN IF EXISTS user_prenom,
  DROP COLUMN IF EXISTS user_nom,
  DROP COLUMN IF EXISTS user_classe;

-- Supprimer les colonnes redondantes de chat_feedback
ALTER TABLE public.chat_feedback
  DROP COLUMN IF EXISTS user_email,
  DROP COLUMN IF EXISTS user_prenom,
  DROP COLUMN IF EXISTS user_classe;