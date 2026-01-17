import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.75.0";
import { z } from "https://deno.land/x/zod@v3.22.4/mod.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Schéma de validation Zod
const signupParentSchema = z.object({
  invitationToken: z.string().uuid("Token d'invitation invalide"),
  prenom: z.string().min(1, "Prénom requis").max(100).trim(),
  nom: z.string().min(1, "Nom requis").max(100).trim(),
  password: z.string().min(8, "Mot de passe trop court (min 8 caractères)").max(128),
});

// Fonction de chiffrement AES-256-GCM
async function encryptData(data: any): Promise<string> {
  const ENCRYPTION_KEY = Deno.env.get("ENCRYPTION_KEY");
  if (!ENCRYPTION_KEY) {
    throw new Error("ENCRYPTION_KEY not configured");
  }

  try {
    const iv = crypto.getRandomValues(new Uint8Array(12));
    const keyData = new TextEncoder().encode(ENCRYPTION_KEY);
    const key = await crypto.subtle.importKey(
      "raw",
      keyData,
      { name: "AES-GCM" },
      false,
      ["encrypt"]
    );

    const encodedData = new TextEncoder().encode(JSON.stringify(data));
    const encrypted = await crypto.subtle.encrypt(
      { name: "AES-GCM", iv },
      key,
      encodedData
    );

    const encryptedArray = new Uint8Array(encrypted);
    const ciphertext = encryptedArray.slice(0, -16);
    const authTag = encryptedArray.slice(-16);

    const ivB64 = btoa(String.fromCharCode(...iv));
    const authTagB64 = btoa(String.fromCharCode(...authTag));
    const encryptedB64 = btoa(String.fromCharCode(...ciphertext));

    return `${ivB64}:${authTagB64}:${encryptedB64}`;
  } catch (error) {
    console.error("Encryption error:", error);
    throw new Error("Failed to encrypt data");
  }
}

const handler = async (req: Request): Promise<Response> => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    // Valider les données d'entrée avec Zod
    const rawBody = await req.json();
    const parseResult = signupParentSchema.safeParse(rawBody);

    if (!parseResult.success) {
      console.error("❌ Validation échouée:", parseResult.error.flatten());
      return new Response(
        JSON.stringify({
          success: false,
          error: "Données invalides",
          details: parseResult.error.flatten().fieldErrors,
        }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const { invitationToken, prenom, nom, password } = parseResult.data;

    console.log(`📝 Début inscription parent avec token: ${invitationToken}`);

    // Create Supabase clients
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

    // 1. Vérifier l'invitation (avec admin client pour contourner RLS)
    console.log("1️⃣ Vérification de l'invitation...");
    const { data: invitation, error: invitationError } = await supabaseAdmin
      .from("parent_invitations")
      .select("*")
      .eq("token", invitationToken)
      .eq("status", "pending")
      .gt("expires_at", new Date().toISOString())
      .maybeSingle();

    if (invitationError || !invitation) {
      console.error("❌ Invitation invalide:", invitationError);
      throw new Error("Ce lien d'invitation n'est pas valide ou a expiré");
    }
    console.log("✅ Invitation valide");

    // 2. Vérifier si l'email existe déjà
    console.log("2️⃣ Vérification si l'email existe déjà...");
    const { data: existingUsers, error: listError } = await supabaseAdmin.auth.admin.listUsers();
    
    if (listError) {
      console.error("❌ Erreur lors de la vérification des utilisateurs:", listError);
      throw new Error("Erreur lors de la vérification du compte");
    }

    const existingUser = existingUsers?.users?.find(
      (u) => u.email?.toLowerCase() === invitation.parent_email.toLowerCase()
    );

    if (existingUser) {
      console.log("⚠️ Email déjà utilisé:", invitation.parent_email);
      
      // Vérifier si c'est un compte élève ou parent
      const { data: userRole } = await supabaseAdmin
        .from("user_roles")
        .select("role")
        .eq("user_id", existingUser.id)
        .single();

      if (userRole?.role === "eleve") {
        throw new Error("Cet email est déjà utilisé pour un compte élève. Veuillez utiliser une autre adresse email pour créer votre compte parent.");
      } else if (userRole?.role === "parent") {
        throw new Error("Un compte parent existe déjà avec cet email. Veuillez vous connecter directement.");
      } else {
        throw new Error("Un compte existe déjà avec cet email. Veuillez utiliser une autre adresse email.");
      }
    }

    // 3. Créer l'utilisateur avec email CONFIRMÉ (empêche l'envoi d'email natif Supabase)
    // Note: L'email a déjà été validé via l'invitation + notre propre confirmation custom
    console.log("3️⃣ Création de l'utilisateur parent...");
    const { data: userData, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email: invitation.parent_email,
      password,
      email_confirm: true, // IMPORTANT: évite l'envoi automatique d'email natif Supabase
    });

    if (authError) {
      console.error("❌ Erreur création utilisateur:", authError);
      throw authError;
    }

    if (!userData.user) {
      throw new Error("User creation failed");
    }

    const userId = userData.user.id;
    console.log(`✅ Utilisateur parent créé (non confirmé): ${userId}`);

    // 4. Chiffrer les données du parent
    console.log("4️⃣ Chiffrement des données...");
    const parentData = {
      user_type: "parent",
      email: invitation.parent_email,
      prenom,
      nom,
      eleve_user_id: invitation.eleve_user_id,
      invitation_id: invitation.id,
    };
    const encryptedParentData = await encryptData(parentData);
    console.log("✅ Données parent chiffrées");

    // 5. Stocker dans pending_signups
    console.log("5️⃣ Stockage temporaire des données...");
    const { data: pendingData, error: pendingError } = await supabaseAdmin
      .from("pending_signups")
      .insert({
        user_id: userId,
        encrypted_data: encryptedParentData,
        parent_emails_encrypted: null,
        reception_news: false,
      })
      .select("token")
      .single();

    if (pendingError) {
      console.error("❌ Erreur stockage temporaire:", pendingError);
      // Rollback
      await supabaseAdmin.auth.admin.deleteUser(userId);
      throw pendingError;
    }
    console.log("✅ Données stockées temporairement");

    // 6. Envoyer l'email de confirmation
    console.log("6️⃣ Envoi de l'email de confirmation...");
    const confirmationUrl = `${req.headers.get("origin") || "https://siimply.fr"}/confirm-login?token=${pendingData.token}&type=parent`;

    try {
      await supabaseAdmin.functions.invoke("send-email", {
        body: {
          type: "confirmation",
          to: invitation.parent_email,
          prenom,
          confirmationUrl,
        },
        headers: {
          "X-Internal-Secret": Deno.env.get("INTERNAL_API_SECRET") || "",
        },
      });
      console.log("✅ Email de confirmation envoyé");
    } catch (emailError) {
      console.error("⚠️ Erreur envoi email:", emailError);
      // Non bloquant
    }

    console.log("🎉 Inscription parent initiée avec succès!");

    return new Response(
      JSON.stringify({
        success: true,
        message: "Vérifiez votre email pour confirmer votre inscription. Le lien est valide pendant 15 minutes.",
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
        error: error.message || "Une erreur est survenue lors de la création du compte",
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      }
    );
  }
};

serve(handler);
