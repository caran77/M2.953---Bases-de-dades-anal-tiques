----------------------------------------------------------------------------------------------
--
-- Create schemas
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
DROP TABLE IF EXISTS sale.tb_city;


------------------------------------------------------------------------------------------------
--
-- Create table tb_city and function to calculate distance between 2 cities
--
------------------------------------------------------------------------------------------------
	
CREATE TABLE sale.tb_city
(
	city_name            TEXT NOT NULL ,
	latitude_num         NUMERIC(10,4) NOT NULL ,
	longitude_num        NUMERIC(10,4) NOT NULL ,
	CONSTRAINT pk_route PRIMARY KEY (city_name)
);

CREATE OR REPLACE FUNCTION sale.distance_km(orig_lat NUMERIC, orig_lon NUMERIC, dest_lat NUMERIC, dest_lon NUMERIC) RETURNS NUMERIC AS $$
DECLARE
  x NUMERIC = 69.1 * (dest_lat - orig_lat);
  y NUMERIC = 69.1 * (dest_lon - orig_lon) * COS(orig_lat / 57.3);
BEGIN
  RETURN SQRT(x * x + y * y)* 1.7;
END
$$ LANGUAGE PLPGSQL
;


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


----------------------------------------------------------------------------------------------
--
-- Create schema
--
----------------------------------------------------------------------------------------------

CREATE SCHEMA sale_cdc;

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
DROP TABLE IF EXISTS sale_cdc.tb_statistics_cdc;

----------------------------------------------------------------------------------------------
--
-- Create table tb_client_cdc
--
----------------------------------------------------------------------------------------------
	
CREATE TABLE sale_cdc.tb_client_cdc
(
	client_code          CHAR(5) NOT NULL ,
	client_name          CHARACTER VARYING(40) NOT NULL ,
	address              CHARACTER VARYING(120) ,
	city                 CHARACTER VARYING(25) NOT NULL ,
	country              CHARACTER VARYING(50) NOT NULL ,
	contact_email        CHARACTER VARYING(100) ,
	phone                CHARACTER VARYING(15) ,
	parent_client_code   CHAR(5) ,
	created_by_user      CHARACTER VARYING(10) NOT NULL ,
	created_date         DATE ,
	updated_date         DATE ,
	operation            CHAR(1) NOT NULL ,
	user_id              CHARACTER VARYING(10) NOT NULL ,
	operation_timestamp  TIMESTAMP(6) NOT NULL ,
    CONSTRAINT pk_client_cdc PRIMARY KEY (client_code)
);

----------------------------------------------------------------------------------------------
--
-- Create table tb_category_cdc
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale_cdc.tb_category_cdc
(
	category_code        CHAR(5) NOT NULL ,
	category_name        CHARACTER VARYING(60) NOT NULL ,
	created_by_user      CHARACTER VARYING(10) NOT NULL ,
	created_date         DATE ,
	updated_date         DATE ,
	operation            CHAR(1) NOT NULL ,
	user_id              CHARACTER VARYING(10) NOT NULL ,
	operation_timestamp  TIMESTAMP(6) NOT NULL ,
	CONSTRAINT pk_category_cdc PRIMARY KEY (category_code)
);

----------------------------------------------------------------------------------------------
--
-- Create table tb_subcategory_cdc
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale_cdc.tb_subcategory_cdc
(
	subcategory_code     CHAR(5) NOT NULL ,
	category_code        CHAR(5) ,
	subcategory_name     CHARACTER VARYING(60) NOT NULL ,
	created_by_user      CHARACTER VARYING(10) NOT NULL ,
	created_date         DATE ,
	updated_date         DATE ,
	operation            CHAR(1) NOT NULL ,
	user_id              CHARACTER VARYING(10) NOT NULL ,
	operation_timestamp  TIMESTAMP(6) NOT NULL ,
	CONSTRAINT pk_subcategory_cdc PRIMARY KEY (subcategory_code)	
);

-----------------------------------------------------------------------------------------------
--
-- Create table tb_product_cdc
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale_cdc.tb_product_cdc
(
	product_code         CHAR(5) NOT NULL ,
	subcategory_code     CHAR(5) ,
	product_name         CHARACTER VARYING(60) NOT NULL ,
	price                NUMERIC(12,2) NOT NULL ,
	created_by_user      CHARACTER VARYING(10) NOT NULL ,
	created_date         DATE ,
	updated_date         DATE ,
	operation            CHAR(1) NOT NULL ,
	user_id              CHARACTER VARYING(10) NOT NULL ,
	operation_timestamp  TIMESTAMP(6) NOT NULL ,
	CONSTRAINT pk_product_cdc PRIMARY KEY (product_code)	
);

----------------------------------------------------------------------------------------------
--
-- Create table tb_order_cdc
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale_cdc.tb_order_cdc
(
	order_number         CHAR(10) NOT NULL ,
	client_code          CHAR(5) NOT NULL ,
	order_date           DATE NOT NULL ,
	delivery_date        DATE NOT NULL ,
	reception_date       DATE ,
	created_by_user      CHARACTER VARYING(10) NOT NULL ,
	created_date         DATE ,
	updated_date         DATE ,
	operation            CHAR(1) NOT NULL ,
	user_id              CHARACTER VARYING(10) NOT NULL ,
	operation_timestamp  TIMESTAMP(6) NOT NULL ,
	CONSTRAINT pk_order_cdc PRIMARY KEY (order_number)	
);

----------------------------------------------------------------------------------------------
--
-- Create table tb_order_line_cdc
--
----------------------------------------------------------------------------------------------

CREATE TABLE sale_cdc.tb_order_line_cdc
(
	order_number         CHAR(10) NOT NULL ,
	order_line_number    INTEGER NOT NULL ,
	product_code         CHAR(5) NOT NULL ,
	quantity             INTEGER NOT NULL ,
	unit_price           NUMERIC(12,2) NOT NULL ,
	created_by_user      CHARACTER VARYING(10) NOT NULL ,
	created_date         DATE NULL ,
	updated_date         DATE NULL ,
	operation            CHAR(1) NOT NULL ,
	user_id              CHARACTER VARYING(10) NOT NULL ,
	operation_timestamp  TIMESTAMP(6) NOT NULL ,
	CONSTRAINT pk_order_line_cdc PRIMARY KEY (order_number, order_line_number)
);




------------------------------------------------------------------------------------------------
--
-- Create trigger procedure and procedure on tb_client for CDC changes
--
------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION sale_cdc.sp_client_cdc() 
RETURNS trigger AS
$$
/* 
 *  Procedimiento: sp_client_cdc
 *  Autor: Alexandre Pereiras Magariños
 *  Fecha creación: 2017-11-01
 *  Versión: 1.0
 *  Parámetros:  sin parámetros
 *  Descripción: Procedimiento que cargará en la tabla tb_client_cdc los cambios
 *               producidos a nivel de fila tras cualquier operación en tb_client.
 *
 */
