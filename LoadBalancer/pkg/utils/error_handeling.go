package utils

import (
	"fmt"
	"log"
)

func HandleError(err error) {
	fmt.Printf("%+v\n", err)
	log.Fatalf("%v", err)
}
