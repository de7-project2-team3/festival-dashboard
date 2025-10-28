CREATE OR REPLACE VIEW public.location_view AS (
SELECT 
    f.event_id,
    f.event_name,
    dc.category,
    dp.pay_type
FROM public.fact_event f
LEFT JOIN public.dim_category dc ON f.category_key = dc.category_key
LEFT JOIN public.dim_payment dp ON f.payment_key = dp.payment_key);