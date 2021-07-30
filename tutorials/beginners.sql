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

select rental_duration, count(title) as films_with_this_rental_duration
from film
group by rental_duration;

/* 8. “I’m wondering if we charge more
for a rental when the replacement
cost is higher.
Can you help me pull a count of
films, along with the average,
min, and max rental rate,
grouped by replacement cost?” */

select replacement_cost, count(title) as number_of_films, min(rental_rate) as cheapest_rental, avg(rental_rate) as average_rental, max(rental_rate) as most_expensive_rental
from film
group by replacement_cost
order by replacement_cost DESC;

/* 9. “I’d like to talk to customers that
have not rented much from us to
understand if there is something
we could be doing better.
Could you pull a list of
customer_ids with less than 15
rentals all-time?” */

select customer_id, count(rental_id) as rentals
from payment
group by customer_id
having rentals <15;

/* 10. “I’d like to see if our longest films
also tend to be our most
expensive rentals.
Could you pull me a list of all film
titles along with their lengths
and rental rates, and sort them
from longest to shortest?” */

select title, rental_rate, length
from film
order by length DESC;

/* 11. “I’d like to know which store each
customer goes to, and whether or
not they are active.
Could you pull a list of first and
last names of all customers, and
label them as either ‘store 1
active’, ‘store 1 inactive’, ‘store 2
active’, or ‘store 2 inactive’?” */

select first_name, last_name,
	case when store_id = 1 and active = 1 then 'store 1 active'
		 when store_id = 1 and active = 0 then 'store 1 inactive'
         when store_id = 2 and active = 1 then 'store 2 active'
         when store_id = 2 and active = 0 then 'store 2 inactive'
         else 'no classification'
         end as 'store_and_status'
from customer

/* 12. “I’m curious how many inactive
customers we have at each store.
Could you please create a table to
count the number of customers
broken down by store_id (in
rows), and active status (in
columns)?” */

select store_id,
	sum(case when active=1 then 1
			   else 0
               end) as 'Active',
	sum(case when active=0 then 1
			   else 0
               end) as 'Inactive'
from customer
group by store_id
