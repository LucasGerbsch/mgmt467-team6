Team 6 Assignment 2 US Flight Data README

https://www.kaggle.com/datasets/mexwell/carrier-on-time-performance-dataset

Assumptions: This dataset contains all real flight data from the Bureau of Transportation from the United States as is stated on the Kaggle page.

Questions we're trying to answer:
1. What is the MAE of flights' arrival delay and how does this affect staffing and scheduling?
2. Can we classify when a flight will be diverted to better be prepared?

Steps:
Download the dataset from the link
Create a GCS bucket and upload the dataset
Create a dataset in BigQuery and create a table using the GCS bucket with the dataset

Linear Regression:
Pick 5 features to train a Linear Regression Model with to estimate arrival delay
Investigate the MAE
Create 2 Explain_Predict examples to test your model

Classification:
Train a classification model to predict flight delay using 5 features
Retrain the model using your own decided cutoff threshold
Compare the performance

Feature Engineering:
Engineer a new feature and compare performance

Limit:
Take a limited sample of the data and compare it to the full run model. What do you notice?
