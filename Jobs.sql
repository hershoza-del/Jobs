SELECT * FROM jobs1 LIMIT 10;

SELECT Job_Title, Years_of_Experience FROM jobs1 LIMIT 10;

SELECT Job_Title, Company_Size, Salary_USD, `Automation_Risk_%`
FROM jobs1
WHERE Salary_USD > 500000 AND `Automation_Risk_%` > 20;

SELECT Job_Title, AI_Specialization, Salary_USD, Job_Satisfaction
FROM jobs1
ORDER BY Salary_USD DESC LIMIT 10;

SELECT COUNT(*) FROM jobs1 WHERE Has_Equity = "Yes";
SELECT ROUND(AVG(Competition_Level_Applicants), 0) FROM jobs1;

SELECT AI_Specialization, 
COUNT(*) AS count
FROM jobs1
GROUP BY AI_Specialization
HAVING COUNT(*) > 600;

SELECT
CASE WHEN Salary_USD > 600000 THEN "Really Rich" ELSE "Rich" END AS money_category,
COUNT(*) AS number_of_companies
FROM jobs1
GROUP BY money_category;

WITH category AS (
SELECT AI_Specialization, COUNT(*) AS count
FROM jobs1
WHERE `Automation_Risk_%` < 10
GROUP BY AI_Specialization
)
SELECT * FROM category
WHERE count > 80
ORDER BY count;

SELECT Job_Title, Company_Size, Work_Life_Balance,
ROW_NUMBER() OVER (
PARTITION BY Company_Size
ORDER BY Work_Life_Balance DESC
) AS rank_in_category
FROM jobs1;




