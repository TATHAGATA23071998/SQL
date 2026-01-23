/* =========================================================
   SQL DDL COMMANDS
   CREATE, ALTER, DROP
   ========================================================= */
USE [MyDatabase]
/* Step 1: Create a new table called 'persons' */
CREATE TABLE persons (
    id INT NOT NULL,
    person_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT pk_persons PRIMARY KEY (id)
);

/* Step 2: Validate table creation */
SELECT *
FROM persons;

/* Step 3: Add 'email' column to the persons table */
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;

/* Step 4: Validate schema change */
SELECT *
FROM persons;

/* Step 5: Drop 'phone' column from persons table */
ALTER TABLE persons
DROP COLUMN phone;

/* Step 6: Final schema validation */
SELECT *
FROM persons;