#!/bin/sh
set -e
gradle assemble > /dev/null

. ./.classpath.sh

MAIN="dev.buesing.ksd.publisher.Main"

#export JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005

java $JAVA_OPTS  -cp "${CP}" $MAIN "$@"

