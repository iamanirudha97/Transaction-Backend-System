package db

import (
	"database/sql"
	"log"
	"os"
	"testing"

	"github.com/anirudha/Transaction-Backend-System/util"
	_ "github.com/lib/pq"
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {
	config, err := util.LoadConfig("../..")
	if err != nil {
		log.Fatalln("Error loading env configurations", err)
	}

	testDB, err = sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("connection to Database - simple_bank: Failed", err)
	}

	testQueries = New(testDB)
	os.Exit(m.Run())
}
