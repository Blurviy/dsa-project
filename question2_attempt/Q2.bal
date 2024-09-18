//shopping management system for admin and customer

import ballerina/http;

//product data
type product record {
    string name;
    string description;
    float price;
    int stock_quantity;
    string sku;
    string status; //in or out of stock
};

//user data 
type user record {
    string user_id;
    string user_type; //user type is admin or customer
};

//admin specific
type add_product_request record {
    product product;
};

type add_product_response record {
    string product_code; //SKU is product code
};

type update_product_request record {
    string sku;
    product product;
};

type remove_product_request record {
    string sku;
};

//customer specific
type list_available_products_request record {};

type list_available_products_response record {
    product[] products; //array
};

type search_product_request record {
    string sku;
};

type search_product_response record {
    product product;
    string message; //if swarch is success/failure + results
}; 

type add_to_cart_request record {
    string user_id;
    string sku;
};

type place_order_request record {
    string user_id;
};

//shopping service
service /shopping on new http:Listener(8080) {

    resource function post add_product(add_product_request req) returns add_product_response|error {
        return {product_code: req.product.sku};
    }

   resource function post create_users(user req) returns http:Response|error {
    http:Response response = new;
    response.statusCode = 201;
    response.setPayload("User created successfully with ID: " + req.user_id);
    return response;
}


    resource function put update_product(update_product_request req) returns error? {
        return; //only if error occurs
    }

    resource function delete remove_product(remove_product_request req) returns list_available_products_response|error {
        return {products: []};
    }

    resource function get list_available_products(list_available_products_request req) returns list_available_products_response|error {
        return {products: []};
    }

    resource function get search_product(search_product_request req) returns search_product_response|error {
        product found_product = { 
            name: "Sample Product", 
            description: "This is a sample product.", 
            price: 10.0, 
            stock_quantity: 100, 
            sku: req.sku, 
            status: "available" 
        };

        if (found_product.sku == req.sku) { 
            return {product: found_product, message: "Product found"};
        } else {
            product empty_product = {name: "", description: "", price: 0.0, stock_quantity: 0, sku: "", status: ""};
            return {product: empty_product, message: "Product not found"};
        }
    }

    resource function post add_to_cart(add_to_cart_request req) returns error? {
        return; // only if error occurs
    }

    resource function post place_order(place_order_request req) returns error? {
        return; //only if error occurs 
    }
}