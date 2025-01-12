package utils

import "fmt"

func HandleError(err error) {
	fmt.Printf("%+v\n", err)
}
