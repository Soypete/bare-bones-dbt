package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
)

func handler(w http.ResponseWriter, r *http.Request) {
	log.Print("run dbt job")

	cmd := exec.CommandContext(r.Context(), "/bin/sh", "./run_dbt.sh")
	cmd.Stderr = os.Stderr
	out, err := cmd.Output()
	if err != nil {
		w.WriteHeader(500)
	}
	w.Write(out)
}

func main() {
	log.Print("dbt-job: starting server...")

	http.HandleFunc("/", handler)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("dbt-job: listening on %s", port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), nil))
}
