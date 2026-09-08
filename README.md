# Swiggy_Analysis_SQL
## 📌 Project Overview

This project focuses on analyzing Swiggy food delivery data using **SQL Server**.

The project demonstrates an end-to-end SQL data analytics workflow, starting from a raw dataset and transforming it into a structured **Star Schema** consisting of Fact and Dimension tables.

SQL queries are then used to analyze order patterns, restaurant performance, food categories, pricing ranges, ratings, and spending behavior.

---

## 🎯 Project Objectives

The main objectives of this project are:

- Transform raw Swiggy data into a structured analytical database.
- Build a **Star Schema** using Fact and Dimension tables.
- Perform data analysis using SQL Server.
- Analyze order distribution across different dimensions.
- Identify top-performing restaurants.
- Analyze food categories and ratings.
- Understand pricing and spending patterns.
- Generate business-oriented insights using SQL.

---

## 🗂️ Dataset

The raw dataset contains Swiggy food-related information such as:

- State
- City
- Order Date
- Restaurant Name
- Location
- Category
- Dish Name
- Price (INR)
- Rating
- Rating Count

> **Note:** The source dataset does not contain a unique customer ID, actual transaction/order ID, quantity, or payment information. Therefore, metrics based on `COUNT(*)` represent records/listings in the dataset rather than verified customer transactions.

---

## 🏗️ Data Model

The project follows a **Star Schema** design.

### Fact Table

**fact_swiggy_orders**

Contains measurable information and foreign keys connecting the dimension tables.

Key columns:

- `order_id`
- `date_id`
- `location_id`
- `restaurant_id`
- `category_id`
- `dish_id`
- `Price_INR`
- `Rating`
- `Rating_Count`

### Dimension Tables

#### 📅 dim_date
Contains:

- Date
- Year
- Month
- Month Name
- Quarter
- Day
- Week

#### 📍 dim_location
Contains:

- State
- City
- Location

#### 🍽️ dim_Restaurant
Contains:

- Restaurant Key
- Restaurant Name

#### 🏷️ dim_category
Contains:

- Category ID
- Category

#### 🍴 dim_dish
Contains:

- Dish ID
- Dish Name

---

## 🔄 Data Transformation Process

The project follows these major steps:

```text
Raw Swiggy Dataset
        ↓
Data Cleaning & Validation
        ↓
Create Dimension Tables
        ↓
Populate Dimension Tables
        ↓
Create Fact Table
        ↓
Load Fact Data
        ↓
Validate Relationships & Record Counts
        ↓
Perform SQL Analysis
        ↓
Generate Business Insights
📊 Key Analysis Performed
1. Monthly Order Trends

Analyzed the distribution of records across different months and years to understand monthly patterns.

2. Day-of-Week Analysis

Analyzed record distribution across weekdays to identify which days have higher activity.

3. Top Restaurants

Identified the top restaurants based on the total listed price associated with their records.

4. Category Analysis

Analyzed:

Record distribution by category
Average rating by category
5. Price Range Analysis

Analyzed the distribution of records across different price ranges:

Under 100
100–199
200–299
300–499
500+
6. Customer Spending Insights

Price-based buckets were created to understand how records are distributed across different spending ranges.

Since customer identifiers are not available in the source data, these represent price-based record distributions rather than individual customer spending.

🛠️ Technologies Used
Technology	Purpose
SQL Server	Database & SQL analysis
SSMS	Query development and database management
SQL	Data transformation and analysis
Star Schema	Data modeling
GitHub	Project documentation & version control
🧠 SQL Concepts Used

This project demonstrates practical knowledge of:

CREATE DATABASE
CREATE TABLE
Primary Keys
Foreign Keys
IDENTITY
INSERT INTO
SELECT
JOIN
GROUP BY
ORDER BY
COUNT()
SUM()
AVG()
CASE
TOP
DISTINCT
YEAR()
MONTH()
DATENAME()
DATEPART()
Data aggregation
Dimensional modeling
Star Schema
Fact & Dimension tables
Data validation
📁 Project Structure
Swiggy-SQL-Data-Analysis/
│
├── README.md
│
├── SQL/
│   ├── Database_Creation.sql
│   ├── Table_Creation.sql
│   ├── Dimension_Loading.sql
│   ├── Fact_Loading.sql
│   └── Analysis_Queries.sql
│
├── Dataset/
│   └── Swiggy_data.csv
│
└── Screenshots/
    └── Dashboard_or_Query_Results.png

Update the file names above according to your actual GitHub folder structure.

📈 Key Business Questions

The analysis answers questions such as:

How many records are available for each month?
Which days of the week have the highest activity?
Which restaurants have the highest total listed price?
Which food categories have the most records?
What is the average rating for each category?
How are records distributed across different price ranges?
Which spending range contains the highest number of records?
How does food pricing vary across the dataset?
🔍 Important Data Considerations

This project uses a food listing dataset rather than a complete transactional order database.

Therefore:

order_id in the fact table is a generated surrogate key.
It should not be interpreted as the original Swiggy order ID.
COUNT(*) represents the number of fact records.
SUM(Price_INR) represents total listed price across records.
It should not be interpreted as actual revenue.
Customer-level spending cannot be calculated because customer identifiers are not available.
Rating_Count should be interpreted carefully because the same rating count may appear across multiple records.

These considerations help ensure that the analytical results are interpreted correctly.

💡 Skills Demonstrated

This project demonstrates my ability to:

Design relational databases for analytics.
Build a Star Schema.
Create and populate Fact and Dimension tables.
Establish relationships using Primary and Foreign Keys.
Write analytical SQL queries.
Perform aggregations and segmentation.
Use SQL CASE statements for business bucketing.
Validate transformed data.
Convert business questions into SQL queries.
Present data-driven business insights.
🚀 Future Improvements

Potential extensions for this project include:

Connecting the SQL Server database to Power BI.
Creating an interactive Swiggy analytics dashboard.
Adding more advanced SQL analysis using CTEs and Window Functions.
Implementing automated data refresh.
Adding additional business KPIs when transactional/customer-level data becomes available.
