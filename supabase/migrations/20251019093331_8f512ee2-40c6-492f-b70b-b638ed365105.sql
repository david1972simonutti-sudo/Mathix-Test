-- Add content_hash and params columns to exercices table for deduplication and parameter tracking
ALTER TABLE public.exercices 
ADD COLUMN IF NOT EXISTS content_hash TEXT UNIQUE,
ADD COLUMN IF NOT EXISTS params JSONB DEFAULT '{}'::jsonb;

-- Create index on content_hash for fast duplicate detection
CREATE INDEX IF NOT EXISTS idx_exercices_content_hash ON public.exercices(content_hash);

-- Create index on user_id in interactions for faster user-specific queries
CREATE INDEX IF NOT EXISTS idx_interactions_user_id ON public.interactions(user_id);

-- Create composite index on user_id and created_at for recent exercises lookup
CREATE INDEX IF NOT EXISTS idx_interactions_user_created ON public.interactions(user_id, created_at DESC);