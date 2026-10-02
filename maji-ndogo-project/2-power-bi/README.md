# Maji Ndogo Water Project: Power BI

This project is the visualisation stage of the Maji Ndogo water project. Building on the SQL analysis, I used Power BI to create interactive reports and a public dashboard to support decision-making and track water infrastructure improvements.

The project consists of four parts, progressing from basic visualisations to data modelling, decision-support reporting, and project progress tracking.

## Folder Structure

```text
power-bi/
├── part-1/   Power BI file (.pbix) and screenshots
├── part-2/   Power BI file (.pbix) and screenshots
├── part-3/   Power BI file (.pbix) and screenshots
├── part-4/   Power BI file (.pbix) and screenshots
└── README.md
```

## Part 1: Exploring the Water Crisis

Created visualisations to explore water access across rural and urban areas, broken infrastructure, queue patterns, gender differences in water collection, and crime around water points.

**Skills:** Data import, visual and page filters, custom shape maps using TopoJSON, DAX measures, sorting, and visual interactions.

## Part 2: Building a Data Model

Connected eight related tables to create a structured data model and rebuilt the reports to analyse water access, queues, well pollution, and crime.

**Skills:** Power Query, data cleaning, table relationships, cardinality, cross-filter direction, fact and dimension tables, and date/time transformations.

## Part 3: Supporting Decision-Making

Designed reports around the information needed by national and provincial leaders. Calculated repair budgets, classified water sources according to basic water access criteria, and compared needs and costs across provinces.

**Skills:** DAX calculated columns and measures, `RELATED`, `CALCULATE`, `FILTER`, `CONTAINSSTRING`, bookmarks, slicers, buttons, and drill-through reports.

## Part 4: Tracking Project Progress

Developed a dashboard to monitor completed improvements, project spending, and budget changes over time. Updated the data source as new project information became available without rebuilding the report.

**Results:** Basic water access increased from **34% to 100%**, while the project finished approximately **5% over budget**.

**Skills:** Time-based measures, running totals, `ALLEXCEPT`, KPI visuals, key influencers analysis, date slicers, and data source updates.

## Tools

Power BI Desktop, Power Query, DAX.
