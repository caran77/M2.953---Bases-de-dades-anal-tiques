-- Client table creation scripts

DROP TABLE IF EXISTS sale.tb_client CASCADE;

CREATE TABLE sale.tb_client (
	client_code			char(5) not null,
	client_name			varchar(40) not null,
	address				varchar(140),
	city				varchar(25),
	country				varchar(60) not null,
	contact_email		varchar(100),	 	 
	phone				varchar(15),	 	 
	parent_client_code	char(5),	
	created_by_user		varchar(10) not null default 'OS_SYSTEM',
	created_date		date,	 	 
	updated_date		date,
	CONSTRAINT tb_client_pk PRIMARY KEY(client_code)
);

ALTER TABLE sale.tb_client ADD CONSTRAINT tb_client_client_fk FOREIGN KEY (parent_client_code) REFERENCES sale.tb_client (client_code);

CREATE UNIQUE INDEX tb_client_client_code_idx ON sale.tb_client (client_code);

CREATE INDEX tb_client_parent_client_code_idx ON sale.tb_client (parent_client_code);
	 	 
-- Category table creation scripts

DROP TABLE IF EXISTS sale.tb_category CASCADE;

CREATE TABLE sale.tb_category (
	category_code		char(5) not null,	
	category_name		varchar(70) not null,
	created_by_user		varchar(10) not null default 'OS_SYSTEM',
	created_date		date,	 	 
	updated_date		date,
	CONSTRAINT tb_category_pk PRIMARY KEY(category_code)
);

CREATE UNIQUE INDEX tb_category_code_idx ON sale.tb_category (category_code);

-- Category table creation scripts

DROP TABLE IF EXISTS sale.tb_subcategory CASCADE;

CREATE TABLE sale.tb_subcategory (
	subcategory_code	char(5) not null,	
	category_code		char(5),
	subcategory_name	varchar(55) not null,
	created_by_user		varchar(10) not null default 'OS_SYSTEM',
	created_date		date,	 	 
	updated_date		date,
	CONSTRAINT tb_subcategory_pk PRIMARY KEY(subcategory_code)
);

ALTER TABLE sale.tb_subcategory ADD CONSTRAINT tb_subcategory_category_fk FOREIGN KEY (category_code) REFERENCES sale.tb_category (category_code);

CREATE UNIQUE INDEX tb_subcategory_code_idx ON sale.tb_subcategory (subcategory_code);

CREATE INDEX tb_subcategory_category_idx ON sale.tb_subcategory (category_code);
 	 
-- Product table creation scripts

DROP TABLE IF EXISTS sale.tb_product CASCADE;

CREATE TABLE sale.tb_product (
	product_code		char(5) not null,	
	subcategory_code	char(5),
	product_name		varchar(60) not null,
	price 				numeric(14,2) not null,	
	created_by_user		varchar(10) not null default 'OS_SYSTEM',
	created_date		date,	 	 
	updated_date		date,
	CONSTRAINT tb_product_pk PRIMARY KEY(product_code)
);	

ALTER TABLE sale.tb_product ADD CONSTRAINT tb_product_subcategory_fk FOREIGN KEY (subcategory_code) REFERENCES sale.tb_subcategory (subcategory_code);

CREATE UNIQUE INDEX tb_product_code_idx ON sale.tb_product (product_code);

CREATE INDEX tb_product_subcategory_idx ON sale.tb_product (subcategory_code);

-- Orders table creation scripts

DROP TABLE IF EXISTS sale.tb_order CASCADE;

CREATE TABLE sale.tb_order (
	order_number		char(10) not null,	
	client_code			char(5) not null,
	order_date			date not null,	 	 
	delivery_date		date,	 	 
	reception_date		date,	 	 
	created_by_user		varchar(10) not null default 'OS_SYSTEM',
	created_date		date,	 	 
	updated_date		date,
	CONSTRAINT tb_order_pk PRIMARY KEY(order_number)
);	

ALTER TABLE sale.tb_order ADD CONSTRAINT tb_order_client_fk FOREIGN KEY (client_code) REFERENCES sale.tb_client (client_code);

CREATE UNIQUE INDEX tb_order_idx ON sale.tb_order (order_number);

CREATE INDEX tb_order_client_idx ON sale.tb_order (client_code);

-- Order lines table creation scripts

DROP TABLE IF EXISTS sale.tb_order_line; 

CREATE TABLE sale.tb_order_line (
	order_number		char(10) not null,	
	order_line_number	smallint not null check(order_line_number > 0),
	product_code		char(5) not null,
	quantity			smallint not null,
	unit_price			numeric(14,2) not null,	 	 
	created_by_user		varchar(10) not null default 'OS_SYSTEM',
	created_date		date,	 	 
	updated_date		date,
	CONSTRAINT tb_order_line_pk PRIMARY KEY(order_number, order_line_number)
);

ALTER TABLE sale.tb_order_line ADD CONSTRAINT tb_order_line_order_fk FOREIGN KEY (order_number) REFERENCES sale.tb_order (order_number);

ALTER TABLE sale.tb_order_line ADD CONSTRAINT tb_order_line_product_fk FOREIGN KEY (product_code) REFERENCES sale.tb_product (product_code);

CREATE UNIQUE INDEX tb_order_line_idx ON sale.tb_order_line (order_number, order_line_number);

CREATE INDEX tb_order_product_idx ON sale.tb_product (product_code);
