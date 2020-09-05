package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"
)

type Resp struct {
	Message string
}

type Envar struct {
	HostingPort   string
	Response      string
	ExApiIPOrFQDN string
	ExApiPort     string
	ExApiPath     string
}

func main() {
	port := os.Getenv("port")
	if port == "" {
		port = "8080"
	}
	router := mux.NewRouter().StrictSlash(true)

	router.HandleFunc("/api/resp", response)
	router.HandleFunc("/api/env", getEnvars)
	router.HandleFunc("/api/callapi", callAPI)

	logErr(http.ListenAndServe(":"+port, router))
}

func response(w http.ResponseWriter, r *http.Request) {
	respenvset := os.Getenv("resp")
	err := json.NewEncoder(w).Encode(Resp{Message: respenvset})

	logErr(err)
}

func getEnvars(w http.ResponseWriter, r *http.Request) {
	port := os.Getenv("port")
	resp := os.Getenv("resp")
	externalSvcIPFQDN := os.Getenv("oocSvcIPOrFQDN")
	externalSvcPort := os.Getenv("oocSvcPort")
	externalSvcPath := os.Getenv("oocSvcPath")

	envvars := Envar{
		HostingPort:   port,
		Response:      resp,
		ExApiIPOrFQDN: externalSvcIPFQDN,
		ExApiPort:     externalSvcPort,
		ExApiPath:     externalSvcPath,
	}

	json.NewEncoder(w).Encode(envvars)
}

func callAPI(w http.ResponseWriter, r *http.Request) {

	externalSvcIP := os.Getenv("oocSvcIPOrFQDN")
	externalSvcPort := os.Getenv("oocSvcPort")
	externalSvcPath := os.Getenv("oocSvcPath")

	resp, err :=
		http.Get(fmt.Sprintf("http://%v:%v/%v", externalSvcIP, externalSvcPort, externalSvcPath))

	if err != nil {
		fmt.Println(err)
		json.NewEncoder(w).Encode(Resp{Message: err.Error()})
		return
	}

	data, _ := ioutil.ReadAll(resp.Body)
	jsonData := string(data)

	fmt.Println(jsonData)

	json.NewEncoder(w).Encode(Resp{Message: jsonData})
}

func logErr(msg interface{}) {
	if t, ok := msg.(error); ok {
		log.Fatalln(t)
	} else {
		if msg != nil {
			log.Println(msg)
		}
	}
}
