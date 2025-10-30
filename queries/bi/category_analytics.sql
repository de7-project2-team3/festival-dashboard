-- Superset -> SQL Lab을 통해 데이터셋 저장한 후 -> 이를 바탕으로 차트 생성

-- 유형별 행사 수
SELECT
    category,
    COUNT(DISTINCT event_id) AS category_events_cnt
FROM public.category_view
GROUP BY category
ORDER BY category_events_cnt DESC;

-- 유형별 평균 행사 기간
SELECT
    category,
    (end_date - start_date + 1) AS duration_days
FROM public.category_view
WHERE start_date IS NOT NULL
    AND end_date IS NOT NULL
    AND end_date >= start_date;

-- 유형별 시민참여형 vs 기관주도형 행사 비율
SELECT
    category,
    subject_type,
    COUNT(DISTINCT event_id) AS events_cnt
FROM public.category_view
WHERE subject_type IN ('시민','기관')
GROUP BY category, subject_type;