# Bank Customer Churn Analytics: End-to-End BI & Predictive Modeling

![Python](https://img.shields.io/badge/Python-3.11-blue)
![Database](https://img.shields.io/badge/Database-PostgreSQL-336791)
![Visualization](https://img.shields.io/badge/Visualization-Power%20BI-F2C811)
![License](https://img.shields.io/badge/License-MIT-green)

An end-to-end data analytics and machine learning project focused on identifying bank customers at risk of churning. This project integrates data cleaning, exploratory data analysis (EDA), database querying (SQL), predictive modeling (Python), and visual storytelling (Power BI) to deliver actionable business retention strategies — built on a real 10,000-customer dataset.


## 📈 Executive Summary & Key Insights

- **Age is the Dominant Factor:** Churn risk escalates sharply with age. The average age of churned customers is **44.8**, compared to **37.4** for retained customers.
- **Account Inactivity is a Critical Signal:** Inactive members churn at nearly double the rate of active members (**26.85% vs. 14.27%**).
- **The Product Sweet Spot is 2:** Customers with 1 product churn at a high rate (**27.71%**), but those with 3 or 4 products churn at extreme rates (**82.71%** and **100.00%**), indicating a serious friction point or over-saturation. Customers with exactly 2 products are the most loyal, at only **7.58%** churn.
- **Geographic Risk:** Customers in **Germany** churn at roughly double the rate of France and Spain (**32.44% vs. 16.15% / 16.67%**), suggesting local service issues or aggressive competitor pricing.

## 🛠️ Step-by-Step Implementation

### Step 1: Data Preprocessing (Python)

Using `pandas` and `scikit-learn`, the raw dataset of 10,000 customers is cleaned and prepared for modeling:

- Removed the identifier column (`CustomerId`).
- Mapped `Gender` to a binary flag (Male = 1, Female = 0).
- One-hot encoded `Geography` (Germany, Spain — France is the reference category).
- Scaled `CreditScore`, `Age`, `Balance`, and `EstimatedSalary` with `StandardScaler` to optimize model convergence.

```python
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
cols = ['CreditScore', 'Age', 'Balance', 'EstimatedSalary']
df[cols] = scaler.fit_transform(df[cols])
```

### Step 2: SQL Analysis (PostgreSQL)

The raw customer data is loaded into PostgreSQL to extract key business metrics (see `sql/churn_queries.sql` for the full set):

```sql
-- Overall churn rate
SELECT ROUND(AVG(churn) * 100, 2) AS churn_rate
FROM bank_churn; -- Result: 20.37%
```

```sql
-- Geography-based churn rate
SELECT country, ROUND(AVG(churn) * 100, 2) AS churn_rate
FROM bank_churn GROUP BY country ORDER BY churn_rate DESC;
-- Result: Germany (32.44%), Spain (16.67%), France (16.15%)
```

```sql
-- Active status impact
SELECT active_member, ROUND(AVG(churn) * 100, 2) AS churn_rate
FROM bank_churn GROUP BY active_member;
-- Result: Inactive (26.85%), Active (14.27%)
```

```sql
-- Product count impact
SELECT products_number, ROUND(AVG(churn) * 100, 2) AS churn_rate
FROM bank_churn GROUP BY products_number ORDER BY products_number;
-- Result: 1 Product (27.71%), 2 Products (7.58%), 3 Products (82.71%), 4 Products (100.00%)
```

### Step 3: Exploratory Data Analysis (EDA)

| Churn Distribution | Age vs. Churn |
|---|---|
| ![Churn Distribution](images/churn_distribution.png) | ![Age vs Churn](images/age_vs_churn.png) |

| Balance vs. Churn | Correlation Matrix |
|---|---|
| ![Balance vs Churn](images/balance_vs_churn.png) | ![Correlation Heatmap](images/correlation_heatmap.png) |

### Step 4: Machine Learning Modeling

Logistic Regression and Random Forest models were trained to predict churn risk (80% train / 20% test split, stratified on the target).

**Model Performance Comparison**

| Model | Accuracy | Precision | Recall | ROC-AUC |
|---|---|---|---|---|
| Logistic Regression | 80.80% | 58.91% | 18.67% | 77.48% |
| Random Forest Classifier | **82.05%** | 54.55% | **70.76%** | **86.54%** |

**Model Visualizations**

| ROC Curves Comparison | Feature Importances (Random Forest) |
|---|---|
| ![ROC Curve](images/roc_curve.png) | ![Feature Importances](images/feature_importances.png) |

The Random Forest Classifier substantially outperforms Logistic Regression on recall and ROC-AUC — critical for a churn model, since catching at-risk customers (recall) matters more than a marginal precision gain. It's the primary model recommended for customer risk scoring.

### Step 5: Power BI Business Intelligence Dashboard

A comprehensive executive dashboard tracks the banking performance KPIs derived above. See [`dashboard/README.md`](dashboard/README.md) for the full setup guide and DAX measures to reconstruct it.

## 🎯 Business Recommendations

1. **Re-engage Inactive Members:** Launch targeted promotions (e.g., fee-free credit cards, loyalty rate increases) for inactive members showing signs of dormancy — they churn at nearly 2x the rate of active members.
2. **Optimize Cross-Selling:** Focus cross-selling campaigns on moving customers from 1 product to 2 products (the safest loyalty zone). Run urgent service audits for customers holding 3+ products — that segment is churning at 80%+.
3. **Targeted Campaigns in Germany:** Investigate competitor pricing or local service gaps in Germany, where churn is double that of France and Spain.
4. **Senior Loyalty Packages:** Build specialized loyalty programs, wealth advisory benefits, or low-risk investment vehicles tailored to the higher-risk 40+ age demographic.

## 🚀 Getting Started

```bash
git clone https://github.com/<your-username>/Bank-Customer-Churn-Analytics.git
cd Bank-Customer-Churn-Analytics
pip install -r requirements.txt
jupyter notebook notebooks/churn_analysis.ipynb
```

## 📊 Dataset

10,000 bank customer records with the following fields: `customer_id`, `credit_score`, `country`, `gender`, `age`, `tenure`, `balance`, `products_number`, `credit_card`, `active_member`, `estimated_salary`, `churn`.

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
