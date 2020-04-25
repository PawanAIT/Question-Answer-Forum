package main

import (
	"fmt"
	"log"
	"net/http"
	"proto"
	"strconv"

	"ClientInterceptor"

	"github.com/gin-gonic/gin"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"google.golang.org/grpc"
)

func authMethods() map[string]bool {
	const path = "/proto.AddService/"
	return map[string]bool{
		path + "Login":            true,
		path + "ReadUsers":        true,
		path + "AddUser":          true,
		path + "AddDownvotes":     true,
		path + "AddKudos":         true,
		path + "AddAnswer":        true,
		path + "AddQuestion":      true,
		path + "AddTopic":         true,
		path + "FollowQuestion":   true,
		path + "FollowTopic":      true,
		path + "FollowUser":       true,
		path + "UnfollowQuestion": true,
		path + "UnfollowTopic":    true,
		path + "UnfollowUser":     true,
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
	interceptor, err := ClientInterceptor.NewAuthInterceptor(jwtToken, authMethods())
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

	g.GET("/show", func(ctx *gin.Context) {
		req := &proto.Khali{}

		if response, err := Client.ReadUsers(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Response,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.POST("/addUser/:a/:b/:c/:d/:e", func(ctx *gin.Context) {
		req := &proto.User{FirstName: ctx.Param("a"), LastName: ctx.Param("b"), Email: ctx.Param("c"), Bio: ctx.Param("d"), ProfilePicture: ctx.Param("e")}
		if response, err := Client.AddUser(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.PATCH("/addDownvotes/:a/:b", func(ctx *gin.Context) {
		var id, downvotes int64
		if id, err = strconv.ParseInt(ctx.Param("a"), 10, 64); err != nil {
			panic(err)
		}
		if downvotes, err = strconv.ParseInt(ctx.Param("b"), 10, 64); err != nil {
			panic(err)
		}
		req := &proto.Downvotes{AnswerId: id, Downvotes: downvotes}
		if response, err := Client.AddDownvotes(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.PATCH("/addKudos/:a/:b", func(ctx *gin.Context) {
		var id, kudos int64
		if id, err = strconv.ParseInt(ctx.Param("a"), 10, 64); err != nil {
			panic(err)
		}
		if kudos, err = strconv.ParseInt(ctx.Param("b"), 10, 64); err != nil {
			panic(err)
		}
		req := &proto.Kudos{AnswerId: id, Kudos: kudos}
		if response, err := Client.AddKudos(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.POST("/addAnswer/:a/:b/:c", func(ctx *gin.Context) {
		var questionID, userID int64
		var answer string
		if questionID, err = strconv.ParseInt(ctx.Param("a"), 10, 64); err != nil {
			panic(err)
		}
		if userID, err = strconv.ParseInt(ctx.Param("b"), 10, 64); err != nil {
			panic(err)
		}
		answer = ctx.Param("c")
		req := &proto.NewAnswer{AnswerText: answer, UserId: userID, QuestionId: questionID}
		if response, err := Client.AddAnswer(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.POST("/addQuestion/:a/:b/:c/:d", func(ctx *gin.Context) {
		var posterID, topicID int64
		var questionTitle, questionDetails string
		if posterID, err = strconv.ParseInt(ctx.Param("a"), 10, 64); err != nil {
			panic(err)
		}
		if topicID, err = strconv.ParseInt(ctx.Param("b"), 10, 64); err != nil {
			panic(err)
		}
		questionTitle = ctx.Param("c")
		questionDetails = ctx.Param("d")
		req := &proto.NewQuestion{PosterId: posterID, TopicId: topicID, QuestionTitle: questionTitle, QuestionDetails: questionDetails}
		if response, err := Client.AddQuestion(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.POST("/addTopic/:a", func(ctx *gin.Context) {
		var topicName string
		topicName = ctx.Param("a")
		req := &proto.NewTopic{TopicName: topicName}
		if response, err := Client.AddTopic(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.PUT("/followQuestion/:a/:b", func(ctx *gin.Context) {
		var followerID, questionID int64
		if followerID, err = strconv.ParseInt(ctx.Param("a"), 10, 64); err != nil {
			panic(err)
		}
		if questionID, err = strconv.ParseInt(ctx.Param("b"), 10, 64); err != nil {
			panic(err)
		}
		req := &proto.FollowQuestionRequest{FollowerId: followerID, QuestionId: questionID}
		if response, err := Client.FollowQuestion(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.PUT("/followTopic/:a/:b", func(ctx *gin.Context) {
		var followerID, topicID int64
		if followerID, err = strconv.ParseInt(ctx.Param("a"), 10, 64); err != nil {
			panic(err)
		}
		if topicID, err = strconv.ParseInt(ctx.Param("b"), 10, 64); err != nil {
			panic(err)
		}
		req := &proto.FollowTopicRequest{FollowerId: followerID, TopicId: topicID}
		if response, err := Client.FollowTopic(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.PUT("/followUser/:a/:b", func(ctx *gin.Context) {
		var followerID, followedUserID int64
		if followerID, err = strconv.ParseInt(ctx.Param("a"), 10, 64); err != nil {
			panic(err)
		}
		if followedUserID, err = strconv.ParseInt(ctx.Param("b"), 10, 64); err != nil {
			panic(err)
		}
		req := &proto.FollowUserRequest{FollowerId: followerID, FollowedUserId: followedUserID}
		if response, err := Client.FollowUser(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.DELETE("/unfollowQuestion/:a/:b", func(ctx *gin.Context) {
		var followerID, questionID int64
		if followerID, err = strconv.ParseInt(ctx.Param("a"), 10, 64); err != nil {
			panic(err)
		}
		if questionID, err = strconv.ParseInt(ctx.Param("b"), 10, 64); err != nil {
			panic(err)
		}
		req := &proto.FollowQuestionRequest{FollowerId: followerID, QuestionId: questionID}
		if response, err := Client.UnfollowQuestion(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.DELETE("/unfollowTopic/:a/:b", func(ctx *gin.Context) {
		var followerID, topicID int64
		if followerID, err = strconv.ParseInt(ctx.Param("a"), 10, 64); err != nil {
			panic(err)
		}
		if topicID, err = strconv.ParseInt(ctx.Param("b"), 10, 64); err != nil {
			panic(err)
		}
		req := &proto.FollowTopicRequest{FollowerId: followerID, TopicId: topicID}
		if response, err := Client.UnfollowTopic(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
			})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	})

	g.DELETE("/unfollowUser/:a/:b", func(ctx *gin.Context) {
		var followerID, followedUserID int64
		if followerID, err = strconv.ParseInt(ctx.Param("a"), 10, 64); err != nil {
			panic(err)
		}
		if followedUserID, err = strconv.ParseInt(ctx.Param("b"), 10, 64); err != nil {
			panic(err)
		}
		req := &proto.FollowUserRequest{FollowerId: followerID, FollowedUserId: followedUserID}
		if response, err := Client.UnfollowUser(ctx, req); err == nil {
			ctx.JSON(http.StatusOK, gin.H{
				"result": response.Status,
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
