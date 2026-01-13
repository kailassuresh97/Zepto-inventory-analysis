alter table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(10,2),
dicountPercent NUMERIC(5,2),
availableQuanity INTEGER,
dicoountsellingPrice NUMERIC(8,2),
weighInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);


---data exploration

select * from zepto
limit 10;

--null values
select * from zepto
where name is null
or
category is null
or
mrp is null
or
"discountPercent" is null
or
"availableQuanity" is null
or
"discountSellingPrice" is null
or
"weightInGms" is null
or
"outOfStock" is null
or
quantity is null

--different product categories
select distinct category
from zepto
order by category

--product in stock/out of stock
select "outOfStock", count(sku_id)
from zepto
group by "outOfStock"

--PRODUCT NAMES PRESENT MULTIPLE TIMES
select name,count(sku_id)
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc

--DATA CLEANING--

--PRODUCT PRICE =0
SELECT * FROM ZEPTO
WHERE MRP = 0 OR "discountSellingPrice" = 0

DELETE FROM ZEPTO WHERE MRP=0

--CONVERT PAISE INTO RUPPPE
UPDATE zepto
SET 
	MRP=MRP/100.0,
	"discountSellingPrice"="discountSellingPrice"/100.0;

select mrp,"discountSellingPrice" from zepto




--Q1. Find the top 10 best-value products based on discount percentage.
select distinct name,mrp,"discountPercent"
from zepto
order by "discountPercent" desc
limit 10

--Q2. What are the Products with high MRP but out of stock?
select distinct name,mrp
from zepto
where "outOfStock"=True and mrp > 300 
order by mrp desc

--Q3.Calculate Estimated Revenue for each category
select category,
sum("discountSellingPrice" * "availableQuanity") as total_revenue
from zepto
group by category
order by total_revenue desc

--Q4. Find all products where mrp is greather than Rs500 and discount is lessthan 10%
select distinct name,mrp,"discountPercent"
from zepto
where mrp>500 and "discountPercent" < 10
order by mrp desc, "discountPercent" desc

--Q5. Identify the top 5 category offering the highest average discount percentage.
select category,
ROUND(avg("discountPercent"),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5

--Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name,"weightInGms","discountSellingPrice",
ROUND("discountSellingPrice" / "weightInGms",2) as price_per_gram
from zepto
where "weightInGms" >=100
order by price_per_gram 

--Q7. Group the products into categories like Low,Medium,Bulk.
select distinct name,"weightInGms",
case
	when "weightInGms" < 1000 then 'Low'
	when "weightInGms" <5000 then 'Medium'
	Else 'Bulk'
	end as weight_category
from zepto

--Q8. What is the Total Inventory Weight per category?
select category,
sum("weightInGms" * "availableQuanity") as total_weight
from zepto
group by category
order by total_weight