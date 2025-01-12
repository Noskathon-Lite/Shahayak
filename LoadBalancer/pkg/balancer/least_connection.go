package balancer

import (
	"LoadBalancer/pkg/server"
	"LoadBalancer/pkg/utils"
	"fmt"
	"net/http"
	"sync"
)

type LeastConnection struct {
	Servers        []server.Server
	mutex          sync.Mutex
	HealthCheckUrl string
	port           string
}

func (lc *LeastConnection) GetServer() server.Server {
	lc.mutex.Lock()
	defer lc.mutex.Unlock()

	var selectedServer server.Server
	minConnections := int(^uint(0) >> 1) // Max int value

	// Find the server with the least number of active connections
	for _, server := range lc.Servers {
		if server.GetConnections() < minConnections {
			minConnections = server.GetConnections()
			selectedServer = server
		}
	}
	return selectedServer

}

func NewLeastConnectionServer(servers []server.Server, port string, healthCheckUrl string) *LeastConnection {
	return &LeastConnection{
		Servers:        servers,
		HealthCheckUrl: healthCheckUrl,
		port:           port,
	}
}

func (r *LeastConnection) GetPort() string {
	return r.port
}
func (r *RoundRobinBalancer) LeastConnectionHealthCheck() {
	for {
		for i := range r.Servers {
			server := r.Servers[i]
			resp, err := http.Get(server.GetAddress() + r.HealthCheckUrl)
			if err != nil || resp.Status != "200" {
				server.Shutdown()
				utils.HandleError(err)
			} else {
				server.MakeReady()
			}

		}
	}
}

func (r *RoundRobinBalancer) LeastConnectionServeProxy(res http.ResponseWriter, req *http.Request) {
	targetedServer := r.GetServer()
	fmt.Println("the targeted server is ", targetedServer)
	targetedServer.ServeHttp(res, req)
}
