package server

import (
	"LoadBalancer/pkg/proxy"
	"LoadBalancer/pkg/utils"
	"io"
	"log"
	"net/http"
	"net/url"
)

func (s *BackendServer) GetAddress() string {
	return s.address
}

func (s *BackendServer) IsAlive() bool {
	return true
}

func (s *BackendServer) ServeHttp(res http.ResponseWriter, req *http.Request) {
	targetUrl, err := url.Parse(s.GetAddress())
	if err != nil {
		utils.HandleError(err)
	}
	proxyReq, err := http.NewRequest(req.Method, targetUrl.String()+req.URL.Path, req.Body)
	if err != nil {
		utils.HandleError(err)
	}
	s.connections++
	proxy.CopyHeaders(req, proxyReq)
	proxyReq.URL.RawQuery = req.URL.RawQuery
	client := &http.Client{}
	resp, err := client.Do(proxyReq)
	if err != nil {
		http.Error(res, "Failed to connect to backend server", http.StatusBadGateway)
		s.connections--
		return
	}

	defer resp.Body.Close()
	proxy.CopyResponseHeaders(resp, res)
	res.WriteHeader(resp.StatusCode)
	_, err = io.Copy(res, resp.Body)
	if err != nil {
		log.Println("Error copying response body:", err)
	}
	s.connections--
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
