-- Add exercice_id to interactions table
ALTER TABLE interactions 
ADD COLUMN exercice_id UUID REFERENCES exercices(id);

-- Make exercice_enonce nullable
ALTER TABLE interactions 
ALTER COLUMN exercice_enonce DROP NOT NULL;

-- Add index for performance
CREATE INDEX idx_interactions_user_exercice ON interactions(user_id, exercice_id);

-- Add index for searching by chapter
CREATE INDEX idx_interactions_user_chapitre ON interactions(user_id, chapitre);