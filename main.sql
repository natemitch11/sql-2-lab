-- Join
-- Get all invoices where the unit_price on the invoice_line is greater than $0.99.
select * from invoice_line 
where unit_price > 0.99;
-- Get the invoice_date, customer first_name and last_name, and total from all invoices.
select i.invoice_date, c.first_name, c.last_name, i.total 
from invoice i 
join customer c on i.customer_id = c.customer_id;
-- Get the customer first_name and last_name and the support rep’s first_name and last_name from all customers. Support reps are on the employee table.
select c.first_name customer_firstname, c.last_name customer_lastname, s.first_name rep_firstname, s.last_name rep_lastname
from customer c
join employee s on c.support_rep_id = s.employee_id; 
-- Get the album title and the artist name from all albums.
select al.title album_title, ar.name artist_name
from album al 
join artist ar on al.artist_id = ar.artist_id;
-- Get all playlist_track track_ids where the playlist name is Music.
select pl.track_id
from playlist_track pl
join playlist p on pl.playlist_id = p.playlist_id
where p.name = 'Music';
-- Get all track name`s for `playlist_id.
select tr.name
from track tr
join playlist_track p on p.track_id = tr.track_id;
-- Get all track name`s and the playlist `name that they’re on ( 2 joins ).
select tr.name track_name, pl.name playlist_name
from track tr
join playlist_track p on p.track_id = tr.track_id
join playlist pl on pl.playlist_id = p.playlist_id;
-- Get all track name`s and album `title`s that are the genre `Alternative & Punk ( 2 joins ).
select tr.name track_name, al.title album_title
from track tr
join genre g on tr.genre_id = g.genre_id
join album al on tr.album_id = al.album_id
where g.genre_id in(
	select genre_id
    from genre
    where genre.name in ('Alternative', 'Punk')
);
-- Subqueries
-- Get all invoices where the unit_price on the invoice_line is greater than $0.99.
select * 
from invoice
where invoice_id in (
    select invoice_id 
    from invoice_line
    where unit_price > 0.99
);
-- Get all playlist tracks where the playlist name is Music.
select track_id
from playlist_track
where playlist_id in (
    select playlist_id
    from playlist
    where playlist.name like 'Music'
);
-- Get all track names for playlist_id 5.
select track_id
from playlist_track
where playlist_id in (
    select playlist_id
    from playlist
    where playlist.playlist_id = 5
);
-- Get all tracks where the genre is Comedy.
select track_id
from track
where genre_id in (
    select genre_id
    from genre
    where genre.name = 'Comedy'
);
-- Get all tracks where the album is Fireball.
select track_id
from track
where album_id in (
    select album_id
    from album
    where album.name = 'Fireball'
);
-- Get all tracks for the artist Queen ( 2 nested subqueries ).
select track_id
from track
where album_id in (
    select album_id
    from album
    where album.artist_id in(
    	select artist_id
      from artist
      where artist.name = 'Queen'
    )
);
-- Create View
-- Create a view called rock that selects all the tracks where the genre is Rock.
create view rock as
select track_id
from track
where genre_id in (
    select genre_id
    from genre
    where genre.name = 'Rock'
);
-- Create a view called classical_count that gets a count of all the tracks from the playlist called Classical.
create view classical_count as
select count(*)
from track
where track_id in (
    select track_id
    from playlist_track pt
    where pt.track_id in (
        select track_id
        from playlist p
        where p.name = 'Classical'
    )
);
-- Update
-- Find all customers with fax numbers and set those numbers to null.
update customer 
set fax = null
where fax is not null;
-- Find all customers with no company (null) and set their company to “Self”.
update customer 
set company = 'Self'
where company is null;
-- Find the customer Julia Barnett and change her last name to Thompson.
update customer 
set last_name = 'Thompson'
where customer_id in(
	select customer_id
  from customer
  where first_name = 'Julia'
  and last_name = 'Barnett'
);
-- Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.
update customer 
set support_rep_id = 4
where customer_id in(
	select customer_id
  from customer
  where email = 'luisrojas@yahoo.cl'
);
-- Find all tracks that are the genre Metal and have no composer. Set the composer to “The darkness around us”.
update track 
set composer = 'The darkness around us'
where genre_id in(
	select genre_id
  from genre
  where name = 'Metal'
)
and composer is null;
-- Delete all ‘lion’ entries from the table.
delete from animals where animals.type = 'lion';
-- Delete all animals whose names start with “M”.
delete from animals where animals.name like 'M%';
-- Delete all entries whose age is less than 9.
delete from animals where animals.age < 9;

 -------------------------------------------------------------------------------------------------
