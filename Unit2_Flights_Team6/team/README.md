Team 6 Assignment 2 README

https://www.kaggle.com/datasets/mexwell/carrier-on-time-performance-dataset

Assumptions: 
We assume that all of this flight data is from the U.S. as is stated on the Kaggle page.

Steps to reproduce:

Download the dataset from the Kaggle link
Upload the dataset to a GCS bucket.
Create a dataset within BigQuery
Create a table in the dataset and reference the GCS bucket to upload the dataset
Create a new Colab file
Authenticate and set the path using your project ID, region, and table path

Business Questions:
-Regression: Can we estimate arrival delay minutes (arr_delay) from operational signals to improve resource planning?
-Classification: Can we classify the probability a flight is diverted to improve disruption response?

Tasks:
Regression (arr_delay):
Train a LINEAR_REG model (CREATE MODEL) using at least 5 features (e.g., dep_delay, distance, carrier, origin, dest, dayofweek).
Evaluate with ML.EVALUATE; explain MAE in business terms.
Show ML.EXPLAIN_PREDICT for two hypothetical flights and interpret top features.

Classification (diverted):
Train LOGISTIC_REG to predict diverted (BOOLEAN).
Report precision, recall, and confusion matrix.
Re-score using a custom threshold (e.g., 0.75) and justify the choice from an ops perspective.

Feature Engineering (TRANSFORM):
Retrain classification with a TRANSFORM clause that (a) creates a ‘route’ (origin||'-'||dest), (b) extracts day_of_week from flight date, and (c) bucketizes dep_delay (e.g., early/on-time/minor/moderate/major).
Compare metrics (baseline vs engineered) and state if performance improved and why.
