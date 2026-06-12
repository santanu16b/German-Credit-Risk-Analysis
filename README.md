# German-Credit-Risk-Analysis
 Dataset used from: https://www.kaggle.com/code/janiobachmann/german-credit-analysis-a-risk-perspective Tools Used: Excel · MySQL · Tableau Dataset: German Credit Risk dataset — 1,000 borrower records across savings levels and age, duration and credit bands 

Business Question
What borrower characteristics — savings level, age, loan duration, loan purpose, credit amount — are most strongly associated with loan default? Which combinations of factors represent the highest-risk segments for a lender?

**Dataset Overview**
Rows -> 1,000 borrowers
Columns -> Customer_ID, Age, Sex, Job, Housing, Saving_Account, Checking_Account, Credit_Amount, Duration, Purpose, Risk, Credit_Band, Age_Band, Duration_Band, Risk_Flag
Saving Account levels -> Little, Moderate, Quite Rich, Rich, Not Applicable
Age Bands -> Under 25, 25-34, 35-49, 50+
Duration Bands -> 0-12, 13-24, 25-36, 36+ Months
Credit Bands -> Low, Medium, High, Very High
Purpose -> Car, Radio/TV, Furniture/equipment, Business, Education, Repairs, Domestic appliances, Vacation/others

What I Did:

Step 1 — Data Preparation (Excel)

Cleaned the raw Kaggle dataset and replaced blank/NA values with "not applicable"
Created derived columns: Credit_Band, Age_Band, Duration_Band, Risk_Flag (binary version of Risk)
Verified all 1,000 rows loaded correctly with no missing values

Step 2 — Database Setup (MySQL)

Created the Project2 database and credit_risk table with appropriate data types
Imported the cleaned CSV with Customer_ID as the primary key
Ran exploratory queries to verify row counts and data integrity

Step 3 — Analysis (MySQL)
Ran structured SQL queries across multiple analytical layers — overall summary, default rate by purpose, savings account level, duration band, credit band, age band, and a window function ranking loan purposes by default rate within each savings group.

Step 4 — Visualisation (Tableau)

Connected the cleaned CSV to Tableau Public
Built sheets for KPIs, Saving Account default rate, Age Band default rate, Duration Band default rate, Credit Band default rate, and a Purpose × Saving Account heat map
Assembled into a single dashboard with Saving Account and Purpose filters
Added a note flagging cells with fewer than 5 borrowers as statistically unreliable
Published to Tableau Public

Analysis & Insights

1. Overall Portfolio Summary
SELECT count(*) as total_borrowers, sum(Risk_Flag) as total_defaults,
round(sum(Risk_Flag)*100/count(*),2) as default_rate,
round(avg(Credit_Amount),2) as avg_credit_amount,
round(avg(Duration),1) as avg_duration_months
FROM credit_risk;

Insight: Out of 1,000 borrowers, 30% have defaulted, with an average credit amount of €3,271.26 and average loan duration of 21 months. This 30% baseline default rate is the benchmark — any segment significantly above this is a higher-risk group worth investigating.

2. Default Rate by Loan Purpose
SELECT Purpose, count(*) as borrowers, sum(Risk_Flag) as defaults,
round(sum(Risk_Flag)*100/count(*),2) as default_rate,
round(avg(Duration),1) as avg_duration_months,
round(avg(Credit_Amount),2) as avg_amount
FROM credit_risk
GROUP BY Purpose ORDER BY default_rate desc;

Insight: Vacation/others and Education loans carry the highest default rates, while Radio/TV is the safest purpose category — sitting well below the overall 30% average. Purpose alone is a meaningful but not the strongest risk signal.

3. Default Rate by Savings Account Level
SELECT Saving_Account, count(*) as borrowers, sum(Risk_Flag) as defaults,
round(sum(Risk_Flag)*100/count(*),2) as default_rate
FROM credit_risk
GROUP BY Saving_Account ORDER BY default_rate desc;

Insight: Borrowers with "Little" savings default at 35.99% — nearly 3x the rate of those with "Rich" savings (12.50%). Savings account status is one of the clearest and strongest predictors of default risk in the entire dataset.

4. Default Rate by Age Band
SELECT Age_Band, count(*) as borrowers, sum(Risk_Flag) as defaults,
round(sum(Risk_Flag)*100/count(*),2) as default_rate
FROM credit_risk
GROUP BY Age_Band ORDER BY default_rate desc;

