-- Supprimer l'ancienne politique SELECT restrictive
DROP POLICY IF EXISTS "Users can view their own images" ON storage.objects;

-- Créer une nouvelle politique SELECT publique (nécessaire pour Gemini)
CREATE POLICY "Public read access for student responses"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'student-responses');