DECLARE
  v_row_client_cdc sale_cdc.tb_client_cdc%rowtype;
BEGIN
  
  -- Capture user and moment of operation
  v_row_client_cdc.user_id := user;
  v_row_client_cdc.operation_timestamp := now();
  
  -- Depending on the operation, we may need to access the OLD or the NEW record.
  -- If DELETE, then insert D and capture from OLD record
  IF (TG_OP = 'DELETE') THEN
      v_row_client_cdc.client_code := OLD.client_code;
      v_row_client_cdc.client_name := OLD.client_name;
      v_row_client_cdc.address := OLD.address;
      v_row_client_cdc.city := OLD.city;
      v_row_client_cdc.country := OLD.country;
      v_row_client_cdc.contact_email := OLD.contact_email;
      v_row_client_cdc.phone := OLD.phone;
      v_row_client_cdc.parent_client_code := OLD.parent_client_code;
      v_row_client_cdc.created_by_user := OLD.created_by_user;
      v_row_client_cdc.created_date := OLD.created_date;
      v_row_client_cdc.updated_date := OLD.updated_date;  
      v_row_client_cdc.operation := 'D';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_client_cdc SELECT v_row_client_cdc.*;
      
	  -- If record exists, then update
	  EXCEPTION
	    WHEN unique_violation THEN
          UPDATE sale_cdc.tb_client_cdc 
             SET (client_name, address, city, 
			      country, contact_email, phone, parent_client_code, 
				  created_by_user, created_date, updated_date, operation, 
				  user_id, operation_timestamp) = 
			       (v_row_client_cdc.client_name, v_row_client_cdc.address, v_row_client_cdc.city, 
				    v_row_client_cdc.country, v_row_client_cdc.contact_email, v_row_client_cdc.phone, v_row_client_cdc.parent_client_code, 
					v_row_client_cdc.created_by_user, v_row_client_cdc.created_date, v_row_client_cdc.updated_date, v_row_client_cdc.operation, 
					v_row_client_cdc.user_id, v_row_client_cdc.operation_timestamp)
           WHERE tb_client_cdc.client_code = v_row_client_cdc.client_code;
	  END;
	  
	  -- Return OLD record
	  RETURN OLD;
  
  -- If UPDATE, then insert U and capture from NEW record	  
  ELSIF (TG_OP = 'UPDATE') THEN
      v_row_client_cdc.client_code := NEW.client_code;
      v_row_client_cdc.client_name := NEW.client_name;
      v_row_client_cdc.address := NEW.address;
      v_row_client_cdc.city := NEW.city;
      v_row_client_cdc.country := NEW.country;
      v_row_client_cdc.contact_email := NEW.contact_email;
      v_row_client_cdc.phone := NEW.phone;
      v_row_client_cdc.parent_client_code := NEW.parent_client_code;
      v_row_client_cdc.created_by_user := NEW.created_by_user;
      v_row_client_cdc.created_date := NEW.created_date;
      v_row_client_cdc.updated_date := NEW.updated_date;   
      v_row_client_cdc.operation := 'U';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_client_cdc SELECT v_row_client_cdc.*;
      
	  -- If record exists, then update
	  EXCEPTION
	    WHEN unique_violation THEN
          UPDATE sale_cdc.tb_client_cdc 
             SET (client_name, address, city, 
			      country, contact_email, phone, parent_client_code, 
				  created_by_user, created_date, updated_date, operation, 
				  user_id, operation_timestamp) = 
			       (v_row_client_cdc.client_name, v_row_client_cdc.address, v_row_client_cdc.city, 
				    v_row_client_cdc.country, v_row_client_cdc.contact_email, v_row_client_cdc.phone, v_row_client_cdc.parent_client_code, 
					v_row_client_cdc.created_by_user, v_row_client_cdc.created_date, v_row_client_cdc.updated_date, v_row_client_cdc.operation, 
					v_row_client_cdc.user_id, v_row_client_cdc.operation_timestamp)
           WHERE tb_client_cdc.client_code = v_row_client_cdc.client_code;
	  END;
      
	  -- Return NEW record
	  RETURN NEW;

  -- If INSERT, then insert I and capture from NEW record		  
  ELSIF (TG_OP = 'INSERT') THEN
      v_row_client_cdc.client_code := NEW.client_code;
      v_row_client_cdc.client_name := NEW.client_name;
      v_row_client_cdc.address := NEW.address;
      v_row_client_cdc.city := NEW.city;
      v_row_client_cdc.country := NEW.country;
      v_row_client_cdc.contact_email := NEW.contact_email;
      v_row_client_cdc.phone := NEW.phone;
      v_row_client_cdc.parent_client_code := NEW.parent_client_code;
      v_row_client_cdc.created_by_user := NEW.created_by_user;
      v_row_client_cdc.created_date := NEW.created_date;
      v_row_client_cdc.updated_date := NEW.updated_date;   
      v_row_client_cdc.operation := 'I';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_client_cdc SELECT v_row_client_cdc.*;
      
	  -- If record exists, then update
	  EXCEPTION
	    WHEN unique_violation THEN
          UPDATE sale_cdc.tb_client_cdc 
             SET (client_name, address, city, 
			      country, contact_email, phone, parent_client_code, 
				  created_by_user, created_date, updated_date, operation, 
				  user_id, operation_timestamp) = 
			       (v_row_client_cdc.client_name, v_row_client_cdc.address, v_row_client_cdc.city, 
				    v_row_client_cdc.country, v_row_client_cdc.contact_email, v_row_client_cdc.phone, v_row_client_cdc.parent_client_code, 
					v_row_client_cdc.created_by_user, v_row_client_cdc.created_date, v_row_client_cdc.updated_date, v_row_client_cdc.operation, 
					v_row_client_cdc.user_id, v_row_client_cdc.operation_timestamp)
           WHERE tb_client_cdc.client_code = v_row_client_cdc.client_code;
	  END;
      
	  -- Return NEW record
	  RETURN NEW;
	  
  END IF;
  
  -- Result is ignored since this is an AFTER trigger
  RETURN NULL; 

END; -- Fin del procedimiento  
$$
LANGUAGE plpgsql;
  
CREATE TRIGGER tg_iud_client_cdc 
  AFTER INSERT OR UPDATE OR DELETE ON sale.tb_client
  FOR EACH ROW
  EXECUTE PROCEDURE sale_cdc.sp_client_cdc()
;

------------------------------------------------------------------------------------------------
--
-- Create trigger procedure and procedure on tb_category for CDC changes
--
------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION sale_cdc.sp_category_cdc() 
RETURNS trigger AS
$$
/* 
 *  Procedimiento: sp_category_cdc
 *  Autor: Alexandre Pereiras Magariños
 *  Fecha creación: 2017-11-01
 *  Versión: 1.0
 *  Parámetros:  sin parámetros
 *  Descripción: Procedimiento que cargará en la tabla tb_category_cdc los cambios
 *               producidos a nivel de fila tras cualquier operación en tb_category.
 *
 */
