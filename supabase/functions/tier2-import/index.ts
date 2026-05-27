import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

/// TODO(phase3): Tier 2 historical import from Google Maps / Instagram timelines.
/// Not implemented in MVP. Returns 501 until Phase 3.
serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  return new Response(
    JSON.stringify({ error: 'Not implemented — Phase 3 feature' }),
    {
      status: 501,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    },
  )
})
