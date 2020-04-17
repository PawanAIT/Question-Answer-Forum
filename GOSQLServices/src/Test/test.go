package main

import (
	"fmt"
	"time"

	"auth"
)

func main() {
	fmt.Println("Yo")
	jwt := auth.NewJWTManager("foo", time.Minute*5)
	server := auth.NewJWTManager("foo", time.Minute*5)
	token, err := jwt.Generate(&auth.User{
		Username: "pwaan",
		Role:     "admin",
	})
	if err != nil {
		fmt.Println("phatt gaya")
	}
	fmt.Println(token)

	reps, err := server.Verify(token)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(reps.Username + " " + reps.Role)
}
