--Netflix Project
DROP TABLE IF EXISTS netflix; 
CREATE TABLE netflix
(
    show_id VARCHAR(10),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    casts VARCHAR(1000),
    country	VARCHAR(150),
    date_added  VARCHAR(50),	
    release_year INT,	
    rating VARCHAR(10),
	duration VARCHAR(15),	
    listed_in  VARCHAR(79)	,
    description  VARCHAR(250)	

);
SELECT* FROM netflix;


SELECT count(*) as total_content FROM netflix;

--1.Count no. of movies vs tv shows

SELECT type, count(*) as total_content FROM netflix group by type;

--2.Find the most common rating for movies and tv shows
SELECT type,rating FROM(
SELECT type, rating, count(*), RANK() OVER(PARTITION BY type order by count(*) desc)as ranking FROM netflix group by 1,2 ) as t1 where ranking = 1

--3.List all movies released in a specific year

SELECT * FROM netflix WHERE type = 'Movie' AND release_year = 2019

--4.find the top 5 countries with the most content on netflix 

SELECT Unnest(string_to_array(country,',')) as new_country,count(show_id) FROM netflix group by 1 order by 2 desc limit 5 ;

--5. identify the longest movie?

SELECT * FROM netflix where type='Movie' and duration=(SELECT MAX(duration) FROM netflix) 

--6.find content added in last 5 yearsTO_DATE(date_added,'Month DD,YYYY')

SELECT * FROM netflix WHERE TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '2 years' 
SELECT *,  TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL ' 4 years' FROM netflix

--7. find all the movies tv shows by director 'Rajiv chilaka'

SELECT * FROM netflix where director like '%Rajiv Chilaka'

--8. List tv shows more than 5 seasons

SELECT *   FROM netflix where type = 'TV Show' and split_part(duration,' ',1)::numeric > 5

--9. count no. of content items in each genre

SELECT unnest(String_to_array(listed_in,',')) as genre,count(show_id) FROM netflix group by 1

--10. find each year and the averag numbers of content release by India on netflix,return top 5 years wit highest avg content release

SELECT Extract(year from to_date(date_added,'Month DD,YYYY')) as year, count(*),round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric * 100,2) as avg_content FROM netflix where country= 'India' group by 1


--11.list all the movies that are documentaries

SELECT * FROM netflix where listed_in ILIKE '%Documentaries%'

--12. All content without a director

SELECT * FROM netflix where director is null

--13. find movies where actor "salman khan" appeared in last 10 years

SELECT to_date(date_added,'Month DD,YYYY') >= current_date - interval '10 years',* FROM netflix where type = 'Movie' and casts ILIKE '%Salman Khan%'

--14. find the top actors who have appeared in the highest number of movies produced in india

SELECT unnest(String_to_array(casts,',')) as actor,count(show_id) from netflix where type = 'Movie' and country ILIKE '%India%' group by 1 order by 2 desc limit 10 

--15. categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.Label content containing these keywords as 'bad' and all other contnt as 'good'.count how may itms fall into each category.
with new_table as
(SELECT *, case when description ilike '%kill%' or description ilike '%voilence%' then 'Bad_content' else 'Good_content' end category FROM netflix)   
select category,count(*) as total_content from new_table group by 1































