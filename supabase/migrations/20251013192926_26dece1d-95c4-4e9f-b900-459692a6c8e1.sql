-- Add mood tracking columns to sessions table
ALTER TABLE sessions 
ADD COLUMN humeur_du_jour TEXT,
ADD COLUMN humeur_timestamp TIMESTAMP WITH TIME ZONE;