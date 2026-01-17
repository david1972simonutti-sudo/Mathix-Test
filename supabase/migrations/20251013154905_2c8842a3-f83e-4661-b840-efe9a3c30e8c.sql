-- Supprimer la colonne groupe_test de la table profiles car on utilise un seul modèle
ALTER TABLE public.profiles DROP COLUMN IF EXISTS groupe_test;