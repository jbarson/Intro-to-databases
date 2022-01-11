# Intro to Databases
## with PostGresql

### Agenda
- Introduction to RDBMS
- The Relational Data Model (Tables, Columns, Rows)
- `SELECT` Statements
- Filtering and ordering
- Joining tables
- Grouping records
- Aggregation functions
- `LIMIT` and `OFFSET`

### Relational Database Management System (RDBMS)
- A program that serves, **and** controls interactions with, one or more _Relational Databases_
- Communicates using a custom protocol (eg. `postgres://` for postgres) that sits on top of TCP
- Front End <-----`http` + `tcp`-----> Back End <-----`postgres` + `tcp`-----> RDBMS

### Structured Data
- The **S** in **SQL** is for _structured_. This means that our data must conform to a _structure_ in order to store it in the database.
- The data itself is stored in **tables** which define things such as field names, data types, and other data constraints
- You are probably familiar with tables already if you've used programs like Excel or Calc
- Tables are made up of **columns** and **rows**
  - Columns are called `fields`
  - Rows are called `records`
- Each table describes an entity (eg. `users`, `products`, `shifts`, `tweets`)
  - The fields represent properties of the entity
  - Each record represents one unique entity

### Primary Keys
- In order to reference a particular record in a table, each one is given a unique identifier we call a **Primary Key**
- Other tables can then make reference to a particular record in another table by storing the Primary Keys value
- We call a Primary Key stored in another table a **Foreign Key**
- It is through this Primary Key/Foreign Key relationship that our tables are _related_ to one another

### SELECT
- The **SELECT** clause queries the database and returns records that match the query
- Always accompanied by the **FROM** keyword which indicates which table we'd like to query
- SELECT takes a list of field names as an argument
- Every SQL command ends in a semicolon (;), that's how we tell the application that we are finished entering our query

```sql
-- basic SELECT query
SELECT author_name, colour FROM authors;

-- the asterisk (*) can be used as a wildcard to return all fields in the table
SELECT * FROM authors;

-- it is customary to put each SQL clause or keyword on a separate line for readability
SELECT author_name, colour
FROM authors;
```

### Filtering and Ordering
- We use `WHERE` to filter our results
- If the record satisfies the `WHERE` criteria (eg. before a certain date, greater than a certain amount), it is included in the query results
- NOTE: using the `WHERE` clause can filter your records down to zero (ie. no records satisfy the filter criteria)

```sql

SELECT *
FROM authors
WHERE colour = 'red';
```

- Order your results with the `ORDER BY` clause
- We specify the field that we want to sort by and the sort direction
- Sort direction is either ascending (`ASC`) or descending (`DESC`)
- NOTE: the default sort direction is ascending (`ASC`) so you don't need to specify it

```sql
SELECT *
FROM table_one
ORDER BY field_one;

-- or in descending order
ORDER BY field_one DESC;
```

### `JOIN`
- We connect tables together using **JOIN**s
- The tables are joined together using the primary key and foreign key
- There are various types of joins:
  - `INNER JOIN`: The default. Return only records that have matching records in the other table
  - `LEFT JOIN`: Return all records from the "left" table and only those from the other table that match
  - `RIGHT JOIN`: The same as a _LEFT JOIN_, but from the _RIGHT_ instead
  - `FULL OUTER JOIN`: Return all records from both tables

```sql
-- basic INNER JOIN
SELECT *
FROM table_one
INNER JOIN table_two
ON table_one.id = table_two.table_one_id;

-- since it is the default, you don't have to specify "INNER"
SELECT *
FROM table_one
JOIN table_two
ON table_one.id = table_two.table_one_id;
```

### Grouping Records
- Records that contain the same values (eg. **students** with the same `cohort_id`) can be _grouped_ together using the `GROUP BY` clause
- If the records contain any unique values, they will not be grouped together

```sql
SELECT author_id, COUNT(author_id) AS num_books
FROM books
GROUP BY author_id;
```

### Aggregation Functions
- Aggregation functions give us meta data about our records (eg. count responses, average player score, get minimum value)
- Some aggregation functions:

