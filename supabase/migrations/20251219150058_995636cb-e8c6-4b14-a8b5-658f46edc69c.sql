-- ===========================================
-- PHASE 1: Sécurisation des tables critiques
-- ===========================================

-- 1. Table pending_signups - Activer RLS avec policy restrictive
ALTER TABLE public.pending_signups ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Service role only - no direct access"
ON public.pending_signups
FOR ALL
USING (false);

-- 2. Table parent_invitations - Supprimer la policy publique dangereuse
DROP POLICY IF EXISTS "Public can read pending invitations by token" ON public.parent_invitations;

-- ===========================================
-- PHASE 2: Ajout des policies DELETE manquantes
-- ===========================================

-- 3. Table chat_history - DELETE policy
CREATE POLICY "Users can delete their chat messages"
ON public.chat_history
FOR DELETE
USING (EXISTS (
  SELECT 1 FROM chats
  WHERE chats.id = chat_history.chat_id
  AND chats.user_id = auth.uid()
));

-- 4. Table chats - DELETE policy
CREATE POLICY "Users can delete their own chats"
ON public.chats
FOR DELETE
USING (auth.uid() = user_id);

-- 5. Table student_profiles - DELETE policy
CREATE POLICY "Users can delete their own student profile"
ON public.student_profiles
FOR DELETE
USING (auth.uid() = user_id);

-- 6. Table sessions - DELETE policy
CREATE POLICY "Users can delete their own sessions"
ON public.sessions
FOR DELETE
USING (auth.uid() = user_id);

-- 7. Table interventions_pedagogiques - DELETE policy
CREATE POLICY "Users can delete their own interventions"
ON public.interventions_pedagogiques
FOR DELETE
USING (auth.uid() = user_id);

-- 8. Table parent_eleve_relations - DELETE policy
CREATE POLICY "Students can delete their parent relations"
ON public.parent_eleve_relations
FOR DELETE
USING (auth.uid() = eleve_user_id OR has_role(auth.uid(), 'administrateur'));

-- 9. Table parent_invitations - DELETE policy
CREATE POLICY "Students can delete their own invitations"
ON public.parent_invitations
FOR DELETE
USING (auth.uid() = eleve_user_id OR has_role(auth.uid(), 'administrateur'));