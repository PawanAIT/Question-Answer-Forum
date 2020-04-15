package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net"

	"../msdb"
	"../proto"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

type server struct{}

func main() {
	listener, err := net.Listen("tcp", ":4040")
	if err != nil {
		panic(err)
	}

	srv := grpc.NewServer()
	proto.RegisterAddServiceServer(srv, &server{})
	reflection.Register(srv)

	if e := srv.Serve(listener); e != nil {
		panic(e)
	}

}

/*
func (s *server) Add(ctx context.Context, request *proto.Request) (*proto.Response, error) {
	a, b := request.GetA(), request.GetB()

	result := a + b

	return &proto.Response{Result: result}, nil
}

func (s *server) Multiply(ctx context.Context, request *proto.Request) (*proto.Response, error) {
	a, b := request.GetA(), request.GetB()

	result := a * b

	return &proto.Response{Result: result}, nil
}*/

func (s *server) AddUser(ctx context.Context, request *proto.User) (*proto.Response, error) {
	fName, lName, email := request.GetFirstName(), request.GetLastName(), request.GetEmail()

	var db *sql.DB
	db = msdb.ConnectDatabase()

	createID, err := msdb.AddUser(db, fName, lName, email)
	if err != nil {
		log.Println("Error creating user: ", err.Error())
	}
	var response string
	response = fmt.Sprintf("Inserted ID: %d successfully.\n", createID)
	return &proto.Response{Resp: response}, nil

}

func (s *server) ReadUsers(ctx context.Context, request *proto.Khali) (*proto.Response, error) {

	var db *sql.DB
	db = msdb.ConnectDatabase()

	response, createID, err := msdb.ReadUsers(db)
	if err != nil {
		log.Println("Error reading Employees: ", err.Error())
	}
	fmt.Printf("Read %d ID's successfully.\n", createID)
	return &proto.Response{Resp: response}, nil

}
