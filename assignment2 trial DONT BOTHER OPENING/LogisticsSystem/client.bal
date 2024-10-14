
import ballerina/kafka;
import ballerina/log;

service client {
    resource function submitRequest(request: DeliveryRequest) {
        // Create a Kafka producer and send the request
        kafka:Producer producer = kafka:createProducer("localhost:9094");
        producer.send("delivery-requests", json:serialize(request));
        log:printInfo("Request submitted: " + json:serialize(request));
    }
}