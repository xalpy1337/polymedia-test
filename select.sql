SELECT
  period_type,
  CASE
    WHEN period_type = 'week' THEN start_date_week
    ELSE start_date_month
  END AS start_date,
  CASE
    WHEN period_type = 'week' THEN start_date_week + INTERVAL '6 days'
    ELSE start_date_month + INTERVAL '1 month' - INTERVAL '1 day'
  END AS end_date,
  salesman_fio,
  chif_fio,
  SUM(sales_count) AS sales_count,
  SUM(sales_sum) AS sales_sum,
  max_overcharge_item,
  MAX(max_overcharge_percent) AS max_overcharge_percent
FROM (
  SELECT
    CASE
      WHEN EXTRACT(ISODOW FROM TO_DATE(sale_date, 'MM/DD/YYYY')) = 1 THEN 'week'
      ELSE 'month'
    END AS period_type,
    DATE_TRUNC('week', TO_DATE(sale_date, 'MM/DD/YYYY'))::DATE AS start_date_week,
    DATE_TRUNC('month', TO_DATE(sale_date, 'MM/DD/YYYY'))::DATE AS start_date_month,
   sellers.fio AS salesman_fio,
    chief.fio AS chif_fio,
    sales.quantity AS sales_count,
    sales.final_price AS sales_sum,
    products.name AS max_overcharge_item,
    ((sales.final_price - products.price::NUMERIC) / products.price::NUMERIC) * 100 AS max_overcharge_percent
  FROM sales
  JOIN products ON sales.item_id = products.id
  JOIN sellers ON sales.salesman_id = sellers.id
  JOIN units ON sellers.department_id = units.department_id
  JOIN sellers AS chief ON units.dep_chif_id = chief.id
) AS SalesData
GROUP BY period_type, start_date_week, start_date_month, salesman_fio, chif_fio, max_overcharge_item
ORDER BY salesman_fio, start_date;

