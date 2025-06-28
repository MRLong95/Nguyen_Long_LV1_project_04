--1 Find the total number of rows in each table of the schema?
SELECT 'GENRE' AS TABLE_NAME, COUNT(*) AS TOTAL_NUM FROM GENRE
UNION
SELECT 'MOVIE', COUNT(*) FROM MOVIE
UNION
SELECT 'NAMES', COUNT (*) FROM NAMES
UNION 
SELECT 'RATINGS', COUNT(*) FROM RATINGS;

--2 Which columns in the movie table have null values?
SELECT
	SUM(CASE WHEN COUNTRY IS NULL THEN 1 ELSE 0 END) AS COUNTRY_NULL,
	SUM(CASE WHEN DURATION IS NULL THEN 1 ELSE 0 END) AS DURATION_NULL,
	SUM(CASE WHEN WORLWIDE_GROSS_INCOME IS NULL THEN 1 ELSE 0 END) AS WORLWIDE_NULL,
	SUM(CASE WHEN LANGUAGES IS NULL THEN 1 ELSE 0 END) AS LANGUAGE_NULL,
	SUM(CASE WHEN PRODUCTION_COMPANY IS NULL THEN 1 ELSE 0 END) AS PRODUCT_NULL
FROM MOVIE;


--3 Find the total number of movies released each year? How does the trend look month wise
SELECT 
	EXTRACT(YEAR FROM DATE_PUBLISHED) AS RELEASE_YEAR,
	COUNT(*) AS TOTAL_MOVIE
FROM MOVIE
GROUP BY RELEASE_YEAR
ORDER BY RELEASE_YEAR;
-- MONTH WISE
SELECT
	EXTRACT(MONTH FROM DATE_PUBLISHED) AS MONTH_NUMBER,
	COUNT(*) NUMBER_OF_MOVIE
FROM MOVIE
GROUP BY MONTH_NUMBER
ORDER BY MONTH_NUMBER;

--
SELECT 
	EXTRACT(MONTH FROM DATE_PUBLISHED) AS RELEASE_MONTH,
	EXTRACT(YEAR FROM DATE_PUBLISHED) AS RELEASE_YEAR,
	COUNT(*) AS TOTAL_MOVIE
FROM MOVIE
GROUP BY RELEASE_YEAR, RELEASE_MONTH
ORDER BY RELEASE_YEAR, RELEASE_MONTH;

--Lets find the number of movies produced by USA or India for the last year
SELECT 
	COUNTRY,
	COUNT(*) AS NUMBER_MOVIE
FROM MOVIE
WHERE COUNTRY IN ('USA', 'India')
AND EXTRACT(YEAR FROM DATE_PUBLISHED) = (
	SELECT MAX(EXTRACT(YEAR FROM DATE_PUBLISHED)) FROM MOVIE
)
GROUP BY COUNTRY;

-- 4 How many movies were produced in the USA or India in the year 2019??
SELECT 
	COUNTRY,
	COUNT(*) AS NUMBER_OF_MOVIE
FROM MOVIE
WHERE COUNTRY IN ('USA', 'India')
AND EXTRACT(YEAR FROM DATE_PUBLISHED) = 2019
GROUP BY COUNTRY;

--5 Find the unique list of the genres present in the data set?
SELECT DISTINCT GENRE FROM GENRE ORDER BY GENRE;

--6 Which genre had the highest number of movies produced overall?
SELECT
	G.GENRE,
	COUNT(*) AS MOVIE_COUNT
FROM GENRE G
JOIN MOVIE M ON G.MOVIE_ID = M.ID
GROUP BY G.GENRE
ORDER BY MOVIE_COUNT DESC
LIMIT 1;

--7  How many movies belong to only one genre?
SELECT 
	COUNT(*) AS SINGER_GENRE_MOVIE
FROM (
	SELECT MOVIE_ID
	FROM GENRE
	GROUP BY MOVIE_ID
	HAVING COUNT(GENRE) =1
) SINGER_GENRE_MOVIE;


-- 8 What is the average duration of movies in each genre?
SELECT 
	G.GENRE,
	ROUND(AVG(M.DURATION), 2) AS AVE_MOVIE
FROM GENRE G
JOIN MOVIE M ON G.MOVIE_ID = M.ID
GROUP BY GENRE
ORDER BY GENRE;

--9 What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced?

SELECT 
	GENRE,
	MOVIE_COUNT,
	RANK () OVER (ORDER BY MOVIE_COUNT DESC) AS RANK_MOVIE
FROM (
	SELECT g.genre,
	COUNT(*) AS MOVIE_COUNT
	FROM GENRE G
	JOIN MOVIE M ON G.MOVIE_ID = M.ID
	GROUP BY G.GENRE
)GENRE_COUNT
WHERE GENRE = 'Thriller';


