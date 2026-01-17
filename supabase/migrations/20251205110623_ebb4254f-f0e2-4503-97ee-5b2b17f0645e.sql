-- Create chat_feedback table
CREATE TABLE public.chat_feedback (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID REFERENCES public.chats(id) ON DELETE CASCADE,
  message_id TEXT NOT NULL,
  user_id UUID NOT NULL,
  rating TEXT NOT NULL CHECK (rating IN ('positive', 'negative')),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  user_prenom TEXT,
  user_email TEXT,
  user_classe TEXT,
  message_content TEXT
);

-- Indexes for performance
CREATE INDEX idx_chat_feedback_conversation ON chat_feedback(conversation_id);
CREATE INDEX idx_chat_feedback_user ON chat_feedback(user_id);
CREATE INDEX idx_chat_feedback_created ON chat_feedback(created_at);

-- Enable RLS
ALTER TABLE chat_feedback ENABLE ROW LEVEL SECURITY;

-- RLS policies
CREATE POLICY "Users can insert their own feedback"
  ON chat_feedback FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own feedback"
  ON chat_feedback FOR SELECT
  USING (auth.uid() = user_id);