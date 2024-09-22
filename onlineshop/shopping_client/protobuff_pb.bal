import ballerina/grpc;
import ballerina/protobuf;

public const string PROTOBUFF_DESC = "0A0F70726F746F627566662E70726F746F120A6F6E6C696E6573686F7022070A05456D70747922C1010A0750726F6475637412120A046E616D6518012001280952046E616D6512200A0B6465736372697074696F6E180220012809520B6465736372697074696F6E12140A0570726963651803200128025205707269636512250A0E73746F636B5F7175616E74697479180420012805520D73746F636B5175616E7469747912100A03736B751805200128095203736B7512310A0673746174757318062001280E32192E6F6E6C696E6573686F702E50726F647563745374617475735206737461747573225D0A045573657212170A07757365725F6964180120012809520675736572496412120A046E616D6518022001280952046E616D6512280A047479706518032001280E32142E6F6E6C696E6573686F702E557365725479706552047479706522520A0F50726F64756374526573706F6E736512100A03736B751801200128095203736B75122D0A0770726F6475637418022001280B32132E6F6E6C696E6573686F702E50726F64756374520770726F6475637422340A0D5573657273526573706F6E736512230A0D637265617465645F636F756E74180120012805520C63726561746564436F756E7422570A1455706461746550726F647563745265717565737412100A03736B751801200128095203736B75122D0A0770726F6475637418022001280B32132E6F6E6C696E6573686F702E50726F64756374520770726F6475637422280A1452656D6F766550726F647563745265717565737412100A03736B751801200128095203736B7522460A1350726F647563744C697374526573706F6E7365122F0A0870726F647563747318012003280B32132E6F6E6C696E6573686F702E50726F64756374520870726F647563747322280A1453656172636850726F647563745265717565737412100A03736B751801200128095203736B7522590A10416464546F436172745265717565737412170A07757365725F6964180120012809520675736572496412100A03736B751802200128095203736B75121A0A087175616E7469747918032001280552087175616E74697479223A0A0C43617274526573706F6E7365122A0A056974656D7318012003280B32142E6F6E6C696E6573686F702E436172744974656D52056974656D7322380A08436172744974656D12100A03736B751801200128095203736B75121A0A087175616E7469747918022001280552087175616E74697479222C0A11506C6163654F726465725265717565737412170A07757365725F6964180120012809520675736572496422770A0D4F72646572526573706F6E736512190A086F726465725F696418012001280952076F726465724964122A0A056974656D7318022003280B32142E6F6E6C696E6573686F702E436172744974656D52056974656D73121F0A0B746F74616C5F7072696365180320012802520A746F74616C50726963652A6E0A0D50726F64756374537461747573121E0A1A50524F445543545F5354415455535F554E5350454349464945441000121C0A1850524F445543545F5354415455535F415641494C41424C451001121F0A1B50524F445543545F5354415455535F4F55545F4F465F53544F434B10022A520A08557365725479706512190A15555345525F545950455F554E535045434946494544100012160A12555345525F545950455F435553544F4D4552100112130A0F555345525F545950455F41444D494E100232DF040A116F6E6C696E6573686F7053657276696365123E0A0A41646450726F6475637412132E6F6E6C696E6573686F702E50726F647563741A1B2E6F6E6C696E6573686F702E50726F64756374526573706F6E7365123C0A0B437265617465557365727312102E6F6E6C696E6573686F702E557365721A192E6F6E6C696E6573686F702E5573657273526573706F6E73652801124E0A0D55706461746550726F6475637412202E6F6E6C696E6573686F702E55706461746550726F64756374526571756573741A1B2E6F6E6C696E6573686F702E50726F64756374526573706F6E736512520A0D52656D6F766550726F6475637412202E6F6E6C696E6573686F702E52656D6F766550726F64756374526571756573741A1F2E6F6E6C696E6573686F702E50726F647563744C697374526573706F6E7365124B0A154C697374417661696C61626C6550726F647563747312112E6F6E6C696E6573686F702E456D7074791A1F2E6F6E6C696E6573686F702E50726F647563744C697374526573706F6E7365124E0A0D53656172636850726F6475637412202E6F6E6C696E6573686F702E53656172636850726F64756374526571756573741A1B2E6F6E6C696E6573686F702E50726F64756374526573706F6E736512430A09416464546F43617274121C2E6F6E6C696E6573686F702E416464546F43617274526571756573741A182E6F6E6C696E6573686F702E43617274526573706F6E736512460A0A506C6163654F72646572121D2E6F6E6C696E6573686F702E506C6163654F72646572526571756573741A192E6F6E6C696E6573686F702E4F72646572526573706F6E7365620670726F746F33";

