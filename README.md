# Power BI Dashboard Setup

This guide reconstructs the executive churn dashboard referenced in the main README.

## 1. Get the data in

1. Open Power BI Desktop → **Get Data → Text/CSV**.
2. Load `data/Customer.csv` (or `data/cleaned_customer.csv` if you want the pre-scaled version — for the dashboard, use the **raw** file so numbers stay human-readable).
3. In Power Query, rename the table to `BankChurn`, confirm column types:
   - `customer_id` → Whole Number
   - `credit_score`, `age`, `tenure`, `products_number` → Whole Number
   - `balance`, `estimated_salary` → Decimal Number
   - `credit_card`, `active_member`, `churn` → Whole Number (used as flags)
   - `country`, `gender` → Text

## 2. Core DAX measures

```dax
Total Customers = COUNTROWS(BankChurn)

Churned Customers = SUM(BankChurn[churn])

Churn Rate = DIVIDE([Churned Customers], [Total Customers], 0)

Retained Customers = [Total Customers] - [Churned Customers]

Retention Rate = 1 - [Churn Rate]

Avg Age (Churned) =
CALCULATE(
    AVERAGE(BankChurn[age]),
    BankChurn[churn] = 1
)

Avg Age (Retained) =
CALCULATE(
    AVERAGE(BankChurn[age]),
    BankChurn[churn] = 0
)

Avg Balance = AVERAGE(BankChurn[balance])

Inactive Churn Rate =
CALCULATE(
    [Churn Rate],
    BankChurn[active_member] = 0
)

Active Churn Rate =
CALCULATE(
    [Churn Rate],
    BankChurn[active_member] = 1
)

High Risk Flag =
IF(
    BankChurn[active_member] = 0 &&
    (BankChurn[products_number] = 1 || BankChurn[products_number] >= 3),
    "High Risk",
    "Standard"
)
```

## 3. Suggested pages & visuals

**Page 1 — Executive Overview**
- KPI cards: `Total Customers`, `Churn Rate`, `Retention Rate`, `Churned Customers`
- Donut chart: Churn split (retained vs. churned)
- Bar chart: Churn Rate by `country`
- Line/column combo: Customer count vs. Churn Rate by `age` bucket (use a calculated Age Group column, e.g. 18-30 / 31-40 / 41-50 / 51-60 / 60+)

**Page 2 — Risk Drivers**
- Bar chart: Churn Rate by `products_number`
- Bar chart: Active vs. Inactive Churn Rate
- Box/scatter: `balance` distribution by churn status
- Table: high-risk customer list filtered by the `High Risk Flag` measure, sorted by `balance` descending

**Page 3 — Geography Deep Dive**
- Map or bar chart: Churn Rate by `country`
- Matrix: `country` x `products_number` showing churn rate per cell
- Slicers: `gender`, `active_member`, `credit_card`

## 4. Formatting notes

- Use a conditional color rule on churn-rate visuals (green < 15%, amber 15–25%, red > 25%) so Germany and the 3–4 product segments stand out immediately.
- Add a bookmark/tooltip on the KPI cards that shows the same metric filtered to the prior period, once you have time-series data to compare against.

## 5. Publishing

- File → Publish → Power BI Service, or export to PDF/PPTX for stakeholders who don't have Power BI installed.
- If sharing the `.pbix` file in this repo, keep it under `dashboard/` and reference it from the main README.
