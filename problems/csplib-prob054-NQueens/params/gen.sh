#!/bin/bash

# Edit this to make bigger instances
maxsize=14

for i in $(seq 2 14); do
  echo "language ESSENCE' 1.0" > $((2**i)).param
  echo "letting n be $((2**i))" >> $((2**i)).param
done