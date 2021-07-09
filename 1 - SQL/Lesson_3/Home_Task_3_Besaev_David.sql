select 
	userid, 
	movieid,
	rating, 
	(rating-min(rating) over (partition by userid ))/(max(rating) over (partition by userid)/min(rating) over (partition by userid )) as normed_rating, 
	avg(rating) over (partition by userid) as avg_rating  
from ratings 
limit 30;

--ETL

psql -c '
  CREATE TABLE IF NOT EXISTS keywords (
    id int, 
	tags text                
  );'


psql -U postgres -c "\\copy keywords FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER as ',' CSV HEADER "

-- Запрос 3 (понимаю, жестоко, писал уставший вечером ) - (нашёл фильмы, которые оценили больше 50 человек, взял по ним средний рейтинг и сджоинил с загруженной таблицей)
with a as (
select movieid, avg_rating 
from 	(select 
			t2.movieid,
			avg(t2.rating) over (partition by t2.movieid) as avg_rating  
		from ratings as t2 inner join 
										(select t1.movieid 
										from 
											(select 
												movieid, 
												userid 
											from ratings 
											group by movieid, userid) as t1  
										group by movieid 
										having count(distinct(userid))>50) as t3 on t2.movieid=t3.movieid
		) as t4
group by movieid, avg_rating
order by 2 desc, 1 asc
limit 150)

select t1.movieid, t2.name as tags  into top_rated_tags from keywords as t2 inner join a as t1 on t1.movieid=t2.id;

-- LOAD

\copy (SELECT * FROM top_rated_tags) TO 'ratings_file.csv' WITH CSV HEADER DELIMITER as E'\t' ;
