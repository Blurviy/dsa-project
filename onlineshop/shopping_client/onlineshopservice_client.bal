import ballerina/io;

onlineshopServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    Product addProductRequest = {name: "ballerina", description: "ballerina", price: 1, stock_quantity: 1, sku: "ballerina", status: "PRODUCT_STATUS_UNSPECIFIED"};
    ProductResponse addProductResponse = check ep->AddProduct(addProductRequest);
    io:println(addProductResponse);

    UpdateProductRequest updateProductRequest = {sku: "ballerina", product: {name: "ballerina", description: "ballerina", price: 1, stock_quantity: 1, sku: "ballerina", status: "PRODUCT_STATUS_UNSPECIFIED"}};
    ProductResponse updateProductResponse = check ep->UpdateProduct(updateProductRequest);
    io:println(updateProductResponse);

    RemoveProductRequest removeProductRequest = {sku: "ballerina"};
    ProductListResponse removeProductResponse = check ep->RemoveProduct(removeProductRequest);
    io:println(removeProductResponse);

    Empty listAvailableProductsRequest = {};
    ProductListResponse listAvailableProductsResponse = check ep->ListAvailableProducts(listAvailableProductsRequest);
    io:println(listAvailableProductsResponse);

    SearchProductRequest searchProductRequest = {sku: "ballerina"};
    ProductResponse searchProductResponse = check ep->SearchProduct(searchProductRequest);
    io:println(searchProductResponse);

    AddToCartRequest addToCartRequest = {user_id: "ballerina", sku: "ballerina", quantity: 1};
    CartResponse addToCartResponse = check ep->AddToCart(addToCartRequest);
    io:println(addToCartResponse);

    PlaceOrderRequest placeOrderRequest = {user_id: "ballerina"};
    OrderResponse placeOrderResponse = check ep->PlaceOrder(placeOrderRequest);
    io:println(placeOrderResponse);

    User createUsersRequest = {user_id: "ballerina", name: "ballerina", 'type: "USER_TYPE_UNSPECIFIED"};
    CreateUsersStreamingClient createUsersStreamingClient = check ep->CreateUsers();
    check createUsersStreamingClient->sendUser(createUsersRequest);
    check createUsersStreamingClient->complete();
    UsersResponse? createUsersResponse = check createUsersStreamingClient->receiveUsersResponse();
    io:println(createUsersResponse);
}