DECLARE
  v_row_category_cdc sale_cdc.tb_category_cdc%rowtype;
BEGIN
  
  -- Capture user and moment of operation
  v_row_category_cdc.user_id := user;
  v_row_category_cdc.operation_timestamp := now();
  
  -- Depending on the operation, we may need to access the OLD or the NEW record.
  -- If DELETE, then insert D and capture from OLD record
  IF (TG_OP = 'DELETE') THEN
      v_row_category_cdc.category_code := OLD.category_code;
      v_row_category_cdc.category_name := OLD.category_name;
      v_row_category_cdc.created_by_user := OLD.created_by_user;
      v_row_category_cdc.created_date := OLD.created_date;
      v_row_category_cdc.updated_date := OLD.updated_date;  
      v_row_category_cdc.operation := 'D';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_category_cdc SELECT v_row_category_cdc.*;
      
	  -- If row exists, then update
	  EXCEPTION
	    WHEN unique_violation THEN 
		  UPDATE sale_cdc.tb_category_cdc
		     SET (category_name, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) = 
			       (v_row_category_cdc.category_name, v_row_category_cdc.created_by_user, v_row_category_cdc.created_date, 
				    v_row_category_cdc.updated_date, v_row_category_cdc.operation, v_row_category_cdc.user_id, v_row_category_cdc.operation_timestamp)
		   WHERE tb_category_cdc.category_code = v_row_category_cdc.category_code;
	  END;
	  
	  -- Return OLD record
	  RETURN OLD;
  
  -- If UPDATE, then insert U and capture from NEW record	  
  ELSIF (TG_OP = 'UPDATE') THEN
      v_row_category_cdc.category_code := NEW.category_code;
      v_row_category_cdc.category_name := NEW.category_name;
      v_row_category_cdc.created_by_user := NEW.created_by_user;
      v_row_category_cdc.created_date := NEW.created_date;
      v_row_category_cdc.updated_date := NEW.updated_date;  
      v_row_category_cdc.operation := 'U';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_category_cdc SELECT v_row_category_cdc.*;
      
	  -- If row exists, then update
	  EXCEPTION
	    WHEN unique_violation THEN 
		  UPDATE sale_cdc.tb_category_cdc
		     SET (category_name, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) = 
			       (v_row_category_cdc.category_name, v_row_category_cdc.created_by_user, v_row_category_cdc.created_date, 
				    v_row_category_cdc.updated_date, v_row_category_cdc.operation, v_row_category_cdc.user_id, v_row_category_cdc.operation_timestamp)
		   WHERE tb_category_cdc.category_code = v_row_category_cdc.category_code;
	  END;
      
	  -- Return NEW record
	  RETURN NEW;

  -- If INSERT, then insert I and capture from NEW record		  
  ELSIF (TG_OP = 'INSERT') THEN
      v_row_category_cdc.category_code := NEW.category_code;
      v_row_category_cdc.category_name := NEW.category_name;
      v_row_category_cdc.created_by_user := NEW.created_by_user;
      v_row_category_cdc.created_date := NEW.created_date;
      v_row_category_cdc.updated_date := NEW.updated_date;  
      v_row_category_cdc.operation := 'I';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_category_cdc SELECT v_row_category_cdc.*;
      
	  -- If row exists, then update
	  EXCEPTION
	    WHEN unique_violation THEN 
		  UPDATE sale_cdc.tb_category_cdc
		     SET (category_name, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) = 
			       (v_row_category_cdc.category_name, v_row_category_cdc.created_by_user, v_row_category_cdc.created_date, 
				    v_row_category_cdc.updated_date, v_row_category_cdc.operation, v_row_category_cdc.user_id, v_row_category_cdc.operation_timestamp)
		   WHERE tb_category_cdc.category_code = v_row_category_cdc.category_code;
	  END;
      
	  -- Return NEW record
	  RETURN NEW;
	  
  END IF;
  
  -- Result is ignored since this is an AFTER trigger
  RETURN NULL; 

END; -- Fin del procedimiento  
$$
LANGUAGE plpgsql;
	
CREATE TRIGGER tg_iud_category_cdc 
  AFTER INSERT OR UPDATE OR DELETE ON sale.tb_category
  FOR EACH ROW
  EXECUTE PROCEDURE sale_cdc.sp_category_cdc()
;

------------------------------------------------------------------------------------------------
--
-- Create trigger procedure and procedure on tb_subcategory for CDC changes
--
------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION sale_cdc.sp_subcategory_cdc() 
RETURNS trigger AS
$$
/* 
 *  Procedimiento: sp_subcategory_cdc
 *  Autor: Alexandre Pereiras Magariños
 *  Fecha creación: 2017-11-01
 *  Versión: 1.0
 *  Parámetros:  sin parámetros
 *  Descripción: Procedimiento que cargará en la tabla tb_subcategory_cdc los cambios
 *               producidos a nivel de fila tras cualquier operación en tb_subcategory.
 *
 */
DECLARE
  v_row_subcategory_cdc sale_cdc.tb_subcategory_cdc%rowtype;
