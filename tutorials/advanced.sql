-- MySQL

-- Channel conversion analysis

/*
Traffic source analysis is about understanding where your customers are
coming from and which channels are driving the highest quality traffic

• Analyzing search data and shifting budget
towards the engines, campaigns or keywords
driving the strongest conversion rates
• Comparing user behavior patterns across
traffic sources to inform creative and
messaging strategy
• Identifying opportunities to eliminate wasted
spend or scale high-converting traffic
*/

/*1 We've been live for almost a month now and we’re
starting to generate sales. Can you help me understand
where the bulk of our website sessions are coming
from, through yesterday?
I’d like to see a breakdown by UTM source, campaign
and referring domain if possible. Thanks! */

SELECT
    utm_campaign,
    utm_content,
    http_referer,
    COUNT(DISTINCT (website_session_id)) AS sessions
FROM
    website_sessions
WHERE
    created_at < '2012-04-12'
GROUP BY utm_campaign , utm_content , http_referer
ORDER BY sessions DESC;

/*2 Sounds like gsearch nonbrand is our major traffic source, but
we need to understand if those sessions are driving sales.
Could you please calculate the conversion rate (CVR) from
session to order? Based on what we're paying for clicks,
we’ll need a CVR of at least 4% to make the numbers work.
If we're much lower, we’ll need to reduce bids. If we’re
higher, we can increase bids to drive more volume.*/

SELECT
    COUNT(DISTINCT (website_sessions.website_session_id)) AS sessions,
    COUNT(DISTINCT (orders.order_id)) AS orders,
    COUNT(DISTINCT (orders.order_id)) / COUNT(DISTINCT (website_sessions.website_session_id)) AS cvr
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at < '2012-04-14'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand';

-- Bid optimization

/* Analyzing for bid optimization is about understanding the value of various
segments of paid traffic, so that you can optimize your marketing budget

• Using conversion rate and revenue per click
analyses to figure out how much you should
spend per click to acquire customers
• Understanding how your website and products
perform for various subsegments of traffic (i.e.
mobile vs desktop) to optimize within channels
• Analyzing the impact that bid changes have on
your ranking in the auctions, and the volume of
customers driven to your site

*/


/*3 Based on your conversion rate analysis, we bid down
gsearch nonbrand on 2012-04-15.
Can you pull gsearch nonbrand trended session volume, by
week, to see if the bid changes have caused volume to drop
at all? */

SELECT
    DATE(created_at) AS week_start_date,
    COUNT(DISTINCT (website_sessions.website_session_id)) AS sessions
FROM
    website_sessions
WHERE
    website_sessions.created_at < '2012-04-15'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY WEEK(created_at);

/*4 I was trying to use our site on my mobile device the other
day, and the experience was not great.
Could you pull conversion rates from session to order, by
device type?
If desktop performance is better than on mobile we may be
able to bid up for desktop specifically to get more volume?*/

SELECT
    website_sessions.device_type,
    COUNT(DISTINCT (website_sessions.website_session_id)) AS sessions,
    COUNT(DISTINCT (orders.order_id)) AS orders,
    COUNT(DISTINCT (orders.order_id)) / COUNT(DISTINCT (website_sessions.website_session_id)) AS cvr
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at < '2012-05-12'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
group by website_sessions.device_type;


/*5 After your device-level analysis of conversion rates, we
realized desktop was doing well, so we bid our gsearch
nonbrand desktop campaigns up on 2012-05-19.
Could you pull weekly trends for both desktop and mobile
so we can see the impact on volume?
You can use 2012-04-15 until the bid change as a baseline*/

-- Website performance analysis
/*
Website content analysis is about understanding which pages are seen the
most by your users, to identify where to focus on improving your business

• Finding the most-viewed pages that customers
view on your site
• Identifying the most common entry pages to
your website – the first thing a user sees
• For most-viewed pages and most common
entry pages, understanding how those pages
perform for your business objectives
*/

/*1 Could you help me get my head around the site by pulling
the most-viewed website pages, ranked by session volume?*/

/*2 It definitely seems like the homepage, the products page,
and the Mr. Fuzzy page get the bulk of our traffic.
I would like to understand traffic patterns more.
I’ll follow up soon with a request to look at entry pages.*/

/*3 Would you be able to pull a list of the top entry pages? I
want to confirm where our users are hitting the site.
If you could pull all entry pages and rank them on entry
volume, that would be great.*/

-- Landing page performance & testing

/*Landing page analysis and testing is about understanding the performance of
your key landing pages and then testing to improve your results

• Identifying your top opportunities for landing
pages – high volume pages with higher than
expected bounce rates or low conversion rates
• Setting up A/B experiments on your live traffic
to see if you can improve your bounce rates
and conversion rates
• Analyzing test results and making
recommendations on which version of landing
pages you should use going forward

*/

