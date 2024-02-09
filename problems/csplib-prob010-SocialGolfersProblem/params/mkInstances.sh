#!/bin/bash

# run to generate *.param files from instances.txt
# cat instances.txt | bash mkInstances.sh

COMMAND=$( cat <<EOF
echo "language Essence 1.3" >   {1}-{2}-{3}-{4}.param ;
echo ""                     >>  {1}-{2}-{3}-{4}.param ;
echo "letting w be {2}"     >>  {1}-{2}-{3}-{4}.param ;
echo "letting g be {3}"     >>  {1}-{2}-{3}-{4}.param ;
echo "letting s be {4}"     >>  {1}-{2}-{3}-{4}.param ;
echo ""                     >>  {1}-{2}-{3}-{4}.param
EOF
)

parallel --colsep ' ' $COMMAND

