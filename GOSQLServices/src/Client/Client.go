package main

import (
	"Client_interceptor"
	"log"
	"net/http"
	"proto"

	"github.com/gin-gonic/gin"
	"google.golang.org/grpc"
)

func authMethods() map[string]bool {
	const path = "/proto.AddService/"
	return map[string]bool{
		path + "AddUser":   true,
		path + "ReadUsers": true,
	}
}

func main() {
	interceptor, err := Client_interceptor.NewAuthInterceptor(authMethods())
	if err != nil {
		panic(err)
	}
	conn, err := grpc.Dial("localhost:4040", grpc.WithInsecure(), grpc.WithUnaryInterceptor(interceptor.Unary()))
	Client := proto.NewAddServiceClient(conn)
	g := gin.Default()
	g.GET("/add/:a/:b/:c", func(ctx *gin.Context) {

		req := &proto.User{FirstName: ctx.Param("a"), LastName: ctx.Param("b"), Email: ctx.Param("c")}
		if response, err := Client.AddUser(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Resp,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.GET("/show", func(ctx *gin.Context) {
		req := &proto.Khali{}

		if response, err := Client.ReadUsers(ctx, req); err == nil {
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
