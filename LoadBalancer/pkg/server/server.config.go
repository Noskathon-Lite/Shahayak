package server

import (
	"LoadBalancer/pkg/utils"
	"net/http"
	"net/url"
)

func (s *BackendServer) GetAddress() string {
	return s.address
}

func (s *BackendServer) IsAlive() bool {
	return s.active
}

func (s *BackendServer) ServeHttp(res http.ResponseWriter, req *http.Request) {
	targetUrl, err := url.Parse(s.GetAddress())
	if err != nil {
		utils.HandleError(err)
	}

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
