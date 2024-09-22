import ballerina/io;

ShopServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {  
    Product addProductRequest = {name: "ballerina", description: "ballerina", price: 1, stock_quantity: 1, sku: "ballerina", available: true};
    ProductResponse addProductResponse = check ep->AddProduct(addProductRequest);
    io:println(addProductResponse);

    UpdateProductRequest updateProductRequest = {sku: "ballerina", product: {name: "ballerina", description: "ballerina", price: 1, stock_quantity: 1, sku: "ballerina", available: true}};
    ProductResponse updateProductResponse = check ep->UpdateProduct(updateProductRequest);
    io:println(updateProductResponse);

    ProductSKU removeProductRequest = {sku: "ballerina"};
    ProductListResponse removeProductResponse = check ep->RemoveProduct(removeProductRequest);
    io:println(removeProductResponse);

    Empty listOrdersRequest = {};
    OrderListResponse listOrdersResponse = check ep->ListOrders(listOrdersRequest);
    io:println(listOrdersResponse);

    Empty listAvailableProductsRequest = {};
    ProductListResponse listAvailableProductsResponse = check ep->ListAvailableProducts(listAvailableProductsRequest);
    io:println(listAvailableProductsResponse);

    ProductSKU searchProductRequest = {sku: "ballerina"};
    ProductResponse searchProductResponse = check ep->SearchProduct(searchProductRequest);
    io:println(searchProductResponse);

    AddToCartRequest addToCartRequest = {user_id: "ballerina", sku: "ballerina"};
    CartResponse addToCartResponse = check ep->AddToCart(addToCartRequest);
    io:println(addToCartResponse);

    UserID placeOrderRequest = {user_id: "ballerina"};
    OrderResponse placeOrderResponse = check ep->PlaceOrder(placeOrderRequest);
    io:println(placeOrderResponse);

    User createUsersRequest = {user_id: "ballerina", name: "ballerina", is_admin: true};
    CreateUsersStreamingClient createUsersStreamingClient = check ep->CreateUsers();
    check createUsersStreamingClient->sendUser(createUsersRequest);
    check createUsersStreamingClient->complete();
    CreateUsersResponse? createUsersResponse = check createUsersStreamingClient->receiveCreateUsersResponse();
    io:println(createUsersResponse);
}

