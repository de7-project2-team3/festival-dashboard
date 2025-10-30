CREATE OR REPLACE VIEW public.v_seasonal_event_trends AS
SELECT 
    dd.year,
    CASE 
        WHEN dd.month IN (3, 4, 5) THEN 'Spring'
        WHEN dd.month IN (6, 7, 8) THEN 'Summer'
        WHEN dd.month IN (9, 10, 11) THEN 'Fall'
        ELSE 'Winter'
    END AS season,
    COUNT(DISTINCT f.event_id) AS event_count,
    COUNT(DISTINCT CASE WHEN dp.pay_type = 'Free' THEN f.event_id END) AS free_event_count,
    COUNT(DISTINCT CASE WHEN dp.pay_type != 'Free' THEN f.event_id END) AS paid_event_count,
    COUNT(DISTINCT dc.category) AS category_count
FROM public.fact_event f
JOIN public.dim_date dd ON f.start_date_key = dd.date_key
LEFT JOIN public.dim_payment dp ON f.payment_key = dp.payment_key
LEFT JOIN public.dim_category dc ON f.category_key = dc.category_key
WHERE dd.year >= 2019
GROUP BY 
    dd.year, 
    CASE 
        WHEN dd.month IN (3, 4, 5) THEN 'Spring'
        WHEN dd.month IN (6, 7, 8) THEN 'Summer'
        WHEN dd.month IN (9, 10, 11) THEN 'Fall'
        ELSE 'Winter'
    END
ORDER BY dd.year, season;