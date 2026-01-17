import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
    const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    
    if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
      throw new Error("Missing environment variables");
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
    
    const { userId } = await req.json();
    
    if (!userId) {
      throw new Error("Missing userId");
    }

    console.log("🧪 Testing randomization for user:", userId);
    
    const results = {
      generated: 0,
      uniqueHashes: new Set(),
      uniqueParams: new Set(),
      duplicateAttempts: 0,
      exercises: [] as any[],
    };

    // Generate 10 exercises
    for (let i = 0; i < 10; i++) {
      console.log(`\n🎲 Generating exercise ${i + 1}/10...`);
      
      const response = await fetch(`${SUPABASE_URL}/functions/v1/analyze-response`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${SUPABASE_SERVICE_ROLE_KEY}`,
        },
        body: JSON.stringify({
          userId,
          message: `donne moi un exercice sur la récurrence test ${i + 1}`,
        }),
      });

      if (!response.ok) {
        console.error(`❌ Failed to generate exercise ${i + 1}`);
        continue;
      }

      const data = await response.json();
      
      if (data.data?.type === "exercice_genere" && data.data.exercice_id) {
        results.generated++;
        
        // Fetch the exercise to get hash and params
        const { data: exercise } = await supabase
          .from("exercices")
          .select("content_hash, params")
          .eq("id", data.data.exercice_id)
          .single();
        
        if (exercise) {
          if (exercise.content_hash) {
            if (results.uniqueHashes.has(exercise.content_hash)) {
              results.duplicateAttempts++;
              console.log(`⚠️ Duplicate hash detected: ${exercise.content_hash.substring(0, 10)}...`);
            }
            results.uniqueHashes.add(exercise.content_hash);
          }
          
          if (exercise.params) {
            const paramsStr = JSON.stringify(exercise.params);
            if (results.uniqueParams.has(paramsStr)) {
              console.log(`⚠️ Duplicate params detected: ${paramsStr}`);
            }
            results.uniqueParams.add(paramsStr);
          }
          
          results.exercises.push({
            id: data.data.exercice_id,
            hash: exercise.content_hash?.substring(0, 10),
            params: exercise.params,
            chapitre: data.data.chapitre,
          });
          
          console.log(`✅ Exercise ${i + 1} generated - Hash: ${exercise.content_hash?.substring(0, 10)}... Params: ${JSON.stringify(exercise.params)}`);
        }
      }
      
      // Small delay to avoid rate limiting
      await new Promise(resolve => setTimeout(resolve, 1000));
    }

    console.log("\n📊 Final Results:");
    console.log(`- Exercises generated: ${results.generated}/10`);
    console.log(`- Unique hashes: ${results.uniqueHashes.size}`);
    console.log(`- Unique params: ${results.uniqueParams.size}`);
    console.log(`- Duplicate attempts: ${results.duplicateAttempts}`);
    console.log(`- Uniqueness rate: ${((results.uniqueHashes.size / results.generated) * 100).toFixed(1)}%`);

    return new Response(
      JSON.stringify({
        success: true,
        summary: {
          generated: results.generated,
          uniqueHashes: results.uniqueHashes.size,
          uniqueParams: results.uniqueParams.size,
          duplicateAttempts: results.duplicateAttempts,
          uniquenessRate: `${((results.uniqueHashes.size / results.generated) * 100).toFixed(1)}%`,
        },
        exercises: results.exercises,
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error: any) {
    console.error("Test error:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});
