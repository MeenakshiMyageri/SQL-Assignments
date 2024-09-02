-- 1. First Normal Form (1NF) : Identify a table in the Movenmovies database that violates 1NF. Explain how you would normalize it to achieve 1NF.

		Table Example: Film_category

		Violation: Suppose the Film_category table had multiple categories per film stored in a single row as a comma-separated list or some other non-atomic structure, which violates 1NF because each column should have atomic (indivisible) values.

		Normalization to 1NF: To achieve 1NF, ensure that each column contains atomic values. If Film_category had multiple categories per film, you would need to split these into separate rows.

		Original Violation:
		film_id | categories
		-------------------------
		1       | Action,Comedy
		2       | Drama
		Normalized Form:

		film_id | category_id
		----------------------
		1       | Action
		1       | Comedy
		2       | Drama

		Ensure that category_id and film_id are atomic and that the table does not have repeating groups or arrays.

-- 2. Second Normal Form (2NF): Choose a table in Movenmovies and describe how you would determine whether it is in 2NF. If it violates 2NF, explain the steps to normalize it.
		Table Example: Film_actor

		Determination: To determine if Film_actor is in 2NF, check if all non-key attributes are fully functionally dependent on the entire primary key. In Film_actor, the primary key is (actor_id, film_id).

		In 2NF: If Film_actor only contains attributes directly dependent on the combination of actor_id and film_id (no partial dependencies on part of the composite key), it is in 2NF.

		Violation Example: If Film_actor had additional attributes like actor_name, it would violate 2NF because actor_name is dependent only on actor_id, not on the combination of actor_id and film_id.

			Normalization to 2NF:

			Original Table:
			actor_id | film_id | actor_name
			------------------------------
			1        | 101     | John Doe
			1        | 102     | John Doe

			Normalized Tables:

			Film_actor:

			actor_id | film_id
			-------------------
			1        | 101
			1        | 102


			Actor:

			actor_id | actor_name
			----------------------
			1        | John Doe

			Move actor_name to a separate Actor table to eliminate partial dependencies.
            
            
-- 3. Third Normal Form (3NF): Identify a table in Movenmovies that violates 3NF. Describe the transitive dependencies present and outline the steps to normalize the table to 3NF.
		Identify a table that violates 3NF, describe the transitive dependencies, and outline the steps to normalize it:

		Table Example: Address

		Violation: Assume the Address table has an additional column city_name that is dependent on city_id, which in turn is dependent on address_id.

		Transitive Dependency: address_id -> city_id -> city_name.
		Normalization to 3NF: To normalize to 3NF, remove transitive dependencies by ensuring that non-key attributes are only dependent on the primary key.

		Original Table:
		address_id | address | city_id | city_name
		-------------------------------------------
		1          | 123 Elm  | 10      | Springfield

		Normalized Tables:

		Address:
		address_id | address | city_id
		------------------------------
		1          | 123 Elm  | 10

		City:
		city_id | city_name
		--------------------
		10      | Springfield

		Move city_name to a City table to eliminate transitive dependency.


-- 4. Normalization Process: Take a specific table in Movenmovies and guide through the process of normalizing it from the initial unnormalized form up to at least 2NF.
		Example Table: Customer

		Initial Unnormalized Form:

		customer_id | first_name | last_name | email            | address_id | address    | city
		------------------------------------------------------------------------------------------
		1           | Jane       | Doe       | jane.doe@example.com | 101      | 123 Elm St | Springfield

		Step-by-Step Normalization:

		1. First Normal Form (1NF): Ensure each cell contains atomic values.

				Normalized Form:

				customer_id | first_name | last_name | email
				--------------------------------------------
				1           | Jane       | Doe       | jane.doe@example.com


				address_id | address    | city
				-----------------------------
				101        | 123 Elm St | Springfield

		2. Second Normal Form (2NF): Ensure no partial dependencies. All non-key attributes should be fully dependent on the primary key.

				Customer table is already in 2NF as all non-key attributes depend on customer_id.

		3. Third Normal Form (3NF): Ensure no transitive dependencies.

				Original: If city information is included directly in the Customer table, it introduces transitive dependency (address_id -> city).

				Normalized:

				Customer:
				customer_id | first_name | last_name | email | address_id
				------------------------------------------------------------
				1           | Jane       | Doe       | jane.doe@example.com | 101


				Address:
				address_id | address    | city_id
				--------------------------------
				101        | 123 Elm St | 10

				City:
				city_id | city_name
				--------------------
				10      | Springfield

				Move city-related attributes to City to remove transitive dependencies.

-- 5. CTE Basics: Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have acted in from the actor and film_actor tables.
   use mavenmovies;
		WITH ActorFilmCount AS (
			SELECT
				a.first_name,
				a.last_name,
				COUNT(fa.film_id) AS film_count
			FROM Actor a
			JOIN Film_actor fa ON a.actor_id = fa.actor_id
			GROUP BY a.first_name, a.last_name
		)
		SELECT DISTINCT first_name, last_name, film_count
		FROM ActorFilmCount;