--10 Find the minimum and maximum values in each column of the ratings table except the movie_id column?
SELECT
	MIN(AVG_RATING) AS MIN_AVG_RATING,
	MAX(AVG_RATING) AS MAX_AVG_RATING,
	MIN(TOTAL_VOTES) AS MIN_TOTAL_RATING,
	MAX(TOTAL_VOTES) AS MAX_TOTAL_RATING,
	MIN(MEDIAN_RATING) AS MIN_MEDIAN_RATING,
	MAX(MEDIAN_RATING) AS MAX_MEDIAN_RATING
FROM RATINGS;

--11 Which are the top 10 movies based on average rating?
SELECT 
	M.TITLE,
	R.AVG_RATING,
	DENSE_RANK () OVER (ORDER BY R.AVG_RATING DESC) AS MOVIE_RANK
FROM MOVIE M
JOIN RATINGS R ON M.ID = R.MOVIE_ID
WHERE R.AVG_RATING IS NOT NULL
LIMIT 10;

--12 Summarise the ratings table based on movie counts by median ratings?
 SELECT
 	MEDIAN_RATING,
	 COUNT(*) AS MOVIE_COUNT
FROM RATINGS
GROUP BY MEDIAN_RATING
ORDER BY MEDIAN_RATING;
-- do you think character actors and filler actors can be from these movies?

--13 Which production house has produced the most number of hit movies (average rating > 8)?
SELECT 
	M.PRODUCTION_COMPANY,
	COUNT(*) AS MOVIE_COUNT,
	RANK() OVER (ORDER BY COUNT(*) DESC) AS PRO_COMPANY_RANK
FROM MOVIE M
JOIN RATINGS R ON M.ID = R.MOVIE_ID
WHERE R.AVG_RATING > 8
GROUP BY 1
HAVING M.PRODUCTION_COMPANY IS NOT NULL
LIMIT 1;

--14 How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
SELECT 
	G.GENRE,
	COUNT(*) AS MOVIE_COUNT
FROM GENRE G
JOIN MOVIE M ON G.MOVIE_ID = M.ID
JOIN RATINGS R ON R.MOVIE_ID = M.ID
WHERE M.COUNTRY = 'USA'
AND EXTRACT(YEAR FROM DATE_PUBLISHED) = 2017
AND EXTRACT(MONTH FROM DATE_PUBLISHED) = 3
AND R.TOTAL_VOTES > 1000
GROUP BY G.GENRE
ORDER BY G.GENRE;

--15 Find movies of each genre that start with ‘The’ and have an average rating > 8?
SELECT
	M.TITLE,
	G.GENRE,
	R.AVG_RATING
FROM MOVIE M
JOIN GENRE G ON M.ID = G.MOVIE_ID
JOIN RATINGS R ON M.ID = R.MOVIE_ID
WHERE TITLE LIKE 'The%'
AND AVG_RATING > 8
ORDER BY M.TITLE, G.GENRE;

--16 Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
SELECT 
	COUNT(*) AS MOVIE_COUNT
FROM MOVIE M
JOIN RATINGS R ON M.ID = R.MOVIE_ID
WHERE M.DATE_PUBLISHED BETWEEN '2018-04-01' AND '2019-04-01'
AND R.MEDIAN_RATING = 8;

--17 Do German movies get more votes than Italian movies?
SELECT
	M.COUNTRY,
	SUM(R.TOTAL_VOTES) AS TOTAL_VOTES
FROM MOVIE M
JOIN RATINGS R ON M.ID = R.MOVIE_ID
WHERE M.COUNTRY IN ('Germany', 'Italian')
GROUP BY M.COUNTRY
ORDER BY TOTAL_VOTES DESC;

--18 Which columns in the names table have null values?
SELECT * FROM NAMES;

SELECT 
	SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS ID_NULL,
	SUM(CASE WHEN NAME IS NULL THEN 1 ELSE 0 END) AS NAME_NULL,
	SUM(CASE WHEN HEIGHT IS NULL THEN 1 ELSE 0 END) AS HEIGHT_NULL,
	SUM(CASE WHEN DATE_OF_BIRTH IS NULL THEN 1 ELSE 0 END) AS DATE_BIRTH_NULL,
	SUM(CASE WHEN KNOWN_FOR_MOVIES IS NULL THEN 1 ELSE 0 END) AS MOVIE_NULL
FROM NAMES;

