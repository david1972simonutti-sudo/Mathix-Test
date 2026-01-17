-- Create enum for groupe test
CREATE TYPE public.groupe_test AS ENUM ('gemini', 'o4mini');

-- Create users profiles table
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE,
  email TEXT NOT NULL,
  nom TEXT NOT NULL,
  prenom TEXT NOT NULL,
  classe TEXT NOT NULL,
  groupe_test groupe_test NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create student profiles table
CREATE TABLE public.student_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL UNIQUE,
  competences JSONB DEFAULT '{}'::jsonb,
  lacunes_identifiees JSONB DEFAULT '[]'::jsonb,
  style_apprentissage TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create interactions table
CREATE TABLE public.interactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  session_id UUID,
  chapitre TEXT,
  exercice_enonce TEXT,
  reponse_eleve TEXT,
  correction TEXT,
  analyse_erreur JSONB,
  modele_utilise TEXT,
  tokens_utilises INTEGER,
  duree_interaction INTEGER,
  satisfaction_eleve INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Create sessions table
CREATE TABLE public.sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  date_debut TIMESTAMP WITH TIME ZONE DEFAULT now(),
  date_fin TIMESTAMP WITH TIME ZONE,
  duree_totale INTEGER,
  nb_exercices INTEGER DEFAULT 0,
  progression JSONB DEFAULT '{}'::jsonb
);

-- Create exercices table
CREATE TABLE public.exercices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chapitre TEXT NOT NULL,
  niveau TEXT NOT NULL,
  enonce TEXT NOT NULL,
  solution TEXT NOT NULL,
  indices JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercices ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
CREATE POLICY "Users can view their own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update their own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can insert their own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid()::text = user_id::text);

-- RLS Policies for student_profiles
CREATE POLICY "Users can view their own student profile"
  ON public.student_profiles FOR SELECT
  USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update their own student profile"
  ON public.student_profiles FOR UPDATE
  USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can insert their own student profile"
  ON public.student_profiles FOR INSERT
  WITH CHECK (auth.uid()::text = user_id::text);

-- RLS Policies for interactions
CREATE POLICY "Users can view their own interactions"
  ON public.interactions FOR SELECT
  USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can insert their own interactions"
  ON public.interactions FOR INSERT
  WITH CHECK (auth.uid()::text = user_id::text);

-- RLS Policies for sessions
CREATE POLICY "Users can view their own sessions"
  ON public.sessions FOR SELECT
  USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can insert their own sessions"
  ON public.sessions FOR INSERT
  WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update their own sessions"
  ON public.sessions FOR UPDATE
  USING (auth.uid()::text = user_id::text);

-- RLS Policies for exercices (everyone can read)
CREATE POLICY "Everyone can view exercices"
  ON public.exercices FOR SELECT
  TO authenticated
  USING (true);

-- Create function to update updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for student_profiles
CREATE TRIGGER update_student_profiles_updated_at
  BEFORE UPDATE ON public.student_profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();