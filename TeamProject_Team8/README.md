**Project:**
This is our capstone project for Purdue MGMT 467 - AI-Assisted Big Data Analytics in the Cloud. This project required us to build a streaming data pipeline that allowed us to create real-time analytics dashboards in Looker Studio. Our team chose to predict New York City CitiBike daily trips for the next 7 days using real-time Open-Meteo API weather forecasts through 2 regression models that we trained using CitiBike trip data and Open-Meteo forecasts from 2022-2024.

**What's in the repo:**
*BQ\
  *Historical_API_Data_Retrieval_and_Model_Training_Notebook: Notebook we used to pull historical data from the archive Open-Meteo API and put it in GCP, then trained the ML model with it.\
  *SQL: Contains all of our SQL queries we used in BigQuery over the course of the project.\
*Dashboards\
  *Historical dashboard screenshot: Screenshot of historical dashboard that displays 2022-2024 trends and insights.\
  *Real-time dashboard screenshot: Screenshot of an instance of our live streaming dashboard that displays current 7 day trip predictions and forecast details.\
  *kpis.md: Document explaining the different graphs and metrics displayed along with their meaning.\
*Docs\
  *Blueprint.PDF: Initial blueprint we had for our project during conceptualization.\
  *Data Governance: Discusses ethical concerns, data privacy, and data assumptions.\
  *Individual Contrbutions: What each team member completed for this project.\
  *ops_runbook.md: Full top to bottom instructions on how to replicate the project and how to close the pipeline when done\
  *ops_runbook Required Files Folder: All of the template files referenced and used in the instructions to replicate the pipeline.\
*Notebooks: Individual exploratory data analysis and pipeline validating/testing.\
*Pipeline\
  *Dataflow\
    *Dataflow Job Graph: Screenshot of our Dataflow Job running.\
    *Streaming BQ Table Screenshot: Screeshot of our final streaming output table that's displayed within our live dashboard with the most recent ingestion time.\
    *Template Parameters Document: Specifications for our Dataflow job and selected template.\
  *Function\
    *main.py: Main.py file used in Cloud Run function.\
    *requirements.txt: requirements.txt used in Cloud Run function.\
  *Infrastructure\
    *Cloud Architecture Diagram: Architecture diagram for the streaming pipeline process.\
    *Historical Architecture Diagram: Architecture diagram for the data collection, cleaning, and model training.\
    *Infrastructure Setup Docment: Document that details gcloud/gsutil commands and APIs required for the project.
