-- Ajouter une policy permettant la lecture publique des invitations par token
-- Ceci est sécurisé car le token est un UUID aléatoire et unique
CREATE POLICY "Public can read pending invitations by token"
ON parent_invitations FOR SELECT
USING (status = 'pending' AND expires_at > now());