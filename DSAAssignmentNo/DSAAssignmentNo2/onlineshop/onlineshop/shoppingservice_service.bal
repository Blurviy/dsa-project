import ballerina/grpc;
import ballerina/uuid;
//import protobuff_pb.bal; // Import the correct type for Empty

import ballerina/io;
import ballerina/protobuf.types.wrappers as wrappers; // Import the correct type for Empty

listener grpc:Listener ep = new (9090);

// Product type with corrected field names and types
public type Product record {|
    string name;
    string description;
    float price;
    int stockQuantity;
    string sku;
    ProductStatus status;
|};

// ProductStatus enum with corrected field names
public type ProductStatus readonly & string;

const ProductStatus PRODUCT_STATUS_UNSPECIFIED = "PRODUCT_STATUS_UNSPECIFIED";
const ProductStatus PRODUCT_STATUS_AVAILABLE = "PRODUCT_STATUS_AVAILABLE";
const ProductStatus PRODUCT_STATUS_OUT_OF_STOCK = "PRODUCT_STATUS_OUT_OF_STOCK";

public type User record {|
    string userId;
    string name;
    UserType type;
|};

public type UserType readonly & string;

const UserType USER_TYPE_UNSPECIFIED = "USER_TYPE_UNSPECIFIED";
const UserType USER_TYPE_CUSTOMER = "USER_TYPE_CUSTOMER";
const UserType USER_TYPE_ADMIN = "USER_TYPE_ADMIN";

public type ProductResponse record {|
    string sku;
    Product product;
|};

public type UsersResponse record {|
    int createdCount;
|};

public type UpdateProductRequest record {|
    string sku;
    Product product;
|};

public type RemoveProductRequest record {|
    string sku;
|};

public type ProductListResponse record {|
    Product[] products = [];
|};

public type SearchProductRequest record {|
    string sku;
|};

public type AddToCartRequest record {|
    string userId;
    string sku;
    int quantity;
|};

public type CartResponse record {|
    CartItem[] items = [];
|};

public type CartItem record {|
    string sku;
    int quantity;
|};

public type PlaceOrderRequest record {|
    string userId;
|};

public type OrderResponse record {|
    string orderId;
    CartItem[] items = [];
    float totalPrice;
|};

const string PROTOBUFF_DESC = "DSAAssignmentNo2\\onlineshop\\protobuff.proto";

@grpc:Descriptor {value: PROTOBUFF_DESC}
service "ShoppingService" on ep {
    map<Product> products = {};
    map<User> users = {};
    map<CartItem[]> carts = {};

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
        return {products: self.products.toArray()};
    }
    isolated remote function ListAvailableProducts(wrappers:Empty value) returns ProductListResponse|error {
        Product[] availableProducts = from var [_, p] in self.products.entries()
                                         where p.status == PRODUCT_STATUS_AVAILABLE
                                         select p;
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
        User? user = self.users[value.userId];
        if user is () {
            return error("User not found");
        }

        Product? product = self.products[value.sku];
        if product is () {
            return error("Product not found");
        }

        CartItem[] cart = self.carts[value.userId] ?: [];
        cart.push({sku: value.sku, quantity: value.quantity});
        self.carts[value.userId] = cart;

        return {items: cart};
    }

    isolated remote function PlaceOrder(PlaceOrderRequest value) returns OrderResponse|error {
        User? user = self.users[value.userId];
        if user is () {
            return error("User not found");
        }

        CartItem[] cart = self.carts[value.userId] ?: [];
        if cart.length() == 0 {
            return error("Cart is empty");
        }

        float totalPrice = 0;
        foreach var item in cart {
            Product? product = self.products[item.sku];
            if product is () {
                return error("Product not found in cart");
            }
            totalPrice += product.price * <float>item.quantity;
            product.stockQuantity -= item.quantity;
            if (product.stockQuantity <= 0) {
                product.status = PRODUCT_STATUS_OUT_OF_STOCK;
            }
            self.products[product.sku] = product;
        }

        string orderId = self.generateOrderId();
        self.carts.remove(request.userId);

        return {
            orderId: orderId,
            items: cart,
            totalPrice: totalPrice
        };
    }

    isolated remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns UsersResponse|error {
        int count = 0;
        check clientStream.forEach(function(User user) {
            self.users[user.userId] = user;
            count += 1;
        });
        return {createdCount: count};
    }
}