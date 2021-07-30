--MySQL

/*Dear Maven Movies Management,
In our review of your policy renewal application, we have realized
that your business information has not been updated in a number
of years.
In order to accurately assess the risk and approve your policy
renewal, we will need you to provide all of the following
information.
Sincerely,
Joe Scardycat, Lead Underwriter*/

/*1 We will need a list of all staff members, including their first and last names, email addresses, and the store
identification number where they work.*/

select first_name, last_name, email, store_id
from staff;

/*2 We will need separate counts of inventory items held at each of your two stores.*/

select store_id, count(inventory_id) as number_items
from inventory
group by store_id;

/*3 We will need a count of active customers for each of your stores. Separately, please. */

select store_id,
	sum(case when active = 1 then 1 else 0 end) as number_of_active_customers
from customer
group by store_id;

/*4 In order to assess the liability of a data breach, we will need you to provide a count of all customer email
addresses stored in the database. */

select count(distinct(email)) as emails
from customer;

/*5 We are interested in how diverse your film offering is as a means of understanding how likely you are to
keep customers engaged in the future. Please provide a count of unique film titles you have in inventory at
each store and then provide a count of the unique categories of films you provide. */

select intory.store_id,
	sum(case when sflist.category = 'Documentary' then 1 else 0 end) as documentary,
    sum(case when sflist.category = 'Horror' then 1 else 0 end) as horror,
    sum(case when sflist.category = 'Family' then 1 else 0 end) as family,
    sum(case when sflist.category = 'Foreign' then 1 else 0 end) as _foreign,
    sum(case when sflist.category = 'Comedy' then 1 else 0 end) as comedy,
    sum(case when sflist.category = 'Sports' then 1 else 0 end) as sports,
    sum(case when sflist.category = 'Music' then 1 else 0 end) as music,
    sum(case when sflist.category = 'Classics' then 1 else 0 end) as classics,
    sum(case when sflist.category = 'Animation' then 1 else 0 end) as animation,
    sum(case when sflist.category = 'Action' then 1 else 0 end) as _action,
    sum(case when sflist.category = 'New' then 1 else 0 end) as _new,
    sum(case when sflist.category = 'Sci-fi' then 1 else 0 end) as sci_fi,
    sum(case when sflist.category = 'Drama' then 1 else 0 end) as drama,
    sum(case when sflist.category = 'Travel' then 1 else 0 end) as travel,
    sum(case when sflist.category = 'Games' then 1 else 0 end) as games,
    sum(case when sflist.category = 'Children' then 1 else 0 end) as children,
    count(sflist.category) as _total
from inventory as intory
left join nicer_but_slower_film_list as sflist
on intory.film_id = sflist.FID
group by intory.store_id;

/*6 We would like to understand the replacement cost of your films. Please provide the replacement cost for the
film that is least expensive to replace, the most expensive to replace, and the average of all films you carry.*/

select min(replacement_cost) as min_replace, max(replacement_cost) as max_replace, avg(replacement_cost) as avg_replace
from film;

/*7 We are interested in having you put payment monitoring systems and maximum payment processing
restrictions in place in order to minimize the future risk of fraud by your staff. Please provide the average
payment you process, as well as the maximum payment you have processed.*/


select avg(amount) as avg_payment, max(amount) as max_amount
from payment;

/*8 We would like to better understand what your customer base looks like. Please provide a list of all customer
identification values, with a count of rentals they have made all-time, with your highest volume customers at
the top of the list.*/

select cs.customer_id, count(distinct(rent.rental_id)) as number_of_rentals
from customer as cs
left join rental as rent
on cs.customer_id = rent.customer_id
where rent.rental_id is not Null
group by cs.customer_id
order by number_of_rentals DESC;
 
