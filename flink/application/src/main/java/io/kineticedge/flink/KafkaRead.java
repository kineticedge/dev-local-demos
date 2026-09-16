package io.kineticedge.flink;


import io.kineticedge.flink.avro.AvroDeserialization;
import io.kineticedge.flink.avro.AvroSerialization;
import io.kineticedge.order.Order;
import io.kineticedge.order.OrderKey;
import io.kineticedge.order.OrderLineItem;
import io.kineticedge.purchaseorder.PurchaseOrder;
import io.kineticedge.purchaseorder.PurchaseOrderLineItem;
import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.api.java.typeutils.TupleTypeInfo;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.connector.kafka.sink.KafkaSink;
import org.apache.flink.connector.kafka.source.KafkaSource;
import org.apache.flink.connector.kafka.source.enumerator.initializer.OffsetsInitializer;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.kafka.clients.consumer.OffsetResetStrategy;

import java.util.Properties;
import java.util.Random;
import java.util.stream.Collectors;

public class KafkaRead {

    private static final Random RANDOM = new Random();

    public static void main(String[] args) throws Exception {

        Configuration configuration = new Configuration();
        configuration.setString("pipeline.name", "example-pipeline");

        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment()
                .enableCheckpointing(5000L);

        env.configure(configuration);

        String bootStrapServers = "broker-1:9092,broker-2:9092,broker-3:9092";

        Properties kafkaProperties = new Properties();
        kafkaProperties.setProperty("bootstrap.servers", bootStrapServers);

        KafkaSource<Tuple2<OrderKey, Order>> source = KafkaSource.<Tuple2<OrderKey, Order>>builder()
                .setBootstrapServers(bootStrapServers)
                .setTopics("datagen.orders")
                .setDeserializer(new AvroDeserialization<>(OrderKey.class, Order.class, "http://schema-registry:8081"))
                .setProperty("commit.offsets.on.checkpoint", "true")
                .setProperty("group.id", "flink-example")
                .setStartingOffsets(OffsetsInitializer.committedOffsets(OffsetResetStrategy.EARLIEST))
                .build();

        KafkaSink<Tuple2<OrderKey, PurchaseOrder>> sink = KafkaSink.<Tuple2<OrderKey, PurchaseOrder>>builder()
                .setBootstrapServers(bootStrapServers)
                .setRecordSerializer(new AvroSerialization<>(OrderKey.class, PurchaseOrder.class, "purchase-orders", "http://schema-registry:8081"))
                .build();

        env.fromSource(source, WatermarkStrategy.noWatermarks(), "DatagenOrders")
                .map(kv -> {
                    return new Tuple2<>(kv.f0, convert(kv.f1));
                }, new TupleTypeInfo<>(TypeInformation.of(OrderKey.class), TypeInformation.of(PurchaseOrder.class)))
                .sinkTo(sink);

        env.execute();

    }

    private static PurchaseOrder convert(Order order) {

        return PurchaseOrder.newBuilder()
                .setOrderId(order.getOrderId())
                .setUserId(order.getUserId())
                .setStoreId(order.getStoreId())
                .setLineItems(order.getLineItems().stream().map(KafkaRead::convert).collect(Collectors.toList()))
                .build();
    }

    private static PurchaseOrderLineItem convert(OrderLineItem lineItem) {

        final double price = randomPrice();

        return PurchaseOrderLineItem.newBuilder()
                .setSku(lineItem.getSku())
                .setQuantity(lineItem.getQuantity())
                .setPrice(price)
                .setRetailPrice(Math.floor(price * 1.10 * 100) / 100.0)
                .build();
    }

    private static double randomPrice() {
        return ((double) RANDOM.nextInt(10_000)) / 100.0;
    }
}