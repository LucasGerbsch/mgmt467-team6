**Leonard Chiu, Anishka Patiya, Lucas Gerbsch, Eugene Chi**



**The Business Problem:**

We will build a real-time social media sentiment analysis system that helps marketing and product teams detect changes in public sentiment about our top product within minutes. The system will surface urgent negative trends for rapid response, automatically tag high-impact posts (such as ones with high follower counts or high engagement), and provide historical context so product managers can prioritize bug fixes, feature improvements, and PR responses.



**Data Sources:**

Batch (historical):

historical\_twitter\_100k.csv — 100,000 historical tweets collected between 2023-01-01 and 2024-12-31. Columns: post\_id, created\_at (ISO 8601 UTC), user\_id, text, label\_sentiment (negative|neutral|positive), platform, language, retweet\_count, like\_count, reply\_count, user\_followers, user\_account\_age\_days.

Stored in: Cloud Storage bucket gs://final-project-aurora-data/historical/.

Streaming (live):

Twitter/X API v2 — filtered stream (Bearer token): provides live public tweets matching brand-related rules. Stream fields: id, created\_at, text, author\_id, lang, public\_metrics (retweets, likes, replies), geo (where available).

Optional vendor stream (Brandwatch / Meltwater / Mention): webhook pushing brand mentions to our ingestion endpoint for broader coverage beyond Twitter. For compliance and privacy, we will only store and process public posts and will follow platform TOS. Any PII (personal data in text) will be redacted before persistent storage and flagged for manual review if required.



**Cloud Architecture (Design):**



GCP Project \& Resources (concrete names used in our build):



GCP Project ID: final-sentiment-aurora-2025



Cloud Storage bucket: gs://final-project-aurora-data



BigQuery dataset: final\_project\_aurora



Pub/Sub topic: projects/final-sentiment-aurora-2025/topics/twitter-stream



Dataflow job name prefix: aurora-dataflow-.



Ingest (Streaming + Batch):



Historical CSV historical\_twitter\_100k.csv uploaded to gs://final-project-aurora-data/historical/ and loaded once into BigQuery table final\_project\_aurora.raw\_twitter\_posts using a one-time bq load job.

Live tweets arrive via Twitter filtered stream. A lightweight ingestion service runs on Cloud Run (twitter-ingest) that establishes the persistent connection (or receives webhook events from vendor streams). The service publishes incoming JSON messages to Pub/Sub topic twitter-stream.



Stream buffer \& pre-processing:



Pub/Sub acts as durable buffer and decouples ingestion from processing. 

Topics:



\- twitter-stream (primary) and twitter-stream-deadletter (DLQ).



\- Dataflow (Apache Beam, streaming) job aurora-dataflow-clean subscribes to twitter-stream. 



Responsibilities:



Validate incoming JSON schema and route malformed messages to the DLQ.

Normalize timestamps to UTC and parse language tags.

Compute lightweight features: text\_length, has\_hashtag (bool), has\_mention (bool), has\_url (bool), hashtags\_count, mentions\_count, is\_retweet.

Enrich with user metadata if available (followers count, account age), and compute engagement\_score = retweet\_count\*1 + reply\_count\*1.5 + like\_count\*0.5.

Batch and buffer inserts to BigQuery for cost-effectiveness.



ML enrichment \& scoring:

Primary sentiment scoring happens in two parallel paths:

Low-latency path: Dataflow calls a lightweight local BQML microservice (deployed as a prediction endpoint in BigQuery or Cloud Run) for immediate sentiment prediction for every message (used for dashboarding and alerts). This path avoids external API rate limits.

High-fidelity path: A sampled subset (configurable, default 20%) and high-impact posts (e.g., user\_followers > 10000 or engagement\_score > 50) are sent to the Natural Language AI API for richer sentiment scores and entity extraction. Results are merged back into BigQuery for model training and deep analysis.



Storage \& serving:

Processed streaming records written to BigQuery table final\_project\_aurora.processed\_tweets (partitioned by DATE(created\_at) and clustered by label\_sentiment, platform). Use streaming inserts with fallback to batched load via Cloud Storage for resilience.

Historical CSV data initially loaded into final\_project\_aurora.historical\_tweets and then normalized into the processed table schema.



Modeling \& retraining:

Use BigQuery ML to train the baseline classification model final\_project\_aurora.models.sentiment\_bqml\_v1 (see SQL example below).

