-- Add RLS policy to allow parents to view their children's profiles
CREATE POLICY "Parents can view their children's profiles"
ON public.profiles
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM public.parent_eleve_relations
    WHERE parent_eleve_relations.parent_user_id = auth.uid()
    AND parent_eleve_relations.eleve_user_id = profiles.user_id
  )
);