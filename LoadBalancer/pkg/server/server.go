package server

import "net/http"

type Server interface {
	GetAddress() string
	IsAlive() bool
	ServeHttp(res http.ResponseWriter, req *http.Request)
	Shutdown()
	MakeReady()
	GetConnections() int
}

type BackendServer struct {
	address     string
	active      bool
	connections int
}
