package main

import (
	"fmt"
	"time"

	"auth"
)

func main() {
	fmt.Println("Yo")
	jwt := auth.NewJWTManager("foo", time.Minute*5)
	token, err := jwt.Generate(&auth.User{
		Username: "pawan",
		Role:     "admin",
	})
	if err != nil {
		fmt.Println("Unable to generate token")
	}

	reps, err := server.Verify(token)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(reps.Username + " " + reps.Role)
}
