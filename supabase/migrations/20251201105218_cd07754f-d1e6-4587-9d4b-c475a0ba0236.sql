-- Étape 1 : Créer l'enum pour les rôles
CREATE TYPE public.app_role AS ENUM ('eleve', 'parent', 'administrateur');

-- Étape 2 : Créer la table user_roles (sécurité)
CREATE TABLE public.user_roles (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    role app_role NOT NULL,
    created_at timestamptz DEFAULT now(),
    UNIQUE (user_id, role)
);

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

-- Étape 3 : Créer la fonction has_role (security definer)
CREATE OR REPLACE FUNCTION public.has_role(_user_id uuid, _role app_role)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = _role
  )
$$;

-- Étape 4 : Créer la table parent_eleve_relations avec trigger
CREATE TABLE public.parent_eleve_relations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    eleve_user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    created_at timestamptz DEFAULT now(),
    UNIQUE (parent_user_id, eleve_user_id)
);

ALTER TABLE public.parent_eleve_relations ENABLE ROW LEVEL SECURITY;

-- Trigger pour limiter à 2 parents maximum par élève
CREATE OR REPLACE FUNCTION check_max_parents()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM parent_eleve_relations WHERE eleve_user_id = NEW.eleve_user_id) >= 2 THEN
        RAISE EXCEPTION 'Un élève ne peut avoir que 2 parents maximum';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_max_parents
BEFORE INSERT ON parent_eleve_relations
FOR EACH ROW EXECUTE FUNCTION check_max_parents();

-- Étape 5 : Créer la table parent_invitations
CREATE TABLE public.parent_invitations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    eleve_user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    parent_email text NOT NULL,
    token uuid DEFAULT gen_random_uuid() NOT NULL UNIQUE,
    status text DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'expired')),
    created_at timestamptz DEFAULT now(),
    expires_at timestamptz DEFAULT (now() + interval '7 days')
);

ALTER TABLE public.parent_invitations ENABLE ROW LEVEL SECURITY;

-- Étape 6 : Modifier la table profiles (ajouter 4 nouveaux champs)
ALTER TABLE public.profiles
ADD COLUMN paiement_valide boolean DEFAULT false,
ADD COLUMN date_paiement timestamptz,
ADD COLUMN premiere_utilisation_chat timestamptz,
ADD COLUMN reception_news boolean DEFAULT false;

-- Étape 7 : Migrer les données existantes (créer rôle eleve pour les utilisateurs valides uniquement)
INSERT INTO public.user_roles (user_id, role)
SELECT p.user_id, 'eleve'::app_role 
FROM public.profiles p
WHERE EXISTS (SELECT 1 FROM auth.users WHERE id = p.user_id)
ON CONFLICT (user_id, role) DO NOTHING;

-- Étape 8 : Créer les RLS policies

-- Policies pour user_roles
CREATE POLICY "Users can view their own roles"
ON public.user_roles
FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own role during signup"
ON public.user_roles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can view all roles"
ON public.user_roles
FOR SELECT
TO authenticated
USING (public.has_role(auth.uid(), 'administrateur'));

CREATE POLICY "Admins can manage all roles"
ON public.user_roles
FOR ALL
TO authenticated
USING (public.has_role(auth.uid(), 'administrateur'))
WITH CHECK (public.has_role(auth.uid(), 'administrateur'));

-- Policies pour parent_eleve_relations
CREATE POLICY "Users can view their own relations"
ON public.parent_eleve_relations
FOR SELECT
TO authenticated
USING (
  auth.uid() = parent_user_id OR 
  auth.uid() = eleve_user_id OR
  public.has_role(auth.uid(), 'administrateur')
);

CREATE POLICY "Eleves can create parent relations"
ON public.parent_eleve_relations
FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = eleve_user_id OR
  public.has_role(auth.uid(), 'administrateur')
);

CREATE POLICY "Admins can manage all relations"
ON public.parent_eleve_relations
FOR ALL
TO authenticated
USING (public.has_role(auth.uid(), 'administrateur'))
WITH CHECK (public.has_role(auth.uid(), 'administrateur'));

-- Policies pour parent_invitations
CREATE POLICY "Eleves can view their own invitations"
ON public.parent_invitations
FOR SELECT
TO authenticated
USING (
  auth.uid() = eleve_user_id OR
  public.has_role(auth.uid(), 'administrateur')
);

CREATE POLICY "Eleves can create invitations"
ON public.parent_invitations
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = eleve_user_id);

CREATE POLICY "Eleves can update their own invitations"
ON public.parent_invitations
FOR UPDATE
TO authenticated
USING (auth.uid() = eleve_user_id);

CREATE POLICY "Admins can manage all invitations"
ON public.parent_invitations
FOR ALL
TO authenticated
USING (public.has_role(auth.uid(), 'administrateur'))
WITH CHECK (public.has_role(auth.uid(), 'administrateur'));

-- Mise à jour des policies profiles pour les nouveaux champs
CREATE POLICY "Users can update their payment info"
ON public.profiles
FOR UPDATE
TO authenticated
USING (auth.uid()::text = user_id::text)
WITH CHECK (auth.uid()::text = user_id::text);