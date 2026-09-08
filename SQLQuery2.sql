use [Swiggy Database]
select * from Swiggy_data;

-- data validation and cleaning
-- Null check 

SELECT 
	sum(case when state is null then 1 else 0 end) as null_state,
	sum(case when city is null then 1 else 0 end) as null_city,
	sum(case when Order_Date is null then 1 else 0 end) as null_order_date,
	sum(case when Restaurant_Name  is null then 1 else 0 end) as null_restaurant,
	sum(case when Location  is null then 1 else 0 end) as null_location,
	sum(case when Category is null then 1 else 0 end) as null_category,
	sum(case when Dish_Name is null then 1 else 0 end) as null_dish,
	sum(case when Price_INR is null then 1 else 0 end) as null_price,
	sum(case when Rating is null then 1 else 0 end) as null_rating,
	sum(case when Rating_Count is null then 1 else 0 end) as null_rating_count
from Swiggy_data;

--Blank or Empty string
SELECT *
FROM Swiggy_data
where
state = '' or City = '' or Location = '' or Category = '' or Dish_Name = '' or Restaurant_Name = ''


-- Duplicate Detection 
SELECT 
State, City, Order_Date,Restaurant_Name,  Location, Category, Dish_Name, Price_INR, Rating, Rating_Count ,
count(*) as CNT 
From Swiggy_data
Group BY
State, City, Order_Date,Restaurant_Name , Location, Category, Dish_Name, Price_INR, Rating, Rating_Count 
having COUNT(*) > 1

--Delete Duplication
WITH CTE AS (
SELECT * , ROW_NUMBER()Over(
	PARTITION BY State, City, Order_Date,Restaurant_Name,  Location, Category, Dish_Name,
	Price_INR, Rating, Rating_Count
	ORDER BY (SELECT NULL)
) AS rn 
From Swiggy_data
)
DELETE FROM CTE WHERE rn> 1

-- CREATING SCHEMA 
-- CREATING DIMENSION TABLE
-- DATE TABLE

CREATE TABLE dim_date (
	date_id INT identity(1,1) primary key,
	Full_date DATE,
	Year INT,
	Month INT,
	Month_name varchar(20),
	Quarter INT,
	Day INT,
	Week INT	
	)


-- dim_location
create table dim_location(
	location_id INT IDENTITY(1,1) Primary Key,
	State Varchar(100),
	City Varchar(100),
	Location Varchar(200)
);

-- Restaurant Table

CREATE TABLE dim_Restaurant
(
    Restaurant_Key  INT IDENTITY(1,1) PRIMARY KEY,
    Restaurant_Name VARCHAR(200)
);

-- dim_category

CREATE TABLE dim_category(
	category_id INT	IDENTITY(1,1) PRIMARY KEY,
	Category VARCHAR(200)
);

--drop table dim_category;

-- dim dish

CREATE TABLE dim_dish (
	dish_ID INT IDENTITY(1,1) PRIMARY KEY,
	Dish_Name VARCHAR(200)

)

select * from Swiggy_data;


--FACT TABLE

CREATE TABLE fact_swiggy_orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,

    date_id INT,
    Price_INR DECIMAL(10,2),
    Rating DECIMAL(4,2),
    Rating_Count INT,

    location_id INT,
    restaurant_id INT,
    category_id INT,
    dish_id INT,

    FOREIGN KEY (date_id) 
        REFERENCES dim_date(date_id),

    FOREIGN KEY (location_id) 
        REFERENCES dim_location(location_id),

    FOREIGN KEY (restaurant_id) 
        REFERENCES dim_Restaurant(Restaurant_key),

    FOREIGN KEY (category_id)
		REFERENCES dim_category(category_id),

    FOREIGN KEY (dish_id) 
        REFERENCES dim_dish(dish_id)
);


select * from fact_swiggy_orders

-- Insert data in Tables
-- Dim Date

INSERT INTO dim_date ( Full_date,Year ,Month ,Month_name ,Quarter ,Day ,Week )
SELECT DISTINCT
	Order_date,
	Year(Order_date),
	MONTH(Order_date),
	DATENAME(MONTH,Order_date),
	DATEPART(QUARTER, Order_date),
	DAY(Order_date),
	DATEPART(WEEK, Order_date)
FROM Swiggy_data
WHERE Order_Date IS NOT NULL;


select * from dim_date

--dim_location 
INSERT INTO dim_location (State,  City, Location)
SELECT Distinct
	State,
	City,
	Location
FROM Swiggy_data;

--dim_restaurant
INSERT INTO dim_Restaurant (Restaurant_Name)
SELECT Distinct
	Restaurant_Name
From Swiggy_data;

--dim_Category
INSERT INTO dim_category(Category)
SELECT DISTINCT
    Category
FROM Swiggy_data;

-- Dim_Dish
INSERT INTO dim_dish(Dish_Name)
SELECT DISTINCT
	Dish_Name
from Swiggy_data;


-- Fact Table

INSERT INTO fact_swiggy_orders
(
    date_id,
    Price_INR,
    Rating,
    Rating_Count,
    location_id,
    restaurant_id,
    category_id,
    dish_id
)
SELECT
    dd.date_id,
    s.Price_INR,
    s.Rating,
    s.Rating_Count,
    dl.location_id,
    dr.Restaurant_Key,
    dc.category_id,
    dsh.dish_id
FROM Swiggy_data s

JOIN dim_date dd
    ON dd.Full_date = s.Order_Date

JOIN dim_location dl
    ON dl.State = s.State
    AND dl.City = s.City
    AND dl.Location = s.Location

