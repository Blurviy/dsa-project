import ballerina/grpc;
import ballerina/uuid;
import ballerina/io;
import ballerina/protobuf.types.wrappers as wrappers; 

listener grpc:Listener ep = new (9090);

public type Empty record {||}; 

public type Product record {| 
    string name; 
    string description; 
    float price; 
    int stock_quantity; 
    string sku; 
    ProductStatus status; 
|};

public enum ProductStatus {
    PRODUCT_STATUS_UNSPECIFIED,
    PRODUCT_STATUS_AVAILABLE,
    PRODUCT_STATUS_OUT_OF_STOCK
}

public enum UserType {
    USER_TYPE_UNSPECIFIED,
    USER_TYPE_CUSTOMER,
    USER_TYPE_ADMIN
}

public type User record {| 
    string user_id; 
    string name; 
    UserType type; 
|};

public type ProductResponse record {| 
    string sku; 
    Product product; 
|};

public type UsersResponse record {| 
    int created_count; 
|};

public type UpdateProductRequest record {| 
    string sku; 
    Product product; 
|};

public type RemoveProductRequest record {| 
    string sku; 
|};

public type ProductListResponse record {| 
    map<Product> products; 
|};

public type SearchProductRequest record {| 
    string sku; 
|};

public type AddToCartRequest record {| 
    string user_id; 
    string sku; 
    int quantity; 
|};

public type CartResponse record {| 
    map<CartItem> items; 
|};

public type CartItem record {| 
    string sku; 
    int quantity; 
|};

public type PlaceOrderRequest record {| 
    string user_id; 
|};

public type OrderResponse record {| 
    string order_id; 
    map<CartItem> items; 
    float total_price; 
|};

const string PROTOBUFF_DESC = "DSAAssignmentNo2\\onlineshop\\protobuff.proto";

@grpc:Descriptor {value: PROTOBUFF_DESC}
service "ShoppingService" on ep {
    map<Product> products = {};
    map<User> users = {};
    map<map<CartItem>> carts = {};

    isolated remote function AddProduct(Product value) returns ProductResponse|error {
        self.products[value.sku] = value;
        return {sku: value.sku, product: value};
    }

    isolated remote function UpdateProduct(UpdateProductRequest value) returns ProductResponse|error {
        Product? existingProduct = self.products[value.sku];
        if existingProduct is () {
            return error("Product not found");
        }
        self.products[value.sku] = value.product;
        return {sku: value.sku, product: value.product};
    }

    isolated remote function RemoveProduct(RemoveProductRequest value) returns ProductListResponse|error {
        _ = self.products.remove(value.sku);
        return {products: self.products};
    }

    isolated remote function ListAvailableProducts(Empty value) returns ProductListResponse|error {
        map<Product> availableProducts = {};
        foreach var [sku, product] in self.products.entries() {
            if product.status == PRODUCT_STATUS_AVAILABLE {
                availableProducts[sku] = product;
            }
        }
        return {products: availableProducts};
    }

    isolated remote function SearchProduct(SearchProductRequest value) returns ProductResponse|error {
        Product? product = self.products[value.sku];
        if product is () {
            return error("Product not found");
        }
        return {sku: value.sku, product: product};
    }

    isolated remote function AddToCart(AddToCartRequest value) returns CartResponse|error {
        User? user = self.users[value.user_id];
        if user is () {
            return error("User not found");
        }

        Product? product = self.products[value.sku];
        if product is () {
            return error("Product not found");
        }

        map<CartItem> cart = self.carts[value.user_id] ?: {};
        cart[value.sku] = {sku: value.sku, quantity: value.quantity};
        self.carts[value.user_id] = cart;

        return {items: cart};
    }

    isolated remote function PlaceOrder(PlaceOrderRequest value) returns OrderResponse|error {
        User? user = self.users[value.user_id];
        if user is () {
            return error("User not found");
        }

        map<CartItem> cart = self.carts[value.user_id] ?: {};
        if cart.length() == 0 {
            return error("Cart is empty");
        }

        float totalPrice = 0;
        map<CartItem> orderItems = {};
        foreach var [sku, item] in cart.entries() {
            Product? product = self.products[sku];
            if product is () {
                return error("Product not found in cart");
            }
            totalPrice += product.price * <float>item.quantity;
            product.stock_quantity -= item.quantity;
            if (product.stock_quantity <= 0) {
                product.status = PRODUCT_STATUS_OUT_OF_STOCK;
            }
            self.products[product.sku] = product;
            orderItems[sku] = item;
        }

        string orderId = uuid:createType1AsString();
        _ = self.carts.remove(value.user_id);

        return {
            order_id: orderId,
            items: cart,
            total_price: totalPrice
        };
    }

    isolated remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns UsersResponse|error {
        int count = 0;
        check clientStream.forEach(function(User user) {
            self.users[user.user_id] = user;
            count += 1;
        });
        return {created_count: count};
    }
}
