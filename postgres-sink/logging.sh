#!/bin/bash

URL=http://localhost:18083/admin/loggers

CT="Content-Type:application/json"

curl -s -X PUT -H $CT ${URL}/io.confluent.connect.jdbc -d '{"level": "TRACE"}' | jq '.'

curl -s -X PUT -H $CT ${URL}/org.apache.kafka.connect.runtime.WorkerSinkTask -d '{"level": "TRACE"}' | jq '.'
