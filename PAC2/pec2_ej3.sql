----------------------------------------------------------------------------------------------
--
-- Create schemas
--
----------------------------------------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS surt_dw;

CREATE SCHEMA IF NOT EXISTS surt_stg;

CREATE SCHEMA IF NOT EXISTS sale_stg;

----------------------------------------------------------------------------------------------
--
-- Create tables
--
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
-- Create table tb_product_cdc
--
----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS surt_dw.tb_product_dim;

CREATE TABLE surt_dw.tb_product_dim
(
	product_code         CHAR(5) NOT NULL,
	product_name         CHARACTER VARYING(60) NOT NULL,
	price                NUMERIC(12,2) NOT NULL,
	subcategory_code     CHAR(5),
	subcategory_name     CHARACTER VARYING(50),    
	category_code     	CHAR(5),
	category_name     	CHARACTER VARYING(50),    	
	CONSTRAINT pk_product_dim PRIMARY KEY (product_code)
);

----------------------------------------------------------------------------------------------
--
-- Create table tb_product_err
--
----------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS surt_stg.tb_product_err;

CREATE TABLE surt_stg.tb_product_err
(
	product_code      	CHAR(5) NOT NULL,
	error_timestamp		TIMESTAMP (6) WITHOUT TIME ZONE,
	error_code			TEXT,
	error_message		TEXT,    	
	CONSTRAINT pk_product_err PRIMARY KEY (product_code, error_timestamp)
);

----------------------------------------------------------------------------------------------
--
-- Create view of products
--
----------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS surt_stg.v_product_scat_cat;

CREATE VIEW surt_stg.v_product_scat_cat AS
	SELECT	PRO.product_code,
			PRO.product_name,
			PRO.price,
			SUB.subcategory_code,
			SUB.subcategory_name,
			CAT.category_code,
			CAT.category_name
	FROM	sale_cdc.tb_product_cdc				PRO
	LEFT OUTER JOIN sale_cdc.tb_subcategory_cdc	SUB ON (
		PRO.subcategory_code	=	SUB.subcategory_code		
	)
	LEFT OUTER JOIN sale_cdc.tb_category_cdc	CAT ON (
		SUB.category_code		=	CAT.category_code
	)
	WHERE	PRO.operation_timestamp >= now() - (10 * INTERVAL '1 minute');
----------------------------------------------------------------------------------------------
--
-- Procedure sp_load_one_product
--
----------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS sale_stg.sp_load_one_product;

CREATE PROCEDURE sale_stg.sp_load_one_product (
	p_product_code		surt_dw.tb_product_dim.product_code%TYPE,
	p_product_name 		surt_dw.tb_product_dim.product_name%TYPE,
	p_price				surt_dw.tb_product_dim.price%TYPE,
	p_subcategory_code	surt_dw.tb_product_dim.subcategory_code%TYPE,
	p_subcategory_name	surt_dw.tb_product_dim.subcategory_name%TYPE,
	p_category_code		surt_dw.tb_product_dim.category_code%TYPE,
	p_category_name		surt_dw.tb_product_dim.category_name%TYPE
) as
$$
declare
	v_mycode		numeric(1);
begin
	SELECT 1 INTO v_mycode FROM surt_dw.tb_product_dim DAD WHERE DAD.product_code = p_product_code;
	--		
	IF FOUND THEN
		UPDATE	surt_dw.tb_product_dim
		SET		product_name		=	p_product_name,
				price				=	p_price,
				subcategory_code	=	p_subcategory_code,
				subcategory_name    =	p_subcategory_name,
				category_code		=	p_category_code,
				category_name		=	p_category_name
		WHERE	product_code		=	p_product_code;
	ELSE
		INSERT INTO surt_dw.tb_product_dim (
			product_code,
			product_name,
			price,
			subcategory_code,
			subcategory_name,    
			category_code,
			category_name
		) VALUES (
			p_product_code,
			p_product_name,
			p_price,
			p_subcategory_code,
			p_subcategory_name,    
			p_category_code,
			p_category_name			
		);	
	END IF;
EXCEPTION
	WHEN OTHERS THEN
		INSERT INTO surt_stg.tb_product_err (
			product_code,
			error_timestamp,
			error_code,
			error_message
		) VALUES (
			p_product_code,
			now()::TIMESTAMP,
			SQLSTATE,
			SQLERRM					
		);
END;
$$ LANGUAGE plpgsql;

