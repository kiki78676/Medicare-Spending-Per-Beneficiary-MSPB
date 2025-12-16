USE Medicare_Hospital_db
SELECT *
FROM dbo.mspb_clean

ALTER TABLE dbo.mspb_clean
DROP COLUMN Footnote;

SELECT
COUNT(*) as total_rows,
count(DISTINCT Score) as  unique_scores,
MIN(Score) as minimum_score,
MAX(score) as maximum_score,
AVG(CAST(Score AS Float)) as avg_score
FROM dbo.mspb_clean

SELECT * FROM dbo.Hospital_General_Information

CREATE OR ALTER VIEW dbo.v_mspb_base AS
SELECT
  CAST([Facility ID] AS varchar(20)) AS facility_id,
  [Facility Name] AS facility_name,
  [City/Town] AS city,
  [State] AS state,
  TRY_CONVERT(float, [Score]) AS mspb_score,
  TRY_CONVERT(date, [Start Date]) AS start_date,
  TRY_CONVERT(date, [End Date]) AS end_date
FROM dbo.mspb_clean;
GO

SELECT *
FROM dbo.v_mspb_base

SELECT facility_id, COUNT(*) AS cnt
FROM dbo.v_mspb_base
GROUP BY facility_id
HAVING COUNT(*) > 1;

CREATE OR ALTER VIEW dbo.V_mspb_features AS
SELECT facility_id,
facility_name,
city,
state,
mspb_score,
 -- Spending vs national average (%)
ROUND(((mspb_score-1.0) * 100),2) AS pct_vs_national,
 -- Efficiency / cost tier
CASE 
WHEN mspb_score >=1.05 THEN 'HIGH COST (>=1.05)'
WHEN mspb_score >=0.95 THEN 'AVERAGE (0.95-1.04)'
 ELSE 'LOW COST (<0.95)'
END AS efficiency_tier,
  -- Simple flag: above/below national average
 CASE
    WHEN mspb_score > 1.0 THEN 'Above'
    WHEN mspb_score < 1.0 THEN 'Below'
    ELSE 'No different'
  END AS compared_to_national
FROM dbo.v_mspb_base;
GO

SELECT *
FROM dbo.v_mspb_features;


--KPI Summary (cards)
CREATE OR ALTER VIEW dbo.v_mspb_kpis AS
SELECT
  COUNT(*) AS total_facilities,
  ROUND(AVG(mspb_score),2) AS avg_mspb,
  MIN(mspb_score) AS min_mspb,
  MAX(mspb_score) AS max_mspb,
  SUM(CASE WHEN mspb_score > 1 THEN 1 ELSE 0 END) AS above_1,
  SUM(CASE WHEN mspb_score < 1 THEN 1 ELSE 0 END) AS below_1,
  SUM(CASE WHEN mspb_score = 1 THEN 1 ELSE 0 END) AS equal_1
FROM dbo.v_mspb_features;
GO

--Regional variation (State aggregation)
CREATE OR ALTER VIEW dbo.v_mspb_by_state AS
SELECT
state,
COUNT(*) AS num_facilities,
ROUND(AVG(mspb_score),2) AS avg_mspb,
ROUND(AVG(pct_vs_national),2) AS avg_pct_vs_national,
MIN(mspb_score) AS min_mspb,
MAX(mspb_score) AS max_mspb
FROM dbo.v_mspb_features
GROUP BY state;
GO

--Efficiency tier breakdown (for stacked bars)
CREATE OR ALTER VIEW  dbo.v_mspb_tier_counts  AS
SELECT
state,
efficiency_tier,
COUNT(*) as facilities
FROM dbo.v_mspb_features
GROUP BY state,efficiency_tier
GO


--Top/Bottom 20 hospitals (ranking tables)
CREATE OR ALTER VIEW dbo.v_mspb_top20_high AS
SELECT TOP 20
facility_id,
facility_name,
city, 
state, 
mspb_score, 
pct_vs_national, 
efficiency_tier
FROM dbo.v_mspb_features
ORDER BY mspb_score DESC;
GO

CREATE OR ALTER VIEW dbo.v_mspb_top20_low AS
SELECT TOP 20
  facility_id, 
  facility_name, 
  city, 
  state, 
  mspb_score, 
  pct_vs_national, 
  efficiency_tier
FROM dbo.v_mspb_features
ORDER BY mspb_score ASC;
GO

--Add Hospital General Info + Outcomes

SELECT * FROM dbo.Hospital_General_Information

SELECT * FROM dbo.V_mspb_features

CREATE OR ALTER VIEW dbo.v_hgi_dedup AS
WITH x AS (
  SELECT
    CAST([Facility ID] AS varchar(20)) AS facility_id,
    [Hospital Type] AS hospital_type,
    [Hospital Ownership] AS hospital_ownership,
    [Emergency Services] AS emergency_services,
    TRY_CONVERT(int, [Hospital overall rating]) AS overall_rating,
    ROW_NUMBER() OVER (
      PARTITION BY CAST([Facility ID] AS varchar(20))
      ORDER BY [Facility Name] 
    ) AS rn
  FROM dbo.Hospital_General_Information
)
SELECT
  facility_id,
  hospital_type, 
  hospital_ownership, 
  emergency_services, 
  overall_rating
FROM x
WHERE rn = 1;
GO

--JOINED TABLE
CREATE OR ALTER VIEW dbo.v_hgi_dedup_clean AS
WITH x AS(
SELECT 
f.*,
d.hospital_type,
d.emergency_services,
d.hospital_ownership,
d.overall_rating
FROM dbo.v_mspb_features f
LEFT JOIN dbo.v_hgi_dedup d
ON f.facility_id = d.facility_id
)
SELECT
facility_id,
facility_name,
city,
state,
mspb_score,
pct_vs_national,
efficiency_tier,
compared_to_national,
hospital_ownership,
COALESCE(hospital_type,'Acute Care Hospitals') AS hospital_type,
COALESCE(emergency_services,'No') AS emergency_services,
overall_rating
FROM x
GO

--BY Rating
CREATE OR ALTER VIEW dbo.v_mspb_by_rating AS
SELECT
  overall_rating,
  COUNT(*) AS facilities,
  ROUND(AVG(mspb_score),2) AS avg_mspb,
  ROUND(AVG(pct_vs_national),2) AS avg_pct_vs_national
FROM dbo.v_hgi_dedup_clean
WHERE overall_rating IS NOT NULL
GROUP BY overall_rating
GO



SELECT * FROM dbo.v_hgi_dedup_clean

--BY OWNERSHIP
CREATE OR ALTER VIEW dbo.v_mspb_by_ownership AS
SELECT
  hospital_ownership,
  COUNT(*) AS facilities,
  ROUND(AVG(mspb_score),2) AS avg_mspb,
  ROUND(AVG(pct_vs_national),2) AS avg_pct_vs_national
FROM dbo.v_hgi_dedup_clean
WHERE hospital_ownership IS NOT NULL
GROUP BY hospital_ownership;
GO



