use music_database;
SELECT * FROM invoice;
SELECT * FROM employee;
SELECT * FROM album;
SELECT * FROM customer;
SELECT * FROM artist;
SELECT * FROM invoice_line;
SELECT * FROM playlist;
SELECT * FROM track;
SELECT * FROM genre;
SELECT * FROM playlist_track;
/* Who is the senior most employee based on job title? */
SELECT*FROM employee
ORDER BY levels desc 
LIMIT 1
 /*Which countries have the most Invoices? */
 SELECT count(*) as Total_billing ,billing_country
 from invoice
 group by billing_country
 order by Total_billing desc;
 /*What are top 3 values of total invoice? */
 select total  from invoice
 order by total desc
 limit 3;
 /*Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
select billing_city, sum(total) as Total_invoice from invoice
group by billing_city
order by Total_invoice desc limit 1;
/*Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
select customer.customer_id ,customer.first_name,customer.last_name, SUM(total) as spent from customer,invoice
where customer.customer_id=invoice.invoice_id
group by customer_id,first_name, last_name
order by spent desc limit 1;
/*Count how many songs base on genre does customer 12 bought.*/
select  genre.genre_id,genre.name,COUNT(track.name)as Total_track from customer
 JOIN INVOICE ON invoice.CUSTOMER_ID = Customer.CUSTOMER_ID
  JOIN INVOICE_LINE ON Invoice_Line.INVOICE_ID = Invoice.INVOICE_ID
  JOIN TRACK  ON Track.TRACK_ID = Invoice_line.TRACK_ID
  JOIN GENRE ON Genre.GENRE_ID = Track.GENRE_ID
where customer.customer_id=12
group by  genre_id,name
order by Total_track desc
/*How much did customer 13 spent across genres?*/
SELECT C.LAST_NAME,C.FIRSt_NAME,G.NAME GENRE,SUM(IL.UNIT_PRICE)FROM CUSTOMER C
  JOIN INVOICE I ON I.CUSTOMER_ID = C.CUSTOMER_ID
  JOIN INVOICE_LINE IL ON IL.INVOICE_ID = I.INVOICE_ID
  JOIN TRACK T ON T.TRACK_ID = IL.TRACK_ID
  JOIN GENRE G ON G.GENRE_ID = T.GENRE_ID
  WHERE C.CUSTOMER_ID = 13
  GROUP BY 1,2,3
  ORDER BY 1
  /*How much did each customers spent per genre*/
  SELECT C.LAST_NAME,C.FIRSt_NAME,G.NAME GENRE,SUM(IL.UNIT_PRICE)FROM CUSTOMER C
  JOIN INVOICE I ON I.CUSTOMER_ID = C.CUSTOMER_ID
  JOIN INVOICE_LINE IL ON IL.INVOICE_ID = I.INVOICE_ID
  JOIN TRACK T ON T.TRACK_ID = IL.TRACK_ID
  JOIN GENRE G ON G.GENRE_ID = T.GENRE_ID
  GROUP BY 1,2,3
  ORDER BY 1
  /*How much did users spent total per country?*/
  SELECT customer.COUNTRY,customer.first_name,customer.last_name ,sum(invoice.total) as Total from invoice , customer
  where customer.customer_id=invoice.invoice_id GROUP BY 1,2,3  order by Total
  
  /*How many users per country?*/
  select customer.customer_id ,first_name,last_name,country from customer;
  
/*Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
select email, first_name,last_name from customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
where genre.name LIKE "ROCK" and customer.email like "a%"
order by email;

/*Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC
LIMIT 10;
 /* Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
select name,milliseconds from track
where milliseconds >(select avg( milliseconds)as song_length from track)
order by milliseconds desc;

/*Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent */
WITH best_artist AS (
	SELECT artist.artist_id, artist.name,
    SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY artist.artist_id,artist.name
	ORDER BY total_sales DESC
	LIMIT 1
)
SELECT customer.customer_id, customer.first_name, customer.last_name, best_artist.name, 
SUM(invoice_line.unit_price*invoice_line.quantity) AS amount_spent
FROM invoice 
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id = track.album_id
JOIN best_artist ON best_artist.artist_id = album.artist_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name, best_artist.name
ORDER BY amount_spent DESC;

/* We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre with the highest amount of purchases.
 Write a query that returns each country along with the top Genre. 
For countries where the maximum number of purchases is shared return all Genres. */
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY customer.country, genre.name, genre.genre_id
	ORDER BY genre_id DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1
/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1)
