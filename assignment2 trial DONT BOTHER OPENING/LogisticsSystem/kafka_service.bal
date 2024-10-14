
import ballerina/log;
import ballerinax/kafka;

service kafkaService {
    resource function onMessage(kafka:Message) {
        // Process the received message
        log:printInfo("Received message: " + kafka.value.toString());
    }
}

kafka:ConsumerConfiguration consumerConfig = {
    bootstrapServers: ["localhost:9092"], // Replace with your Kafka broker address
    groupId: "my-consumer-group",
    autoOffsetReset: "earliest" // Or "latest"
};

kafka:Consumer consumer1 = kafka:createConsumer(consumerConfig, "new-delivery-request");
consumer1.subscribe(function (message) {
    onMessage(message);
});

kafka:Consumer consumer2 = kafka:createConsumer(consumerConfig, "standard-delivery-request");
consumer2.subscribe(function (message) {
    onMessage(message);
});

kafka:Consumer consumer3 = kafka:createConsumer(consumerConfig, "international-delivery-request");
consumer3.subscribe(function (message) {
    onMessage(message);
});

kafka:Consumer consumer4 = kafka:createConsumer(consumerConfig, "express-delivery-request");
consumer4.subscribe(function (message) {
    onMessage(message);
});