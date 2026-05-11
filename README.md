[![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)](https://www.snowflake.com)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org)
[![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=tableau&logoColor=white)](https://public.tableau.com)
[![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.snowflake.com)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Mohd-Shabir)

# A/B Testing Analysis: Snowflake · SQL · Python · Tableau

An end-to-end A/B testing project analyzing the impact of a new webpage design on user conversion rates. The analysis covers data storage and querying in Snowflake, statistical significance testing in Python, and interactive dashboard visualization in Tableau.

**Key Finding:** The new webpage design (Group B) achieved a **14.07% conversion rate** vs **5.40% for the original design (Group A)** — a **160.5% relative improvement** with extremely high statistical significance (p < 0.001).

---

## Table of Contents

- [Project Overview](#project-overview)
- [Tools & Technologies](#tools--technologies)
- [Dataset](#dataset)
- [Project Structure](#project-structure)
- [Analysis Workflow](#analysis-workflow)
  - [Step 1: SQL Analysis in Snowflake](#step-1-sql-analysis-in-snowflake)
  - [Step 2: Statistical Testing in Python](#step-2-statistical-testing-in-python)
  - [Step 3: Visualization in Tableau](#step-3-visualization-in-tableau)
- [Key Results](#key-results)
- [Business Impact](#business-impact)
- [Final Recommendation](#final-recommendation)
- [How to Run This Project](#how-to-run-this-project)
- [Key Learnings](#key-learnings)

---

## Project Overview

A company wanted to know if their new webpage design would convert more visitors than their current design. Instead of just launching it and hoping for the best, they ran a proper A/B test.

---
**The Approach:**

This project follows a complete data analysis pipeline **entirely within Snowflake**:

1. **SQL in Snowflake** — Store and explore the data, calculate conversion rates across different segments
2. **Python in Snowflake** — Run statistical tests using Snowflake's integrated Python notebooks
3. **Tableau** — Create interactive dashboards to visualize and communicate the findings

Rather than just comparing numbers, i used proper statistical methods to ensure the decision is backed by solid evidence.

All data processing and analysis was done in Snowflake, showcasing the platform's ability to handle both SQL and Python workloads seamlessly.

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| **Snowflake** | Cloud data warehouse for data storage, SQL analysis, **and Python statistical testing** |
| **SQL** | Data validation, aggregation, and segmentation queries |
| **Python (in Snowflake)** | Statistical significance testing and effect size analysis using Snowflake notebooks |
| **SciPy** | Chi-square test and t-tests |
| **Statsmodels** | Confidence intervals for conversion rates |
| **Tableau Public** | Interactive dashboards and data visualization |
| **Git & GitHub** | Version control and project sharing |

---

## Dataset

- **Source:** [Kaggle — A/B Testing Practice](https://www.kaggle.com/datasets/adarsh0806/ab-testing-practice)
- **Size:** 5,000 users
- **Test Groups:** Group A (original design) and Group B (new design)

### Dataset Structure:

| Column | Description |
|---|---|
| User ID | Unique identifier for each user |
| Group | A (original design) or B (new design) |
| Page Views | Number of pages viewed per session |
| Time Spent | Time spent on site in seconds |
| Conversion | Whether the user converted (True/False) |
| Device | Desktop or Mobile |
| Location | England, Scotland, Wales, Northern Ireland |

---



## Project Structure

```
ab-testing-snowflake-sql-python-tableau/
│
├── data/
│   └── ab_testing.csv                          # Raw dataset
│
├── sql/
│   └── ab_testing_analysis.sql                 # All SQL queries
│
├── notebooks/
│   └── ab_testing_statistical_analysis.ipynb   # Python analysis
│
└── visualizations/
    ├── dashboard_overview.pdf                  # Dashboard 1
    └── dashboard_behavior_analysis.pdf         # Dashboard 2
```

---


---

## Analysis Workflow

### Step 1: SQL Analysis in Snowflake

The first step was loading the data into Snowflake and using SQL to explore it from every angle.

#### What We Did:

**Data Setup & Validation**
- Created database, schema, and table in Snowflake
- Validated data quality (checked for nulls, duplicates, data types)
- Confirmed balanced group split: Group A (2,519 users), Group B (2,481 users)

**Overall Conversion Analysis**
- Calculated conversion rates for each group
- Group A: 5.40% (136 conversions)
- Group B: 14.07% (349 conversions)

**Device-Specific Analysis**
- Broke down conversion rates by device type (Desktop vs Mobile)
- Checked if the new design worked better on specific devices

**Location-Specific Analysis**
- Analyzed conversion rates across all four UK regions
- Identified if certain locations responded better to the new design

**User Behavior Analysis**
- Compared page views and time spent between groups
- Analyzed behavior differences between converters and non-converters
- Looked for outliers that might skew results

**User Segmentation**
- Segmented users by engagement level:
  - **Light Users:** ≤5 page views
  - **Medium Users:** 6-10 page views
  - **Heavy Users:** >10 page views
- Analyzed conversion rates for each segment

**Time-Based Analysis**
- Grouped users into time-spent buckets (0-99s, 100-199s, etc.)
- Identified optimal engagement windows for conversions

#### Key SQL Findings:

✅ Group B outperformed Group A by **160.5%**  
✅ Improvement was consistent across **both Desktop and Mobile**  
✅ Improvement was consistent across **all four locations**  
✅ All user segments (Light, Medium, Heavy) showed higher conversion in Group B  
✅ Engagement metrics (page views, time spent) were similar between groups  

---

### Step 2: Statistical Testing in Python (Snowflake Notebooks)

After exploring the data with SQL, used **Python within Snowflake** to answer the critical question: **"Is this difference real, or could it just be random luck?"**

Snowflake's integrated Python notebooks allowed us to run statistical tests directly in the same environment as our data, eliminating the need to export data or switch platforms.

#### Tests Performed:

#### 1. Chi-Square Test
**Purpose:** Test if the conversion rate difference is statistically significant

**Results:**
- Chi-square statistic: **χ² = 106.23**
- P-value: **6.57e-25** (that's 0.0000000000000000000000000657)
- **Conclusion:** ✅ Highly significant (p < 0.001)

**What This Means:**  
There is virtually zero chance this difference happened by random luck. The new design genuinely performs better.

---

#### 2. Confidence Intervals (95%)
**Purpose:** Estimate the range where the true conversion rates likely fall

**Results:**

| Group | Conversion Rate | 95% Confidence Interval |
|-------|----------------|------------------------|
| Group A | 5.40% | 4.58% – 6.35% |
| Group B | 14.07% | 12.75% – 15.49% |
| **Difference** | **+8.67pp** | **7.04pp – 10.30pp** |

**What This Means:**  
Group B’s true conversion rate is estimated to be between 12.75% and 15.49% with 95% confidence. Even at the lower bound (12.75%), it still exceeds Group A’s upper bound (6.35%). Since the confidence intervals do not overlap, the results strongly indicate that Group B performs better.

---

#### 3. Effect Size (Cohen's h)
**Purpose:** Measure how big the difference actually is (not just if it exists)

**Results:**
- Cohen's h: **0.2999**
- **Interpretation:** Between "small" (0.2) and "medium" (0.5) by statistical standards

**What This Means:**  
While the statistical classification is "small-to-medium," the business impact is substantial. A 160% improvement in conversions is highly meaningful regardless of the technical classification.

---

#### 4. T-Tests for Secondary Metrics
**Purpose:** Check if the groups had similar engagement levels (to rule out confounding factors)

**Page Views:**
- Group A average: **7.58 pages**
- Group B average: **7.49 pages**
- Difference: -0.09 pages
- P-value: **0.436**
- **Conclusion:** No significant difference

**Time Spent:**
- Group A average: **241.73 seconds**
- Group B average: **243.30 seconds**
- Difference: +1.57 seconds
- P-value: **0.639**
- **Conclusion:** No significant difference

**What This Means:**  
Both groups browsed the same amount and spent the same time on the site. This confirms the conversion improvement came from better design or messaging, not from tricking users into staying longer or viewing more pages. This is a clean, ethical win.

---

### Step 3: Visualization in Tableau

Created two interactive dashboards in Tableau Public to present the findings visually.

#### Dashboard 1: Test Results Overview
- Headline conversion rate comparison
- Conversion rates by device (Desktop vs Mobile)
- Conversion rates by location (England, Scotland, Wales, Northern Ireland)
- Sample size and group distribution validation

#### Dashboard 2: User Behavior Deep Dive
- Behavioral patterns: converters vs non-converters
- Conversion rates by time spent buckets
- Conversion rates by user engagement segments
- Page views distribution analysis

📊 **[View Dashboard 1 — Test Results Overview](https://public.tableau.com/views/ABTesting_17781793238810/Dashboard1-Overview)**

📊 **[View Dashboard 2 — User Behavior Deep Dive](https://public.tableau.com/views/ABTesting_17781793238810/Dashboard2)**

---

## Key Results

### Overall Performance

| Metric | Group A (Original) | Group B (New Design) | Difference |
|--------|-------------------|---------------------|------------|
| **Conversion Rate** | 5.40% | 14.07% | **+8.67pp** |
| **Total Conversions** | 136 | 349 | **+213** |
| **Total Users** | 2,519 | 2,481 | -38 |

**Relative Improvement: +160.5%**

---

### Statistical Validation

| Test | Result | Interpretation |
|------|--------|----------------|
| **Chi-Square Test** | χ² = 106.23, p = 6.57e-25 | Highly significant |
| **Confidence Interval (A)** | 4.58% – 6.35% | 95% confidence range |
| **Confidence Interval (B)** | 12.75% – 15.49% | 95% confidence range |
| **Effect Size (Cohen's h)** | 0.2999 | Small-to-medium effect |

---

### Performance by Device

| Device | Group A | Group B | Improvement |
|--------|---------|---------|-------------|
| **Desktop** | 5.87% | 13.91% | +8.04pp (+137%) |
| **Mobile** | 4.94% | 14.24% | +9.30pp (+188%) |

✅ Group B won on **both devices**

---

### Performance by Location

| Location | Group A | Group B | Improvement |
|----------|---------|---------|-------------|
| **England** | 6.93% | 14.69% | +7.76pp (+112%) |
| **Northern Ireland** | 5.05% | 11.46% | +6.41pp (+127%) |
| **Scotland** | 4.93% | 15.06% | +10.13pp (+205%) |
| **Wales** | 4.77% | 15.12% | +10.35pp (+217%) |

✅ Group B won in **all four locations**

---

### Engagement Metrics (Secondary)

| Metric | Group A | Group B | P-value | Significant? |
|--------|---------|---------|---------|--------------|
| **Avg Page Views** | 7.58 | 7.49 | 0.436 | ❌ No |
| **Avg Time Spent** | 241.73s | 243.30s | 0.639 | ❌ No |

✅ No significant difference in engagement — the conversion lift came from better design, not manipulation

---

### Performance by User Segment

| Segment | Group A | Group B | Improvement |
|---------|---------|---------|-------------|
| **Light Users** (≤5 pages) | 6.21% | 14.14% | +7.93pp (+128%) |
| **Medium Users** (6-10 pages) | 5.44% | 14.78% | +9.34pp (+172%) |
| **Heavy Users** (>10 pages) | 4.40% | 13.01% | +8.61pp (+196%) |

✅ Group B won across **all engagement levels**

---

## Business Impact

### Expected Performance After Implementation

If Group B is rolled out to all users, here's what to expect:

| Scenario | Conversions per 1,000 Visitors | Monthly Conversions (100K visitors) |
|----------|-------------------------------|-------------------------------------|
| **Current (Group A)** | 54 | 5,400 |
| **After Rollout (Group B)** | 141 | 14,070 |
| **Additional Conversions** | **+87** | **+8,670** |

---

### Revenue Impact Example

Assuming an average order value of **$50 per conversion**:

| Metric | Current (Group A) | After Rollout (Group B) | Increase |
|--------|------------------|------------------------|----------|
| **Monthly Conversions** | 5,400 | 14,070 | +8,670 |
| **Monthly Revenue** | $270,000 | $703,500 | **+$433,500** |
| **Annual Revenue** | $3,240,000 | $8,442,000 | **+$5,202,000** |

**Potential annual revenue increase: ~$5.2 million**

*Note: Actual results will vary based on your specific traffic patterns, seasonality, and business model.*

---

## Final Recommendation

### ✅ IMPLEMENT GROUP B (NEW DESIGN)

---

#### 1. Massive Conversion Improvement
- **160.5% relative improvement** (from 5.4% to 14.07%)
- **+8.67 percentage points** absolute improvement
- **213 additional conversions** in the test alone

---

#### 2. Statistically Bulletproof
- **Chi-square test:** p-value = 6.57e-25 (virtually impossible this is random chance)
- **Confidence intervals don't overlap:** Even Group B's worst case beats Group A's best case
- **Effect size:** Cohen's h = 0.2999 (meaningful business impact)

---

#### 3. Universal Success
- ✅ Works on **Desktop** (13.91% vs 5.87%)
- ✅ Works on **Mobile** (14.24% vs 4.94%)
- ✅ Works in **England** (14.69% vs 6.93%)
- ✅ Works in **Northern Ireland** (11.46% vs 5.05%)
- ✅ Works in **Scotland** (15.06% vs 4.93%)
- ✅ Works in **Wales** (15.12% vs 4.77%)
- ✅ Works for **Light Users** (14.14% vs 6.21%)
- ✅ Works for **Medium Users** (14.78% vs 5.44%)
- ✅ Works for **Heavy Users** (13.01% vs 4.40%)

**Group B won in every single segment tested (8 out of 8 combinations)**

---

#### 4. No Negative Side Effects
- Page views: No significant difference (p = 0.436)
- Time spent: No significant difference (p = 0.639)
- Users aren't being manipulated into longer sessions
- The improvement is clean and ethical

---

#### 5. Low Implementation Risk
- Large sample size (5,000 users) provides reliable estimates
- Consistent results across all segments reduce uncertainty
- Confidence intervals are tight and well above Group A
- No concerning patterns in the data

---

### Expected Outcome

If you implement Group B for all users:
- Conversion rate will improve from **5.4% to approximately 14.1%**
- For every 1,000 visitors, expect **87 additional conversions**
- Potential revenue increase of **$5+ million annually** (based on example calculation)

---

### Implementation Priority: **HIGH**

The evidence is overwhelming. This is a clear, data-driven decision with minimal risk and massive upside.

---

## How to Run This Project

#### 1. Set up Snowflake
Create a free Snowflake trial account at snowflake.com
Run the queries in `sql/ab_testing_analysis.sql`
Load `data/ab_testing.csv` using Snowflake's Load Data UI

#### 2. Load the Data
Upload `ab_testing.csv` to your Snowflake table
Verify with `SELECT * FROM ab_test_results LIMIT 10;`

#### 3. Run Python Statistical Analysis in Snowflake

**Option A: Using Snowflake Notebooks (Recommended)**
In Snowflake, navigate to Projects → Notebooks
Create a new Python notebook
Copy the code from `notebooks/ab_testing_statistical_analysis.ipynb`
Run the cells directly in Snowflake

**Option B: Using Local Jupyter Notebook**
```bash
# Install required libraries
pip install pandas numpy scipy statsmodels snowflake-connector-python

# Launch Jupyter Notebook
jupyter notebook notebooks/ab_testing_statistical_analysis.ipynb

#### 4. Explore Tableau Dashboards
Download Tableau Public (free)
Open the Tableau workbook or visit the published dashboard link
Interact with the visualizations to explore the data


Key Learnings
1. Always Validate with Statistics
SQL showed Group B looked better, but Python's chi-square test proved it wasn't just luck. Never make business decisions on descriptive statistics alone.

2. Check Secondary Metrics
Confirming that page views and time spent didn't change ruled out confounding factors. This proved the conversion lift came from better design, not manipulation.

3. Segment Analysis Builds Confidence
Seeing consistent improvement across all devices, locations, and user types gave confidence that the result will hold when rolled out to everyone.

4. Effect Size Matters as Much as P-Value
A tiny improvement can be statistically significant but meaningless for business. Cohen's h confirmed this improvement is worth implementing.

5. Confidence Intervals Tell the Full Story
P-values say "is there a difference?" but confidence intervals say "how big is the difference?" Non-overlapping intervals made the case even stronger.



Project Highlights
✨ End-to-end A/B testing pipeline from data storage to statistical validation to visualization
✨ Real-world business scenario with clear, actionable recommendations
✨ Proper statistical methodology including chi-square tests, confidence intervals, and effect size
✨ Multi-dimensional analysis across devices, locations, and user segments
✨ Clean, reproducible code with detailed documentation
✨ Professional visualizations in Tableau for stakeholder communication