Insight: Borrowers Under 25 default at 40.94% — by far the highest of any age group, more than double the 35-49 group (22.63%). Younger borrowers represent a significantly elevated risk segment, likely reflecting shorter credit histories and less financial stability.

5. Default Rate by Loan Duration
SELECT Duration_Band, count(*) as borrowers, sum(Risk_Flag) as defaults,
round(sum(Risk_Flag)*100/count(*),2) as default_rate
FROM credit_risk
GROUP BY Duration_Band ORDER BY default_rate desc;

Insight: Default rate rises steadily with loan duration — from 21.17% for 0-12 month loans to 51.72% for loans of 36+ months. Longer-duration loans more than double the baseline risk, making duration one of the most actionable underwriting levers.

6. Default Rate by Credit Amount Band
SELECT Credit_Band, count(*) as borrowers, sum(Risk_Flag) as defaults,
round(sum(Risk_Flag)*100/count(*),2) as default_rate,
round(avg(Credit_Amount),2) as avg_amount
FROM credit_risk
GROUP BY Credit_Band ORDER BY default_rate desc;

Insight: "Very High" credit amount loans default at a noticeably elevated rate compared to "Low" and "Medium" bands, confirming that larger loan sizes carry proportionally higher risk.

7. Savings Account × Purpose Risk Ranking (Window Function)
SELECT Saving_Account, Purpose, count(*) as borrowers,
round(sum(Risk_Flag)*100.0/count(*),2) as default_rate,
rank() over (partition by Saving_Account order by sum(Risk_Flag)*100.0/count(*) desc)
as risk_rank_in_savings_group
FROM credit_risk
GROUP BY Saving_Account, Purpose
HAVING count(*) >= 5
ORDER BY Saving_Account, default_rate desc;

Insight: Within the "Little" savings group — the highest-risk segment overall — Education (50%) and Business (48.21%) loans are the most dangerous combinations, with 1 in 2 education borrowers defaulting. Within "Rich" savings, Car and Furniture/equipment loans default at 0%. The gap between these two extremes shows that savings level combined with purpose produces the most powerful risk signal in the dataset — far stronger than either factor alone.

Key Findings Summary

#  Finding
1  Overall default rate is 30% across 1,000 borrowers, with an average credit amount of €3,271.26 and average duration of 21 months
2  Saving Account level is the single strongest individual predictor — "Little" savings defaults at 35.99% vs 12.50% for "Rich" savings
3  Under 25 borrowers default at 40.94% — the highest of any age band, nearly double the safest age band (35-49 at 22.63%)
4  Default rate rises consistently with loan duration — from 21.17% (0-12 months) to 51.72% (36+ months)
5  Education and Business are the riskiest loan purposes overall
6  Within the "Little" savings group, Education loans default at 50% — the single highest risk combination in the dataset
7  Within the "Rich" savings group, Car and Furniture/equipment loans default at 0% — the lowest risk combination in the dataset
8  Cells with fewer than 5 borrowers (e.g. some Moderate/Rich × Purpose combinations) show extreme percentages and should be treated with caution

Conclusion & Recommendations

The core finding of this analysis is that default risk is not driven by a single factor — it is the combination of savings account level, age, loan duration, and loan purpose that produces the clearest risk signal.

Recommendation 1 — Tighten underwriting for "Little" savings + Education/Business loans
This combination defaults at nearly 50%. Either require additional collateral/guarantors or apply stricter income verification for this segment.

Recommendation 2 — Apply additional scrutiny to Under-25 borrowers
At 40.94% default, this age group is the highest-risk by a wide margin. Consider requiring a co-signer or limiting initial credit amounts for first-time borrowers under 25.

Recommendation 3 — Cap or re-price loans of 36+ months duration
Default rate more than doubles for the longest-duration loans (51.72%). Shorter repayment terms or risk-based pricing for long-duration loans would directly reduce exposure.

Recommendation 4 — Use the Saving Account × Purpose combination as a screening matrix
Rather than evaluating savings level or purpose in isolation, lenders should use the combined risk ranking (Recommendation Query 7) as a quick screening tool — "Rich savings + Car/Furniture" can be fast-tracked, while "Little savings + Education/Business" should trigger manual review.

Recommendation 5 — Flag low-sample cells before reporting them as findings
Several Saving Account × Purpose combinations have fewer than 5 borrowers and show 0% or 100% default rates. These should never be presented as standalone insights without a sample-size caveat, as done in the dashboard.
