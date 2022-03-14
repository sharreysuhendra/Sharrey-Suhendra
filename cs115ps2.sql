-- 1
SELECT CONCAT(firstName, ' ', lastName) AS "full name", email AS "email address"
FROM employees
WHERE (firstName = 'Tom' AND lastName = 'King') OR 
	  (firstName = 'Barry' AND lastName = 'Jones')

-- 2
SELECT ordernumber, orderdate, status
FROM orders
WHERE orderDate >= '2003-04-01' AND orderDate <= '2003-04-30'
ORDER BY orderDate DESC

-- 3
SELECT ordernumber, orderdate
FROM orders O JOIN customers C ON O.customerNumber = C.customerNumber
WHERE customerName = 'Mini Classics'

-- 4
SELECT COUNT(DISTINCT productCode) AS num_products
FROM orderdetails OD 
	JOIN orders O ON OD.orderNumber = O.orderNumber
	JOIN customers C ON O.customerNumber = C.customerNumber
WHERE country != 'USA'

-- 5
SELECT productName, productLine, MSRP
FROM products
WHERE (productline = 'Classic Cars' OR productline = 'Vintage Cars') AND
		MSRP = (SELECT MIN(MSRP)
			   	FROM products
			   	WHERE productline = 'Classic Cars' OR productline = 'Vintage Cars')
				
-- 6
SELECT firstName, lastName, SUM(numOrders) AS numSales
FROM employees E 
	JOIN customers C ON E.employeeNumber = C.salesRepEmployeeNumber 
	JOIN (SELECT customerNumber, COUNT(*) AS numOrders
	 	  FROM orders
	 	  GROUP BY customerNumber) AS ordersPerCustomer ON C.customerNumber = ordersPerCustomer.customerNumber
GROUP BY employeeNumber HAVING SUM(numOrders) >= 25;

-- 7
SELECT customerName, productLine, COUNT(P.productCode) AS numProducts
FROM customers C 
	JOIN orders O ON C.customerNumber = O.customerNumber
	JOIN orderdetails OD ON O.orderNumber = OD.orderNumber	
	JOIN products P ON OD.productCode = P.productCode
GROUP BY customerName, productLine
ORDER BY customerName, productLine

-- 8
SELECT customerName, O1.orderNumber AS orderNum1, O1.orderDate AS orderDate1, O2.orderNumber AS orderNum2, O2.orderDate AS orderDate2
FROM customers C 
	JOIN orders O1 ON C.customerNumber = O1.customerNumber
	JOIN (SELECT customerNumber, orderNumber, orderDate
		  FROM orders) AS O2 ON O1.customerNumber = O2.customerNumber
WHERE O1.orderDate - O2.orderDate = 7

-- 9
SELECT DISTINCT customerName
FROM customers C 
	INNER JOIN orders O ON C.customerNumber = O.customerNumber
WHERE C.customerNumber NOT IN (SELECT customerNumber
						   	   FROM orders O 
							   		INNER JOIN orderdetails OD ON O.orderNumber = OD.orderNumber
							   		INNER JOIN products P ON OD.productCode = P.productCode
						       WHERE buyPrice > 70)
							  
-- 10 
SELECT employeeNumber AS employeeID, COALESCE(SUM(numOrder),0) AS numSales
FROM employees E 
	LEFT OUTER JOIN customers C ON E.employeeNumber = C.salesRepEmployeeNumber
	LEFT OUTER JOIN (SELECT customerNumber, COUNT(orderNumber) AS numOrder
					 FROM orders
					 GROUP BY customerNumber) custOrder ON C.customerNumber = custOrder.customerNumber
GROUP BY employeeID