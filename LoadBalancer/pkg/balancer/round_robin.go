package balancer

import (
	"LoadBalancer/pkg/server"
	"sync"
)

type RoundRobin struct {
	Servers      []server.Server
	CurrentIndex int
	mutex        sync.Mutex
}
