#!/bin/bash

DEFAULT_NUM_THREADS=16
DEFAULT_BIN=build/test_runq

NUM_THREADS=${1:-$DEFAULT_NUM_THREADS}
BIN=${2:-$DEFAULT_BIN}
if [ -z "$NUM_THREADS" ]; then
    echo "Usage: $0 <num_threads> <BIN>"
    exit 1
fi
OMP_NUM_THREADS=$NUM_THREADS ./$BIN
