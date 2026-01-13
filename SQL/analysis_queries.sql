/* =========================================================
   Enterprise Asset Management (EAM)
   Analysis Queries
   ---------------------------------------------------------
   Purpose:
   These queries answer operational questions around
   maintenance risk, backlog pressure, reliability, downtime,
   cost drivers, and work order efficiency.
   ========================================================= */

USE eam_transit;

------------------------------------------------------------
-- 1) Top 10 assets by downtime (risk list)
------------------------------------------------------------
SELECT
  asset_id,
  asset_type,
  location_name,
  downtime_hours,
  failure_count,
  maintenance_cost_usd
FROM v_asset_health
ORDER BY downtime_hours DESC
LIMIT 10;

------------------------------------------------------------
-- 2) Backlog by priority
------------------------------------------------------------
SELECT
  priority,
  COUNT(*) AS backlog_work_orders
FROM v_work_orders_clean
WHERE status = 'Backlog'
  AND priority IS NOT NULL
GROUP BY priority
ORDER BY backlog_work_orders DESC;

------------------------------------------------------------
-- 3) Backlog hotspots by location (Top 10)
------------------------------------------------------------
SELECT
  l.location_name,
  COUNT(*) AS backlog_work_orders
FROM v_work_orders_clean w
JOIN locations l
  ON l.location_id = w.location_id
WHERE w.status = 'Backlog'
GROUP BY l.location_name
ORDER BY backlog_work_orders DESC
LIMIT 10;

------------------------------------------------------------
-- 4) Failures by asset type (reliability drivers)
------------------------------------------------------------
SELECT
  asset_type,
  SUM(failure_count) AS total_failures,
  ROUND(AVG(failure_count), 2) AS avg_failures_per_asset
FROM v_asset_health
GROUP BY asset_type
ORDER BY total_failures DESC;

------------------------------------------------------------
-- 5) Downtime share by borough
------------------------------------------------------------
SELECT
  borough,
  SUM(downtime_hours) AS total_downtime_hours,
  ROUND(
    100 * SUM(downtime_hours)
    / (SELECT SUM(downtime_hours) FROM v_asset_health),
    2
  ) AS pct_of_total_downtime
FROM v_asset_health
GROUP BY borough
ORDER BY total_downtime_hours DESC;

------------------------------------------------------------
-- 6) Maintenance cost drivers by asset type
------------------------------------------------------------
SELECT
  asset_type,
  SUM(maintenance_cost_usd) AS total_maintenance_cost,
  ROUND(AVG(maintenance_cost_usd), 2) AS avg_cost_per_asset
FROM v_asset_health
GROUP BY asset_type
ORDER BY total_maintenance_cost DESC;

------------------------------------------------------------
-- 7) Work order cycle time (completed work only)
------------------------------------------------------------
SELECT
  status,
  ROUND(AVG(cycle_time_hours), 2) AS avg_cycle_time_hours,
  COUNT(*) AS work_orders
FROM v_work_orders_clean
WHERE cycle_time_hours IS NOT NULL
  AND status = 'Closed'
GROUP BY status;

