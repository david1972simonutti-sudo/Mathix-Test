import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.75.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface ValidateInvitationRequest {
  token: string;
}

const handler = async (req: Request): Promise<Response> => {
  // Handle CORS preflight requests
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { token }: ValidateInvitationRequest = await req.json();

    if (!token) {
      return new Response(
        JSON.stringify({ error: "Token manquant" }),
        { status: 400, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    // Initialize Supabase client with service role to bypass RLS
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    console.log("Validating parent invitation token:", token);

    // Fetch invitation using service role (bypasses RLS)
    const { data: invitation, error: invitationError } = await supabaseAdmin
      .from("parent_invitations")
      .select("id, parent_email, status, expires_at, eleve_user_id")
      .eq("token", token)
      .eq("status", "pending")
      .maybeSingle();

    if (invitationError) {
      console.error("Error fetching invitation:", invitationError);
      return new Response(
        JSON.stringify({ error: "Erreur lors de la vérification de l'invitation" }),
        { status: 500, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    if (!invitation) {
      console.log("No invitation found for token:", token);
      return new Response(
        JSON.stringify({ error: "Invitation introuvable ou déjà utilisée" }),
        { status: 404, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    // Fetch student profile separately
    const { data: studentProfile, error: profileError } = await supabaseAdmin
      .from("profiles")
      .select("prenom, nom")
      .eq("user_id", invitation.eleve_user_id)
      .maybeSingle();

    if (profileError) {
      console.error("Error fetching student profile:", profileError);
      return new Response(
        JSON.stringify({ error: "Erreur lors de la récupération du profil de l'élève" }),
        { status: 500, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    if (!studentProfile) {
      console.error("Student profile not found for user_id:", invitation.eleve_user_id);
      return new Response(
        JSON.stringify({ error: "Profil de l'élève introuvable" }),
        { status: 404, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    // Check if invitation has expired
    const expiresAt = new Date(invitation.expires_at);
    const now = new Date();

    if (expiresAt < now) {
      console.log("Invitation expired at:", expiresAt);
      return new Response(
        JSON.stringify({ error: "Ce lien d'invitation a expiré" }),
        { status: 410, headers: { "Content-Type": "application/json", ...corsHeaders } }
      );
    }

    console.log("Invitation validated successfully for:", invitation.parent_email);

    // Return the validated invitation data with student profile
    return new Response(
      JSON.stringify({
        success: true,
        invitation: {
          id: invitation.id,
          parent_email: invitation.parent_email,
          eleve_user_id: invitation.eleve_user_id,
          profiles: studentProfile,
        },
      }),
      { status: 200, headers: { "Content-Type": "application/json", ...corsHeaders } }
    );
  } catch (error: any) {
    console.error("Error in validate-parent-invitation function:", error);
    return new Response(
      JSON.stringify({ error: error.message || "Erreur interne du serveur" }),
      { status: 500, headers: { "Content-Type": "application/json", ...corsHeaders } }
    );
  }
};

serve(handler);
