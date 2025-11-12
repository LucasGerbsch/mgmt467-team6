This project focuses on developing and evaluating a Logistic Regression model in BigQuery ML 

to predict flight diversions, a rare but costly operational issue. The baseline model, trained on basic flight parameters, achieved high overal accuracy \(0.9977\) but zero precision and recal for predicting diversions, reflecting the difficulty of modeling such an infrequent event. Despite this, a ROC AUC of 0.7179 indicated that the model could stil rank flights by diversion risk, even though it failed to classify true diversions at the default threshold. These results highlight the importance of feature engineering when addressing extreme class imbalance. To improve model performance, new features such as route, which captures airport pair risk, and 

dep\_delay\_bucketized, which accounts for non-linear delay effects, were introduced. However, the engineered model failed to train due to a SQL syntax error \(“Unexpected keyword 

CREATE”\), preventing evaluation at this stage. 

Moving forward, resolving this structural issue is essential to assess the engineered model’s effectiveness. Once trained, it is expected that these added features wil enhance the model’s ability to identify high-risk flights and yield improved ROC AUC, precision, and recal scores. A key next step involves threshold tuning and business-driven calibration to determine an acceptable false negative rate, balancing the operational costs of false alarms versus missed diversions to inform a practical deployment strategy. 

Addressing the class imbalance inherent in diversion prediction wil be crucial for the next phase. Given that the positive class \(diversion\) constitutes less than 0.3% of the data, conventional accuracy metrics are misleading. Therefore, the focus wil remain on metrics like ROC AUC, which assesses the model's ability to rank risks, and especial y Precision and Recal for the positive class. The failure of the initial model to achieve non-zero Precision and Recal underscores the need for strategic feature selection and the potential implementation of sampling techniques \(e.g., SMOTE or undersampling the majority class\) or cost-sensitive learning within the BigQuery ML framework, if supported. 



After successful y training the engineered model by correcting the SQL syntax, a comparative analysis wil be performed against the baseline model. This comparison wil specifical y examine the uplift in ROC AUC, and the ability to achieve a meaningful trade-off between Precision and Recal . Furthermore, the weights assigned to the newly introduced features \(route and dep\_delay\_bucketized\) wil be analyzed to gain domain-relevant insights into the driving factors of flight diversion risk. The ultimate goal is to move beyond mere ranking and develop a classification model that can reliably flag a useful number of actual diversions without generating an unmanageable volume of false alarms. This practical utility hinges entirely on the forthcoming results of the feature-engineered model.



