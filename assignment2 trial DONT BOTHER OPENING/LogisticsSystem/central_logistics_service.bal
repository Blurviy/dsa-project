
import ballerina/log;
import ballerina/http;
import ballerinax/kafka;
import ballerina/sql;
import ballerina/json;

type DeliveryRequest record {
    int id;
    string delivery_type;
    string pickupLocation ;
    string deliveryLocation;
    string preferredTimeSlots;
};

type DeliverySchedule record {
    int requestId ;
    string deliveryService;
    string pickupTime;
    string deliveryTime;
};




 type centralLogisticsService record {
      string message;
};

type body record {
string body
};

service centralLogisticsService {
    resource function onMessage(message: kafka:Message) {
        // Deserialize the request message
        typedesc<json> request = json:deserialize<DeliveryRequest>(message.value.toString());

        // Process the request and communicate with delivery services
        string deliveryService = request.type;
        http:Client client = new http:Client();
        http:Request httpRequest = client.newRequest("POST", "http://delivery-service-" + deliveryService + ":8080/schedule");
        httpRequest.setHeader("Content-Type", "application/json");
        httpRequest.setBody(json:serialize(request));

        http:Response response = httpRequest.send();
        if (response.statusCode == 200) {
            // Delivery scheduled successfully
            log:printInfo("Delivery scheduled for request: " + json:serialize(request));
            // Store delivery schedule in the database
            DeliverySchedule schedule = {
                requestId: request.id,
                deliveryService: deliveryService,
                pickupTime: response.body.pickupTime,
                deliveryTime: response.body.deliveryTime
            };
            db.delivery_schedules.insertOne(schedule);
        } else {
            log:printError("Error scheduling delivery: " + response.statusCode + " " + response.body.toString());
        }
    }
}

// Consumer configuration
kafka:ConsumerConfiguration consumerConfig = {
    bootstrapServers: ["localhost:9094"],
    groupId: "my-consumer-group",
    autoOffsetReset: "earliest"
};

// Create a consumer and subscribe to the topic
kafka:Consumer consumer = kafka:createConsumer(consumerConfig, "new-delivery-requests");
consumer.subscribe(function (message) {
    onMessage(message);
});