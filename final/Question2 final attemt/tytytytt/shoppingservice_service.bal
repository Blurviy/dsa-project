import ballerina/grpc;
import ballerina/uuid;

listener grpc:Listener ep = new (9090);

public type Product record {|
    string name;
    string description;
    float price;
    int32 stock_quantity;
    string sku;
    ProductStatus status;
|}

public type ProductStatus record {|
    PRODUCT_STATUS_UNSPECIFIED;
    PRODUCT_STATUS_AVAILABLE;
    PRODUCT_STATUS_OUT_OF_STOCK;
|}

public type User record {|
    string user_id;
    string name;
    UserType type;
|}

public type UserType record {|
    USER_TYPE_UNSPECIFIED;
    USER_TYPE_CUSTOMER;
    USER_TYPE_ADMIN;
|}

public type ProductResponse record {|
    string sku;
    Product product;
|}

public type UsersResponse record {|
    int32 created_count;
|}

public type UpdateProductRequest record {|
    string sku;
    Product product;
|}

public type RemoveProductRequest record {|
    string sku;
|}

public type ProductListResponse record {|
    repeated Product products;
|}

public type SearchProductRequest {|
    string sku;
|}

public type AddToCartRequest record {|
    string user_id;
    string sku;
    int32 quantity;
|}

public type CartResponse record {|
    repeated CartItem items;
|}

public type CartItem record {|
    string sku;
    int32 quantity;
|}

public type PlaceOrderRequest record {|
    string user_id;
|}

public type OrderResponse record {|
    string order_id;
    repeated CartItem items;
    float total_price;
|}

@grpc:Descriptor {value: PROTOBUFF_DESC}
service "ShoppingService" on ep {

   isolated remote function AddProduct(Product value) returns ProductResponse|error {
    self.products.add(product);
        return {sku: product.sku, product: product};
    }

   isolated remote function UpdateProduct(UpdateProductRequest value) returns ProductResponse|error {
    Product? existingProduct = self.products[request.sku];
        if existingProduct is () {
            return error("Product not found");
            }
        self.products.put(request.product);
        return {sku: request.sku, product: request.product};
    }

   isolated remote function RemoveProduct(RemoveProductRequest value) returns ProductListResponse|error {
    _ = self.products.remove(request.sku);
        return {products: self.products.toArray()};
    }

   isolated remote function ListAvailableProducts(Empty value) returns ProductListResponse|error {
     Product[] availableProducts = from Product p in self.products
                                      where p.status == PRODUCT_STATUS_AVAILABLE
                                      select p;
        return {products: availableProducts};
    }

   isolated remote function SearchProduct(SearchProductRequest value) returns ProductResponse|error {
    Product? product = self.products[request.sku];
        if product is () {
            return error("Product not found");
        }
        return {sku: request.sku, product: product};
    }

   isolated remote function AddToCart(AddToCartRequest value) returns CartResponse|error {
     User? user = self.users[request.user_id];
        if user is () {
            return error("User not found");
            }

        Product? product = self.products[request.sku];
        if product is () {
            return error("Product not found");
        }

        CartItem[] cart = self.carts[request.user_id] ?: [];
        cart.push({sku: request.sku, quantity: request.quantity});
        self.carts.put([request.user_id, cart]);

        return {items: cart};
    }

   isolated remote function PlaceOrder(PlaceOrderRequest value) returns OrderResponse|error {
    User? user = self.users[request.user_id];
        if user is () {
            return error("User not found");
        }

        CartItem[] cart = self.carts[request.user_id] ?: [];
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
            product.stock_quantity -= item.quantity;
            if (product.stock_quantity <= 0) {
                product.status = PRODUCT_STATUS_OUT_OF_STOCK;
            }
            self.products.put(product);
        }

        string orderId = self.generateOrderId();
        self.carts.remove(request.user_id);

        return {
            order_id: orderId,
            items: cart,
            total_price: totalPrice
        };
    }

   isolated remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns UsersResponse|error {
    int count = 0;
        check clientStream.forEach(function(User user) {
            self.users.add(user);
            count += 1;
        });
        return {created_count: count};
    }
}