BEGIN
  
  -- Capture user and moment of operation
  v_row_subcategory_cdc.user_id := user;
  v_row_subcategory_cdc.operation_timestamp := now();
  
  -- Depending on the operation, we may need to access the OLD or the NEW record.
  -- If DELETE, then insert D and capture from OLD record
  IF (TG_OP = 'DELETE') THEN
      v_row_subcategory_cdc.subcategory_code := OLD.subcategory_code;
      v_row_subcategory_cdc.category_code := OLD.category_code;
	  v_row_subcategory_cdc.subcategory_name := OLD.subcategory_name;
      v_row_subcategory_cdc.created_by_user := OLD.created_by_user;
      v_row_subcategory_cdc.created_date := OLD.created_date;
      v_row_subcategory_cdc.updated_date := OLD.updated_date;  
      v_row_subcategory_cdc.operation := 'D';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_subcategory_cdc SELECT v_row_subcategory_cdc.*;
      
	  -- If row exists, then update
	  EXCEPTION
	    WHEN unique_violation THEN
		  UPDATE sale_cdc.tb_subcategory_cdc 
		     SET (category_code, subcategory_name, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) =
			       (v_row_subcategory_cdc.category_code, v_row_subcategory_cdc.subcategory_name, v_row_subcategory_cdc.created_by_user, 
				    v_row_subcategory_cdc.created_date, v_row_subcategory_cdc.updated_date, v_row_subcategory_cdc.operation, v_row_subcategory_cdc.user_id, v_row_subcategory_cdc.operation_timestamp)
		   WHERE tb_subcategory_cdc.subcategory_code = v_row_subcategory_cdc.subcategory_code;
	  END;
	  
	  -- Return OLD record
	  RETURN OLD;
  
  -- If UPDATE, then insert U and capture from NEW record	  
  ELSIF (TG_OP = 'UPDATE') THEN
      v_row_subcategory_cdc.subcategory_code := NEW.subcategory_code;
      v_row_subcategory_cdc.category_code := NEW.category_code;
	  v_row_subcategory_cdc.subcategory_name := NEW.subcategory_name;
      v_row_subcategory_cdc.created_by_user := NEW.created_by_user;
      v_row_subcategory_cdc.created_date := NEW.created_date;
      v_row_subcategory_cdc.updated_date := NEW.updated_date;  
      v_row_subcategory_cdc.operation := 'U';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_subcategory_cdc SELECT v_row_subcategory_cdc.*;
      
	  -- If row exists, then update
	  EXCEPTION
	    WHEN unique_violation THEN
		  UPDATE sale_cdc.tb_subcategory_cdc 
		     SET (category_code, subcategory_name, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) =
			       (v_row_subcategory_cdc.category_code, v_row_subcategory_cdc.subcategory_name, v_row_subcategory_cdc.created_by_user, 
				    v_row_subcategory_cdc.created_date, v_row_subcategory_cdc.updated_date, v_row_subcategory_cdc.operation, v_row_subcategory_cdc.user_id, v_row_subcategory_cdc.operation_timestamp)
		   WHERE tb_subcategory_cdc.subcategory_code = v_row_subcategory_cdc.subcategory_code;
	  END;
      
	  -- Return NEW record
	  RETURN NEW;

  -- If INSERT, then insert I and capture from NEW record		  
  ELSIF (TG_OP = 'INSERT') THEN
      v_row_subcategory_cdc.subcategory_code := NEW.subcategory_code;
      v_row_subcategory_cdc.category_code := NEW.category_code;
	  v_row_subcategory_cdc.subcategory_name := NEW.subcategory_name;
      v_row_subcategory_cdc.created_by_user := NEW.created_by_user;
      v_row_subcategory_cdc.created_date := NEW.created_date;
      v_row_subcategory_cdc.updated_date := NEW.updated_date;  
      v_row_subcategory_cdc.operation := 'I';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_subcategory_cdc SELECT v_row_subcategory_cdc.*;
      
	  -- If row exists, then update
	  EXCEPTION
	    WHEN unique_violation THEN
		  UPDATE sale_cdc.tb_subcategory_cdc 
		     SET (category_code, subcategory_name, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) =
			       (v_row_subcategory_cdc.category_code, v_row_subcategory_cdc.subcategory_name, v_row_subcategory_cdc.created_by_user, 
				    v_row_subcategory_cdc.created_date, v_row_subcategory_cdc.updated_date, v_row_subcategory_cdc.operation, v_row_subcategory_cdc.user_id, v_row_subcategory_cdc.operation_timestamp)
		   WHERE tb_subcategory_cdc.subcategory_code = v_row_subcategory_cdc.subcategory_code;
	  END;
      
	  -- Return NEW record
	  RETURN NEW;
	  
  END IF;
  
  -- Result is ignored since this is an AFTER trigger
  RETURN NULL; 

END; -- Fin del procedimiento  
$$
LANGUAGE plpgsql;
	
CREATE TRIGGER tg_iud_subcategory_cdc 
  AFTER INSERT OR UPDATE OR DELETE ON sale.tb_subcategory
  FOR EACH ROW
  EXECUTE PROCEDURE sale_cdc.sp_subcategory_cdc()
;

------------------------------------------------------------------------------------------------
--
-- Create trigger procedure and procedure on tb_product for CDC changes
--
------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION sale_cdc.sp_product_cdc() 
RETURNS trigger AS
$$
/* 
 *  Procedimiento: sp_product_cdc
 *  Autor: Alexandre Pereiras Magariños
 *  Fecha creación: 2017-11-01
 *  Versión: 1.0
 *  Parámetros:  sin parámetros
 *  Descripción: Procedimiento que cargará en la tabla tb_product_cdc los cambios
 *               producidos a nivel de fila tras cualquier operación en tb_product.
 *
 */
DECLARE
  v_row_product_cdc sale_cdc.tb_product_cdc%rowtype;
BEGIN
  
  -- Capture user and moment of operation
  v_row_product_cdc.user_id := user;
  v_row_product_cdc.operation_timestamp := now();
  
  -- Depending on the operation, we may need to access the OLD or the NEW record.
  -- If DELETE, then insert D and capture from OLD record
  IF (TG_OP = 'DELETE') THEN
      v_row_product_cdc.product_code := OLD.product_code;
      v_row_product_cdc.subcategory_code := OLD.subcategory_code;
	  v_row_product_cdc.product_name := OLD.product_name;
	  v_row_product_cdc.price := OLD.price;
      v_row_product_cdc.created_by_user := OLD.created_by_user;
      v_row_product_cdc.created_date := OLD.created_date;
      v_row_product_cdc.updated_date := OLD.updated_date;  
      v_row_product_cdc.operation := 'D';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_product_cdc SELECT v_row_product_cdc.*;
	  
	  EXCEPTION 
	    WHEN unique_violation THEN
		  UPDATE sale_cdc.tb_product_cdc 
		     SET (subcategory_code, product_name, price, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) =  
			       (v_row_product_cdc.subcategory_code, v_row_product_cdc.product_name, v_row_product_cdc.price, 
				    v_row_product_cdc.created_by_user, v_row_product_cdc.created_date, v_row_product_cdc.updated_date, v_row_product_cdc.operation, 
					v_row_product_cdc.user_id, v_row_product_cdc.operation_timestamp)   
		   WHERE tb_product_cdc.product_code = v_row_product_cdc.product_code;
	  END;
      
	  -- Return OLD record
	  RETURN OLD;
  
  -- If UPDATE, then insert U and capture from NEW record	  
  ELSIF (TG_OP = 'UPDATE') THEN
      v_row_product_cdc.product_code := NEW.product_code;
      v_row_product_cdc.subcategory_code := NEW.subcategory_code;
	  v_row_product_cdc.product_name := NEW.product_name;
	  v_row_product_cdc.price := NEW.price;
      v_row_product_cdc.created_by_user := NEW.created_by_user;
      v_row_product_cdc.created_date := NEW.created_date;
      v_row_product_cdc.updated_date := NEW.updated_date;  
      v_row_product_cdc.operation := 'U';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_product_cdc SELECT v_row_product_cdc.*;
	  
	  EXCEPTION 
	    WHEN unique_violation THEN
		  UPDATE sale_cdc.tb_product_cdc 
		     SET (subcategory_code, product_name, price, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) =  
			       (v_row_product_cdc.subcategory_code, v_row_product_cdc.product_name, v_row_product_cdc.price, 
				    v_row_product_cdc.created_by_user, v_row_product_cdc.created_date, v_row_product_cdc.updated_date, v_row_product_cdc.operation, 
					v_row_product_cdc.user_id, v_row_product_cdc.operation_timestamp)   
		   WHERE tb_product_cdc.product_code = v_row_product_cdc.product_code;
	  END;
      
	  -- Return NEW record
	  RETURN NEW;

  -- If INSERT, then insert I and capture from NEW record		  
  ELSIF (TG_OP = 'INSERT') THEN
      v_row_product_cdc.product_code := NEW.product_code;
      v_row_product_cdc.subcategory_code := NEW.subcategory_code;
	  v_row_product_cdc.product_name := NEW.product_name;
	  v_row_product_cdc.price := NEW.price;
      v_row_product_cdc.created_by_user := NEW.created_by_user;
      v_row_product_cdc.created_date := NEW.created_date;
      v_row_product_cdc.updated_date := NEW.updated_date;  
      v_row_product_cdc.operation := 'I';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_product_cdc SELECT v_row_product_cdc.*;
	  
	  EXCEPTION 
	    WHEN unique_violation THEN
		  UPDATE sale_cdc.tb_product_cdc 
		     SET (subcategory_code, product_name, price, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) =  
			       (v_row_product_cdc.subcategory_code, v_row_product_cdc.product_name, v_row_product_cdc.price, 
				    v_row_product_cdc.created_by_user, v_row_product_cdc.created_date, v_row_product_cdc.updated_date, v_row_product_cdc.operation, 
					v_row_product_cdc.user_id, v_row_product_cdc.operation_timestamp)   
		   WHERE tb_product_cdc.product_code = v_row_product_cdc.product_code;
	  END;
      
	  -- Return NEW record
	  RETURN NEW;
	  
  END IF;
  
  -- Result is ignored since this is an AFTER trigger
  RETURN NULL; 

