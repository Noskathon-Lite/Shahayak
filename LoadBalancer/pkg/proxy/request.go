package proxy

import "net/http"

func CopyHeaders(source *http.Request, destination *http.Request) {
	for key, value := range source.Header {
		for _, value := range value {
			destination.Header.Add(key, value)
		}
	}
}
