use Walmart_sales_data
go


-- checking data after importing 
select * from [dbo].[WalmartSalesData]

-- Feature engineering
--1. addition of time of the day
select Time,
(case
	when Time between '00:00:00' and '12:00:00' then 'Morning'
	when Time between '12:01:00' and '16:00:00' then 'Afternoon'
	else 'Evening'
	end
) time_of_day 
from WalmartSalesData;

-- addition of new column time_of_day
alter table WalmartSalesData
add time_of_day varchar(20)


-- update the time_of_day data in the respective column in table
update WalmartSalesData
set time_of_day =(
		case
			when Time between '00:00:00' and '12:00:00' then 'Morning'
			when Time between '12:01:00' and '16:00:00' then 'Afternoon'
			else 'Evening'
		end
)

--2. addition of day_name
select Date, DAteNAME(weekday,Date) day_name from WalmartSalesData 


alter table walmartsalesdata
add day_name varchar(10)


select * from WalmartSalesData


update WalmartSalesData
set day_name =(Datename(weekday,Date))


--3. addition of month name 
select Date, DATENAME(MONTH,Date) Month_name from WalmartSalesData

alter table walmartsalesdata
add Month_name varchar(10)


select * from WalmartSalesData

update WalmartSalesData
set Month_name =(DATENAME(MONTH,Date))

-- Business questions to answer 
--1. Generic question
	--	1. How many unique cities does the data have?
		select distinct(city) city_name from WalmartSalesData

	--	2. In which city is each branch ?
		select distinct(city), Branch 
		from WalmartSalesData 

-- Product related questions
	-- 1. How many unique lines does the data have?
	select distinct(product_line) 
	from WalmartSalesData

	-- 2. What is the most common payment method?
	select Payment, count(Payment) Payment_Cnt from WalmartSalesData
	group by Payment 
	order by Payment_Cnt desc

	-- 3. What is the most selling product line?
	select Product_line, count(Product_line) Product_line_cnt from WalmartSalesData
	group by Product_line
	order by Product_line_cnt  desc

	--4. What is the total revenue by month?
	select Month_name, sum(Total) Total_revenue from WalmartSalesData
	group by Month_name
	order by Total_revenue desc

	--5. What month had the largest Cost of Goods Sold(COGS)?
	select Month_name, sum(cogs) Cost_of_Goods_sold_COGS from WalmartSalesData
	group by Month_name
	order by Cost_of_Goods_sold_COGS desc

	--6.What product line had the largest revenue?
	select Product_line, sum(total) Total_revenue from WalmartSalesData
	group by Product_line
	order by Total_revenue desc

	--7. What is the city with the largest revenue?
	select city, sum(total) Total_revenue from WalmartSalesData
	group by city
	order by Total_revenue desc

	--8.What product line had the largest VAT?
	select Product_line, AVG(Tax_5) Avg_VAT from WalmartSalesData
	group by Product_line
	order by Avg_VAT desc

	--9.Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
	select Product_line, (case
	when 

	--10.Which branch sold more products than average product sold?
	select Branch, sum(Quantity) Products_sold from WalmartSalesData
	group by Branch
	having (sum(Quantity) > (select avg(Quantity) from WalmartSalesData))
	
	
	--11.What is the most common product line by gender?
	select gender, Product_line, count(gender) total_cnt from WalmartSalesData
	group by gender, Product_line
	order by total_cnt desc

	--12.What is the average rating of each product line?
	select Product_line, AVG(rating) Avg_Rating from WalmartSalesData
	group by Product_line


	-- Sales Analysis

--1. Number of sales made in each time of the day per weekday
select time_of_day,count(*) from walmartsalesdata
group by time_of_day

--2. Which of the customer types brings the most revenue?
select customer_type, sum(Total) Total_revenue from WalmartSalesData
group by Customer_type


--3.Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, avg(tax_5) VAT from WalmartSalesData
group by city
order by VAT desc

--4. Which customer type pays the most in VAT?
select Customer_type, avg(tax_5) VAT from WalmartSalesData
group by Customer_type
order by VAT desc

-- Customer
--1. How many unique customer types does the data have?
	select distinct(customer_type), count(*) customer_type_cnt from WalmartSalesData
	group by customer_type

--2. How many unique payment methods does the data have?
	select distinct(Payment), count(*) Payment_cnt from WalmartSalesData
	group by payment 

--3.What is the most common customer type?
	select distinct(customer_type), count(*) customer_type_cnt from WalmartSalesData
	group by customer_type

--4. Which customer type buys the most?
select distinct(customer_type), sum(quantity) customer_type_cnt from WalmartSalesData
group by customer_type

--5. What is the gender of most of the customers?
	select Gender, count(*) gender_cnt from WalmartSalesData
	group by Gender 

--6. What is the gender distribution per branch?
	select branch, gender, count(*) cnt_branchwise from WalmartSalesData
	group by branch, gender
	order by cnt_branchwise desc

--7.Which time of the day do customers give most ratings?
select time_of_day, avg(rating) Avg_Rating, count(*) No_of_rating_received from WalmartSalesData
group by time_of_day


--8. Which time of the day do customers give most ratings per branch?
select time_of_day, avg(rating) Avg_Rating, count(*) No_of_rating_received, Branch from WalmartSalesData
group by time_of_day, Branch
order by No_of_rating_received desc

--9. Which day of the week has the best avg ratings?
	select day_name, avg(Rating) Avg_Rating,count(*) No_of_rating_received from WalmartSalesData
	group by day_name
	order by Avg_Rating desc

--10. Which day of the week has the best average ratings per branch?
select day_name, branch, avg(Rating) Avg_Rating,count(*) No_of_rating_received from WalmartSalesData
group by day_name, Branch
order by Avg_Rating desc
