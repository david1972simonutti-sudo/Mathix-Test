-- Table B.O Seconde
CREATE TABLE IF NOT EXISTS public.bo_seconde (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chapitre TEXT NOT NULL,
  sous_notion TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(chapitre, sous_notion)
);

-- Table B.O Première
CREATE TABLE IF NOT EXISTS public.bo_premiere (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chapitre TEXT NOT NULL,
  sous_notion TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(chapitre, sous_notion)
);

-- Table B.O Terminale
CREATE TABLE IF NOT EXISTS public.bo_terminale (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chapitre TEXT NOT NULL,
  sous_notion TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(chapitre, sous_notion)
);

-- RLS avec lecture publique
ALTER TABLE public.bo_seconde ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bo_premiere ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bo_terminale ENABLE ROW LEVEL SECURITY;

-- Politique de lecture publique
CREATE POLICY "Lecture publique bo_seconde" ON public.bo_seconde FOR SELECT USING (true);
CREATE POLICY "Lecture publique bo_premiere" ON public.bo_premiere FOR SELECT USING (true);
CREATE POLICY "Lecture publique bo_terminale" ON public.bo_terminale FOR SELECT USING (true);