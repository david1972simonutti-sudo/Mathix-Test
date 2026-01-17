-- Allow authenticated users to insert exercises created from the app
-- Ensure RLS is enabled (no-op if already enabled)
ALTER TABLE public.exercices ENABLE ROW LEVEL SECURITY;

-- Create a permissive policy for authenticated users to insert exercises
CREATE POLICY "Users can insert exercices"
ON public.exercices
FOR INSERT
TO authenticated
WITH CHECK (true);