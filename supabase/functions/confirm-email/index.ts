import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.75.0';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const url = new URL(req.url);
    const token = url.searchParams.get('token');

    if (!token) {
      throw new Error('Token is required');
    }

    console.log('Confirming email with token:', token);

    // Initialize Supabase admin client
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

    // Find the confirmation record
    const { data: confirmation, error: findError } = await supabaseAdmin
      .from('email_confirmations')
      .select('*')
      .eq('token', token)
      .is('confirmed_at', null)
      .single();

    if (findError || !confirmation) {
      console.error('Confirmation not found:', findError);
      throw new Error('Invalid or expired confirmation token');
    }

    // Check if token is expired
    if (new Date(confirmation.expires_at) < new Date()) {
      throw new Error('Confirmation token has expired');
    }

    console.log('Found confirmation for user:', confirmation.user_id);

    // Update confirmation record
    const { error: updateError } = await supabaseAdmin
      .from('email_confirmations')
      .update({ confirmed_at: new Date().toISOString() })
      .eq('token', token);

    if (updateError) {
      console.error('Error updating confirmation:', updateError);
      throw updateError;
    }

    // Confirm user in Supabase Auth
    const { error: confirmError } = await supabaseAdmin.auth.admin.updateUserById(
      confirmation.user_id,
      { email_confirm: true }
    );

    if (confirmError) {
      console.error('Error confirming user:', confirmError);
      throw confirmError;
    }

    console.log('Successfully confirmed email for user:', confirmation.user_id);

    return new Response(
      JSON.stringify({ 
        message: 'Email confirmed successfully',
        success: true 
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200 
      }
    );

  } catch (error) {
    console.error('Error in confirm-email function:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error occurred';
    return new Response(
      JSON.stringify({ 
        error: errorMessage,
        success: false 
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400 
      }
    );
  }
});
