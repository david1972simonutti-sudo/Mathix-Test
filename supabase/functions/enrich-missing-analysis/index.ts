import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

/**
 * 🔧 Fonction Edge pour enrichir rétroactivement les interactions sans analyse_fine
 * 
 * Cette fonction :
 * 1. Trouve les interactions avec analyse_fine null ou vide
 * 2. Ré-analyse ces interactions avec l'IA pour générer une analyse_fine
 * 3. Met à jour l'interaction et le profil étudiant
 * 
 * Peut être déclenchée :
 * - Manuellement par l'utilisateur
 * - Par un cron job périodique
 * - Après un rebuild de compétences
 */

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    // Get auth token
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      throw new Error('Missing authorization header');
    }

    // Create Supabase client
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: authHeader },
        },
      }
    );

    // Admin client for updates
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    // Verify user
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser();
    if (userError || !user) {
      throw new Error('Unauthorized');
    }

    console.log(`🔍 Enriching missing analyses for user: ${user.id}`);

    // Fetch interactions without proper analyse_fine
    // Strategy: Select where analyse_erreur is null OR where analyse_erreur.analyse_fine is missing
    const { data: interactions, error: interactionsError } = await supabaseAdmin
      .from('interactions')
      .select('id, user_id, chapitre, exercice_enonce, reponse_eleve, analyse_erreur, created_at')
      .eq('user_id', user.id)
      .not('reponse_eleve', 'is', null)
      .order('created_at', { ascending: false })
      .limit(100); // Process last 100 interactions

    if (interactionsError) {
      throw interactionsError;
    }

    if (!interactions || interactions.length === 0) {
      console.log('⚠️ No interactions found');
      return new Response(
        JSON.stringify({ 
          success: true, 
          message: 'No interactions to enrich',
          processed: 0 
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    console.log(`📊 Found ${interactions.length} interactions, filtering for missing analyse_fine...`);

    // Filter interactions that need enrichment
    const needsEnrichment = interactions.filter(i => {
      const analyseErreur = i.analyse_erreur as any;
      const hasAnalyseFine = analyseErreur?.analyse_fine && 
                             Array.isArray(analyseErreur.analyse_fine) && 
                             analyseErreur.analyse_fine.length > 0;
      return !hasAnalyseFine;
    });

    console.log(`🔧 ${needsEnrichment.length} interactions need enrichment`);

    if (needsEnrichment.length === 0) {
      return new Response(
        JSON.stringify({ 
          success: true, 
          message: 'All interactions already have analyse_fine',
          processed: 0 
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Helper to detect chapter from text
    const detectChapter = (text: string): string | null => {
      if (!text) return null;
      const msg = text.toLowerCase();
      
      const chapterKeywords: Record<string, string[]> = {
        "Équations du second degré": ["second degré", "discriminant", "delta", "trinôme"],
        "Dérivation": ["dérivée", "dériver", "tangente", "f'(x)"],
        "Suites": ["suite", "récurrence", "u_n", "v_n", "terme"],
        "Fonctions": ["fonction", "courbe", "graphe", "image", "f(x)"],
        "Probabilités": ["probabilité", "proba", "loi", "binomiale"],
        "Limites": ["limite", "infini", "asymptote", "lim"],
        "Intégrales": ["intégrale", "primitive", "aire"],
        "Trigonométrie": ["cosinus", "sinus", "tangente", "cos", "sin"],
        "Logarithmes": ["logarithme", "ln", "log", "exponentielle", "exp"],
        "Vecteurs": ["vecteur", "colinéaire", "norme"],
        "Géométrie": ["triangle", "cercle", "pythagore"]
      };
      
      for (const [chapter, keywords] of Object.entries(chapterKeywords)) {
        if (keywords.some(kw => msg.includes(kw))) {
          return chapter;
        }
      }
      
      return null;
    };

    // Helper to detect if it's a help request
    const isHelpRequest = (text: string): boolean => {
      if (!text) return false;
      const msg = text.toLowerCase();
      const helpPatterns = [
        "je ne me souviens plus", "j'ai oublié", "explique", "rappelle-moi",
        "comment on fait", "je comprends pas", "aide-moi", "c'est quoi",
        "je suis perdu", "je bloque"
      ];
      return helpPatterns.some(p => msg.includes(p));
    };

    // Process each interaction that needs enrichment
    let enrichedCount = 0;
    const enrichmentPromises = needsEnrichment.slice(0, 20).map(async (interaction) => {
      try {
        // Determine chapter
        let chapitre = interaction.chapitre;
        if (!chapitre) {
          chapitre = detectChapter(interaction.reponse_eleve || '') ||
                     detectChapter(typeof interaction.exercice_enonce === 'string' 
                       ? interaction.exercice_enonce 
                       : JSON.stringify(interaction.exercice_enonce || ''));
        }
        
        if (!chapitre) {
          console.log(`  ⏭️ Interaction ${interaction.id}: No chapter identifiable`);
          return null;
        }

        console.log(`  🔄 Processing interaction ${interaction.id} - ${chapitre}`);

        // Generate analyse_fine using AI
        const enrichmentPrompt = `CONTEXTE:
Exercice : ${typeof interaction.exercice_enonce === 'string' 
  ? interaction.exercice_enonce.substring(0, 300) 
  : JSON.stringify(interaction.exercice_enonce || {}).substring(0, 300)}
Réponse élève : ${interaction.reponse_eleve?.substring(0, 500)}
Chapitre : ${chapitre}

MISSION : Identifie la sous-notion PRÉCISE travaillée et son statut.

Réponds UNIQUEMENT avec ce JSON :
{
  "sous_notion": "Nom précis de la sous-notion (max 6 mots)",
  "statut": "maitrise" | "a_renforcer" | "en_cours",
  "details": "Diagnostic court"
}`;

        const aiResponse = await fetch("https://ai.gateway.lovable.dev/v1/chat/completions", {
          method: "POST",
          headers: {
            "Authorization": `Bearer ${Deno.env.get("LOVABLE_API_KEY")}`,
            "Content-Type": "application/json"
          },
          body: JSON.stringify({
            model: "google/gemini-2.5-flash",
            messages: [{ role: "user", content: enrichmentPrompt }],
            temperature: 0.3,
            max_tokens: 200
          })
        });

        if (!aiResponse.ok) {
          console.log(`    ❌ AI request failed: ${aiResponse.status}`);
          return null;
        }

        const data = await aiResponse.json();
        const aiContent = data.choices?.[0]?.message?.content || "";
        
        // Extract JSON
        const jsonMatch = aiContent.match(/\{[^}]*"sous_notion"[^}]*\}/);
        if (!jsonMatch) {
          console.log(`    ⚠️ No JSON found in AI response`);
          
          // Fallback: generic analysis avec vocabulaire encourageant
          const isHelp = isHelpRequest(interaction.reponse_eleve || '');
          const analyseFine = [{
            sous_notion: chapitre,
            statut: isHelp ? "a_renforcer" : "en_cours",
            details: "Analyse générique (enrichissement automatique)"
          }];
          
          return { interaction, chapitre, analyseFine };
        }

        const parsed = JSON.parse(jsonMatch[0]);
        // Normaliser le statut pour compatibilité
        let normalizedStatut = parsed.statut || "en_cours";
        if (normalizedStatut === "lacune") normalizedStatut = "a_renforcer";
        if (normalizedStatut === "en_cours_acquisition") normalizedStatut = "en_cours";
        if (normalizedStatut === "maîtrisé") normalizedStatut = "maitrise";
        
        const analyseFine = [{
          sous_notion: parsed.sous_notion || chapitre,
          statut: normalizedStatut,
          details: parsed.details || "Enrichissement automatique"
        }];

        console.log(`    ✅ Generated: ${analyseFine[0].sous_notion} (${analyseFine[0].statut})`);
        
        return { interaction, chapitre, analyseFine };
      } catch (error) {
        console.error(`    ❌ Error processing interaction ${interaction.id}:`, error);
        return null;
      }
    });

    const results = await Promise.all(enrichmentPromises);
    const successfulResults = results.filter(r => r !== null);

    console.log(`✅ Successfully enriched ${successfulResults.length} interactions`);

    // Update interactions in database and student profile
    for (const result of successfulResults) {
      if (!result) continue;
      
      const { interaction, chapitre, analyseFine } = result;
      
      // Update interaction with new analyse_fine
      const updatedAnalyseErreur = {
        ...(interaction.analyse_erreur || {}),
        analyse_fine: analyseFine,
        enriched_at: new Date().toISOString()
      };
      
      const { error: updateError } = await supabaseAdmin
        .from('interactions')
        .update({
          analyse_erreur: updatedAnalyseErreur,
          chapitre: chapitre // Update chapter if it was missing
        })
        .eq('id', interaction.id);
      
      if (updateError) {
        console.error(`❌ Error updating interaction ${interaction.id}:`, updateError);
      } else {
        enrichedCount++;
        console.log(`  💾 Updated interaction ${interaction.id}`);
      }
      
      // Update student profile
      try {
        await updateStudentCompetences(supabaseAdmin, interaction.user_id, chapitre, analyseFine);
        console.log(`  📊 Updated student profile for ${chapitre}`);
      } catch (error) {
        console.error(`  ❌ Error updating profile:`, error);
      }
    }

    console.log(`🎉 Enrichment complete: ${enrichedCount}/${needsEnrichment.length} interactions updated`);

    return new Response(
      JSON.stringify({ 
        success: true,
        processed: enrichedCount,
        total_found: needsEnrichment.length,
        message: `Successfully enriched ${enrichedCount} interactions`
      }),
      { 
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    );

  } catch (error) {
    console.error('❌ Error enriching analyses:', error);
    return new Response(
      JSON.stringify({ 
        error: (error as Error).message || 'Internal server error' 
      }),
      { 
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    );
  }
});

// Helper function to update student competences (copied from analyze-response)
async function updateStudentCompetences(
  supabase: any,
  userId: string,
  chapitre: string,
  analyseFine: Array<{
    sous_notion: string;
    statut: string; // maitrise | a_renforcer | en_cours | fragile
    details: string;
  }>
) {
  if (!analyseFine || analyseFine.length === 0) return;
  
  try {
    const { data: profile, error: fetchError } = await supabase
      .from('student_profiles')
      .select('competences, lacunes_identifiees, id')
      .eq('user_id', userId)
      .maybeSingle();
    
    const competences = profile?.competences || {};
    const lacunes = profile?.lacunes_identifiees || [];
    
    if (!competences[chapitre]) {
      competences[chapitre] = {
        reussites_globales: 0,
        echecs_globaux: 0,
        sous_notions: {}
      };
    }
    
    for (const item of analyseFine) {
      const { sous_notion, statut, details } = item;
      
      if (!competences[chapitre].sous_notions[sous_notion]) {
        competences[chapitre].sous_notions[sous_notion] = {
          reussites: 0,
          echecs: 0,
          statut: "en_cours"
        };
      }
      
      const sousNotionData = competences[chapitre].sous_notions[sous_notion];
      
      // Normaliser le statut (accepte anciens ET nouveaux noms)
      const normalizedStatut = statut === "maîtrisé" ? "maitrise" 
        : statut === "lacune" ? "a_renforcer"
        : statut === "en_cours_acquisition" ? "en_cours"
        : statut;
      
      if (normalizedStatut === "maitrise") {
        sousNotionData.reussites += 1;
        competences[chapitre].reussites_globales += 1;
        
        if (sousNotionData.reussites >= 3 && sousNotionData.echecs < 2) {
          sousNotionData.statut = "maitrise";
          
          const lacuneIndex = lacunes.findIndex(
            (l: any) => l.sous_notion === sous_notion && l.chapitre === chapitre
          );
          if (lacuneIndex !== -1) {
            lacunes.splice(lacuneIndex, 1);
          }
        }
      } else if (normalizedStatut === "a_renforcer") {
        sousNotionData.echecs += 1;
        competences[chapitre].echecs_globaux += 1;
        
        if (sousNotionData.echecs >= 2) {
          sousNotionData.statut = "a_renforcer";
          
          const gapExists = lacunes.some(
            (l: any) => l.sous_notion === sous_notion && l.chapitre === chapitre
          );
          
          if (!gapExists) {
            lacunes.push({
              chapitre,
              sous_notion,
              identifie_le: new Date().toISOString(),
              details
            });
          }
        }
      } else if (normalizedStatut === "en_cours" || normalizedStatut === "fragile") {
        if (sousNotionData.statut !== "maitrise" && sousNotionData.statut !== "a_renforcer") {
          sousNotionData.statut = normalizedStatut;
        }
      }
    }
    
    if (profile?.id) {
      await supabase
        .from('student_profiles')
        .update({
          competences,
          lacunes_identifiees: lacunes,
          updated_at: new Date().toISOString()
        })
        .eq('user_id', userId);
    } else {
      await supabase
        .from('student_profiles')
        .insert({
          user_id: userId,
          competences,
          lacunes_identifiees: lacunes
        });
    }
  } catch (error) {
    console.error("Error in updateStudentCompetences:", error);
    throw error;
  }
}
