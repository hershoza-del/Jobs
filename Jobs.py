import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df = pd.read_csv("/Users/hershoza/Downloads/global_ai_jobs_2026.csv")

#where my charts will be saved specifically 
output_dir = os.path.join(os.path.expanduser("~"), "job_charts")
os.makedirs(output_dir, exist_ok=True)

def save_path(filename):
    return os.path.join(output_dir, filename)

print(f"Charts will be saved to: {output_dir}")

#brief analysis of the csv before changing the csv
print(df.shape)
print(df.info())
print(df.describe())

print(df.isnull().sum())
print(df.duplicated().sum())

summary = df.groupby("AI_Specialization")["Salary_USD"].agg(["mean", "count", "std"])
print(summary)

#changing the csv 
df = df.drop(columns=["Data_Source", "Record_Created", "Application_Deadline",
                      "Posted_Date" , "Salary_Min", "Salary_Max",
                      "Salary_Category", "Continent", "Work_From_Home_Available", 
                      "Skills_Required", "Required_Certifications", "Company",
                      "Industry", "Benefits_Value_USD", "Job_Openings",
                      "AI_Investment_Company_Millions", "Company_AI_Maturity_1_10",
                      "Job_Growth_Projection_%", "Gender_Diversity_%_Female", 
                      "Hiring_Difficulty_1_10"])

df["Company_Size"] = df["Company_Size"].str.split("(").str[0].str.strip()

df = df.rename(columns={"Equity_Offered": "Has_Equity",
                        "Job_Satisfaction_1_10": "Job_Satisfaction",
                        "Work_Life_Balance_1_10": "Work_Life_Balance"})

#boxplot, barchart, and scatterplot charts
fig, ax = plt.subplots(figsize=(8, 5))
df.boxplot(column="Salary_USD", by="Experience_Level", ax=ax, grid=False)
ax.set_title("Salary by Experience Level")
fig.suptitle("")           
ax.set_xlabel("Experience Level")
ax.set_ylabel("Salary (USD)")
fig.tight_layout()
fig.savefig(save_path("boxplot.png"), dpi=150)
plt.close(fig)

top_countries = df["Country"].value_counts().head(5).index
subset = df[df["Country"].isin(top_countries)]
counts = pd.crosstab(subset["Country"], subset["Experience_Level"])
counts = counts.loc[top_countries]

fig, ax = plt.subplots(figsize=(10, 6))
counts.plot(kind='bar', stacked=True, ax=ax, color='darkorange', edgecolor='white')
ax.set_title("Job Postings by Country and Experience Level (Top 5 Countries)")
ax.set_xlabel("Country")
ax.set_ylabel("Number of Job Postings")
ax.legend(title="Experience Level")
plt.xticks(rotation=20, ha="right")
fig.tight_layout()
fig.savefig(save_path("barchart.png"), dpi=150)
plt.close(fig)

jitter = np.random.uniform(-0.2, 0.2, size=len(df))
fig, ax = plt.subplots(figsize=(8, 5))
ax.scatter(df["Job_Satisfaction"] + jitter, df["Salary_USD"], alpha=0.1, s=10, color='seagreen') 
ax.set_title("Salary vs. Job Satisfaction")
ax.set_xlabel("Job Satisfaction (1-10)")
ax.set_ylabel("Salary (USD)")
fig.tight_layout()
fig.savefig(save_path("scatterplot.png"), dpi=150)
plt.close(fig)

#export changes to excel
df.to_excel("/Users/hershoza/Downloads/Jobs.xlsx", index=False)





