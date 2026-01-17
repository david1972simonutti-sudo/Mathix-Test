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

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // SÉCURITÉ : Vérifier le token JWT et récupérer l'utilisateur authentifié
    const token = authHeader.replace('Bearer ', '');
    const { data: { user: authenticatedUser }, error: authError } = await supabase.auth.getUser(token);

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

    console.log(`User ${authenticatedUser.id} uploading static asset`);

    const { base64Data, fileName, contentType } = await req.json();

    if (!base64Data || !fileName) {
      return new Response(
        JSON.stringify({ error: 'Missing base64Data or fileName' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // SÉCURITÉ : Validation du nom de fichier (éviter path traversal)
    const sanitizedFileName = fileName.replace(/[^a-zA-Z0-9._-]/g, '_');
    if (sanitizedFileName !== fileName) {
      console.warn(`Filename sanitized from "${fileName}" to "${sanitizedFileName}"`);
    }

    // SÉCURITÉ : Validation du type de contenu
    const allowedContentTypes = ['image/png', 'image/jpeg', 'image/gif', 'image/webp', 'application/pdf'];
    const finalContentType = contentType || 'image/png';
    if (!allowedContentTypes.includes(finalContentType)) {
      return new Response(
        JSON.stringify({ error: 'Content type not allowed' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // SÉCURITÉ : Limiter la taille du fichier (5MB max)
    const maxSizeBytes = 5 * 1024 * 1024;
    const estimatedSize = (base64Data.length * 3) / 4;
    if (estimatedSize > maxSizeBytes) {
      return new Response(
        JSON.stringify({ error: 'File too large (max 5MB)' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Decode base64 to Uint8Array
    const binaryString = atob(base64Data);
    const bytes = new Uint8Array(binaryString.length);
    for (let i = 0; i < binaryString.length; i++) {
      bytes[i] = binaryString.charCodeAt(i);
    }

    // Utiliser l'ID utilisateur dans le chemin pour isoler les fichiers par utilisateur
    const filePath = `user-uploads/${authenticatedUser.id}/${sanitizedFileName}`;

    const { data, error } = await supabase.storage
      .from('student-responses')
      .upload(filePath, bytes, {
        contentType: finalContentType,
        upsert: true
      });

    if (error) {
      console.error('Upload error:', error);
      return new Response(
        JSON.stringify({ error: error.message }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // Générer une URL signée (bucket privé) pour sécuriser les photos élèves
    const { data: signedUrlData, error: signedUrlError } = await supabase.storage
      .from('student-responses')
      .createSignedUrl(filePath, 3600); // Expire dans 1 heure

    if (signedUrlError || !signedUrlData?.signedUrl) {
      console.error('Signed URL error:', signedUrlError);
      return new Response(
        JSON.stringify({ error: 'Failed to generate signed URL' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    console.log(`Upload successful by user ${authenticatedUser.id}:`, signedUrlData.signedUrl);

    return new Response(
      JSON.stringify({ success: true, url: signedUrlData.signedUrl }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (error: unknown) {
    console.error('Error:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    return new Response(
      JSON.stringify({ error: errorMessage }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
