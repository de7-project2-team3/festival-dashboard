DROP VIEW IF EXISTS public.eventmap_view;

CREATE VIEW public.eventmap_view AS 
SELECT 
    f.event_id,
    f.event_name,
    c.category,
    sd.full_date AS start_date,
    ed.full_date AS end_date,
    TO_CHAR(sd.full_date, 'YYYY-MM') AS start_month,
    TO_CHAR(ed.full_date, 'YYYY-MM') AS end_month,
    s.subject_type,
    l.place_name,
    l.area,
    l.latitude,
    l.longitude
FROM public.fact_event f
LEFT JOIN public.dim_category c ON f.category_key = c.category_key
LEFT JOIN public.dim_date sd ON f.start_date_key = sd.date_key
LEFT JOIN public.dim_date ed ON f.end_date_key = ed.date_key
LEFT JOIN public.dim_subject s ON f.subject_key = s.subject_key
LEFT JOIN public.dim_location l ON f.location_key = l.location_key;