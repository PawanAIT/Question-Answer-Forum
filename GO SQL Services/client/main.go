package main

import (
	"log"
	"net/http"

	"../proto"

	"github.com/gin-gonic/gin"
	"google.golang.org/grpc"
)

func main() {
	conn, err := grpc.Dial("localhost:4040", grpc.WithInsecure())
	if err != nil {
		panic(err)
	}

	client := proto.NewAddServiceClient(conn)

	g := gin.Default()
	g.GET("/add/:a/:b/:c", func(ctx *gin.Context) {

		req := &proto.User{FirstName: ctx.Param("a"), LastName: ctx.Param("b"), Email: ctx.Param("c")}
		if response, err := client.AddUser(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Resp,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.GET("/show", func(ctx *gin.Context) {
		req := &proto.Khali{}

		if response, err := client.ReadUsers(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Resp,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	if err := g.Run(":8080"); err != nil {
		log.Fatalf("Failed to run server: %v", err)
	}

}
