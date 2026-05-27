import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

/// Updates place_coverage stats and triggers confirmation check after a new submission.
serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    )

    const { place_id, submission_id } = await req.json()
    if (!place_id) {
      return new Response(JSON.stringify({ error: 'place_id required' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const { data: stats, error } = await supabase
      .from('place_submissions')
      .select('submitted_by, status, liveness_passed')
      .eq('place_id', place_id)

    if (error) throw error

    const accepted = stats.filter((s) => s.status === 'accepted')
    const rejected = stats.filter((s) => s.status === 'rejected')
    const uniqueSubmitters = new Set(accepted.map((s) => s.submitted_by)).size
    const rejectionRate = stats.length > 0 ? rejected.length / stats.length : null

    const { error: upsertError } = await supabase
      .from('place_coverage')
      .upsert({
        place_id,
        total_submissions: stats.length,
        accepted_submissions: accepted.length,
        unique_submitters: uniqueSubmitters,
        rejection_rate: rejectionRate,
        last_updated: new Date().toISOString(),
      })

    if (upsertError) throw upsertError

    // Trigger confirmation check
    await supabase.rpc('check_and_confirm_place', { p_place_id: place_id })

    return new Response(JSON.stringify({ ok: true }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
