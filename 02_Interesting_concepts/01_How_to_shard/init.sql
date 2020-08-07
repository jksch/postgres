/* Add extension */
CREATE EXTENSION IF NOT EXISTS postgres_fdw; /* Remote DB */
CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; /* UUID generation */


/* Create connection to shard 1 */
CREATE SERVER shard1 FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'shard1', dbname 'db');

/* Create connection to shard 2 */
CREATE SERVER shard2 FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'shard2', dbname 'db');

/* Create connection to shard 3 */
CREATE SERVER shard3 FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'shard3', dbname 'db');

/* Create connection to shard 4 */
CREATE SERVER shard4 FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'shard4', dbname 'db');

/* Create remote user for shard 1 */
CREATE USER MAPPING FOR db SERVER shard1
    OPTIONS (user 'db', password 'db');

/* Create remote user for shard 2 */
CREATE USER MAPPING FOR db SERVER shard2
    OPTIONS (user 'db', password 'db');

/* Create remote user for shard 3 */
CREATE USER MAPPING FOR db SERVER shard3
    OPTIONS (user 'db', password 'db');

/* Create remote user for shard 4 */
CREATE USER MAPPING FOR db SERVER shard4
    OPTIONS (user 'db', password 'db');

/* Create local names table */
CREATE TABLE names
(
    id   VARCHAR(36),
    name VARCHAR(100)
) PARTITION BY hash (id);

/* Add the remote shard tables: */
CREATE FOREIGN TABLE names_shard_1
    PARTITION OF names
        FOR VALUES WITH (MODULUS 4, REMAINDER 0)
    SERVER shard1;

CREATE FOREIGN TABLE names_shard_2
    PARTITION OF names
        FOR VALUES WITH (MODULUS 4, REMAINDER 1)
    SERVER shard2;

CREATE FOREIGN TABLE names_shard_3
    PARTITION OF names
        FOR VALUES WITH (MODULUS 4, REMAINDER 2)
    SERVER shard3;

CREATE FOREIGN TABLE names_shard_4
    PARTITION OF names
        FOR VALUES WITH (MODULUS 4, REMAINDER 3)
    SERVER shard4;
