# Unit 1 Summary — TheLook eCommerce Analysis  
**Author:** Anishka Pateriya  
**Dataset:** BigQuery Public Dataset — `thelook_ecommerce`  

---

## What I Found
Using data from Google’s `thelook_ecommerce` dataset, I explored the company’s recent performance through a series of SQL and Python analyses. The focus was on identifying growth trends, customer behavior, and product-specific insights.  
The 3 Key performance indicators (KPIs) that I identified were:
- **Total Orders per Month**
- **Monthly Revenue**
- **Unique Customers per Month**

From these analyses, several patterns emerged:
- **Revenue and orders** have been steadily increasing over time.  
- **Average Order Value (AOV)** and **Repeat Purchase Rate** suggest a healthy base of returning customers.  
- The **“Tops & Tees”** category stood out for its seasonal variability, often peaking during summer months. However, this trend was not perfectly consistent each year, suggesting external factors may influence demand.  

To better interpret category performance amidst overall growth, I refined the metric from total sales to **percentage of total sales** for each category.

---

## What Changed After Validation
During the analysis, I encountered incorrect outputs when calculating the **percentage of “Tops & Tees” orders by location** — some values exceeded 100%. Recognizing the error, I revised the query logic to ensure the percentage of category orders could never surpass total orders.  
This correction validated that:
- Location-based percentages were computed correctly.  
- Subsequent visualizations and insights accurately reflected realistic business performance.  
I also incorporated **CTEs and window functions** to streamline queries and improve accuracy, and confirmed timestamp data types before plotting to ensure consistency across analyses.

---

## What I Propose
Based on the findings, I recommend the following actions:

1. **Marketing Optimization**  
   - Prioritize advertising on **Chrome browsers**, which account for the majority of “Tops & Tees” purchases.  
   - Focus campaigns on **Email and AdWords** channels, as they generate the highest conversion rates.  
   - To expand reach, increase targeted efforts on **YouTube** and **Facebook**, which currently underperform but show potential.

2. **Strategic Focus**  
   - Continue tracking **relative category performance (% of total sales)** rather than raw counts to better capture true growth.  
   - Investigate the **drivers behind summer sales peaks**, such as promotions or geographic effects.  
   - Use these insights to **forecast demand** and **allocate ad budgets seasonally** for higher ROI.

---

**In summary**, this analysis provides a foundation for understanding sales growth, validating analytical accuracy, and developing actionable marketing and product strategies grounded in data from TheLook eCommerce dataset.
