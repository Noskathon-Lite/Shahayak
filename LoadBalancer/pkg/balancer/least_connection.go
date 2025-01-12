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
