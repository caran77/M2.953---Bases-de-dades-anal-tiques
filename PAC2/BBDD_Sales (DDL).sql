----------------------------------------------------------------------------------------------
--
-- Create schema
--
----------------------------------------------------------------------------------------------

CREATE SCHEMA sale;


----------------------------------------------------------------------------------------------
--
-- Drop tables
--
----------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS sale.tb_order_line;
DROP TABLE IF EXISTS sale.tb_order;
DROP TABLE IF EXISTS sale.tb_product;
DROP TABLE IF EXISTS sale.tb_subcategory;
DROP TABLE IF EXISTS sale.tb_category;
DROP TABLE IF EXISTS sale.tb_client;


----------------------------------------------------------------------------------------------
--
-- Create table tb_client
--
----------------------------------------------------------------------------------------------
	
CREATE TABLE sale.tb_client
(
	client_code          CHAR(5) NOT NULL ,
	client_name          CHARACTER VARYING(40) NOT NULL ,
	address              CHARACTER VARYING(140) ,
	city                 CHARACTER VARYING(25)  ,
	country              CHARACTER VARYING(60) NOT NULL ,
	contact_email        CHARACTER VARYING(100) ,
	phone                CHARACTER VARYING(15) ,
	parent_client_code   CHAR(5) ,
	created_by_user      CHARACTER VARYING(10) NOT NULL DEFAULT 'OS_SYSTEM',
	created_date         DATE ,
	updated_date         DATE ,
	CONSTRAINT pk_client PRIMARY KEY (client_code) ,
	CONSTRAINT fk_client_parent FOREIGN KEY (parent_client_code) 
	           REFERENCES sale.tb_client (client_code)
);


----------------------------------------------------------------------------------------------
--
-- Create table tb_category
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale.tb_category
(
	category_code        CHAR(5) NOT NULL ,
	category_name        CHARACTER VARYING(70) NOT NULL ,
	created_by_user      CHARACTER VARYING(10) NOT NULL  DEFAULT 'OS_SYSTEM',
	created_date         DATE ,
	updated_date         DATE ,
	CONSTRAINT pk_category PRIMARY KEY (category_code)
);


----------------------------------------------------------------------------------------------
--
-- Create table tb_subcategory
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale.tb_subcategory
(
	subcategory_code     CHAR(5) NOT NULL ,
	category_code        CHAR(5) ,
	subcategory_name     CHARACTER VARYING(55) NOT NULL ,
	created_by_user      CHARACTER VARYING(10) NOT NULL  DEFAULT 'OS_SYSTEM',
	created_date         DATE ,
	updated_date         DATE ,
	CONSTRAINT pk_subcategory PRIMARY KEY (subcategory_code),
	CONSTRAINT fk_subcategory_category FOREIGN KEY (category_code) 
	           REFERENCES sale.tb_category (category_code)
);


----------------------------------------------------------------------------------------------
--
-- Create table tb_product
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale.tb_product
(
	product_code         CHAR(5) NOT NULL ,
	subcategory_code     CHAR(5) ,
	product_name         CHARACTER VARYING(60) NOT NULL ,
	price                NUMERIC(12,2) NOT NULL ,
	created_by_user      CHARACTER VARYING(10) NOT NULL  DEFAULT 'OS_SYSTEM',
	created_date         DATE ,
	updated_date         DATE ,
	CONSTRAINT pk_product PRIMARY KEY (product_code) ,
	CONSTRAINT fk_product_subcategory FOREIGN KEY (subcategory_code) 
	           REFERENCES sale.tb_subcategory (subcategory_code)
);


----------------------------------------------------------------------------------------------
--
-- Create table tb_order
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale.tb_order
(
	order_number         CHAR(10) NOT NULL ,
	client_code          CHAR(5) NOT NULL ,
	order_date           DATE NOT NULL ,
	delivery_date        DATE ,
	reception_date       DATE ,
	created_by_user      CHARACTER VARYING(10) NOT NULL  DEFAULT 'OS_SYSTEM',
	created_date         DATE ,
	updated_date         DATE ,
	CONSTRAINT pk_order PRIMARY KEY (order_number) ,
	CONSTRAINT fk_order_client FOREIGN KEY (client_code) 
	           REFERENCES sale.tb_client(client_code)
);


----------------------------------------------------------------------------------------------
--
-- Create table tb_order_line
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale.tb_order_line
(
	order_number         CHAR(10) NOT NULL ,
	order_line_number    INTEGER NOT NULL ,
	product_code         CHAR(5) NOT NULL ,
	quantity             INTEGER NOT NULL ,
	unit_price           NUMERIC(12,2) NOT NULL ,
	created_by_user      CHARACTER VARYING(10) NOT NULL  DEFAULT 'OS_SYSTEM',
	created_date         DATE NULL ,
	updated_date         DATE NULL ,
	CONSTRAINT pk_order_line PRIMARY KEY (order_number, order_line_number) ,
	CONSTRAINT fk_orderline_order FOREIGN KEY (order_number) 
	           REFERENCES sale.tb_order (order_number) ,
	CONSTRAINT fk_orderline_product FOREIGN KEY (product_code) 
	           REFERENCES sale.tb_product (product_code) ,
	CONSTRAINT ck_orderline_line_number CHECK (order_line_number >= 1) 
);

