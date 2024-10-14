CREATE DATABASE logistics_db;

USE logistics_db;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    contact_number VARCHAR(20)
);

CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    customer_id INT,
    type VARCHAR(20),
    pickup_location VARCHAR(100),
    delivery_location VARCHAR(100),
    preferred_time_slots VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE delivery_schedules (
    schedule_id INT PRIMARY KEY,
    shipment_id INT,
    pickup_time DATETIME,
    delivery_time DATETIME,
    FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id)
);