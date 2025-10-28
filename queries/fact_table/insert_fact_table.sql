BEGIN;

INSERT INTO public.fact_event (
    event_id, event_name, detail_url,
    start_date_key, end_date_key, registered_date_key,
    location_key, category_key, payment_key, org_key, subject_key
)
SELECT
    s.event_id,
    s.event_name,
    s.detail_url,
    COALESCE(dd_start.date_key, 0) AS start_date_key,
    COALESCE(dd_end.date_key, 0)   AS end_date_key,
    COALESCE(dd_reg.date_key, 0)   AS registered_date_key,
    dl.location_key,
    COALESCE(dc.category_key, 0)   AS category_key,
    COALESCE(dp.payment_key, 0)    AS payment_key,
    COALESCE(dorg.org_key, 0)        AS org_key,
    COALESCE(ds.subject_key, 0)    AS subject_key
FROM public.staging_events s
LEFT JOIN dim_date        dd_start ON dd_start.full_date = s.start_date::date
LEFT JOIN dim_date        dd_end   ON dd_end.full_date   = s.end_date::date
LEFT JOIN dim_date        dd_reg   ON dd_reg.full_date   = s.registered_date::date
LEFT JOIN dim_location    dl       ON dl.place_name = s.place_name
LEFT JOIN dim_category    dc       ON dc.category   = s.category
LEFT JOIN dim_payment     dp       ON dp.pay_type   = s.pay_type
LEFT JOIN dim_organization dorg      ON dorg.organization = s.organization
LEFT JOIN dim_subject     ds       ON ds.subject_type = s.subject
LEFT JOIN public.fact_event f      ON f.event_id = s.event_id
WHERE f.event_id IS NULL              -- 이미 있는 건 제외(중복 방지)
AND s.event_id IS NOT NULL;         -- 안전 가드

COMMIT;