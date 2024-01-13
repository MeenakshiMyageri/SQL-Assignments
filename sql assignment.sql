
-- 1. Identify the primary keys and foreign keys in maven movies db. Discuss the differences 
/* solution
-- Primary Key: A primary key is a unique identifier for a record in a table. There are no duplicate values in the primary key column.
-- Foreign Key: A foreign key is a column or a set of columns in a table that refers to the primary key of another table. It establishes a link between the two tables.
*/
select * from information_schema.key_column_usage;

-- 2. List all details of actors
select * from mavenmovies.actor;

-- 3. List all customer information from DB. 
select * from mavenmovies.customer;

-- 4. List different countries. 
select distinct country from mavenmovies.country;

-- 5. Display all active customers.
select customer_id,first_name,last_name,email from mavenmovies.customer where active=1;

-- 6. List of all rental IDs for customer with ID 1. 
select rental_id from mavenmovies.rental where customer_id=1;

-- 7. Display all the films whose rental duration is greater than 5 . 
select film_id,title from mavenmovies.film where rental_duration >5;

-- 8. List the total number of films whose replacement cost is greater than $15 and less than $20. 
select count(*) from mavenmovies.film where replacement_cost between 15 and 20;

-- 9. Display the count of unique first names of actors. 
 select count(distinct first_name) from mavenmovies.actor;


-- 10. Display the first 10 records from the customer table .
select * from mavenmovies.customer limit 10;

-- 11. Display the first 3 records from the customer table whose first name starts with ‘b’. 
select * from mavenmovies.customer where first_name like 'b%' limit 3;

-- 12.Display the names of the first 5 movies which are rated as ‘G’. 
select title from mavenmovies.film where rating= 'G' limit 5;

-- 13.Find all customers whose first name starts with "a". 
select * from mavenmovies.customer where first_name like 'a%';

-- 14.Find all customers whose first name ends with "a". 
select * from mavenmovies.customer where first_name like'%a';

-- 15.Display the list of first 4 cities which start and end with ‘a’ 
select * from mavenmovies.city where city like 'a%a' limit 4;

-- 16.Find all customers whose first name have "NI" in any position. 
select first_name from mavenmovies.customer where first_name like '%ni%';

-- 17.Find all customers whose first name have "r" in the second position .
select first_name from mavenmovies.customer where first_name like '_r%';

-- 18.Find all customers whose first name starts with "a" and are at least 5 characters in length. 
select first_name from mavenmovies.customer where first_name like 'a____%';

 -- 19.Find all customers whose first name starts with "a" and ends with "o". 
 select first_name from mavenmovies.customer where first_name like 'a%o';

 -- 20.Get the films with pg and pg-13 rating using IN operator. 
select title from mavenmovies.film where rating in ('pg','pg-13');

 -- 21.Get the films with length between 50 to 100 using between operator. 
select * from mavenmovies.film where length between 50 and 100;

 -- 22.Get the top 50 actors using limit operator. 
select * from mavenmovies.actor limit 50;

 -- 23.Get the distinct film ids from inventory table. 
select distinct film_id from mavenmovies.inventory; 


