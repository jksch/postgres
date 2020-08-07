CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

CREATE TABLE IF NOT EXISTS names
(
    id           UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name         VARCHAR(64)      NOT NULL
);

