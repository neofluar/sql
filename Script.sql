-- Simple SELECT

SELECT prod_name, prod_id, prod_price
FROM PRODUCTS;

SELECT * FROM Products;

SELECT vend_id FROM Products;

SELECT DISTINCT vend_id FROM Products;

SELECT DISTINCT vend_id, prod_price FROM Products;

-- SELECT vend_id, DISTINCT prod_price FROM Products; -- doesn't work!

SELECT prod_name FROM Products FETCH FIRST 5 ROWS ONLY;

SELECT prod_name FROM Products LIMIT 3;

--This is a comment.

-- ORDER BY (must be at the end)

SELECT prod_name FROM Products ORDER BY prod_name;

SELECT prod_name, prod_price FROM Products ORDER BY prod_price;

SELECT prod_name, prod_id, prod_price FROM Products ORDER BY prod_price, prod_name;

SELECT prod_id, prod_name, prod_price FROM Products ORDER BY prod_price DESC;

SELECT prod_id, prod_name, prod_price FROM Products ORDER BY prod_price DESC, prod_name;

-- WHERE Statement (must be after FROM part)
SELECT prod_name, prod_price FROM Products WHERE prod_price=3.49;

SELECT prod_name, prod_price FROM Products WHERE prod_price<10;

SELECT prod_name, prod_price, vend_id FROM Products WHERE vend_id<>'DLL01';

SELECT prod_name, prod_price, vend_id FROM Products WHERE prod_price BETWEEN 4 AND 10;

SELECT cust_name FROM Customers WHERE cust_email IS NULL;

-- CHAPTER 5 WHERE NOT IN

SELECT prod_id, prod_price, vend_id, prod_name FROM Products
WHERE vend_id = 'DLL01' AND prod_price <= 4;

SELECT prod_id, prod_name, prod_price, vend_id
FROM Products
WHERE vend_id = 'DLL01' OR vend_id = 'BRS01';

SELECT prod_id, prod_name, prod_price, vend_id
FROM Products
WHERE (vend_id = 'DLL01' OR vend_id = 'BRS01') AND prod_price >= 10;

SELECT prod_id, prod_name, vend_id
FROM Products
WHERE vend_id IN ('BRS01', 'DLL01');

SELECT prod_id, prod_name
FROM Products
WHERE NOT vend_id = 'DLL01';

SELECT prod_id, prod_name, prod_price
FROM Products
WHERE NOT vend_id = 'DLL01' AND prod_price > 5;

-- CHAPTER 6 LIKE and Metasymbols %, _, []

SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE 'Fish%';

SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE 'fish%';

SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE '%bean bag%';

SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE 'F%y%';

SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE '__ inch teddy bear%';

SELECT cust_contact 
FROM Customers
WHERE cust_contact LIKE '[^JM]%'; -- is not supported

SELECT cust_contact
FROM Customers
WHERE cust_contact LIKE 'J%' OR cust_contact LIKE 'M%';

-- CHAPTER 7 || RTRIM

SELECT vend_name || ' (' || vend_country || ')'
FROM Vendors
ORDER BY vend_name;

SELECT RTRIM(vend_name) || ' (' || RTRIM(vend_country) || ')'
FROM Vendors
ORDER BY vend_name;

SELECT RTRIM(vend_name) || ' (' || RTRIM(vend_country) || ')' AS vend_title -- doesn't exist
FROM Vendors
ORDER BY vend_name;

SELECT * FROM Vendors;

SELECT * FROM OrderItems;

SELECT prod_id, quantity, item_price
FROM OrderItems
WHERE order_num = 20008;

SELECT prod_id,
       quantity, 
       item_price,
       quantity * item_price AS extended_price
FROM OrderItems
WHERE order_num = 20008;

SELECT extended_price FROM OrderItems;

-- CHAPTER 8 FUNCTIONS: LENGTH, SOUNDEX, UPPER, LOWER, YEAR, ABS, SQRT

SELECT * FROM Vendors;

SELECT vend_name, UPPER(vend_name) AS upper_vend_name
FROM Vendors;

SELECT vend_name, LENGTH(vend_name) as leng_vend_name
FROM Vendors;

SELECT vend_name, LENGTH(TRIM(vend_name)) as true_leng_vend_name
FROM Vendors;

SELECT cust_name, cust_contact 
FROM Customers
WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green');

