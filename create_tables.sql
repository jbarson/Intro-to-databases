DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;

CREATE TABLE authors(
   id INT GENERATED ALWAYS AS IDENTITY,
   author_name VARCHAR(255) NOT NULL,
   colour VARCHAR(20),
   num_books INT NOT NULL,
   PRIMARY KEY(id)
);

CREATE TABLE books(
   id INT GENERATED ALWAYS AS IDENTITY,
   author_id INT,
   book_name VARCHAR(255) NOT NULL,
   PRIMARY KEY(id),
   CONSTRAINT fk_author
      FOREIGN KEY(id)
	  REFERENCES authors(id)
);

INSERT INTO authors(author_name, colour, num_articles)
VALUES('JRR Tolkien', 'red', 10),
      ('William Shakespe\q
      are', NULL, 35),
      ('George R Martin', 'blue', 20),
      ('Cory Doctorow', 'red', 15);

INSERT INTO books(author_id, book_name)
VALUES(1,'The Hobbit'),
      (3,'Game of Thrones'),
      (2,'MacBeth'),
      (1,'The Fellowship of the Ring');
