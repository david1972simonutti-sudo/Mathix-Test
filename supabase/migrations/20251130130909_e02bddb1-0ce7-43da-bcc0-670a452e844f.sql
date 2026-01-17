-- Création de la table interventions_pedagogiques
CREATE TABLE IF NOT EXISTS interventions_pedagogiques (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  interaction_id UUID REFERENCES interactions(id) ON DELETE CASCADE,
  
  -- Contexte
  notion_actuelle TEXT NOT NULL,
  chapitre_actuel TEXT NOT NULL,
  niveau TEXT NOT NULL,
  
  -- Pré-requis détecté
  prerequis_manquant TEXT NOT NULL,
  niveau_prerequis TEXT,
  gravite INT CHECK (gravite BETWEEN 1 AND 5),
  type_erreur TEXT,
  
  -- Message et action
  message_affiche TEXT,
  explication TEXT,
  recommandation_action TEXT,
  
  -- Statut et suivi
  statut TEXT DEFAULT 'proposee' CHECK (statut IN ('proposee', 'acceptee', 'refusee', 'ignoree')),
  mode_aide_renforcee BOOLEAN DEFAULT false,
  nb_nouvelles_erreurs_apres_refus INT DEFAULT 0,
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index pour les requêtes fréquentes
CREATE INDEX idx_interventions_user_statut ON interventions_pedagogiques(user_id, statut, created_at DESC);
CREATE INDEX idx_interventions_prerequis ON interventions_pedagogiques(prerequis_manquant, statut);

-- RLS policies
ALTER TABLE interventions_pedagogiques ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own interventions" 
ON interventions_pedagogiques 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own interventions" 
ON interventions_pedagogiques 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own interventions" 
ON interventions_pedagogiques 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Service role can insert interventions" 
ON interventions_pedagogiques 
FOR INSERT 
WITH CHECK (true);