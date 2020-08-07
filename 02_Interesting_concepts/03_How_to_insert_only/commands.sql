-- Show all inserted values
EXPLAIN ANALYSE
SELECT id, created, name, street, city, zip
FROM address
LIMIT 100;

-- Count values
EXPLAIN ANALYSE
SELECT COUNT(id)
FROM address;

-- Show all inserts for a given ID
EXPLAIN ANALYSE
SELECT id, created, name, street, city, zip
FROM address
WHERE id = 'e02e0dbd-7861-4670-81b7-aeb8fb99ff84';

-- Show the current entry for a given ID
EXPLAIN ANALYSE
SELECT id, created, name, street, city, zip
FROM addresses
WHERE id = 'e02e0dbd-7861-4670-81b7-aeb8fb99ff84';

-- Insert a value
EXPLAIN ANALYSE
INSERT INTO addresses (id, name, street, city, zip)
VALUES ('e02e0dbd-7861-4670-81b7-aeb8fb99ff84',
        'George Orwell',
        'Wigan Pier 90',
        'Wigan',
        'WN3 4EU');

-- Update a value. This will internally trigger an insert.
EXPLAIN ANALYSE
UPDATE addresses
SET name= 'George Orwell',
    street = 'Wigan Pier 88',
    city = 'Wigan',
    zip = 'WN3 4EU'
WHERE id = 'e02e0dbd-7861-4670-81b7-aeb8fb99ff84';

-- Remove all entries for a given ID
DELETE
FROM addresses
WHERE id = 'e02e0dbd-7861-4670-81b7-aeb8fb99ff84';
