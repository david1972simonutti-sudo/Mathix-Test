import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    // SÉCURITÉ : Vérifier l'en-tête Authorization
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      console.error('Missing Authorization header');
      return new Response(
        JSON.stringify({ error: 'Authorization header required' }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 401 
        }
      );
    }

    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    );

    // SÉCURITÉ : Vérifier le token JWT et récupérer l'utilisateur authentifié
    const token = authHeader.replace('Bearer ', '');
    const { data: { user: authenticatedUser }, error: authError } = await supabaseAdmin.auth.getUser(token);

    if (authError || !authenticatedUser) {
      console.error('Invalid token or user not found:', authError?.message);
      return new Response(
        JSON.stringify({ error: 'Invalid or expired token' }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 401 
        }
      );
    }

    // SÉCURITÉ CRITIQUE : Vérifier que l'utilisateur est administrateur
    const { data: roleData, error: roleError } = await supabaseAdmin
      .from('user_roles')
      .select('role')
      .eq('user_id', authenticatedUser.id)
      .eq('role', 'administrateur')
      .single();

    if (roleError || !roleData) {
      console.error(`Security violation: Non-admin user ${authenticatedUser.id} attempted to create test accounts`);
      return new Response(
        JSON.stringify({ error: 'Administrator access required' }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 403 
        }
      );
    }

    console.log(`Admin ${authenticatedUser.id} authorized to create test accounts`);

    // Parse request body for custom account
    const body = await req.json().catch(() => null);
    
    if (!body?.account) {
      return new Response(
        JSON.stringify({ error: 'Account data required in request body' }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 400 
        }
      );
    }

    const account = {
      email: body.account.email,
      password: body.account.password,
      classe: body.account.classe || 'Terminale',
      prenom: body.account.prenom || 'Test',
      nom: body.account.nom || 'User'
    };

    // Validation des données
    if (!account.email || !account.password) {
      return new Response(
        JSON.stringify({ error: 'Email and password are required' }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 400 
        }
      );
    }

    if (account.password.length < 8) {
      return new Response(
        JSON.stringify({ error: 'Password must be at least 8 characters' }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 400 
        }
      );
    }

    console.log(`Creating account for ${account.email}...`);

    // 1. Créer l'utilisateur auth avec email confirmé
    const { data: authUser, error: createAuthError } = await supabaseAdmin.auth.admin.createUser({
      email: account.email,
      password: account.password,
      email_confirm: true,
    });

    if (createAuthError) {
      console.error(`Error creating auth user ${account.email}:`, createAuthError);
      return new Response(
        JSON.stringify({ error: createAuthError.message }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 400 
        }
      );
    }

    const userId = authUser.user.id;
    console.log(`Auth user created: ${userId}`);

    // 2. Créer le profil
    const { error: profileError } = await supabaseAdmin.from('profiles').insert({
      user_id: userId,
      email: account.email,
      prenom: account.prenom,
      nom: account.nom,
      classe: account.classe,
    });

    if (profileError) {
      console.error(`Error creating profile for ${account.email}:`, profileError);
    }

    // 3. Créer le student_profile avec compétences transversales à 50%
    const defaultTransversales = {
      chercher: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
      modeliser: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
      representer: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
      raisonner: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
      calculer: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] },
      communiquer: { score_actuel: 0.5, total_sollicitations: 0, interactions: [] }
    };
    
    const { error: studentProfileError } = await supabaseAdmin.from('student_profiles').insert({
      user_id: userId,
      competences: { _transversales: defaultTransversales }
    });

    if (studentProfileError) {
      console.error(`Error creating student_profile for ${account.email}:`, studentProfileError);
    }

    // 4. Attribuer le rôle élève (pas admin!)
    const { error: insertRoleError } = await supabaseAdmin.from('user_roles').insert({
      user_id: userId,
      role: 'eleve',
    });

    if (insertRoleError) {
      console.error(`Error creating role for ${account.email}:`, insertRoleError);
    }

    console.log(`Account ${account.email} created successfully by admin ${authenticatedUser.id}!`);

    return new Response(JSON.stringify({ 
      message: 'Test account created!',
      result: {
        email: account.email,
        classe: account.classe,
        status: 'created',
        userId
      }
    }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });

  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    console.error('Unexpected error:', error);
    return new Response(JSON.stringify({ error: errorMessage }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }
});
