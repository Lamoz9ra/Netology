CREATE TABLE films(
   ID_FILM			INT PRIMARY KEY     NOT NULL,
   NAME       	TEXT    			NOT NULL,
   COUNTRY     	TEXT     			NOT NULL,
   SALES        INT					NOT NULL,
   YEAR      	INT					NOT NULL
);

INSERT INTO films(ID_FILM, NAME, COUNTRY, SALES, YEAR)
VALUES 	(7, 'Gattaca', 'USA', 12339633, 1997), 
		(80, 'A Beautiful Mind','USA', 170742341, 2001), 
		(5, 'The Lord of the Rings: The Two Towers','USA', 925282504, 2002);

DROP TABLE persons; -- Была проблема с "relation "persons" already exists"
		
CREATE TABLE persons(
   ID_PERSON 	INT PRIMARY KEY     NOT NULL,
   NAME       	TEXT    			NOT NULL
);

INSERT INTO persons(ID_PERSON, NAME)
VALUES 	(9, 'Jude Law'), 
		(70, 'Ron Howard'), 
		(3, 'Orlando Bloom');

CREATE TABLE persons2content(
   ID_PERSON 	INT     		NOT NULL,
   ID_FILM		INT      		NOT NULL,
   NAME       	TEXT    		NOT NULL,
   PRIMARY KEY(ID_PERSON, ID_FILM)
);

INSERT INTO persons2content(ID_PERSON, ID_FILM, NAME)
VALUES 	(9, 7, 'Actor'), 
		(70, 80, 'Director'), 
		(3, 5, 'Actor');
