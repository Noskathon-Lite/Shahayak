package balancer

import "net/http"

type LoadBalancer interface {
	GetServer() string
	Healthcheck() error
	ServeProxy(res http.ResponseWriter, req *http.Request)
	GetPort() string
}
