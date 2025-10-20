# Hacker News Content and Engagement Analysis

## Project Overview
This project analyzes data from Hacker News to understand the factors that contribute to a story's success. The analysis identifies top authors, determines the optimal time to post for engagement, and ranks top-performing stories.

This project showcases advanced SQL skills, including Common Table Expressions (CTEs) and Window Functions (`RANK()`), to perform sophisticated ranking and aggregation.

## Tools Used
- **Google BigQuery:** For advanced SQL analysis.
- **Looker Studio:** For dashboarding.
- **SQL:** Featuring CTEs and Window Functions.

## Key Findings
- **Optimal Posting Time:** The analysis of average score by hour revealed that the most successful stories are typically posted in the morning, between 8 AM and 10 AM.
- **Top Authors:** The dashboard identifies the top 10 most influential authors by their total combined score, showing their outsized impact on the platform.
- **Top Content:** A table of the highest-scoring posts of all time reveals the types of content that resonate most with the community.

## Data Source
The data is from the `bigquery-public-data.hacker_news.full` table, which contains all stories, comments, and posts from the platform. The `VIEW` created for this project filtered for 'story' types and cleaned column names (like `by` to `author`) for easier analysis.

## Dashboard
A live, interactive dashboard was built in Looker Studio to present the findings.

**https://lookerstudio.google.com/reporting/34542e5b-e05c-408a-b475-fccd7ce418ab**

## SQL Queries
The SQL script used for all analysis in this project is available in the `sql_scripts` folder. This file demonstrates data exploration, aggregation, and the use of advanced SQL functions like Common Table Expressions (CTEs) and `RANK()` to answer complex questions.

* **[`analysis_queries.sql`](sql_scripts/analysis_queries.sql)**


graph TD
    subgraph Data & Analysis
        Logs[Raw Data: Hacker News Logs] --> BigQuery[BigQuery Dataset]
        Analyst[SecOps Analyst] -- 1. Defines CTEs for Readability --> BigQuery
        Analyst -- 2. Applies Window Functions (RANK(), AVG() OVER(...)) --> BigQuery
        Analyst -- 3. Identifies Outliers from Baseline --> BigQuery
        BigQuery --> Reports[Reports (Top Users, Peak Times, Anomalies)]
    end
