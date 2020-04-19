package main

import (
	"Server_interceptor"
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
	interceptor := Server_interceptor.NewAuthInterceptor(jwtManager)
	srv := grpc.NewServer(
		grpc.UnaryInterceptor(interceptor.Unary()),
	)
	proto.RegisterAddServiceServer(srv, &server{})
	reflection.Register(srv)

	if e := srv.Serve(listener); e != nil {
		panic(e)
	}

}

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

func (s *server) AddUser(ctx context.Context, request *proto.User) (*proto.Response, error) {
	fName, lName, email := request.GetFirstName(), request.GetLastName(), request.GetEmail()
	fmt.Println(fName, lName, email)
	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	createID, err := msdb.AddUser(db, fName, lName, email)
	if err != nil {
		log.Println("Error creating user: ", err.Error())
	}
	var response string
	response = fmt.Sprintf("Inserted ID: %d successfully.\n", createID)
	return &proto.Response{Resp: response}, nil

}

func (s *server) Login(ctx context.Context, request *proto.LoginRequest) (*proto.Token, error) {
	state, authcode := request.GetState(), request.GetAuthcode()
	fmt.Println("state =  %s, authcode = %s", state, authcode)
	accessToken, err := getUserInfoAndJWTAccessToken(state, authcode)
	if err != nil {
		return nil, fmt.Errorf("Failed to get accessToken : %s", err.Error())
	}
	fmt.Println("InsideLoginFunction")

	res := &proto.Token{AccessToken: accessToken}
	return res, nil
}

func (s *server) ReadUsers(ctx context.Context, request *proto.Khali) (*proto.Response, error) {

	var db *sql.DB
	db = msdb.ConnectDatabase()
	defer db.Close()

	response, createID, err := msdb.ReadUsers(db)
	if err != nil {
		log.Println("Error reading Employees: ", err.Error())
	}
	fmt.Printf("Read %d ID's successfully.\n", createID)
	return &proto.Response{Resp: response}, nil

}
