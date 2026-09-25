# Hospital Patient Records — Data Analysis Project

## 📌 Project Overview

This project analyzes synthetic hospital patient records to uncover insights into hospital encounters, healthcare costs, insurance coverage, and patient readmission behavior.

The project was completed using **MySQL** for data analysis and **Power BI** for interactive data visualization.

The analysis covers hospital records from **2011 to 2022** and focuses on three main areas:

1. Encounters Overview
2. Cost & Coverage Insights
3. Patient Behavior Analysis

---

## 🛠️ Tools & Technologies

* **MySQL** — data querying and analysis
* **Power BI** — interactive dashboards and visualization
* **SQL** — aggregation, filtering, grouping, joins, window functions
* **DAX** — calculated columns and measures in Power BI
* **VS Code** — SQL development and project organization
* **Git & GitHub** — version control and project sharing

---

## 📊 Project Objectives

### Objective 1 — Encounters Overview

The analysis answers:

* How many encounters occurred each year?
* What percentage of encounters belonged to each encounter class each year?
* What percentage of encounters lasted more than 24 hours versus 24 hours or less?

Encounter classes include:

* Ambulatory
* Emergency
* Inpatient
* Outpatient
* Urgent Care
* Wellness

---

### Objective 2 — Cost & Coverage Insights

The analysis investigates:

* How many encounters had zero payer coverage and what percentage of total encounters they represent?
* What were the 10 most frequently performed procedures and their average base costs?
* Which 10 procedures had the highest average base costs?
* What was the average total claim cost for each payer?

---

### Objective 3 — Patient Behavior Analysis

The analysis examines:

* How many unique patients were admitted during each quarter over time?
* How many patients were readmitted within 30 days of a previous encounter?
* Which patients had the highest number of readmissions?

The readmission analysis uses SQL window functions to compare a patient's encounters over time and identify subsequent inpatient encounters occurring within 30 days of a previous encounter.

---

## 📈 Power BI Dashboard

The Power BI report contains three pages corresponding to the three project objectives.

### 1. Encounters Overview

Includes:

* Total encounters by year
* Encounter class distribution by year
* Encounter duration analysis

![Encounters Overview](screenshots/1_encounter_overview.png)

### 2. Cost & Coverage

Includes:

* Encounters with zero payer coverage
* Top 10 most frequent procedures
* Top 10 procedures by average base cost
* Average total claim cost by payer

![Cost & Coverage](screenshots/2_cost_coverage.png)

### 3. Patient Behavior

Includes:

* Unique patients admitted by quarter
* Patients readmitted within 30 days
* Patients with the highest number of readmissions

![Patient Behavior](screenshots/3_patient_behavior.png)

---

## 🗂️ Repository Structure

```text
hospital-patient-records/
│
├── README.md
│
├── sql/
│   ├── objective_1_encounters.sql
│   ├── objective_2_cost_coverage.sql
│   └── objective_3_patient_behavior.sql
│
├── powerbi/
│   └── hospital_patient_records.pbix
│
└── screenshots/
    ├── 1_encounter_overview.png
    ├── 2_cost_coverage.png
    └── 3_patient_behavior.png
```

---

## 🔍 SQL Skills Demonstrated

This project demonstrates practical SQL skills including:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `ORDER BY`
* `COUNT`
* `COUNT(DISTINCT ...)`
* `AVG`
* `ROUND`
* `CASE`
* `JOIN`
* Subqueries
* Window functions
* `LAG()`
* Date and time calculations
* Aggregation and percentage calculations
* Top-N analysis

---

## 📊 Power BI Skills Demonstrated

The Power BI dashboard demonstrates:

* MySQL data connection
* Data modeling
* Relationships between tables
* Calculated columns
* DAX measures
* KPI cards
* Line charts
* Bar charts
* 100% stacked charts
* Donut charts
* Filtering and sorting
* Dashboard design

---

## 💡 Key Learning Outcomes

Through this project, I practiced transforming raw relational healthcare data into meaningful analytical insights.

The project strengthened my understanding of:

* Relational databases
* SQL analytical queries
* Aggregations and business metrics
* Window functions
* Date-based analysis
* Healthcare data analysis
* Data visualization
* Building an end-to-end analysis workflow from database to dashboard

---

## 📁 Dataset

The project uses synthetic hospital patient records provided for educational analysis.

The dataset contains information related to:

* Patients
* Payers
* Encounters
* Procedures


---

## 🚀 Project Workflow

```text
Raw Hospital Data
       ↓
     MySQL
       ↓
SQL Analysis
       ↓
   Power BI
       ↓
Interactive Dashboard
       ↓
Healthcare Insights
```
