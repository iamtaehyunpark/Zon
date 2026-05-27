import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface RegisterPlacePayload {
  name: string
  category: string
  space_type: 'outdoor_artificial' | 'outdoor_natural' | 'indoor_artificial' | 'indoor_natural'
  lat: number
  lng: number
  address?: string
  operating_hours?: Record<string, string>
  anchor_image_hash?: string
  certificate_hash?: string
  initial_submission?: {
    liveness_passed: boolean
    vision_score?: number
    embedding_similarity?: number
    inlier_count?: number
    depth_variance?: number
    sensor_match_score?: number
    final_score?: number
    gps_lat?: number
    gps_lng?: number
    wifi_fingerprint?: Record<string, number>
    imu_snapshot?: Record<string, unknown>
    frame_count?: number
    viewpoint_direction?: string
  }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: cors })
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    )

    // Authenticate
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return json({ error: 'Missing authorization' }, 401)
    }
    const { data: { user }, error: authError } = await supabase.auth.getUser(
      authHeader.replace('Bearer ', ''),
    )
    if (authError || !user) {
      return json({ error: 'Unauthorized' }, 401)
    }

    const body: RegisterPlacePayload = await req.json()
    if (!body.name || !body.category || !body.space_type || !body.lat || !body.lng) {
      return json({ error: 'Missing required fields' }, 400)
    }

    // Check for duplicate nearby place (within 20m)
    const { data: nearby } = await supabase.rpc('places_within_radius', {
      user_lat: body.lat,
      user_lng: body.lng,
      radius_m: 20,
    })
    if ((nearby ?? []).length > 0) {
      return json({ error: 'A place already exists within 20m of this location' }, 409)
    }

    // Create place
    const { data: place, error: placeError } = await supabase
      .from('places')
      .insert({
        name:              body.name,
        category:          body.category,
        space_type:        body.space_type,
        lat:               body.lat,
        lng:               body.lng,
        address:           body.address ?? null,
        operating_hours:   body.operating_hours ?? null,
        anchor_image_hash: body.anchor_image_hash ?? null,
        status:            'pending',
        registered_by:     user.id,
      })
      .select('id')
      .single()

    if (placeError) throw placeError
    const placeId = place.id as string

    // Create initial coverage row
    await supabase.from('place_coverage').upsert({
      place_id:          placeId,
      total_submissions: 0,
      unique_submitters: 0,
      viewpoint_clusters: 0,
    })

    // If an initial submission was provided, record it
    let submissionId: string | null = null
    if (body.initial_submission) {
      const sub = body.initial_submission
      const { data: submission, error: subError } = await supabase
        .from('place_submissions')
        .insert({
          place_id:             placeId,
          submitted_by:         user.id,
          round_number:         1,
          liveness_passed:      sub.liveness_passed,
          vision_score:         sub.vision_score ?? null,
          embedding_similarity: sub.embedding_similarity ?? null,
          inlier_count:         sub.inlier_count ?? null,
          depth_variance:       sub.depth_variance ?? null,
          sensor_match_score:   sub.sensor_match_score ?? null,
          final_score:          sub.final_score ?? null,
          gps_lat:              sub.gps_lat ?? body.lat,
          gps_lng:              sub.gps_lng ?? body.lng,
          wifi_fingerprint:     sub.wifi_fingerprint ?? null,
          imu_snapshot:         sub.imu_snapshot ?? null,
          certificate_hash:     body.certificate_hash ?? null,
          frame_count:          sub.frame_count ?? null,
          status:               'accepted',
        })
        .select('id')
        .single()

      if (!subError) {
        submissionId = submission.id
        await supabase.from('place_coverage').upsert({
          place_id:          placeId,
          total_submissions: 1,
          accepted_submissions: 1,
          unique_submitters: 1,
          viewpoint_clusters: 1,
        })
      }
    }

    return json({
      place_id: placeId,
      status: 'pending',
      submission_id: submissionId,
      pioneer_badge_reserved: true,
      coverage_required: {
        unique_submitters: 3,
        viewpoint_clusters: 3,
        daytime: true,
        nighttime: true,
      },
    })
  } catch (err) {
    console.error(err)
    return json({ error: err.message ?? 'Internal error' }, 500)
  }
})

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...cors, 'Content-Type': 'application/json' },
  })
}
