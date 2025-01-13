package main

import (
	"LoadBalancer/pkg/balancer"
	"LoadBalancer/pkg/server"
	"LoadBalancer/pkg/utils"
	"fmt"
	"net/http"
)

func main() {
	servers := []server.Server{
		server.NewBackendServer("http://localhost:9000"),
		server.NewBackendServer("http://localhost:9002"),
		server.NewBackendServer("http://localhost:9001"),
	}
	roundRobinBalancer := balancer.NewRoundRobinLoadBalancer(servers, "8080", "/healthcheck")
	//go roundRobinBalancer.HealthCheck()
	handleRedirect := func(res http.ResponseWriter, req *http.Request) {
		roundRobinBalancer.ServeProxy(res, req)
	}
	http.HandleFunc("/", handleRedirect)
	fmt.Println("Starting server on port 8080")
	err := http.ListenAndServe(":"+roundRobinBalancer.GetPort(), nil)
	if err != nil {
		utils.HandleError(err)
	}

}
