package main

import (
	"LoadBalancer/pkg/balancer"
	"LoadBalancer/pkg/server"
	"net/http"
)

func main() {
	servers := []server.Server{
		server.NewBackendServer("https://www.facebook.com"),
		server.NewBackendServer("https://www.yahoo.com"),
		server.NewBackendServer("https://www.youtube.com"),
	}
	roundRobinBalancer := balancer.NewRoundRobinLoadBalancer(servers, "8000", "/healthcheck")
	go roundRobinBalancer.HealthCheck()
	handleRedirect := func(res http.ResponseWriter, req *http.Request) {
		roundRobinBalancer.ServeProxy(res, req)
	}
	http.HandleFunc("/", handleRedirect)
	err := http.ListenAndServe(":"+roundRobinBalancer.GetPort(), nil)
	if err != nil {
		HandleError(err)
	}

}