END; -- Fin del procedimiento  
$$
LANGUAGE plpgsql;
	
CREATE TRIGGER tg_iud_product_cdc 
  AFTER INSERT OR UPDATE OR DELETE ON sale.tb_product
  FOR EACH ROW
  EXECUTE PROCEDURE sale_cdc.sp_product_cdc()
;

------------------------------------------------------------------------------------------------
--
-- Create trigger procedure and procedure on tb_order for CDC changes
--
------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION sale_cdc.sp_order_cdc() 
RETURNS trigger AS
$$
/* 
 *  Procedimiento: sp_order_cdc
 *  Autor: Alexandre Pereiras Magariños
 *  Fecha creación: 2017-11-01
 *  Versión: 1.0
 *  Parámetros:  sin parámetros
 *  Descripción: Procedimiento que cargará en la tabla tb_order_cdc los cambios
 *               producidos a nivel de fila tras cualquier operación en tb_order.
 *
 */
DECLARE
  v_row_order_cdc sale_cdc.tb_order_cdc%rowtype;
BEGIN
  
  -- Capture user and moment of operation
  v_row_order_cdc.user_id := user;
  v_row_order_cdc.operation_timestamp := now();
  
  -- Depending on the operation, we may need to access the OLD or the NEW record.
  -- If DELETE, then insert D and capture from OLD record
  IF (TG_OP = 'DELETE') THEN
      v_row_order_cdc.order_number := OLD.order_number;
      v_row_order_cdc.client_code := OLD.client_code;
	  v_row_order_cdc.order_date := OLD.order_date;
	  v_row_order_cdc.delivery_date := OLD.delivery_date;
	  v_row_order_cdc.reception_date := OLD.reception_date;
      v_row_order_cdc.created_by_user := OLD.created_by_user;
      v_row_order_cdc.created_date := OLD.created_date;
      v_row_order_cdc.updated_date := OLD.updated_date;  
      v_row_order_cdc.operation := 'D';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_order_cdc SELECT v_row_order_cdc.*;
      
	  -- If row exists, update
	  EXCEPTION 
	    WHEN unique_violation THEN
		  UPDATE sale_cdc.tb_order_cdc
		     SET (client_code, order_date, delivery_date, reception_date, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) = 
			       (v_row_order_cdc.client_code, v_row_order_cdc.order_date, v_row_order_cdc.delivery_date, 
				    v_row_order_cdc.reception_date, v_row_order_cdc.created_by_user, v_row_order_cdc.created_date, v_row_order_cdc.updated_date,
					v_row_order_cdc.operation, v_row_order_cdc.user_id, v_row_order_cdc.operation_timestamp)
		   WHERE tb_order_cdc.order_number = v_row_order_cdc.order_number;		   
	  END;
	  
	  -- Return OLD record
	  RETURN OLD;
  
  -- If UPDATE, then insert U and capture from NEW record	  
  ELSIF (TG_OP = 'UPDATE') THEN
      v_row_order_cdc.order_number := NEW.order_number;
      v_row_order_cdc.client_code := NEW.client_code;
	  v_row_order_cdc.order_date := NEW.order_date;
	  v_row_order_cdc.delivery_date := NEW.delivery_date;
	  v_row_order_cdc.reception_date := NEW.reception_date;
      v_row_order_cdc.created_by_user := NEW.created_by_user;
      v_row_order_cdc.created_date := NEW.created_date;
      v_row_order_cdc.updated_date := NEW.updated_date;  
      v_row_order_cdc.operation := 'U';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_order_cdc SELECT v_row_order_cdc.*;
      
	  -- If row exists, update
	  EXCEPTION 
	    WHEN unique_violation THEN
		  UPDATE sale_cdc.tb_order_cdc
		     SET (client_code, order_date, delivery_date, reception_date, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) = 
			       (v_row_order_cdc.client_code, v_row_order_cdc.order_date, v_row_order_cdc.delivery_date, 
				    v_row_order_cdc.reception_date, v_row_order_cdc.created_by_user, v_row_order_cdc.created_date, v_row_order_cdc.updated_date,
					v_row_order_cdc.operation, v_row_order_cdc.user_id, v_row_order_cdc.operation_timestamp)
		   WHERE tb_order_cdc.order_number = v_row_order_cdc.order_number;		   
	  END;
      
	  -- Return NEW record
	  RETURN NEW;

  -- If INSERT, then insert I and capture from NEW record		  
  ELSIF (TG_OP = 'INSERT') THEN
      v_row_order_cdc.order_number := NEW.order_number;
      v_row_order_cdc.client_code := NEW.client_code;
	  v_row_order_cdc.order_date := NEW.order_date;
	  v_row_order_cdc.delivery_date := NEW.delivery_date;
	  v_row_order_cdc.reception_date := NEW.reception_date;
      v_row_order_cdc.created_by_user := NEW.created_by_user;
      v_row_order_cdc.created_date := NEW.created_date;
      v_row_order_cdc.updated_date := NEW.updated_date;  
      v_row_order_cdc.operation := 'I';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_order_cdc SELECT v_row_order_cdc.*;
      
	  -- If row exists, update
	  EXCEPTION 
	    WHEN unique_violation THEN
		  UPDATE sale_cdc.tb_order_cdc
		     SET (client_code, order_date, delivery_date, reception_date, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) = 
			       (v_row_order_cdc.client_code, v_row_order_cdc.order_date, v_row_order_cdc.delivery_date, 
				    v_row_order_cdc.reception_date, v_row_order_cdc.created_by_user, v_row_order_cdc.created_date, v_row_order_cdc.updated_date,
					v_row_order_cdc.operation, v_row_order_cdc.user_id, v_row_order_cdc.operation_timestamp)
		   WHERE tb_order_cdc.order_number = v_row_order_cdc.order_number;		   
	  END;
      
	  -- Return NEW record
	  RETURN NEW;
	  
  END IF;
  
  -- Result is ignored since this is an AFTER trigger
  RETURN NULL; 

