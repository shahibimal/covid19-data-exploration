# 🌍 Epidemiological Trend Analysis & Clinical KPI Pipeline

### 📌 Project Context
In the real world, data is rarely clean, especially when it comes from global health reporting. This project was born out of a desire to move beyond "basic tracking" and into actual **Data Engineering**. I took a massive dataset of global COVID-19 records and built a pipeline to extract meaningful **Key Performance Indicators (KPIs)** that could actually assist in healthcare decision-making.

### 📁 Project Architecture
* **[📂 /sql]** – Contains production-ready scripts. I focused on writing modular T-SQL using **CTEs** and **Window Functions** to ensure the logic is scalable and easy to audit.
* **[📂 /data]** – Cleaned and normalized datasets (originally sourced from Our World in Data).
* **[📂 /dashboard]** – Tableau workbooks that translate thousands of rows into visual stories.

### 🛠️ The Tech Stack
* **MS SQL Server (T-SQL):** The engine used for all heavy lifting—data cleaning, joining disparate tables, and complex aggregations.
* **Tableau:** Used for high-level Business Intelligence (BI) and geospatial mapping.
* **Excel:** Leveraged for initial schema validation and data quality checks.

### 🔍 Engineering Highlights (The "Human" Side)
Instead of just running basic `SELECT` statements, I focused on three engineering challenges:
1. **Clinical Accuracy:** I didn't just calculate "deaths." I engineered **Case Fatality Rates (CFR)** to provide a normalized view of the pandemic's impact across countries with vastly different population sizes.
2. **Rolling Aggregations:** I used **SQL Window Functions** (`OVER`, `PARTITION BY`) to track the velocity of the global vaccination rollout. This allows a viewer to see the "acceleration" of healthcare interventions rather than just a static total.
3. **Optimized Logic:** I utilized **Common Table Expressions (CTEs)** and **Temporary Tables** to create a multi-step ETL process. This keeps the queries efficient and allows for "Schema-on-Read" flexibility when connecting to Tableau.

### 📊 From Data to Insights (The Dashboard)
The SQL output was modeled into an interactive Tableau dashboard. I prioritized three specific "views" for an executive audience:
* **The Global Trend Map:** Identifying real-time hotspots.
* **Survival Correlations:** Visualizing the direct relationship between vaccination milestones and the decline in mortality rates.
* **Healthcare Strain:** Comparing infection rates vs. population density to identify areas at risk of hospital overflow.

**🔗 [Explore the Interactive Dashboard here](https://public.tableau.com/app/profile/bimal.shahi/viz/covid19analysisdashboard/Dashboard1)**

---
*Note: This analysis uses data through 2021. The focus of this repository is to demonstrate professional-grade SQL transformation and Data Storytelling.*
