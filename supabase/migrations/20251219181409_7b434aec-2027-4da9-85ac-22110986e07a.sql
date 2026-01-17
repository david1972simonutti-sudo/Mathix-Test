-- Révoquer les privilèges INSERT, UPDATE, DELETE du rôle anon sur les tables de référence
-- Ces tables ne doivent être modifiées que par des admins via service_role

REVOKE INSERT, UPDATE, DELETE ON public.bo_seconde FROM anon;
REVOKE INSERT, UPDATE, DELETE ON public.bo_premiere FROM anon;
REVOKE INSERT, UPDATE, DELETE ON public.bo_terminale FROM anon;
REVOKE INSERT, UPDATE, DELETE ON public.exercices FROM anon;