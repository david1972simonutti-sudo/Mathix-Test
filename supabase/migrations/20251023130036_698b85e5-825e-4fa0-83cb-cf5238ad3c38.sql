-- Add exercice_id to chat_history to link messages to specific exercises
ALTER TABLE chat_history 
ADD COLUMN exercice_id uuid REFERENCES exercices(id);

-- Create index for better query performance
CREATE INDEX idx_chat_history_exercice_id ON chat_history(exercice_id);

-- Add current_exercice_id to sessions to track the active exercise
ALTER TABLE sessions 
ADD COLUMN current_exercice_id uuid REFERENCES exercices(id);