/* ·00· we can employ the USE clause to call the database*/ 
USE sakila;

/* ·01· Selecciona todos los nombres de las películas sin que aparezcan duplicados.*/

SELECT DISTINCT title AS Titulo /*showing without the duplicates we can use the SELECT DISTINCT clause*/
FROM film 

/* ·02· Muestra los nombres de todas las películas que tengan una clasificación de "PG-13". */

SELECT title
from film
WHERE rating = 'PG-13';

/* ·03· Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en
su descripción */

SELECT title, description
FROM film
WHERE description LIKE '%amazing%'; /* to seach for values that follow a spescific pattern in a column.*/

/* ·04· Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */

SELECT title, length
FROM film
WHERE length > 120 
ORDER BY length DESC;

SELECT *
FROM actor

/* ·05· Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame
nombre_actor y contenga nombre y apellido. */

SELECT
	CONCAT(first_name, ' ', last_name) AS nombre_actor /*CONCAT command merge data drom different colums into a single representation. */
FROM actor;

/* ·06· Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido. */

SELECT
	CONCAT(first_name, ' ' , last_name) AS nombre_actor
FROM actor
WHERE last_name like '%gibson%';

/* ·07·  Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20. */

SELECT first_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20; /*BETWEEN filters the entries within a range, including the endpoints*/

/* ·08· Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13". */

SELECT title
from film
WHERE rating NOT IN ('R','PG-13'); /* NOT IN clause excludes values*/

/* ·09· Encuentra la cantidad total de películas en cada clasificación de la tabla film y 
muestra la clasificación junto con el recuento. */

SELECT rating, COUNT(*) AS rated_films
FROM film
GROUP BY rating
ORDER BY CASE 
	WHEN rating = 'NC-17' THEN 1
    WHEN rating = 'R' THEN 2
    WHEN rating = 'PG-13' THEN 3
    WHEN rating = 'PG' THEN 4
    WHEN rating = 'G' THEN 5
    END;

/* ·10· Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su
nombre y apellido junto con la cantidad de películas alquiladas. */

SELECT 
	c.customer_id AS client_id,
    CONCAT(c.first_name, ' ' , c.last_name) AS client_name,
    COUNT(r.rental_id) AS total_rented_films
FROM customer c 
LEFT JOIN rental r  /*includes all values of the customer table, even it there´re no matches in rental table*/
ON c.customer_id = r.customer_id  /*present in both tables*/
GROUP BY c.customer_id /*we group by customer_id so we can count how many films each one has rented*/
ORDER BY total_rented_films;

/* ·11· Encuentra la cantidad total de películas alquiladas por categoría y 
muestra el nombre de la categoría junto con el recuento de alquileres. */

SELECT
	c.name AS category,
    COUNT(r.rental_id) AS total_films_rented
FROM category c
INNER JOIN film_category fc /*we use INNER JOIN because we are only interested in movies that have been rentes. So we are not lookingvale,  at any NULL data*/
ON c.category_id = fc.category_id
INNER JOIN film f /*stands for films. each film has a unique ID*/
ON fc.film_id = f.film_id
INNER JOIN inventory i /*refers to the physical copies of each movie*/
ON f.film_id = i.film_id
INNER JOIN rental r /*indicates the number of times that each copy of every film has been rented*/
ON i.inventory_id = r.inventory_id /*enables to track the number os times a physical copy of the same film were rented*/
GROUP BY c.name
ORDER BY total_films_rented ASC;


/* ·12· Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y
muestra la clasificación junto con el promedio de duración. */

SELECT
	rating,
    AVG(length) AS average_length /*AVG operator calculates the average of the selected data*/
FROM film
GROUP BY rating
ORDER BY average_length ASC;

/* ·13· Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love". */

SELECT a.first_name AS name, a.last_name AS surname
FROM actor a
INNER JOIN film_actor fa /*ensures that only values that match are includes in the tables*/
ON a.actor_id = fa.actor_id
INNER JOIN film f
ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love';

/* ·14· Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción. */

SELECT title
FROM film
WHERE /*the result will display the values that meet the specified condition*/
	LOWER(description) LIKE '%dog%' OR LOWER(description) LIKE '%cat%';

/* ·15· Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor. */

SELECT a.first_name AS name, a.last_name AS surname
FROM actor a
LEFT JOIN film_actor fa /*includes all the records from the primary table, even if there are no matches in the secondary table*/
ON a.actor_id = fa.actor_id /*If a vallue doesn´t macth in the secondary table. it will display as NULL*/
WHERE fa.actor_id IS NULL; /*filters to ensure that only NULL records are returned*/

/* ·16· Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010. */
SELECT title, release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010
ORDER BY release_year DESC;

