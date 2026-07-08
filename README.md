# E-Commerce Business Insights - SQL Analysis

## Overview
Analysed 483,000+ e-commerce orders across 5 relational tables using MySQL to extract actionable business insights across revenue, payments, operations and shipping.

## Dataset
- Source: Kaggle E-Commerce Dataset
- Size: 483,000+ orders
- Tables: orders, customers, products, payments, orderitems

## What I Did
- Imported and cleaned 483,000+ rows across 5 tables
- Built a unified final_orders table using multi-table JOINs
- Calculated derived metrics (approval time in minutes)
- Wrote 18 business queries to answer key business questions

## Business Questions Answered
1. What is the total revenue generated across all orders?
2. Which product categories are generating the most revenue?
3. Which are the top 5 categories driving maximum revenue?
4. Which states are contributing most to overall revenue?
5. What is the average amount spent per order?
6. Which payment method do customers prefer most?
7. Do customers spend more depending on their payment method?
8. What percentage of total revenue comes from each payment method?
9. In which states do customers most frequently pay by credit card?
10. How long does it take on average for an order to be approved?
11. Which product categories face the most delays in order approval?
12. How many orders are taking longer than average to get approved?
13. Which states experience the slowest order approvals?
14. How did order volumes change month by month in 2017?
15. Which categories incur the highest shipping costs on average?
16. For which categories is shipping eating into revenue the most?
17. Are there orders where the business is losing money on shipping?
18. How many orders in total are shipping-loss cases?

## Tools Used
MySQL | MySQL Workbench

## Files
- `ecommerce_project.sql` - all 18 business queries with screenshots of outputs
- `Ecommerce_Business_Insights_Report.pdf` - full BA report with insights and recommendations
