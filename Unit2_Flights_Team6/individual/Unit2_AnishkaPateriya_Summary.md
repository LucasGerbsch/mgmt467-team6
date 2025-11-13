What I Learned

Regression (Arrival Delay):

Built a LINEAR_REG model to predict arrival delay (arr_delay) using features like departure delay, distance, route, and day of week.

The model’s MAE = 9.25 minutes, meaning predictions are on average 9 minutes off from actual arrival times.

This level of accuracy is useful for resource planning such as gate and crew scheduling.

Top factors influencing delay were departure delay, distance, and route.

Classification (Diverted Flights):

Built a LOGISTIC_REG model to predict whether a flight would be diverted.

The dataset was extremely imbalanced—only about 0.23% of flights were diverted.

The model predicted no diversions (precision and recall were both 0.0).

Even after adding engineered features (route, day_of_week, and delay buckets), performance did not improve.

Where the Model Failed

The classification task failed due to class imbalance and missing external factors like weather or emergencies.

Threshold adjustments did not help because predicted diversion probabilities were extremely low.

Threshold to Deploy

The current model should not be deployed since it fails to detect diversions.

For a future version, a lower threshold (around 0.25) could be tested after balancing the data.

Operationally, it’s better to have false alarms than to miss true diversions, since missed diversions cause major disruptions.

Key Takeaways

The regression model performs well enough for planning purposes.

The classification model needs re-training with balanced data and better features.

If re-trained, the threshold should be chosen to prioritize recall for timely diversion response.
