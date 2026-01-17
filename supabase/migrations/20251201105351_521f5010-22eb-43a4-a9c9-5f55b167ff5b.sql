-- Corriger le search_path pour check_max_parents
CREATE OR REPLACE FUNCTION check_max_parents()
RETURNS TRIGGER 
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    IF (SELECT COUNT(*) FROM parent_eleve_relations WHERE eleve_user_id = NEW.eleve_user_id) >= 2 THEN
        RAISE EXCEPTION 'Un élève ne peut avoir que 2 parents maximum';
    END IF;
    RETURN NEW;
END;
$$;

-- Corriger le search_path pour update_updated_at_column
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;