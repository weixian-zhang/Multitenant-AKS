package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

var (
	_logger *zap.Logger
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

	initZaplog()

	port := os.Getenv("port")
	if port == "" {
		port = "8080"
	}

	logInfoErr(fmt.Sprintf("Listening on port: %v", port))

	router := mux.NewRouter().StrictSlash(true)

	router.HandleFunc("/api/resp", response)
	router.HandleFunc("/api/env", getEnvars)
	router.HandleFunc("/api/callapi", callAPI)

	logInfoErr(http.ListenAndServe(":"+port, router))
}

func response(w http.ResponseWriter, r *http.Request) {
	respenvset := os.Getenv("resp")
	err := json.NewEncoder(w).Encode(Resp{Message: respenvset})

	logInfoErr("/api/resp processed")
	logInfoErr(err)
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
	b, _ := json.Marshal(envvars)

	logInfoErr(fmt.Sprintf("/api/env processed. %v", string(b)))

	json.NewEncoder(w).Encode(envvars)
}

func callAPI(w http.ResponseWriter, r *http.Request) {

	externalSvcIP := os.Getenv("oocSvcIPOrFQDN")
	externalSvcPort := os.Getenv("oocSvcPort")
	externalSvcPath := os.Getenv("oocSvcPath")

	logInfoErr(fmt.Sprintf("/api/callapi calling another API @ http://%v:%v", externalSvcIP, externalSvcPort))

	req, err := http.NewRequest("GET", fmt.Sprintf("http://%v:%v%v", externalSvcIP, externalSvcPort, externalSvcPath), nil)
	ctx, cancelFunc := context.WithTimeout(req.Context(), 3 * time.Second)
	defer cancelFunc()

	req = req.WithContext(ctx)
	
	res, err := http.DefaultClient.Do(req)

	if err != nil {
		logInfoErr(err)
		json.NewEncoder(w).Encode(Resp{Message: err.Error()})
		return
	}

	data, _ := ioutil.ReadAll(res.Body)
	jsonData := string(data)

	logInfoErr(fmt.Sprintf("response from API: %v", jsonData))

	json.NewEncoder(w).Encode(Resp{Message: jsonData})
}

func logInfoErr(msg interface{}) {
	if t, ok := msg.(error); ok {
		_logger.Error(t.Error())
	} else {
		if msg != nil {
			if m, ok := msg.(string); ok {
				_logger.Info(m)
			}
			
		}
	}
}

func initZaplog() {
	loggerConfig := zap.NewProductionConfig()
	loggerConfig.OutputPaths = []string{"stdout", "stderr"}
	loggerConfig.EncoderConfig.TimeKey = "timestamp"
	loggerConfig.EncoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	loggerConfig.EncoderConfig.EncodeCaller = zapcore.ShortCallerEncoder
	logger, _ := loggerConfig.Build()
	_logger = logger
}
