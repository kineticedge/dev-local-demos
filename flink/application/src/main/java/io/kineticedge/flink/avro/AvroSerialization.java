package io.kineticedge.flink.avro;

import org.apache.avro.specific.SpecificRecord;
import org.apache.flink.api.common.serialization.SerializationSchema;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.connector.kafka.sink.KafkaRecordSerializationSchema;
import org.apache.flink.formats.avro.registry.confluent.ConfluentRegistryAvroSerializationSchema;
import org.apache.kafka.clients.producer.ProducerRecord;

public class AvroSerialization<K extends SpecificRecord, V extends SpecificRecord> implements KafkaRecordSerializationSchema<Tuple2<K, V>> {

    private static final String SUBJECT_SUFFIX_KEY = "-key";
    private static final String SUBJECT_SUFFIX_VALUE = "-value";

    private final String topic;
    private final SerializationSchema<K> serializationSchemaKey;
    private final SerializationSchema<V> serializationSchemaValue;

    public AvroSerialization(final Class<K> keyClass, final Class<V> valueClass, final String topic, final String schemaRegistryUrl) {
        this.topic = topic;
        serializationSchemaKey = ConfluentRegistryAvroSerializationSchema.forSpecific(keyClass, getKeySubject(topic), schemaRegistryUrl);
        serializationSchemaValue = ConfluentRegistryAvroSerializationSchema.forSpecific(valueClass, getValueSubject(topic), schemaRegistryUrl);
    }

    @Override
    public void open(final SerializationSchema.InitializationContext context, final KafkaSinkContext sinkContext) throws Exception {
        KafkaRecordSerializationSchema.super.open(context, sinkContext);
    }

    @Override
    public ProducerRecord<byte[], byte[]> serialize(final Tuple2<K, V> element, final KafkaSinkContext context, final Long timestamp) {
        return new ProducerRecord<>(topic, serializationSchemaKey.serialize(element.f0), serializationSchemaValue.serialize(element.f1));
    }

    private String getKeySubject(final String topic) {
        return topic + SUBJECT_SUFFIX_KEY;
    }

    public String getValueSubject(final String topic) {
        return topic + SUBJECT_SUFFIX_VALUE;
    }
}