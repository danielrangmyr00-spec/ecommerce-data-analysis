E-commerce Delivery Performance Analysis


Project Overview:

This project analyzes transactional e-commerce data to understand how delivery performance impacts customer satisfaction and business value.
The goal was to investigate whether longer delivery times lead to negative customer reviews and how this relates to order value.


Tools Used:

- SQL Server (analysis and feature engineering)

- Python (data ingestion)

- Power BI (visualization and dashboard)

- Dataset

- Olist Brazilian E-commerce Public Dataset. Contains ~100,000 real online orders including timestamps, prices and customer reviews.


Key Analysis Steps:

- Imported raw transaction data into SQL Server

- Cleaned delivered orders and created analysis table

- Converted timestamps to datetime fields

- Engineered delivery time feature (delivery_days)

- Joined customer reviews and order value

- Created dataset for dashboard reporting


Key Findings: 

- Orders with longer delivery times received significantly lower review scores

- 1-star reviews had an average delivery time of ~21 days

- 5-star reviews had an average delivery time of ~10 days

- Large orders appear more sensitive to delivery delays



Business Insight:

Delivery performance is strongly associated with customer satisfaction.
Improving logistics speed and reliability is likely to increase customer satisfaction and stabilize revenue performance.




Dashboard

The final dataset was used to build a Power BI dashboard showing:

- delivery time vs review score

- average order value

- monthly order trends

(Screenshots available in the /powerbi folder)