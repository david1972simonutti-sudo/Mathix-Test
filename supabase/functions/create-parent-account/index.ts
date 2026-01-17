import "https://deno.land/x/xhr@0.1.0/mod.ts";
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.75.0";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { token, prenom, nom, password } = await req.json();

    console.log('Creating parent account with token:', token);

    // Validation des champs requis
    if (!token || !prenom || !nom || !password) {
      return new Response(
        JSON.stringify({ error: 'Tous les champs sont requis' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Créer un client Supabase avec le service_role pour contourner RLS
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    );

    // 1. Vérifier que le token existe et est valide (avec admin client pour contourner RLS)
    const { data: invitation, error: invitationError } = await supabaseAdmin
      .from('parent_invitations')
      .select('*, profiles!parent_invitations_eleve_user_id_fkey(prenom, nom)')
      .eq('token', token)
      .eq('status', 'pending')
      .gt('expires_at', new Date().toISOString())
      .maybeSingle();

    if (invitationError) {
      console.error('Error fetching invitation:', invitationError);
      return new Response(
        JSON.stringify({ error: 'Erreur lors de la vérification de l\'invitation' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    if (!invitation) {
      console.error('Invalid or expired token');
      return new Response(
        JSON.stringify({ error: 'Ce lien d\'invitation n\'est pas valide ou a expiré' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    console.log('Valid invitation found for eleve:', invitation.eleve_user_id);

    // 2. Créer le compte Auth Supabase (avec admin client)
    const { data: authData, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email: invitation.parent_email,
      password: password,
      email_confirm: true, // Confirmer l'email automatiquement
    });

    if (authError) {
      console.error('Error creating auth user:', authError);
      if (authError.message.includes('already registered')) {
        return new Response(
          JSON.stringify({ error: 'Un compte existe déjà avec cet email. Veuillez vous connecter.' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }
      return new Response(
        JSON.stringify({ error: 'Erreur lors de la création du compte: ' + authError.message }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const parentUserId = authData.user.id;
    console.log('Auth user created:', parentUserId);

    // 3. Créer le profil parent (avec admin client)
    const { error: profileError } = await supabaseAdmin
      .from('profiles')
      .insert({
        user_id: parentUserId,
        email: invitation.parent_email,
        prenom: prenom,
        nom: nom,
        classe: 'parent', // Utiliser "parent" comme classe pour les parents
        reception_news: false,
        paiement_valide: false,
      });

    if (profileError) {
      console.error('Error creating profile:', profileError);
      // Si erreur, supprimer le compte auth créé
      await supabaseAdmin.auth.admin.deleteUser(parentUserId);
      return new Response(
        JSON.stringify({ error: 'Erreur lors de la création du profil' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    console.log('Profile created for parent');

    // 4. Créer le rôle parent (avec admin client)
    const { error: roleError } = await supabaseAdmin
      .from('user_roles')
      .insert({
        user_id: parentUserId,
        role: 'parent',
      });

    if (roleError) {
      console.error('Error creating role:', roleError);
      // Si erreur, supprimer le profil et le compte auth
      await supabaseAdmin.from('profiles').delete().eq('user_id', parentUserId);
      await supabaseAdmin.auth.admin.deleteUser(parentUserId);
      return new Response(
        JSON.stringify({ error: 'Erreur lors de la création du rôle' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    console.log('Role created for parent');

    // 5. Créer la relation parent-eleve (avec admin client)
    const { error: relationError } = await supabaseAdmin
      .from('parent_eleve_relations')
      .insert({
        parent_user_id: parentUserId,
        eleve_user_id: invitation.eleve_user_id,
      });

    if (relationError) {
      console.error('Error creating parent-eleve relation:', relationError);
      // Si erreur, nettoyer tout ce qui a été créé
      await supabaseAdmin.from('user_roles').delete().eq('user_id', parentUserId);
      await supabaseAdmin.from('profiles').delete().eq('user_id', parentUserId);
      await supabaseAdmin.auth.admin.deleteUser(parentUserId);
      
      if (relationError.message.includes('maximum')) {
        return new Response(
          JSON.stringify({ error: 'Cet élève a déjà atteint le maximum de 2 parents' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }
      
      return new Response(
        JSON.stringify({ error: 'Erreur lors de la création de la relation parent-élève' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    console.log('Parent-eleve relation created');

    // 6. Mettre à jour l'invitation à "accepted" (avec admin client)
    const { error: updateError } = await supabaseAdmin
      .from('parent_invitations')
      .update({ status: 'accepted' })
      .eq('id', invitation.id);

    if (updateError) {
      console.error('Error updating invitation status:', updateError);
      // On continue quand même, le compte est créé
    }

    console.log('Invitation status updated to accepted');

    return new Response(
      JSON.stringify({ 
        success: true,
        message: 'Compte parent créé avec succès',
        eleveNom: invitation.profiles?.nom,
        elevePrenom: invitation.profiles?.prenom
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (error) {
    console.error('Unexpected error in create-parent-account:', error);
    return new Response(
      JSON.stringify({ error: 'Une erreur inattendue s\'est produite' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
