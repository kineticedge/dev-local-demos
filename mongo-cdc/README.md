
## Mongo CDC

Demonstrates CDC of one Mongo Collection and copying those documents to a secondarly collection.

## Containers 

* __kafka__ (1 Zookeeper, 4 Brokers, w/out Schema Registry)

* __connect__ (2 distributed workers in a single connect cluster)

  * Debezium Mongo Source Connector
  * Mongo Sink Connector

## Setup

### `build.sh`

  * The Debezium and Mongo connectors needs to be installed in the distributed connect cluster before it is started.
This script downloads them from the confluent hub and installs them.

### `up.sh`

  * starts the necessary containers 

  * It waits to ensure that both connect distributed cluster is fully up and available. 

### `setup.sh`

  * starts the `Debezium Mongo Source Connector`, `MongoDB Sink Connector`
 
### `generate.sh`

  * generates a random order in the __main__ database, __order__ collection in MongoDB. 

### `down.sh`

  * shuts all the containers down
  * removes all volumes
