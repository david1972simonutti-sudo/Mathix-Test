import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { email } = await req.json();
    console.log("📧 Demande de réinitialisation pour:", email);

    if (!email) {
      return new Response(
        JSON.stringify({ success: false, error: "Email requis" }),
        { status: 400, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    // Créer le client Supabase avec service role
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Rechercher l'utilisateur via la table profiles (plus fiable que listUsers)
    const { data: profile, error: profileError } = await supabaseAdmin
      .from('profiles')
      .select('user_id, prenom')
      .ilike('email', email)
      .maybeSingle();

    if (profileError) {
      console.error("Erreur recherche profile:", profileError);
      throw profileError;
    }

    if (!profile) {
      console.log("❌ Email non trouvé dans profiles (message générique retourné):", email);
      // SÉCURITÉ: Retourner succès même si l'email n'existe pas
      // pour empêcher l'énumération des comptes utilisateurs
      return new Response(
        JSON.stringify({ success: true }),
        { status: 200, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    const userId = profile.user_id;
    const prenom = profile.prenom || "Utilisateur";
    
    console.log("✅ Utilisateur trouvé via profiles:", userId);

    // Supprimer les anciens tokens non utilisés pour cet utilisateur
    await supabaseAdmin
      .from('password_reset_tokens')
      .delete()
      .eq('user_id', userId)
      .is('used_at', null);

    // Créer un nouveau token
    const { data: tokenData, error: tokenError } = await supabaseAdmin
      .from('password_reset_tokens')
      .insert({
        user_id: userId,
        email: email.toLowerCase()
      })
      .select('token')
      .single();

    if (tokenError) {
      console.error("Erreur création token:", tokenError);
      throw tokenError;
    }

    console.log("✅ Token créé:", tokenData.token);

    // Construire l'URL de réinitialisation
    const origin = req.headers.get('origin') || 'https://siimply.fr';
    const resetUrl = `${origin}/reset-password?token=${tokenData.token}`;

    console.log("🔗 URL de réinitialisation:", resetUrl);

    // Envoyer l'email via send-email
    const emailResponse = await fetch(`${Deno.env.get("SUPABASE_URL")}/functions/v1/send-email`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${Deno.env.get("SUPABASE_ANON_KEY")}`,
        "X-Internal-Secret": Deno.env.get("INTERNAL_API_SECRET") || "",
      },
      body: JSON.stringify({
        type: 'password_reset',
        to: email,
        prenom: prenom,
        resetUrl: resetUrl
      }),
    });

    if (!emailResponse.ok) {
      const errorText = await emailResponse.text();
      console.error("❌ Erreur envoi email:", errorText);
      throw new Error("Erreur lors de l'envoi de l'email");
    }

    console.log("✅ Email de réinitialisation envoyé à:", email);

    return new Response(
      JSON.stringify({ success: true }),
      { status: 200, headers: { "Content-Type": "application/json", ...corsHeaders } }
    );

  } catch (error: any) {
    console.error("❌ Erreur request-password-reset:", error);
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500, headers: { "Content-Type": "application/json", ...corsHeaders } }
    );
  }
});
