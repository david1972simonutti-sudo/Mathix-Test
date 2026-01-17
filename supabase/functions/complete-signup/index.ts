import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.75.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Fonction de déchiffrement AES-256-GCM
async function decryptData(encryptedData: string): Promise<any> {
  const ENCRYPTION_KEY = Deno.env.get("ENCRYPTION_KEY");
  if (!ENCRYPTION_KEY) {
    throw new Error("ENCRYPTION_KEY not configured");
  }

  try {
    // Le format est: iv:authTag:encryptedText (en base64)
    const parts = encryptedData.split(":");
    if (parts.length !== 3) {
      throw new Error("Invalid encrypted data format");
    }

    const [ivB64, authTagB64, encryptedB64] = parts;
    
    // Décoder depuis base64
    const iv = Uint8Array.from(atob(ivB64), c => c.charCodeAt(0));
    const authTag = Uint8Array.from(atob(authTagB64), c => c.charCodeAt(0));
    const encrypted = Uint8Array.from(atob(encryptedB64), c => c.charCodeAt(0));
    
    // Importer la clé
    const keyData = new TextEncoder().encode(ENCRYPTION_KEY);
    const key = await crypto.subtle.importKey(
      "raw",
      keyData,
      { name: "AES-GCM" },
      false,
      ["decrypt"]
    );

    // Combiner encrypted + authTag
    const ciphertext = new Uint8Array(encrypted.length + authTag.length);
    ciphertext.set(encrypted);
    ciphertext.set(authTag, encrypted.length);

    // Déchiffrer
    const decrypted = await crypto.subtle.decrypt(
      { name: "AES-GCM", iv },
      key,
      ciphertext
    );

    const decryptedText = new TextDecoder().decode(decrypted);
    return JSON.parse(decryptedText);
  } catch (error) {
    console.error("Decryption error:", error);
    throw new Error("Failed to decrypt data");
  }
}

