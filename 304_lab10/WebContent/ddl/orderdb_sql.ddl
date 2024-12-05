CREATE DATABASE orders;
go;

USE orders;
go;

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO category(categoryName) VALUES ('Sunglasses');
INSERT INTO category(categoryName) VALUES ('Prescription Glasses');
INSERT INTO category(categoryName) VALUES ('Reading Glasses');
INSERT INTO category(categoryName) VALUES ('Blue Light Glasses');
INSERT INTO category(categoryName) VALUES ('Sports Glasses');
INSERT INTO category(categoryName) VALUES ('Safety Glasses');
INSERT INTO category(categoryName) VALUES ('Fashion Glasses');
INSERT INTO category(categoryName) VALUES ('Kids Glasses');

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Oakley Holbrook', 1, 'Sporty sunglasses with UV protection', 120.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Transitions Progressive Lenses', 2, 'Lenses that adapt to light changes', 200.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Ray-Ban Wayfarer RX', 2, 'Stylish prescription frames', 180.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Foster Grant Classic Readers', 3, 'Affordable reading glasses', 15.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Peepers Focus Readers', 3, 'Stylish reading glasses with magnification', 25.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Gunnar Gaming Glasses', 4, 'Blue light blocking glasses for gaming', 60.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Felix Gray Computer Glasses', 4, 'Stylish blue light glasses for digital screens', 95.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Oakley Flak 2.0', 5, 'Durable sports glasses for active use', 170.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nike Tailwind R', 5, 'Lightweight sports glasses', 130.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('3M Safety Glasses', 6, 'Protective glasses for construction work', 25.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Uvex Ultra-Spec 2000', 6, 'Safety glasses with UV protection', 30.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Gucci Oversized Frames', 7, 'High-fashion oversized glasses', 350.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Prada Cat-Eye Frames', 7, 'Elegant fashion glasses', 400.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Fisher-Price Durable Frames', 8, 'Safe and durable glasses for kids', 50.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Disney Character Glasses', 8, 'Kids glasses with favorite characters', 60.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Polarized Sports Sunglasses', 1, 'Ideal for outdoor activities', 110.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Armani Prescription Frames', 2, 'Luxury prescription glasses', 250.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Clip-On Reading Glasses', 3, 'Compact and convenient readers', 20.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Gaming Glasses with Amber Tint', 4, 'Blue light glasses with amber tint', 50.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Wraparound Sports Glasses', 5, 'Snug fit sports frames', 140.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Scratch-Resistant Safety Glasses', 6, 'Durable safety glasses', 35.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Vintage Round Fashion Glasses', 7, 'Retro round frames', 120.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Brightly Colored Kids Glasses', 8, 'Fun and colorful kids frames', 45.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Polarized Aviator Sunglasses', 1, 'Timeless design with polarized lenses', 130.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Durable Reading Glasses', 3, 'Long-lasting reading glasses', 22.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Flexible Kids Frames', 8, 'Bendable frames for active kids', 55.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Night Driving Glasses', 4, 'Glasses for reduced glare while driving at night', 40.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Polarized Wraparound Sunglasses', 1, 'Secure fit sunglasses with polarized lenses', 150.00);

INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 18);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 19);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 10);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 22);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 21.35);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 25);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 30);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 0, 40);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 97);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 3, 31);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , 'test');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , 'bobby');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , 'password');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , 'pw');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , 'test');

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);

-- New SQL DDL for lab 8
UPDATE Product SET productImageURL = 'Images/1.jpg' WHERE ProductId = 1;
UPDATE Product SET productImageURL = 'Images/2.jpg' WHERE ProductId = 2;
UPDATE Product SET productImageURL = 'Images/3.jpg' WHERE ProductId = 3;
UPDATE Product SET productImageURL = 'Images/4.jpg' WHERE ProductId = 4;
UPDATE Product SET productImageURL = 'Images/5.jpg' WHERE ProductId = 5;
UPDATE Product SET productImageURL = 'Images/6.jpg' WHERE ProductId = 6;
UPDATE Product SET productImageURL = 'Images/7.jpg' WHERE ProductId = 7;
UPDATE Product SET productImageURL = 'Images/8.jpg' WHERE ProductId = 8;
UPDATE Product SET productImageURL = 'Images/9.jpg' WHERE ProductId = 9;
UPDATE Product SET productImageURL = 'Images/10.jpg' WHERE ProductId = 10;
UPDATE Product SET productImageURL = 'Images/11.jpg' WHERE ProductId = 11;
UPDATE Product SET productImageURL = 'Images/12.jpg' WHERE ProductId = 12;
UPDATE Product SET productImageURL = 'Images/13.jpg' WHERE ProductId = 13;
UPDATE Product SET productImageURL = 'Images/14.jpg' WHERE ProductId = 14;
UPDATE Product SET productImageURL = 'Images/15.jpg' WHERE ProductId = 15;
UPDATE Product SET productImageURL = 'Images/16.jpg' WHERE ProductId = 16;
UPDATE Product SET productImageURL = 'Images/17.jpg' WHERE ProductId = 17;
UPDATE Product SET productImageURL = 'Images/18.jpg' WHERE ProductId = 18;
UPDATE Product SET productImageURL = 'Images/19.jpg' WHERE ProductId = 19;
UPDATE Product SET productImageURL = 'Images/20.jpg' WHERE ProductId = 20;
UPDATE Product SET productImageURL = 'Images/21.jpg' WHERE ProductId = 21;
UPDATE Product SET productImageURL = 'Images/22.jpg' WHERE ProductId = 22;
UPDATE Product SET productImageURL = 'Images/23.jpg' WHERE ProductId = 23;
UPDATE Product SET productImageURL = 'Images/24.jpg' WHERE ProductId = 24;
UPDATE Product SET productImageURL = 'Images/25.jpg' WHERE ProductId = 25;
UPDATE Product SET productImageURL = 'Images/26.jpg' WHERE ProductId = 26;
UPDATE Product SET productImageURL = 'Images/27.jpg' WHERE ProductId = 27;
