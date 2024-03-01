FROM golang:latest as builder
WORKDIR /app
COPY server/* ./
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -v -o server

FROM ghcr.io/dbt-labs/dbt-bigquery:1.6.7
USER root
WORKDIR /dbt
COPY --from=builder /app/server ./
RUN ls
COPY server/run_dbt.sh ./
COPY cust_analytics_poc ./

ENTRYPOINT "./server"
