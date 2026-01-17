import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders })
  }

  try {
    console.log('🕐 Starting daily competences snapshot...')

    // Create Supabase client with service role for admin access
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    
    const supabase = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { persistSession: false }
    })

    // Get current date in YYYY-MM-DD format
    const today = new Date().toISOString().split('T')[0]
    console.log(`📅 Snapshot date: ${today}`)

    // Fetch all student profiles with competences
    const { data: studentProfiles, error: fetchError } = await supabase
      .from('student_profiles')
      .select('user_id, competences')
      .not('competences', 'is', null)

    if (fetchError) {
      console.error('❌ Error fetching student profiles:', fetchError)
      throw fetchError
    }

    console.log(`📊 Found ${studentProfiles?.length || 0} student profiles`)

    if (!studentProfiles || studentProfiles.length === 0) {
      return new Response(
        JSON.stringify({ 
          success: true, 
          message: 'No student profiles found',
          snapshotsCreated: 0 
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Prepare snapshots for upsert
    const snapshots = studentProfiles.map(profile => ({
      user_id: profile.user_id,
      snapshot_date: today,
      competences: profile.competences || {},
    }))

    // Upsert snapshots (insert or update if already exists for today)
    const { data: upsertedData, error: upsertError } = await supabase
      .from('competences_snapshots')
      .upsert(snapshots, { 
        onConflict: 'user_id,snapshot_date',
        ignoreDuplicates: false 
      })
      .select('id')

    if (upsertError) {
      console.error('❌ Error upserting snapshots:', upsertError)
      throw upsertError
    }

    const count = upsertedData?.length || snapshots.length
    console.log(`✅ Successfully saved ${count} competences snapshots for ${today}`)

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: `Saved ${count} snapshots`,
        snapshotsCreated: count,
        date: today
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error: any) {
    console.error('❌ Error in save-daily-snapshots:', error)
    
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: error.message 
      }),
      { 
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
})
