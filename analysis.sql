WITH sessions AS (
  SELECT
    event_date,
    user_pseudo_id,
    country,
    version,
    install_source,
    subscription_status_p AS subscription_status,
    COUNT(*) AS click_count,
    CAST(
      (julianday(MAX(event_ts)) - julianday(MIN(event_ts))) * 86400
      AS INTEGER
    ) AS duration_sec
  FROM editing_panel_clicked
  GROUP BY
    event_date,
    user_pseudo_id,
    country,
    version,
    install_source,
    subscription_status
)
SELECT
  COUNT(*) AS total_sessions,
  SUM(
    CASE 
      WHEN click_count <= 2 OR duration_sec < 20 THEN 1 
      ELSE 0 
    END
  ) AS bounce_sessions,
  ROUND(
    1.0 * SUM(
      CASE 
        WHEN click_count <= 2 OR duration_sec < 20 THEN 1 
        ELSE 0 
      END
    ) / COUNT(*),
    4
  ) AS bounce_rate
FROM sessions;
