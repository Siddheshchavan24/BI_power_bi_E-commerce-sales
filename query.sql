CREATE TABLE ecommerce_transactions(
    User_ID VARCHAR(50),
    Product_ID VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    Discount INT,
    Final_Price DECIMAL(10, 2),
    Payment_Method VARCHAR(50),
    Purchase_Date TEXT
);

INSERT INTO ecommerce_transactions
SELECT 
    User_ID,
    Product_ID,
    Category,
    Price,
    Discount,
    Final_Price,
    Payment_Method,
    TO_DATE(Purchase_Date, 'DD-MM-YYYY')
FROM ecommerce_transactions;

SELECT * FROM ecommerce_transactions LIMIT 10;

-- Check for any null values or unexpected data in key columns
SELECT 
    COUNT(*) AS total_rows,
    COUNT(User_ID) AS total_users,
    COUNT(Product_ID) AS total_products,
    COUNT(Purchase_Date) AS total_dates
FROM ecommerce_transactions;

-- Add extracted month and year columns for analysis
ALTER TABLE ecommerce_transactions
ADD COLUMN Purchase_Month INT,
ADD COLUMN Purchase_Year INT;

--Top 5 Best-Selling Products by Revenue
SELECT 
    Product_ID, 
    SUM(Final_Price) AS Total_Revenue
FROM ecommerce_transactions
GROUP BY Product_ID
ORDER BY Total_Revenue DESC
LIMIT 5;


--Monthly Revenue Trends
SELECT 
    Purchase_Year, 
    Purchase_Month, 
    SUM(Final_Price) AS Monthly_Revenue
FROM ecommerce_transactions
GROUP BY Purchase_Year, Purchase_Month
ORDER BY Purchase_Year DESC, Purchase_Month DESC;

--Customer Who Spent the Most
SELECT 
    User_ID, 
    SUM(Final_Price) AS Total_Spent
FROM ecommerce_transactions
GROUP BY User_ID
ORDER BY Total_Spent DESC
LIMIT 1;

--Most Popular Product Categories
SELECT 
    Category, 
    SUM(Final_Price) AS Total_Revenue
FROM ecommerce_transactions
GROUP BY Category
ORDER BY Total_Revenue DESC;


--Average Order Value per Month
SELECT 
    Purchase_Year, 
    Purchase_Month, 
    AVG(Final_Price) AS Avg_Order_Value
FROM ecommerce_transactions
GROUP BY Purchase_Year, Purchase_Month
ORDER BY Purchase_Year DESC, Purchase_Month DESC;


--Monthly Growth Rate in Orders/Revenue
WITH Monthly_Revenue AS (
    SELECT 
        Purchase_Year, 
        Purchase_Month, 
        COUNT(*) AS Total_Orders,
        SUM(Final_Price) AS Monthly_Revenue
    FROM ecommerce_transactions
    GROUP BY Purchase_Year, Purchase_Month
)
SELECT 
    Purchase_Year,
    Purchase_Month,
    Monthly_Revenue,
    LAG(Monthly_Revenue) OVER (ORDER BY Purchase_Year, Purchase_Month) AS Previous_Month_Revenue,
    ((Monthly_Revenue - LAG(Monthly_Revenue) OVER (ORDER BY Purchase_Year, Purchase_Month)) / LAG(Monthly_Revenue) OVER (ORDER BY Purchase_Year, Purchase_Month)) * 100 AS Revenue_Growth_Percentage
FROM Monthly_Revenue;


SELECT * FROM ecommerce_transactions;


