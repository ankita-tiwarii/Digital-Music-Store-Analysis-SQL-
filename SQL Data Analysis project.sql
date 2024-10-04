-- 1 Who is the senior most employee based on the job title

select * from employee
order by levels 
limit 1;

-- 2 which countries have the most Invoices 

select count(*) as c  , billing_country from invoice 
group by billing_country
order by c desc;

-- 3 what are top 3 values of invoice

select total from invoice 
order by total desc
limit 3;

/* 4 which city has the best customers ? we would like to through a 
 promotional music festival in the city we made the most money.
 write a query that returns one city that has the highest sum of 
 invoice totals 
return both the city name and sum of all invoice totals. */

select sum(total) as invoice_total , billing_city from invoice 
group by billing_city 
order by invoice_total desc ;

/* write query to return the email ,firstname , lastname and
 genre of all rock music listners . 
 return your list ordered alphabetically by email 
starting with A */

select email , first_name , last_name 
from customer 
join invoice on
invoice.customer_id = customer.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
        select track_id from track
        join genre on track.genre_id = genre.genre_id
        where genre.name like "rock"
        )
order by email asc  ;


/* Return all the track names that have a song length longer than the avg
song length return the name and miliseconds for each track order by the 
song length with the longest songs listed first */
select name , milliseconds from track 
where milliseconds > ( select avg(milliseconds) as avg_track_len from track)
order by milliseconds desc;

/* we want to find out the most popular music genre for each country.
we determine the most popular genre as the genre with the highest amount 
of purchases */
with popular_genre as
( select count(invoice_line.quantity) as purchases , customer.country ,
genre.name , genre.genre_id , 
row_number() over(partition by customer.country  
order by count(invoice_line.quantity) desc) as rowno
from invoice_line
join invoice on invoice.invoice_id = invoice_line.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by 2,3,4
order by 2 asc , 1 desc )
select* from popular_genre where rowno <= 1 

/* write a query thatdetermines the customer that has spent the most on
for each country , write a query that returns the country along with the top
customer and how much they spent ,
fro countries where the top amount spent is shared , provide all customers
who spent this amount */

WITH Customer_with_country as (
  select customer.customer_id , first_name , last_name , billing_country ,
  sum(total) as total_spending ,
  row_number() over (partition by billing_country order by sum(total)
  desc)  as rowno
  from invoice
  join customer on customer.customer_id = invoice.customer_id
  group by 1,2,3,4
  order by 4 asc , 5 desc)
select * from Customer_with_country where rowno <= 1 
    















