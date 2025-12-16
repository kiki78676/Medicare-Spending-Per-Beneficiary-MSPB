## 📊 CMS Medicare Spending Per Beneficiary (MSPB) Analysis

---

## 📌 Project Overview

**Medicare Spending per Beneficiary (MSPB)** is a CMS metric that measures how much Medicare spends on a hospital episode relative to the national average.

- 🟢 **MSPB = 1.00** → Equal to national average  
- 📉 **MSPB < 1.00** → More cost-efficient  
- 📈 **MSPB > 1.00** → Higher spending than average  

This project delivers an **end-to-end healthcare analytics and business intelligence solution** that evaluates hospital cost efficiency, identifies spending drivers, and examines whether **higher Medicare spending correlates with better hospital outcomes, ownership type, or geographic location**.

The final output is an **executive-ready Power BI dashboard** backed by a **SQL-driven analytical model**.

---

## 🏥 What This Project Does

This repository contains a complete analytics workflow that:

- Cleans and validates CMS MSPB data using **Python**
- Models reusable analytical views in **SQL Server**
- Enriches MSPB data with **Hospital General Information**
- Prevents duplicate inflation through **window-function-based deduplication**
- Visualizes insights using **Power BI** (SQL-first design, minimal DAX)

**Workflow Overview**

📥 Data ingestion → 🧹 Cleaning & validation → 🗄️ SQL Server modeling → 📊 Power BI visuals → 📈 Executive insights

---

## ❓ What Is MSPB?

**Medicare Spending per Beneficiary (MSPB)** compares Medicare spending for a hospital episode (3 days before admission through 30 days post-discharge) to the national average.

- 🟢 **MSPB = 1.00** → National average spending  
- 📉 **MSPB < 1.00** → More efficient spending  
- 📈 **MSPB > 1.00** → Higher than average spending  

This project combines **CMS MSPB** with **Hospital General Information** to evaluate spending differences by:

- State
- Hospital ownership
- Hospital quality rating

---

## 📌 Business Questions Answered

- 🏥 How many hospitals are included and what is the overall MSPB average?
- 📊 How many hospitals spend **above vs below** the national average?
- 🗺️ Which states show the highest and lowest average MSPB?
- ⭐ Does higher Medicare spending correlate with better quality ratings?
- 🏢 How does spending vary by hospital ownership type?
- 🚨 Which hospitals are extreme outliers (highest spending vs most efficient)?

---

## 📂 Data Sources

- **CMS Medicare Spending per Beneficiary (MSPB)**
- **CMS Hospital General Information**
- **CMS Provider Data Catalog**

All datasets are publicly available from the CMS Provider Data portal.

---

## 🧰 Tech Stack

### 🐍 Python — Data Ingestion & ETL

Used for repeatable ingestion and preprocessing before loading into SQL Server.

- **pandas**  
  - Load and clean raw CSV files  
  - Handle missing values and data types  
  - Standardize column naming  

- **numpy**  
  - Numeric calculations and transformations  

- **urllib**  
  - Dataset retrieval and file handling  

- **SQLAlchemy + pyodbc**  
  - Database connectivity  
  - Load cleaned DataFrames into SQL Server tables  

---

### 🗄️ SQL Server — Data Modeling & Analytics

SQL Server is the **core analytical layer** of this project.

- Clean base views with enforced data types
- Feature engineering in SQL:
  - MSPB % vs national average
  - Cost-efficiency tiers
- **Window functions** (`ROW_NUMBER() OVER (PARTITION BY ...)`) to deduplicate hospitals
- Reusable **views** for:
  - KPIs
  - Regional aggregation
  - Rankings
  - Ownership and quality analysis
- Data quality checks:
  - Duplicate detection
  - Null validation
  - Row-count reconciliation

---

### 📊 Power BI — Visualization & Reporting

Power BI is used **strictly for visualization**, with business logic handled upstream in SQL.

- Executive KPI cards
- Filled U.S. map (state-level MSPB averages)
- Bar charts for:
  - Spending vs quality ratings
  - Spending vs ownership type
- Ranked tables for:
  - Highest-spending hospitals
  - Most cost-efficient hospitals
- Interactive slicers for exploration

> Design choice: SQL views were intentionally used instead of heavy DAX to improve transparency, performance, and scalability.

---

## 🔄 End-to-End Pipeline

### Step 1: Data Acquisition
- Download CMS MSPB and Hospital General Information datasets
- Store raw files separately from processed data

### Step 2: Python Cleaning & Validation
- Remove suppressed and invalid MSPB scores
- Filter to **MSPB-1** measure only
- Convert numeric and categorical fields
- Validate row counts before and after cleaning

### Step 3: Load to SQL Server
- Use SQLAlchemy engine to load cleaned datasets
- Enables repeatable, automated ingestion

### Step 4: SQL Modeling
- Create a canonical MSPB base view (1 row per hospital)
- Engineer derived metrics and efficiency tiers
- Deduplicate hospital records prior to joins
- Build analytical views for Power BI consumption

### Step 5: Power BI Reporting
- Connect directly to SQL views
- Build executive dashboards
- Validate metrics against SQL results

---

## 🧠 Data Modeling Highlights

### Deduplication Strategy

CMS hospital datasets can contain multiple records per Facility ID.  
If not handled, joins inflate metrics and distort insights.

This project uses:

- `ROW_NUMBER()` partitioned by Facility ID
- Deterministic row selection
- One-row-per-hospital enforcement

This ensures:
- Accurate KPIs
- Correct averages
- Reliable dashboards

---

### KPI Engineering

A dedicated KPI view ensures:
- One-row summary dataset
- Exact numeric reporting (no “K” abbreviations)
- Consistent executive metrics across visuals

---

## 📈 Dashboard Pages

### Executive Overview
- Total hospitals
- Average MSPB
- Hospitals above vs below national average
- Geographic variation via filled U.S. map

### Cost Drivers & Outcomes
- Average MSPB by quality rating
- Average MSPB by ownership type
- Top high-spending hospitals
- Top cost-efficient hospitals
- Executive insight summary

---

## 🔍 Key Insights

- Medicare spending varies significantly by state
- Higher spending does **not** consistently result in better quality ratings
- Ownership structure explains more spending variation than quality alone
- A small subset of hospitals drives extreme cost inefficiencies

---

## 📁 Repository Structure

- `/python` — Data ingestion and cleaning scripts  
- `/sql` — SQL Server views and transformations  
- `/powerbi` — Power BI report files and screenshots  
- `/data` — Raw and processed datasets (if shareable)  
- `README.md` — Project documentation  

---

## ▶️ How to Run

1. Execute Python ETL scripts to clean and load data into SQL Server  
2. Run SQL scripts to build analytical views  
3. Open Power BI report and refresh from SQL Server  

---

## 🚀 Future Enhancements

- Add multi-year MSPB trend analysis
- Incorporate additional CMS quality measures
- Extend analysis to episode-level cost drivers
- Add hospital-level drill-through dashboards

---

## 👤 Author

**Kishor Khatiwada**  
Data Analytics | Business Intelligence | Healthcare Analytics
