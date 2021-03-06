/*
MySQL

Situation: You and your business partner were recently approached by another local business owner
who is interested in purchasing Maven Movies. He primarily owns restaurants and bars, so he
has lots of questions for you about your business and the rental business in general. His offer
seems very generous, so you are going to entertain his questions.

The objective: You and your business partner were recently approached by another local business owner
who is interested in purchasing Maven Movies. He primarily owns restaurants and bars, so he
has lots of questions for you about your business and the rental business in general. His offer
seems very generous, so you are going to entertain his questions.

"Dear Maven Movies Management,
I am excited about the potential acquisition and learning more
about your rental business.
Please bear with me as I am new to the industry, but I have a
number of questions for you. Assuming you can answer them all,
and that there are no major surprises, we should be able to move
forward with the purchase.
Best,
Martin Moneybags"

*/

/*1. My partner and I want to come by each of the stores in person and meet the managers. Please send over
the managers’ names at each store, with the full address of each property (street address, district, city, and
country please).*/

SELECT
    st.store_id,
    staff.last_name AS manager_last_name,
    staff.first_name AS manager_first_name,
    adrs.address,
    adrs.address2,
    adrs.district,
    city.city,
    country.country
FROM
    store AS st
        INNER JOIN
    staff ON st.manager_staff_id = staff.staff_id
        INNER JOIN
    address AS adrs ON st.address_id = adrs.address_id
        INNER JOIN
    city ON adrs.city_id = city.city_id
        INNER JOIN
    country ON city.country_id = country.country_id;

/*2. I would like to get a better understanding of all of the inventory that would come along with the business.
Please pull together a list of each inventory item you have stocked, including the store_id number, the
inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost.*/

SELECT
    inv.inventory_id,
    inv.store_id,
    f.title,
    f.rating,
    f.rental_rate,
    f.replacement_cost
FROM
    inventory AS inv
        INNER JOIN
    film AS f ON inv.film_id = f.film_id;

/*3. From the same list of films you just pulled, please roll that data up and provide a summary level overview of
your inventory. We would like to know how many inventory items you have with each rating at each store. */

SELECT
    store_id,
    SUM(CASE
        WHEN rating = 'PG' THEN 1
        ELSE 0
    END) AS 'PG',
    SUM(CASE
        WHEN rating = 'G' THEN 1
        ELSE 0
    END) AS 'G',
    SUM(CASE
        WHEN rating = 'NC-17' THEN 1
        ELSE 0
    END) AS 'NC-17',
    SUM(CASE
        WHEN rating = 'PG-13' THEN 1
        ELSE 0
    END) AS 'PG-13',
    SUM(CASE
        WHEN rating = 'R' THEN 1
        ELSE 0
    END) AS 'R',
    COUNT(rating) AS 'Total'
FROM
    (SELECT
        inv.inventory_id,
            inv.store_id,
            f.title,
            f.rating,
            f.rental_rate,
            f.replacement_cost
    FROM
        inventory AS inv
    INNER JOIN film AS f ON inv.film_id = f.film_id) AS t1
GROUP BY store_id;

/*4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement
cost, sliced by store and film category.*/

SELECT
    store_id,
    rating,
    AVG(replacement_cost) AS avg_replacement,
    SUM(replacement_cost) AS total_replacement
FROM
    (SELECT
        inv.inventory_id,
            inv.store_id,
            f.title,
            f.rating,
            f.rental_rate,
            f.replacement_cost
    FROM
        inventory AS inv
    INNER JOIN film AS f ON inv.film_id = f.film_id) AS t1
GROUP BY store_id , rating;

/*5. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement
cost, sliced by store and film category.*/

SELECT
    store_id AS store,
    name AS category,
    AVG(replacement_cost) AS avg_replacement,
    SUM(replacement_cost) AS total_replacement
FROM
    (SELECT
        inv.inventory_id,
            inv.store_id,
            f.title,
            f.rating,
            category.name,
            f.rental_rate,
            f.replacement_cost
    FROM
        inventory AS inv
    INNER JOIN film AS f ON inv.film_id = f.film_id
    INNER JOIN film_category AS fc ON f.film_id = fc.film_id
    INNER JOIN category ON fc.category_id = category.category_id) AS t1
GROUP BY store , category;

/*6. We would like to understand how much your customers are spending with you, and also to know who your
most valuable customers are. Please pull together a list of customer names, their total lifetime rentals, and the
sum of all payments you have collected from them. It would be great to see this ordered on total lifetime value,
with the most valuable customers at the top of the list.*/

SELECT
    cs.last_name,
    cs.first_name,
    COUNT(rental.rental_id) AS lifetime_rentals,
    SUM(pay.amount) AS lifetime_value
FROM
    customer AS cs
        INNER JOIN
    rental ON cs.customer_id = rental.customer_id
        INNER JOIN
    payment AS pay ON rental.rental_id = pay.payment_id
GROUP BY cs.customer_id
ORDER BY lifetime_value DESC;

/*7. My partner and I would like to get to know your board of advisors and any current investors. Could you
please provide a list of advisor and investor names in one table? Could you please note whether they are an
investor or an advisor, and for the investors, it would be good to include which company they work with.*/

SELECT
    *
FROM
    (SELECT
        last_name,
            first_name,
            'Advisor' AS type_,
            'Not applicable' AS company
    FROM
        advisor UNION SELECT
        last_name, first_name, 'Investor' AS type_, company_name
    FROM
        investor) AS t
ORDER BY last_name , first_name;

/*8. We're interested in how well you have covered the most-awarded actors. Of all the actors with three types of
awards, for what % of them do we carry a film? And how about for actors with two types of awards? Same
questions. Finally, how about actors with just one award?*/

SELECT
    num_awards,
    num_actors / (num_actors + num_actors_missing) AS 'carrying percentage'
FROM
    (SELECT
        num_awards,
            COUNT(DISTINCT (actor_award.actor_award_id)) AS num_actors
    FROM
        actor_award
    LEFT JOIN (SELECT
        film.title,
            actor_award.actor_award_id,
            actor.actor_id,
            ROUND(LENGTH(awards) - LENGTH(REPLACE(awards, ',', ''))) + 1 AS num_awards
    FROM
        actor_award
    INNER JOIN actor ON CONCAT(actor.last_name, '-', actor.first_name) = CONCAT(actor_award.last_name, '-', actor_award.first_name)
    INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
    INNER JOIN film ON film_actor.film_id = film.film_id) AS t1 ON actor_award.actor_award_id = t1.actor_award_id
    WHERE
        t1.actor_award_id IS NOT NULL
    GROUP BY num_awards
    ORDER BY num_awards) q1
        INNER JOIN
    (SELECT
        ROUND(LENGTH(awards) - LENGTH(REPLACE(awards, ',', ''))) + 1 AS num_awards_missing,
            COUNT(*) AS num_actors_missing
    FROM
        actor_award
    LEFT JOIN (SELECT
        actor_award.actor_award_id,
            actor.actor_id,
            ROUND(LENGTH(actor_award.awards) - LENGTH(REPLACE(actor_award.awards, ',', ''))) + 1 AS num_awards
    FROM
        actor_award
    INNER JOIN actor ON CONCAT(actor.last_name, '-', actor.first_name) = CONCAT(actor_award.last_name, '-', actor_award.first_name)
    INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
    INNER JOIN film ON film_actor.film_id = film.film_id) AS t1 ON actor_award.actor_award_id = t1.actor_award_id
    WHERE
        t1.actor_award_id IS NULL
    GROUP BY num_awards_missing) q2 ON q1.num_awards = q2.num_awards_missing
ORDER BY num_awards DESC;
