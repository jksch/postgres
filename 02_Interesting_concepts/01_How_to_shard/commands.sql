-- Generate 50k entries
INSERT INTO names (id, name)
SELECT uuid_generate_v1(), 'John Wick'
from generate_series(1, 50000);

-- Count all entries
SELECT COUNT(*)
FROM names;

-- Show shard distribution of entries
SELECT COUNT(1), tableoid::regclass
FROM names
GROUP BY 2
ORDER BY 2;
