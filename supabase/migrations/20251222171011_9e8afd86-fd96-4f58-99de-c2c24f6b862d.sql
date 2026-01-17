-- Increase parent invitation expiration from 15 minutes to 7 days
ALTER TABLE parent_invitations 
ALTER COLUMN expires_at 
SET DEFAULT (now() + interval '7 days');