END; -- Fin del procedimiento  
$$
LANGUAGE plpgsql;
	
CREATE TRIGGER tg_iud_order_cdc 
  AFTER INSERT OR UPDATE OR DELETE ON sale.tb_order
  FOR EACH ROW
  EXECUTE PROCEDURE sale_cdc.sp_order_cdc()
;

------------------------------------------------------------------------------------------------
--
-- Create trigger procedure and procedure on tb_order_line for CDC changes
--
------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION sale_cdc.sp_order_line_cdc() 
RETURNS trigger AS
$$
/* 
 *  Procedimiento: sp_order_line_cdc
 *  Autor: Alexandre Pereiras Magariños
 *  Fecha creación: 2017-11-01
 *  Versión: 1.0
 *  Parámetros:  sin parámetros
 *  Descripción: Procedimiento que cargará en la tabla tb_order_line_cdc los cambios
 *               producidos a nivel de fila tras cualquier operación en tb_order_line.
 *
 */
DECLARE
  v_row_order_line_cdc sale_cdc.tb_order_line_cdc%rowtype;
BEGIN
  
  -- Capture user and moment of operation
  v_row_order_line_cdc.user_id := user;
  v_row_order_line_cdc.operation_timestamp := now();
  
  -- Depending on the operation, we may need to access the OLD or the NEW record.
  -- If DELETE, then insert D and capture from OLD record
  IF (TG_OP = 'DELETE') THEN
      v_row_order_line_cdc.order_number := OLD.order_number;
      v_row_order_line_cdc.order_line_number := OLD.order_line_number;
	  v_row_order_line_cdc.product_code := OLD.product_code;
	  v_row_order_line_cdc.quantity := OLD.quantity;
	  v_row_order_line_cdc.unit_price := OLD.unit_price;
      v_row_order_line_cdc.created_by_user := OLD.created_by_user;
      v_row_order_line_cdc.created_date := OLD.created_date;
      v_row_order_line_cdc.updated_date := OLD.updated_date;  
      v_row_order_line_cdc.operation := 'D';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_order_line_cdc SELECT v_row_order_line_cdc.*;
      
	  -- If row exists, update it
	  EXCEPTION 
	    WHEN unique_violation THEN
	      UPDATE sale_cdc.tb_order_line_cdc
	         SET (product_code, quantity, unit_price, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) =
		           (v_row_order_line_cdc.product_code, v_row_order_line_cdc.quantity, v_row_order_line_cdc.unit_price, v_row_order_line_cdc.created_by_user, 
			        v_row_order_line_cdc.created_date, v_row_order_line_cdc.updated_date, v_row_order_line_cdc.operation, v_row_order_line_cdc.user_id, v_row_order_line_cdc.operation_timestamp)
	       WHERE tb_order_line_cdc.order_number = v_row_order_line_cdc.order_number
	         AND tb_order_line_cdc.order_line_number = v_row_order_line_cdc.order_line_number;
	  END;
	  
	  -- Return OLD record
	  RETURN OLD;
  
  -- If UPDATE, then insert U and capture from NEW record	  
  ELSIF (TG_OP = 'UPDATE') THEN
      v_row_order_line_cdc.order_number := NEW.order_number;
      v_row_order_line_cdc.order_line_number := NEW.order_line_number;
	  v_row_order_line_cdc.product_code := NEW.product_code;
	  v_row_order_line_cdc.quantity := NEW.quantity;
	  v_row_order_line_cdc.unit_price := NEW.unit_price;
      v_row_order_line_cdc.created_by_user := NEW.created_by_user;
      v_row_order_line_cdc.created_date := NEW.created_date;
      v_row_order_line_cdc.updated_date := NEW.updated_date;  
      v_row_order_line_cdc.operation := 'U';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_order_line_cdc SELECT v_row_order_line_cdc.*;
      
	  -- If row exists, update it
	  EXCEPTION 
	    WHEN unique_violation THEN
	      UPDATE sale_cdc.tb_order_line_cdc
	         SET (product_code, quantity, unit_price, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) =
		           (v_row_order_line_cdc.product_code, v_row_order_line_cdc.quantity, v_row_order_line_cdc.unit_price, v_row_order_line_cdc.created_by_user, 
			        v_row_order_line_cdc.created_date, v_row_order_line_cdc.updated_date, v_row_order_line_cdc.operation, v_row_order_line_cdc.user_id, v_row_order_line_cdc.operation_timestamp)
	       WHERE tb_order_line_cdc.order_number = v_row_order_line_cdc.order_number
	         AND tb_order_line_cdc.order_line_number = v_row_order_line_cdc.order_line_number;
	  END;
      
	  -- Return NEW record
	  RETURN NEW;

  -- If INSERT, then insert I and capture from NEW record		  
  ELSIF (TG_OP = 'INSERT') THEN
      v_row_order_line_cdc.order_number := NEW.order_number;
      v_row_order_line_cdc.order_line_number := NEW.order_line_number;
	  v_row_order_line_cdc.product_code := NEW.product_code;
	  v_row_order_line_cdc.quantity := NEW.quantity;
	  v_row_order_line_cdc.unit_price := NEW.unit_price;
      v_row_order_line_cdc.created_by_user := NEW.created_by_user;
      v_row_order_line_cdc.created_date := NEW.created_date;
      v_row_order_line_cdc.updated_date := NEW.updated_date;  
      v_row_order_line_cdc.operation := 'I';
	  
	  BEGIN
	  -- Insert into CDC table
      INSERT INTO sale_cdc.tb_order_line_cdc SELECT v_row_order_line_cdc.*;
      
	  -- If row exists, update it
	  EXCEPTION 
	    WHEN unique_violation THEN
	      UPDATE sale_cdc.tb_order_line_cdc
	         SET (product_code, quantity, unit_price, created_by_user, created_date, updated_date, operation, user_id, operation_timestamp) =
		           (v_row_order_line_cdc.product_code, v_row_order_line_cdc.quantity, v_row_order_line_cdc.unit_price, v_row_order_line_cdc.created_by_user, 
			        v_row_order_line_cdc.created_date, v_row_order_line_cdc.updated_date, v_row_order_line_cdc.operation, v_row_order_line_cdc.user_id, v_row_order_line_cdc.operation_timestamp)
	       WHERE tb_order_line_cdc.order_number = v_row_order_line_cdc.order_number
	         AND tb_order_line_cdc.order_line_number = v_row_order_line_cdc.order_line_number;
	  END;
      
	  -- Return NEW record
	  RETURN NEW;
	  
  END IF;
  
  -- Result is ignored since this is an AFTER trigger
  RETURN NULL; 

