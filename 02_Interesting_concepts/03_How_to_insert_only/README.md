# How to: Create an insert only table
This example shows how to create an insert only table which on the outside will behave like a normal table.

### How to run the example:
```
docker-compose up
```

### How to play with the example
The 'commands.sql' file contains some basic queries which help to explore this example.

### Regenerate the test data
The test data in 'addresses.csv' can be regenerated with:
```
go test -v
```
To reinitialise a new DB instance just drop the old docker-compose instance:
```
docker-compose rm
docker-compose up
```