public isolated client class onlineshopServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, PROTOBUFF_DESC);
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
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/AddProduct", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/AddProduct", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/UpdateProduct", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductResponse>result, headers: respHeaders};
    }

    isolated remote function RemoveProduct(RemoveProductRequest|ContextRemoveProductRequest req) returns ProductListResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveProductRequest message;
        if req is ContextRemoveProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductListResponse>result;
    }

    isolated remote function RemoveProductContext(RemoveProductRequest|ContextRemoveProductRequest req) returns ContextProductListResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveProductRequest message;
        if req is ContextRemoveProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductListResponse>result, headers: respHeaders};
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
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/ListAvailableProducts", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductListResponse>result, headers: respHeaders};
    }

    isolated remote function SearchProduct(SearchProductRequest|ContextSearchProductRequest req) returns ProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchProductRequest message;
        if req is ContextSearchProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductResponse>result;
    }

    isolated remote function SearchProductContext(SearchProductRequest|ContextSearchProductRequest req) returns ContextProductResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchProductRequest message;
        if req is ContextSearchProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/SearchProduct", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/AddToCart", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CartResponse>result, headers: respHeaders};
    }

    isolated remote function PlaceOrder(PlaceOrderRequest|ContextPlaceOrderRequest req) returns OrderResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceOrderRequest message;
        if req is ContextPlaceOrderRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <OrderResponse>result;
    }

    isolated remote function PlaceOrderContext(PlaceOrderRequest|ContextPlaceOrderRequest req) returns ContextOrderResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceOrderRequest message;
        if req is ContextPlaceOrderRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshop.onlineshopService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <OrderResponse>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("onlineshop.onlineshopService/CreateUsers");
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

    isolated remote function receiveUsersResponse() returns UsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <UsersResponse>payload;
        }
    }

    isolated remote function receiveContextUsersResponse() returns ContextUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <UsersResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public type ContextUserStream record {|
    stream<User, error?> content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextUsersResponse record {|
    UsersResponse content;
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

public type ContextSearchProductRequest record {|
    SearchProductRequest content;
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

public type ContextPlaceOrderRequest record {|
    PlaceOrderRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveProductRequest record {|
    RemoveProductRequest content;
    map<string|string[]> headers;
|};

public type ContextProductResponse record {|
    ProductResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type User record {|
    string user_id = "";
    string name = "";
    UserType 'type = USER_TYPE_UNSPECIFIED;
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type UsersResponse record {|
    int created_count = 0;
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type Product record {|
    string name = "";
    string description = "";
    float price = 0.0;
    int stock_quantity = 0;
    string sku = "";
    ProductStatus status = PRODUCT_STATUS_UNSPECIFIED;
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type CartItem record {|
    string sku = "";
    int quantity = 0;
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type OrderResponse record {|
    string order_id = "";
    CartItem[] items = [];
    float total_price = 0.0;
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type UpdateProductRequest record {|
    string sku = "";
    Product product = {};
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type SearchProductRequest record {|
    string sku = "";
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type AddToCartRequest record {|
    string user_id = "";
    string sku = "";
    int quantity = 0;
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type CartResponse record {|
    CartItem[] items = [];
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type ProductListResponse record {|
    Product[] products = [];
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type Empty record {|
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type PlaceOrderRequest record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type RemoveProductRequest record {|
    string sku = "";
|};

@protobuf:Descriptor {value: PROTOBUFF_DESC}
public type ProductResponse record {|
    string sku = "";
    Product product = {};
|};

public enum ProductStatus {
    PRODUCT_STATUS_UNSPECIFIED, PRODUCT_STATUS_AVAILABLE, PRODUCT_STATUS_OUT_OF_STOCK
}

public enum UserType {
    USER_TYPE_UNSPECIFIED, USER_TYPE_CUSTOMER, USER_TYPE_ADMIN
}