/*1 The other day you showed us that all of our traffic is landing
on the homepage right now. We should check how that
landing page is performing.
Can you pull bounce rates for traffic landing on the
homepage? I would like to see three numbers…Sessions,
Bounced Sessions, and % of Sessions which Bounced
(aka “Bounce Rate”).*/

/*2 Based on your bounce rate analysis, we ran a new custom
landing page (/lander-1) in a 50/50 test against the
homepage (/home) for our gsearch nonbrand traffic.
Can you pull bounce rates for the two groups so we can
evaluate the new page? Make sure to just look at the time
period where /lander-1 was getting traffic, so that it is a fair
comparison.*/

/*3 Based on your bounce rate analysis, we ran a new custom
landing page (/lander-1) in a 50/50 test against the
homepage (/home) for our gsearch nonbrand traffic.
Can you pull bounce rates for the two groups so we can
evaluate the new page? Make sure to just look at the time
period where /lander-1 was getting traffic, so that it is a fair
comparison.*/

-- ANALYZING & TESTING CONVERSION FUNNELS

/* Conversion funnel analysis is about understanding and optimizing each step of
your user’s experience on their journey toward purchasing your products

• Identifying the most common paths customers
take before purchasing your products
• Identifying how many of your users continue
on to each next step in your conversion flow,
and how many users abandon at each step
• Optimizing critical pain points where users are
abandoning, so that you can convert more
users and sell more products
*/

/*1 I’d like to understand where we lose our gsearch visitors
between the new /lander-1 page and placing an order. Can
you build us a full conversion funnel, analyzing how many
customers make it to each step?
Start with /lander-1 and build the funnel all the way to our
thank you page. Please use data since August 5th.*/

/*2 Looks like we should focus on the lander, Mr. Fuzzy page,
and the billing page, which have the lowest click rates.
I have some ideas for the billing page that I think will make
customers more comfortable entering their credit card info.
I’ll test a new page soon and will ask for help analyzing
performance.*/

/*3 We tested an updated billing page based on your funnel
analysis. Can you take a look and see whether /billing-2 is
doing any better than the original /billing page?
We’re wondering what % of sessions on those pages end up
placing an order. FYI – we ran this test for all traffic, not just
for our search visitors.*/

-- Channel portfolio optimization

/* Analyzing a portfolio of marketing channels is about bidding efficiently and
using data to maximize the effectiveness of your marketing budget.

• Understanding which marketing channels are
driving the most sessions and orders through
your website
• Understanding differences in user
characteristics and conversion performance
across marketing channels
• Optimizing bids and allocating marketing spend
across a multi-channel portfolio to achieve
maximum performance

/*1 With gsearch doing well and the site performing better, we
launched a second paid search channel, bsearch, around
August 22.
Can you pull weekly trended session volume since then and
compare to gsearch nonbrand so I can get a sense for how
important this will be for the business?*/

/*2 I’d like to learn more about the bsearch nonbrand campaign.
Could you please pull the percentage of traffic coming on
Mobile, and compare that to gsearch?
Feel free to dig around and share anything else you find
interesting. Aggregate data since August 22nd is great, no
need to show trending at this point.*/

/*3 I’m wondering if bsearch nonbrand should have the same
bids as gsearch. Could you pull nonbrand conversion rates
from session to order for gsearch and bsearch, and slice the
data by device type?
Please analyze data from August 22 to September 18; we
ran a special pre-holiday campaign for gsearch starting on
September 19th, so the data after that isn’t fair game.*/

/*4 Based on your last analysis, we bid down bsearch nonbrand on
December 2nd.
Can you pull weekly session volume for gsearch and bsearch
nonbrand, broken down by device, since November 4th?
If you can include a comparison metric to show bsearch as a
percent of gsearch for each device, that would be great too.*/

-- Analyzing Direct traffic

/* Analyzing your branded or direct traffic is about keeping a pulse on how well
your brand is doing with consumers, and how well your brand drives business

• Identifying how much revenue you are
generating from direct traffic – this is high
margin revenue without a direct cost of
customer acquisition
• Understanding whether or not your paid
traffic is generating a “halo” effect, and
promoting additional direct traffic
• Assessing the impact of various initiatives on
how many customers seek out your business*/

/*1 A potential investor is asking if we’re building any
momentum with our brand or if we’ll need to keep relying
on paid traffic.
Could you pull organic search, direct type in, and paid
brand search sessions by month, and show those sessions
as a % of paid search nonbrand?*/

-- Analyzing Seasonality & Business patterns

/*Analyzing business patterns is about generating insights to help you maximize
efficiency and anticipate future trends

• Day-parting analysis to understand how much
support staff you should have at different
times of day or days of the week
• Analyzing seasonality to better prepare for
upcoming spikes or slowdowns in demand*/

/*1 2012 was a great year for us. As we continue to grow, we
should take a look at 2012’s monthly and weekly volume
patterns, to see if we can find any seasonal trends we
should plan for in 2013.
If you can pull session volume and order volume, that
would be excellent.*/

