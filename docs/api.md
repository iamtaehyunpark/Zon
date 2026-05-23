# ZON — Edge Function API Reference

All Edge Functions run on Supabase (Deno/TypeScript).
Base URL: `https://<project>.supabase.co/functions/v1/`

Authentication: All endpoints require `Authorization: Bearer <supabase_jwt>` unless noted.

---

## POST /verify-stamp

Receives the on-device verification result, validates the certificate signature,
creates the Stamp record, and triggers badge evaluation.

**Images are NEVER accepted. Only the signed proof payload.**

### Request Body
```json
{
  "place_id": "uuid",
  "tier": "tier1",
  "certificate_hash": "sha256-hex-string",
  "vision_score": 0.89,
  "sensor_score": 0.94,
  "final_score": 0.91,
  "route": "A",
  "gps_lat": 37.5665,
  "gps_lng": 126.9780,
  "wifi_fingerprint": { "AA:BB:CC:DD:EE:FF": -62 },
  "local_time": "2025-05-22T09:41:00+09:00",
  "weather": "sunny",
  "season": "spring",
  "time_of_day": "morning",
  "frame_count": 180,
  "device_model": "iPhone 15 Pro"
}
```

### Response
```json
{
  "stamp_id": "uuid",
  "badges_earned": [
    { "badge_id": "uuid", "badge_type": "place_signature", "name": "Blue Bottle Seongsu" }
  ],
  "pioneer_reserved": false,
  "place_status": "confirmed"
}
```

### Errors
| Code | Reason |
|------|--------|
| 400 | Invalid certificate hash |
| 400 | Place not found or not eligible |
| 400 | Score below threshold (< 0.75) |
| 409 | Duplicate stamp for same place within 24h |

---

## POST /submit-place-reference

Receives a consensus registration submission. Validates liveness result,
stores the submission, updates coverage, and confirms place if threshold met.

### Request Body
```json
{
  "place_id": "uuid",
  "liveness_passed": true,
  "vision_score": 0.87,
  "embedding_similarity": 0.91,
  "inlier_count": 143,
  "depth_variance": 0.34,
  "sensor_match_score": 0.95,
  "final_score": 0.88,
  "gps_lat": 37.5441,
  "gps_lng": 127.0557,
  "wifi_fingerprint": { "AA:BB:CC:DD:EE:FF": -58 },
  "imu_snapshot": { "ax": 0.01, "ay": 9.81, "az": 0.02 },
  "certificate_hash": "sha256-hex-string",
  "frame_count": 210,
  "viewpoint_direction": "north"
}
```

### Response
```json
{
  "submission_id": "uuid",
  "round_number": 2,
  "status": "accepted",
  "coverage": {
    "unique_submitters": 2,
    "viewpoint_clusters": 2,
    "has_daytime": true,
    "has_nighttime": false,
    "missing": ["nighttime_submission"]
  },
  "place_confirmed": false,
  "badges_reserved": ["founder"]
}
```

---

## POST /register-place

Creates a new place in `pending` status from the first registration submission.
Also creates the initial `place_coverage` row and `place_submissions` round 1.

### Request Body
```json
{
  "name": "Blue Bottle Coffee Seongsu",
  "category": "cafe",
  "space_type": "indoor_artificial",
  "lat": 37.5441,
  "lng": 127.0557,
  "address": "서울 성동구 아차산로9길 12",
  "operating_hours": {
    "mon": "08:00-21:00",
    "tue": "08:00-21:00",
    "sat": "08:00-22:00",
    "sun": "08:00-22:00"
  },
  "anchor_image_hash": "sha256-hex-string",
  "certificate_hash": "sha256-hex-string",
  "initial_submission": { /* same shape as submit-place-reference body */ }
}
```

### Response
```json
{
  "place_id": "uuid",
  "status": "pending",
  "pioneer_badge_reserved": true,
  "coverage_required": {
    "unique_submitters": 3,
    "viewpoint_clusters": 3,
    "daytime": true,
    "nighttime": true
  }
}
```

---

## POST /tier2-import

Server-side processing for Tier 2 historical photo import.
Accepts EXIF metadata (NO image bytes). Runs vision matching against place DB.

### Request Body
```json
{
  "photos": [
    {
      "client_id": "local-identifier-string",
      "exif_lat": 37.5665,
      "exif_lng": 126.9780,
      "exif_taken_at": "2024-03-15T14:22:00Z",
      "exif_device": "iPhone 14",
      "embedding_vector": [0.12, -0.34, ...]   // MixVPR 512-dim, computed on device
    }
  ]
}
```

### Response
```json
{
  "results": [
    {
      "client_id": "local-identifier-string",
      "matched": true,
      "place_id": "uuid",
      "place_name": "Gyeongbokgung Palace",
      "confidence": 0.88,
      "suggested_tier": "tier2"
    },
    {
      "client_id": "another-id",
      "matched": false,
      "reason": "no_place_within_radius"
    }
  ]
}
```

---

## GET /feed

Returns paginated feed for the authenticated user.

### Query Parameters
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| cursor | timestamptz | now() | Pagination cursor |
| limit | int | 20 | Max 50 |

### Response
```json
{
  "items": [
    {
      "stamp_id": "uuid",
      "author": { "id": "uuid", "username": "...", "avatar_url": "..." },
      "place": { "id": "uuid", "name": "...", "category": "..." },
      "tier": "tier1",
      "photo_urls": ["..."],
      "caption": "...",
      "sensory_tags": ["coffee_scent", "lively"],
      "like_count": 42,
      "comment_count": 7,
      "is_liked": false,
      "is_saved": false,
      "created_at": "2025-05-22T09:41:00Z"
    }
  ],
  "next_cursor": "2025-05-22T09:30:00Z",
  "has_more": true
}
```

---

## GET /places/nearby

Returns places within radius sorted by distance.

### Query Parameters
| Param | Type | Required | Description |
|-------|------|----------|-------------|
| lat | float | yes | User latitude |
| lng | float | yes | User longitude |
| radius | int | no | Meters, default 500 |
| include_visited | bool | no | Default false |

### Response
```json
{
  "places": [
    {
      "id": "uuid",
      "name": "Blue Bottle Coffee Seongsu",
      "category": "cafe",
      "status": "confirmed",
      "distance_m": 34,
      "has_badge": true,
      "user_visited": false,
      "pending_count": 0
    }
  ]
}
```

---

## POST /backfill-badges

Internal function (service_role only). Called by `check_and_confirm_place`
when a place transitions to `confirmed`. Issues retroactive Pioneer/Founder/Confirmer badges.

### Request Body
```json
{ "place_id": "uuid" }
```

### Response
```json
{
  "badges_issued": [
    { "user_id": "uuid", "badge_type": "pioneer", "badge_id": "uuid" },
    { "user_id": "uuid", "badge_type": "founder", "badge_id": "uuid" }
  ]
}
```
