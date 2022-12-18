
if ! [ -x "$(command -v jq)" ]; then
    echo "\njq is not found, please install and make it available on your path, https://stedolan.github.io/jq\n"
    exit 1
fi


# absolute path to 'dev-local-demos' project
DEV_LOCAL_DEMOS=$(cd $(dirname $0)/..; pwd)

# absolute Path to 'dev-local' project
DEV_LOCAL=$(cd $(dirname $0)/../../dev-local; pwd)

BIN=${DEV_LOCAL}/bin
CONNECT=${BIN}/connect
KSQL_SHELL=${BIN}/ksql-shell
DRUID=${BIN}/druid

# ensure aliases are accessible from within functions, when bash shell is used.
shopt -s expand_aliases

alias d='docker'
alias dc='docker compose'
alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'

#kt --create --if-not-exists --topic __consumer_offsets --replication-factor 3 --partitions 1 --config min.insync.replicas=2 --config cleanup.policy=compact --config compression.type=producer --config segment.bytes=104857600


function create_connect_topics() {

  kt --create --if-not-exists --topic connect-cluster-config \
	--replication-factor 3 \
	--partitions 1 \
	--config min.insync.replicas=2 \
	--config cleanup.policy=compact

  kt --create --if-not-exists --topic connect-cluster-offsets \
	--replication-factor 3 \
	--partitions 25 \
	--config min.insync.replicas=2 \
	--config cleanup.policy=compact

  kt --create --if-not-exists --topic connect-cluster-status \
	--replication-factor 3 \
	--partitions 5 \
	--config min.insync.replicas=2 \
	--config cleanup.policy=compact
}


function is_connect_ready() {
  $CONNECT available
  [ $? -ne 0 ] && error_msg "connector RESTful API is not yet available, aborting script. wait until connector is ready to run this script." && exit 1
}

function heading() {
  tput setaf 2; printf "$@\n"; tput sgr 0
}

function footing() {
  tput setaf 4; printf "$@\n"; tput sgr 0
}

function subheading() {
  tput setaf 3; printf "$@\n"; tput sgr 0
}

function error_msg() {
  tput setaf 5; printf "\n$@\n\n"; tput sgr 0
}
