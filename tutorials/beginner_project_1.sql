-- MySQL

SELECT 
    first_name, last_name, email, store_id
FROM
    staff;

/*2 We will need separate counts of inventory items held at each of your two stores.*/

SELECT 
    store_id, COUNT(inventory_id) AS number_items
FROM
    inventory
GROUP BY store_id;

/*3 We will need a count of active customers for each of your stores. Separately, please. */

SELECT 
    store_id,
    SUM(CASE
        WHEN active = 1 THEN 1
        ELSE 0
    END) AS number_of_active_customers
FROM
    customer
GROUP BY store_id;

/*4 In order to assess the liability of a data breach, we will need you to provide a count of all customer email
addresses stored in the database. */

SELECT 
    COUNT(DISTINCT (email)) AS emails
FROM
    customer;

/*5 We are interested in how diverse your film offering is as a means of understanding how likely you are to
keep customers engaged in the future. Please provide a count of unique film titles you have in inventory at
each store and then provide a count of the unique categories of films you provide. */

SELECT 
    intory.store_id,
    SUM(CASE
        WHEN sflist.category = 'Documentary' THEN 1
        ELSE 0
    END) AS documentary,
    SUM(CASE
        WHEN sflist.category = 'Horror' THEN 1
        ELSE 0
    END) AS horror,
    SUM(CASE
        WHEN sflist.category = 'Family' THEN 1
        ELSE 0
    END) AS family,
    SUM(CASE
        WHEN sflist.category = 'Foreign' THEN 1
        ELSE 0
    END) AS _foreign,
    SUM(CASE
        WHEN sflist.category = 'Comedy' THEN 1
        ELSE 0
    END) AS comedy,
    SUM(CASE
        WHEN sflist.category = 'Sports' THEN 1
        ELSE 0
    END) AS sports,
    SUM(CASE
        WHEN sflist.category = 'Music' THEN 1
        ELSE 0
    END) AS music,
    SUM(CASE
        WHEN sflist.category = 'Classics' THEN 1
        ELSE 0
    END) AS classics,
    SUM(CASE
        WHEN sflist.category = 'Animation' THEN 1
        ELSE 0
    END) AS animation,
    SUM(CASE
        WHEN sflist.category = 'Action' THEN 1
        ELSE 0
    END) AS _action,
    SUM(CASE
        WHEN sflist.category = 'New' THEN 1
        ELSE 0
    END) AS _new,
    SUM(CASE
        WHEN sflist.category = 'Sci-fi' THEN 1
        ELSE 0
    END) AS sci_fi,
    SUM(CASE
        WHEN sflist.category = 'Drama' THEN 1
        ELSE 0
    END) AS drama,
    SUM(CASE
        WHEN sflist.category = 'Travel' THEN 1
        ELSE 0
    END) AS travel,
    SUM(CASE
        WHEN sflist.category = 'Games' THEN 1
        ELSE 0
    END) AS games,
    SUM(CASE
        WHEN sflist.category = 'Children' THEN 1
        ELSE 0
    END) AS children,
    COUNT(sflist.category) AS _total
FROM
    inventory AS intory
        LEFT JOIN
    nicer_but_slower_film_list AS sflist ON intory.film_id = sflist.FID
GROUP BY intory.store_id;

/*6 We would like to understand the replacement cost of your films. Please provide the replacement cost for the
film that is least expensive to replace, the most expensive to replace, and the average of all films you carry.*/

SELECT 
    MIN(replacement_cost) AS min_replace,
    MAX(replacement_cost) AS max_replace,
    AVG(replacement_cost) AS avg_replace
FROM
    film;

/*7 We are interested in having you put payment monitoring systems and maximum payment processing
restrictions in place in order to minimize the future risk of fraud by your staff. Please provide the average
payment you process, as well as the maximum payment you have processed.*/


SELECT 
    AVG(amount) AS avg_payment, MAX(amount) AS max_amount
FROM
    payment;

/*8 We would like to better understand what your customer base looks like. Please provide a list of all customer
identification values, with a count of rentals they have made all-time, with your highest volume customers at
the top of the list.*/

SELECT 
    cs.customer_id,
    COUNT(DISTINCT (rent.rental_id)) AS number_of_rentals
FROM
    customer AS cs
        LEFT JOIN
    rental AS rent ON cs.customer_id = rent.customer_id
WHERE
    rent.rental_id IS NOT NULL
GROUP BY cs.customer_id
ORDER BY number_of_rentals DESC;
