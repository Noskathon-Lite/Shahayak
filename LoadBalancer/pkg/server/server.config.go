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

func (s *BackendServer) Shutdown() {
	s.active = false
}
func (s *BackendServer) MakeReady() {
	s.active = true
}

func NewBackendServer(address string) *BackendServer {
	return &BackendServer{
		address:     address,
		active:      false,
		connections: 0,
	}
}
