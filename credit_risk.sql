-- First we are going to create our database and then create the table and then import the csv 

create database Project2;

use Project2;

create table credit_risk (Customer_ID int primary key, 
Age int, Sex varchar(100), Job int,
Housing varchar(100), Saving_Account varchar(100), Checking_Account varchar(100),
Credit_Amount int, Duration int, Purpose varchar (100), Risk varchar(100),
Credit_Band varchar(100), Age_Band varchar(100) ,Duration_Band varchar(100), Risk_Flag int);

select * from credit_risk;

-- The data has been imported and verified, now we will explore the data

select Customer_ID, Job, Purpose, Credit_Amount from credit_risk where Risk_Flag = 1;

select count(*) as total_borrowers, sum(Risk_Flag) as total_defaulters, 
round(sum(Risk_Flag)*100/count(*),2) as overall_default_rate, 
round(avg(Credit_Amount),2) as avg_loan_amount,
round(avg(Duration),2) as avg_loan_duration from credit_risk;

-- The default rate is 30.00%, which is alarming for a total 1000 people who are borrowers
-- Therefore, the total defaulters are 300 people
-- The average loan amount and loan duration being €3271.26 and 20.90 months respectively
-- Next, we will check the purpose of the loan of the defaulters

select Purpose, count(*) as borrowers, sum(Risk_Flag) as defaults, round(Sum(Risk_Flag)*100/count(*)) as default_rate,
round(avg(Duration),2) as avg_duration, round(avg(Credit_Amount)) as avg_amount from credit_risk
group by Purpose order by default_rate desc;

-- We can now see that vacation/others have the highest default rate with 42% with a 20.58 months avg along with €8209.33 avg amount
-- They are also the lowest amount of borrowers with 12 and also the highest avg borrow amount indicating an alarming default correlation with amount of borrowers and amount
-- The highest being the purpose of car with 337 borrowers with 31% default rate and €3768.19 amount
-- Education is close second in the default rate with 39% and €2879.20 avg borrow rate
-- Now let us explore a little bit about the purpose category of vacation/others and education first, our top 2 default rate categories

select Age, Job, Saving_Account, Credit_Amount, Duration from credit_risk where Purpose = 'vacation/others' and Risk_Flag = 1;

-- We can see that the age diverity is not restricted to a particular group, but the job category is, which = 3
-- The duration range is high, 24 months being the lowest and 60 months being the highest
-- Credit amount are all more than €11,000 with the one exception being €1358 whise saving account is also 'not applicable'
-- Now we will check for education

select Age, Job, Saving_Account, Credit_Amount, Duration from credit_risk where Purpose = 'education' and Risk_Flag = 1;

-- This is much diverse with the age but the most common number in job catgeory = 2 followed by 3 then 1 and then 0
-- The credit amount goes as high as €12612 to as low as €433
-- The duration is also very diverse with being as high as 60 months to as low as 6 months

select Saving_Account, sum(Risk_Flag) as defaults, round(sum(Risk_Flag)*100/count(*),2) as default_rate,
round(avg(Credit_Amount),2) as avg_loan_amount from credit_risk group by Saving_Account order by default_rate desc;

-- We can see that people with 'Little' savings have the highest default rate with 35.99% and an average loan amount of €3187.83
-- This is followed by 'Moderate' then 'Not Applicable', 'Quite Rich' and then 'Rich'-> who are at 12.50% default rate with 6 people

-- We will now see the purpose of the people who are defaulters with 'Little' in Saving_Account

select Purpose, Saving_Account, round(sum(Risk_Flag)*100/count(*)) as default_rate,
round(avg(Credit_Amount),2) as avg_loan_amount from credit_risk where Saving_Account = 'Little'
group by Purpose order by default_rate desc;

-- An alarming rate of 50% default rate in the education purpose followed by 48% in the business purpose
-- This is followed by 43% in repairs purpose. Here vacation/others which has the overall highest default rate come at the 5th position among the 8 with 38%
-- The lowest is the radio/TV purpose with 25% default rate

select Duration_Band, count(*) as borrowers, round(sum(Risk_Flag)*100/count(*),2) as default_rate,
round(avg(Credit_Amount),2) as avg_loan_amount from credit_risk
group by Duration_Band order by default_rate desc;

-- The highest ranked default rates 1. 36+ Months -> 87 borrowers, 51.72% default rate with an avg of €7645.77 loan amount
-- 2. 25-36 Months -> 143 borrowers, 39.86% default rate with an avg of €5273.60 loan amount
-- 3. 13-24 Months -> 411 borrowers, 29.68% default rate with an avg of €2923.71 loan amount
-- 4. 0-12 Months -> 359 borrowers, 21.17% default rate with an avg of €1811.44 loan amount

