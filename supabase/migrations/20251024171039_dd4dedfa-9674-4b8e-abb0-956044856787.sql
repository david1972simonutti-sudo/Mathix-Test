-- 1. Créer la nouvelle table chats
CREATE TABLE public.chats (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  exercice_id uuid UNIQUE REFERENCES public.exercices(id) ON DELETE CASCADE,
  session_id uuid REFERENCES public.sessions(id) ON DELETE SET NULL,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- Index pour performance
CREATE INDEX idx_chats_user_id ON public.chats(user_id);
CREATE INDEX idx_chats_exercice_id ON public.chats(exercice_id);
CREATE INDEX idx_chats_session_id ON public.chats(session_id);

-- RLS policies pour chats
ALTER TABLE public.chats ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own chats"
  ON public.chats FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own chats"
  ON public.chats FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own chats"
  ON public.chats FOR UPDATE
  USING (auth.uid() = user_id);

-- Trigger pour updated_at
CREATE TRIGGER update_chats_updated_at
  BEFORE UPDATE ON public.chats
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- 2. Modifier la table chat_history
ALTER TABLE public.chat_history 
  DROP COLUMN IF EXISTS session_id,
  DROP COLUMN IF EXISTS exercice_id;

ALTER TABLE public.chat_history
  ADD COLUMN chat_id uuid REFERENCES public.chats(id) ON DELETE CASCADE;

CREATE INDEX idx_chat_history_chat_id ON public.chat_history(chat_id);

-- Supprimer anciennes policies
DROP POLICY IF EXISTS "Users can view their own chat history" ON public.chat_history;
DROP POLICY IF EXISTS "Users can insert their own chat history" ON public.chat_history;
DROP POLICY IF EXISTS "Users can view their own chat messages" ON public.chat_history;
DROP POLICY IF EXISTS "Users can insert their own chat messages" ON public.chat_history;

-- Nouvelles RLS policies basées sur chat_id
CREATE POLICY "Users can view their chat messages"
  ON public.chat_history FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.chats
      WHERE chats.id = chat_history.chat_id
      AND chats.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert their chat messages"
  ON public.chat_history FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.chats
      WHERE chats.id = chat_history.chat_id
      AND chats.user_id = auth.uid()
    )
  );

-- 3. Ajouter chat_id à la table interactions
ALTER TABLE public.interactions
  ADD COLUMN chat_id uuid REFERENCES public.chats(id) ON DELETE SET NULL;

CREATE INDEX idx_interactions_chat_id ON public.interactions(chat_id);

-- 4. Nettoyer la table sessions
ALTER TABLE public.sessions
  DROP COLUMN IF EXISTS current_exercice_id;