Model retraining cadence: weekly (every Sunday 02:00 UTC) triggered by Cloud Scheduler invoking a Cloud Function which executes a CREATE OR REPLACE MODEL BigQuery job. Retrain earlier if data drift is detected.



Visualization \& alerting:

Looker Studio dashboard named Aurora Sentiment Monitor connects directly to BigQuery (final\_project\_aurora.processed\_tweets) for live visualizations.

Cloud Monitoring / Alerting: alert rules defined for operational metrics (Dataflow lag > 5 minutes, Pub/Sub unacked messages > threshold) and business KPIs (negative % in 15-min window > 30%). Alerts sent to Slack channel #aurora-alerts and PagerDuty.



Concrete example BigQuery table names and model names:



final\_project\_aurora.raw\_twitter\_posts (raw records)



final\_project\_aurora.processed\_tweets (cleaned+enriched records)



final\_project\_aurora.labels.manual\_labeled (human-labeled samples for evaluation)



**Machine Learning Plan (BigQuery ML)**



Problem formulation:



Primary task: Multiclass classification to predict label\_sentiment in {negative, neutral, positive} for each post.



Secondary task (optional): Regression to predict continuous sentiment score in \[-1,1] if we want finer-grained scoring.



Training data and split:



Use the 100k historical tweets (historical\_twitter\_100k.csv) as the primary labeled dataset.



Supplement training data with human-labeled streaming samples kept in labels.manual\_labeled (target 5,000 labeled streaming samples gathered over the first 6 weeks).



Train/val/test split: 80/10/10.



Features (final, concrete list):



text\_length (int)



hashtags\_count (int)



mentions\_count (int)



user\_followers (int)



engagement\_score (float)



platform (string / categorical)



language (string / categorical)



hour\_of\_day (int)



day\_of\_week (int)



has\_negative\_keyword (boolean)



avg\_sentiment\_last\_15m (float) — rolling feature computed by scheduled SQL or within Dataflow windowing (optional)



embedding\_vector (REPEATED FLOAT) — optional; precomputed embeddings stored in a separate table and joined if required.



Model selection \& evaluation:



Baseline: boosted\_tree\_classifier in BQML.



Evaluation metrics: accuracy, precision/recall per class, macro F1, and confusion matrix. Store eval results in final\_project\_aurora.model\_evals.

Use ML.EXPLAIN to surface top features driving predictions.



Retraining \& deployment:

Retrain weekly or when drift detected (automatic detection via statistical tests comparing recent vs baseline distributions stored in BigQuery).

Deploy predictions by writing to table final\_project\_aurora.predictions\_streaming and exposing a prediction summary table optimized for Looker Studio.



**Dashboard KPIs (Looker Studio):**



Dashboard name: Aurora Sentiment Monitor



Real-time Sentiment Score (15-min rolling average) — rolling mean sentiment score (or % positive minus % negative) with 1–5 minute latency.

Alert threshold: negative % in last 15 minutes > 30% triggers a page-level alert and Slack notification.

Mentions Volume (posts/hour) — total incoming posts mentioning tracked keywords; helps separate volume spikes from sentiment shifts.



Example alert: mentions/hour increases by >300% relative to baseline.



Sentiment Distribution — stacked bar / donut showing % positive / neutral / negative for selected time window.

Top Negative Themes — table of top 10 keywords/entities associated with negative posts (counts \& examples).

Model Health \& Data Drift — sample model accuracy (from labeled streaming samples), and a drift indicator (e.g., KL divergence for text length or language distribution vs baseline).





Devil's advocate prompt: 



Biggest risk: Relying on external streaming APIs (Twitter/X) and the Natural Language API for high-fidelity scoring creates two correlated single points of failure: (1) data coverage and continuity risk (API outages, access revocations, or rule pruning), and (2) cost/latency risk from third-party scoring at scale.



Mitigations (concrete):



-Multi-source ingestion: Subscribe to multiple sources (Twitter filtered stream + vendor webhook) so coverage isn't dependent on one provider. Maintain a buffer of historical data for fallback.

-Graceful fallback model: Deploy a locally hosted BQML/Cloud Run prediction endpoint (the sentiment\_bqml\_v1 model) as the default scorer. Only call the Natural Language AI API for sampled or high-impact records.

