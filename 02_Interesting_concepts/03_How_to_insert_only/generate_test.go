package processing

import (
	"encoding/csv"
	"log"
	"os"
	"testing"

	"github.com/Pallinder/go-randomdata"
	"github.com/google/uuid"
)

func TestGenerateEntries(t *testing.T) {
	f, err := os.Create("addresses.csv")
	logErr(t, err)
	defer f.Close()

	w := csv.NewWriter(f)
	defer w.Flush()

	for location := 0; location < 100; location++ {
		w.Write([]string{
			uuid.New().String(),
			randomdata.FullName(randomdata.RandomGender),
			randomdata.Street(),
			randomdata.City(),
			randomdata.PostalCode("SE"),
		})
		log.Printf("Writen %d", location)
	}
}

func logErr(t *testing.T, err error) {
	if err != nil {
		t.Fatalf("Unexpected error: %v", err)
	}
}