END; -- Fin del procedimiento  
$$
LANGUAGE plpgsql;
	
CREATE TRIGGER tg_iud_order_line_cdc 
  AFTER INSERT OR UPDATE OR DELETE ON sale.tb_order_line
  FOR EACH ROW
  EXECUTE PROCEDURE sale_cdc.sp_order_line_cdc()
;


------------------------------------------------------------------------------------------------
--
-- Create schema sale_dw
--
------------------------------------------------------------------------------------------------

CREATE SCHEMA sale_dw;

------------------------------------------------------------------------------------------------
--
-- Create schema sale_stg
--
------------------------------------------------------------------------------------------------

CREATE SCHEMA sale_stg;

------------------------------------------------------------------------------------------------
--
-- Create table tb_product_dim
--
------------------------------------------------------------------------------------------------

CREATE TABLE sale_dw.tb_product_dim
(
	product_code         CHAR(5) NOT NULL ,
	product_name         CHARACTER VARYING(50) NOT NULL ,
	price                NUMERIC(12,2) NOT NULL ,
	subcategory_code     CHAR(5) ,
	subcategory_name     CHARACTER VARYING(50) ,
	category_code        CHAR(5) ,
	category_name        CHARACTER VARYING(50) ,
	CONSTRAINT pk_product_dim PRIMARY KEY (product_code)
);

------------------------------------------------------------------------------------------------
--
-- Create table tb_product_err
--
------------------------------------------------------------------------------------------------

CREATE TABLE sale_stg.tb_product_err
(
	product_code         CHAR(5) NOT NULL,
	error_timestamp      TIMESTAMP(6) NOT NULL ,
	error_code           TEXT ,
	error_message        TEXT ,
	CONSTRAINT pk_product_err PRIMARY KEY (product_code, error_timestamp)
);


------------------------------------------------------------------------------------------------
--
-- Create view vw_product_stg
--
------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW sale_stg.vw_product_stg AS
/* 
 *  Vista: sale_stg.vw_product_stg
 *  Autor: Alexandre Pereiras Magariños
 *  Fecha creación: 2017-11-01
 *  Versión: 1.0
 *
 *  Descripción: Vista que proporciona los detalles de productos que han 
 *               sufrido cambios, o productos cuya categoría o subcategoría
 *               ha sufrido cambios.
 */
-- Seleccionamos los productos, y sus subcategorias y categorias, asociados 
-- a categorias que han experimentado cambios (nuevas o actualizaciones) en los ultimos 10 minutos
SELECT 
  tb_product_cdc.product_code,
  tb_product_cdc.product_name,
  tb_product_cdc.price,
  tb_category_cdc.category_code,
  tb_category_cdc.category_name,
  tb_subcategory_cdc.subcategory_code,
  tb_subcategory_cdc.subcategory_name
FROM 
  sale_cdc.tb_product_cdc
LEFT OUTER JOIN sale_cdc.tb_subcategory_cdc  ON 
  tb_subcategory_cdc.subcategory_code = tb_product_cdc.subcategory_code
LEFT OUTER JOIN sale_cdc.tb_category_cdc ON
  tb_category_cdc.category_code = tb_subcategory_cdc.category_code
WHERE 
 (
    -- 600 segundos son 10 minutos
    EXTRACT(EPOCH FROM (current_timestamp::timestamp - tb_product_cdc.operation_timestamp::timestamp)) <= 600 OR
    EXTRACT(EPOCH FROM (current_timestamp::timestamp - tb_subcategory_cdc.operation_timestamp::timestamp)) <= 600 OR
    EXTRACT(EPOCH FROM (current_timestamp::timestamp - tb_category_cdc.operation_timestamp::timestamp)) <= 600
) 
ORDER BY
  tb_product_cdc.product_code
;

------------------------------------------------------------------------------------------------
--
-- Create sp_load_product_dim 
--
------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION sale_dw.sp_load_product_dim() 
RETURNS void AS 
$$
/* 
 *  Procedimiento: sp_load_product_dim
 *  Autor: Alexandre Pereiras Magariños
 *  Fecha creación: 2017-11-01
 *  Versión: 1.0
 *  Parámetros:  ninguno
 *
 *  Descripción: Procedimiento que cargará en la tabla tb_product_dim aquellos productos
 *               de las tablas CDC como parte de una carga incremental. La lista de productos
 *               que necesitan ser modificados se obtiene de la vista sale_stg.vw_product_stg
 *
 *
 */
DECLARE
  
  v_row_product_stg    sale_stg.vw_product_stg%rowtype;
  v_row_product_dim    sale_dw.tb_product_dim%rowtype;

  v_err_message        text;
  v_returned_sqlstate  text;
    
BEGIN 

  -- Iterar la lista de productos a partir de la vista sale_stg.vw_product_stg
  FOR v_row_product_stg IN 
    SELECT vw_product_stg.product_code,
           vw_product_stg.product_name,
           vw_product_stg.price,
           vw_product_stg.category_code,
           vw_product_stg.category_name,
           vw_product_stg.subcategory_code,
           vw_product_stg.subcategory_name
      FROM sale_stg.vw_product_stg  
    LOOP

  BEGIN
   
    -- Asignamos los detalles de producto a la variable de tipo registro para insertar/actualizar
    v_row_product_dim.product_code := v_row_product_stg.product_code;
    v_row_product_dim.product_name := v_row_product_stg.product_name;
    v_row_product_dim.price := v_row_product_stg.price;
    v_row_product_dim.category_code := v_row_product_stg.category_code;
    v_row_product_dim.category_name := v_row_product_stg.category_name;
    v_row_product_dim.subcategory_code := v_row_product_stg.subcategory_code;
    v_row_product_dim.subcategory_name := v_row_product_stg.subcategory_name;
        
    BEGIN
	  -- Intentamos insertar valores en la dimension de productos dentro de un nuevo bloque 
      INSERT INTO sale_dw.tb_product_dim SELECT v_row_product_dim.*;

      -- Si la fila existe, intentamos actualizar
      EXCEPTION 
        WHEN unique_violation THEN
        UPDATE 
               sale_dw.tb_product_dim
           SET (product_name, price, category_code, category_name, subcategory_code, subcategory_name) = 
                 (v_row_product_dim.product_name, v_row_product_dim.price, v_row_product_dim.category_code, v_row_product_dim.category_name, v_row_product_dim.subcategory_code, v_row_product_dim.subcategory_name) 
          WHERE 
               product_code = v_row_product_dim.product_code; 

        -- Si hay algun problema con la actualizacion, insertamos detalles en la tabla de errores       
        WHEN others THEN
          GET STACKED DIAGNOSTICS v_err_message = MESSAGE_TEXT,
                                  v_returned_sqlstate = RETURNED_SQLSTATE;
          INSERT INTO sale_stg.tb_product_err VALUES (v_row_product_stg.product_code, current_timestamp, v_returned_sqlstate, v_err_message); 
    END;
    
    -- Si existe algun problema al capturar datos de productos, subcategorias o categorias
    -- Insertar en la tabla de errores utilizando GET STACKED DIAGNOSTICS
    -- Continuamos con la carga
    EXCEPTION 
	  WHEN others THEN
      GET STACKED DIAGNOSTICS v_err_message = MESSAGE_TEXT,
                              v_returned_sqlstate = RETURNED_SQLSTATE;
      INSERT INTO sale_stg.tb_product_err VALUES (v_row_product_stg.product_code, current_timestamp, v_returned_sqlstate, v_err_message);  
      CONTINUE;
  END;  
    
  END LOOP;  
