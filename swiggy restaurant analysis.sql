CREATE DATABASE swiggy_db;
USE swiggy_db;
CREATE TABLE swiggy (
    id INT,
    name VARCHAR(255),
    city VARCHAR(100),
    rating VARCHAR(20),
    rating_count VARCHAR(50),
    cost VARCHAR(50),
    cuisine VARCHAR(255),
    lic_no VARCHAR(100),
    link TEXT,
    address TEXT,
    menu VARCHAR(255)
);
-- Data Cleaning queries


-- check total records
select count(*) from swiggy;


-- update coloumn name in table 
ALTER TABLE swiggy
RENAME COLUMN name TO restaurant_name;


-- This will show all different values currently present in rating
select distinct rating from swiggy;


-- check for nulls in key coloumns
select count(*) - count(rating) as null_rating from swiggy;
select count(*) - count(name) as null_names from swiggy;


-- remove rows where rating is 'new' or '--'(not rated yet)
delete from swiggy where rating = 'new' or rating = '--' or rating = 'NA';


-- Standardise rating to numeric
update swiggy set rating = cast(rating as decimal(2,1));


--  Analysis queries

-- Q1: How many restaurants are listed per city?
SELECT city, COUNT(*) as total_restuarent
FROM swiggy
GROUP BY city 
order by city 
desc limit 10;


-- Q3: Which restaurant chains have the most branches?
select restaurant_name , count(*) as most_branch
from swiggy
group by restaurant_name
order by restaurant_name desc;


-- Q2: What are the most popular cuisines across India?
select cuisine, count(*) as count
from swiggy
 group by cuisine
order by count desc limit 10;


-- Q4: Top 5 cities with highest average restaurant rating?
SELECT city,
       ROUND(AVG(CAST(rating AS FLOAT)), 2) AS avg_rating,
       COUNT(*) AS total_restaurants
FROM swiggy
GROUP BY city
HAVING COUNT(*) > 50
ORDER BY avg_rating DESC
LIMIT 5;


-- Q5: What is the average cost for two across cities?
SELECT city,
       ROUND(AVG(CAST(REPLACE(cost, 'â‚¹ ', '') AS DECIMAL(10,2))), 0) AS avg_cost
FROM swiggy
WHERE cost != 'NA'
GROUP BY city
ORDER BY avg_cost DESC
LIMIT 10;


-- Q6: Which cuisines have the highest average rating? 
SELECT cuisine, ROUND(AVG(CAST(rating AS FLOAT)), 2) AS avg_rating, 
COUNT(*) AS restaurant_count 
FROM swiggy 
WHERE rating NOT IN ('NEW', '--') 
GROUP BY cuisine HAVING COUNT(*) > 100
 ORDER BY avg_rating DESC LIMIT 10;


-- Q7: Restaurants with rating above 4.5 and more than 1000 ratings
SELECT restaurant_name, city, rating, rating_count, cost
FROM swiggy
WHERE rating >= 4.5
AND (
    CAST(REPLACE(rating_count, '+ ratings', '') AS SIGNED) >= 1000
    OR rating_count IN ('1K+ ratings', '5K+ ratings', '10K+ ratings')
)
ORDER BY rating DESC
LIMIT 20;


-- Q8: Business insight — which city has best value for money?
-- (high rating, low cost)
SELECT city,
       ROUND(AVG(rating), 2) AS avg_rating,
       ROUND(AVG(CAST(REGEXP_REPLACE(cost, '[^0-9]', '') AS SIGNED)), 0) AS avg_cost
FROM swiggy
WHERE cost != 'NA'
GROUP BY city
HAVING COUNT(*) > 30
ORDER BY avg_rating DESC, avg_cost ASC
LIMIT 10;



SHOW TABLES;
describe swiggy;
select * from swiggy;