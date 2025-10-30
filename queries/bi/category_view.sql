DROP VIEW IF EXISTS public.category_view;

CREATE VIEW public.category_view AS 
SELECT 
    f.event_id,
    f.event_name,
    c.category,
    sd.full_date AS start_date,
    ed.full_date AS end_date,
    s.subject_type
FROM public.fact_event f
LEFT JOIN public.dim_category c ON f.category_key = c.category_key
LEFT JOIN public.dim_date sd ON f.start_date_key = sd.date_key
LEFT JOIN public.dim_date ed ON f.end_date_key = ed.date_key
LEFT JOIN public.dim_subject s ON f.subject_key = s.subject_key;