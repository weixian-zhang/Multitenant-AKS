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

func main() {
	port := os.Getenv("port")
	if port == "" {
		port = "8080"
	}
	router := mux.NewRouter().StrictSlash(true)

	router.HandleFunc("/api/resp", Response)
	router.HandleFunc("/api/calloocluster", CallOOClusterService)

	logErr(http.ListenAndServe(":" + port, router))
}

func Response(w http.ResponseWriter, r *http.Request){
	respenvset := os.Getenv("resp")
	err := json.NewEncoder(w).Encode(Resp{Message: respenvset})
	
	logErr(err)
}

func CallOOClusterService(w http.ResponseWriter, r *http.Request) {

	externalSvcIP := os.Getenv("oocSvcIP")
	externalSvcPort := os.Getenv("oocSvcPort")
	externalSvcPath := os.Getenv("oocSvcPath")

	resp , err :=
		http.Get(fmt.Sprintf("http://%v:%v/%v",externalSvcIP, externalSvcPort, externalSvcPath ))

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
		if msg!= nil {
			log.Println(msg)
		}
	}
}


