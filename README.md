## Medicare Spending per Beneficiary (MSPB)

This repository contains an end-to-end **data analytics and business intelligence project** analyzing **Medicare Spending per Beneficiary (MSPB)** across U.S. hospitals. The goal of this project is to evaluate hospital cost efficiency, identify spending drivers, and uncover geographic and organizational patterns in Medicare spending.

---

## Important Note on Markdown Rendering

If you are viewing this file in **Edit mode**, it may look like plain text.

**This is expected behavior.**

GitHub Markdown only renders headers, bullet points, and formatting when you click **Preview**.

So what you need is **correct Markdown syntax**, not something that “looks styled” in Edit mode.  
Below is **100% valid GitHub Markdown**.  
Copy-paste it exactly, then click **Preview** — **it WILL render correctly**.

---

## Project Overview

**Medicare Spending per Beneficiary (MSPB)** is a CMS metric that compares how much Medicare spends on a hospital stay relative to the national average.

* MSPB = **1.00** → Equal to national average  
* MSPB < **1.00** → More cost-efficient  
* MSPB > **1.00** → Higher spending than average  

This project combines **CMS MSPB data** with **Hospital General Information** to evaluate whether higher spending correlates with better hospital quality, ownership type, or geographic location.

---

## Key Business Questions

* How many hospitals are included in the MSPB program?
* What is the national average MSPB score?
* Which hospitals spend above vs below the national average?
* How does MSPB vary by state?
* Does higher spending correlate with better hospital quality ratings?
* Does hospital ownership structure influence spending efficiency?

---

## Data Sources

* CMS Medicare Spending per Beneficiary (MSPB)
* CMS Hospital General Information
* CMS Provider Data Catalog

All datasets are publicly available and provided by the Centers for Medicare & Medicaid Services (CMS).

---

## Tools & Technologies

* **Python**
  * Pandas
  * NumPy
* **SQL Server**
  * Views
  * CTEs
  * Window Functions
  * Data Deduplication
* **Power BI**
  * DAX measures
  * KPI cards
  * Filled maps
  * Bar charts and tables
* **GitHub**
  * Version control
  * Project documentation

---

## Data Engineering & SQL Design

* Cleaned and standardized raw CMS datasets
* Deduplicated hospital records using `ROW_NUMBER()`
* Built hospital dimension views with consistent attributes
* Created MSPB feature views for analytics
* Designed KPI summary views for Power BI consumption
* Ensured correct data grain to avoid duplication in dashboards

---

## Key Metrics

* Total Hospitals
* Average MSPB Score
* Hospitals Above National Average
* Hospitals Below National Average
* Average MSPB by State
* Average MSPB by Hospital Quality Rating
* Average MSPB by Hospital Ownership
* Top 10 Highest-Spending Hospitals
* Top 10 Most Cost-Efficient Hospitals

---

## Power BI Dashboard Overview

The Power BI report is designed for **executive and analytical audiences** and includes:

* Executive KPI cards for quick insight
* U.S. filled map showing average MSPB by state
* Cost drivers analysis by:
  * Hospital quality rating
  * Hospital ownership type
* Ranked tables of:
  * Highest-spending hospitals
  * Most cost-efficient hospitals
* Interactive filtering and drill-down capabilities

---

## Key Insights

* Higher Medicare spending does **not consistently** lead to better hospital quality ratings
* Hospital ownership structure shows stronger variation in MSPB than quality ratings
* Certain states consistently spend above the national average
* A small subset of hospitals drives extreme over- and under-spending
* Cost efficiency opportunities exist without sacrificing quality outcomes

---

## Repository Structure

* `/sql` – SQL scripts, views, and transformations
* `/python` – Data preparation and validation scripts
* `/powerbi` – Power BI report files
* `/data` – Source and processed datasets
* `README.md` – Project documentation

---

## Future Enhancements

* Add year-over-year MSPB trend analysis
* Incorporate additional CMS quality measures
* Build predictive models to identify cost drivers
* Expand dashboards with hospital-level drill-through analysis

---

## Author

**Kishor Khatiwada**  
Data Analytics | Business Intelligence | Healthcare Analytics
