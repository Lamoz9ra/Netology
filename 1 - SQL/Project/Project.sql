CREATE TABLE Customer(
   	ID		INT PRIMARY KEY     NOT NULL	,
	NAME       	VARCHAR   			,
  	SEX       	VARCHAR  
);


CREATE TABLE Agent(
   ID			INT PRIMARY KEY     NOT NULL	,
   NAME       		VARCHAR    					
);

CREATE TABLE Emp(
   	ID		INT PRIMARY KEY     NOT NULL	,
   	NAME    	VARCHAR    								
);

CREATE TABLE Sales(
   	ID		INT PRIMARY KEY     		NOT NULL,
	ID_CUSTOMER	int REFERENCES Customer		NOT NULL,
  	ID_AGENT	int REFERENCES Agent		NOT NULL,
 	ID_Emp		int REFERENCES Emp		NOT NULL,
   	PRODUCT     	VARCHAR 				,
  	SALE_AMOUNT	int 				NOT NULL,
  	RETURN_FLG	CHAR(1)				NOT NULL
);

-- Вставка данных

insert into Agent values
('1', 'Zara'),
('2', 'Reebok'),
('3', 'Nike'),
('4', 'Adidas')
;
 
insert into Emp values
('1', 'Kate'	),
('2', 'Lidia' 	),
('3', 'Alexey' ),
('4', 'Pier'	),
('5', 'Aurel'	),
('6', 'Klaudia');

insert into Customer values
('1', 'Andrey', 'm'	),
('2', 'Sasha', 'm' 	),
('3', 'Petr' , 'm'	),
('4', 'Nikita', 'm'	),
('5', 'Vera', 'f'	),
('6', 'Lena', 'f'	);

insert into Sales values
('1', 	'2', '1', '1', 'Shoes', 1000, 'N'	),
('2', 	'4', '2', '3', 'Shoes', 2000, 'N'	),
('3', 	'5', '3', '5', 'Pants', 5000, 'N'	),
('4', 	'6', '4', '4', 'T-Shirt', 7000, 'N'	),
('5', 	'1', '3', '6', 'T-Shirt', 5000, 'N'	),
('6', 	'1', '2', '2', 'Shoes', 2300, 'Y'	),
('7', 	'2', '1', '1', 'Pants', 6000, 'N'	),
('8', 	'3', '4', '2', 'Jacket', 7000, 'y'	),
('9', 	'5', '2', '4', 'Shoes', 7000, 'N'	),
('10', 	'3', '3', '6', 'Bag', 12000, 'N'	);

-- Запросы -------------------------------------------------------------

-- 1.выгрузка всего из таблицы с клиентами 

Select * 
From Customer;

-- 2. Продажи по товарам 

Select 
	Product, 
	sum (sale_amount) 
from Sales 
group by Product 
order by 2 desc;

-- 3 Все продажи по продуктам, начинающимся с буквы Т

Select * 
from Sales 
where Product like 'T%';

-- 4 Все товары, которые вернули.

Select * 
from Sales 
where Return_flg='Y';

-- 5 разница между самой дорогой и самой дешевой продажей

select 
	max(sale_amount)-min(sale_amount) as delta 
from sales;

-- 6 Продажи в зависимости от пола

select 
	C.sex, 
    sum(S.sale_amount) 
from SALES S inner join Customer C 
		on S.ID_CUSTOMER = C.ID 
group by 1;

-- 7 Продажи пользователей в зависимости от магазина 

Select 
	C.name as Customer_name, 
	A.name as Agent_name, 
    sum (sale_amount) 
from Sales S inner join Customer C 
	on S.Id_customer=C.id 
		inner join Agent A 
			on S.ID_AGent=A.id 
group by 1,2 
order by 3 desc;

-- 8 Продажи пользователей в зависимости от магазина  с учетом суммарных продаж

Select 
	C.name as Customer_name, 
    A.name as Agent_name, 
    sum (s.sale_amount), 
    sum(s.sale_amount) over (partition by c.name) as Costomer_total_sale 
from Sales S inner join Customer C 
	on S.Id_customer=C.id 
		inner join Agent A 
			on S.ID_AGent=A.id 
group by 1,2,s.sale_amount 
order by 1,3 desc;

 -- 9 Продажи в зависимости от магазина  и продукта с учетом округленного среднего чека
 
 Select 
	A.name, 
    S.product, 
    S.sale_amount, 
    ceil(avg(sale_amount) over (partition by A.name)) 
from Sales S inner join Agent A 
	on S.ID_AGent=A.id 
order by 4 desc;
 
-- 10 Количество продаж работником и его максимальная сумма продажи.

select 
	E.name, 
    S.sale_amount, 
    count(S.id) as count_sales, 
    max(s.sale_amount) over (partition by E.name) as max_sale 
from Sales S inner join Emp E 
	on S.ID_EMP=E.ID 
group by 1,2, s.sale_amount 
order by 3 desc,4 desc;
