-- 1.Join Practice:
-- Write a query to display the customer's first name, last name, email, and city they live in.
select c.first_name,c.last_name,c.email,a.city_id from mavenmovies.customer c join mavenmovies.address a on c.address_id=a.address_id;


-- 2. Subquery Practice (Single Row):
-- Retrieve the film title, description, and release year for the film that has the longest duration.
 select title,description,release_year from mavenmovies.film where length=(select max(length) from mavenmovies.film);


-- 3.Join Practice (Multiple Joins):
-- List the customer name, rental date, and film title for each rental made. Include customers who have never rented a film.
select c.first_name,c.last_name,f.title,r.rental_date from mavenmovies.customer c left join mavenmovies.rental r on c.customer_id=r.customer_id
 left join mavenmovies.inventory i on
 r.inventory_id=i.inventory_id left join mavenmovies.film f on i.film_id=f.film_id;
    
    
-- 4.Subquery Practice (Multiple Rows):
-- Find the number of actors for each film. Display the film title and the number of actors for each film.
select f.title as film_title,count(a.actor_id) as number_of_actors from mavenmovies.film f join mavenmovies.film_actor fa on f.film_id=fa.film_id join mavenmovies.actor a on fa.actor_id=a.actor_id
group by f.title;


-- 5. Join Practice (Using Aliases):
-- Display the first name, last name, and email of customers along with the rental date, film title and rental return date.
select c.first_name,c.last_name,c.email,f.title,r.rental_date,r.return_date from mavenmovies.customer c join mavenmovies.rental r on c.customer_id=r.customer_id
 join mavenmovies.inventory i on
 r.inventory_id=i.inventory_id join mavenmovies.film f on i.film_id=f.film_id;


-- 6.Subquery Practice (Conditional):
-- Retrieve the film titles that are rented by customers whose email domain ends with '.net'.
select title from mavenmovies.film where film_id in(select film_id from mavenmovies.inventory 
where inventory_id in (select inventory_id from mavenmovies.rental where rental_id in (Select rental_id from mavenmovies.customer
 where email like '%.net')));


-- 7. Join Practice (Aggregation):
-- Show the total number of rentals made by each customer, along with their first and last names.
select c.first_name,c.last_name,count(r.rental_id) AS total_rentals  from mavenmovies.customer c join mavenmovies.rental r on c.customer_id=r.customer_id
group by c.first_name,c.last_name order by total_rentals desc;


-- 8.Subquery Practice (Aggregation):
-- List the customers who have made more rentals than the average number of rentals made by all customers.
select customer_id, count(*) AS num_rental
from mavenmovies.rental
group by customer_id
having count(*) > (select avg(rental_count) from (select count(rental_id) as rental_count
 from mavenmovies.rental group by customer_id) as avg_rental);


-- 9.Join Practice (Self Join):
-- Display the customer first name, last name, and email along with the names of other customers living in the same city.
select c.first_name,c.last_name,c.email,ci.city_id from mavenmovies.customer c join mavenmovies.address a on c.address_id=a.address_id 
join mavenmovies.city ci on a.city_id=ci.city_id;


-- 10.Subquery Practice (Correlated Subquery):
-- Retrieve the film titles with a rental rate higher than the average rental rate of films in the same category.

select title, rental_rate from mavenmovies.film f
where rental_rate > (select avg(rental_rate)
from mavenmovies.film
where category_id = f.category_id);

-- 11.Subquery Practice (Nested Subquery):
-- Retrieve the film titles along with their descriptions and lengths that have a rental rate greater 
-- than the average rental rate of films released in the same year.
select title,description,length from mavenmovies.film where rental_rate > (select avg(rental_rate) from mavenmovies.film
where release_year=film.release_year);


-- 12 Subquery Practice (IN Operator):
-- List the first name, last name, and email of customers who have rented at least one film in the 'Documentary' category.
select c.first_name,c.last_name,c.email from mavenmovies.customer c where customer_id in(select distinct c.customer_id 
from mavenmovies.customer c join mavenmovies.rental r on c.customer_id = r.customer_id
join mavenmovies.inventory i on r.inventory_id = i.inventory_id
join mavenmovies.film_category fc on i.film_id = fc.film_id
join mavenmovies.category cat on fc.category_id = cat.category_id
where cat.name = 'Documentary');


-- 13.Subquery Practice (Scalar Subquery):
-- Show the title, rental rate, and difference from the average rental rate for each film.
select title,rental_rate,rental_rate - (select avg(rental_rate) from mavenmovies.film ) as Difference_from_Average_Rental_Rate
 from mavenmovies.film;


-- 14.Subquery Practice (Existence Check):
-- Retrieve the titles of films that have never been rented.
select title from mavenmovies.film where film_id not in (select distinct film_id from mavenmovies.inventory i join 
mavenmovies.rental r on i.inventory_id=r.inventory_id);


-- 15.Subquery Practice (Correlated Subquery - Multiple Conditions):
-- List the titles of films whose rental rate is higher than the average rental rate of films released
-- in the same year and belong to the 'Sci-Fi' category.
select  title from mavenmovies.film f where rental_rate > (select avg(rental_rate)
from mavenmovies.film where  release_year = f.release_year)
and  film_id IN (select  fc.film_id from mavenmovies.film_category fc
join mavenmovies.category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
);


-- 16.Subquery Practice (Conditional Aggregation):
-- Find the number of films rented by each customer, excluding customers who have rented fewer than five films.
select c.customer_id,c.first_name,c.last_name,
count(r.inventory_id) as num_films_rented from mavenmovies.customer c JOIN  mavenmovies.rental r on c.customer_id = r.customer_id
group by  c.customer_id, c.first_name,c.last_name
having count(r.inventory_id) >= 5;

