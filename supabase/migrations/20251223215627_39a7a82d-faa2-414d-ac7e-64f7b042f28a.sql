-- RLS policy pour que les parents puissent lire les student_profiles de leurs enfants
CREATE POLICY "Parents can view their children's student profiles" 
ON public.student_profiles 
FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM parent_eleve_relations
    WHERE parent_eleve_relations.parent_user_id = auth.uid()
    AND parent_eleve_relations.eleve_user_id = student_profiles.user_id
  )
);

-- RLS policy pour que les parents puissent lire les sessions de leurs enfants
CREATE POLICY "Parents can view their children's sessions" 
ON public.sessions 
FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM parent_eleve_relations
    WHERE parent_eleve_relations.parent_user_id = auth.uid()
    AND parent_eleve_relations.eleve_user_id = sessions.user_id
  )
);

-- RLS policy pour que les parents puissent lire les interactions de leurs enfants
CREATE POLICY "Parents can view their children's interactions" 
ON public.interactions 
FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM parent_eleve_relations
    WHERE parent_eleve_relations.parent_user_id = auth.uid()
    AND parent_eleve_relations.eleve_user_id = interactions.user_id
  )
);