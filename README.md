# RETAILPULSE BI
### Sales Performance & Business Intelligence Command Center

An end-to-end analytics project: **Raw Data → Excel Analysis → SQL Analysis → Power BI Dashboard → Business Insights**.

> **Note:** The dataset is a synthetic practice dataset (862 raw rows, Jan–Dec 2024) created for this project. It is not real company data.

## Business Problem
RetailPulse Commerce relied on manually prepared reports. Management needed to know: *what is happening in the business, where, and what to investigate next?*

## Tools Used
- Microsoft Excel (data audit, formulas, analysis, charts)
- SQL (queries run on SQLite, presented in MySQL Workbench style)
- Power BI Desktop (3-page interactive dashboard)

## Data Cleaning
| Check | Rows Found | Action |
|---|---|---|
| Duplicate orders | 12 | Removed |
| Missing Product ID | 8 | Removed |
| Missing Order Date | 5 | Removed |
| Invalid quantity (≤0) | 6 | Removed |
| Missing Region | 6 | Filled as "Unknown" |
| Invalid discount | 4 | Clipped to valid range |
| Missing Customer ID | 5 | Filled as "Unknown Customer" |

Result: 862 raw rows → **831 clean rows**.

## KPI Definitions
- **Revenue** = Quantity × Unit_Price × (1 − Discount)
- **Profit** = Revenue − Cost
- **Profit Margin** = Profit ÷ Revenue
- **Average Order Value** = Total Revenue ÷ Total Orders

## Excel Analysis
Data audit, formula-based calculated columns, and pivot-style analysis with charts.

<img width="1917" height="1018" alt="excel_analysis" src="https://github.com/user-attachments/assets/1a657200-a0f6-4340-b64e-22f324c35e73" />


## SQL Analysis
13 queries in `sql/RetailPulse_Queries.sql` (10 core + 3 advanced using CTE, CASE, subqueries).

<img width="1262" height="931" alt="sql_results" src="https://github.com/user-attachments/assets/2d3d900e-2f2a-4cfa-9b95-232ec50c30bd" />

*Advanced query: high-revenue products with below-average profit margin.*

## Power BI Dashboard
**Page 1 - Executive Overview**

<img width="1916" height="970" alt="dashboard_overview" src="https://github.com/user-attachments/assets/5e56646e-3523-4a80-9908-ec10f907f932" />


**Page 2 - Sales & Product Analytics**

<img width="1917" height="975" alt="dashboard_products" src="https://github.com/user-attachments/assets/7eb1a854-f1df-48e2-8a66-d740519dda62" />


**Page 3 - Business Insights**

<img width="1917" height="978" alt="insights_page" src="https://github.com/user-attachments/assets/c28ae1ba-89ff-4897-a942-08f257f7f00f" />


## Key Insights
1. Total revenue ₹1.14 Cr, profit ₹45.67 L, overall margin ~40%.
2. Sports & Fitness leads on revenue, but Fashion has the best margin (44.5%).
3. West region has strong revenue but the lowest margin (37.7%) among major regions.
4. Trimmer is a top-3 product by revenue but has only 23% margin.
5. November is the peak month; June is the weakest. Online drives ~63% of revenue.

## Business Recommendations
1. Review Trimmer's cost and discount structure.
2. Investigate pricing/sourcing costs in the West region.
3. Grow Fashion and Home & Kitchen (highest margins).
4. Plan inventory and campaigns around the Oct–Nov peak.
5. Keep prioritising Online while testing offers to lift Store order value.

## Project Structure
```
RETAILPULSE_BI/
├── data/
│   └── RetailPulse_Data.xlsx
├── excel/
│   └── RetailPulse_Analysis.xlsx
├── sql/
│   ├── RetailPulse_Queries.sql
│   └── retailpulse.db
├── powerbi/
│   └── RetailPulse_Dashboard.pbix
├── report/
│   └── RetailPulse_Business_Report.docx
├── screenshots/
│   ├── excel_analysis.png
│   ├── sql_results.png
│   ├── dashboard_overview.png
│   ├── dashboard_products.png
│   └── insights_page.png
└── README.md
```

## Author
**Harshit Singh** — [LinkedIn profle : https://www.linkedin.com/in/harshit-singh-b67867414?utm_source=share_via&utm_content=profile&utm_medium=member_android]
