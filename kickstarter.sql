-- database: ./kickstarter.db

-- QUESTION: Of the Kickstarter categories with highly successful campaigns, what seems more important—lots of backers, higher individual contributions, or both?

-- removing nulls and empty entries 
DELETE FROM ksprojects 
WHERE COALESCE (name, category, main_category, deadline, launched, backers, state, usd_pledged_real, usd_goal_real) IS NULL;

DELETE from ksprojects
WHERE name = "" or goal == 0;




--total campaigns
SELECT
  main_category,
  COUNT(*)
FROM ksprojects
GROUP BY main_category
ORDER BY COUNT(*);


-- largest percent succeeded categories
SELECT  
  main_category, 
  COUNT(CASE WHEN state='successful' THEN 1 END) AS num_succeeded, 
  COUNT(CASE WHEN state='successful' THEN 1 END)*100.0/COUNT(*) AS pct_succeeded, 
  COUNT(CASE WHEN state='canceled' THEN 1 END)*100.0/COUNT(*) AS pct_canceled, 
  COUNT(CASE WHEN state='failed' THEN 1 END)*100.0/COUNT(*) AS pct_failed
FROM ksprojects
GROUP BY main_category
ORDER BY pct_succeeded; 
-- includes percentages for failed and canceled campaigns as well for visualizing the ratio of project states in one bar graph 


--average percent of goal funded for categories with high success rates
SELECT 
  main_category, 
  COUNT(CASE WHEN state='successful' THEN 1 END) AS num_succeeded, 
  COUNT(CASE WHEN state='successful' THEN 1 END)*100.0/COUNT(*) AS pct_succeeded, 
  AVG(
    CASE 
        WHEN state = 'successful'
        THEN usd_pledged_real / NULLIF(usd_goal_real, 0)
    END
  )*100.0 AS avg_pct_funded
FROM ksprojects
GROUP BY main_category
HAVING COUNT(*) >= 50
ORDER BY avg_pct_funded DESC;


--median number of backers, ordered by largest amount
--it is median rather than average to account for large outliers
WITH ranked AS (
  SELECT
    main_category,
    backers,
    ROW_NUMBER() OVER (
      PARTITION BY main_category
      ORDER BY backers
    ) AS rn,
    COUNT(*) OVER (
      PARTITION BY main_category
    ) AS cnt
    FROM ksprojects
    WHERE backers IS NOT NULL
)
SELECT
  main_category,
  ROUND(AVG(backers), 0) AS median_backers
FROM ranked
WHERE rn IN (
  (cnt + 1) / 2,
  (cnt + 2) / 2
)
GROUP BY main_category
ORDER BY median_backers DESC;



--average percent of goal funded for categories with high failure rates
SELECT  
  main_category, 
  COUNT(CASE WHEN state='failed' THEN 1 END) AS num_failed, 
  COUNT(CASE WHEN state='failed' THEN 1 END)*100.0/COUNT(*) AS pct_failed, 
  AVG(
    CASE 
      WHEN state = 'failed'
      THEN usd_pledged_real / NULLIF(usd_goal_real, 0)
    END
  )*100.0 AS avg_pct_funded
FROM ksprojects
GROUP BY main_category
HAVING COUNT(*) >= 50
ORDER BY pct_failed DESC;

--comparing successful and failed campaigns and the average percent of the goal they reached
SELECT
    main_category,
    state,
    COUNT(*) AS num_campaigns,
    ROUND(AVG(backers), 0) AS avg_backers,
    ROUND(AVG(usd_pledged_real), 2) AS avg_pledged,
    ROUND(
        AVG(usd_pledged_real / NULLIF(usd_goal_real, 0)) * 100,
        2
    ) AS avg_pct_goal
FROM ksprojects
WHERE state IN ('successful', 'failed')
GROUP BY main_category, state
ORDER BY main_category, state;



-- average pledged, backers, pledged per backer, and campaign length for categories for the largest average pledged amounts
SELECT 
  main_category, 
  ROUND(AVG(usd_pledged_real), 2) AS avg_pledged, 
  ROUND(AVG(backers), 0) AS avg_backers, 
  ROUND(AVG(usd_pledged_real/NULLIF(backers, 0)), 2) AS avg_pledged_per_backer,
  ROUND(AVG(julianday(deadline)-julianday(launched))) AS campaign_length
FROM ksprojects
GROUP BY main_category
ORDER BY avg_pledged DESC;