--
-- Modify category and subcategory
--

DROP PROCEDURE IF EXISTS sale_stg.sp_update_category;

CREATE PROCEDURE sale_stg.sp_update_category()  AS 
$$
DECLARE
	c_category CURSOR FOR
		SELECT	CAT.category_code,
				CAT.category_name
		FROM	sale_cdc.tb_category_cdc	CAT	
		WHERE	CAT.operation_timestamp >= now() - (10 * INTERVAL '1 minute');
	c_product CURSOR (
		p_category_code	surt_dw.tb_product_dim.category_code%TYPE
	) FOR			 
		SELECT	PRO.product_code
		FROM	surt_dw.tb_product_dim	PRO
		WHERE	PRO.category_code	=	p_category_code;
BEGIN
	FOR v_category IN c_category LOOP
		FOR v_product IN c_product (v_category.category_code) LOOP
			BEGIN
				UPDATE	surt_dw.tb_product_dim		PRO
				SET		category_name 		=	CAT.category_name
				WHERE	PRO.product_code	=	v_product.product_code;
			EXCEPTION
				WHEN OTHERS THEN
					INSERT INTO surt_stg.tb_product_err (
						product_code,
						error_timestamp,
						error_code,
						error_message
					) VALUES (
						v_product.product_code,
						now()::TIMESTAMP,
						SQLSTATE,
						SQLERRM					
					);				
			END;
		END LOOP;
	END LOOP;
END;
$$ LANGUAGE plpgsql;

DROP PROCEDURE IF EXISTS sale_stg.sp_update_subcategory;

CREATE PROCEDURE sale_stg.sp_update_subcategory()  AS 
$$
DECLARE
	c_subcategory CURSOR FOR
		SELECT	CAT.subcategory_code,
				CAT.subcategory_name
		FROM	sale_cdc.tb_subcategory_cdc	CAT	
		WHERE	CAT.operation_timestamp >= now() - (10 * INTERVAL '1 minute');
	c_product CURSOR (
		p_category_code	surt_dw.tb_product_dim.subcategory_code%TYPE
	) FOR			 
		SELECT	PRO.product_code
		FROM	surt_dw.tb_product_dim	PRO
		WHERE	PRO.subcategory_code	=	p_category_code;
BEGIN
	FOR v_subcategory IN c_subcategory LOOP
		FOR v_product IN c_product (v_subcategory.subcategory_code) LOOP
			BEGIN
				UPDATE	surt_dw.tb_product_dim		PRO
				SET		subcategory_name 	=	CAT.subcategory_name
				WHERE	PRO.product_code	=	v_product.product_code;
			EXCEPTION
				WHEN OTHERS THEN
					INSERT INTO surt_stg.tb_product_err (
						product_code,
						error_timestamp,
						error_code,
						error_message
					) VALUES (
						v_product.product_code,
						now()::TIMESTAMP,
						SQLSTATE,
						SQLERRM					
					);		
			END;						
		END LOOP;
	END LOOP;	
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------
--
-- Procedure sp_load_product_dim
--
----------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS sale_stg.sp_load_product_dim;

CREATE PROCEDURE sale_stg.sp_load_product_dim()  AS 
$$
DECLARE
	v	RECORD;
	c_product_scat_cat CURSOR FOR
		SELECT	DAD.product_code,
				DAD.product_name,
				DAD.price,
				DAD.subcategory_code,
				DAD.subcategory_name,
				DAD.category_code,
				DAD.category_name
		FROM	surt_stg.v_product_scat_cat DAD;			
BEGIN
	OPEN c_product_scat_cat;
	LOOP
		FETCH c_product_scat_cat INTO v;   
      	EXIT WHEN NOT FOUND;
		CALL sale_stg.sp_load_one_product (
			p_product_code		=>	V.product_code,
			p_product_name 		=>	V.product_name,
			p_price				=>	V.price,
			p_subcategory_code	=>	V.subcategory_code,
			p_subcategory_name	=>	V.subcategory_name,
			p_category_code		=>	V.category_code,
			p_category_name		=>	V.category_name
		);	
	END LOOP;
	CLOSE c_product_scat_cat;
	--
	-- Actualitzem les categories i subcategories
	--
	CALL sale_stg.sp_update_category();
	CALL sale_stg.sp_update_subcategory();
    COMMIT;
END;
$$ LANGUAGE plpgsql;