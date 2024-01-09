WITH subcategory_sales AS (
    SELECT prod_subcategory,
        t.calendar_year AS order_year,
        SUM(s.amount_sold) AS total_sales,
        LAG(SUM(s.amount_sold)) OVER (PARTITION BY prod_subcategory ORDER BY calendar_year) AS prev_year_sales
    FROM sh.sales s
	JOIN sh.products p USING(prod_id)
	JOIN sh.times t USING(time_id)
    WHERE t.calendar_year BETWEEN 1998 AND 2001
    GROUP BY prod_subcategory, t.calendar_year
)
SELECT DISTINCT prod_subcategory, order_year, total_sales, prev_year_sales
FROM subcategory_sales
WHERE total_sales > prev_year_sales;
