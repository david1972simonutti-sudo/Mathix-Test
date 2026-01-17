-- Add chat_type column to chats table to differentiate between "exercice" and "cours"
ALTER TABLE public.chats 
ADD COLUMN chat_type text DEFAULT 'exercice' CHECK (chat_type IN ('exercice', 'cours'));

-- Add index for better query performance
CREATE INDEX idx_chats_chat_type ON public.chats(chat_type);

-- Add chat_type column to interactions table as well
ALTER TABLE public.interactions 
ADD COLUMN chat_type text DEFAULT 'exercice' CHECK (chat_type IN ('exercice', 'cours'));