-- Intermediate - Alter Table
-- Copy, paste, and run the insert statement from the delete section above. (You should have deleted all the entries.)
-- Add a column to the animals table called “location”. It should have a VARCHAR data type.
alter table animals 
add location varchar(100);
-- Insert 3 new animals into the table – make sure none of their fields are null.
insert into animals (name, age, type, location) 
values ('Pikachu', 21, 'Electric Mouse', 'Kanto'), 
('Cyndaquil', 17, 'Fire Mouse', 'Johto'),
('Squirtle', 21, 'Water Turtle', 'Kanto');
-- Change the “type” column’s name to be “species”.
alter table animals
rename column type to species;
-- Change the “species” column data type to be VARCHAR.
alter table animals
alter column species varchar(100);
-- Intermediate - Group By
-- Find a count of how many tracks there are per genre. Display the genre name with the count.
select g.name, count(*) 
from track t
join genre g on t.genre_id = g.genre_id
group by g.name;
-- Find a count of how many tracks are the “Pop” genre and how many tracks are the “Rock” genre.
select g.name, count(*) 
from track t
join genre g on t.genre_id = g.genre_id
where g.name in ('Pop', 'Rock')
group by g.name;
-- Find a list of all artists and how many albums they have.
select ar.name, count(*) album_count 
from artist ar
join album al on ar.artist_id = al.artist_id
group by ar.name;
--------------------------------------------------------------------------------------------------

--eCommerce Simulation - No Hints
-- Let’s simulate an e-commerce site. We’re going to need to keep track of users, products, and the products users have added to their cart.
-- users need an id, name, and an email
-- products need an id, name, and a price
-- cart should be a middle table that has an id, references both users and products, and has a quantity

-- Instructions --------------------------------------------------------------------------------

-- Create 3 tables following the criteria in the summary.
create table users (id serial primary key, name varchar(100), email varchar(100));
create table products (id serial primary key, name varchar(100), price int);
create table cart (id serial primary key, user_id int references users(id), product_id int references products(id), quantity int);

-- Add some data to fill up each table.
-- At least 3 users
insert into users (name, email)
values ('Bob Saget', 'bobsaget@gmail.com'),
('Jaquin Phoenix', 'RUNotEntertained@gmail.com'),
('Christian Bale', 'TDKR@gmail.com');
-- At least 5 products
insert into products (name, price)
values ('Javelin', 199),
('Peanut Butter', 4.99),
('Grappling Hook', 1099.99),
('Video Camera', 499),
('Bat-a-rang', 199);
-- Each user should have at least 2 different products in their cart
insert into cart (user_id, product_id, quantity)
values (1, 2, 3),
(1, 4, 4),
(2,1,5),
(2,4,2),
(3,3,2),
(3,5,10);
-- Run queries against your data.
-- Get all products in your first user’s cart
select u.name, p.name, quantity
from cart c
join users u on c.user_id = u.id
join products p on c.product_id = p.id
where c.user_id = 1;
-- Get products in all carts with all the users’ information
select u.name, p.name, quantity
from cart c
join users u on c.user_id = u.id
join products p on c.product_id = p.id;
-- Get the total cost of an order (sum the price of all products on an cart).
select sum(c.quantity*p.price) as total_price
from cart c
join users u on c.user_id = u.id
join products p on c.product_id = p.id
where c.user_id = 1;
-- Update the quantity of a product in a user’s cart where the user’s id is 2
update cart
set quantity = 7
where user_id = 2;