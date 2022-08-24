
if ! [ -x "$(command -v jq)" ]; then
    echo "\njq is not found, please install and make it available on your path, https://stedolan.github.io/jq\n"
    exit
fi


# absolute path to 'dev-local-demos' project
DEV_LOCAL_DEMOS=$(cd $(dirname $0)/..; pwd)

# absolute Path to 'dev-local' project
DEV_LOCAL=$(cd $(dirname $0)/../../dev-local; pwd)

BIN=${DEV_LOCAL}/bin
CONNECT=${BIN}/connect
KSQL_SHELL=${BIN}/ksql-shell
DRUID=${BIN}/druid

alias d='docker'
alias dc='docker compose'
alias kt='kafka-topics --bootstrap-server localhost:19092,localhost:29092,localhost:39092'

function heading() {
  tput setaf 2; printf "$@\n"; tput sgr 0
}

function footing() {
  tput setaf 4; printf "$@\n"; tput sgr 0
}

function subheading() {
  tput setaf 3; printf "$@\n"; tput sgr 0
}
