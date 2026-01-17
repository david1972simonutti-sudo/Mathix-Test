-- 1. Supprimer la politique problématique "Service role can insert interventions"
DROP POLICY IF EXISTS "Service role can insert interventions" ON public.interventions_pedagogiques;

-- 2. Ajouter contrainte UNIQUE sur profiles.email (si pas déjà présente)
ALTER TABLE public.profiles 
ADD CONSTRAINT profiles_email_unique UNIQUE (email);