END;   
$$
LANGUAGE plpgsql;


------------------------------------------------------------------------------------------------
--
-- Create table tb_date_dim
--
------------------------------------------------------------------------------------------------

CREATE TABLE sale_dw.tb_date_dim (
  date_key     INTEGER ,
  day          DATE NOT NULL ,
  day_num      INTEGER NOT NULL ,
  week_day_num INTEGER NOT NULL ,
  week_day_nam CHARACTER VARYING(20) NOT NULL ,
  month_num    INTEGER NOT NULL ,
  month_nam    CHARACTER VARYING(30) NOT NULL ,
  quarter_num  INTEGER NOT NULL ,
  quarter_nam  CHARACTER VARYING(5) NOT NULL , 
  year         INTEGER NOT NULL ,
  CONSTRAINT pk_date_dim PRIMARY KEY (date_key)
);


------------------------------------------------------------------------------------------------
--
-- Create sp_load_date_dim 
--
------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION sale_dw.sp_load_date_dim(p_start_date DATE, p_end_date DATE) 
RETURNS void AS 
$$
/* 
 *  Procedimiento: sp_load_date_dim
 *  Autor: Alexandre Pereiras Magariños
 *  Fecha creación: 2017-11-01
 *  Versión: 1.0
 *  Parámetros:  p_start_date: fecha de inicio
 *               p_end_date: fecha de fin
 *  Descripción: Procedimiento que cargará en la tabla tb_date_dim aquellas fechas
 *               que se encuentre entre p_start_date y p_end_date, ambas incluídas.
 *
 *
 */
DECLARE
  --v_no_records integer;
  v_processing_date p_start_date%type;
  v_start_date      p_start_date%type;
  v_end_date        p_end_date%type;
  v_row_date_dim    sale_dw.tb_date_dim%rowtype;
  
BEGIN 
  -- Initialize variables
  v_start_date := p_start_date;
  v_end_date := p_end_date;
  
  -- If start date is greater than end date, raise exception
  IF v_start_date > v_end_date THEN
    RAISE SQLSTATE 'UOC01';
  END IF;
  
  -- Assign starting date before starting loop
  v_processing_date := v_start_date;
	  
  -- Start with loop 
  LOOP
	  
	  -- Calculate each of the table fields in the row
	  v_row_date_dim.date_key := to_number(to_char(v_processing_date, 'YYYYMMDD'), '99999999');
	  v_row_date_dim.day := v_processing_date;
	  v_row_date_dim.day_num := to_number(to_char(v_processing_date, 'DD'), '99');
	  v_row_date_dim.week_day_num := to_number(to_char(v_processing_date, 'ID'), '9');
	  v_row_date_dim.week_day_nam := trim(to_char(v_processing_date, 'Day'));
	  v_row_date_dim.month_num  := to_number(to_char(v_processing_date, 'MM'), '99');
	  v_row_date_dim.month_nam := trim(to_char(v_processing_date, 'Month'));
	  v_row_date_dim.quarter_num := to_number(to_char(v_processing_date, 'Q'), '9');
	  v_row_date_dim.quarter_nam := 'Q' || to_char(v_processing_date, 'Q');
	  v_row_date_dim.year := to_number(to_char(v_processing_date, 'YYYY'), '9999');
	  
	  -- Block to handle insert/update 
	  BEGIN
	    -- Insert row in the table
	    INSERT INTO sale_dw.tb_date_dim SELECT v_row_date_dim.*;

		EXCEPTION 
          -- If we're trying to insert and find a unique violation, it's because record exists
          -- We need to update instead of insert		
	      WHEN unique_violation THEN
		    -- Creating a new block for updating
		    BEGIN
	          UPDATE sale_dw.tb_date_dim 
  			    SET (day, day_num, week_day_num, week_day_nam, month_num, month_nam, quarter_num, quarter_nam, year) =
			        (v_row_date_dim.day, v_row_date_dim.day_num, v_row_date_dim.week_day_num, v_row_date_dim.week_day_nam, v_row_date_dim.month_num, 
				     v_row_date_dim.month_nam, v_row_date_dim.quarter_num, v_row_date_dim.quarter_nam, v_row_date_dim.year)
               WHERE tb_date_dim.date_key = v_row_date_dim.date_key; 
			  -- If any other exception, raise to the upper level SQLSTATE UOC02
              EXCEPTION WHEN others THEN 
                RAISE SQLSTATE 'UOC02';
            END;				
		  -- If we find another exception, then raise to the upper level SQLSTATE UOC02
          WHEN others THEN
	        RAISE SQLSTATE 'UOC02';
	  END;
	  
	  -- Assign next date
	  v_processing_date := v_processing_date + 1;
	  
	  -- If new date is already greater than the end date, then exit the procedure
	  IF v_processing_date > v_end_date THEN
	    -- Exit loop
	    EXIT;
	  END IF;

  -- End of loop   
  END LOOP;

  -- Capturing general exceptions
  EXCEPTION 
    -- Capturing SQLSTATE UOC01
    WHEN SQLSTATE 'UOC01' THEN
      RAISE EXCEPTION 'Exception: start date = % is greater than end date = %. Error code = %', v_start_date, v_end_date, SQLSTATE; 	
	-- Capturing SQLSTATE UOC02
	WHEN SQLSTATE 'UOC02' THEN  
      RAISE EXCEPTION 'Exception: there is an error in the insert/update of date = %. Error code = %', v_processing_date, SQLSTATE; 
    -- If we find another exception, then raise to the upper level with the same message
    WHEN others THEN
	  RAISE EXCEPTION 'Exception: it’s not possible to load dates between start date = % and end date = %. Error code = %', v_start_date, v_end_date, SQLSTATE;

END;   
$$
LANGUAGE plpgsql;

-- Cargar datos fechas
SELECT * FROM sale_dw.sp_load_date_dim('2015-01-01', '2018-12-31');



