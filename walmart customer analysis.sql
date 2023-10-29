
/*Customer type*/
SELECT
	DISTINCT customer_type
FROM sales;

/*Unique payment method*/
SELECT
	DISTINCT payment
FROM sales;

/* Most common customer type */
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

/*Customers by gender*/
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

/*Gender distribution by branch*/
SELECT
	COUNT(gender) as gender_cnt,branch
FROM sales
GROUP BY branch
ORDER BY gender_cnt DESC;

/*Time and day-name vs Revenue*/
select day_name ,time_of_day, round(sum(total),2) as total_revenue
from sales
group by day_name,time_of_day
order by day_name,total_revenue DESC;