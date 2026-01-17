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
    const { token, newPassword } = await req.json();
    console.log("🔐 Tentative de réinitialisation avec token:", token?.substring(0, 8) + "...");

    if (!token || !newPassword) {
      return new Response(
        JSON.stringify({ success: false, error: "Token et nouveau mot de passe requis" }),
        { status: 400, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    if (newPassword.length < 8) {
      return new Response(
        JSON.stringify({ success: false, error: "Le mot de passe doit contenir au moins 8 caractères" }),
        { status: 400, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    // Créer le client Supabase avec service role
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Vérifier le token
    const { data: tokenData, error: tokenError } = await supabaseAdmin
      .from('password_reset_tokens')
      .select('*')
      .eq('token', token)
      .is('used_at', null)
      .gt('expires_at', new Date().toISOString())
      .single();

    if (tokenError || !tokenData) {
      console.log("❌ Token invalide ou expiré");
      return new Response(
        JSON.stringify({ success: false, error: "Lien invalide ou expiré. Veuillez demander un nouveau lien de réinitialisation." }),
        { status: 400, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    console.log("✅ Token valide pour user:", tokenData.user_id);

    // Mettre à jour le mot de passe via l'API Admin
    const { error: updateError } = await supabaseAdmin.auth.admin.updateUserById(
      tokenData.user_id,
      { password: newPassword }
    );

    if (updateError) {
      console.error("❌ Erreur mise à jour mot de passe:", updateError);
      throw updateError;
    }

    console.log("✅ Mot de passe mis à jour pour:", tokenData.user_id);

    // Marquer le token comme utilisé
    await supabaseAdmin
      .from('password_reset_tokens')
      .update({ used_at: new Date().toISOString() })
      .eq('token', token);

    // Récupérer le prénom pour l'email de confirmation
    const { data: profile } = await supabaseAdmin
      .from('profiles')
      .select('prenom')
      .eq('user_id', tokenData.user_id)
      .single();

    const prenom = profile?.prenom || "Utilisateur";

    // Envoyer l'email de confirmation
    const emailResponse = await fetch(`${Deno.env.get("SUPABASE_URL")}/functions/v1/send-email`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${Deno.env.get("SUPABASE_ANON_KEY")}`,
        "X-Internal-Secret": Deno.env.get("INTERNAL_API_SECRET") || "",
      },
      body: JSON.stringify({
        type: 'password_reset_confirmation',
        to: tokenData.email,
        prenom: prenom
      }),
    });

    if (!emailResponse.ok) {
      console.error("⚠️ Email de confirmation non envoyé (non bloquant)");
    } else {
      console.log("✅ Email de confirmation envoyé");
    }

    return new Response(
      JSON.stringify({ success: true }),
      { status: 200, headers: { "Content-Type": "application/json", ...corsHeaders } }
    );

  } catch (error: any) {
    console.error("❌ Erreur reset-password:", error);
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      { status: 500, headers: { "Content-Type": "application/json", ...corsHeaders } }
    );
  }
});
