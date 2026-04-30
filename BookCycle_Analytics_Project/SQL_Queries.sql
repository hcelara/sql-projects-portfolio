--Find the top 3 best-selling books in each genre for BookCycle's Univerity store location.
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
WHERE rank <= 3
ORDER BY total_sales DESC;

--Find the customers who have made purchases above the average order value.
SELECT *
FROM customers 
WHERE customer_id IN ( 
    SELECT customer_id 
    FROM transactions 
    GROUP BY customer_id 
    HAVING SUM(sale_price) > (
        SELECT AVG(sale_price) 
        FROM transactions) 
    );
