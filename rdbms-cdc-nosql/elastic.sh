#!/bin/sh

cd $(dirname $0)
. ../scripts/dev-local.sh

heading "elastic: started"

subheading "connect : start the Confluent elasticsearch sink connector for 'all_orders'"
$CONNECT create ./connectors/elastic.json
$CONNECT status ./connectors/elastic.json

subheading "elasticsearch : creating the index for the 'all_orders_si'."

curl -H "Content-Type: application/json" -X DELETE http://localhost:9200/all_orders_si
echo ""

curl -H "Content-Type: application/json" -X PUT http://localhost:9200/all_orders_si -d @./elastic/all_orders_si.json
echo ""


subheading "connect : start the Confluent elasticsearch sink connector for the pre-created index, 'all_orders_si'."
$CONNECT create ./connectors/elastic-si.json
$CONNECT status ./connectors/elastic-si.json


footing "elastic: completed"









#url http://localhost:9200/all_orders/_count
#"mappings": {
#"properties": {
#"timestamp": {
#"type": "date",
#"format": "yyyy-MM-dd"
#}
#}
#}
