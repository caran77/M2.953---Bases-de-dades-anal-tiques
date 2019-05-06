----------------------------------------------------------------------------------------------
--
-- Drop tables
--
----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS sale_dw.tb_order_line_fact;
----------------------------------------------------------------------------------------------
--
-- Create tables
--
----------------------------------------------------------------------------------------------
CREATE TABLE sale_dw.tb_order_line_fact
(
	order_number	     CHAR(10) NOT NULL,
	order_line_number    INTEGER NOT NULL,
	order_date_key       INTEGER NOT NULL,
	product_key          INTEGER NOT NULL,
	quantity			 INTEGER,
	unit_price			 NUMERIC(12,2) NOT NULL,
	value_amt		     NUMERIC(18,2) NOT NULL,
	created_timestamp	 TIMESTAMP(6) WITHOUT TIME ZONE,
	updated_timestamp	 TIMESTAMP(6) WITHOUT TIME ZONE,
	CONSTRAINT pk_order_line_fact PRIMARY KEY (order_number, order_line_number)
);
----------------------------------------------------------------------------------------------
--
-- Foreign keys
--
----------------------------------------------------------------------------------------------
ALTER TABLE sale_dw.tb_order_line_fact ADD CONSTRAINT fk_order_line_fact_date_dim FOREIGN KEY (order_date_key) REFERENCES Sale_dw.tb_date_dim (date_key);
ALTER TABLE sale_dw.tb_order_line_fact ADD CONSTRAINT fk_order_line_fact_product_dim FOREIGN KEY (product_key) REFERENCES Sale_dw.tb_product_dim (product_key);
----------------------------------------------------------------------------------------------
--
-- View to get active products
--
----------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW sale_stg.vw_current_products AS
	with current_products AS (
		SELECT	pro.product_code,
				pro.product_key
		FROM	sale_dw.tb_product_dim	pro
		WHERE	pro.end_date	=	to_timestamp('4000-01-01 00.00:00', 'YYYY-MM-DD HH24.MI:SS')
	) 	SELECT	ord.order_number				order_number,
				ord.order_date					order_date,
				lin.order_line_number			order_line_number,
				pro.product_key					product_key,
				lin.quantity					quantity,
				lin.unit_price					unit_price,
				lin.unit_price * lin.quantity	value_amt
		FROM	sale_cdc.tb_order_cdc		ord
		JOIN	sale_cdc.tb_order_line_cdc	lin ON (
				ord.order_number = lin.order_number
		)
		JOIN	current_products pro on (
				lin.product_code	=	pro.product_code
		)
		WHERE	lin.operation != 'D';	
----------------------------------------------------------------------------------------------
--
-- Procedure tb_order_line_fact
--
----------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sale_dw.tb_order_line_fact () as
$$
DECLARE
	v_row_product	sale_stg.vw_current_products%rowtype;
	v_error			varchar(2000);	
	v_result		INTEGER;
BEGIN
	-- Validate that all the records exist on parent tables
	SELECT	1
	INTO 	v_result
	FROM	sale_stg.vw_current_products cur
	WHERE	CAST (to_char(cur.order_date, 'YYYYMMDD') AS INTEGER) NOT IN (
		SELECT	dat.date_key
		FROM	sale_dw.tb_date_dim	dat
	)
	OR	cur.product_key NOT IN (
		SELECT 	pro.product_key
		FROM	sale_dw.tb_product_dim pro
	)
	LIMIT 1;
	IF NOT FOUND THEN
		DELETE FROM sale_dw.tb_order_line_fact;
		-- New data
		FOR v_row_product IN (
			SELECT	order_number,
					order_date,
					order_line_number,
					product_key,
					quantity,
					unit_price,
					value_amt
			FROM	sale_stg.vw_current_products
		) LOOP		
			INSERT INTO sale_dw.tb_order_line_fact (
				order_number,
				order_line_number,
				order_date_key,
				product_key,
				quantity,
				unit_price,
				value_amt,
				created_timestamp,
				updated_timestamp
			)VALUES(
				v_row_product.order_number,
				v_row_product.order_line_number,
				CAST ((to_char(v_row_product.order_date, 'YYYYMMDD')) AS INTEGER),
				v_row_product.product_key,
				v_row_product.quantity,
				v_row_product.unit_price,
				v_row_product.value_amt,
				NOW()::timestamp,
				NOW()::timestamp
			);
		END LOOP;
	END IF;				
EXCEPTION
	WHEN OTHERS THEN				
		-- We have to raise the error 
		RAISE EXCEPTION 'Error loading data(%,%), you have available old data', sqlstate, sqlerrm;
END;
$$ LANGUAGE plpgsql;
----------------------------------------------------------------------------------------------
--
-- Execute procedure sale_dw.tb_order_line_fact ()
-- We don't need to control the transaction:
-- 1. If the CALL is OK, it will perform a COMMIT 
-- 2. If the CALL is not OK, it will perform a ROLLBACK 
--
----------------------------------------------------------------------------------------------
CALL sale_dw.tb_order_line_fact ();
