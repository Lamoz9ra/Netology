-- Создание схемы

CREATE TABLE Department(
   ID			INT PRIMARY KEY     NOT NULL,
   NAME       	VARCHAR    					
);

CREATE TABLE Employee(
   	ID				INT PRIMARY KEY     			NOT NULL,
  	DEPARTMENT_ID 	INT REFERENCES Department		NOT NULL,
  	CHIEF_DOC_ID	INT      								,
   	NAME       		VARCHAR    								,
  	NUM_PUBLIC 		INT
);

-- Вставка данных

insert into Department values
('1', 'Therapy'),
('2', 'Neurology'),
('3', 'Cardiology'),
('4', 'Gastroenterology'),
('5', 'Hematology'),
('6', 'Oncology');
 
insert into Employee values
('1', '1', '1', 'Kate', 4),
('2', '1', '1', 'Lidia', 2),
('3', '1', '1', 'Alexey', 1),
('4', '1', '2', 'Pier', 7),
('5', '1', '2', 'Aurel', 6),
('6', '1', '2', 'Klaudia', 1),
('7', '2', '3', 'Klaus', 12),
('8', '2', '3', 'Maria', 11),
('9', '2', '4', 'Kate', 10),
('10', '3', '5', 'Peter', 8),
('11', '3', '5', 'Sergey', 9),
('12', '3', '6', 'Olga', 12),
('13', '3', '6', 'Maria', 14),
('14', '4', '7', 'Irina', 2),
('15', '4', '7', 'Grit', 10),
('16', '4', '7', 'Vanessa', 16),
('17', '5', '8', 'Sascha', 21),
('18', '5', '8', 'Ben', 22),
('19', '6', '9', 'Jessy', 19),
('20', '6', '9', 'Ann', 18);


-- задача а)
select 
	d.name, 
    count(distinct(e.chief_doc_id)) as Num_glav_vrach 
from department as d inner join Employee as e 
		on d.ID=e.department_id 
group by d.name 
order by 2 DESC;

-- Задача b)

select 
	d.id, 
    d.name, 
    count(distinct(e.ID)) as count_doc 
from department as d inner join Employee as e 
	on d.ID=e.department_id 
group by d.id, d.name 
having count(distinct(e.ID)) >= 3  
order by 3 DESC;

-- Задача c)

select 
	d.id, 
    d.name, 
    sum(e.NUM_PUBLIC) as max_count_doc 
from department as d inner join Employee as e 
	on d.ID=e.department_id 
group by d.id, d.name 
order by 3 DESC 
limit 1;

-- Задача d)

with a as(
	select 
		e.DEPARTMENT_ID, 
        e.ID, 
        min(e.NUM_PUBLIC) over (partition by e.DEPARTMENT_ID)  as min_count_doc 
	from Employee as e  
    order by 3 DESC),
    
b as (
	select e.* 
    from a inner join employee as e 
		on a.id=e.id and a.min_count_doc=e.num_public)
        
select 
	d.id, 
    d.name, 
    b.name, 
    b.num_public 
from department as d inner join b 
	on b.department_id=d.id;
    
-- Задача e)

with c as(
	select 
		d.id, 
		d.name, 
        count(distinct(e.chief_doc_id)) as Num_glav_vrach 
	from department as d inner join Employee as e 
		on d.ID=e.department_id 
	group by 1,2  
    having count(distinct(e.chief_doc_id))>1 
    order by 2 DESC)
  
select 
	c.id, 
    c.name, 
    avg(e.num_public) as avg_public 
from c inner join employee as e 
	on c.id=e.department_id
group by 1,2 
order by 3 desc;