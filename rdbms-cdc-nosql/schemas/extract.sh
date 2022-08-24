#!/bin/bash

subject=_postgres_.public.orders-value

curl -s "http://localhost:8081/subjects/" | jq -r '.[]' | while read subject; do
  echo $subject
  if [[ $subject =~ ^(_postgres_\.public|_mysql_\.main|_mysql5_\.main).*$ ]]; then
    echo "extracting: $subject"
    curl -s "http://localhost:8081/subjects/${subject}/versions/latest" | jq '.schema | fromjson' > ${subject}.json
  fi
done