--19 Who are the top three directors in the top three genres whose movies have an average rating > 8?
WITH high_rated_movies AS (
    SELECT movie_id, avg_rating
    FROM ratings
    WHERE avg_rating > 8
),
top_genres AS (
    SELECT g.genre
    FROM genre g
    JOIN high_rated_movies hrm ON g.movie_id = hrm.movie_id
    GROUP BY g.genre
    ORDER BY COUNT(*) DESC
    LIMIT 3
),
director_movies AS (
    SELECT d.movie_id, d.name_id, g.genre, m.id, m.title, r.avg_rating
    FROM director_mapping d
    JOIN movie m ON d.movie_id = m.id
    JOIN genre g ON m.id = g.movie_id
    JOIN high_rated_movies r ON m.id = r.movie_id
    WHERE g.genre IN (SELECT genre FROM top_genres)
),
director_stats AS (
    SELECT movie_id, names, genre, 
           AVG(avg_rating) AS avg_rating, 
           COUNT(*) AS movie_count,
           RANK() OVER (PARTITION BY genre ORDER BY COUNT(*) DESC, AVG(avg_rating) DESC) AS rank
    FROM director_movies
    GROUP BY director_id, name, genre
    HAVING AVG(avg_rating) > 8
)
SELECT genre, name, avg_rating, movie_count
FROM director_stats
WHERE rank <= 3
ORDER BY genre, rank;
-- 20 Who are the top two actors whose movies have a median rating >= 8?
SELECT 
	N.NAME AS ACTOR_NAME,
	COUNT(DISTINCT R.MOVIE_ID) AS MOVIE_COUNT
FROM RATINGS R
JOIN ROLE_MAPPING RM ON RM.MOVIE_ID = R.MOVIE_ID
JOIN NAMES N ON N.ID = RM.NAME_ID
WHERE R.MEDIAN_RATING >=8
AND RM.CATEGORY = 'actor'
GROUP BY N.ID, N.NAME
ORDER BY MOVIE_COUNT DESC
LIMIT 3;

--21 Which are the top three production houses based on the number of votes received by their movies?
SELECT 
	M.PRODUCTION_COMPANY,
	SUM(R.TOTAL_VOTES) AS VOTE_COUNT,
	RANK() OVER (ORDER BY SUM(R.TOTAL_VOTES) DESC) AS PROD_COM_RANK
FROM MOVIE M
JOIN RATINGS R ON R.MOVIE_ID = M.ID
WHERE M.PRODUCTION_COMPANY IS NOT NULL
GROUP BY M.PRODUCTION_COMPANY
LIMIT 3;

--22 Rank actors with movies released in India based on their average ratings?
select * from NAMES;

SELECT 
    n.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(DISTINCT m.id) AS movie_count,
    ROUND(AVG(r.avg_rating), 2) AS actor_avg_rating,
    RANK() OVER (ORDER BY ROUND(AVG(r.avg_rating), 2) DESC, COUNT(DISTINCT m.id) DESC) AS actor_rank
FROM 
    movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN role_mapping rm ON m.id = rm.movie_id
    INNER JOIN names n ON rm.name_id = n.id
WHERE 
    m.country LIKE '%India%'
    AND rm.category = 'actor'
GROUP BY 
    n.id, n.name
HAVING 
    COUNT(DISTINCT r.movie_id) > 0
ORDER BY 
    actor_avg_rating DESC, movie_count DESC, actor_name;

-- 23 .Find out the top five actresses in Hindi movies released in India based on their average ratings?
SELECT 
    n.name AS actress_name,
    ROUND(AVG(r.avg_rating), 2) AS avg_rating,
    COUNT(DISTINCT m.id) AS movie_count,
    SUM(r.total_votes) AS total_votes,
	RANK() OVER (ORDER BY ROUND(AVG(R.AVG_RATING), 2) DESC, COUNT(DISTINCT M.ID) DESC) AS ACTRESS_RANK
FROM 
    movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN role_mapping rm ON m.id = rm.movie_id
    INNER JOIN names n ON rm.name_id = n.id
WHERE 
    m.languages LIKE '%Hindi%'
    AND m.country LIKE '%India%'
    AND rm.category = 'actress'
GROUP BY 
    n.id, n.name
HAVING 
    COUNT(DISTINCT m.id) > 0
ORDER BY 
    avg_rating DESC, movie_count DESC, total_votes DESC
LIMIT 5;

--24 Select thriller movies as per avg rating and classify them.

SELECT 
    m.title,
    ROUND(r.avg_rating, 2) AS avg_rating,
    CASE 
        WHEN r.avg_rating >= 8.0 THEN 'Excellent'
        WHEN r.avg_rating >= 6.5 THEN 'Good'
        WHEN r.avg_rating >= 5.0 THEN 'Average'
        ELSE 'Below Average'
    END AS classification
FROM 
    movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN genre g ON m.id = g.movie_id
WHERE 
    g.genre = 'Thriller'
ORDER BY 
    r.avg_rating DESC, m.title;

