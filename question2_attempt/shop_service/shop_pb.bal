import ballerina/grpc;
import ballerina/protobuf;

public const string SHOP_DESC = "0A0A73686F702E70726F746F120473686F7022AC010A0750726F6475637412120A046E616D6518012001280952046E616D6512200A0B6465736372697074696F6E180220012809520B6465736372697074696F6E12140A0570726963651803200128015205707269636512250A0E73746F636B5F7175616E74697479180420012805520D73746F636B5175616E7469747912100A03736B751805200128095203736B75121C0A09617661696C61626C651806200128085209617661696C61626C6522510A1455706461746550726F647563745265717565737412100A03736B751801200128095203736B7512270A0770726F6475637418022001280B320D2E73686F702E50726F64756374520770726F64756374221E0A0A50726F64756374534B5512100A03736B751801200128095203736B7522540A0F50726F64756374526573706F6E736512180A076D65737361676518012001280952076D65737361676512270A0770726F6475637418022001280B320D2E73686F702E50726F64756374520770726F6475637422400A1350726F647563744C697374526573706F6E736512290A0870726F647563747318012003280B320D2E73686F702E50726F64756374520870726F6475637473224E0A045573657212170A07757365725F6964180120012809520675736572496412120A046E616D6518022001280952046E616D6512190A0869735F61646D696E1803200128085207697341646D696E222F0A134372656174655573657273526573706F6E736512180A076D65737361676518012001280952076D657373616765223D0A10416464546F436172745265717565737412170A07757365725F6964180120012809520675736572496412100A03736B751802200128095203736B7522560A0C43617274526573706F6E736512180A076D65737361676518012001280952076D657373616765122C0A0A636172745F6974656D7318022003280B320D2E73686F702E50726F647563745209636172744974656D7322210A0655736572494412170A07757365725F69641801200128095206757365724964227E0A054F7264657212190A086F726465725F696418012001280952076F72646572496412170A07757365725F6964180220012809520675736572496412290A0870726F647563747318032003280B320D2E73686F702E50726F64756374520870726F647563747312160A067374617475731804200128095206737461747573224C0A0D4F72646572526573706F6E736512180A076D65737361676518012001280952076D65737361676512210A056F7264657218022001280B320B2E73686F702E4F7264657252056F7264657222380A114F726465724C697374526573706F6E736512230A066F726465727318012003280B320B2E73686F702E4F7264657252066F726465727322070A05456D7074793294040A0B53686F705365727669636512320A0A41646450726F64756374120D2E73686F702E50726F647563741A152E73686F702E50726F64756374526573706F6E736512420A0D55706461746550726F64756374121A2E73686F702E55706461746550726F64756374526571756573741A152E73686F702E50726F64756374526573706F6E7365123C0A0D52656D6F766550726F6475637412102E73686F702E50726F64756374534B551A192E73686F702E50726F647563744C697374526573706F6E736512360A0B4372656174655573657273120A2E73686F702E557365721A192E73686F702E4372656174655573657273526573706F6E7365280112320A0A4C6973744F7264657273120B2E73686F702E456D7074791A172E73686F702E4F726465724C697374526573706F6E7365123F0A154C697374417661696C61626C6550726F6475637473120B2E73686F702E456D7074791A192E73686F702E50726F647563744C697374526573706F6E736512380A0D53656172636850726F6475637412102E73686F702E50726F64756374534B551A152E73686F702E50726F64756374526573706F6E736512370A09416464546F4361727412162E73686F702E416464546F43617274526571756573741A122E73686F702E43617274526573706F6E7365122F0A0A506C6163654F72646572120C2E73686F702E5573657249441A132E73686F702E4F72646572526573706F6E7365620670726F746F33";

