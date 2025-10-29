CREATE OR REPLACE VIEW public.category_view AS 
SELECT 
    f.event_id,
    f.event_name,
    c.category_key,
    c.category,
    sd.full_date AS start_date,
    ed.full_date AS end_date,
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


-- 분석 쿼리

-- 유형별 행사 수
-- SELECT
--     category_name,
--     COUNT(DISTINCT event_id) AS total_events
-- FROM public.category_view
-- GROUP BY category_name
-- ORDER BY total_events DESC;

-- 유형별 평균 행사 기간
-- SELECT
--     category_name,
--     AVG(end_date - start_date) AS avg_duration_days
-- FROM public.category_view
-- WHERE start_date IS NOT NULL AND end_date IS NOT NULL
-- GROUP BY category_name
-- ORDER BY avg_duration_days DESC;

-- 시민참여형 vs 기관주도형 행사 비율
-- SELECT
--     category_name,
--     SUM(CASE WHEN subject_type = '시민' THEN 1 ELSE 0 END) AS citizen_events,
--     SUM(CASE WHEN subject_type = '기관' THEN 1 ELSE 0 END) AS org_events
-- FROM public.category_view
-- GROUP BY category_name;

-- 지역별 행사 분포 (지도용)
-- SELECT
--     category_name,
--     area,
--     latitude,
--     longitude,
--     COUNT(*) AS event_count
-- FROM public.category_view
-- GROUP BY category_name, area, latitude, longitude;