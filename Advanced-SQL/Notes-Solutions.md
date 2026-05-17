# Notes 
## Level 1

Currently Working through level 1 

Inner Join - Only what is matched based upon the criteria, this command also **REQUIRES** a **ON** modifier here in order to allow SQL to understand what is what. 

### Five Types of Joins 
1. Inner Join - Where Two tables overlap 
```( Table A ((INNER JOIN - OVERLAP)) Table B)```
2. Left Join - Where the two tables overalp AND THE FULL LEFT Values
```(LEFT JOIN - Table A((LEFT JOIN - OVERLAP)) Table B )```
3. Right Join - Where two tables overlap and full RIGHT Values
```(Table A ((RIGHT JOIN - OVERLAP )) Table B - RIGHT JOIN)```
4. Full Join - JOINING ON BOTH TABLES INCLUDING OVERLAP AND NOT
```(Table A - FULL JOIN ((FULL JOIN - OVERLAP)) Table B - FULL JOIN)```
5. Self Join - Joining with itself (Table A and Table B are different tables for the same table) 
# Solutions

## Level 1

1. 
```sql 
    SELECT 
        customers.first_name,
        customers.last_name,
        count(orders.order_id) as Number_Of_Orders
    FROM customers
    INNER JOIN orders on customers.customer_id = orders.customer_id
    GROUP BY customers.first_name, customers.last_name
```
Originally This was the Plan - But this doesn't account for individuals with NO orders -> potential issues, because of this we would want to update this to a Different type of join where we're matching primarily by the LEFT join (since Left would be Customers)
```sql 
    SELECT 
        customers.first_name,
        customers.last_name,
        count(orders.order_id) as Number_Of_Orders
    FROM customers
    LEFT JOIN orders on customers.customer_id = orders.customer_id
    GROUP BY customers.first_name, customers.last_name
```