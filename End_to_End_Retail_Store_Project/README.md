# Retail Sales Performance Analysis for a Regional Superstore

## Project Overview

This project presents an end-to-end data analysis solution for a regional retail company. The goal was to analyze sales performance, profitability, customer behavior, and product performance to identify business opportunities and areas for improvement.

The project follows a complete analytics workflow, starting from raw data cleaning and exploration using Python, followed by SQL-based analysis and data modeling, and ending with an interactive Power BI dashboard designed to support business decision-making.

---

# Business Problem

The company has experienced revenue growth but inconsistent profitability. Management needs insights into:

- Which products generate the most revenue and profit
- Which products and categories are underperforming
- Which regions and customer segments contribute the most value
- How discounts affect profitability
- How sales performance changes over time
- Which areas require strategic improvement

The analysis helps management make data-driven decisions related to pricing, inventory planning, marketing strategies, and profitability optimization.

---

# Dataset

**Dataset Name:** Sample Superstore Dataset  
**Source:** Tableau / Kaggle

The dataset contains transactional retail sales data including:

- Orders
- Customers
- Products
- Categories
- Locations
- Shipping details
- Sales
- Quantity
- Discounts
- Profit

The original dataset was cleaned and transformed before being used for analysis.

---

# Tools & Technologies

## Python
Used for data preparation and exploratory analysis:

- Pandas
- Pandas Matplotlib
- Jupyter Notebook

Tasks performed:

- Data loading and inspection
- Missing value handling
- Duplicate detection
- Data validation
- Data type correction
- Feature engineering
- Exploratory data analysis
- Data export

---

## SQL

Used for database design and business analysis.

Tasks performed:

- Database schema creation
- Table normalization
- Data import
- Data aggregation
- Business analysis queries
- Joins
- Subqueries
- CTEs
- Window functions
- Views

---

## Power BI

Used to build an interactive business intelligence dashboard.

Implemented:

- Data modeling
- Table relationships
- DAX measures
- KPI cards
- Interactive filters
- Business dashboards
- Data storytelling

---

# Project Workflow

## 1. Data Cleaning & Preparation (Python)

The raw dataset was processed by:

- Checking data structure and data types
- Removing duplicates
- Handling missing values
- Validating data consistency
- Creating additional analytical features:

  - Year
  - Month
  - Quarter
  - Profit Margin
  - Shipping Days

The cleaned dataset was exported for SQL analysis.

---

## 2. Database Design & SQL Analysis

The dataset was transformed from a single flat file into a structured relational database.

Tables created:

- Customers
- Products
- Geography
- Orders
- Order Details

SQL analysis was performed to answer business questions related to:

- Sales performance
- Profitability
- Customer value
- Product performance
- Regional analysis
- Monthly trends
- Discount impact

---

## 3. Power BI Dashboard

An interactive dashboard was created to provide business insights.

Dashboard pages:

### Executive Dashboard

Provides an overview of key business metrics:

- Total Sales
- Total Profit
- Total Orders
- Customers
- Profit Margin

---

### Sales Performance

Analyzes:

- Sales by region
- Sales by category
- Sales by sub-category
- Sales trends

---

### Customer Insights

Analyzes:

- Customer segments
- Top customers
- Customer contribution
- Customer profitability

---

### Product Insights

Analyzes:

- Best-performing products
- Low-performing products
- Product profitability
- Category performance

---

### Time Analysis

Analyzes:

- Monthly sales trends
- Seasonal patterns
- Yearly performance

---

# Dashboard Screenshots

## Executive Dashboard

![Executive Dashboard](PowerBi_screen_shots/1.%20Executive_dashboard.png)

## Sales Performance

![Sales Performance](PowerBi_screen_shots/2.%20Sales_performance.png)

## Customer Insights

![Customer Insights](PowerBi_screen_shots/3.%20Customer_insights.png)

## Product Insights

![Product Insights](PowerBi_screen_shots/4.%20Product_insight.png)

## Time Analysis

![Time Analysis](PowerBi_screen_shots/5.%20Time_analysis.png)

---

# Repository Structure

End_to_End_Retail_Store_Project
│
├── PowerBi_screen_shots
│   ├── 1. Executive_dashboard.png
│   ├── 2. Sales_performance.png
│   ├── 3. Customer_insights.png
│   ├── 4. Product_insight.png
│   └── 5. Time_analysis.png
│
├── archive
│   └── Sample - Superstore.csv
│
├── Insights.sql
├── buildingSchema.sql
├── retail_clean.csv
├── retail_dashboard.pbix
├── retail_project.ipynb
└── README.md

---

# Key Skills Demonstrated

### Data Analysis

- Data cleaning
- Exploratory data analysis
- Feature engineering
- Business insights generation

### Python

- Pandas
- NumPy
- Data visualization
- Data validation

### SQL

- Database design
- Data modeling
- Aggregations
- Joins
- CTEs
- Window functions
- Business reporting

### Power BI

- Data modeling
- DAX measures
- Dashboard development
- KPI creation
- Interactive reporting

### Business Analytics

- Problem solving
- Data storytelling
- Decision support
- Translating data into business recommendations

---

# Project Outcome

This project demonstrates a complete analytics pipeline, transforming raw retail transaction data into actionable business insights.

The final dashboard enables decision-makers to understand sales trends, identify profitable products and customers, evaluate regional performance, and improve business strategies using data-driven insights.

---

# Author

**Abdullah Hatem**

GitHub:  
https://github.com/AbdullahHatem

LinkedIn:  
https://www.linkedin.com/in/abdullah-hatem-275049220
