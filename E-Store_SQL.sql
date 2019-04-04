/**
 * Author:  Nathan
 * Created: 27-Mar-2019
 */

-- jdbc:derby://localhost:1527/electronic_store_DB [nat on NAT]
-- database: electronic_store_DB
-- username: nat
-- password: nat

CREATE TABLE PRODUCTS (
    ID DECIMAL(20) NOT NULL,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRODUCT_PRICE DECIMAL(5, 2) NOT NULL,
    PRODUCT_TYPE VARCHAR(50) NOT NULL,
    PRODUCT_STOCK_QTY INTEGER DEFAULT 0 NOT NULL,
    PRIMARY KEY (ID)
);

INSERT INTO NAT.PRODUCTS (ID, PRODUCT_NAME, PRODUCT_PRICE, PRODUCT_TYPE, PRODUCT_STOCK_QTY) 
	VALUES (4102366650, 'Canon EOS 4000D DSLR Camera', 245.00, 'camera', 20);
INSERT INTO NAT.PRODUCTS (ID, PRODUCT_NAME, PRODUCT_PRICE, PRODUCT_TYPE, PRODUCT_STOCK_QTY) 
	VALUES (5244245050, 'Vmotal GDC80X2 Mini Compact Digital Camera', 38.85, 'camera', 50);
INSERT INTO NAT.PRODUCTS (ID, PRODUCT_NAME, PRODUCT_PRICE, PRODUCT_TYPE, PRODUCT_STOCK_QTY) 
	VALUES (6505226852, 'Garmin Vivoactive 3 GPS Smartwatch', 165.46, 'watch', 40);
INSERT INTO NAT.PRODUCTS (ID, PRODUCT_NAME, PRODUCT_PRICE, PRODUCT_TYPE, PRODUCT_STOCK_QTY) 
	VALUES (3788276846, 'Audio-Technica ATH-S200BT Wireless On-Ear Headphones', 59.00, 'headphones', 90);
INSERT INTO NAT.PRODUCTS (ID, PRODUCT_NAME, PRODUCT_PRICE, PRODUCT_TYPE, PRODUCT_STOCK_QTY) 
	VALUES (7624225586, 'Veho Zb-5 On-Ear Wireless Bluetooth Headphones', 59.95, 'headphones', 80);

CREATE TABLE ORDERS (
    ORDER_NO INTEGER NOT NULL,
    CUSTOMER_NO INTEGER NOT NULL,
    CUSTOMER_NAME VARCHAR(255) NOT NULL,
    BILLING_ADDRESS VARCHAR(255) NOT NULL,
    CARD_NO VARCHAR(20) NOT NULL,
    CARD_TYPE VARCHAR(50) NOT NULL,
    TOTAL_PRICE DECIMAL(7, 2) NOT NULL,
    ORDER_DATE DATE NOT NULL,
    ITEMS_SUMMARY VARCHAR(255) NOT NULL,
    DELIVERY_STATUS VARCHAR(20) DEFAULT 'Pending'  NOT NULL,
    PRIMARY KEY (ORDER_NO)
);

INSERT INTO NAT.ORDERS (ORDER_NO, CUSTOMER_NO, CUSTOMER_NAME, BILLING_ADDRESS, CARD_NO, CARD_TYPE, TOTAL_PRICE, ORDER_DATE, ITEMS_SUMMARY, DELIVERY_STATUS) 
	VALUES (441957, 167313, 'Nathan Smith', '99 Ford Avenue', '****-****-****-4444', 'Debit', 239.80, '2019-04-04', 'Veho Zb-5 On-Ear Wireless Bluetooth Headphones x4', 'Pending');
