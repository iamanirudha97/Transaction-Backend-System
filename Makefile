postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migraterdsup:
	migrate -path db/migration -database "postgresql://root:secret<@free-tier-postgres-public.cyhc80w44nnc.us-east-1.rds.amazonaws.com:5432/simple_bank" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migraterdsdown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down


migrateupversion1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1	

migratedownversion1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

test-api:
	go test -v ./api -run .

server:
	go run main.go

dev: 
	air

mock: 
	mockgen -package mockdb -destination db/mock/store.go github.com/anirudha/Transaction-Backend-System/db/sqlc Store


.PHONY: postgres createdb dropdb migrateup migratedown sqlc test test-api server mock migrateupversion1 migratedownversion1
