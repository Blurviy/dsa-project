
# Distributed Systems and Applications (DSA612S) - Assignment 1

This project involves the development of two distributed systems using the Ballerina Language. The first part requires building a RESTful API to manage the Programme Development Unit at the Namibia University of Science and Technology (NUST). The second part involves designing an online shopping system using gRPC to handle remote invocations for customers and admins.
## Project Structure

This repository contains two main components:

- #### 1. RESTful API for Programme Management

- #### 2. gRPC-based Online Shopping System
## Part 1: RESTful API for Programme Management

#### Overview

This API manages the Programme Development workflow at the Programme Development Unit, NUST. It includes functionalities such as adding, updating, retrieving, and deleting programmes, as well as identifying programmes due for review.


## Functionalities

- **Add a new programme:** Creates a new programme record.
- **Retrieve all programmes:** Lists all programmes in the unit.
- **Update programme:** Updates an existing programme's details using its programme code.
- **Retrieve programme details:** Fetches details of a specific programme using its code.
- **Delete a programme:** Removes a programme using its code.
## Technologies Used

- [**Ballerina Language:**](https://ballerina.io/learn/write-a-restful-api-with-ballerina/) For building the RESTful API service.

- [**HTTP Methods:**](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/HTTP-methods) `GET`, `POST`, `PUT`, `DELETE` for respective CRUD operations.
## Instructions for Running the API

1. Clone the repository to your local machine.

2. Navigate to the `final\DSAQuestion1\DSA_Assignment` directory.

3. Follow the Ballerina setup guide to install the Ballerina language.

4. Run the following command to start the server:
```bash
bal run
```
## Part 2: gRPC-Based Online Shopping System

### Overview

The online shopping system handles remote invocation for two types of users: customers and admins. Customers can view, search, and add products to a cart, while admins can manage product inventory and list all customer orders.
## Functionalities

- Admin Operations:
    - Add new product.
    - Update product details.
    - Remove product from inventory.
    - List all orders.
- Customer Operations:
    - View available products.
    - Search for a product by SKU.
    - Add products to a cart.
    - Place an order
## Technology Used

- [Ballerina Language:](https://ballerina.io/learn/write-a-grpc-service-with-ballerina/) For building the gRPC server and client.

- [gRPC Protocol Buffers:](https://grpc.io/docs/what-is-grpc/introduction/) For defining the remote procedure calls (RPCs).
## Instructions for Running the gRPC System

1. Clone the repository to your local machine.

2. Navigate to the grpc-shopping/ directory.

3. Compile and run the gRPC server using the following command:
```bash
bal grpc --input protobuff.proto --output .
```
```bash
bal run
```

4. Change the directory and run gRPC client can be run using:
```bash
cd client/
```
```bash
bal run
```
## Authors

- [@Blurviy](https://github.com/Blurviy)
- [@MayaTheBeholder](https://github.com/MayaTheBeholder)
- [@EclipseRav](https://github.com/EclipseRav)
- [@libang01](https://github.com/libang01)
- [@Saya2003](https://github.com/Saya2003)
## Technologies Used

- [**Ballerina Language:**](https://ballerina.io/learn/write-a-restful-api-with-ballerina/) For building the RESTful API service.

- [**HTTP Methods:**](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/HTTP-methods) `GET`, `POST`, `PUT`, `DELETE` for respective CRUD operations.
## Technologies Used

- [**Ballerina Language:**](https://ballerina.io/learn/write-a-restful-api-with-ballerina/) For building the RESTful API service.

- [**HTTP Methods:**](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/HTTP-methods) `GET`, `POST`, `PUT`, `DELETE` for respective CRUD operations.