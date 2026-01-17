-- Table pour stocker les snapshots quotidiens des compétences
CREATE TABLE public.competences_snapshots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  snapshot_date DATE NOT NULL DEFAULT CURRENT_DATE,
  competences JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Un seul snapshot par user par jour
  UNIQUE(user_id, snapshot_date)
);

-- Index pour les requêtes de comparaison rapides
CREATE INDEX idx_snapshots_user_date ON public.competences_snapshots(user_id, snapshot_date DESC);

-- Activer RLS
ALTER TABLE public.competences_snapshots ENABLE ROW LEVEL SECURITY;

-- Les élèves peuvent voir leurs propres snapshots
CREATE POLICY "Users can view their own snapshots"
  ON public.competences_snapshots 
  FOR SELECT
  USING (auth.uid() = user_id);

-- Les parents peuvent voir les snapshots de leurs enfants
CREATE POLICY "Parents can view children snapshots"
  ON public.competences_snapshots 
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.parent_eleve_relations
      WHERE parent_user_id = auth.uid() 
      AND eleve_user_id = competences_snapshots.user_id
    )
  );

-- Service role peut insérer (pour l'edge function)
CREATE POLICY "Service role can insert snapshots"
  ON public.competences_snapshots
  FOR INSERT
  WITH CHECK (true);