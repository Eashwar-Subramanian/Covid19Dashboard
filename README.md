# COVID-19 Analysis (SQL + Tableau Prep Outputs)

SQL exploration queries and Tableau preparation outputs for analyzing COVID-19 deaths and vaccination trends.

## What’s in this repo
- Two SQL scripts:
  - `Covid Project MySql.sql` — exploration queries + view creation
  - `Covi19fortableau.sql` — extracts/prep queries for Tableau-ready tables
- Four prepared Excel tables:
  - `Tableau Table 1.xlsx`
  - `Tableau Table 2.xlsx`
  - `Tableau Table 3.xlsx`
  - `Tableau Table 4.xlsx`

## Notes about expected table names (from the SQL scripts)
The SQL queries reference tables/views including:
- `covid19death`
- `covid_vaccination`
- Views created/used in the workflow such as `PopvsVac` and `PercentPopulationVaccinated`

## How reviewers can evaluate quickly
1) Open `Covid Project MySql.sql` and scan:
   - table usage, joins, and view logic
2) Open `Covi19fortableau.sql` and scan:
   - extract logic and how the output tables are shaped for Tableau
3) Open the Excel tables to see what the Tableau inputs look like

## Feedback I want
Open a GitHub Issue titled: **Review: covid-data-analysis-sql-tableau** and tell me:
1) Whether the queries are readable and consistently structured  
2) Whether naming/comments make sense to a non-author  
3) What you’d change to make this repo “hiring-review ready”
