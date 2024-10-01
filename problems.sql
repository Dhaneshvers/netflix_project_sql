
select * from netflix

select count(*) from netflix

select distinct type from netflix

-- 1.) count the number os movies vs tv shows
select type,count(type) as counts from netflix
group by type

-- 2. Find the most common rating for movies and TV showsselect type,rating from(
select type,rating,count(*),
rank() over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2) as t1
where ranking = 1

-- 3. List all movies released in a specific year (e.g., 2020)
select * from netflix

SELECT type,count(release_year)
FROM netflix
WHERE release_year = 2020 and type = 'Movie'
group by type

-- 4. Find the top 5 countries with the most content on Netflix
select * from netflix 

select UNNEST(STRING_TO_ARRAY(country,',')),
count(show_id) as total_count
from netflix
group by 1
order by 2 desc
limit 5

--5.) Identify the longest movie
select * from netflix

select * from 
 (select distinct title as movie,
  split_part(duration,' ',1):: numeric as duration 
  from netflix
  where type ='Movie') as subquery
where duration = (select max(split_part(duration,' ',1):: numeric ) from netflix)

--6.) -- 6. Find content added in the last 5 years
select TO_DATE(date_added,'month DD,YYYY'),title from netflix
WHERE TO_DATE(date_added,'month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS' 

--select current_date - INTERVAL '5 YEARS' 

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * from netflix

select type,title,director from netflix
where director = 'Rajiv Chilaka'

-- 8. List all TV shows with more than 5 seasons
select * from netflix

select * from (
select type,split_part(duration,' ',1)::Numeric as duration from netflix
where type = 'TV Show'
) as t
where duration>=5 

-- 9. Count the number of content items in each genre
select * from netflix

select UNNEST(STRING_TO_ARRAY(listed_in,',')),
count(show_id)
from netflix
group by 1


-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !

select * from netflix
select 
EXTRACT(year from TO_DATE(date_added,'Month dd,yyyy')) as year,
count(*) as yearly_content_added,
count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric *100 as avg_content_per_year
from netflix
where country='India'
group by 1


-- 11. List all movies that are documentaries

select * from netflix

select * from (select title, UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre from netflix) as t
where genre='Documentaries' 


-- 12. Find all content without a director
select * from netflix

select title,director from netflix
where director is null

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netflix
--select * from(select release_year,title,unnest(string_to_array(casts,',')) as salman_khan,
r--elease_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10 from netflix) as t
--where salman_khan='Salman Khan'

select * from netflix WHERE casts LIKE '%Salman Khan%' and 
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2











