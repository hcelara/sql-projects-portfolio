WITH sales_by_book AS (
    SELECT book_id, SUM(sale_price) AS total_sales
    FROM transactions
    WHERE store_location = 'University'
    GROUP BY book_id
),
ranked_books AS (
    SELECT b.genre, b.title, sbb.total_sales,
           ROW_NUMBER() OVER (PARTITION BY b.genre ORDER BY sbb.total_sales DESC) AS rank
    FROM books b
    JOIN sales_by_book sbb ON b.book_id = sbb.book_id
)
SELECT genre, title, total_sales, rank
FROM ranked_books
WHERE rank = 1
ORDER BY total_sales DESC;