JOIN dim_Restaurant dr
    ON s.Restaurant_Name = dr.Restaurant_Name

JOIN dim_category dc
    ON dc.Category = s.Category

JOIN dim_dish dsh
    ON dsh.Dish_Name = s.Dish_Name;



select * from fact_swiggy_orders

select * from fact_swiggy_orders f
join dim_date d On f.date_id  = d.date_id
join dim_location l on f.location_id = l.location_id
JOIN dim_restaurant r on f.restaurant_id = r.Restaurant_Key

join dim_category c on f.category_id = c.category_id
join dim_dish di on f.dish_id =  di.dish_id;

--KPI 
-- Total Orders

select count(*) AS TotaL_Orders
From fact_swiggy_orders

--Total Revenue (INR Million)

Select
FORMAT(Sum(Convert(Float,price_INR))/ 1000000, 'N2') + 'INR Million'
AS 
Total_Revenue 
from fact_swiggy_orders

--Avg Dish Price

Select
FORMAT(Avg(Convert(Float,price_INR)), 'N2') + 'INR'
AS 
Total_Average
from fact_swiggy_orders

-- AVG Rating
Select 
Avg(Rating) AS Average_Rating
From fact_swiggy_orders

-- DEEP Dive Business Analysis

--Monthly Orders Trends

Select 
d.year,
d.month,
d.month_name,
count(*) AS Total_Orders
from fact_swiggy_orders f
Join dim_date d ON f.date_id = d.date_id
Group BY 
d.year,
d.month,
d.month_name
ORDER BY 
d.year,
d.month;

--Quaterly Trend

Select 
d.year,
d.quarter,
count(*) AS Quarterly_T_Orders
from fact_swiggy_orders f
Join dim_date d ON f.date_id = d.date_id
Group BY 
d.year,
d.quarter
ORDER BY 
count(*) DESC

-- Yearly Trend
Select 
d.year,
count(*) AS Yeary_Trend
from fact_swiggy_orders f
Join dim_date d ON f.date_id = d.date_id
Group BY 
d.year
ORDER BY 
count(*) DESC

--Orders by Day of week (mon-sun)
Select 
    DATENAME(WEEKDAY, d.full_date) AS day_name,
    COUNT(*) as total_orders
from fact_swiggy_orders f 
Join dim_date d on f.date_id = d.date_id
Group by  DATENAME(WEEKDAY, d.Full_date), DATEPART(WEEKDAY, d.Full_date)
order by DATEPART(WEEKDAY, d.Full_date);


--Top 10 cities by orders volume
select Top 10
l.city,
COUNT(*) As Total_Orders from fact_swiggy_orders f
join dim_location l
on l.location_id = f.location_id
group by l.City
order by COUNT(*) ASC

--select * from fact_swiggy_orders

--Sum of sales 
select Top 10
l.city,
Sum(f.price_INR) As Total_Revenue from fact_swiggy_orders f
join dim_location l
on l.location_id = f.location_id
group by l.City
order by Sum(f.price_INR) Desc

--Revenue contribition by states 
select top 10
l.state,
Sum(f.price_INR) As Total_Revenue from fact_swiggy_orders f
join dim_location l
on l.location_id = f.location_id
group by l.State
order by Sum(f.price_INR) desc

--    Food performance ----


-- top 10 restaurants by orders

select top 10
r.restaurant_name,
Sum(f.price_INR) As Total_Revenue from fact_swiggy_orders f
join dim_Restaurant r
on r.Restaurant_Key = f.restaurant_id
group by r.restaurant_name
order by Sum(f.price_INR) desc

--top categories by order volume
select
c.category,
COUNT(*) As Total_Orders from fact_swiggy_orders f
join dim_category c 
on c.category_id = f.category_id
group by c.category
order by COUNT(*) desc

-- Most orderd dishes

select top 10
d.dish_name,
COUNT(*) As order_count from fact_swiggy_orders f
join dim_dish d 
on d.dish_ID = f.dish_id
group by d.dish_name
order by COUNT(*) desc

--cuisine performance (orders + AVg Rating)

select 
c.category,
COUNT(*) As total_orders, 
AVG(f.rating) as Avg_rating
from fact_swiggy_orders f
join dim_category c
on c.category_id = f.category_id
group by c.category
order by total_orders desc;

/*select 
c.category,
    COUNT(*) As total_orders, 
    AVG(f.rating) as Avg_rating
from fact_swiggy_orders f
join dim_category c
on c.category_id = f.category_id
group by c.category
order by Avg_rating desc;*/

-------/*Customer Spending Insights
-------Buckets of customer spend:*/

SELECT
    CASE
        WHEN f.Price_INR < 100 THEN 'Under 100'
        WHEN f.Price_INR < 200 THEN '100 - 199'
        WHEN f.Price_INR < 300 THEN '200 - 299'
        WHEN f.Price_INR < 500 THEN '300 - 499'
        ELSE '500+'
    END AS price_range,

    COUNT(*) AS Total_Orders

FROM fact_swiggy_orders f

GROUP BY
    CASE
        WHEN f.Price_INR < 100 THEN 'Under 100'
        WHEN f.Price_INR < 200 THEN '100 - 199'
        WHEN f.Price_INR < 300 THEN '200 - 299'
        WHEN f.Price_INR < 500 THEN '300 - 499'
        ELSE '500+'
    END

ORDER BY Total_Orders DESC;

--         Ratings Analysis
--Distribution of dish ratings from 1–5.


select 
    rating,
    COUNT(*) as rating_count
From fact_swiggy_orders
group by rating
order by COUNT(*) desc