public isolated client class ShopServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SHOP_DESC);
    }

    isolated remote function AddProduct(Product|ContextProduct req) returns ProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        Product message; 
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductResponse>result;
    }

    isolated remote function AddProductContext(Product|ContextProduct req) returns ContextProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductResponse>result, headers: respHeaders};
    }

    isolated remote function UpdateProduct(UpdateProductRequest|ContextUpdateProductRequest req) returns ProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateProductRequest message;
        if req is ContextUpdateProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductResponse>result;
    }

    isolated remote function UpdateProductContext(UpdateProductRequest|ContextUpdateProductRequest req) returns ContextProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateProductRequest message;
        if req is ContextUpdateProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductResponse>result, headers: respHeaders};
    }

    isolated remote function RemoveProduct(ProductSKU|ContextProductSKU req) returns ProductListResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductSKU message;
        if req is ContextProductSKU {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductListResponse>result;
    }

    isolated remote function RemoveProductContext(ProductSKU|ContextProductSKU req) returns ContextProductListResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductSKU message;
        if req is ContextProductSKU {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductListResponse>result, headers: respHeaders};
    }

    isolated remote function ListOrders(Empty|ContextEmpty req) returns OrderListResponse|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/ListOrders", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <OrderListResponse>result;
    }

    isolated remote function ListOrdersContext(Empty|ContextEmpty req) returns ContextOrderListResponse|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/ListOrders", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <OrderListResponse>result, headers: respHeaders};
    }

    isolated remote function ListAvailableProducts(Empty|ContextEmpty req) returns ProductListResponse|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductListResponse>result;
    }

    isolated remote function ListAvailableProductsContext(Empty|ContextEmpty req) returns ContextProductListResponse|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductListResponse>result, headers: respHeaders};
    }

    isolated remote function SearchProduct(ProductSKU|ContextProductSKU req) returns ProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductSKU message;
        if req is ContextProductSKU {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductResponse>result;
    }

    isolated remote function SearchProductContext(ProductSKU|ContextProductSKU req) returns ContextProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        ProductSKU message;
        if req is ContextProductSKU {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductResponse>result, headers: respHeaders};
    }

    isolated remote function AddToCart(AddToCartRequest|ContextAddToCartRequest req) returns CartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CartResponse>result;
    }

    isolated remote function AddToCartContext(AddToCartRequest|ContextAddToCartRequest req) returns ContextCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CartResponse>result, headers: respHeaders};
    }

    isolated remote function PlaceOrder(UserID|ContextUserID req) returns OrderResponse|grpc:Error {
        map<string|string[]> headers = {};
        UserID message;
        if req is ContextUserID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <OrderResponse>result;
    }

    isolated remote function PlaceOrderContext(UserID|ContextUserID req) returns ContextOrderResponse|grpc:Error {
        map<string|string[]> headers = {};
        UserID message;
        if req is ContextUserID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shop.ShopService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <OrderResponse>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("shop.ShopService/CreateUsers");
        return new CreateUsersStreamingClient(sClient);
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUser(User message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUser(ContextUser message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveCreateUsersResponse() returns CreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <CreateUsersResponse>payload;
        }
    }

    isolated remote function receiveContextCreateUsersResponse() returns ContextCreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <CreateUsersResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class ShopServiceProductResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductResponse(ProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductResponse(ContextProductResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShopServiceOrderListResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendOrderListResponse(OrderListResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextOrderListResponse(ContextOrderListResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShopServiceCreateUsersResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCreateUsersResponse(CreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCreateUsersResponse(ContextCreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShopServiceOrderResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendOrderResponse(OrderResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextOrderResponse(ContextOrderResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShopServiceProductListResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductListResponse(ProductListResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductListResponse(ContextProductListResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShopServiceCartResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCartResponse(CartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCartResponse(ContextCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextUserStream record {|
    stream<User, error?> content;
    map<string|string[]> headers;
|};

public type ContextProductSKU record {|
    ProductSKU content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextOrderListResponse record {|
    OrderListResponse content;
    map<string|string[]> headers;
|};

public type ContextProduct record {|
    Product content;
    map<string|string[]> headers;
|};

public type ContextOrderResponse record {|
    OrderResponse content;
    map<string|string[]> headers;
|};

public type ContextUpdateProductRequest record {|
    UpdateProductRequest content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextCartResponse record {|
    CartResponse content;
    map<string|string[]> headers;
|};

public type ContextProductListResponse record {|
    ProductListResponse content;
    map<string|string[]> headers;
|};

public type ContextEmpty record {|
    Empty content;
    map<string|string[]> headers;
|};

public type ContextUserID record {|
    UserID content;
    map<string|string[]> headers;
|};

public type ContextProductResponse record {|
    ProductResponse content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersResponse record {|
    CreateUsersResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type ProductSKU record {|
    string sku = "";
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type Order record {|
    string order_id = "";
    string user_id = "";
    Product[] products = [];
    string status = "";
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type User record {|
    string user_id = "";
    string name = "";
    boolean is_admin = false;
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type OrderListResponse record {|
    Order[] orders = [];
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type Product record {|
    string name = "";
    string description = "";
    float price = 0.0;
    int stock_quantity = 0;
    string sku = "";
    boolean available = false;
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type OrderResponse record {|
    string message = "";
    Order 'order = {};
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type UpdateProductRequest record {|
    string sku = "";
    Product product = {};
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type AddToCartRequest record {|
    string user_id = "";
    string sku = "";
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type CartResponse record {|
    string message = "";
    Product[] cart_items = [];
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type ProductListResponse record {|
    Product[] products = [];
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type Empty record {|
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type UserID record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type ProductResponse record {|
    string message = "";
    Product product = {};
|};

@protobuf:Descriptor {value: SHOP_DESC}
public type CreateUsersResponse record {|
    string message = "";
|};

