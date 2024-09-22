import ballerina/io;
import ballerina/grpc;

type Product record {
    string name;
    string description;
    float price;
    int stockQuantity;
    string sku;
    boolean available;
};

type Order record {
    string orderId;
    string productId;
    int quantity;
    float price;
    string status;
};

type Cart record {
    string cartId;
    string userId;
    Product[] products;
};


service class ShopService {
   
    resource function AddProduct(Product product) returns ProductResponse {
        self.products[product.sku] = product;
        return {message: "Product added successfully", product: product};
    }

    resource function UpdateProduct(UpdateProductRequest req) returns ProductResponse {
        if self.products.hasKey(req.sku) {
            self.products[req.sku] = req.product;
            return {message: "Product updated successfully", product: req.product};
        }
        return {message: "Product not found"};
    } 

    resource function RemoveProduct(ProductSKU sku) returns ProductListResponse {
        self.products.remove(sku.sku);
        return {products: self.getAvailableProducts()};
    }

    resource function ListAvailableProducts(Empty empty) returns ProductListResponse {
        return {products: self.getAvailableProducts()};
    }

    resource function SearchProduct(ProductSKU sku) returns ProductResponse {
        Product? product = {
    name: "ballerina",
    description: "ballerina",
    price: 1.0,
    stockQuantity: 1,
    sku: "ballerina",
    available: true
};

        if product is Product {
            return {message: "Product found", product: product};
        }
        return {message: "Product not found"};
    }

    resource function AddToCart(AddToCartRequest req) returns CartResponse {
        if !self.products.hasKey(req.sku) {
            return {message: "Product not found"};
        }

        Product product = self.products[req.sku];
        carts[req.user_id].push(product);

        return {message: "Product added to cart", cart_items: carts[req.user_id]};
    }

    resource function PlaceOrder(UserID id) returns OrderResponse {
        if carts.hasKey(id.user_id) {
            string orderId = "ORD" + id.user_id + time:currentTime().toString();
            Order order = {
                order_id: orderId,
                user_id: id.user_id,
                products: carts[id.user_id],
                status: "Pending"
            };

            orders[orderId] = order;
            carts.remove(id.user_id);

            return {message: "Order placed successfully", order: order};
        }
        return {message: "No items in cart"};
    }

    private function getAvailableProducts() returns Product[] {
        return self.products.values().filter(function (Product product) returns boolean {
            return product.available;
        });
    }
}

service /shop on new grpc:Listener(9090) {
    isolated resource function 'AddProduct(Product product) returns ProductResponse;
    isolated resource function 'UpdateProduct(UpdateProductRequest req) returns ProductResponse;
    isolated resource function 'RemoveProduct(ProductSKU sku) returns ProductListResponse;
    isolated resource function 'ListAvailableProducts(Empty empty) returns ProductListResponse;
    isolated resource function 'SearchProduct(ProductSKU sku) returns ProductResponse;
    isolated resource function 'AddToCart(AddToCartRequest req) returns CartResponse;
    isolated resource function 'PlaceOrder(UserID id) returns OrderResponse;
}
