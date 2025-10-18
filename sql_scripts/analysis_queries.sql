-- ##############################################################
-- ##### HACKER NEWS ENGAGEMENT ANALYSIS - SQL QUERIES      #####
-- ##############################################################

-- This file contains the SQL queries used for the Hacker News trend analysis.
-- It demonstrates data exploration, aggregation, and the use of advanced
-- SQL (CTEs and Window Functions) to answer complex, layered questions.


-- ********************************************************************
-- Query 1: Find the best hour to post (Average Score by Hour)
-- This query checks which hour of the day yields the highest average score.
-- It uses the corrected `timestamp` and `by` columns.
-- ********************************************************************

SELECT
  EXTRACT(HOUR FROM timestamp) AS hour_of_day,
  ROUND(AVG(score), 2) AS average_score,
  COUNT(*) AS num_stories
FROM
  `bigquery-public-data.hacker_news.full`
WHERE
  type = 'story'
  AND score > 0
  AND `by` IS NOT NULL
GROUP BY
  hour_of_day
ORDER BY
  average_score DESC;


-- ********************************************************************
-- Query 2: Top 10 authors by total score
-- This identifies the most influential authors on the platform by
-- summing their total score. It aliases `by` as `author` for clarity.
-- ********************************************************************

SELECT
  `by` AS author,
  SUM(score) AS total_score,
  COUNT(*) AS total_stories
FROM
  `bigquery-public-data.hacker_news.full`
WHERE
  type = 'story'
  AND `by` IS NOT NULL
GROUP BY
  author
ORDER BY
  total_score DESC
LIMIT 10;


-- ********************************************************************
-- Query 3: Advanced Analysis (Top 3 posts for each top 10 author)
-- This query uses Common Table Expressions (CTEs) and a Window Function (RANK())
-- to find the top 3 performing posts for each of the top 10 authors.
-- This answers a much more complex question than a simple GROUP BY.
-- ********************************************************************

-- CTE 1: Find the top 10 authors by total score
WITH TopAuthors AS (
  SELECT
    `by` AS author,
    SUM(score) AS total_score
  FROM
    `bigquery-public-data.hacker_news.full`
  WHERE
    type = 'story' AND `by` IS NOT NULL
  GROUP BY
    author
  ORDER BY
    total_score DESC
  LIMIT 10
),

-- CTE 2: Rank all stories by those top authors.
RankedStories AS (
  SELECT
    h.`by` AS author,
    h.title,
    h.score,
    -- This Window Function ranks posts *within* each author's group
    RANK() OVER (PARTITION BY h.`by` ORDER BY h.score DESC) AS post_rank
  FROM
    `bigquery-public-data.hacker_news.full` AS h
  INNER JOIN
    TopAuthors AS t ON h.`by` = t.author -- Join full table with our Top 10 list
  WHERE
    h.type = 'story'
)

-- Final SELECT: Choose only the posts ranked 1, 2, or 3.
SELECT
  author,
  title,
  score,
  post_rank
FROM
  RankedStories
WHERE
  post_rank <= 3
ORDER BY
  author,
  post_rank;


-- ********************************************************************
-- Query 4: Create the final, cleaned view for the Looker Studio Dashboard.
-- This view pre-processes the data:
-- 1. Filters for 'story' types with a score > 0 and a valid author
-- 2. Aliases the confusing `by` column to `author` for Looker Studio
-- 3. Extracts the hour from the `timestamp` for the time-series chart
-- NOTE: You must replace `your-project-id.your_dataset_name`
-- ********************************************************************

CREATE OR REPLACE VIEW `your-project-id.your_dataset_name.hacker_news_stories_view` AS (
  SELECT
    `by` AS author,
    score,
    title,
    timestamp,
    EXTRACT(HOUR FROM timestamp) AS hour_of_day
  FROM
    `bigquery-public-data.hacker_news.full`
  WHERE
    type = 'story'
    AND score > 0
    AND `by` IS NOT NULL
);
