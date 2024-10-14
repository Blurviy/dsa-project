import ballerina/http;
import ballerina/log;

service internationalDeliveryService {
    resource function scheduleDelivery(request: DeliveryRequest) returns http:Response {
        // Implement international delivery scheduling logic
        // ...

        // Return the scheduled pickup and delivery times
        http:Response response = new http:Response();
        response.statusCode = 200;
        response.setBody({
            pickupTime: "2023-10-13T14:00:00Z",
            deliveryTime: "2023-10-20T16:00:00Z"
        });
        return response;
    }
}