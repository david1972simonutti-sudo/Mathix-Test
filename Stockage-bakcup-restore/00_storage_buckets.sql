-- ============================================
-- BUCKET: student-responses
-- Type: PRIVÉ (URLs signées requises)
-- Usage: Stockage des photos/fichiers des élèves
-- Date export: 2026-01-16
-- ============================================

-- 1. Création du bucket (privé)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'student-responses', 
  'student-responses', 
  false,
  5242880,
  ARRAY['image/png', 'image/jpeg', 'image/gif', 'image/webp', 'application/pdf']::text[]
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

-- 2. Policy INSERT
CREATE POLICY "Users can upload their own files" 
ON storage.objects 
FOR INSERT 
TO authenticated
WITH CHECK (
  bucket_id = 'student-responses' 
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- 3. Policy SELECT
CREATE POLICY "Users can read their own files" 
ON storage.objects 
FOR SELECT 
TO authenticated
USING (
  bucket_id = 'student-responses' 
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- 4. Policy DELETE
CREATE POLICY "Users can delete their own files" 
ON storage.objects 
FOR DELETE 
TO authenticated
USING (
  bucket_id = 'student-responses' 
  AND auth.uid()::text = (storage.foldername(name))[1]
);
