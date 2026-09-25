library(readxl)
library(dplyr)

df <- read_excel("Downloads/Jobs1.xlsx") %>%
  rename(Remote_Pct = `Remote_Work_%`) %>%
  mutate(
    is_us            = Country == "United States",
    Experience_Level = factor(Experience_Level, levels = c("Entry Level", "Mid Level",
                                                           "Senior Level", "Lead Level", "Executive")),
    Company_Size     = factor(Company_Size, levels = c("Small", "Medium", "Large", "Enterprise"))
  )

# 1. t-test: US vs non-US salary

t.test(Salary_USD ~ is_us, data = df)

# 	Welch Two Sample t-test
#
# data:  Salary_USD by is_us
# t = -5.9927, df = 109.89, p-value = 2.667e-08
# alternative hypothesis: true difference in means between group FALSE and group TRUE is not equal to 0
# 95 percent confidence interval:
#  -94401.60 -47480.94
# sample estimates:
# mean in group FALSE  mean in group TRUE
#            156633.4            227574.7

# 2. anova: salary across experience levels

anova_model <- aov(Salary_USD ~ Experience_Level, data = df)
summary(anova_model)

#                    Df    Sum Sq   Mean Sq F value Pr(>F)
# Experience_Level    4 2.031e+13 5.077e+12    2348 <2e-16 ***
# Residuals        4995 1.080e+13 2.162e+09
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

TukeyHSD(anova_model)

#   Tukey multiple comparisons of means
#     95% family-wise confidence level
#
# Fit: aov(formula = Salary_USD ~ Experience_Level, data = df)
#
# $Experience_Level
#                               diff       lwr       upr p adj
# Mid Level-Entry Level     35369.91  28700.34  42039.48     0
# Senior Level-Entry Level  81749.65  75251.36  88247.95     0
# Lead Level-Entry Level   143717.52 136733.37 150701.66     0
# Executive-Entry Level    273336.68 263747.68 282925.67     0
# Senior Level-Mid Level    46379.74  41871.56  50887.93     0
# Lead Level-Mid Level     108347.61 103163.58 113531.64     0
# Executive-Mid Level      237966.77 229597.49 246336.04     0
# Lead Level-Senior Level   61967.86  57006.13  66929.60     0
# Executive-Senior Level   191587.02 183353.60 199820.45     0
# Executive-Lead Level     129619.16 120997.11 138241.21     0

# 3. Correlation: remote work % vs salary

cor.test(df$Remote_Pct, df$Salary_USD)

# 	Pearson's product-moment correlation
#
# data:  df$Remote_Pct and df$Salary_USD
# t = -0.7043, df = 4998, p-value = 0.4813
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  -0.03767068  0.01776241
# sample estimates:
#          cor
# -0.009961791

# 4. Regression: experience + remote + company size

model <- lm(Salary_USD ~ Experience_Level + Remote_Pct + Company_Size, data = df)
summary(model)

# Call:
# lm(formula = Salary_USD ~ Experience_Level + Remote_Pct + Company_Size, data = df)
#
# Residuals:
#     Min      1Q  Median      3Q     Max
# -215396  -26734   -1985   23841  371081
#
# Coefficients:
#                               Estimate Std. Error t value Pr(>|t|)
# (Intercept)                   74727.51    3266.72  22.875   <2e-16 ***
# Experience_LevelMid Level     35322.35    2445.69  14.443   <2e-16 ***
# Experience_LevelSenior Level  81667.98    2382.92  34.272   <2e-16 ***
# Experience_LevelLead Level   143571.43    2561.81  56.043   <2e-16 ***
# Experience_LevelExecutive    273250.57    3514.78  77.743   <2e-16 ***
# Remote_Pct                        2.00      25.24   0.079    0.937
# Company_SizeMedium            -2253.84    2468.01  -0.913    0.361
# Company_SizeLarge               678.73    2317.94   0.293    0.770
# Company_SizeEnterprise         -822.45    2460.44  -0.334    0.738
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#
# Residual standard error: 46500 on 4991 degrees of freedom
# Multiple R-squared:  0.6531,	Adjusted R-squared:  0.6525
# F-statistic:  1174 on 8 and 4991 DF,  p-value: < 2.2e-16

# 5. Chi-square: equity by company size

chisq.test(table(df$Company_Size, df$Has_Equity))

# 	Pearson's Chi-squared test
#
# data:  table(df$Company_Size, df$Has_Equity)
# X-squared = 1.1134, df = 3, p-value = 0.7738

# 6. z-test for proportions: equity in US vs non-US jobs

prop.test(table(df$is_us, df$Has_Equity == "Yes"))

# 	2-sample test for equality of proportions with continuity correction
#
# data:  table(df$is_us, df$Has_Equity == "Yes")
# X-squared = 0.0023091, df = 1, p-value = 0.9617
# alternative hypothesis: two.sided
# 95 percent confidence interval:
#  -0.08924269  0.10308950
# sample estimates:
#    prop 1    prop 2
# 0.6399509 0.6330275
  