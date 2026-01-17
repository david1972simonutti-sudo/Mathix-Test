-- Sécuriser le bucket student-responses : restreindre l'accès en lecture aux propriétaires uniquement
-- Actuellement le bucket est PUBLIC, ce qui expose tous les fichiers des élèves

-- Supprimer les politiques existantes sur storage.objects pour ce bucket
DROP POLICY IF EXISTS "Public read access for student responses" ON storage.objects;
DROP POLICY IF EXISTS "Users can read their own images" ON storage.objects;
DROP POLICY IF EXISTS "Users can upload their own images" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own images" ON storage.objects;

-- Nouvelle politique : Les utilisateurs peuvent lire uniquement leurs propres fichiers
CREATE POLICY "Users can read their own files"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'student-responses'
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Politique pour l'upload : Les utilisateurs peuvent uploader dans leur propre dossier
CREATE POLICY "Users can upload their own files"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'student-responses'
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Politique pour la suppression : Les utilisateurs peuvent supprimer leurs propres fichiers
CREATE POLICY "Users can delete their own files"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'student-responses'
  AND auth.uid()::text = (storage.foldername(name))[1]
);