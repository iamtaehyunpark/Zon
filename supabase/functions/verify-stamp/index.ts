import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface VerifyStampPayload {
  place_id: string
  certificate_hash: string
  vision_score: number
  sensor_score: number
  final_score: number
  tier: 'tier1' | 'tier2' | 'tier3'
  gps_lat: number
  gps_lng: number
  wifi_fingerprint?: Record<string, number>
  imu_snapshot?: Record<string, unknown>
  frame_count: number
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    )

    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing authorization' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const { data: { user }, error: authError } = await supabase.auth.getUser(
      authHeader.replace('Bearer ', ''),
    )
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const payload: VerifyStampPayload = await req.json()

    // Reject below threshold
    if (payload.final_score <= 0.5) {
      return new Response(JSON.stringify({ error: 'Verification failed: score too low' }), {
        status: 422,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const { data: stamp, error: stampError } = await supabase
      .from('stamps')
      .insert({
        user_id: user.id,
        place_id: payload.place_id,
        tier: payload.tier,
        certificate_hash: payload.certificate_hash,
        vision_score: payload.vision_score,
        sensor_score: payload.sensor_score,
        final_score: payload.final_score,
      })
      .select()
      .single()

    if (stampError) throw stampError

    return new Response(JSON.stringify({ stamp }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
