BEGIN;

CREATE TEMP TABLE resolved AS (
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
) 

MERGE INTO public.fact_event AS f
USING resolved AS r
    ON f.event_id = r.event_id
WHEN MATCHED THEN UPDATE SET
    event_name          = r.event_name,
    detail_url          = r.detail_url,
    start_date_key      = r.start_date_key,
    end_date_key        = r.end_date_key,
    registered_date_key = r.registered_date_key,
    location_key        = r.location_key,
    category_key        = r.category_key,
    payment_key         = r.payment_key,
    org_key             = r.org_key,
    subject_key         = r.subject_key
WHEN NOT MATCHED THEN INSERT (
    event_id, event_name, detail_url,
    start_date_key, end_date_key, registered_date_key,
    location_key, category_key, payment_key, org_key, subject_key
) VALUES (
    r.event_id, r.event_name, r.detail_url,
    r.start_date_key, r.end_date_key, r.registered_date_key,
    r.location_key, r.category_key, r.payment_key, r.org_key, r.subject_key
);

DROP TABLE resolved;

COMMIT;