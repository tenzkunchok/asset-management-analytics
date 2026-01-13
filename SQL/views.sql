-- =====================================================
-- Enterprise Asset Management (EAM)
-- SQL Views for Analysis and Tableau
-- =====================================================

-- Clean work orders view
CREATE OR REPLACE VIEW v_work_orders_clean AS
SELECT
  wo.work_order_id,
  wo.asset_id,
  wo.location_id,
  wo.status,
  wo.priority,
  wo.created_at,
  wo.completed_at,
  wo.labor_cost_usd,
  wo.parts_cost_usd,
  wo.total_cost_usd,
  TIMESTAMPDIFF(HOUR, wo.created_at, wo.completed_at) AS cycle_time_hours
FROM work_orders wo;

-- Asset health summary view
CREATE OR REPLACE VIEW v_asset_health AS
SELECT
  a.asset_id,
  a.asset_type,
  l.location_name,
  l.borough,
  COUNT(fe.failure_id) AS failure_count,
  SUM(fe.downtime_hours) AS downtime_hours,
  SUM(wo.total_cost_usd) AS maintenance_cost_usd
FROM assets a
LEFT JOIN locations l ON l.location_id = a.location_id
LEFT JOIN failure_events fe ON fe.asset_id = a.asset_id
LEFT JOIN work_orders wo ON wo.asset_id = a.asset_id
GROUP BY
  a.asset_id,
  a.asset_type,
  l.location_name,
  l.borough;

