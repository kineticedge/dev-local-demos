package io.kineticedge.flink.avro;

import org.apache.avro.specific.SpecificRecord;
import org.apache.flink.api.common.serialization.DeserializationSchema;
import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.api.java.typeutils.TupleTypeInfo;
import org.apache.flink.connector.kafka.source.reader.deserializer.KafkaRecordDeserializationSchema;
import org.apache.flink.formats.avro.registry.confluent.ConfluentRegistryAvroDeserializationSchema;
import org.apache.kafka.clients.consumer.ConsumerRecord;

import java.io.IOException;

public  class AvroDeserialization<K extends SpecificRecord, V extends SpecificRecord> implements KafkaRecordDeserializationSchema<Tuple2<K, V>> {

    private final TypeInformation<Tuple2<K, V>> typeInformation;
    private final DeserializationSchema<K> deserializationSchemaKey;
    private final DeserializationSchema<V> deserializationSchemaValue;

    public AvroDeserialization(final Class<K> keyClass, final Class<V> valueClass, final String schemaRegistryUrl) {
        this.typeInformation = new TupleTypeInfo<>(TypeInformation.of(keyClass), TypeInformation.of(valueClass));
        deserializationSchemaKey = ConfluentRegistryAvroDeserializationSchema.forSpecific(keyClass, schemaRegistryUrl);
        deserializationSchemaValue = ConfluentRegistryAvroDeserializationSchema.forSpecific(valueClass, schemaRegistryUrl);
    }

    @Override
    public TypeInformation<Tuple2<K, V>> getProducedType() {
        return typeInformation;
    }

    @Override
    public void deserialize(ConsumerRecord<byte[], byte[]> record, org.apache.flink.util.Collector<Tuple2<K, V>> out) throws IOException {
        out.collect(Tuple2.of(deserializationSchemaKey.deserialize(record.key()), deserializationSchemaValue.deserialize(record.value())));
    }
}