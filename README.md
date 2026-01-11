# GlowForge Editing Screen Analysis

The goal of the analysis is to understand user behavior inside the editing screen and explore whether early abandonment during editing could explain the reported drop before save.

---

## Contents

- `analysis.sql`  
  SQL queries used for the analysis. Queries are written step by step, starting from basic data checks, session construction, and bounce rate calculations.

- `GlowForge_Editing_Screen_Analysis.pdf`  
  Short report summarizing assumptions, methodology, findings, and recommendations.

---

## Data

The dataset contains editing panel click events.  
Each row represents a user clicking an editing tool inside the editor.

The data does **not** include save events, exits, or crashes.  
Because of this, churn is inferred using simple engagement-based proxies.

---

## Key Assumptions

- One session is approximated as one user per day.
- Session duration is calculated as the time between first and last edit click.
- A bounce session is defined as:
  - ≤ 2 clicks OR
  - session duration < 20 seconds

---

## Tools Used

- SQLite
- SQL (exploratory analysis)
- Excel / Sheets for basic charts

---

## Notes

This repository focuses on clarity and reasoning rather than production-ready pipelines.  
All conclusions are based only on the provided data.

---

## Author

Ahnaf Samin
