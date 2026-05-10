-- ============================================
-- DATABASE AND SCHEMA SETUP   (A/B TESTING)
-- ============================================
-- Creating a dedicated database for our A/B testing project
-- This keeps our experiment data organized and separate from other projects

CREATE DATABASE ab_testing_db;

-- Switching to the newly created database
USE DATABASE ab_testing_db;

-- Creating a schema to organize our tables within the database
CREATE SCHEMA ab_testing_schema;

-- Using A/B testing schema
USE SCHEMA ab_testing_schema;

-- ============================================
-- TABLE CREATION
-- ============================================
-- Creating the main table to store the A/B test results
-- This table will hold all user interaction data from both control and treatment groups
CREATE OR REPLACE TABLE ab_test_results (
    "User ID"     BIGINT,
    "Group"       VARCHAR(20),
    "Page Views"  INT,
    "Time Spent"  INT,
    "Conversion"  BOOLEAN,
    "Device"      VARCHAR(20),
    "Location"    VARCHAR(50)
);

-- ============================================
-- DATA VALIDATION
-- ============================================
-- Quick preview of the first 10 rows to verify data loaded correctly
-- This helps us understand the structure and spot any obvious issues
SELECT * FROM ab_test_results LIMIT 10;

-- Counting total number of records in our dataset
-- Important to ensure all data was imported successfully
SELECT COUNT(*) AS total_rows FROM ab_test_results;


-- ============================================
-- GROUP DISTRIBUTION ANALYSIS
-- ============================================
-- Checking how users are distributed between test groups

SELECT 
    "Group",
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM ab_test_results
GROUP BY "Group";

-- ============================================
-- OVERALL PERFORMANCE BY GROUP
-- ============================================
-- Comparing key metrics between control and treatment groups
-- This gives us a high-level view of which group performed better
-- looking at total users, conversions, and engagement metrics
SELECT 
    "Group",
    COUNT(*) as total_users,
    SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) as conversions,
    ROUND(AVG("Page Views"), 2) as avg_page_views,
    ROUND(AVG("Time Spent"), 2) as avg_time_spent
FROM ab_test_results
GROUP BY "Group";

-- ============================================
-- CONVERSION RATE ANALYSIS
-- ============================================
-- Calculating conversion rates for each group - this is our primary success metric
-- Conversion rate = (number of conversions / total users) × 100
-- This tells us which version of our test was more effective at driving conversions

SELECT 
    "Group",
    COUNT(*) as total_users,
    SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) as conversions,
    ROUND(SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as conversion_rate_percent
FROM ab_test_results
GROUP BY "Group";

-- ============================================
-- DEVICE-SPECIFIC CONVERSION ANALYSIS
-- ============================================
-- Breaking down conversion rates by device type 
-- This helps identify if one group performs better on specific devices
-- Important for understanding if our changes work differently across platforms

SELECT 
    "Group",
    "Device",
    COUNT(*) as total_users,
    SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) as conversions,
    ROUND(SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as conversion_rate_percent
FROM ab_test_results
GROUP BY "Group", "Device"
ORDER BY "Group", "Device";

-- ============================================
-- LOCATION-SPECIFIC CONVERSION ANALYSIS
-- ============================================
-- Analyzing conversion rates across different geographic locations
-- Helps us understand if our test results vary by region
-- Useful for identifying location-specific trends or issues

SELECT 
    "Group",
    "Location",
    COUNT(*) as total_users,
    SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) as conversions,
    ROUND(SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as conversion_rate_percent
FROM ab_test_results
GROUP BY "Group", "Location"
ORDER BY "Group", "Location";

-- ============================================
-- MULTI-DIMENSIONAL CONVERSION ANALYSIS
-- ============================================
-- Examining conversion rates across all combinations of group, device, and location
-- This detailed breakdown helps identify specific segments where one group excels
-- For example: "Group B performs better on Mobile devices in England"
-- Conversion rates by group, device, and location combinations

SELECT 
    "Group",
    "Device",
    "Location",
    COUNT(*) as total_users,
    SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) as conversions,
    ROUND(SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as conversion_rate_percent
FROM ab_test_results
GROUP BY "Group", "Device", "Location"
ORDER BY "Group", "Device", "Location";

-- ============================================
-- PAGE VIEWS DISTRIBUTION ANALYSIS
-- ============================================
-- Calculating statistical distribution of page views for each group
-- Using quartiles (Q25, median, Q75) to understand the spread of data
-- This shows us if one group encourages more page exploration than the other

SELECT 
    "Group",
    MIN("Page Views") as min_page_views,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY "Page Views"), 2) as q25_page_views,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "Page Views"), 2) as median_page_views,
    ROUND(AVG("Page Views"), 2) as avg_page_views,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY "Page Views"), 2) as q75_page_views,
    MAX("Page Views") as max_page_views
FROM ab_test_results
GROUP BY "Group";


-- ============================================
-- TIME SPENT DISTRIBUTION ANALYSIS
-- ============================================
-- Analyzing how time spent on site is distributed across each group
-- Similar to page views, we use statistical measures to understand engagement patterns
-- Higher time spent might indicate better content or more confusion - context matters!

