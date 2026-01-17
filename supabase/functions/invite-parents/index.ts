import "https://deno.land/x/xhr@0.1.0/mod.ts";
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.75.0";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    // 1. Vérifier l'authentification
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      throw new Error('Non authentifié');
    }

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: authHeader } } }
    );

    const { data: { user }, error: authError } = await supabaseClient.auth.getUser();
    
    if (authError || !user) {
      throw new Error('Utilisateur non authentifié');
    }

    // 2. Parse la requête
    const { parentEmails } = await req.json();
    
    if (!parentEmails || !Array.isArray(parentEmails) || parentEmails.length === 0) {
      throw new Error('Aucun email parent fourni');
    }

    if (parentEmails.length > 2) {
      throw new Error('Maximum 2 parents autorisés');
    }

    // 3. Récupérer le profil de l'élève
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    const { data: profile, error: profileError } = await supabaseAdmin
      .from('profiles')
      .select('prenom, nom')
      .eq('user_id', user.id)
      .single();

    if (profileError || !profile) {
      throw new Error('Profil élève non trouvé');
    }

    // 4. Vérifier que l'élève n'a pas déjà 2 parents
    const { data: existingParents, error: parentsError } = await supabaseAdmin
      .from('parent_eleve_relations')
      .select('id')
      .eq('eleve_user_id', user.id);

    if (parentsError) {
      throw new Error('Erreur lors de la vérification des parents existants');
    }

    const currentParentsCount = existingParents?.length || 0;
    const totalParentsAfter = currentParentsCount + parentEmails.length;

    if (totalParentsAfter > 2) {
      throw new Error(`Tu as déjà ${currentParentsCount} parent(s). Tu peux inviter ${2 - currentParentsCount} parent(s) maximum.`);
    }

    // 5. Créer les invitations (logique réutilisée de complete-signup)
    const invitations = parentEmails.map((parentEmail: string) => ({
      eleve_user_id: user.id,
      parent_email: parentEmail,
    }));

    const { data: invitationsData, error: invitationError } = await supabaseAdmin
      .from("parent_invitations")
      .insert(invitations)
      .select("token, parent_email");

    if (invitationError) {
      console.error("❌ Erreur création invitations:", invitationError);
      throw new Error('Erreur lors de la création des invitations');
    }

    if (!invitationsData || invitationsData.length === 0) {
      throw new Error('Aucune invitation créée');
    }

    console.log(`✅ ${invitationsData.length} invitation(s) créée(s)`);

    // 6. Envoyer les emails d'invitation (logique réutilisée de complete-signup)
    console.log("📧 Envoi des emails d'invitation aux parents...");
    const sentEmails: string[] = [];
    const failedEmails: string[] = [];

    for (const invitation of invitationsData) {
      const invitationUrl = `${req.headers.get("origin") || "https://siimply.fr"}/signup/parents?token=${invitation.token}`;
      
      try {
        await supabaseAdmin.functions.invoke("send-email", {
          body: {
            type: "parent_invitation",
            to: invitation.parent_email,
            elevePrenom: profile.prenom,
            eleveNom: profile.nom,
            invitationUrl,
          },
          headers: {
            "X-Internal-Secret": Deno.env.get("INTERNAL_API_SECRET") || "",
          },
        });
        console.log(`✅ Email d'invitation envoyé à ${invitation.parent_email}`);
        sentEmails.push(invitation.parent_email);
      } catch (emailErr) {
        console.error(`⚠️ Erreur envoi email parent ${invitation.parent_email}:`, emailErr);
        failedEmails.push(invitation.parent_email);
      }
    }

    return new Response(
      JSON.stringify({ 
        success: true,
        message: `${sentEmails.length} invitation(s) envoyée(s) avec succès`,
        sentEmails,
        failedEmails: failedEmails.length > 0 ? failedEmails : undefined
      }),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );

  } catch (error: any) {
    console.error('❌ Erreur dans invite-parents:', error);
    return new Response(
      JSON.stringify({ 
        error: error.message || 'Erreur lors de l\'envoi des invitations'
      }),
      {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  }
});
