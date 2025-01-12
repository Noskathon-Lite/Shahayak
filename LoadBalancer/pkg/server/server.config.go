package server

import "net/http"

func (s *BackendServer) GetAddress() string {
	return s.address
}

func (s *BackendServer) IsAlive() bool {
	return s.active
}

func (s *BackendServer) ServeHttp(res http.ResponseWriter, req *http.Request) {

}
