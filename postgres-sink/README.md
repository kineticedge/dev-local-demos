
## Postgres Sink Demonstration

This demonstration shows how to migrate schemaless data into a relational database using the JDBC Sink Connector which requires a schema.


* This demonstration demonstrates change data capture from a relational databases, enrichment by ksqlDB, and the stores the resulting enriched stream of data to Apache Cassandra.
* Uses and Stores are created and stored in tables in relational databases and replicated to topics in Apache Kafka.
* A script is provided to generate random orders in each of the relational databases.
* The tables are streamed into Kafka topics using the Debezium MySQL CDC source connector.  
* ksqlDB joins the stream of orders to the tables of users and stores to create an enriched ordered. 
  This enriched order is written to Cassandra using the open-source Datastax Cassandra sink connector.
* This demonstration leverages docker and docker compose to provide a fully contained demonstration of this pprocess.

## Containers 

* __kafka__ (1 Zookeeper, 4 Brokers, and 1 Schema Registry)

* __connect__ (2 distributed workers in a single connect cluster)

  * JDBC Sink Connector

* __postgres__

* __ksqlDB__

## Setup

### `build.sh`

  * The JDBC Sink connector needs to be installed.
This script downloads them from the confluent hub and installs them so the connect containers have access to them at startup.

### `up.sh`

  * starts all of the necessary containers 

  * It waits to ensure that both connect distributed cluster and ksqlDB are fully available before exiting.

### `setup.sh`

  * creates kafka topics
  * creates database tables in Postgres
  * create ksql query to read data from a topic with JSON data
  * create ksql query to create a topic with a schema associated witht the key and value
  * create a connector to write the data from the schema-associated topic to Postgres
  
### `generate.sh`

  * generates a ranom order or N orders as non-schema based JSON to the ORDERS topic.

## Teardown

### `down.sh`

  * shuts all the containers down
  * removes all volumes
