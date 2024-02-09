#!/bin/bash

# run to generate *.param files from instances.txt
# bash mkInstances.sh

COMMAND=$( cat <<EOF
echo "language Essence 1.3" >   {1}-{2}.param ;
echo ""                     >>  {1}-{2}.param ;
echo "letting k be {1}"     >>  {1}-{2}.param ;
echo "letting n be {2}"     >>  {1}-{2}.param ;
echo ""                     >>  {1}-{2}.param
EOF
)

parallel $COMMAND ::: `seq 1 7` ::: `seq 1 20` 25 30