SELECT order_num
FROM Orders
WHERE YEAR(order_date) = 2012;

SELECT prod_id, prod_name, SQRT(prod_price) as SQRT_PRICE
FROM Products;

-- CHAPTER 9 AVG, MIN, MAX, COUNT, SUM

SELECT AVG(prod_price) as AVG_PROD_PRICE
FROM Products;

SELECT * FROM Products;

SELECT AVG(prod_price) AS dll_avg_price
FROM Products
WHERE vend_id = 'DLL01';

SELECT COUNT(*) AS num_customers
FROM Customers;

SELECT COUNT(cust_email)
FROM Customers;

SELECT MAX(prod_price) AS max_price
FROM Products
WHERE vend_id = 'DLL01';

SELECT MIN(prod_price) AS min_price
FROM Products;

SELECT * FROM OrderItems;

SELECT SUM(quantity)
FROM OrderItems
WHERE order_num = 20005;

SELECT SUM(quantity*item_price)
FROM OrderItems
WHERE order_num = 20005;

SELECT AVG(DISTINCT(prod_price))
FROM Products
WHERE vend_id = 'DLL01';

SELECT COUNT(*) AS num_items,
       MIN(prod_price) AS min_price,
       MAX(prod_price) AS max_price,
       AVG(prod_price) AS avg_price
FROM Products;

-- CHAPTER 10 GROUP BY, HAVING

SELECT COUNT(*)
FROM Products
WHERE vend_id = 'DLL01';

SELECT vend_id, COUNT(*) as num_prods
FROM Products
GROUP BY vend_id;

SELECT cust_id, COUNT(*) AS num_orders
FROM Orders
GROUP BY cust_id
HAVING COUNT(*) >= 2;

SELECT vend_id, COUNT(*) AS num_prods
FROM Products
WHERE prod_price >= 4
GROUP BY vend_id
HAVING COUNT(*) >= 2;

SELECT order_num, COUNT(*) AS items
FROM OrderItems
GROUP BY order_num
HAVING COUNT(*) >= 3
ORDER BY items, order_num;

-- CHAPTER 11 SUBQUERY

SELECT * FROM Orders;
SELECT * FROM Customers;
SELECT * FROM OrderItems;

SELECT order_num
FROM OrderItems
WHERE prod_id = 'RGAN01';

SELECT cust_id
FROM Orders
WHERE order_num IN (SELECT order_num
					FROM OrderItems
					WHERE prod_id = 'RGAN01');
					
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (SELECT cust_id
				  FROM Orders
				  WHERE order_num IN (SELECT order_num
									  FROM OrderItems
					                  WHERE prod_id = 'RGAN01'));
SELECT cust_name,
       cust_state,
       (SELECT COUNT(*)
        FROM Orders
        WHERE Customers.cust_id = Orders.cust_id) AS num_orders
FROM Customers
ORDER BY cust_name;

-- CHAPTER 12 INNER JOIN

SELECT vend_name, prod_name, prod_price
FROM Vendors, Products
WHERE Vendors.vend_id = Products.vend_id;

SELECT vend_name, prod_name, prod_price
FROM Vendors INNER JOIN Products
	ON Vendors.vend_id = Products.vend_id;
	
SELECT prod_name, vend_name, prod_price, quantity
FROM Products, Vendors, OrderItems
WHERE Products.vend_id = Vendors.vend_id
	AND OrderItems.prod_id = Products.prod_id
	AND order_num = '20007';

SELECT prod_name, vend_name, prod_price, quantity
FROM Products 
	INNER JOIN Vendors ON Products.vend_id = Vendors.vend_id
	INNER JOIN OrderItems ON OrderItems.prod_id = Products.prod_id
WHERE order_num = '20007';

SELECT cust_name, cust_contact
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id
	AND Orders.order_num = OrderItems.order_num
	AND OrderItems.prod_id = 'RGAN01';

SELECT cust_name, cust_contact
FROM Customers
	INNER JOIN Orders ON Customers.cust_id = Orders.cust_id
	INNER JOIN OrderItems ON Orders.order_num = OrderItems.order_num
WHERE OrderItems.prod_id = 'RGAN01';

-- CHAPTER 13 SELF-JOIN, LEFT/RIGHT OUTER JOIN, FULL JOIN

