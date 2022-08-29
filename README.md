# Demos

Each folder is a demonstration that leverages the `dev-local` environment to showcase various aspects of event processing, real-time analytics, and more.

## Demo structure

* The scripts are structured assuming `dev-local` is a sibling directory to this `dev-local-demos` project.

* `./build.sh` - anything that needs to be done prior to starting containers.

  * This is primarily for installation of various connect workers into the Kafka Connect cluster, since
  those connectors need to be installed before the cluster is started.

* `./up.sh` - starts up all the containers needed for the demonstration

* `./setup.sh` - sets up the demonstration.

  * Execute this with a fully up and running cluster.
  * If you are wanting to learn more about the demo, this is the script to investigate.
  * This is mostly an "all-in-one" script, but some things (for various reasons with the demo) may be excluded, please read the README for the specific demo.

* `./ksql.sh` - if the demonstration leverages __ksqlDB__, this is the script to configure all of it. 

  * ksqlDB requires schema to be available on the registry, before they can be used. 

  * If a demo has ksql.sh referenced from the `setup.sh` script, then it also pre-creates the schemas.

  * Even if a demo does pre-create schema and sets up through `setup.sh` it will still be self-contained in a `ksql.sh` script for readability.
  
* `./down.sh` - brings down the containers startd with `./up.sh` and remove any volumes.

* `./stop.sh` - stops all the containers that were started with `up.sh`.

  * this is equivalent to `down.sh` but w/out removing the volumes.
  
* Each demonstration will have it's own setup, see the specific README for details.

## Service passwords

* The admin account username for the applications that require one is `admin`.

* The admin account password is the application name, unless the system prevents it. For example, the password for `grafana` is `grafana`.

* Currently only `minio` has password rules that prevents this. It's password is `miniominio`.

## Demos

### rdbms-cdc-nosql

* Orders Captured via CDC from both Postgres and MySQL leverating Debezium.

* Orders enriched and joined in ksqlDB

* Orders pushed to Cassandra, Mongo, and Elasticsearch with sink connectors

* Technologies

  * Apache Kafka
    * Confluent Community Edition Docker Images for Zookeeper and Brokers
  * Confluent's Schema Registry
    * Confluent Community Edition Docker Image for Schema Registry
  * Confluent's ksqlDB - Stream Processing 
    * Confluent Community Edition Docker Image for ksqlDB
  * Apache Kafka Connect Distributed Cluster
    * Confluent Community Edition Docker Images for Connect
    * Debezium for MySQL Source Connector (Apache 2.0 License)
    * Datastax Cassandra Sink Connector (Apache 2.0 License)
    * MongoDB Kafka Sink Connecttor (Apache 2.0 License)
    * Confluent Elasticsearch Sink Connector (Confluent Community License)
  * MySQL (v5 & v8)
  * Postgres
  * Apache Cassandra
  * MongoDB
  * Elasticsearch

  Please see the respective technologies license policy to ensure you are using it in accordance with their license.
