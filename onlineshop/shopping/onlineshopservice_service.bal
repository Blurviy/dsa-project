import ballerina/grpc;
import ballerina/uuid;

// Saya's code with modifications

listener grpc:Listener ep = new (9090);

// public type Product record {|
//     string name;
//     string description;
//     float price;
//     int stock_quantity;
//     string sku;
//     ProductStatus status;
// |}

public type Product record {|
    string name = "Unknown Product";
    string description = "No description available";
    float price = 0.0;
    int stock_quantity = 0;
    string sku = uuid:createType1AsString(); // Automatically generate a SKU
    ProductStatus status = PRODUCT_STATUS_UNSPECIFIED;
|};


public enum ProductStatus {
    PRODUCT_STATUS_UNSPECIFIED, 
    PRODUCT_STATUS_AVAILABLE, 
    PRODUCT_STATUS_OUT_OF_STOCK
}

// public type User record {|
//     string user_id;
//     string name;
//     UserType type;
// |};

public type User record {| 
    string user_id = uuid:createType1AsString(); // Automatically generate a user ID
    string name = "Unknown User";
    UserType type = USER_TYPE_UNSPECIFIED;
|};

public enum UserType {
    USER_TYPE_UNSPECIFIED, 
    USER_TYPE_CUSTOMER, 
    USER_TYPE_ADMIN
}

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
    Product[] products;
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
    CartItem[] items;
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
    CartItem[] items;
    float total_price;
|};

@grpc:Descriptor {value: PROTOBUFF_DESC}
service "onlineshopService" on ep {
    map<Product> products = {};
    map<User> users = {};
    map<CartItem[]> carts = {};

    isolated remote function AddProduct(Product value) returns ProductResponse|error {
        products[value.sku] = value;
        return {sku: value.sku, product: value};
    }

    isolated remote function UpdateProduct(UpdateProductRequest value) returns ProductResponse|error {
        Product? existingProduct = products[value.sku];
        if existingProduct is () {
            return error("Product not found");
        }
        products[value.sku] = value.product;
        return {sku: value.sku, product: value.product};
    }

    isolated remote function RemoveProduct(RemoveProductRequest value) returns ProductListResponse|error {
        _ = products.remove(value.sku);
        return {products: products.toArray()};
    }

    isolated remote function ListAvailableProducts(Empty value) returns ProductListResponse|error {
        Product[] availableProducts = from Product p in products.values()
                                      where p.status == PRODUCT_STATUS_AVAILABLE
                                      select p;
        return {products: availableProducts};
    }

    isolated remote function SearchProduct(SearchProductRequest value) returns ProductResponse|error {
        Product? product = products[value.sku];
        if product is () {
            return error("Product not found");
        }
        return {sku: value.sku, product: product};
    }

    isolated remote function AddToCart(AddToCartRequest value) returns CartResponse|error {
        User? user = users[value.user_id];
        if user is () {
            return error("User not found");
        }

        Product? product = products[value.sku];
        if product is () {
            return error("Product not found");
        }

        CartItem[] cart = carts[value.user_id] ?: [];
        cart.push({sku: value.sku, quantity: value.quantity});
        carts[value.user_id] = cart;

        return {items: cart};
    }

    isolated remote function PlaceOrder(PlaceOrderRequest value) returns OrderResponse|error {
        User? user = users[value.user_id];
        if user is () {
            return error("User not found");
        }

        CartItem[] cart = carts[value.user_id] ?: [];
        if cart.length() == 0 {
            return error("Cart is empty");
        }

        float totalPrice = 0;
        foreach var item in cart {
            Product? product = products[item.sku];
            if product is () {
                return error("Product not found in cart");
            }
            totalPrice += product.price * <float>item.quantity;
            product.stock_quantity -= item.quantity;
            if (product.stock_quantity <= 0) {
                product.status = PRODUCT_STATUS_OUT_OF_STOCK;
            }
            products[item.sku] = product;
        }

        string orderId = uuid:createType1AsString();
        carts.remove(value.user_id);

        return {
            order_id: orderId,
            items: cart,
            total_price: totalPrice
        };
    }

    isolated remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns UsersResponse|error {
        int count = 0;
        check clientStream.forEach(function(User user) {
            users[user.user_id] = user;
            count += 1;
        });
        return {created_count: count};
    }
}

