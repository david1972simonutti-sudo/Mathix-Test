-- Create hors_programme_classe table
CREATE TABLE public.hors_programme_classe (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  classe text NOT NULL,
  notion text NOT NULL,
  niveau_cible text NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);

-- Enable RLS with public read
ALTER TABLE public.hors_programme_classe ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read access" ON public.hors_programme_classe
  FOR SELECT USING (true);

-- Create unique constraint to avoid duplicates
CREATE UNIQUE INDEX idx_hors_programme_unique ON public.hors_programme_classe (classe, notion);

-- Insert data for SECONDE (notions de Première)
INSERT INTO public.hors_programme_classe (classe, notion, niveau_cible) VALUES
('Seconde', 'Dérivation', 'Première'),
('Seconde', 'Nombre dérivé', 'Première'),
('Seconde', 'Fonction dérivée', 'Première'),
('Seconde', 'Tangente à une courbe', 'Première'),
('Seconde', 'Fonction exponentielle', 'Première'),
('Seconde', 'Suites numériques', 'Première'),
('Seconde', 'Suite arithmétique', 'Première'),
('Seconde', 'Suite géométrique', 'Première'),
('Seconde', 'Récurrence', 'Première'),
('Seconde', 'Probabilités conditionnelles', 'Première'),
('Seconde', 'Second degré discriminant', 'Première'),
('Seconde', 'Produit scalaire', 'Première'),
('Seconde', 'Trigonométrie cercle trigonométrique', 'Première');

-- Insert data for SECONDE (notions de Terminale)
INSERT INTO public.hors_programme_classe (classe, notion, niveau_cible) VALUES
('Seconde', 'Limites de fonctions', 'Terminale'),
('Seconde', 'Asymptotes', 'Terminale'),
('Seconde', 'Calcul intégral', 'Terminale'),
('Seconde', 'Primitives', 'Terminale'),
('Seconde', 'Équations différentielles', 'Terminale'),
('Seconde', 'Continuité', 'Terminale'),
('Seconde', 'Loi normale', 'Terminale'),
('Seconde', 'Nombres complexes', 'Terminale'),
('Seconde', 'Logarithme népérien', 'Terminale');

-- Insert data for PREMIÈRE (notions de Terminale)
INSERT INTO public.hors_programme_classe (classe, notion, niveau_cible) VALUES
('Première', 'Limites de fonctions', 'Terminale'),
('Première', 'Asymptotes', 'Terminale'),
('Première', 'Croissances comparées', 'Terminale'),
('Première', 'Calcul intégral', 'Terminale'),
('Première', 'Primitives', 'Terminale'),
('Première', 'Équations différentielles', 'Terminale'),
('Première', 'Continuité', 'Terminale'),
('Première', 'Loi normale', 'Terminale'),
('Première', 'Intervalle de confiance', 'Terminale'),
('Première', 'Nombres complexes', 'Terminale'),
('Première', 'Logarithme népérien', 'Terminale'),
('Première', 'Géométrie dans l''espace vecteurs', 'Terminale'),
('Première', 'Plans et droites dans l''espace', 'Terminale');

-- Insert data for TERMINALE (notions de Prépa/Université)
INSERT INTO public.hors_programme_classe (classe, notion, niveau_cible) VALUES
('Terminale', 'Équations différentielles ordre 2', 'Prépa/Université'),
('Terminale', 'Intégrales doubles', 'Prépa/Université'),
('Terminale', 'Intégrales triples', 'Prépa/Université'),
('Terminale', 'Séries numériques', 'Prépa/Université'),
('Terminale', 'Séries entières', 'Prépa/Université'),
('Terminale', 'Espaces vectoriels', 'Prépa/Université'),
('Terminale', 'Calcul matriciel avancé', 'Prépa/Université'),
('Terminale', 'Déterminants', 'Prépa/Université'),
('Terminale', 'Valeurs propres et vecteurs propres', 'Prépa/Université'),
('Terminale', 'Topologie', 'Prépa/Université'),
('Terminale', 'Fonctions de plusieurs variables', 'Prépa/Université'),
('Terminale', 'Dérivées partielles', 'Prépa/Université'),
('Terminale', 'Intégrales généralisées', 'Prépa/Université'),
('Terminale', 'Développements limités', 'Prépa/Université'),
('Terminale', 'Formule de Taylor', 'Prépa/Université');