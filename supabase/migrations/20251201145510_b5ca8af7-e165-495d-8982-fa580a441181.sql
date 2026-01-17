ALTER TABLE public.email_confirmations 
  ADD CONSTRAINT email_confirmations_user_id_fkey 
  FOREIGN KEY (user_id) 
  REFERENCES auth.users(id) 
  ON DELETE CASCADE;

ALTER TABLE public.email_confirmations ENABLE ROW LEVEL SECURITY;