# Postgres sharding example
This project shows a very simple way to shard a postgres table.
The example uses 5 postgres instances:
- 1 x as load balancer (called db)
- 4 x as shards (called shard1-4) 

### How to run
To run the project open it in a console and run:
```
docker-compose up
```
To stop the db:
```
docker-compose down
```
If you and to drop the containers:
```
docker-compose rm
```

### DB login
You can login to the DB on:
- Host: localhost:5432
- DB: db
- User: db
- Password: db

### Demo commands
The 'commands.sql' file contains some demo commands.

#### Sources:
- [Source-01](https://pgdash.io/blog/postgres-11-sharding.html)
- [Source-02](https://severalnines.com/database-blog/how-take-advantage-new-partitioning-features-postgresql-11)
