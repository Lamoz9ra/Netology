-- Comment
SELECT 'ФИО: Бесаев Давид Шотович';

-- пункт 1

SELECT * 
FROM ratings 
LIMIT 10;

select * 
from links 
where imdbid like '%42' and movieid between 100 and 1000 
limit 10;

-- пункт 2

select * 
from ratings as r 
inner join links as l 
	on r.movieid=l.movieid 
where r.rating=5 
limit 5;

-- пункт 3
select
	count(movieid) as missingmovie 
from ratings 
where rating is null;

select 
	userid, 
	avg(rating) as avgrating 
from ratings 
group by userid 
having avg(rating) >= 3.5 
order by 2 desc 
limit 10;

-- пункт 4

select l.imdbid 
from links as l 
inner join  
		(select movieid, avg(rating) as avgrating 
		from ratings 
		group by movieid  
		having avg(rating) >= 3.5 
		limit 10) as r 
	on l.movieid=r.movieid;

with tmp_users 
as (
	select userid, count(userid) 
	from ratings 
	group by userid 
	having count(userid)>10
)
select avg(r.rating) 
	from ratings as r inner join tmp_users as tmp on r.userid=tmp.userid;
