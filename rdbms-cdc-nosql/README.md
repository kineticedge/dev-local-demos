
## RDBMS Change Data Capture to NoSQL

This demonstration will take orders from __MySQL__ and orders from __Postgres__ can enrich them with their __user__ and __store__ metadata. 
It then will combine them into a single stream which is ingested into Cassandra as a single enriched order table that also includes the origin (__mysql__, __mysql5__,  or __postgres__).

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

  * Debezium MySQL Source Connector
  * Debezium Postgres Source Connector
  * Datastax Cassandra Sink Connector
  * Datastax Cassandra Sink Connector
  * Mongo
  * Elastic

* __mysql__ (v8 which has binlog pre-enabled)

* __mysql5__ (with binlog enabled to allow for the Debezium source connector to obtain changes from the database)

* __postgres__ (with loggine enabled)

* __cassandra__

* __mongodb__

* __ksqlDB__

## Setup

### `build.sh`

  * The Debezium and Datastax connectors needs to be installed in the distributed connect cluster before it is started.
This script downloads them from the confluent hub and installs them so the connect containers have access to them at startup.

### `up.sh`

  * starts all of the necessary containers 

  * It waits to ensure that both connect distributed cluster and cassandra are fully available before returning; since
their startup times are longer than others (the others should be ready when they are). 

### `setup.sh`

  * creates kafka topics
  * creates database tables in both MySQL, Postgres, and Cassandra
  * loads `user` and `store` tables in MySQL, MySQL5 and Postgres.
  * starts the `Debezium MySQL Source Connector`, `Debezium Postgresql Source Connector` and the `Datastax Cassandra Sink Connector`
  * registers the schemas for the 6 topics used as input to `ksqldb`. 
  Instead of registering, orders could be generated so the source connectors to register the schemas.
  ksqlDB requires schemas pre-registered (or data published to topics prior to creating the streams and tables in ksqlDB).

### `ksql.sh`

  * creates the `ORDERS`, `STRORES`, and `USERS` streams from the CDC topic.
    * the schemas are needed prior to creating these streams and tables; `setup.sh` registers with the `registers_schema.sh` script.
  * creates the `ENRICHED_ORDERS` stream that creates the enriched data.
  
### `generate.sh`

  * generates a ranom order or N orders to either `mysql`, `mysql5`, or `postgres` if a numerical value is provided as an argument.
  * random orders with a `store_id` and `user_id` contrainded to the values in the respective `stores` and `users` tables.

## Teardown

### `down.sh`

  * shuts all the containers down
  * removes all volumes
