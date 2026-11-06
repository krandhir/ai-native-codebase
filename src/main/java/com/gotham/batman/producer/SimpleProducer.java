package com.gotham.batman.producer;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.Properties;

public class SimpleProducer {
    public static void main(String[] args) {
        String bootstrapServers = "127.0.0.1:9092";
        String topic = "learning-kafka";

        // 1. Create Producer Properties
        Properties properties = new Properties();
        properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

        // 2. Create the Producer
        KafkaProducer<String, String> producer = new KafkaProducer<>(properties);

        // 3. Create a Producer Record & Send data
        for (int i = 0; i < 10; i++) {
            String messageValue = "Hello Kafka World " + i;
            ProducerRecord<String, String> record = new ProducerRecord<>(topic, messageValue);

            producer.send(record);
            System.out.println("Sent: " + messageValue);
        }

        // 4. Flush and Close (Mandatory to avoid data loss)
        producer.flush();
        producer.close();
    }
}