-- 6.Recursive CTE: Use a recursive CTE to generate a hierarchical list of categories and their subcategories from the category table in Movenmovies.

		WITH RecursiveCategory AS (
			SELECT
				category_id,
				name,
				parent_category_id,
				0 AS level
			FROM Category
			WHERE parent_category_id IS NULL

			UNION ALL

			SELECT
				c.category_id,
				c.name,
				c.parent_category_id,
				rc.level + 1
			FROM Category c
			JOIN RecursiveCategory rc ON c.parent_category_id = rc.category_id
		)
		SELECT * FROM RecursiveCategory
		ORDER BY level, parent_category_id, category_id;


-- 7.CTE with Joins: Create a CTE that combines information from the film and language tables to display the film title, language name, and rental rate.

		WITH FilmLanguage AS (
			SELECT
				f.title,
				l.name AS language_name,
				f.rental_rate
			FROM Film f
			JOIN Language l ON f.language_id = l.language_id
		)
		SELECT * FROM FilmLanguage;


-- 8.CTE for Aggregation: Write a query using a CTE to find the total revenue generated by each customer (sum of payments) from the customer and payment tables.
		
        WITH CustomerRevenue AS (
			SELECT
				c.customer_id,
				SUM(p.amount) AS total_revenue
			FROM Customer c
			JOIN Payment p ON c.customer_id = p.customer_id
			GROUP BY c.customer_id
		)
		SELECT * FROM CustomerRevenue;

-- 9.CTE with Window Functions: Utilize a CTE with a window function to rank films based on their rental duration from the film table.

		WITH RankedFilms AS (
    SELECT
        film_id,
        title,
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) 
    FROM Film
)
SELECT
    film_id,
    title,
    rental_duration,
    rank
FROM RankedFilms
ORDER BY rank;



-- 10.CTE and Filtering: Create a CTE to list customers who have made more than two rentals, and then join this CTE with the customer table to retrieve additional customer details.

		WITH FrequentRenters AS (
			SELECT
				r.customer_id,
				COUNT(r.rental_id) AS rental_count
			FROM Rental r
			GROUP BY r.customer_id
			HAVING COUNT(r.rental_id) > 2
		)
		SELECT
			c.customer_id,
			c.first_name,
			c.last_name,
			c.email,
			fr.rental_count
		FROM FrequentRenters fr
		JOIN Customer c ON fr.customer_id = c.customer_id;


-- 11.CTE for Date Calculations: Write a query using a CTE to find the total number of rentals made each month, considering the rental_date from the rental table.

		WITH MonthlyRentals AS (
			SELECT
				DATEPART(YEAR, rental_date) AS year,
				DATEPART(MONTH, rental_date) AS month,
				COUNT(rental_id) AS total_rentals
			FROM Rental
			GROUP BY (YEAR, rental_date), (MONTH, rental_date)
		)
		SELECT * FROM MonthlyRentals
		ORDER BY year, month;


-- 12.CTE for Pivot Operations: Use a CTE to pivot the data from the payment table to display the total payments made by each customer in separate columns for different payment methods.
		
        WITH PaymentPivot AS (
			SELECT
				customer_id,
				payment_method,
				SUM(amount) AS total_amount
			FROM Payment
			GROUP BY customer_id, payment_method
		)
		SELECT
			customer_id,
			SUM(CASE WHEN payment_method = 'Credit Card' THEN total_amount ELSE 0 END) AS credit_card_total,
			SUM(CASE WHEN payment_method = 'Cash' THEN total_amount ELSE 0 END) AS cash_total,
			SUM(CASE WHEN payment_method = 'Debit Card' THEN total_amount ELSE 0 END) AS debit_card_total
		FROM PaymentPivot
		GROUP BY customer_id;

-- 13.CTE and Self-Join: Create a CTE to generate a report showing pairs of actors who have appeared in the same film together, using the film_actor table.
		
        WITH ActorPairs AS (
			SELECT
				fa1.actor_id AS actor1_id,
				fa2.actor_id AS actor2_id,
				fa1.film_id
			FROM Film_actor fa1
			JOIN Film_actor fa2 ON fa1.film_id = fa2.film_id
			WHERE fa1.actor_id < fa2.actor_id
		)
		SELECT
			a1.first_name AS actor1_first_name,
			a1.last_name AS actor1_last_name,
			a2.first_name AS actor2_first_name,
			a2.last_name AS actor2_last_name,
			ap.film_id
		FROM ActorPairs ap
		JOIN Actor a1 ON ap.actor1_id = a1.actor_id
		JOIN Actor a2 ON ap.actor2_id = a2.actor_id;

-- 14.CTE for Recursive Search: Implement a recursive CTE to find all employees in the staff table who report to a specific manager, considering the reports_to column.

		WITH RecursiveStaff AS (
			SELECT
				staff_id,
				first_name,
				last_name,
				reports_to,
				0 AS level
			FROM Staff
			WHERE reports_to IS NULL  -- Change to a specific manager's ID if needed

			UNION ALL

			SELECT
				s.staff_id,
				s.first_name,
				s.last_name,
				s.reports_to,
				rs.level + 1
			FROM Staff s
			JOIN RecursiveStaff rs ON s.reports_to = rs.staff_id
		)
		SELECT * FROM RecursiveStaff;
