-- Create user_feedback table for CSAT data
CREATE TABLE public.user_feedback (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  
  -- CSAT data
  csat_score INTEGER NOT NULL CHECK (csat_score IN (1, 3, 5)), -- 😞=1, 😐=3, 😊=5
  difficulty TEXT CHECK (difficulty IN ('facile', 'moyen', 'dur')),
  comment TEXT,
  
  -- Metadata utilisateur (dénormalisé pour l'email)
  user_prenom TEXT,
  user_nom TEXT,
  user_classe TEXT,
  user_email TEXT
);

-- Enable RLS
ALTER TABLE public.user_feedback ENABLE ROW LEVEL SECURITY;

-- Users can insert their own feedback
CREATE POLICY "Users can insert their own feedback" ON public.user_feedback
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can view their own feedback
CREATE POLICY "Users can view their own feedback" ON public.user_feedback
  FOR SELECT USING (auth.uid() = user_id);