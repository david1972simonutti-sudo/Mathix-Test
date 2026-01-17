-- Enable INSERT policy for authenticated users on chat_history
CREATE POLICY "Users can insert their own chat messages"
ON public.chat_history
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Also allow SELECT for users to read their own messages
CREATE POLICY "Users can view their own chat messages"
ON public.chat_history
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);