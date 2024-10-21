#!/bin/bash

set -e
cd "$(dirname -- "$0")"
. ../scripts/dev-local.sh


heading "installing connectors"

subheading "installing opensky connector"

if [ ! -d "../../kafka-connect-opensky" ]; then
  echo ""
  echo "please clone and build (as a sibling to dev-local-demos) https://github.com/nbuesing/kafka-connect-opensky"
  echo ""
  exit
fi


if [ ! -f "../../kafka-connect-opensky/build/distributions/kafka-connect-opensky.tar" ]; then
  echo ""
  echo "cannot find kafka-connect-opensky connector."
  echo "please download the kafka-connect-opensky project as a sibling to dev-local and build."
  echo ""
  exit
fi

subheading "installing opensky connector"
(cd ../../dev-local/connect/jars/; tar xfv ../../../kafka-connect-opensky/build/distributions/kafka-connect-opensky.tar)

