package balancer

type LoadBalancer interface {
	GetServer() string
	Healthcheck() error
}
