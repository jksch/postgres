CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

CREATE TABLE IF NOT EXISTS address
(
    id      UUID        NOT NULL,
    created TIMESTAMP   NOT NULL DEFAULT now(),
    name    VARCHAR(64) NOT NULL,
    street  VARCHAR(64) NOT NULL,
    city    VARCHAR(32) NOT NULL,
    zip     VARCHAR(16) NOT NULL
);

COPY address (id, name, street, city, zip) FROM '/docker-entrypoint-initdb.d/addresses.csv'
    DELIMITER ',';

-- Create an order index will ensure that the view is performant.
CREATE UNIQUE INDEX address_id_idx ON address (id DESC, created DESC) WITH (fillfactor = 45);

-- Create a view on which will only show the relevant (newest) entities.
CREATE OR REPLACE VIEW addresses AS
SELECT DISTINCT ON (id) id, created, name, street, city, zip
FROM address
ORDER BY id, created DESC;

-- Define an insert behavior for the view.
CREATE OR REPLACE RULE insert_into_addresses AS ON INSERT TO addresses DO INSTEAD (
    INSERT INTO address (id, name, street, city, zip)
    VALUES (new.id, new.name, new.street, new.city, new.zip)
    );

-- Define a different update behavior,
-- that will ensure that instead of a update an insert will be triggered.
CREATE OR REPLACE RULE update_addresses AS ON UPDATE TO addresses DO INSTEAD (
    INSERT INTO address (id, name, street, city, zip)
    VALUES (new.id, new.name, new.street, new.city, new.zip)
    );

-- Define a delete behaviour.
CREATE OR REPLACE RULE delete_addresses AS ON DELETE TO addresses DO INSTEAD (
    DELETE
    FROM address
    WHERE id = old.id
    );

-- If the table grows to large it can be cleaned up with this command.
CREATE OR REPLACE FUNCTION cleanup() RETURNS VOID AS
$$
DELETE
FROM address remove USING addresses view
WHERE remove.id = view.id
  AND NOT remove.created = view.created;
    -- After cleanup a full vacuum should be executed.
    -- Vacuum can not be ran form a function.
    --VACUUM (FULL, ANALYSE) address;
$$ LANGUAGE SQL;

