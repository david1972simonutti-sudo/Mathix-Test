-- CORRECTIF CRITIQUE : Empêcher l'auto-attribution du rôle administrateur
-- La politique actuelle permet à n'importe quel utilisateur de s'attribuer n'importe quel rôle

-- Supprimer l'ancienne politique vulnérable
DROP POLICY IF EXISTS "Users can insert their own role during signup" ON public.user_roles;

-- Nouvelle politique : Les utilisateurs peuvent uniquement s'attribuer le rôle 'eleve'
CREATE POLICY "Users can only self-assign eleve role during signup" 
ON public.user_roles 
FOR INSERT 
WITH CHECK (
  auth.uid() = user_id 
  AND role = 'eleve'::app_role
);

-- CORRECTIF : Révoquer les privilèges du rôle anon sur les tables sensibles
-- Même si RLS protège les données, c'est une défense en profondeur

REVOKE ALL ON public.chat_history FROM anon;
REVOKE ALL ON public.sessions FROM anon;
REVOKE ALL ON public.interactions FROM anon;
REVOKE ALL ON public.user_roles FROM anon;
REVOKE ALL ON public.parent_invitations FROM anon;
REVOKE ALL ON public.student_profiles FROM anon;
REVOKE ALL ON public.profiles FROM anon;
REVOKE ALL ON public.chats FROM anon;
REVOKE ALL ON public.interventions_pedagogiques FROM anon;
REVOKE ALL ON public.user_feedback FROM anon;
REVOKE ALL ON public.chat_feedback FROM anon;
REVOKE ALL ON public.parent_eleve_relations FROM anon;