SELECT cust_id, cust_name, cust_contact
FROM Customers
WHERE cust_name = (SELECT cust_name
				   FROM Customers
				   WHERE cust_contact = 'Jim Jones');
SELECT * FROM Customers;

SELECT C1.cust_id, C1.cust_name, C1.cust_contact
FROM Customers C1, Customers C2
WHERE C1.cust_name = C2.cust_name
	AND C2.cust_contact = 'Jim Jones';
	
SELECT Customers.cust_id, Orders.order_num
FROM Customers LEFT OUTER JOIN Orders
	ON Customers.cust_id = Orders.cust_id;
	
SELECT Customers.cust_id, Orders.order_num
FROM Customers FULL OUTER JOIN Orders
	ON Customers.cust_id = Orders.cust_id;
	
SELECT Customers.cust_id,
	   COUNT(Orders.order_num) AS num_ords
FROM Customers INNER JOIN Orders ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;

--CHAPTER 14 UNION + UNION ALL

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL', 'IN', 'MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All'
ORDER BY cust_name, cust_contact;

SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL', 'IN', 'MI')
UNION ALL
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';


-- CHAPTER 15 INSERT

SELECT * FROM Customers;

INSERT INTO Customers(cust_id,
					  cust_name,
					  cust_address,
					  cust_city,
					  cust_state,
					  cust_zip,
					  cust_country,
					  cust_contact,
					  cust_email)
VALUES ('1000000006',
		'Toy Land',
		'123 Any Street',
		'New York',
		'NY',
		'11111',
		'USA',
		NULL,
		NULL);

SELECT * FROM Customers;

SELECT * INTO CustCopy FROM Customers; --doesn't work for db2

CREATE TABLE CustCopy LIKE Customers;
INSERT INTO CustCopy (SELECT * FROM Customers);
SELECT * FROM CustCopy;

-- CHAPTER 16 UPDATE, DELETE

SELECT * FROM Customers;

UPDATE Customers
SET cust_email = 'kim@thetoystore.com'
WHERE cust_id = '1000000005';

UPDATE Customers
SET cust_contact = 'Sam Roberts', 
	cust_email = 'sam@toyland.com'
WHERE cust_id = '1000000006';

UPDATE Customers
SET cust_email = NULL
WHERE cust_id = '1000000005';

DELETE FROM Customers
WHERE cust_id = '1000000006';

-- CHAPTER 17 CREATE, ALTER, DROP

SELECT * FROM Vendors;

ALTER TABLE Vendors ADD vend_phone CHAR(20);

ALTER TABLE Vendors
DROP COLUMN vend_phone;

SELECT * FROM CustCopy;

DROP TABLE CustCopy;

-- CHAPTER 18 VIEW

CREATE VIEW ProductCustomers AS
SELECT cust_name, cust_contact, prod_id
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id
  AND OrderItems.order_num = Orders.order_num;
SELECT * FROM ProductCustomers;
SELECT cust_name
FROM ProductCustomers
WHERE prod_id = 'RGAN01';

CREATE VIEW VendorLocations AS
SELECT RTRIM(vend_name) || ' (' || RTRIM(vend_country) || ')' AS vend_title
FROM Vendors;
SELECT * FROM VendorLocations;

DROP VIEW CustomerEmailList;
CREATE VIEW CustomerEmailList AS
SELECT cust_id, cust_name, cust_email
FROM Customers
WHERE cust_email IS NOT NULL;
SELECT * FROM CustomerEmailList;

CREATE VIEW OrderItemsExpanded AS
SELECT order_num, prod_id, quantity, item_price, quantity*item_price AS expanded_price
FROM OrderItems;
SELECT SUM(expanded_price) 
FROM OrderItemsExpanded
WHERE order_num = 20008;

-- CHAPTER 19 PROCEDURE

EXECUTE AddNewProduct('JTS01', 'Stuffed Eiffel Tower', 6.49, 'Plush stuffed toy with the text La Tour Eiffel in red white and blue');

CREATE PROCEDURE MailingListCount(
	ListCount OUT INTEGER
)
IS
	v_rows INTEGER;
BEGIN
	SELECT COUNT(*) INTO v_rows
	FROM Customers
	WHERE cust_email IS NOT NULL;
	ListCount := v_rows
END;

var ReturnValue NUMBER
EXEC MailingListCount(:ReturnValue);
SELECT ReturnValue;
