SELECT 
    dd.year,
    dd.quarter,
    dd.year || '-Q' || dd.quarter AS year_quarter,
    COALESCE(dc.category, 'Unknown') AS category,
    COUNT(DISTINCT f.event_id) AS event_count
FROM public.fact_event f
JOIN public.dim_date dd ON f.start_date_key = dd.date_key
LEFT JOIN public.dim_category dc ON f.category_key = dc.category_key
WHERE dd.year >= 2019
GROUP BY dd.year, dd.quarter, dd.year || '-' || dd.quarter, dc.category
ORDER BY dd.year, dd.quarter, event_count DESC;