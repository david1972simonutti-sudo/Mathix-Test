import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY");
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-internal-secret",
};

// Validation du secret interne pour les appels entre Edge Functions
const INTERNAL_API_SECRET = Deno.env.get("INTERNAL_API_SECRET");

function validateInternalSecret(req: Request): boolean {
  const providedSecret = req.headers.get("X-Internal-Secret");
  if (!INTERNAL_API_SECRET) {
    console.error("⚠️ INTERNAL_API_SECRET not configured");
    return false;
  }
  return providedSecret === INTERNAL_API_SECRET;
}

// Rate limiting: stockage en mémoire (reset au redéploiement)
const rateLimitMap = new Map<string, { count: number; resetAt: number }>();

// Configuration rate limiting
const RATE_LIMIT_WINDOW_MS = 60 * 1000; // 1 minute
const RATE_LIMIT_MAX_REQUESTS = 5; // max 5 emails par minute par IP/email

function checkRateLimit(identifier: string): { allowed: boolean; retryAfterMs?: number } {
  const now = Date.now();
  const entry = rateLimitMap.get(identifier);
  
  if (!entry || now > entry.resetAt) {
    // Première requête ou fenêtre expirée
    rateLimitMap.set(identifier, { count: 1, resetAt: now + RATE_LIMIT_WINDOW_MS });
    return { allowed: true };
  }
  
  if (entry.count >= RATE_LIMIT_MAX_REQUESTS) {
    // Limite atteinte
    return { allowed: false, retryAfterMs: entry.resetAt - now };
  }
  
  // Incrémenter le compteur
  entry.count++;
  return { allowed: true };
}

// Nettoyage périodique des entrées expirées (toutes les 5 minutes)
setInterval(() => {
  const now = Date.now();
  for (const [key, entry] of rateLimitMap.entries()) {
    if (now > entry.resetAt) {
      rateLimitMap.delete(key);
    }
  }
}, 5 * 60 * 1000);

interface ConfirmationEmailRequest {
  type: 'confirmation';
  to: string;
  prenom: string;
  confirmationUrl: string;
}

interface ContactEmailRequest {
  type: 'contact';
  nom: string;
  email: string;
  sujet: string;
  message: string;
}

interface SupportEmailRequest {
  type: 'support';
  nom: string;
  email: string;
  typeProblem: string;
  description: string;
  imageUrl?: string;
}

interface ParentInvitationEmailRequest {
  type: 'parent_invitation';
  to: string;
  elevePrenom: string;
  eleveNom: string;
  invitationUrl: string;
}

interface PasswordResetEmailRequest {
  type: 'password_reset';
  to: string;
  prenom: string;
  resetUrl: string;
}

interface PasswordResetConfirmationEmailRequest {
  type: 'password_reset_confirmation';
  to: string;
  prenom: string;
}

interface ContactWithConfirmationEmailRequest {
  type: 'contact_with_confirmation';
  objet: string;
  email: string;
  message: string;
}

interface CSATFeedbackEmailRequest {
  type: 'csat_feedback';
  userPrenom: string;
  userNom: string;
  userEmail: string;
  userClasse: string;
  csatScore: number;
  difficulty?: string;
  comment?: string;
}

interface ChatMessageFeedbackEmailRequest {
  type: 'chat_message_feedback';
  userPrenom: string;
  userEmail: string;
  userClasse: string;
  rating: 'positive' | 'negative';
  comment?: string;
  messageContent: string;
  conversationId: string;
}

type EmailRequest = ConfirmationEmailRequest | ContactEmailRequest | SupportEmailRequest | ParentInvitationEmailRequest | PasswordResetEmailRequest | PasswordResetConfirmationEmailRequest | ContactWithConfirmationEmailRequest | CSATFeedbackEmailRequest | ChatMessageFeedbackEmailRequest;

