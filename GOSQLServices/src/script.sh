#!/bin/bash
  
# turn on bash's job control
set -m
  
# Start the server
./Server &
  
# Start Client
./Client
