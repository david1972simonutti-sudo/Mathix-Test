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
    const parts = encryptedData.split(":");
    if (parts.length !== 3) {
      throw new Error("Invalid encrypted data format");
    }

    const [ivB64, authTagB64, encryptedB64] = parts;
    
    const iv = Uint8Array.from(atob(ivB64), c => c.charCodeAt(0));
    const authTag = Uint8Array.from(atob(authTagB64), c => c.charCodeAt(0));
    const encrypted = Uint8Array.from(atob(encryptedB64), c => c.charCodeAt(0));
    
    const keyData = new TextEncoder().encode(ENCRYPTION_KEY);
    const key = await crypto.subtle.importKey(
      "raw",
      keyData,
      { name: "AES-GCM" },
      false,
      ["decrypt"]
    );

    const ciphertext = new Uint8Array(encrypted.length + authTag.length);
    ciphertext.set(encrypted);
    ciphertext.set(authTag, encrypted.length);

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

    console.log(`📝 Finalisation inscription parent pour email: ${email}`);

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
    const parentData = await decryptData(pendingData.encrypted_data);

    if (parentData.user_type !== "parent") {
      throw new Error("Type d'utilisateur invalide");
    }

    console.log("✅ Données déchiffrées");

    // 3. Vérifier que l'email correspond
    if (parentData.email !== email) {
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
    console.log("5️⃣ Création du profil parent...");
    const { error: profileError } = await supabaseAdmin.from("profiles").insert({
      user_id: pendingData.user_id,
      email: parentData.email,
      nom: parentData.nom,
      prenom: parentData.prenom,
      classe: "parent",
      reception_news: false,
      paiement_valide: false,
    });

    if (profileError) {
      console.error("❌ Erreur création profil:", profileError);
      throw profileError;
    }
    console.log("✅ Profil parent créé");

    // 6. Attribuer le rôle parent
    console.log("6️⃣ Attribution du rôle parent...");
    const { error: roleError } = await supabaseAdmin.from("user_roles").insert({
      user_id: pendingData.user_id,
      role: "parent",
    });

    if (roleError) {
      console.error("❌ Erreur attribution rôle:", roleError);
      throw roleError;
    }
    console.log("✅ Rôle parent attribué");

    // 7. Créer la relation parent-élève
    console.log("7️⃣ Création de la relation parent-élève...");
    const { error: relationError } = await supabaseAdmin
      .from("parent_eleve_relations")
      .insert({
        parent_user_id: pendingData.user_id,
        eleve_user_id: parentData.eleve_user_id,
      });

    if (relationError) {
      console.error("❌ Erreur création relation:", relationError);
      
      if (relationError.message?.includes("maximum")) {
        throw new Error("Cet élève a déjà atteint le maximum de 2 parents");
      }
      throw relationError;
    }
    console.log("✅ Relation parent-élève créée");

    // 8. Mettre à jour l'invitation à "accepted"
    console.log("8️⃣ Mise à jour de l'invitation...");
    const { error: updateError } = await supabaseAdmin
      .from("parent_invitations")
      .update({ status: "accepted" })
      .eq("id", parentData.invitation_id);

    if (updateError) {
      console.error("⚠️ Erreur mise à jour invitation:", updateError);
      // Non bloquant
    } else {
      console.log("✅ Invitation marquée comme acceptée");
    }

    // 9. Supprimer l'entrée pending_signups
    console.log("9️⃣ Nettoyage des données temporaires...");
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

    console.log("🎉 Inscription parent finalisée avec succès!");

    return new Response(
      JSON.stringify({
        success: true,
        userId: pendingData.user_id,
        message: "Inscription parent finalisée avec succès",
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
