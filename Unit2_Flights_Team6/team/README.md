Team 6 Assignment 2 US Flight Data README

https://www.kaggle.com/datasets/mexwell/carrier-on-time-performance-dataset

Assumptions: This dataset contains all real flight data from the Bureau of Transportation from the United States as is stated on the Kaggle page.

Questions we're trying to answer:
1. What is the MAE of flights' arrival delay and how does this affect staffing and scheduling?
2. Can we classify when a flight will be diverted to better be prepared?

Steps:
1. Download the dataset from the link
2. Create a GCS bucket and upload the dataset
3. Create a dataset in BigQuery and create a table using the GCS bucket with the dataset

Linear Regression:
1. Pick 5 features to train a Linear Regression Model with to estimate arrival delay
2. Investigate the MAE
3. Create 2 Explain_Predict examples to test your model

Classification:
1. Train a classification model to predict flight delay using 5 features
2. Retrain the model using your own decided cutoff threshold
3. Compare the performance

Feature Engineering:
1. Engineer a new feature and compare performance

Limit:
1. Take a limited sample of the data and compare it to the full run model. What do you notice?
