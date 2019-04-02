----------------------------------------------------------------------------------------------
--
-- Create schema
--
----------------------------------------------------------------------------------------------
create schema if not exists sale_cdc;


----------------------------------------------------------------------------------------------
--
-- Drop tables
--
----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS sale_cdc.tb_order_line_cdc;
DROP TABLE IF EXISTS sale_cdc.tb_order_cdc;
DROP TABLE IF EXISTS sale_cdc.tb_product_cdc;
DROP TABLE IF EXISTS sale_cdc.tb_subcategory_cdc;
DROP TABLE IF EXISTS sale_cdc.tb_category_cdc;
DROP TABLE IF EXISTS sale_cdc.tb_client_cdc;

----------------------------------------------------------------------------------------------
--
-- Create table tb_client_cdc
--
----------------------------------------------------------------------------------------------
	
CREATE TABLE sale_cdc.tb_client_cdc
(
	client_code          CHAR(5) NOT NULL,
	client_name          CHARACTER VARYING(40) NOT NULL,
	address              CHARACTER VARYING(140),
	city                 CHARACTER VARYING(25),
	country              CHARACTER VARYING(60) NOT NULL,
	contact_email        CHARACTER VARYING(100),
	phone                CHARACTER VARYING(15),
	parent_client_code   CHAR(5),
	created_by_user      CHARACTER VARYING(10),
	created_date         DATE,
	updated_date         DATE,
    operation            CHAR(1),
    user_id              CHARACTER VARYING(10),
    operation_timestamp  timestamp (6) without time zone,
    CONSTRAINT pk_client PRIMARY KEY (client_code) 
);


----------------------------------------------------------------------------------------------
--
-- Create table tb_category_cdc
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale_cdc.tb_category_cdc
(
	category_code        CHAR(5) NOT NULL,
	category_name        CHARACTER VARYING(70) NOT NULL,
	created_by_user      CHARACTER VARYING(10) NOT NULL,
	created_date         DATE,
	updated_date         DATE,
    operation            CHAR(1),
    user_id              CHARACTER VARYING(10),
    operation_timestamp  timestamp (6) without time zone,    
	CONSTRAINT pk_category PRIMARY KEY (category_code)
);


----------------------------------------------------------------------------------------------
--
-- Create table tb_subcategory_cdc
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale_cdc.tb_subcategory_cdc
(
	subcategory_code     CHAR(5) NOT NULL,
	category_code        CHAR(5),
	subcategory_name     CHARACTER VARYING(55) NOT NULL,
	created_by_user      CHARACTER VARYING(10) NOT NULL,
	created_date         DATE,
	updated_date         DATE,
    operation            CHAR(1),
    user_id              CHARACTER VARYING(10),
    operation_timestamp  timestamp (6) without time zone,    
	CONSTRAINT pk_subcategory PRIMARY KEY (subcategory_code)
);


----------------------------------------------------------------------------------------------
--
-- Create table tb_product_cdc
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale_cdc.tb_product_cdc
(
	product_code         CHAR(5) NOT NULL,
	subcategory_code     CHAR(5),
	product_name         CHARACTER VARYING(60) NOT NULL,
	price                NUMERIC(12,2) NOT NULL,
	created_by_user      CHARACTER VARYING(10) NOT NULL,
	created_date         DATE,
	updated_date         DATE,
    operation            CHAR(1),
    user_id              CHARACTER VARYING(10),
    operation_timestamp  timestamp (6) without time zone,    
	CONSTRAINT pk_product PRIMARY KEY (product_code)
);


----------------------------------------------------------------------------------------------
--
-- Create table tb_order_cdc
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale_cdc.tb_order_cdc
(
	order_number         CHAR(10) NOT NULL,
	client_code          CHAR(5) NOT NULL,
	order_date           DATE NOT NULL,
	delivery_date        DATE,
	reception_date       DATE,
	created_by_user      CHARACTER VARYING(10) NOT NULL,
	created_date         DATE,
	updated_date         DATE,
    operation            CHAR(1),
    user_id              CHARACTER VARYING(10),
    operation_timestamp  timestamp (6) without time zone,    
	CONSTRAINT pk_order PRIMARY KEY (order_number)
);


----------------------------------------------------------------------------------------------
--
-- Create table tb_order_line_cdc
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale_cdc.tb_order_line_cdc
(
	order_number         CHAR(10) NOT NULL,
	order_line_number    INTEGER NOT NULL,
	product_code         CHAR(5) NOT NULL,
	quantity             INTEGER NOT NULL,
	unit_price           NUMERIC(12,2) NOT NULL,
	created_by_user      CHARACTER VARYING(10) NOT NULL,
	created_date         DATE NULL,
	updated_date         DATE NULL,
    operation            CHAR(1),
    user_id              CHARACTER VARYING(10),
    operation_timestamp  timestamp (6) without time zone,    
	CONSTRAINT pk_order_line PRIMARY KEY (order_number, order_line_number)
);