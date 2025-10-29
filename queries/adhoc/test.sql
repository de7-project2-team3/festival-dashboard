-- select * from public.staging_events limit 10
-- SELECT
--     has_schema_privilege(current_user, 'public', 'USAGE')  AS can_use_schema,
--     has_schema_privilege(current_user, 'public', 'CREATE') AS can_create_in_schema;

-- SELECT
--     table_schema,
--     table_name,
--     privilege_type
-- FROM information_schema.table_privileges
-- WHERE grantee = current_user
--     AND table_schema = 'public'     -- 필요 시 변경
-- ORDER BY table_schema, table_name, privilege_type;

-- CREATE OR REPLACE VIEW public.zz_test_view AS
-- SELECT 1 AS n;

SELECT c.relname AS object_name,
    CASE 
        WHEN c.relkind = 'r' THEN 'table'
        WHEN c.relkind = 'v' THEN 'view'
    END AS object_type
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
AND c.relkind IN ('r', 'v')
ORDER BY object_type, object_name;

-- DROP VIEW IF EXISTS public.zz_test_view;


-- SELECT current_database(), current_schema(), current_user;
-- SHOW search_path;

-- SELECT 
--     n.nspname AS schema_name,
--     c.relname AS object_name,
--     CASE WHEN c.relkind='r' THEN 'table'
--     WHEN c.relkind='v' THEN 'view' END AS object_type
-- FROM pg_class c
-- JOIN pg_namespace n ON n.oid = c.relnamespace
-- WHERE c.relname = 'location_view';


