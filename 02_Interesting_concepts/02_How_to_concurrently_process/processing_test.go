package processing

import (
	"database/sql"
	"fmt"
	"log"
	"runtime"
	"strings"
	"sync"
	"testing"
	"time"

	_ "github.com/lib/pq"
)

const (
	connection = "user=db password=db dbname=db port=5432 host=localhost sslmode=disable"
)

type Names struct {
	ID   string
	Name string
}

func TestProcessing(t *testing.T) {
	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds)
	workingDuration := 5 * time.Millisecond
	started := time.Now()

	wg := sync.WaitGroup{}
	for worker := 0; worker < runtime.NumCPU(); worker++ {
		wName := fmt.Sprintf("Worker-%d", worker)
		wg.Add(1)

		go func() {
			log.Printf("%s started.", wName)
			db, err := sql.Open("postgres", connection)
			logErr(t, err)
			defer db.Close()

			for {
				tx, err := db.Begin()
				logErr(t, err)

				rows, err := tx.Query("SELECT id, name FROM names WHERE processed_by IS NULL FOR UPDATE SKIP LOCKED LIMIT 10;")
				logErr(t, err)

				updateIDs := make([]string, 0, 10)
				for rows.Next() {
					var name Names
					err := rows.Scan(&name.ID, &name.Name)
					logErr(t, err)

					updateIDs = append(updateIDs, "'"+name.ID+"'")

					// Do work...
					time.Sleep(workingDuration)
				}
				logErr(t, rows.Err())

				if len(updateIDs) < 1 {
					log.Printf("%s finished.", wName)
					logErr(t, tx.Rollback())
					wg.Done()
					return
				}

				update := fmt.Sprintf(
					"UPDATE names SET processed_by='%s', processed_at=now() WHERE id IN (%s);",
					wName,
					strings.Join(updateIDs, ","),
				)
				_, err = tx.Exec(update)
				logErr(t, err)
				logErr(t, tx.Commit())
				log.Printf("%s committed: %d", wName, len(updateIDs))
			}

		}()
	}
	wg.Wait()

	finished := time.Now().Sub(started)
	if finished > 100*workingDuration {
		t.Errorf("Test failed, processing did NOT run concurrently.")
	}
}

func logErr(t *testing.T, err error) {
	t.Helper()
	if err != nil {
		t.Fatalf("Unexpected error, %v", err)
	}
}
