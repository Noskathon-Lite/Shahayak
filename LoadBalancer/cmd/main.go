package main

import (
	"LoadBalancer/pkg/balancer"
	"LoadBalancer/pkg/server"
)

func main() {
	servers := []server.Server{
		server.NewBackendServer("https://www.facebook.com"),
		server.NewBackendServer("https://www.yahoo.com"),
		server.NewBackendServer("https://www.youtube.com"),
	}
	roundRobinBalancer := balancer.NewRoundRobinLoadBalancer(servers, "8000", "/healthcheck")
}
