package balancer

import (
	"LoadBalancer/pkg/server"
	"sync"
)

type RoundRobinBalancer struct {
	Servers      []server.Server
	CurrentIndex int
	port         int
	mutex        sync.Mutex
}

func NewRoundRobinLoadBalancer(servers []server.Server, port int) *RoundRobinBalancer {
	return &RoundRobinBalancer{
		Servers:      servers,
		CurrentIndex: 0,
		port:         port,
	}
}

func (r *RoundRobinBalancer) GetServer() (*server.Server, error) {
	r.mutex.Lock()
	defer r.mutex.Unlock()

}
