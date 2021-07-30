-- MYSQL

-- 1. Select first name, last name and email from customer table

select first_name, last_name, email from customer;

-- 2. My understanding is that we have titles that we rent for durations of 3, 5, or 7 days.
-- Could you pull the records of our films and see if there are any other rental durations?”

select distinct(rental_duration) from film where rental_duration not in (3,5,7);

-- 3. I’d like to look at payment records for our long-term customers to learn about their purchase patterns.
-- Could you pull all payments from our first 100 customers (based on customer ID)?

select customer_id, rental_id, amount, payment_date
from payment
where customer_id <= 100
order by customer_id;

-- 4. The payment data you gave me on our first 100 customers was great – thank you!
-- Now I’d love to see just payments over $5 for those same customers, since January 1, 2006.

select customer_id, rental_id, amount, payment_date
from payment
where customer_id <= 100 and amount > 5 and payment_date > '2006-01-01'
order by customer_id;

--5. The data you shared previously on customers 42, 53, 60, and 75 was good to see.
-- Now, could you please write a query to pull all payments from those specific customers, along with payments over $5, from any customer?

select customer_id, rental_id, amount, payment_date
from payment
where customer_id in (43,53,60,75) or amount > 5
order by customer_id;

--6. We need to understand the special features in our films.
-- Could you pull a list of films which include a Behind the Scenes special feature?

select title, special_features
from film
where special_features like '%Behind the Scenes%';

/* 7. “I need to get a quick overview
of how long our movies tend to
be rented out for.
Could you please pull a count of
titles sliced by rental duration?” */
