# How to: Concurrently process DB entries
This example shows how to process DB entities concurrently without the need for additional locking.

### Used principle
As demonstrated in 'processing_test.go' this queries can be used for concurrent processing:
```
BEGIN;

-- Slect 10 names for processing.
SELECT id, name
FROM names
WHERE processed_by IS NULL FOR UPDATE SKIP LOCKED
LIMIT 10;

-- Do the work...

-- Mark the names as proccessed.
UPDATE names
SET processed_by=:worker,
    processed_at=now()
WHERE id IN (:updatedIDs);

COMMIT;
```

### How to run the example:
```
docker-compose up
go test -v
```

### Example output:
```
$ go test -v
=== RUN   TestProcessing
2020/08/06 16:20:51.332064 Worker-7 started.
2020/08/06 16:20:51.332135 Worker-3 started.
2020/08/06 16:20:51.332167 Worker-5 started.
2020/08/06 16:20:51.332193 Worker-6 started.
2020/08/06 16:20:51.332301 Worker-1 started.
2020/08/06 16:20:51.332311 Worker-2 started.
2020/08/06 16:20:51.332312 Worker-4 started.
2020/08/06 16:20:51.332354 Worker-0 started.
2020/08/06 16:20:51.440232 Worker-1 committed: 10
2020/08/06 16:20:51.440964 Worker-3 committed: 10
2020/08/06 16:20:51.441009 Worker-6 committed: 10
2020/08/06 16:20:51.441108 Worker-0 committed: 10
2020/08/06 16:20:51.441133 Worker-5 committed: 10
2020/08/06 16:20:51.441249 Worker-4 committed: 10
2020/08/06 16:20:51.441326 Worker-7 committed: 10
2020/08/06 16:20:51.441672 Worker-2 committed: 10
2020/08/06 16:20:51.443633 Worker-7 finished.
2020/08/06 16:20:51.443763 Worker-6 finished.
2020/08/06 16:20:51.443797 Worker-2 finished.
2020/08/06 16:20:51.443806 Worker-3 finished.
2020/08/06 16:20:51.443773 Worker-0 finished.
2020/08/06 16:20:51.444403 Worker-4 finished.
2020/08/06 16:20:51.497363 Worker-1 committed: 10
2020/08/06 16:20:51.498236 Worker-5 committed: 10
2020/08/06 16:20:51.498938 Worker-1 finished.
2020/08/06 16:20:51.499766 Worker-5 finished.
--- PASS: TestProcessing (0.17s)
PASS
ok  	dev/pg_locker	0.174s
```
You can see that the entries where processed concurrently and without overlap.
