-- Permettre au service role d'insérer des exercices
CREATE POLICY "Service role can insert exercices"
ON exercices
FOR INSERT
TO service_role
WITH CHECK (true);

-- Permettre au service role d'insérer des interactions
CREATE POLICY "Service role can insert interactions"
ON interactions
FOR INSERT
TO service_role
WITH CHECK (true);