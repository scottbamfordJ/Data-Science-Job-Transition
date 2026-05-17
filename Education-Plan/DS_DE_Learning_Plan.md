# Data Science & Data Engineering Learning Plan
**Scott Bamford — May 2026**

> A 6-month plan to pivot from a Developer/AI Engineer background into Data Science and Data Engineering roles. Assumes ~1 hour/day on weekdays.

---

## Timeline Overview

| Milestone | Date |
|---|---|
| Start | May 2026 |
| Phase 1 complete | Aug 2026 |
| Phase 2–3 complete | Nov 2026 |
| Job-ready | Dec 2026 |

---

## Phase 1 — Foundation: SQL Depth + dbt + Airflow
**Weeks 1–10 | May – Aug 2026**

The fastest path to Analytics Engineer roles. These tools are table stakes and can be learned quickly with consistent practice.

### What to Learn

**Advanced SQL**
- Window functions (ROW_NUMBER, RANK, LAG/LEAD, PARTITION BY)
- CTEs and recursive queries
- Query optimization and execution plans
- Snowflake-specific syntax and best practices
- Partitioning and clustering strategies

**dbt (data build tool)**
- Models, sources, seeds, and snapshots
- Tests (schema tests, custom tests)
- Jinja templating and macros
- Documentation and the dbt DAG
- dbt Cloud vs dbt Core
- Incremental models

**Airflow**
- DAGs and task structure
- Operators (Python, Bash, SQL)
- Scheduling and dependencies
- XComs and task communication
- Connections and hooks
- Error handling and retries

**Data Modeling**
- Star schema and snowflake schema
- Dimensional modeling (Kimball methodology)
- Slowly changing dimensions (SCD Type 1, 2, 3)
- Fact vs dimension tables
- Data vault basics

### Resources

| Resource | Link | Cost |
|---|---|---|
| Mode SQL Tutorial | https://mode.com/sql-tutorial/ | Free |
| StrataScratch SQL Practice | https://www.stratascratch.com | Free tier |
| dbt Learn (official courses) | https://courses.getdbt.com | Free |
| dbt Documentation | https://docs.getdbt.com | Free |
| Airflow Documentation | https://airflow.apache.org/docs/ | Free |
| The Complete Airflow Course (Udemy) | https://www.udemy.com/course/the-complete-hands-on-course-to-master-apache-airflow/ | Paid (~$15 on sale) |
| Kimball Dimensional Modeling Techniques | https://www.kimballgroup.com/data-warehouse-business-intelligence-resources/kimball-techniques/dimensional-modeling-techniques/ | Free |

### Goal by Aug 2026
Build a dbt project on a public dataset (e.g. NYC taxi data or Citibike) with Airflow scheduling. Push to GitHub with a clean README.

---

## Phase 2 — Python Data Stack + ML Fundamentals
**Weeks 11–18 | Aug – Oct 2026**

Build on your existing Python knowledge. Go deeper into data manipulation and modeling with a business problem focus.

### What to Learn

**Python Data Stack**
- Pandas at scale — advanced groupby, merges, reshaping, memory optimization
- NumPy for numerical computing
- Polars (fast-growing alternative to Pandas — worth knowing)
- Data wrangling best practices and reproducible notebooks

**ML Modeling**
- Regression (linear, logistic, ridge/lasso)
- Classification (decision trees, random forests, gradient boosting)
- Clustering (k-means, DBSCAN)
- Train/test splits and cross-validation
- Hyperparameter tuning (GridSearch, RandomSearch)
- Pipelines in Scikit-learn

**Model Evaluation**
- Confusion matrices, precision, recall, F1
- ROC curves and AUC
- RMSE, MAE for regression
- Feature importance and SHAP values
- Avoiding data leakage

**Experimentation & Statistics**
- A/B test design and sample size calculation
- Statistical power and significance
- Confidence intervals and p-values
- Applied to real business problems (conversion rates, revenue impact)

### Resources

| Resource | Link | Cost |
|---|---|---|
| Kaggle Learn | https://www.kaggle.com/learn | Free |
| Scikit-learn Tutorials | https://scikit-learn.org/stable/tutorial/ | Free |
| Introduction to Statistical Learning (ISLR) | https://www.statlearning.com | Free PDF |
| Pandas Documentation | https://pandas.pydata.org/docs/ | Free |
| Udacity A/B Testing Course | https://www.udacity.com/course/ab-testing--ud257 | Free |
| Real Python | https://realpython.com | Free + paid |

### Goal by Oct 2026
Complete one end-to-end ML project — frame a business problem (churn prediction, pricing model, demand forecasting), build and evaluate a model, write it up as a GitHub repo with a README, architecture notes, and results summary.

---

## Phase 3 — Streaming + Cloud-Scale Data Engineering
**Weeks 19–24 | Oct – Nov 2026**

Rounds out your DE profile and differentiates you from analytics-only candidates. Your StreamSets background gives you a head start here.

### What to Learn

**Kafka / Streaming**
- Producers, consumers, and topics
- Partitions, offsets, and consumer groups
- Kafka Connect and Kafka Streams
- Real-time pipeline design patterns
- At-least-once vs exactly-once delivery

