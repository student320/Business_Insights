# Business Insights for Technology Hardware Company - Project Overview

## Project Goal
This Power BI project aims to provide a comprehensive view of year-over-year (YoY) company performance from multiple perspectives while offering insights into overall product and customer performance. The analysis focuses on Atliq Hardware, a technology hardware company, and employs key performance indicators (KPIs) to assess the company’s standing. The primary objectives of the analysis are to 1) drive company growth and increase net sales, 2) improve profitability, and 3) optimize the product portfolio. Based on the findings, recommendations will be provided to help achieve these goals.

Atliq Hardware has a wealth of data related to finance, sales, marketing, supply chain, and product offerings that is not being effectively utilized. This project leverages this data to uncover valuable insights that will contribute to Atliq Hardware’s overall success.

Insights and recommendations are provided for these following areas:
- **YoY Profit & Loss Statement**:
- **Sales Analysis**:
  - **Customer Performance**:
  - **Product Performance**:
- **Supply Chain Forecast Accuracy Trend**:

  An interactive Power BI dashbaord with additional insights and analysis can be found [here](https://app.powerbi.com/view?r=eyJrIjoiZTUyYWY3MjUtNzI5Ny00MmY0LThlN2YtNDgxYTljOWIwZDg4IiwidCI6ImM2ZTU0OWIzLTVmNDUtNDAzMi1hYWU5LWQ0MjQ0ZGM1YjJjNCJ9).
  
  SQL queries used to answer specific business quesions requested by management for ad hoc analysis can be found [here](https://github.com/student320/Business_Insights/blob/main/Business_Insights.sql).



## Company Background
Atliq Hardwares is a technology hardware company that sells multiple categories of electronic products through channels such as retailers, distributors, and direct sales, catering to well-known companies worldwide. Atliq's business model involves both business-to-business (B2B) and business-to-consumer (B2C) sales; however, the largest portion of revenue comes from B2B transactions. The company focuses on selling in-demand products and maintaining strong customer relationships, which are crucial for its operations.

## Data Model and Entity Relationship Diagram (ERD)
The analysis is based on the following datasets:

- dim_customer: Contains information on customer details, including customer code, name, and other demographic or business attributes.
- dim_market: Provides market-related data, including regions, sub-zones, and other geographical or market segmentation details.
- dim_product: Holds details about products, such as product code, category, and other product-specific attributes.
- fact_sales_monthly: Contains monthly sales data, including sales quantities, revenue, and other relevant sales metrics.
- fact_forecast_monthly: Includes forecasted sales data for upcoming periods, with estimated quantities and revenue predictions.
- freight_cost: Data related to shipping and transportation costs incurred during product delivery.
- gross_price: Contains information on the gross price of products before any deductions or adjustments.
- manufacturing_cost: Tracks the costs associated with producing goods, including materials, labor, and overhead.
- post_invoice_deductions: Includes deductions applied after invoicing, such as discounts or returns.
- pre_invoice_deductions: Contains deductions applied before invoicing, like early payment discounts or promotional offers.

Atliq Hardware's data model can be seen below with a total row count of 1,858,329 records.  

The data model ERD can be found [here](https://lucid.app/lucidchart/5b5eb739-3350-4fd0-a3fe-c15e840668a5/view)


![image](https://github.com/user-attachments/assets/101500fb-b627-45b7-9a58-24bab7d953b7)
![image](https://github.com/user-attachments/assets/29f7704c-28eb-4ea5-aedf-df519e6a38e9)


## Executive Summary

**Overview of Insights**
The following sections will provide a breif analysis of factors impacting performance and present recommendations for the company's future strategy.  

**YoY Profit and Loss Statement** for the fiscal year of 2021:  

Up to and including the 2021 fiscal year, the company has remained in its growth phase and has not yet achieved profitability. The primary focus has been on increasing market share and building brand recognition. In 2021, the company experienced significant expansion, with **net sales rising by 207.43% year-over-year (YoY)**, while the **Gross Margin %** remained strong, with only a **slight decline of 1.65%**. However, projections for 2022 indicate that **overall profitability will remain negative and may decrease further**. Therefore, the company should **prioritize profitability as a key objective**.
![image](https://github.com/user-attachments/assets/b01e9230-6eb1-480f-9dda-cc6dcc5a15cf)  

**Sales Analysis** for the fiscal year of 2021:
  - **Customer Performance:**
    - The **top-performing countries** in terms of Net Sales and Gross Margin % are the **USA**, **India**, and **Canada**, as illustrated in the performance matrix below.
    - The **worst-performing countries** are **Columbia**, **Austria**, and **Italy**.
    
    - **Our leading customers are:**
      - **Amazon**: Net sales of $109.03M USD with a Gross Margin % of 35.40%.
      - **AtliQ Exclusive**: Net sales of $79.92M USD with a Gross Margin % of 43.73%.
      - **AtliQ eStore**: Net sales of $70.31M USD with a Gross Margin % of 37.54%.
     
    - **Our worst performing customers are:**
      - **Nova**: Net sales of 0.46$M USD with a Gross Margin % of 26.65%.
      - **All-Out**: Net sales of 1.06$M USD with a Gross Margin % of 47.53%.
      - **Notebilling**: Net sales of 1.47$M USD with a Gross Margin % of 18.28%.
    -   ![image](https://github.com/user-attachments/assets/a889c2ec-34ff-4d9e-9553-0e8dff11fdfb)


 - **Product Performance:**
  - The **best-performing product segments are:**
    - **Notebooks**: Net Sales of $266.49M USD with Gross Margin % of 36.47%.
      - **Personal Laptops** are the top category with Net Sales of $113.07M USD and Gross Margin % of 36.11%. 
    - **Accessories**: Net Sales of $244.85M USD with a Gross Margin % of 36.45%
      - **Keyboards** are the top category with Net Sales of $134.14M USD  and Gross Margin % of %.
     
    - The **worst-performing product segments are:**
    - **Desktops**: Net Sales of $46.43M USD with Gross Margin % of 36.17%.
      - **Personal Desktops** are the worst category with Net Sales of $12.68M USD and Gross Margin % of 36.70%.
    - **Networking**: Net Sales of $45.16M USD with a Gross Margin % of 36.75%
      - **Wifi Externder** is the  only category in Networking segment.
    -   ![image](https://github.com/user-attachments/assets/395cf3f8-e556-40c0-899b-6a53e1b69969)


    
**Supply Chain Forecast Evaluation**
- For the fiscal year 2021, the company achieved an impressive **forecast accuracy of 80.21%**, an **improvement of 9.88%** compared to the previous fiscal year.
- The net error in quantity sold is **-751.71K units, a decline of 252.81%**. This negative net error indicates that we have been over-forecasting sales, which could lead to excess inventory for some products. 
- Despite the improvement in forecast accuracy, there is a **risk of out-of-stock (OOS)** situations for high-demand products like **Notebooks** and **Accessories**, which could result in missed sales opportunities and customer dissatisfaction.
- Product categories like **Networking** and **Storage** are facing **excess inventory (EI)** issues, as highlighted by the forecast error analysis. This can lead to increased costs for warehousing and obsolete stock, underscoring the need for more efficient inventory management and demand planning.
![image](https://github.com/user-attachments/assets/dcdc678c-9bb4-413b-a7d7-de7427a2c7f3)



The full interactive report is available with more dashboards [here](https://app.powerbi.com/view?r=eyJrIjoiZTUyYWY3MjUtNzI5Ny00MmY0LThlN2YtNDgxYTljOWIwZDg4IiwidCI6ImM2ZTU0OWIzLTVmNDUtNDAzMi1hYWU5LWQ0MjQ0ZGM1YjJjNCJ9).

## Recommendations
- As we have already established growth and brand recognition, it is crucial to develop strategies aimed at achieving profitability. Given our strong gross margin, variable costs related to our products and customers are not an issue; instead, operational costs are the primary barrier to profitability. We should begin strategizing on how to enhance operational efficiency and potentially reduce fixed costs.

- Recommendation for Customer Performance:
  - Focus on Retention and Growth: While Amazon, AtliQ Exclusive, and AtliQ eStore are driving a significant portion of revenue and maintaining healthy gross margins, it’s crucial to develop strategies for retaining these top customers through enhanced customer service, personalized offers, or long-term contracts. Investing in deeper relationships with these key clients could lead to even more consistent performance and higher lifetime value.
  - Improve Customer Segmentation for Lower Performers: The worst-performing customers like Nova, All-Out, and Notebilling present an opportunity to re-evaluate the company's engagement strategy. For Nova and Notebilling, their relatively low net sales and margins suggest potential misalignment with the company's product offering or pricing strategy. Conducting a deeper customer segmentation analysis might reveal insights on how to better serve these clients or whether to consider deprioritizing resources for underperforming segments.
  - Regional Customer Development: With Columbia, Austria, and Italy underperforming, it’s essential to analyze the specific challenges in these regions. Whether the issues stem from economic conditions, distribution inefficiencies, or poor brand penetration, addressing these regional factors through tailored marketing, pricing, or logistical strategies could improve performance.
 
- Recommendation for Product Performance:
  - Invest in High-Performing Product Categories: With Notebooks and Accessories leading in sales and maintaining strong gross margins, these segments should be further developed. Consider expanding the product line within these categories, particularly for Personal Laptops and Keyboards, which are the top-performing subcategories. Focus on innovation and marketing to maintain their competitive edge and capitalize on customer demand.
  - Reassess Underperforming Product Segments: The Desktops and Networking segments are trailing in performance. For Personal Desktops, the company could explore reasons for declining demand and consider pivoting the product line to better align with current market trends, possibly by introducing hybrid or compact desktop models. Similarly, for Networking, the reliance on a single category, the WiFi Extender, indicates a potential gap in the product offering. Expanding the networking product range could provide growth opportunities.

- Inventory Risk Diversification: The mix of out-of-stock risks for some products and excess inventory for others indicates that the company needs to diversify its inventory risk management approach. Tailoring forecasts and supply chain strategies to specific product categories can help minimize both overstocking and stockouts.



**Appendix**  

**More in depth Customer Performance**  

![image](https://github.com/user-attachments/assets/d3637dc7-a7f7-41d0-b213-b1978c7785b0)

**More in depth Product Performance**  

![image](https://github.com/user-attachments/assets/ae174505-8f60-4fdd-88a3-fd5f04e834e1)

**SQL Queries used for Ad Hoc Analysis**  

(https://github.com/student320/Business_Insights/blob/main/Business_Insights.sql).


