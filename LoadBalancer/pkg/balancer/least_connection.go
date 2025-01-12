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