const handler = async (req: Request): Promise<Response> => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { token, email } = await req.json();

    if (!token || !email) {
      throw new Error("Token et email requis");
    }

    console.log(`📝 Finalisation inscription pour email: ${email}`);

    // Create Supabase admin client
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false,
        },
      }
    );

    // 1. Récupérer les données de pending_signups
    console.log("1️⃣ Récupération des données temporaires...");
    const { data: pendingData, error: pendingError } = await supabaseAdmin
      .from("pending_signups")
      .select("*")
      .eq("token", token)
      .gt("expires_at", new Date().toISOString())
      .maybeSingle();

    if (pendingError || !pendingData) {
      console.error("❌ Token invalide ou expiré:", pendingError);
      throw new Error("Token invalide ou expiré");
    }

    // 2. Déchiffrer les données
    console.log("2️⃣ Déchiffrement des données...");
    const studentData = await decryptData(pendingData.encrypted_data);
    let parentEmails: string[] = [];
    
    if (pendingData.parent_emails_encrypted) {
      parentEmails = await decryptData(pendingData.parent_emails_encrypted);
    }

    console.log("✅ Données déchiffrées");

    // 3. Vérifier que l'email correspond
    if (studentData.email !== email) {
      console.error("❌ Email ne correspond pas");
      throw new Error("Email incorrect");
    }
    console.log("✅ Email vérifié");

    // 4. Confirmer l'email dans auth.users EN PREMIER
    console.log("4️⃣ Confirmation de l'email...");
    const { error: confirmError } = await supabaseAdmin.auth.admin.updateUserById(
      pendingData.user_id,
      { email_confirm: true }
    );

    if (confirmError) {
      console.error("❌ Erreur confirmation email:", confirmError);
      throw new Error("Erreur lors de la confirmation de l'email");
    }
    console.log("✅ Email confirmé dans auth.users");

    // 5. Créer le profil
    console.log("5️⃣ Création du profil...");
    const { error: profileError } = await supabaseAdmin.from("profiles").insert({
      user_id: pendingData.user_id,
      email: studentData.email,
      nom: studentData.nom,
      prenom: studentData.prenom,
      classe: studentData.classe,
      reception_news: pendingData.reception_news,
      paiement_valide: false,
    });

    if (profileError) {
      console.error("❌ Erreur création profil:", profileError);
      throw profileError;
    }
    console.log("✅ Profil créé");

    // 6. Créer le profil étudiant avec compétences transversales à 50%
    console.log("6️⃣ Création du profil étudiant...");
    const defaultTransversales = {
      chercher: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
      modeliser: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
      representer: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
      raisonner: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
      calculer: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
      communiquer: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] }
    };
    const { error: studentProfileError } = await supabaseAdmin
      .from("student_profiles")
      .insert({
        user_id: pendingData.user_id,
        competences: { _transversales: defaultTransversales }
      });

    if (studentProfileError) {
      console.error("❌ Erreur création profil étudiant:", studentProfileError);
      throw studentProfileError;
    }
    console.log("✅ Profil étudiant créé");

    // 7. Attribuer le rôle élève
    console.log("7️⃣ Attribution du rôle élève...");
    const { error: roleError } = await supabaseAdmin.from("user_roles").insert({
      user_id: pendingData.user_id,
      role: "eleve",
    });

    if (roleError) {
      console.error("❌ Erreur attribution rôle:", roleError);
      throw roleError;
    }
    console.log("✅ Rôle élève attribué");

    // 8. Créer et envoyer les invitations parents
    if (parentEmails && parentEmails.length > 0) {
      console.log(`8️⃣ Création de ${parentEmails.length} invitation(s) parent...`);
      
      const invitations = parentEmails.map((parentEmail) => ({
        eleve_user_id: pendingData.user_id,
        parent_email: parentEmail,
      }));

      const { data: invitationsData, error: invitationError } = await supabaseAdmin
        .from("parent_invitations")
        .insert(invitations)
        .select("token, parent_email");

      if (invitationError) {
        console.error("❌ Erreur création invitations:", invitationError);
      } else if (invitationsData && invitationsData.length > 0) {
        console.log(`✅ ${invitationsData.length} invitation(s) créée(s)`);
        
        // Envoyer les emails d'invitation
        console.log("9️⃣ Envoi des emails d'invitation aux parents...");
        for (const invitation of invitationsData) {
          const invitationUrl = `${req.headers.get("origin") || "https://siimply.fr"}/signup/parents?token=${invitation.token}`;
          
          try {
            await supabaseAdmin.functions.invoke("send-email", {
              body: {
                type: "parent_invitation",
                to: invitation.parent_email,
                elevePrenom: studentData.prenom,
                eleveNom: studentData.nom,
                invitationUrl,
              },
              headers: {
                "X-Internal-Secret": Deno.env.get("INTERNAL_API_SECRET") || "",
              },
            });
            console.log(`✅ Email d'invitation envoyé à ${invitation.parent_email}`);
          } catch (emailErr) {
            console.error(`⚠️ Erreur envoi email parent ${invitation.parent_email}:`, emailErr);
          }
        }
      }
    }

    // 🔟 Supprimer l'entrée pending_signups
    console.log("🔟 Nettoyage des données temporaires...");
    const { error: deleteError } = await supabaseAdmin
      .from("pending_signups")
      .delete()
      .eq("id", pendingData.id);

    if (deleteError) {
      console.error("⚠️ Erreur suppression pending_signup:", deleteError);
      // Non bloquant
    } else {
      console.log("✅ Données temporaires supprimées");
    }

    console.log("🎉 Inscription finalisée avec succès!");

    return new Response(
      JSON.stringify({
        success: true,
        userId: pendingData.user_id,
        message: "Inscription finalisée avec succès",
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error: any) {
    console.error("💥 Erreur globale:", error);
    
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || "Une erreur est survenue lors de la finalisation",
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      }
    );
  }
};

serve(handler);
