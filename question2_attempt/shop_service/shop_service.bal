import ballerina/io;
import ballerina/grpc;
import ballerina/time;

type Product record {
    string sku;
    string name;
    boolean available;
};

type Order record {
    string order_id;
    string user_id;
    Product[] products;
    string status;
};

type ProductResponse record {
    string message;
    Product? product = ();
};

type ProductListResponse record {
    Product[] products;
};

type ProductSKU record {
    string sku;
};

type UpdateProductRequest record {
    string sku;
    Product product;
};

type AddToCartRequest record {
    string user_id;
    string sku;
};

type CartResponse record {
    string message;
    Product[] cart_items;
};

type OrderResponse record {
    string message;
    Order? order = ();
};

type UserID record {
    string user_id;
};

type Empty record {};

service class ShopService {
    private map<string, Product> products = {};
    private map<string, Order> orders = {};
    private map<string, Product[]> carts = {};

    resource function post AddProduct(Product product) returns ProductResponse {
        self.products[product.sku] = product;
        return {message: "Product added successfully", product: product};
    }

    resource function put UpdateProduct(UpdateProductRequest req) returns ProductResponse {
        if self.products.hasKey(req.sku) {
            self.products[req.sku] = req.product;
            return {message: "Product updated successfully", product: req.product};
        }
        return {message: "Product not found"};
    } 

    resource function delete RemoveProduct(ProductSKU sku) returns ProductListResponse {
        self.products.remove(sku.sku);
        return {products: self.getAvailableProducts()};
    }

    resource function get ListAvailableProducts(Empty empty) returns ProductListResponse {
        return {products: self.getAvailableProducts()};
    }

    resource function get SearchProduct(ProductSKU sku) returns ProductResponse {
        Product? product = self.products[sku.sku];
        if product is Product {
            return {message: "Product found", product: product};
        }
        return {message: "Product not found"};
    }

    resource function post AddToCart(AddToCartRequest req) returns CartResponse {
        if !self.products.hasKey(req.sku) {
            return {message: "Product not found"};
        }

        Product product = self.products[req.sku];
        if !self.carts.hasKey(req.user_id) {
            self.carts[req.user_id] = [];
        }
        self.carts[req.user_id].push(product);

        return {message: "Product added to cart", cart_items: self.carts[req.user_id]};
    }

    resource function post PlaceOrder(UserID id) returns OrderResponse {
        if self.carts.hasKey(id.user_id) {
            string orderId = "ORD" + id.user_id + time:currentTime().toString();
            Order order = {
                order_id: orderId,
                user_id: id.user_id,
                products: self.carts[id.user_id],
                status: "Pending"
            };

            self.orders[orderId] = order;
            self.carts.remove(id.user_id);

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
    resource function post AddProduct(Product product) returns ProductResponse {
        return self.AddProduct(product);
    }
    resource function put UpdateProduct(UpdateProductRequest req) returns ProductResponse {
        return self.UpdateProduct(req);
    }
    resource function delete RemoveProduct(ProductSKU sku) returns ProductListResponse {
        return self.RemoveProduct(sku);
    }
    resource function get ListAvailableProducts(Empty empty) returns ProductListResponse {
        return self.ListAvailableProducts(empty);
    }
    resource function get SearchProduct(ProductSKU sku) returns ProductResponse {
        return self.SearchProduct(sku);
    }
    resource function post AddToCart(AddToCartRequest req) returns CartResponse {
        return self.AddToCart(req);
    }
    resource function post PlaceOrder(UserID id) returns OrderResponse {
        return self.PlaceOrder(id);
    }
}
