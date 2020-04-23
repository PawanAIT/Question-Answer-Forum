package main

import (
	"auth"
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net"
	"net/http"
	"time"

	"ServerInterceptor"
	"msdb"

	"proto"

	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

type server struct{}

func main() {
	listener, err := net.Listen("tcp", "0.0.0.0:4567")
	if err != nil {
		panic(err)
	}
	interceptor := ServerInterceptor.NewAuthInterceptor(jwtManager)
	srv := grpc.NewServer(
		grpc.UnaryInterceptor(interceptor.Unary()),
	)
	proto.RegisterAddServiceServer(srv, &server{})
	reflection.Register(srv)

	if e := srv.Serve(listener); e != nil {
		panic(e)
	}

}

//OAuthInfo stores data returned by Google OAuth
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

var (
	googleOauthConfig *oauth2.Config
	// TODO: randomize it
	oauthStateString = "pseudo-random"
	jwtManager       = auth.NewJWTManager("foobar", time.Minute*15)
)

func getUserInfoAndJWTAccessToken(state string, code string) (string, error) {

	if state != oauthStateString {
		return "", fmt.Errorf("invalid oauth state")
	}

	fmt.Println(code)

	token, err := googleOauthConfig.Exchange(oauth2.NoContext, code)

	if err != nil {
		return "", fmt.Errorf("code exchange failed: %s", err.Error())
	}

	response, err := http.Get("https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + token.AccessToken)
	if err != nil {
		return "", fmt.Errorf("failed getting user info: %s", err.Error())
	}
	defer response.Body.Close()
	contents, err := ioutil.ReadAll(response.Body)
	if err != nil {
		return "", fmt.Errorf("failed reading response body: %s", err.Error())
	}

	fmt.Println(token)

	var userInfo OAuthInfo
	err = json.Unmarshal(contents, &userInfo)
	if err != nil {
		panic(err)
	}
	jwttoken, err := jwtManager.Generate(&auth.User{
		Username: userInfo.Email,
		Id:       userInfo.ID,
	})
	if err != nil {
		fmt.Println("Unable to generate token")
	}
	return jwttoken, nil
}

func (s *server) Login(ctx context.Context, request *proto.LoginRequest) (*proto.Token, error) {
	state, authcode := request.GetState(), request.GetAuthcode()
	fmt.Printf("state =  %s, authcode = %s\n", state, authcode)
	accessToken, err := getUserInfoAndJWTAccessToken(state, authcode)
	if err != nil {
		return nil, fmt.Errorf("Failed to get accessToken : %s", err.Error())
	}
	fmt.Println("InsideLoginFunction")

	res := &proto.Token{AccessToken: accessToken}
	return res, nil
}

func (s *server) ReadUsers(ctx context.Context, request *proto.Khali) (*proto.StringResponse, error) {

	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	response, countID, err := msdb.ReadUsers(db)
	if err != nil {
		log.Println("Error reading Employees: ", err.Error())
	}
	fmt.Printf("Read %d ID's successfully.\n", countID)
	return &proto.StringResponse{Status: response}, nil
}

func (s *server) AddUser(ctx context.Context, request *proto.User) (*proto.Response, error) {
	fName, lName, email, bio, profilePicture := request.GetFirstName(), request.GetLastName(), request.GetEmail(),
		request.GetBio(), request.GetProfilePicture()
	fmt.Println(fName, lName, email, bio, email)
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.AddUser(db, fName, lName, email, bio, profilePicture)
	if err != nil {
		log.Println("Error creating user: ", err.Error())
	}
	return &proto.Response{Status: status}, nil

}

func (s *server) AddDownvotes(ctx context.Context, request *proto.Downvotes) (*proto.Response, error) {
	id, downvotes := request.GetAnswerId(), request.GetDownvotes()
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.AddDownvotes(db, id, downvotes)
	if err != nil {
		log.Println("Error Adding Downvotes: ", err.Error())
	}
	return &proto.Response{Status: status}, nil
}

func (s *server) AddKudos(ctx context.Context, request *proto.Kudos) (*proto.Response, error) {
	id, kudos := request.GetAnswerId(), request.GetKudos()
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.AddKudos(db, id, kudos)
	if err != nil {
		log.Println("Error Adding Kudos: ", err.Error())
	}
	return &proto.Response{Status: status}, nil
}

func (s *server) AddAnswer(ctx context.Context, request *proto.NewAnswer) (*proto.Response, error) {
	answerText, questionID, userID := request.GetAnswerText(), request.GetQuestionId(), request.GetUserId()
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.AddAnswer(db, answerText, questionID, userID)
	if err != nil {
		log.Println("Error Adding Answer: ", err.Error())
	}
	return &proto.Response{Status: status}, nil
}

func (s *server) AddQuestion(ctx context.Context, request *proto.NewQuestion) (*proto.Response, error) {
	questionTitle, questionDetails, posterID, topicID := request.GetQuestionTitle(), request.GetQuestionDetails(),
		request.GetPosterId(), request.GetTopicId()
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.AddQuestion(db, questionTitle, questionDetails, posterID, topicID)
	if err != nil {
		log.Println("Error Adding Question: ", err.Error())
	}
	return &proto.Response{Status: status}, nil
}

func (s *server) AddTopic(ctx context.Context, request *proto.NewTopic) (*proto.Response, error) {
	topicName := request.GetTopicName()
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.AddTopic(db, topicName)
	if err != nil {
		log.Println("Error Adding Topic: ", err.Error())
	}
	return &proto.Response{Status: status}, nil
}

func (s *server) FollowQuestion(ctx context.Context, request *proto.FollowQuestionRequest) (*proto.Response, error) {
	followerID, questionID := request.GetFollowerId(), request.GetQuestionId()
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.FollowQuestion(db, followerID, questionID)
	if err != nil {
		log.Println("Error Following Question: ", err.Error())
	}
	return &proto.Response{Status: status}, nil
}

func (s *server) FollowTopic(ctx context.Context, request *proto.FollowTopicRequest) (*proto.Response, error) {
	followerID, topicID := request.GetFollowerId(), request.GetTopicId()
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.FollowTopic(db, followerID, topicID)
	if err != nil {
		log.Println("Error Following Topic: ", err.Error())
	}
	return &proto.Response{Status: status}, nil
}

func (s *server) FollowUser(ctx context.Context, request *proto.FollowUserRequest) (*proto.Response, error) {
	followerID, userID := request.GetFollowerId(), request.GetFollowedUserId()
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.FollowUser(db, followerID, userID)
	if err != nil {
		log.Println("Error Following User: ", err.Error())
	}
	return &proto.Response{Status: status}, nil
}

func (s *server) UnfollowQuestion(ctx context.Context, request *proto.FollowQuestionRequest) (*proto.Response, error) {
	followerID, questionID := request.GetFollowerId(), request.GetQuestionId()
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.UnfollowQuestion(db, followerID, questionID)
	if err != nil {
		log.Println("Error Unfollowing Question: ", err.Error())
	}
	return &proto.Response{Status: status}, nil
}

func (s *server) UnfollowTopic(ctx context.Context, request *proto.FollowTopicRequest) (*proto.Response, error) {
	followerID, topicID := request.GetFollowerId(), request.GetTopicId()
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.UnfollowTopic(db, followerID, topicID)
	if err != nil {
		log.Println("Error Unfollowing Topic: ", err.Error())
	}
	return &proto.Response{Status: status}, nil
}

func (s *server) UnfollowUser(ctx context.Context, request *proto.FollowUserRequest) (*proto.Response, error) {
	followerID, userID := request.GetFollowerId(), request.GetFollowedUserId()
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	status, err := msdb.UnfollowUser(db, followerID, userID)
	if err != nil {
		log.Println("Error Unfollowing User: ", err.Error())
	}
	return &proto.Response{Status: status}, nil
}
