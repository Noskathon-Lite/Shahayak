package balancer

import (
	"LoadBalancer/pkg/server"
	"fmt"
	"net/http"
	"sync"
)

type RoundRobinBalancer struct {
	Servers        []server.Server
	CurrentIndex   int
	port           string
	mutex          sync.Mutex
	HealthCheckUrl string
}

func NewRoundRobinLoadBalancer(servers []server.Server, port string, healthCheckUrl string) *RoundRobinBalancer {
	return &RoundRobinBalancer{
		Servers:        servers,
		CurrentIndex:   0,
		port:           port,
		HealthCheckUrl: healthCheckUrl,
	}
}

func (r *RoundRobinBalancer) GetServer() server.Server {
	r.mutex.Lock()
	defer r.mutex.Unlock()
	availableServer := r.Servers[r.CurrentIndex%len(r.Servers)]
	for {
		if availableServer.IsAlive() {
			return availableServer
		}
		r.CurrentIndex++
	}
}

func (r *RoundRobinBalancer) GetPort() string {
	return r.port
}

func (r *RoundRobinBalancer) HealthCheck() {
	for {
		for i := range r.Servers {
			server := r.Servers[i]
			resp, err := http.Get(server.GetAddress() + r.HealthCheckUrl)
			if err != nil || resp.Status != "200" {
				server.Shutdown()
				HandleError(err)
			} else {
				server.MakeReady()
			}

		}
	}
}
func (r *RoundRobinBalancer) ServeProxy(res http.ResponseWriter, req *http.Request) {
	targetedServer := r.GetServer()
	fmt.Println("the targeted server is ", targetedServer)
	targetedServer.ServeHttp(res, req)
}
