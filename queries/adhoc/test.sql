-- select * from public.staging_events limit 10
SELECT
    column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'fact_event'
ORDER BY ordinal_position;