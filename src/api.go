package main


import(
	"net/http"
	"os"
	"log"
	"github.com/gorilla/mux"
	"encoding/json"
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
	logErr(http.ListenAndServe(":" + port, router))
}

func Response(w http.ResponseWriter, r *http.Request){
	respenvset := os.Getenv("resp")
	err := json.NewEncoder(w).Encode(Resp{Message: respenvset})
	
	logErr(err)
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