--25 What is the genre-wise running total and moving average of the average movie duration?
SELECT 
	G.GENRE,
	ROUND(AVG(M.DURATION), 2) AS AVG_DURATION,
	SUM(AVG(M.DURATION)) OVER (ORDER BY G.GENRE) AS TOTAL_DURATION,
	AVG(AVG(M.DURATION)) OVER (ORDER BY G.GENRE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS MOVING_AVG_DURATION
FROM GENRE G
JOIN MOVIE M ON M.ID = G.MOVIE_ID
GROUP BY G.GENRE
ORDER BY G.GENRE;

----26 Which are the five highest-grossing movies of each year that belong to the top three genres?

WITH top_genres AS (
    SELECT genre
    FROM genre
    GROUP BY genre
    ORDER BY COUNT(*) DESC
    LIMIT 3
),
movies_with_gross AS (
    SELECT m.id, m.title, m.year,
           CAST(
               REGEXP_REPLACE(m.worlwide_gross_income, '^\$ |^INR ', '') AS DECIMAL(15,0)
           ) AS gross_income
    FROM movie m
    WHERE m.worlwide_gross_income IS NOT NULL
      AND m.worlwide_gross_income != ''
      AND m.worlwide_gross_income ~ '^\$ |^INR '
),
filtered_movies AS (
    SELECT mg.id, mg.title, mg.year, mg.gross_income, g.genre,
           RANK() OVER (PARTITION BY mg.year ORDER BY mg.gross_income DESC) AS rank
    FROM movies_with_gross mg
    JOIN genre g ON mg.id = g.movie_id
    WHERE g.genre IN (SELECT genre FROM top_genres)
)
SELECT id, title, year, gross_income, genre
FROM filtered_movies
WHERE rank <= 5
ORDER BY year, gross_income DESC;


--27 Which are the top two production houses with the highest number of hits (median rating >= 8) among multilingual movies?
SELECT 
	M.PRODUCTION_COMPANY,
	COUNT(*) AS MOVIE_COUNT,
	RANK () OVER (ORDER BY COUNT(*) DESC) AS RANK_MOVIE
FROM MOVIE M
JOIN RATINGS R ON M.ID = R.MOVIE_ID
WHERE R.MEDIAN_RATING >=8
AND M.PRODUCTION_COMPANY IS NOT NULL
GROUP BY M.PRODUCTION_COMPANY 
LIMIT 3;

--28 Who are the top 3 actresses based on number of Super Hit movies (average rating > 8) in drama genre?
SELECT 
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(DISTINCT r.movie_id) AS movie_count,
    ROUND(AVG(r.avg_rating), 2) AS actress_avg_rating,
    DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT r.movie_id) DESC, AVG(r.avg_rating) DESC) AS actress_rank
FROM ratings r
    INNER JOIN genre g ON r.movie_id = g.movie_id
    INNER JOIN role_mapping rm ON r.movie_id = rm.movie_id
    INNER JOIN names n ON rm.name_id = n.id
WHERE r.avg_rating > 8
    AND g.genre = 'Drama'
    AND rm.category = 'actress'
GROUP BY 
    n.id, n.name
ORDER BY 
    actress_rank, actress_name
LIMIT 3;


--29  Get the following details for top 9 directors (based on number of movies)
WITH director_movies AS (
    SELECT dm.name_id AS director_id,
           n.name AS director_name,
           m.id AS movie_id,
           m.date_published,
           m.duration
    FROM director_mapping dm
    JOIN names n ON dm.name_id = n.id
    JOIN movie m ON dm.movie_id = m.id
),
ranked_directors AS (
    SELECT director_id, director_name, COUNT(*) AS number_of_movies
    FROM director_movies
    GROUP BY director_id, director_name
    ORDER BY number_of_movies DESC
    LIMIT 9
),
director_movie_details AS (
    SELECT d.director_id,
           d.director_name,
           d.movie_id,
           d.date_published,
           d.duration,
           r.avg_rating,
           r.total_votes
    FROM director_movies d
    JOIN ranked_directors rnk ON d.director_id = rnk.director_id
    LEFT JOIN ratings r ON d.movie_id = r.movie_id
),
inter_movie_gap AS (
    SELECT director_id,
           (LEAD(date_published) OVER (
               PARTITION BY director_id ORDER BY date_published
           ) - date_published)::INT AS gap_days
    FROM director_movie_details
)
SELECT 
    d.director_id,
    d.director_name,
    COUNT(*) AS number_of_movies,
    COALESCE(ROUND(AVG(i.gap_days)), 0) AS avg_inter_movie_days,
    ROUND(AVG(d.avg_rating)::NUMERIC, 2) AS avg_rating,
    SUM(d.total_votes) AS total_votes,
    MIN(d.avg_rating) AS min_rating,
    MAX(d.avg_rating) AS max_rating,
    SUM(d.duration) AS total_duration
FROM director_movie_details d
LEFT JOIN inter_movie_gap i ON d.director_id = i.director_id
GROUP BY d.director_id, d.director_name
ORDER BY number_of_movies DESC;





































	

































