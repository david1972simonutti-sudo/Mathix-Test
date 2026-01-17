-- Add exercise_context column to chats table for persistent exercise context
ALTER TABLE chats 
ADD COLUMN exercise_context JSONB DEFAULT '{}'::jsonb;

-- Add comment explaining the structure
COMMENT ON COLUMN chats.exercise_context IS 'Stores {enonce_exercice, resolution_eleve, corrections_remarques, derniere_maj} for OCR context persistence within chat';