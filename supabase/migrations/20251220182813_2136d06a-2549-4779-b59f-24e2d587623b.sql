-- Add column to track if user has seen welcome popup
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS has_seen_welcome_popup boolean DEFAULT false;