SELECT *
FROM category;

/* ·17· Encuentra el título de todas las películas que son de la misma categoría que "Family". */

SELECT c.name AS category, f.title
FROM category c
INNER JOIN film_category fa
ON c.category_id = fa.category_id
INNER JOIN film f
ON fa.film_id = f.film_id
WHERE c.name = 'family';

/* ·18· Muestra el nombre y apellido de los actores que aparecen en más de 10 películas. */

SELECT
	CONCAT(first_name, ' ', last_name) AS actor_name
FROM actor
WHERE actor_id IN (  /* we utilise the subquery to find the values from the main query wo have appeared in more than 10 movies*/
	SELECT actor_id
    FROM film_actor
    GROUP BY actor_id /*group the records of the table for the value. It means that each group includes all the films associated with an actor*/
    HAVING COUNT(film_id) >10); /*filters to include only actors with more than 10 movies*/


/* ·19· Encuentra el título de todas las películas que son "R" y 
tienen una duración mayor a 2 horas en la tabla film. */

SELECT title
FROM film
WHERE rating = 'R' AND length > 120;

/* ·20· Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y 
muestra el nombre de la categoría junto con el promedio de duración. */

SELECT 
	c.name AS category,
	AVG(f.length) AS average_length
FROM category c /*contains the information about the categories*/
INNER JOIN film_category fa /*intermediate link to connect the categories with films*/
ON c.category_id = fa.category_id
INNER JOIN film f /*contains the information about films*/
ON fa.film_id = f.film_id
WHERE f.length > 120 /*only include films that are longer than 2 hours in the filter*/
GROUP BY c.name
HAVING AVG(f.length) > 120 /*Filters again after calculating the average length. This will make sure that the categories only include those that fulfil the condition*/
ORDER BY average_length DESC;

/* ·21· Encuentra los actores que han actuado en al menos 5 películas y 
muestra el nombre del actor junto con la cantidad de películas en las que han actuado. */

SELECT 
	CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
	COUNT(fa.film_id) AS total_movies
FROM actor a
INNER JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) >= 5
ORDER BY total_movies ASC;


/* ·22· Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y 
luego selecciona las películas correspondientes. 
Pista: Usamos DATEDIFF para calcular la diferencia entre una
fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final). */

SELECT f.title AS movie  /*main query to find the title in the film table that match the subquerys*/
FROM film f
WHERE f.film_id IN (
	SELECT i.film_id
    FROM inventory i
    WHERE i.inventory_id IN (  /*To select the values that fulfil the condition in the following subquery*/
		SELECT r.inventory_id
        FROM rental r
        WHERE DATEDIFF(r.return_date, r.rental_date) > 5)); /*To only include rents where the difference is more than 5*/
        

/* ·23· Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y 
luego exclúyelos de la lista de actores. */

SELECT a.first_name, a.last_name /*In the main query, we select the values and filter them in order to exclude those that don´t feature in the subquery*/
FROM actor a
WHERE a.actor_id NOT IN ( /*the subquery returns a list of actors who have played horror films*/
	SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film_category fc
    ON fa.film_id = fc.film_id
    INNER JOIN category c
    ON fc.category_id = c.category_id
    WHERE LOWER(c.name) = 'horror');
 
/* ·24· BONUS: Encuentra el título de las películas que son comedias y 
tienen una duración mayor a 180 minutos en la tabla film con subconsultas. */


SELECT name
FROM category;

SELECT title, length /*the main query to find the titles and the length of the films*/
FROM film i
WHERE i.film_id IN ( /*First subquery to find the film id related to the result of the next subquery*/
    SELECT fc.film_id
    FROM film_category fc
    WHERE fc.category_id IN ( /*Second subquery to find the ID of comedy*/
		SELECT c.category_id
		FROM category c
		WHERE LOWER(c.name) = 'comedy' 
        ))
AND i.length > 180;

/* ·25· BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. 
La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos. 
Pista: Podemos hacer un JOIN de una tabla consigo misma, poniendole un alias diferente. */

SELECT
	CONCAT(a1.first_name, ' ', a1.last_name) AS actor_a,
	CONCAT(a2.first_name, ' ', a2.last_name) AS actor_b,
    COUNT(*) AS number_movies_together
FROM film_actor fa1
JOIN film_actor fa2 
ON fa1.film_id = fa2.film_id /*to find the actors who played in the same film*/
JOIN actor a1
ON fa1.actor_id = a1.actor_id  /*to find the name of the first one*/
JOIN actor a2
ON fa2.actor_id = a2.actor_id /*to find the name of the second one*/
GROUP BY actor_a, actor_b
ORDER BY number_movies_together DESC;
