-- Rendre le bucket student-responses PRIVÉ pour sécuriser les photos des élèves
UPDATE storage.buckets SET public = false WHERE id = 'student-responses';