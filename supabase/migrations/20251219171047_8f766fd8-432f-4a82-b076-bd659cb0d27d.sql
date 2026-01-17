-- Supprimer la politique RLS qui permet aux élèves d'insérer directement des relations
-- Cela force le passage par l'Edge Function create-parent-account qui valide le token d'invitation
DROP POLICY IF EXISTS "Eleves can create parent relations" ON public.parent_eleve_relations;