select Purpose, round(sum(Risk_Flag)*100/count(*)) as default_rate,
round(avg(Credit_Amount),2) as avg_loan_amount from credit_risk where Duration_Band = '36+ Months'
group by Purpose order by default_rate desc;

-- An alarming rate of 100% default rate in the purpose category of domestic appliances is there with an avg of €3051.00
-- Repairs have the lowest with 0% with and avg of €3394.00

select Credit_Band, count(*) as borrowers, round(sum(Risk_Flag)*100/count(*)) as default_rate,
round(avg(Credit_Amount),2) as avg_loan_amount from credit_risk
group by Credit_Band order by default_rate desc;

-- We can see by ranking of credit band 1. Very High -> borrowers 40, 60% default rate with an avg €12641.88 loan amount
-- 2. High -> borrowers 148, 36% default rate with an avg €6953.00 loan amount
-- 3. Low -> borrowers 432, 28% default rate with an avg €1266.84 loan amount
-- 4. Medium -> borrowers 380, 27% default rate with an avg €3129.65 loan amount

select Purpose, round(sum(Risk_Flag)*100/count(*)) as default_rate,
round(avg(Credit_Amount),2) as avg_loan_amount from credit_risk where Credit_Band = 'Very High'
group by Purpose order by default_rate desc;

-- Here the purpose category containing repairs have the highest default rate with 100% along with an avg of €11998.00
-- Business and vacation/others are the next category both with 80% 
-- The lowest is radio/TV with 20% default rate with an avg loan amount of €11945.80

select Age_Band, count(*) as borrowers, round(sum(Risk_Flag)*100/count(*)) as default_rate,
round(avg(Credit_Amount),2) as avg_loan_amount from credit_risk
group by Age_Band order by default_rate desc;

-- The rankings of age band are 1. Under 25 -> borrowers 149, 41% default rate with an avg €2958.76 loan amount
-- 2. 25-34 -> borrowers 399, 33% default rate with an avg €3293.19 loan amount
-- 3. 50+ -> borrowers 125, 27% default rate with an avg €3276.32 loan amount
-- 4. 35-49 -> borrowers 327, 23% default rate with an avg €3384.95 loan amount

select Purpose, round(sum(Risk_Flag)*100/count(*)) as default_rate,
round(avg(Credit_Amount),2) as avg_loan_amount from credit_risk where Age_Band = 'Under 25'
group by Purpose order by default_rate desc;

-- Domestic Appliances' default rate is the highest with 50% with an avg loan amount of €1031.50
-- This is followed by car with a 49% default rate with an avg loan amount of €4180.92
-- The lowest being Repairs with a 20% default rate with an avg loan amount of €1113.40

select Purpose, Duration_Band, round(sum(Risk_Flag)*100/count(*)) as default_rate, 
count(*) as borrowers from credit_risk group by Purpose, Duration_Band
having count(*)>=10 order by default_rate desc
limit 10;

-- 1. Business (36+ Months) -> borrowers 19, 63% default rate
-- 2. Furniture/Equipment (25-36 Months) -> borrowers 25, 60% default rate
-- 3. Radio/TV (36+ Months) -> borrowers 23, 57% default rate
-- 4. Business (25-36 Months) -> borrowers 22, 45% default rate
-- 5. Car (36+ Months) -> borrowers 27, 41% default rate
-- 6. Education (13-24 Months) -> borrowers 15, 40% default rate
-- 7. Car (25-36 Months) -> borrowers 47, 38% default rate
-- 8. Car (13-24 Months) -> borrowers 140, 34% default rate
-- 9. Education (0-12 Months) -> borrowers 30, 30% default rate
-- 10. Repairs (13-24 Months) -> borrowers 10, 30% default rate

select Saving_Account, Purpose, count(*) as borrowers,
round(sum(Risk_Flag) * 100.0 / count(*), 2) as default_rate, rank() over (partition by Saving_Account
order by sum(Risk_Flag) * 100.0 / count(*) desc) as risk_rank_in_savings_group
from credit_risk
group by Saving_Account, Purpose
having count(*) >= 5
order by Saving_Account, default_rate desc;

-- Little savings = highest risk group. Education (50%) and Business (48.21%) 
-- are the most dangerous combinations — 1 in 2 education borrowers defaults.
-- Moderate savings: Education hits 60% but only 5 borrowers — small sample.
-- Furniture/equipment (44.44%) is the main concern here.
-- Not applicable: Risk drops sharply — max 22.97%. Education safest at 6.67%.
-- Rich savings = lowest risk. Car and furniture default at 0%.
-- KEY FINDING: Savings level is the strongest default predictor.
-- Little + education = 50% default. Rich + car/furniture = 0% default.
-- Savings status should be a mandatory screening criterion for loan approval.