**Spark / PySpark**
- PySpark DataFrames and transformations
- Spark SQL
- Running Spark on Databricks
- Spark Structured Streaming basics
- Performance tuning (partitioning, caching, shuffles)

**Cloud DE Patterns**
- AWS Glue + S3 (you already have this — deepen it)
- Databricks lakehouse architecture
- Snowflake architecture and Snowpark
- Data lakehouse patterns (Delta Lake, Iceberg)

**Pipeline Architecture**
- Medallion architecture (bronze / silver / gold layers)
- Idempotency and backfills
- SLAs, monitoring, and alerting
- Data quality checks in production

### Resources

| Resource | Link | Cost |
|---|---|---|
| Confluent Kafka Developer Training | https://developer.confluent.io/learn-kafka/ | Free |
| Databricks Academy | https://www.databricks.com/learn/training/home | Free |
| PySpark Documentation | https://spark.apache.org/docs/latest/api/python/ | Free |
| Apache Spark with Python (Udemy) | https://www.udemy.com/course/apache-spark-programming-in-python-for-beginners/ | Paid (~$15 on sale) |
| Snowflake Snowpark Docs | https://www.snowflake.com/en/data-cloud/snowpark/ | Free |

### Goal by Nov 2026
Build a mini streaming pipeline — ingest a real-time data source (e.g. a public API like OpenWeather or NYC MTA), process with Kafka or Spark, land in a warehouse. Document and push to GitHub.

---

## Phase 4 — Portfolio + Job Prep
**Weeks 25–26 | Dec 2026**

Polish, certify, and apply. Two focused weeks to turn your work into a compelling story.

### What to Do

**Certifications (pick 1–2)**
- dbt Certified Developer — https://www.getdbt.com/certifications
- Databricks Data Engineer Associate — https://www.databricks.com/learn/certification
- AWS Cloud Practitioner (if not already) — https://aws.amazon.com/certification/certified-cloud-practitioner/
- Snowflake SnowPro Core — https://www.snowflake.com/certifications/

**Interview Prep**
- SQL interview questions on StrataScratch and LeetCode (focus on window functions and multi-table joins)
- Take-home case study practice (Kaggle competitions are good proxies)
- Data system design basics — how to design a pipeline end-to-end
- Know how to explain your GitHub projects clearly and concisely

**Portfolio Cleanup**
- 3 pinned GitHub repos with clean READMEs
- Each README should include: problem statement, data source, architecture diagram, approach, and results
- Add architecture diagrams (Excalidraw or Mermaid in the markdown itself)

**Networking**
- Join the dbt Slack community — https://www.getdbt.com/community/join-the-community
- Attend NYC data meetups — https://www.meetup.com/topics/data-engineering/us/ny/new-york/
- LinkedIn outreach to Analytics Engineers and Data Engineers at companies you want to work at

### Goal by Dec 2026
3 polished GitHub projects, 1–2 certifications completed, actively applying to Analytics Engineer and Data Engineer roles.

---

## GitHub Strategy — @scottbamfordJ

**3 pinned projects, quality over quantity.**

### Project 1 — dbt + Airflow Pipeline (Phase 1)
- Use a public dataset: NYC Taxi, Citibike, or similar
- Build dbt models with staging, intermediate, and mart layers
- Schedule with Airflow DAGs
- Include a data model diagram in the README

### Project 2 — End-to-End ML Project (Phase 2)
- Frame a real business problem: churn prediction, revenue forecasting, pricing model
- Include EDA, feature engineering, model training, and evaluation
- Document your decisions and tradeoffs
- Show metrics clearly (not just "I built a model")

### Project 3 — Streaming Pipeline (Phase 3)
- Real-time API → Kafka or Spark → warehouse
- NYC MTA real-time data or OpenWeather API are good free options
- Include an architecture diagram
- Document the medallion layers if applicable

### General GitHub Tips
- Commit regularly — hiring managers look at activity. Even small daily commits count.
- Write READMEs like you're explaining the project to a hiring manager who has 2 minutes.
- Add a `requirements.txt` or `pyproject.toml` to every Python project.
- Use `.env.example` files so people can see what credentials are needed without exposing yours.

---

## What You Already Have (Don't Need to Rebuild)

- Python — foundational, just needs deepening
- SQL & databases — strong (Snowflake, Postgres, BigQuery, etc.)
- Cloud platforms — AWS, GCP, Azure experience
- ETL & data pipelines — StreamSets, AWS Glue/S3/Lambda
- A/B testing & hypothesis testing — from MS and StreamSets work
- Dashboarding — Tableau, some Looker
- LLM/AI engineering — increasingly valued in DS roles
- MS in Quantitative Methods — strong academic foundation

---

## Honest Timeline Note

This plan assumes ~1 hour of focused learning on weekdays. If you can add weekend sessions, you could compress Phases 1 and 2 to 3 months and be job-ready by October 2026 instead of December.

The single highest-leverage first step: **start dbt this week**. It's free, widely used, and immediately makes you hireable as an Analytics Engineer — the natural bridge role between your current developer background and a full DS/DE title.

