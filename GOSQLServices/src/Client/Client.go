package main

import (
	"Client_interceptor"
	"fmt"
	"log"
	"net/http"
	"proto"

	"github.com/gin-gonic/gin"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"google.golang.org/grpc"
)

func authMethods() map[string]bool {
	const path = "/proto.AddService/"
	return map[string]bool{
		path + "AddUser":   true,
		path + "ReadUsers": true,
		path + "Login":     true,
	}
}

var (
	googleOauthConfig *oauth2.Config
	// TODO: randomize it
	oauthStateString = "pseudo-random"
)

func init() {
	googleOauthConfig = &oauth2.Config{
		RedirectURL:  "http://localhost:8080/callback",
		ClientID:     "392376614027-qpuh3t81joaucdt4kcgpq84gbfqrr83f.apps.googleusercontent.com",
		ClientSecret: "0ISYm6CUhkyezn_JpBzV1lIA",
		Scopes:       []string{"https://www.googleapis.com/auth/userinfo.email"},
		Endpoint:     google.Endpoint,
	}
}

var jwtToken string

func getInterceptor() (proto.AddServiceClient, error) {
	interceptor, err := Client_interceptor.NewAuthInterceptor(jwtToken, authMethods())
	if err != nil {
		panic(err)
	}

	conn, err := grpc.Dial("localhost:4567", grpc.WithInsecure(), grpc.WithUnaryInterceptor(interceptor.Unary()))
	if err != nil {
		return nil, err
	}
	Client := proto.NewAddServiceClient(conn)
	return Client, nil
}

func main() {

	connectionWithoutInterceptor, err := grpc.Dial("localhost:4567", grpc.WithInsecure())
	if err != nil {
		log.Fatal("cannot dial server: ", err)
	}
	ClientWithoutInterceptor := proto.NewAddServiceClient(connectionWithoutInterceptor)
	var Client proto.AddServiceClient
	g := gin.Default()
	g.GET("/", func(ctx *gin.Context) {
		var w http.ResponseWriter = ctx.Writer
		var r *http.Request = ctx.Request
		handleMain(w, r)
	})
	g.GET("/loginWithGoogle", func(ctx *gin.Context) {
		var w http.ResponseWriter = ctx.Writer
		var r *http.Request = ctx.Request
		handleGoogleLogin(w, r)
	})

	g.GET("/callback", func(ctx *gin.Context) {
		var w http.ResponseWriter = ctx.Writer
		var r *http.Request = ctx.Request
		state, authcode := handleGoogleCallback(w, r)

		req := &proto.LoginRequest{State: state, Authcode: authcode}
		if Token, err := ClientWithoutInterceptor.Login(ctx, req); err == nil {
			jwtToken = Token.AccessToken
			Client, _ = getInterceptor()
			ctx.JSON(http.StatusOK, gin.H{
				"result": jwtToken,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

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

//OAuthInfo contains data returned from OAuth2 Verifier
type OAuthInfo struct {
	ID            string `json:"id"`
	Email         string `json:"email"`
	VerifiedEmail bool   `json:"verified_email"`
	Picture       string `json:"picture"`
}

func init() {
	googleOauthConfig = &oauth2.Config{
		RedirectURL:  "http://localhost:8080/callback",
		ClientID:     "392376614027-qpuh3t81joaucdt4kcgpq84gbfqrr83f.apps.googleusercontent.com",
		ClientSecret: "0ISYm6CUhkyezn_JpBzV1lIA",
		Scopes:       []string{"https://www.googleapis.com/auth/userinfo.email"},
		Endpoint:     google.Endpoint,
	}
}

func handleMain(w http.ResponseWriter, req *http.Request) {
	var htmlIndex = `<html>
	<body>
		<a href="/loginWithGoogle">Google Log In</a>
	</body>
	</html>`

	fmt.Fprintf(w, htmlIndex)
}
func handleGoogleLogin(w http.ResponseWriter, r *http.Request) {
	url := googleOauthConfig.AuthCodeURL(oauthStateString)
	http.Redirect(w, r, url, http.StatusTemporaryRedirect)
}

func handleGoogleCallback(w http.ResponseWriter, r *http.Request) (string, string) {
	state, authcode := r.FormValue("state"), r.FormValue("code")
	return state, authcode
}
