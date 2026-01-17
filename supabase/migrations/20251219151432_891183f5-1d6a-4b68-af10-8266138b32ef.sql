-- Supprimer la politique permissive sur exercices
DROP POLICY IF EXISTS "Users can insert exercices" ON public.exercices;

-- Sécuriser la fonction update_updated_at_column avec search_path
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $function$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$function$;