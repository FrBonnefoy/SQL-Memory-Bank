-- MYSQL

SELECT 
    first_name, last_name, email
FROM
    customer;

-- 2. My understanding is that we have titles that we rent for durations of 3, 5, or 7 days.
-- Could you pull the records of our films and see if there are any other rental durations?”

SELECT DISTINCT
    (rental_duration)
FROM
    film
WHERE
    rental_duration NOT IN (3 , 5, 7);

-- 3. I’d like to look at payment records for our long-term customers to learn about their purchase patterns.
-- Could you pull all payments from our first 100 customers (based on customer ID)?

SELECT 
    customer_id, rental_id, amount, payment_date
FROM
    payment
WHERE
    customer_id <= 100
ORDER BY customer_id;

-- 4. The payment data you gave me on our first 100 customers was great – thank you!
-- Now I’d love to see just payments over $5 for those same customers, since January 1, 2006.

SELECT 
    customer_id, rental_id, amount, payment_date
FROM
    payment
WHERE
    customer_id <= 100 AND amount > 5
        AND payment_date > '2006-01-01'
ORDER BY customer_id;

-- 5. The data you shared previously on customers 42, 53, 60, and 75 was good to see.
-- Now, could you please write a query to pull all payments from those specific customers, along with payments over $5, from any customer?

SELECT 
    customer_id, rental_id, amount, payment_date
FROM
    payment
WHERE
    customer_id IN (43 , 53, 60, 75)
        OR amount > 5
ORDER BY customer_id;

-- 6. We need to understand the special features in our films.
-- Could you pull a list of films which include a Behind the Scenes special feature?

SELECT 
    title, special_features
FROM
    film
WHERE
    special_features LIKE '%Behind the Scenes%';

/* 7. “I need to get a quick overview
of how long our movies tend to
be rented out for.
Could you please pull a count of
titles sliced by rental duration?” */

SELECT 
    rental_duration,
    COUNT(title) AS films_with_this_rental_duration
FROM
    film
GROUP BY rental_duration;

/* 8. “I’m wondering if we charge more
for a rental when the replacement
cost is higher.
Can you help me pull a count of
films, along with the average,
min, and max rental rate,
grouped by replacement cost?” */

SELECT 
    replacement_cost,
    COUNT(title) AS number_of_films,
    MIN(rental_rate) AS cheapest_rental,
    AVG(rental_rate) AS average_rental,
    MAX(rental_rate) AS most_expensive_rental
FROM
    film
GROUP BY replacement_cost
ORDER BY replacement_cost DESC;

/* 9. “I’d like to talk to customers that
have not rented much from us to
understand if there is something
we could be doing better.
Could you pull a list of
customer_ids with less than 15
rentals all-time?” */

SELECT 
    customer_id, COUNT(rental_id) AS rentals
FROM
    payment
GROUP BY customer_id
HAVING rentals < 15;

/* 10. “I’d like to see if our longest films
also tend to be our most
expensive rentals.
Could you pull me a list of all film
titles along with their lengths
and rental rates, and sort them
from longest to shortest?” */

SELECT 
    title, rental_rate, length
FROM
    film
ORDER BY length DESC;

/* 11. “I’d like to know which store each
customer goes to, and whether or
not they are active.
Could you pull a list of first and
last names of all customers, and
label them as either ‘store 1
active’, ‘store 1 inactive’, ‘store 2
active’, or ‘store 2 inactive’?” */

SELECT 
    first_name,
    last_name,
    CASE
        WHEN store_id = 1 AND active = 1 THEN 'store 1 active'
        WHEN store_id = 1 AND active = 0 THEN 'store 1 inactive'
        WHEN store_id = 2 AND active = 1 THEN 'store 2 active'
        WHEN store_id = 2 AND active = 0 THEN 'store 2 inactive'
        ELSE 'no classification'
    END AS 'store_and_status'
FROM
    customer;

/* 12. Im curious how many inactive
customers we have at each store.
Could you please create a table to
count the number of customers
broken down by store_id (in
rows), and active status (in
columns)?*/

SELECT 
    store_id,
    SUM(CASE
        WHEN active = 1 THEN 1
        ELSE 0
    END) AS 'Active',
    SUM(CASE
        WHEN active = 0 THEN 1
        ELSE 0
    END) AS 'Inactive'
FROM
    customer
GROUP BY store_id;

/* 13 “Can you pull for me a list of each
film we have in inventory?
I would like to see the film’s title,
description, and the store_id value
associated with each item, and its
inventory_id. Thanks!”*/

SELECT 
    f.title, f.description, intry.inventory_id, intry.store_id
FROM
    film AS f
        INNER JOIN
    inventory AS intry ON f.film_id = intry.film_id;

/* 14 “Customers often ask which films
their favorite actors appear in.
It would be great to have a list of
all actors, with each title that they
appear in. Could you please pull
that for me?”*/

SELECT 
    act.first_name, act.last_name, f.title
FROM
    actor AS act
        INNER JOIN
    film_actor AS fact ON act.actor_id = fact.actor_id
        INNER JOIN
    film AS f ON fact.film_id = f.film_id
ORDER BY act.last_name , act.first_name;

/* 15 “One of our investors is interested
in the films we carry and how
many actors are listed for each
film title.

Can you pull a list of all actors, and figure out how many titles are associated to each actor?

Can you pull a list of all titles, and
figure out how many actors are
associated with each title?”*/

SELECT 
    act.first_name,
    act.last_name,
    COUNT(f.title) AS number_of_movies
FROM
    actor AS act
        INNER JOIN
    film_actor AS fact ON act.actor_id = fact.actor_id
        INNER JOIN
    film AS f ON fact.film_id = f.film_id
GROUP BY act.actor_id
ORDER BY number_of_movies DESC;

SELECT 
    f.title, COUNT(act.actor_id) AS number_of_actors
FROM
    actor AS act
        INNER JOIN
    film_actor AS fact ON act.actor_id = fact.actor_id
        INNER JOIN
    film AS f ON fact.film_id = f.film_id
GROUP BY f.title
ORDER BY number_of_actors DESC;

/* 16 “The Manager from Store 2 is
working on expanding our film
collection there.
Could you pull a list of distinct titles
and their descriptions, currently
available in inventory at store 2?”*/

SELECT DISTINCT
    (f.title) AS titles, f.description
FROM
    film AS f
        INNER JOIN
    inventory AS intry ON f.film_id = intry.film_id
WHERE
    intry.store_id = 2;

/*17 “We will be hosting a meeting with
all of our staff and advisors soon.
Could you pull one list of all staff
and advisor names, and include a
column noting whether they are a
staff member or advisor? Thanks!”*/

SELECT 
    *, CONCAT(g.type_staff, '-', g.local_id) AS global_id
FROM
    (SELECT
        advisor_id AS local_id,
            'advisor' AS type_staff,
            last_name,
            first_name
    FROM
        advisor UNION SELECT
        staff_id AS local_id,
            'staff' AS type_staff,
            last_name,
            first_name
    FROM
        staff) AS g
ORDER BY g.last_name , g.first_name;