// Fonction pour envoyer un email via l'API Resend
async function sendEmail(params: {
  from: string;
  to: string[];
  subject: string;
  html: string;
  replyTo?: string;
}) {
  const response = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${RESEND_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(params),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Resend API error: ${response.status} - ${error}`);
  }

  return await response.json();
}

// Template HTML pour email de confirmation
const getConfirmationEmailHtml = (prenom: string, confirmationUrl: string) => `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Confirmez votre inscription</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Ubuntu, sans-serif; background-color: #ffffff;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td align="center" style="padding: 20px 0 48px;">
        <table width="600" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px;">
          <tr>
            <td style="padding: 20px;">
              <h1 style="color: #1a1a1a; font-size: 28px; font-weight: 700; margin: 40px 0; line-height: 1.3;">
                Bienvenue sur Siimply, ${prenom} !
              </h1>
              
              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Merci de vous être inscrit sur Siimply, votre assistant personnel en mathématiques.
              </p>

              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Pour activer votre compte, veuillez confirmer votre adresse email en cliquant sur le bouton ci-dessous :
              </p>

              <table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 32px 0;">
                <tr>
                  <td align="center">
                    <a href="${confirmationUrl}" target="_blank" style="background-color: #5046e5; border-radius: 8px; color: #fff; font-size: 16px; font-weight: 600; text-decoration: none; padding: 14px 32px; display: inline-block;">
                      Confirmer mon inscription
                    </a>
                  </td>
                </tr>
              </table>

              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Ou copiez-collez ce lien dans votre navigateur :
              </p>
              
              <p style="color: #5046e5; font-size: 14px; text-decoration: underline; word-break: break-all;">
                ${confirmationUrl}
              </p>

              <p style="color: #666; font-size: 14px; line-height: 24px; margin-top: 32px;">
                Si vous n'avez pas créé de compte sur Siimply, vous pouvez ignorer cet email en toute sécurité.
              </p>

              <p style="color: #898989; font-size: 12px; line-height: 22px; margin-top: 24px; border-top: 1px solid #e6e6e6; padding-top: 24px;">
                <a href="https://siimply.fr" target="_blank" style="color: #898989; text-decoration: none;">Siimply</a> - Votre assistant personnel en mathématiques
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
`;

// Template HTML pour email de contact
const getContactEmailHtml = (nom: string, email: string, sujet: string, message: string) => `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Nouveau message de contact</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Ubuntu, sans-serif; background-color: #f6f6f6;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #f6f6f6;">
    <tr>
      <td align="center" style="padding: 24px 0 64px;">
        <table width="600" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; background-color: #ffffff; border-radius: 8px; border: 1px solid #e6e6e6;">
          <tr>
            <td style="padding: 20px 32px 48px;">
              <h1 style="color: #1a1a1a; font-size: 24px; font-weight: 700; margin: 32px 0 24px;">
                📩 Nouveau message de contact
              </h1>
              
              <table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 24px 0;">
                <tr>
                  <td>
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">De :</p>
                    <p style="color: #1a1a1a; font-size: 16px; margin: 4px 0 0; font-weight: 500;">${nom}</p>
                    
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">Email :</p>
                    <p style="color: #1a1a1a; font-size: 16px; margin: 4px 0 0; font-weight: 500;">${email}</p>
                    
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">Sujet :</p>
                    <p style="color: #1a1a1a; font-size: 16px; margin: 4px 0 0; font-weight: 500;">${sujet}</p>
                  </td>
                </tr>
              </table>

              <hr style="border: none; border-top: 1px solid #e6e6e6; margin: 24px 0;">

              <div style="margin: 24px 0; background-color: #f9f9f9; padding: 20px; border-radius: 6px; border: 1px solid #e6e6e6;">
                <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 0 0 8px;">Message :</p>
                <p style="color: #333; font-size: 15px; line-height: 24px; margin: 8px 0 0; white-space: pre-wrap;">${message}</p>
              </div>

              <hr style="border: none; border-top: 1px solid #e6e6e6; margin: 24px 0;">

              <p style="color: #898989; font-size: 12px; line-height: 22px; margin-top: 24px; text-align: center;">
                Message reçu via le formulaire de contact de Siimply
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
`;

// Template HTML pour email de support
const getSupportEmailHtml = (nom: string, email: string, typeProblem: string, description: string, imageUrl?: string) => `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Demande de support</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Ubuntu, sans-serif; background-color: #f6f6f6;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #f6f6f6;">
    <tr>
      <td align="center" style="padding: 24px 0 64px;">
        <table width="600" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; background-color: #ffffff; border-radius: 8px; border: 1px solid #e6e6e6;">
          <tr>
            <td style="padding: 20px 32px 48px;">
              <h1 style="color: #1a1a1a; font-size: 24px; font-weight: 700; margin: 32px 0 24px;">
                🛟 Nouvelle demande de support
              </h1>
              
              <div style="background-color: #fff3cd; border: 1px solid #ffc107; border-radius: 6px; padding: 16px; margin: 24px 0;">
                <p style="color: #856404; font-size: 15px; margin: 0; font-weight: 500;">
                  Type de problème : <strong>${typeProblem}</strong>
                </p>
              </div>

              <table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 24px 0;">
                <tr>
                  <td>
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">Utilisateur :</p>
                    <p style="color: #1a1a1a; font-size: 16px; margin: 4px 0 0; font-weight: 500;">${nom}</p>
                    
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">Email :</p>
                    <p style="color: #1a1a1a; font-size: 16px; margin: 4px 0 0; font-weight: 500;">${email}</p>
                  </td>
                </tr>
              </table>

              <hr style="border: none; border-top: 1px solid #e6e6e6; margin: 24px 0;">

              <div style="margin: 24px 0; background-color: #f9f9f9; padding: 20px; border-radius: 6px; border: 1px solid #e6e6e6;">
                <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 0 0 8px;">Description du problème :</p>
                <p style="color: #333; font-size: 15px; line-height: 24px; margin: 8px 0 0; white-space: pre-wrap;">${description}</p>
              </div>

              ${imageUrl ? `
                <hr style="border: none; border-top: 1px solid #e6e6e6; margin: 24px 0;">
                <div style="margin: 24px 0;">
                  <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 12px;">Capture d'écran jointe :</p>
                  <img src="${imageUrl}" alt="Capture d'écran du problème" style="max-width: 100%; height: auto; border-radius: 6px; border: 1px solid #e6e6e6; margin-top: 12px;">
                </div>
              ` : ''}

              <hr style="border: none; border-top: 1px solid #e6e6e6; margin: 24px 0;">

              <div style="background-color: #e3f2fd; border: 1px solid #2196f3; border-radius: 6px; padding: 16px; margin: 24px 0;">
                <p style="color: #0d47a1; font-size: 15px; margin: 0; line-height: 24px;">
                  💡 <strong>Action requise :</strong> Répondre à ${email} pour résoudre ce problème.
                </p>
              </div>

              <p style="color: #898989; font-size: 12px; line-height: 22px; margin-top: 24px; text-align: center;">
                Demande reçue via le formulaire de support de Siimply
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
`;

const getParentInvitationEmailHtml = (elevePrenom: string, eleveNom: string, invitationUrl: string) => `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Invitation Parent - Siimply</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Ubuntu, sans-serif; background-color: #ffffff;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td align="center" style="padding: 20px 0 48px;">
        <table width="600" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px;">
          <!-- Header avec gradient -->
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 20px; text-align: center; border-radius: 8px 8px 0 0;">
              <h1 style="color: #ffffff; margin: 0; font-size: 28px; font-weight: 700;">Siimply</h1>
              <p style="color: #ffffff; margin: 8px 0 0; font-size: 14px; opacity: 0.9;">L'accompagnement évolutif des maths</p>
            </td>
          </tr>

          <!-- Content -->
          <tr>
            <td style="padding: 40px 30px; background-color: #ffffff; border: 1px solid #e6e6e6; border-top: none;">
              <h2 style="color: #1a1a1a; font-size: 24px; font-weight: 700; margin: 0 0 20px;">
                ${elevePrenom} ${eleveNom} vous invite sur Siimply
              </h2>
              
              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Bonjour,
              </p>
              
              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Votre enfant <strong>${elevePrenom} ${eleveNom}</strong> vient de créer un compte sur Siimply, 
                la plateforme d'accompagnement personnalisé en mathématiques.
              </p>

              <div style="background-color: #f9f9f9; border-left: 4px solid #667eea; padding: 20px; margin: 24px 0; border-radius: 4px;">
                <p style="color: #333; font-size: 15px; line-height: 24px; margin: 0 0 12px; font-weight: 600;">
                  En créant votre compte parent, vous pourrez :
                </p>
                <ul style="color: #666; font-size: 15px; line-height: 28px; margin: 0; padding-left: 20px;">
                  <li>Suivre les progrès de votre enfant</li>
                  <li>Gérer les paramètres de paiement</li>
                  <li>Accéder aux statistiques d'apprentissage</li>
                  <li>Être notifié des réussites et difficultés</li>
                </ul>
              </div>

              <!-- CTA Button -->
              <table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 32px 0;">
                <tr>
                  <td align="center">
                    <a href="${invitationUrl}" 
                       target="_blank"
                       style="display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
                              color: #ffffff; text-decoration: none; padding: 16px 40px; 
                              border-radius: 8px; font-weight: 600; font-size: 16px;">
                      Créer mon compte parent
                    </a>
                  </td>
                </tr>
              </table>

              <div style="background-color: #fff3cd; border: 1px solid #ffc107; border-radius: 6px; padding: 16px; margin: 24px 0;">
                <p style="color: #856404; font-size: 14px; margin: 0; line-height: 22px;">
                  <strong>⏰ Important :</strong> Ce lien est valable pendant 7 jours.
                </p>
              </div>

              <p style="color: #999; font-size: 14px; line-height: 24px; margin: 20px 0 0;">
                Si vous n'êtes pas concerné par cette invitation, vous pouvez ignorer cet email en toute sécurité.
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 24px 30px; background-color: #f9f9f9; text-align: center; border: 1px solid #e6e6e6; border-top: none; border-radius: 0 0 8px 8px;">
              <p style="color: #898989; font-size: 12px; line-height: 22px; margin: 0;">
                © 2025 <a href="https://siimply.fr" target="_blank" style="color: #898989; text-decoration: none;">Siimply</a> - L'accompagnement évolutif des maths
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
`;

// Template HTML pour email de réinitialisation de mot de passe
const getPasswordResetEmailHtml = (prenom: string, resetUrl: string) => `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Réinitialisation de votre mot de passe</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Ubuntu, sans-serif; background-color: #ffffff;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td align="center" style="padding: 20px 0 48px;">
        <table width="600" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px;">
          <!-- Header avec gradient -->
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 20px; text-align: center; border-radius: 8px 8px 0 0;">
              <h1 style="color: #ffffff; margin: 0; font-size: 28px; font-weight: 700;">Siimply</h1>
              <p style="color: #ffffff; margin: 8px 0 0; font-size: 14px; opacity: 0.9;">L'accompagnement évolutif des maths</p>
            </td>
          </tr>

          <!-- Content -->
          <tr>
            <td style="padding: 40px 30px; background-color: #ffffff; border: 1px solid #e6e6e6; border-top: none;">
              <h2 style="color: #1a1a1a; font-size: 24px; font-weight: 700; margin: 0 0 20px;">
                Réinitialisation de votre mot de passe
              </h2>
              
              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Bonjour ${prenom},
              </p>
              
              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Vous avez demandé à réinitialiser votre mot de passe sur Siimply. Cliquez sur le bouton ci-dessous pour définir un nouveau mot de passe :
              </p>

              <!-- CTA Button -->
              <table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 32px 0;">
                <tr>
                  <td align="center">
                    <a href="${resetUrl}" 
                       target="_blank"
                       style="display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
                              color: #ffffff; text-decoration: none; padding: 16px 40px; 
                              border-radius: 8px; font-weight: 600; font-size: 16px;">
                      Réinitialiser mon mot de passe
                    </a>
                  </td>
                </tr>
              </table>

              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Ou copiez-collez ce lien dans votre navigateur :
              </p>
              
              <p style="color: #5046e5; font-size: 14px; text-decoration: underline; word-break: break-all;">
                ${resetUrl}
              </p>

              <div style="background-color: #fff3cd; border: 1px solid #ffc107; border-radius: 6px; padding: 16px; margin: 24px 0;">
                <p style="color: #856404; font-size: 14px; margin: 0; line-height: 22px;">
                  <strong>⏰ Important :</strong> Ce lien est valable pendant 15 minutes.
                </p>
              </div>

              <p style="color: #999; font-size: 14px; line-height: 24px; margin: 20px 0 0;">
                Si vous n'avez pas demandé cette réinitialisation, vous pouvez ignorer cet email en toute sécurité. Votre mot de passe ne sera pas modifié.
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 24px 30px; background-color: #f9f9f9; text-align: center; border: 1px solid #e6e6e6; border-top: none; border-radius: 0 0 8px 8px;">
              <p style="color: #898989; font-size: 12px; line-height: 22px; margin: 0;">
                © 2025 <a href="https://siimply.fr" target="_blank" style="color: #898989; text-decoration: none;">Siimply</a> - L'accompagnement évolutif des maths
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
`;

// Template HTML pour confirmation de réinitialisation de mot de passe
const getPasswordResetConfirmationEmailHtml = (prenom: string) => `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mot de passe réinitialisé</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Ubuntu, sans-serif; background-color: #ffffff;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td align="center" style="padding: 20px 0 48px;">
        <table width="600" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px;">
          <!-- Header avec gradient -->
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 20px; text-align: center; border-radius: 8px 8px 0 0;">
              <h1 style="color: #ffffff; margin: 0; font-size: 28px; font-weight: 700;">Siimply</h1>
              <p style="color: #ffffff; margin: 8px 0 0; font-size: 14px; opacity: 0.9;">L'accompagnement évolutif des maths</p>
            </td>
          </tr>

          <!-- Content -->
          <tr>
            <td style="padding: 40px 30px; background-color: #ffffff; border: 1px solid #e6e6e6; border-top: none;">
              <div style="text-align: center; margin-bottom: 24px;">
                <div style="width: 64px; height: 64px; background-color: #d4edda; border-radius: 50%; display: inline-block; line-height: 64px;">
                  <span style="font-size: 32px;">✓</span>
                </div>
              </div>

              <h2 style="color: #1a1a1a; font-size: 24px; font-weight: 700; margin: 0 0 20px; text-align: center;">
                Mot de passe réinitialisé avec succès
              </h2>
              
              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Bonjour ${prenom},
              </p>
              
              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Votre mot de passe Siimply a été modifié avec succès. Vous pouvez maintenant vous connecter avec votre nouveau mot de passe.
              </p>

              <!-- Alerte de sécurité -->
              <div style="background-color: #f8d7da; border: 1px solid #f5c6cb; border-radius: 6px; padding: 20px; margin: 24px 0;">
                <p style="color: #721c24; font-size: 15px; margin: 0 0 12px; font-weight: 600;">
                  ⚠️ Ce n'était pas vous ?
                </p>
                <p style="color: #721c24; font-size: 14px; line-height: 22px; margin: 0 0 16px;">
                  Si vous n'êtes pas à l'origine de cette modification, votre compte pourrait être compromis. Veuillez nous contacter immédiatement :
                </p>
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                  <tr>
                    <td align="center">
                      <a href="mailto:contact@siimply.fr?subject=Alerte%20sécurité%20-%20Mot%20de%20passe%20modifié%20sans%20autorisation" 
                         target="_blank"
                         style="display: inline-block; background-color: #dc3545; 
                                color: #ffffff; text-decoration: none; padding: 12px 24px; 
                                border-radius: 6px; font-weight: 600; font-size: 14px;">
                        Signaler un problème de sécurité
                      </a>
                    </td>
                  </tr>
                </table>
              </div>

              <p style="color: #999; font-size: 14px; line-height: 24px; margin: 20px 0 0;">
                Si vous êtes bien à l'origine de cette modification, vous pouvez ignorer cet avertissement.
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 24px 30px; background-color: #f9f9f9; text-align: center; border: 1px solid #e6e6e6; border-top: none; border-radius: 0 0 8px 8px;">
              <p style="color: #898989; font-size: 12px; line-height: 22px; margin: 0;">
                © 2025 <a href="https://siimply.fr" target="_blank" style="color: #898989; text-decoration: none;">Siimply</a> - L'accompagnement évolutif des maths
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
`;

// Template HTML pour confirmation de contact à l'utilisateur
const getContactConfirmationEmailHtml = (objet: string, message: string) => `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Message envoyé - Siimply</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Ubuntu, sans-serif; background-color: #ffffff;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td align="center" style="padding: 20px 0 48px;">
        <table width="600" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px;">
          <!-- Header avec gradient -->
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 20px; text-align: center; border-radius: 8px 8px 0 0;">
              <h1 style="color: #ffffff; margin: 0; font-size: 28px; font-weight: 700;">Siimply</h1>
              <p style="color: #ffffff; margin: 8px 0 0; font-size: 14px; opacity: 0.9;">L'accompagnement évolutif des maths</p>
            </td>
          </tr>

          <!-- Content -->
          <tr>
            <td style="padding: 40px 30px; background-color: #ffffff; border: 1px solid #e6e6e6; border-top: none;">
              <h2 style="color: #1a1a1a; font-size: 24px; font-weight: 700; margin: 0 0 20px;">
                Message envoyé ! ✅
              </h2>
              
              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Merci, nous avons bien reçu votre message.
              </p>
              
              <p style="color: #333; font-size: 16px; line-height: 26px; margin: 16px 0;">
                Notre équipe vous répondra dans les <strong>48 heures</strong>.
              </p>

              <div style="background-color: #f9f9f9; border-left: 4px solid #667eea; padding: 20px; margin: 24px 0; border-radius: 4px;">
                <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 0 0 8px;">Objet : ${objet}</p>
                <p style="color: #333; font-size: 15px; line-height: 24px; margin: 8px 0 0; white-space: pre-wrap;">${message}</p>
              </div>

              <p style="color: #999; font-size: 14px; line-height: 24px; margin: 20px 0 0;">
                À bientôt sur Siimply !
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 24px 30px; background-color: #f9f9f9; text-align: center; border: 1px solid #e6e6e6; border-top: none; border-radius: 0 0 8px 8px;">
              <p style="color: #898989; font-size: 12px; line-height: 22px; margin: 0;">
                © 2025 <a href="https://siimply.fr" target="_blank" style="color: #898989; text-decoration: none;">Siimply</a> - L'accompagnement évolutif des maths
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
`;

// Template HTML simplifié pour contact interne (avec objet)
const getContactInternalEmailHtml = (objet: string, email: string, message: string) => `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Nouveau message de contact</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Ubuntu, sans-serif; background-color: #f6f6f6;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #f6f6f6;">
    <tr>
      <td align="center" style="padding: 24px 0 64px;">
        <table width="600" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; background-color: #ffffff; border-radius: 8px; border: 1px solid #e6e6e6;">
          <tr>
            <td style="padding: 20px 32px 48px;">
              <h1 style="color: #1a1a1a; font-size: 24px; font-weight: 700; margin: 32px 0 24px;">
                📩 Nouveau message de contact
              </h1>
              
              <table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 24px 0;">
                <tr>
                  <td>
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">Objet :</p>
                    <p style="color: #1a1a1a; font-size: 16px; margin: 4px 0 0; font-weight: 500;">${objet}</p>
                    
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">Email :</p>
                    <p style="color: #1a1a1a; font-size: 16px; margin: 4px 0 0; font-weight: 500;">${email}</p>
                  </td>
                </tr>
              </table>

              <hr style="border: none; border-top: 1px solid #e6e6e6; margin: 24px 0;">

              <div style="margin: 24px 0; background-color: #f9f9f9; padding: 20px; border-radius: 6px; border: 1px solid #e6e6e6;">
                <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 0 0 8px;">Message :</p>
                <p style="color: #333; font-size: 15px; line-height: 24px; margin: 8px 0 0; white-space: pre-wrap;">${message}</p>
              </div>

              <div style="background-color: #e3f2fd; border: 1px solid #2196f3; border-radius: 6px; padding: 16px; margin: 24px 0;">
                <p style="color: #0d47a1; font-size: 15px; margin: 0; line-height: 24px;">
                  💡 <strong>Action requise :</strong> Répondre à ${email}
                </p>
              </div>

              <p style="color: #898989; font-size: 12px; line-height: 22px; margin-top: 24px; text-align: center;">
                Message reçu via le formulaire de contact de Siimply
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
`;

// Template HTML pour email CSAT feedback
const getCSATFeedbackEmailHtml = (
  prenom: string,
  nom: string,
  email: string,
  classe: string,
  csatScore: number,
  difficulty?: string,
  comment?: string
) => {
  const csatEmoji = csatScore >= 5 ? '😊' : csatScore >= 3 ? '😐' : '😞';
  const csatColor = csatScore >= 5 ? '#22c55e' : csatScore >= 3 ? '#f59e0b' : '#ef4444';
  const csatBgColor = csatScore >= 5 ? '#dcfce7' : csatScore >= 3 ? '#fef3c7' : '#fee2e2';
  const csatText = csatScore >= 5 ? 'Heureux' : csatScore >= 3 ? 'Moyen' : 'Déçu';
  
  const difficultyText = difficulty === 'facile' ? '😌 Facile' : difficulty === 'moyen' ? '🤔 Moyen' : difficulty === 'dur' ? '😓 Dur' : 'Non renseigné';

  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Retour CSAT - ${prenom} ${nom}</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Ubuntu, sans-serif; background-color: #f6f6f6;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #f6f6f6;">
    <tr>
      <td align="center" style="padding: 24px 0 64px;">
        <table width="600" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; background-color: #ffffff; border-radius: 8px; border: 1px solid #e6e6e6;">
          <!-- Header -->
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px 20px; text-align: center; border-radius: 8px 8px 0 0;">
              <h1 style="color: #ffffff; margin: 0; font-size: 24px; font-weight: 700;">📊 Nouveau retour CSAT</h1>
            </td>
          </tr>

          <tr>
            <td style="padding: 30px 32px 40px;">
              <!-- Score CSAT -->
              <div style="background-color: ${csatBgColor}; border: 2px solid ${csatColor}; border-radius: 12px; padding: 24px; margin: 0 0 24px; text-align: center;">
                <p style="color: ${csatColor}; font-size: 48px; margin: 0 0 8px;">${csatEmoji}</p>
                <p style="color: ${csatColor}; font-size: 28px; font-weight: 700; margin: 0;">${csatScore}/5</p>
                <p style="color: ${csatColor}; font-size: 16px; margin: 8px 0 0;">${csatText}</p>
              </div>

              <!-- Info élève -->
              <table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 24px 0;">
                <tr>
                  <td>
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 0 0 4px;">Élève :</p>
                    <p style="color: #1a1a1a; font-size: 18px; margin: 4px 0 0; font-weight: 600;">${prenom} ${nom}</p>
                    
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">Classe :</p>
                    <p style="color: #1a1a1a; font-size: 16px; margin: 4px 0 0; font-weight: 500;">${classe}</p>
                    
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">Email :</p>
                    <p style="color: #1a1a1a; font-size: 16px; margin: 4px 0 0; font-weight: 500;">${email}</p>
                  </td>
                </tr>
              </table>

              <hr style="border: none; border-top: 1px solid #e6e6e6; margin: 24px 0;">

              <!-- Difficulté -->
              <div style="margin: 24px 0;">
                <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 0 0 8px;">Difficulté perçue des exercices :</p>
                <p style="color: #1a1a1a; font-size: 16px; margin: 0; font-weight: 500;">${difficultyText}</p>
              </div>

              ${comment ? `
              <!-- Commentaire -->
              <div style="margin: 24px 0; background-color: #f9f9f9; padding: 20px; border-radius: 6px; border: 1px solid #e6e6e6;">
                <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 0 0 8px;">Commentaire :</p>
                <p style="color: #333; font-size: 15px; line-height: 24px; margin: 8px 0 0; white-space: pre-wrap;">${comment}</p>
              </div>
              ` : ''}

              <hr style="border: none; border-top: 1px solid #e6e6e6; margin: 24px 0;">

              <!-- Action -->
              <div style="background-color: #e3f2fd; border: 1px solid #2196f3; border-radius: 6px; padding: 16px; margin: 24px 0;">
                <p style="color: #0d47a1; font-size: 15px; margin: 0; line-height: 24px;">
                  💡 <strong>Action :</strong> <a href="mailto:${email}" style="color: #2196f3; text-decoration: underline;">Répondre à ${prenom}</a>
                </p>
              </div>

              <p style="color: #898989; font-size: 12px; line-height: 22px; margin-top: 24px; text-align: center;">
                Feedback reçu à la déconnexion sur Siimply
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
`;
};

const handler = async (req: Request): Promise<Response> => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    // Validation du secret interne - OBLIGATOIRE
    if (!validateInternalSecret(req)) {
      console.error("❌ Unauthorized: Invalid or missing internal secret");
      return new Response(
        JSON.stringify({ error: "Unauthorized" }),
        { status: 401, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    const emailRequest: EmailRequest = await req.json();
    console.log(`📧 Traitement d'un email de type: ${emailRequest.type}`);

    // Rate limiting basé sur l'IP ou l'email de destination
    const clientIP = req.headers.get("x-forwarded-for") || req.headers.get("cf-connecting-ip") || "unknown";
    const rateLimitKey = `${clientIP}:${emailRequest.type}`;
    const rateLimitCheck = checkRateLimit(rateLimitKey);
    if (!rateLimitCheck.allowed) {
      console.warn(`⚠️ Rate limit atteint pour: ${rateLimitKey}`);
      return new Response(
        JSON.stringify({ 
          success: false,
          error: "Trop de requêtes. Veuillez réessayer dans quelques secondes.",
          retryAfterMs: rateLimitCheck.retryAfterMs
        }),
        {
          status: 429,
          headers: { 
            "Content-Type": "application/json",
            "Retry-After": String(Math.ceil((rateLimitCheck.retryAfterMs || 60000) / 1000)),
            ...corsHeaders 
          },
        }
      );
    }

    let emailResponse;

    switch (emailRequest.type) {
      case 'confirmation': {
        const html = getConfirmationEmailHtml(emailRequest.prenom, emailRequest.confirmationUrl);

        emailResponse = await sendEmail({
          from: "Siimply <no-reply@siimply.fr>",
          to: [emailRequest.to],
          subject: "Confirmez votre inscription sur Siimply",
          html,
        });
        break;
      }

      case 'contact': {
        const html = getContactEmailHtml(emailRequest.nom, emailRequest.email, emailRequest.sujet, emailRequest.message);

        emailResponse = await sendEmail({
          from: "Contact Siimply <no-reply@siimply.fr>",
          to: ["contact@siimply.fr"],
          replyTo: emailRequest.email,
          subject: `[Contact] ${emailRequest.sujet}`,
          html,
        });
        break;
      }

      case 'support': {
        const html = getSupportEmailHtml(emailRequest.nom, emailRequest.email, emailRequest.typeProblem, emailRequest.description, emailRequest.imageUrl);

        emailResponse = await sendEmail({
          from: "Support Siimply <no-reply@siimply.fr>",
          to: ["support@siimply.fr"],
          replyTo: emailRequest.email,
          subject: `[Support] ${emailRequest.typeProblem} - ${emailRequest.nom}`,
          html,
        });
        break;
      }

      case 'parent_invitation': {
        console.log('Envoi email invitation parent à:', emailRequest.to);
        const html = getParentInvitationEmailHtml(
          emailRequest.elevePrenom,
          emailRequest.eleveNom,
          emailRequest.invitationUrl
        );
        emailResponse = await sendEmail({
          from: "Siimply <no-reply@siimply.fr>",
          to: [emailRequest.to],
          subject: `${emailRequest.elevePrenom} ${emailRequest.eleveNom} vous invite sur Siimply`,
          html,
        });
        break;
      }

      case 'password_reset': {
        console.log('Envoi email réinitialisation mot de passe à:', emailRequest.to);
        const html = getPasswordResetEmailHtml(emailRequest.prenom, emailRequest.resetUrl);
        emailResponse = await sendEmail({
          from: "Siimply <no-reply@siimply.fr>",
          to: [emailRequest.to],
          subject: "Réinitialisation de votre mot de passe Siimply",
          html,
        });
        break;
      }

      case 'password_reset_confirmation': {
        console.log('Envoi email confirmation réinitialisation à:', emailRequest.to);
        const html = getPasswordResetConfirmationEmailHtml(emailRequest.prenom);
        emailResponse = await sendEmail({
          from: "Siimply <no-reply@siimply.fr>",
          to: [emailRequest.to],
          subject: "Votre mot de passe Siimply a été réinitialisé",
          html,
        });
        break;
      }

      case 'contact_with_confirmation': {
        console.log('Envoi contact avec confirmation à:', emailRequest.email);
        
        // Email 1: À contact@siimply.fr
        const internalHtml = getContactInternalEmailHtml(
          emailRequest.objet,
          emailRequest.email,
          emailRequest.message
        );
        await sendEmail({
          from: "Contact Siimply <no-reply@siimply.fr>",
          to: ["raphael@siimply.fr"],
          replyTo: emailRequest.email,
          subject: `[Contact] ${emailRequest.objet}`,
          html: internalHtml,
        });

        // Email 2: Confirmation à l'utilisateur
        const confirmationHtml = getContactConfirmationEmailHtml(
          emailRequest.objet,
          emailRequest.message
        );
        emailResponse = await sendEmail({
          from: "Siimply <no-reply@siimply.fr>",
          to: [emailRequest.email],
          subject: "Demande envoyée à Siimply ✅",
          html: confirmationHtml,
        });
        break;
      }

      case 'csat_feedback': {
        console.log('Envoi CSAT feedback pour:', emailRequest.userPrenom, emailRequest.userNom);
        const csatEmoji = emailRequest.csatScore >= 5 ? '😊' : emailRequest.csatScore >= 3 ? '😐' : '😞';
        
        const html = getCSATFeedbackEmailHtml(
          emailRequest.userPrenom,
          emailRequest.userNom,
          emailRequest.userEmail,
          emailRequest.userClasse,
          emailRequest.csatScore,
          emailRequest.difficulty,
          emailRequest.comment
        );
        
        emailResponse = await sendEmail({
          from: "Siimply Feedback <no-reply@siimply.fr>",
          to: ["support@siimply.fr"],
          replyTo: emailRequest.userEmail,
          subject: `${emailRequest.userPrenom} ${emailRequest.userNom} - Retour CSAT ${emailRequest.csatScore}/5 ${csatEmoji}`,
          html,
        });
        break;
      }

      case 'chat_message_feedback': {
        console.log('Envoi feedback chat pour:', emailRequest.userPrenom);
        const ratingEmoji = emailRequest.rating === 'negative' ? '👎' : '👍';
        const ratingColor = emailRequest.rating === 'negative' ? '#ef4444' : '#22c55e';
        const ratingBgColor = emailRequest.rating === 'negative' ? '#fee2e2' : '#dcfce7';
        const ratingText = emailRequest.rating === 'negative' ? 'Négatif' : 'Positif';
        
        const html = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Feedback Chat - ${emailRequest.userPrenom}</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Ubuntu, sans-serif; background-color: #f6f6f6;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #f6f6f6;">
    <tr>
      <td align="center" style="padding: 24px 0 64px;">
        <table width="600" cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; background-color: #ffffff; border-radius: 8px; border: 1px solid #e6e6e6;">
          <tr>
            <td style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px 20px; text-align: center; border-radius: 8px 8px 0 0;">
              <h1 style="color: #ffffff; margin: 0; font-size: 24px; font-weight: 700;">💬 Feedback Message Chat</h1>
            </td>
          </tr>

          <tr>
            <td style="padding: 30px 32px 40px;">
              <div style="background-color: ${ratingBgColor}; border: 2px solid ${ratingColor}; border-radius: 12px; padding: 24px; margin: 0 0 24px; text-align: center;">
                <p style="color: ${ratingColor}; font-size: 48px; margin: 0 0 8px;">${ratingEmoji}</p>
                <p style="color: ${ratingColor}; font-size: 20px; font-weight: 700; margin: 0;">${ratingText}</p>
              </div>

              <table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin: 24px 0;">
                <tr>
                  <td>
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 0 0 4px;">Élève :</p>
                    <p style="color: #1a1a1a; font-size: 18px; margin: 4px 0 0; font-weight: 600;">${emailRequest.userPrenom}</p>
                    
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">Classe :</p>
                    <p style="color: #1a1a1a; font-size: 16px; margin: 4px 0 0; font-weight: 500;">${emailRequest.userClasse}</p>
                    
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">Email :</p>
                    <p style="color: #1a1a1a; font-size: 16px; margin: 4px 0 0; font-weight: 500;">${emailRequest.userEmail}</p>
                    
                    <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 4px;">Conversation ID :</p>
                    <p style="color: #1a1a1a; font-size: 14px; margin: 4px 0 0; font-weight: 500; font-family: monospace;">${emailRequest.conversationId}</p>
                  </td>
                </tr>
              </table>

              <hr style="border: none; border-top: 1px solid #e6e6e6; margin: 24px 0;">

              ${emailRequest.comment ? `
              <div style="margin: 24px 0; background-color: #fef3c7; padding: 20px; border-radius: 6px; border: 1px solid #f59e0b;">
                <p style="color: #92400e; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 0 0 8px;">💬 Commentaire de l'élève :</p>
                <p style="color: #451a03; font-size: 15px; line-height: 24px; margin: 8px 0 0; white-space: pre-wrap;">${emailRequest.comment}</p>
              </div>
              ` : ''}

              <div style="margin: 24px 0; background-color: #f9f9f9; padding: 20px; border-radius: 6px; border: 1px solid #e6e6e6;">
                <p style="color: #666; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin: 0 0 8px;">🤖 Message de l'IA concerné :</p>
                <p style="color: #333; font-size: 14px; line-height: 22px; margin: 8px 0 0; white-space: pre-wrap; max-height: 200px; overflow: hidden;">${emailRequest.messageContent}</p>
              </div>

              <p style="color: #898989; font-size: 12px; line-height: 22px; margin-top: 24px; text-align: center;">
                Feedback reçu via le chatbot Siimply
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;
        
        emailResponse = await sendEmail({
          from: "Siimply Feedback <no-reply@siimply.fr>",
          to: ["support@siimply.fr"],
          replyTo: emailRequest.userEmail,
          subject: `[Feedback Chat] ${ratingEmoji} - ${emailRequest.userPrenom} (${emailRequest.userClasse})`,
          html,
        });
        break;
      }

      default:
        throw new Error(`Type d'email non supporté: ${(emailRequest as any).type}`);
    }

    console.log("✅ Email envoyé avec succès:", emailResponse.id);

    return new Response(JSON.stringify({ 
      success: true, 
      emailId: emailResponse.id 
    }), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        ...corsHeaders,
      },
    });
  } catch (error: any) {
    console.error("❌ Erreur dans send-email:", error);
    return new Response(
      JSON.stringify({ 
        success: false,
        error: error.message 
      }),
      {
        status: 500,
        headers: { 
          "Content-Type": "application/json", 
          ...corsHeaders 
        },
      }
    );
  }
};

serve(handler);
