-- quick size check
SELECT COUNT(*)
FROM editing_panel_clicked;

-- just checking columns + sample rows
SELECT *
FROM editing_panel_clicked
LIMIT 10;

-- building session table
-- Using user + date as session (As no session id in data)

WITH sess AS (
  SELECT
    event_date,
    user_pseudo_id AS uid,
    country,
    version,
    install_source AS src,
    subscription_status_p AS sub_status,
    COUNT(*) AS clicks,
    MIN(event_ts) AS start_ts,
    MAX(event_ts) AS end_ts,
    CAST(
      (julianday(MAX(event_ts)) - julianday(MIN(event_ts))) * 86400
      AS INT
    ) AS dur_sec
  FROM editing_panel_clicked
  GROUP BY
    event_date,
    uid,
    country,
    version,
    src,
    sub_status
)

SELECT *
FROM sess
LIMIT 20;

-- overall bounce
-- bounce = few clicks or very short session

WITH sess AS (
  SELECT
    event_date,
    user_pseudo_id AS uid,
    COUNT(*) AS clicks,
    CAST(
      (julianday(MAX(event_ts)) - julianday(MIN(event_ts))) * 86400
      AS INT
    ) AS dur_sec
  FROM editing_panel_clicked
  GROUP BY
    event_date,
    uid
)

SELECT
  COUNT(*) AS total_sess,
  SUM(
    CASE
      WHEN clicks <= 2 OR dur_sec < 20 THEN 1
      ELSE 0
    END
  ) AS bounce_sess,
  ROUND(
    1.0 * SUM(
      CASE
        WHEN clicks <= 2 OR dur_sec < 20 THEN 1
        ELSE 0
      END
    ) / COUNT(*),
    4
  ) AS bounce_rate
FROM sess;

-- bounce by app version

WITH sess AS (
  SELECT
    event_date,
    user_pseudo_id AS uid,
    version,
    COUNT(*) AS clicks,
    CAST(
      (julianday(MAX(event_ts)) - julianday(MIN(event_ts))) * 86400
      AS INT
    ) AS dur_sec
  FROM editing_panel_clicked
  GROUP BY
    event_date,
    uid,
    version
)

SELECT
  version,
  COUNT(*) AS sess_cnt,
  ROUND(
    1.0 * SUM(
      CASE
        WHEN clicks <= 2 OR dur_sec < 20 THEN 1
        ELSE 0
      END
    ) / COUNT(*),
    4
  ) AS bounce_rate
FROM sess
GROUP BY version
ORDER BY bounce_rate DESC;


-- bounce by country

WITH sess AS (
  SELECT
    event_date,
    user_pseudo_id AS uid,
    country,
    COUNT(*) AS clicks,
    CAST(
      (julianday(MAX(event_ts)) - julianday(MIN(event_ts))) * 86400
      AS INT
    ) AS dur_sec
  FROM editing_panel_clicked
  GROUP BY
    event_date,
    uid,
    country
)

SELECT
  country,
  COUNT(*) AS sess_cnt,
  ROUND(
    1.0 * SUM(
      CASE
        WHEN clicks <= 2 OR dur_sec < 20 THEN 1
        ELSE 0
      END
    ) / COUNT(*),
    4
  ) AS bounce_rate
FROM sess
GROUP BY country
ORDER BY bounce_rate DESC;


-- bounce by install source

WITH sess AS (
  SELECT
    event_date,
    user_pseudo_id AS uid,
    install_source AS src,
    COUNT(*) AS clicks,
    CAST(
      (julianday(MAX(event_ts)) - julianday(MIN(event_ts))) * 86400
      AS INT
    ) AS dur_sec
  FROM editing_panel_clicked
  GROUP BY
    event_date,
    uid,
    src
)

SELECT
  src,
  COUNT(*) AS sess_cnt,
  ROUND(
    1.0 * SUM(
      CASE
        WHEN clicks <= 2 OR dur_sec < 20 THEN 1
        ELSE 0
      END
    ) / COUNT(*),
    4
  ) AS bounce_rate
FROM sess
GROUP BY src
ORDER BY bounce_rate DESC;

-- bounce by subscription status

WITH sess AS (
  SELECT
    event_date,
    user_pseudo_id AS uid,
    subscription_status_p AS sub_status,
    COUNT(*) AS clicks,
    CAST(
      (julianday(MAX(event_ts)) - julianday(MIN(event_ts))) * 86400
      AS INT
    ) AS dur_sec
  FROM editing_panel_clicked
  GROUP BY
    event_date,
    uid,
    sub_status
)

SELECT
  sub_status,
  COUNT(*) AS sess_cnt,
  ROUND(
    1.0 * SUM(
      CASE
        WHEN clicks <= 2 OR dur_sec < 20 THEN 1
        ELSE 0
      END
    ) / COUNT(*),
    4
  ) AS bounce_rate
FROM sess
GROUP BY sub_status
ORDER BY bounce_rate DESC;


-- avg engagement (not required, but useful context)

WITH sess AS (
  SELECT
    event_date,
    user_pseudo_id AS uid,
    COUNT(*) AS clicks,
    CAST(
      (julianday(MAX(event_ts)) - julianday(MIN(event_ts))) * 86400
      AS INT
    ) AS dur_sec
  FROM editing_panel_clicked
  GROUP BY
    event_date,
    uid
)

SELECT
  AVG(clicks) AS avg_clicks,
  AVG(dur_sec) AS avg_dur_sec
FROM sess;
