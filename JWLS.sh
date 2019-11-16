#!/bin/bash

clear

mkdir JWLSout 2>/dev/null

function finish {
  rm -r JWLSout
}


rm -r /tmp/JWLS 2>/dev/null
mkdir /tmp/JWLS 2>/dev/null


mkfifo /tmp/JWLS/wlin.fifo
touch /tmp/JWLS/wlout.txt



tail -f /tmp/JWLS/wlin.fifo | JWLS.wl

trap finish EXIT

