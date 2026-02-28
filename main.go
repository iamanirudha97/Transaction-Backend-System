package main

import (
	"database/sql"
	"log"

	"github.com/anirudha/Transaction-Backend-System/api"
	db "github.com/anirudha/Transaction-Backend-System/db/sqlc"
	"github.com/anirudha/Transaction-Backend-System/util"
	_ "github.com/lib/pq"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatalln("Error loading env configurations", err)
	}
	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("connection to Database - simple_bank: Failed", err)
	}
	store := db.NewStore(conn)
	server, err := api.NewServer(store, config)
	if err != nil {
		log.Fatal("Cannot Create Server", err)
	}

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server", err)
	}
}
