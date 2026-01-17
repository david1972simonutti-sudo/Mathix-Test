-- Ajouter le champ titre dans la table chats pour stocker un titre descriptif
-- basé sur le chapitre identifié par Gemini
ALTER TABLE chats ADD COLUMN titre text;