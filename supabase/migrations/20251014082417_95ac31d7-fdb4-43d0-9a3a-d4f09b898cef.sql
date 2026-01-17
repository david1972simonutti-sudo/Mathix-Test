-- Create storage bucket for student responses
INSERT INTO storage.buckets (id, name, public)
VALUES ('student-responses', 'student-responses', true);

-- Policy: Users can upload their own images
CREATE POLICY "Users can upload their own images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'student-responses' 
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Policy: Users can view their own images
CREATE POLICY "Users can view their own images"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'student-responses'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Policy: Users can delete their own images
CREATE POLICY "Users can delete their own images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'student-responses'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Add image_url column to interactions table
ALTER TABLE interactions
ADD COLUMN image_url text;