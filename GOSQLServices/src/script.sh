#!/bin/bash
  
# turn on bash's job control
set -m
  
# Start the server
./Server/Server &
  
# Start Client
./Client/Client
