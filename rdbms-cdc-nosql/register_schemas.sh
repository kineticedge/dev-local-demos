#!/bin/sh

cd $(dirname $0)

declare -a schemas


schemas=($(ls ./schemas/*.json))

for i in "${schemas[@]}"; do

 base=$(basename $i) 
 subject=${base%.json}

 SCHEMA=$(jq '. | tojson' $i)

  DATA=$(cat <<EOF
  {
    "schema" : ${SCHEMA},
    "schemaType" : "AVRO"
  }
EOF)

  echo ${subject}
  curl -s -X POST -H "Content-Type:application/json" --data "${DATA}" "http://localhost:8081/subjects/${subject}/versions/" | jq
  echo ""

done



