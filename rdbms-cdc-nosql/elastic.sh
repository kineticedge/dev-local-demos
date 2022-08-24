

curl -H "Content-Type: application/json" -X DELETE http://localhost:9200/all_orders_si
echo ""

curl -H "Content-Type: application/json" -X PUT http://localhost:9200/all_orders_si -d @./elastic/all_orders_si.json
echo ""

#url http://localhost:9200/all_orders/_count


#"mappings": {
#"properties": {
#"timestamp": {
#"type": "date",
#"format": "yyyy-MM-dd"
#}
#}
#}
