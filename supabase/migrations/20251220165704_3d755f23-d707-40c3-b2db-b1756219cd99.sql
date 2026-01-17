-- Supprimer la politique RLS trop permissive sur la table exercices
DROP POLICY IF EXISTS "Service role can insert exercices" ON public.exercices;