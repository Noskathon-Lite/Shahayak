package proxy

import "net/http"

func CopyResponseHeaders(original *http.Response, destination http.ResponseWriter) {
	for key, value := range original.Header {
		for _, value := range value {
			destination.Header().Add(key, value)
		}
	}
}
