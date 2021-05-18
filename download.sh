#!/bin/sh
DATADIR=$1
YEARS=${@:2}
CURRDIR=$PWD
URL="https://data.nber.org/natality"

cd $DATADIR
echo $PWD
for YEAR in $YEARS
  do curl -O "$URL/$YEAR/natl$YEAR.rdata"
done
cd $CURRDIR
