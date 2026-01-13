## Top 10 assets by downtime (risk list)
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
<img width="650" height="210" alt="Screenshot 2026-01-12 at 7 29 19 PM" src="https://github.com/user-attachments/assets/bf4c86da-37ca-47ab-8fa1-444726e69856" />

## Backlog by priority
SELECT
  priority,
  COUNT(*) AS backlog_work_orders
FROM v_work_orders_clean
WHERE status = 'Backlog'
GROUP BY priority
ORDER BY backlog_work_orders DESC;
<img width="201" height="120" alt="Screenshot 2026-01-12 at 7 29 59 PM" src="https://github.com/user-attachments/assets/cec4bac4-f5e6-42b4-b736-f8a56e7ba6e8" />

# Backlog hotspots by location
SELECT
  l.location_name,
  COUNT(*) AS backlog_work_orders
FROM v_work_orders_clean w
JOIN locations l ON l.location_id = w.location_id
WHERE w.status = 'Backlog'
GROUP BY l.location_name
ORDER BY backlog_work_orders DESC
LIMIT 10;
<img width="325" height="410" alt="Screenshot 2026-01-12 at 9 10 18 PM" src="https://github.com/user-attachments/assets/5fabb526-5cfb-4db2-9b76-356bcb4bbc1c" />


# Failures by asset type (where reliability problems live)
SELECT
  asset_type,
  SUM(failure_count) AS total_failures,
  ROUND(AVG(failure_count), 2) AS avg_failures_per_asset
FROM v_asset_health
GROUP BY asset_type
ORDER BY total_failures DESC;
<img width="312" height="155" alt="Screenshot 2026-01-12 at 7 33 11 PM" src="https://github.com/user-attachments/assets/40e9da75-7bfe-4c74-9eeb-f02269dab004" />

# Downtime share by borough
SELECT
  borough,
  SUM(downtime_hours) AS total_downtime_hours,
  ROUND(100 * SUM(downtime_hours) / (SELECT SUM(downtime_hours) FROM v_asset_health), 2) AS pct_of_total
FROM v_asset_health
GROUP BY borough
ORDER BY total_downtime_hours DESC;
<img width="349" height="151" alt="Screenshot 2026-01-12 at 7 35 46 PM" src="https://github.com/user-attachments/assets/35982232-966f-4b21-80ba-1faadf331a44" />

# Cost drivers: maintenance cost by asset type
SELECT
  asset_type,
  SUM(maintenance_cost_usd) AS total_maintenance_cost,
  ROUND(AVG(maintenance_cost_usd), 2) AS avg_cost_per_asset
FROM v_asset_health
GROUP BY asset_type
ORDER BY total_maintenance_cost DESC;
<img width="452" height="180" alt="Screenshot 2026-01-12 at 7 37 03 PM" src="https://github.com/user-attachments/assets/db5da764-96c3-4ae2-a0d6-dc21917bc8d7" />

# Work order cycle time (how long work takes)
SELECT
  status,
  ROUND(AVG(cycle_time_hours), 2) AS avg_cycle_time_hours,
  COUNT(*) AS work_orders
  <img width="326" height="101" alt="Screenshot 2026-01-12 at 9 13 21 PM" src="https://github.com/user-attachments/assets/ef9fe31c-9727-48dc-a88d-6f60e5fa8bbb" />