SELECT 
    "Group",
    MIN("Time Spent") as min_time_spent,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY "Time Spent"), 2) as q25_time_spent,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "Time Spent"), 2) as median_time_spent,
    ROUND(AVG("Time Spent"), 2) as avg_time_spent,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY "Time Spent"), 2) as q75_time_spent,
    MAX("Time Spent") as max_time_spent
FROM ab_test_results
GROUP BY "Group";


-- ============================================
-- OUTLIER DETECTION
-- ============================================
-- Identifying unusual behavior patterns that might skew our results
-- Outliers are extreme values that differ significantly from the majority
-- checking for unusually high/low page views and time spent
-- These might represent bots, errors, or genuinely unusual user behavior

SELECT 
    "Group",
    COUNT(CASE WHEN "Page Views" > 12 THEN 1 END) as high_page_view_outliers,
    COUNT(CASE WHEN "Page Views" < 3 THEN 1 END) as low_page_view_outliers,
    COUNT(CASE WHEN "Time Spent" > 400 THEN 1 END) as high_time_outliers,
    COUNT(CASE WHEN "Time Spent" < 100 THEN 1 END) as low_time_outliers
FROM ab_test_results
GROUP BY "Group";


-- ============================================
-- CONVERTER VS NON-CONVERTER BEHAVIOR
-- ============================================
-- Comparing behavior patterns between users who converted and those who didn't
-- This helps us understand what actions lead to conversions
-- Behavioral patterns of converters vs non-converters

SELECT 
    "Group",
    "Conversion",
    COUNT(*) as user_count,
    ROUND(AVG("Page Views"), 2) as avg_page_views,
    ROUND(AVG("Time Spent"), 2) as avg_time_spent,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "Page Views"), 2) as median_page_views,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "Time Spent"), 2) as median_time_spent
FROM ab_test_results
GROUP BY "Group", "Conversion"
ORDER BY "Group", "Conversion";


-- ============================================
-- DEVICE PREFERENCES BY CONVERSION STATUS
-- ============================================
-- Analyzing device distribution among converters vs non-converters
-- Helps answer: Do converters prefer certain devices?
-- This can inform device-specific optimization strategies
-- Device distribution for converters vs non-converters

SELECT 
    "Group",
    "Conversion",
    "Device",
    COUNT(*) as user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY "Group", "Conversion"), 2) as percentage
FROM ab_test_results
GROUP BY "Group", "Conversion", "Device"
ORDER BY "Group", "Conversion", "Device";

-- ============================================
-- LOCATION PREFERENCES BY CONVERSION STATUS
-- ============================================
-- Examining geographic distribution of converters vs non-converters
-- Identifies if certain locations have higher conversion propensity
-- Useful for targeted marketing or localization efforts
-- Location distribution for converters vs non-converters

SELECT 
    "Group",
    "Conversion",
    "Location",
    COUNT(*) as user_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY "Group", "Conversion"), 2) as percentage
FROM ab_test_results
GROUP BY "Group", "Conversion", "Location"
ORDER BY "Group", "Conversion", "Location";


-- ============================================
-- CONVERSION RATE BY PAGE VIEW COUNT
-- ============================================
-- Analyzing how conversion rate changes with number of pages viewed
-- This reveals the relationship between engagement depth and conversion
-- Question: Does viewing more pages increase likelihood of conversion?
-- Conversion rates by page view count

SELECT 
    "Group",
    "Page Views",
    COUNT(*) as total_users,
    SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) as conversions,
    ROUND(SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as conversion_rate_percent
FROM ab_test_results
GROUP BY "Group", "Page Views"
ORDER BY "Group", "Page Views";


-- ============================================
-- CONVERSION RATE BY TIME SPENT BUCKETS
-- ============================================
-- Grouping users into time-spent categories to analyze conversion patterns
-- Bucketing helps us see trends more clearly than individual time values
-- Insight: Is there an optimal time range that leads to highest conversions?


SELECT 
    "Group",
    CASE 
        WHEN "Time Spent" < 100 THEN '0-99 sec'
        WHEN "Time Spent" < 200 THEN '100-199 sec'
        WHEN "Time Spent" < 300 THEN '200-299 sec'
        WHEN "Time Spent" < 400 THEN '300-399 sec'
        ELSE '400+ sec'
    END as time_bucket,
    COUNT(*) as total_users,
    SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) as conversions,
    ROUND(SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as conversion_rate_percent
FROM ab_test_results
GROUP BY "Group", time_bucket
ORDER BY "Group", time_bucket;


-- ============================================
-- USER ENGAGEMENT SEGMENTATION
-- ============================================
-- Categorizing users into engagement levels based on page views
-- Light Users (≤5 pages): Casual browsers
-- Medium Users (6-10 pages): Moderately engaged
-- Heavy Users (>10 pages): Highly engaged explorers
-- This segmentation helps us understand which user types each group attracts
-- and which segments convert best


SELECT 
    "Group",
    CASE 
        WHEN "Page Views" <= 5 THEN 'Light Users'
        WHEN "Page Views" <= 10 THEN 'Medium Users'
        ELSE 'Heavy Users'
    END as user_segment,
    COUNT(*) as total_users,
    SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) as conversions,
    ROUND(SUM(CASE WHEN "Conversion" = true THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as conversion_rate_percent,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY "Group"), 2) as segment_size_percent
FROM ab_test_results
GROUP BY "Group", user_segment
ORDER BY "Group", user_segment;