package com.gotham.batman.consumer;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.serialization.StringDeserializer;

import java.time.Duration;
import java.util.Collections;
import java.util.Properties;

public class SimpleConsumer {
    public static void main(String[] args) {
        String bootstrapServers = "127.0.0.1:9092";
        String topic = "learning-kafka";
        String groupId = "my-learning-group";

        // 1. Create Consumer Properties
        Properties properties = new Properties();
        properties.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        properties.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.GROUP_ID_CONFIG, groupId);
        properties.setProperty(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest"); // Read from the beginning if no offset exists

        // 2. Create the Consumer
        KafkaConsumer<String, String> consumer = new KafkaConsumer<>(properties);

        // 3. Subscribe to the Topic
        consumer.subscribe(Collections.singletonList(topic));

        // 4. Poll for data in an infinite loop
        System.out.println("Waiting for messages...");
        try {
            while (true) {
                ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));

                for (ConsumerRecord<String, String> record : records) {
                    System.out.printf("Received Message -> Key: %s, Value: %s, Partition: %d, Offset: %d%n",
                            record.key(), record.value(), record.partition(), record.offset());
                }
            }
        } finally {
            consumer.close(); // Clean shutdown
        }
    }
}

