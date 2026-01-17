import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.75.0";
import { z } from "https://deno.land/x/zod@v3.22.4/mod.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// Schéma de validation Zod
const signupStudentSchema = z.object({
  email: z.string().email("Email invalide").max(255).toLowerCase().trim(),
  password: z.string().min(8, "Mot de passe trop court (min 8 caractères)").max(128),
  nom: z.string().min(1, "Nom requis").max(100).trim(),
  prenom: z.string().min(1, "Prénom requis").max(100).trim(),
  classe: z.string().min(1, "Classe requise").max(50).trim(),
  receptionNews: z.boolean().default(false),
  parentEmails: z.array(z.string().email("Email parent invalide")).max(2).default([]),
});

// Fonction de chiffrement AES-256-GCM
async function encryptData(data: any): Promise<string> {
  const ENCRYPTION_KEY = Deno.env.get("ENCRYPTION_KEY");
  if (!ENCRYPTION_KEY) {
    throw new Error("ENCRYPTION_KEY not configured");
  }

  try {
    // Générer un IV aléatoire (12 bytes pour GCM)
    const iv = crypto.getRandomValues(new Uint8Array(12));
    
    // Convertir la clé en format utilisable
    const keyData = new TextEncoder().encode(ENCRYPTION_KEY);
    const key = await crypto.subtle.importKey(
      "raw",
      keyData,
      { name: "AES-GCM" },
      false,
      ["encrypt"]
    );

    // Chiffrer les données
    const encodedData = new TextEncoder().encode(JSON.stringify(data));
    const encrypted = await crypto.subtle.encrypt(
      { name: "AES-GCM", iv },
      key,
      encodedData
    );

    // Extraire le authTag (derniers 16 bytes)
    const encryptedArray = new Uint8Array(encrypted);
    const ciphertext = encryptedArray.slice(0, -16);
    const authTag = encryptedArray.slice(-16);

    // Encoder en base64 pour stockage
    const ivB64 = btoa(String.fromCharCode(...iv));
    const authTagB64 = btoa(String.fromCharCode(...authTag));
    const encryptedB64 = btoa(String.fromCharCode(...ciphertext));

    // Format: iv:authTag:encryptedText
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
    const parseResult = signupStudentSchema.safeParse(rawBody);

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

    const { email, password, nom, prenom, classe, receptionNews, parentEmails } = parseResult.data;

    console.log(`📝 Début inscription pour: ${email}`);

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

    // 1. Créer l'utilisateur avec email CONFIRMÉ (empêche l'envoi d'email natif Supabase)
    // Note: Notre propre système de confirmation custom gère la validation
    console.log("1️⃣ Création de l'utilisateur...");
    const { data: userData, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true, // IMPORTANT: évite l'envoi automatique d'email natif Supabase
    });

    if (authError) {
      console.error("❌ Erreur création utilisateur:", authError);
      
      // Vérifier si l'email existe déjà
      if (authError.message?.includes("already been registered")) {
        throw new Error("Un compte existe déjà avec cet email. Veuillez vous connecter.");
      }
      throw authError;
    }

    if (!userData.user) {
      throw new Error("User creation failed - no user returned");
    }

    const userId = userData.user.id;
    console.log(`✅ Utilisateur créé (non confirmé): ${userId}`);

    // 2. Chiffrer les données de l'élève
    console.log("2️⃣ Chiffrement des données...");
    const studentData = {
      email,
      nom,
      prenom,
      classe,
    };
    const encryptedStudentData = await encryptData(studentData);
    console.log("✅ Données élève chiffrées");

    // 3. Chiffrer les emails des parents si présents
    let encryptedParentEmails: string | null = null;
    if (parentEmails && parentEmails.length > 0) {
      encryptedParentEmails = await encryptData(parentEmails);
      console.log("✅ Emails parents chiffrés");
    }

    // 4. Stocker dans pending_signups
    console.log("3️⃣ Stockage temporaire des données...");
    const { data: pendingData, error: pendingError } = await supabaseAdmin
      .from("pending_signups")
      .insert({
        user_id: userId,
        encrypted_data: encryptedStudentData,
        parent_emails_encrypted: encryptedParentEmails,
        reception_news: receptionNews,
      })
      .select("token")
      .single();

    if (pendingError) {
      console.error("❌ Erreur stockage temporaire:", pendingError);
      // Rollback: supprimer l'utilisateur créé
      await supabaseAdmin.auth.admin.deleteUser(userId);
      throw pendingError;
    }
    console.log("✅ Données stockées temporairement");

    // 5. Envoyer l'email de confirmation avec lien vers /confirm-login
    console.log("4️⃣ Envoi de l'email de confirmation...");
    const confirmationUrl = `${req.headers.get("origin") || "https://siimply.fr"}/confirm-login?token=${pendingData.token}`;

    try {
      await supabaseAdmin.functions.invoke("send-email", {
        body: {
          type: "confirmation",
          to: email,
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
      // Non bloquant - l'utilisateur peut redemander un email
    }

    console.log("🎉 Inscription initiée avec succès (en attente de confirmation)!");

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