/*2 We’re considering adding live chat support to the website
to improve our customer experience. Could you analyze
the average website session volume, by hour of day and
by day week, so that we can staff appropriately?
Let’s avoid the holiday time period and use a date range of
Sep 15 - Nov 15, 2013.*/

-- Product Sales analysis

/*1 Analyzing product sales helps you understand how each product contributes to
your business, and how product launches impact the overall portfolio

• Analyzing sales and revenue by product
• Monitoring the impact of adding a new
product to your product portfolio
• Watching product sales trends to understand
the overall health of your business*/

/*2 We’re about to launch a new product, and I’d like to do a
deep dive on our current flagship product.
Can you please pull monthly trends to date for number of
sales, total revenue, and total margin generated for the
business?*/

/*3 We launched our second product back on January 6th. Can
you pull together some trended analysis?
I’d like to see monthly order volume, overall conversion
rates, revenue per session, and a breakdown of sales by
product, all for the time period since April 1, 2013.*/

-- Product level website analysis

/*Product-focused website analysis is about learning how customers interact
with each of your products, and how well each product converts customers

• Understanding which of your products
generate the most interest on multi-product
showcase pages
• Analyzing the impact on website conversion
rates when you add a new product
• Building product-specific conversion funnels to
understand whether certain products convert
better than others*/

/*1 Now that we have a new product, I’m thinking about our
user path and conversion funnel. Let’s look at sessions which
hit the /products page and see where they went next.
Could you please pull clickthrough rates from /products
since the new product launch on January 6th 2013, by
product, and compare to the 3 months leading up to launch
as a baseline? */

/*2 I’d like to look at our two products since January 6th and
analyze the conversion funnels from each product page to
conversion.
It would be great if you could produce a comparison between
the two conversion funnels, for all website traffic.*/

-- Cross-selling products

/* Cross-sell analysis is about understanding which products users are most
likely to purchase together, and offering smart product recommendations

• Understanding which products are often
purchased together
• Testing and optimizing the way you cross-sell
products on your website
• Understanding the conversion rate impact and
the overall revenue impact of trying to crosssell additional products*/

/*1 On September 25th we started giving customers the option
to add a 2nd product while on the /cart page. Morgan says
this has been positive, but I’d like your take on it.
Could you please compare the month before vs the month
after the change? I’d like to see CTR from the /cart page,
Avg Products per Order, AOV, and overall revenue per
/cart page view.*/

/*2 On December 12th 2013, we launched a third product
targeting the birthday gift market (Birthday Bear).
Could you please run a pre-post analysis comparing the
month before vs. the month after, in terms of session-toorder conversion rate, AOV, products per order, and
revenue per session?*/

-- Product Refund analysis

/*Analyzing product refund rates is about controlling for quality and
understanding where you might have problems to address

• Monitoring products from different suppliers
• Understanding refund rates for products at
different price points
• Taking product refund rates and the associated
costs into account when assessing the overall
performance of your business

*/

/*1 Our Mr. Fuzzy supplier had some quality issues which
weren’t corrected until September 2013. Then they had a
major problem where the bears’ arms were falling off in
Aug/Sep 2014. As a result, we replaced them with a new
supplier on September 16, 2014.
Can you please pull monthly product refund rates, by
product, and confirm our quality issues are now fixed?*/

--Analyze repeat behavior

/* Analyzing repeat visits helps you understand user behavior and identify
some of your most valuable customers

• Analyzing repeat activity to see how often
customers are coming back to visit your site
• Understanding which channels they use when
they come back, and whether or not you are
paying for them again through paid channels
• Using your repeat visit activity to build a better
understanding of the value of a customer in
order to better optimize marketing channels

*/

/*1 We’ve been thinking about customer value based solely on
their first session conversion and revenue. But if customers
have repeat sessions, they may be more valuable than we
thought. If that’s the case, we might be able to spend a bit
more to acquire them.
Could you please pull data on how many of our website
visitors come back for another session? 2014 to date is good. */

select count(distinct(user_id)) from website_sessions
where is_repeat_session = 1 and year(created_at)>=2014;

/*2 Ok, so the repeat session data was really interesting to see.
Now you’ve got me curious to better understand the behavior
of these repeat customers.
Could you help me understand the minimum, maximum, and
average time between the first and second session for
customers who do come back? Again, analyzing 2014 to date
is probably the right time period.*/

/*3 Let’s do a bit more digging into our repeat customers.
Can you help me understand the channels they come back
through? Curious if it’s all direct type-in, or if we’re paying for
these customers with paid search ads multiple times.
Comparing new vs. repeat sessions by channel would be
really valuable, if you’re able to pull it! 2014 to date is great. */

/*4 Sounds like you and Tom have learned a lot about our repeat
customers. Can I trouble you for one more thing?
I’d love to do a comparison of conversion rates and revenue per
session for repeat sessions vs new sessions.
Let’s continue using data from 2014, year to date.*/
