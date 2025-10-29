CREATE OR REPLACE VIEW public.v_quarterly_category_trends AS
SELECT 
    dd.year,
    CASE 
        WHEN dd.month IN (1, 2, 3) THEN 1
        WHEN dd.month IN (4, 5, 6) THEN 2
        WHEN dd.month IN (7, 8, 9) THEN 3
        ELSE 4
    END AS quarter,
    dd.year || '-Q' || 
    CASE 
        WHEN dd.month IN (1, 2, 3) THEN 1
        WHEN dd.month IN (4, 5, 6) THEN 2
        WHEN dd.month IN (7, 8, 9) THEN 3
        ELSE 4
    END AS year_quarter,
    COALESCE(dc.category, 'Unknown') AS category,
    COUNT(DISTINCT f.event_id) AS event_count
FROM public.fact_event f
JOIN public.dim_date dd ON f.start_date_key = dd.date_key
LEFT JOIN public.dim_category dc ON f.category_key = dc.category_key
WHERE dd.year >= 2019
GROUP BY 
    dd.year, 
    CASE 
        WHEN dd.month IN (1, 2, 3) THEN 1
        WHEN dd.month IN (4, 5, 6) THEN 2
        WHEN dd.month IN (7, 8, 9) THEN 3
        ELSE 4
    END,
    dd.year || '-Q' || 
    CASE 
        WHEN dd.month IN (1, 2, 3) THEN 1
        WHEN dd.month IN (4, 5, 6) THEN 2
        WHEN dd.month IN (7, 8, 9) THEN 3
        ELSE 4
    END,
    dc.category
ORDER BY dd.year, quarter, event_count DESC;