| Function | Purpose | Example Usage
| :-- | :-- | :-- |
| `COUNT` | Return the number of records grouped together | `COUNT(*) AS num_users` |
| `SUM` | Add the values of the specified field together | `SUM(player_score) AS total_score` |
| `MIN` | Return the minimum value from the field | `MIN(player_score) AS lowest_score` |
| `MAX` | Return the maximum value | `MAX(player_score) AS high_score` |
| `AVG` | Return the average value | `AVG(player_score) AS average_score` |

### `LIMIT` and `OFFSET`
- We can limit the amount of records returned from a query using `LIMIT`
- `LIMIT` accepts an _integer_ as an argument

```sql
SELECT *
FROM table_one
-- only return 50 records
LIMIT 50;
```

- NOTE: `LIMIT` runs **after** `ORDER BY` (ie. sort your records then specify how many to return)

```sql
SELECT *
FROM table_one
-- order by a field(s)
ORDER BY field_name DESC
-- return the top 10
LIMIT 10;
```

- We can skip any number of records using `OFFSET`
- Like `LIMIT`, `OFFSET` accepts an _integer_ as an argument

```sql
SELECT *
FROM table_one
-- skip the first 10 records
OFFSET 10;
```

- `OFFSET` and `LIMIT` work hand-in-hand to create [pagination](https://en.wikipedia.org/wiki/Pagination)

```sql
SELECT *
FROM table_one
-- skip the first 20 records, return the next 10
LIMIT 10 OFFSET 20;

-- you can specify these in any order
OFFSET 20 LIMIT 10;
```

### SELECT Challenges

1. List total number of authors

```sql
SELECT COUNT(*)
FROM authors;

-- describe the query below
-- using an alias on COUNT
SELECT COUNT(*) num_authors
FROM authors;
```

2. List users with more that 10 books

```sql
SELECT *
FROM authors
WHERE num_books > 10;
```

3. List authors who have more than 10 books and have the colour 'red'

```sql
SELECT *
FROM authors
WHERE num_books > 10 AND colour = 'red';
```

4. List of authors with more than 10 books sorted by number of books

```sql
SELECT *
FROM authors
WHERE num_books > 10
ORDER BY num_books DESC;
```

6. List all the author colours, don't repeat any colours

```sql
SELECT DISTINCT colour
FROM authors
ORDER BY num_books;
```

7. List all authors along with their books

```sql
SELECT *
FROM authors
JOIN books
ON books.author_id = author.id;
```

8. List all authors along with how many books each has

```sql
SELECT author_name, COUNT(books.id) AS book_count
FROM books
JOIN authors ON authors.id = author_id
GROUP BY author_name;
```

9. Enhance previous query to only include authors that have more than 1 books

```sql
SELECT author_name, COUNT(books.id) AS book_count
FROM books
JOIN authors ON authors.id = author_id
GROUP BY author_name
HAVING COUNT(books.id) > 1;
```

10. List ALL authors in the database, along with their books if any

```sql
SELECT *
FROM authors
LEFT JOIN books
ON authors.id = author_id;

-- using RIGHT join instead
SELECT *
FROM books
RIGHT JOIN authors
ON authors.id = author_id;
```

11. List albums along with average song rating

```sql
SELECT album_name, AVG(songs.rating) AS avg_rating
FROM albums
JOIN songs ON albums.id = songs.album_id
GROUP BY album_name;
```

12. List albums and songs with rating higher than album average

```sql
SELECT album_name, 
  artist_name, 
  song_name, 
  rating,
  (SELECT avg(rating) FROM songs WHERE album_id = albums.id)
FROM albums
JOIN songs ON albums.id = songs.album_id
WHERE rating > (SELECT avg(rating) FROM songs WHERE album_id = albums.id);
```

### Useful Links
- [Top 10 Most Popular RDBMSs](https://www.c-sharpcorner.com/article/what-are-the-most-popular-relational-databases/)
- [Another Ranking of DBMSs](https://db-engines.com/en/ranking)
- [SELECT Queries Order of Execution](https://sqlbolt.com/lesson/select_queries_order_of_execution)
- [SQL Joins Visualizer](https://sql-joins.leopard.in.ua/)
- [Visualizing Joins](https://joins.spathon.com/)
- [PSQL CheatSheet](https://gist.github.com/Kartones/dd3ff5ec5ea238d4c546)
- [Data Defininition Language & Data Manipulation Language](https://stackoverflow.com/questions/2578194/what-are-ddl-and-dml/2578207)
