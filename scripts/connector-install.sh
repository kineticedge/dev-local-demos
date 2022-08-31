
if [ "$DEV_LOCAL" == "" ]; then
    echo "\n'dev-local.sh' was not sourced; that needs to be sourced prior to this script.\n"
    exit 1
fi


function installPlugin() {

    connector=$1

    DIRECTORY=${connector%%;*}
    PLUGIN=${connector#*;}

    touch ../tmp/connect-distributed.properties

    heading "plugin : $connector"

    if [ ! -d "${DEV_LOCAL}/connect/jars/$DIRECTORY" ]; then
      subheading "installing plugin : $connector"
      confluent-hub install --worker-configs ../tmp/connect-distributed.properties --component-dir "${DEV_LOCAL}/connect/jars" --no-prompt "${PLUGIN}"
      echo ""
    else
      subheading "already installed: $DIRECTORY"
    fi

    rm ../tmp/connect-distributed.properties

}

function installPlugins() {
  declare -a CONNECTORS="$@"
  for connector in "${CONNECTORS[@]}" ; do
    installPlugin $connector
  done
}