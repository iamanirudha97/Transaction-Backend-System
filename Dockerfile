#builder stage
FROM golang:1.26-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN ls -al
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.18.3/migrate.linux-amd64.tar.gz | tar xvz

# sudo mv migrate 

#run stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate /usr/local/bin/
COPY app.env .
COPY db/migration ./migration
COPY migrations.sh .

EXPOSE 8080
CMD ["/app/main"]
ENTRYPOINT [ "/app/migrations.sh" ]
