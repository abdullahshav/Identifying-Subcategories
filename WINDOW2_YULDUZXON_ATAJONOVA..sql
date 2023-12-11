WITH SubcategorySales AS (
    SELECT
        prod_subcategory,
        sales_year,
        SUM(sales) AS total_sales
    FROM
        your_sales_table
    WHERE
        sales_year IN (1998, 1999, 2000, 2001)
    GROUP BY
        prod_subcategory, sales_year
),
PreviousYearSales AS (
    SELECT
        prod_subcategory,
        sales_year,
        LAG(total_sales) OVER (PARTITION BY prod_subcategory ORDER BY sales_year) AS previous_year_sales
    FROM
        SubcategorySales
)
SELECT DISTINCT
    s.prod_subcategory
FROM
    SubcategorySales s
JOIN
    PreviousYearSales p ON s.prod_subcategory = p.prod_subcategory AND s.sales_year = p.sales_year
WHERE
    s.total_sales > COALESCE(p.previous_year_sales, 0);