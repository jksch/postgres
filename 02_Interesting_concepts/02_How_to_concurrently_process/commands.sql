-- Select names
SELECT id, name, processed_by, processed_at
FROM names;

-- Count unprocessed names
SELECT COUNT(id)
FROM names
WHERE processed_by IS NULL;

-- Reset setup
UPDATE names
SET processed_by = NULL,
    processed_at = NULL
WHERE id IS NOT NULL;
