--
-- TB_CATEGORY
--
CREATE OR REPLACE FUNCTION sale.fn_tb_category()  RETURNS TRIGGER AS 
$$
DECLARE
	v_operation		sale_cdc.tb_category_cdc.operation%TYPE := 'D';
	v_mycode		NUMERIC(1);
	v_row			sale_cdc.tb_category_cdc%ROWTYPE;
BEGIN	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	IF TG_OP = 'DELETE' THEN
		v_row := OLD;
	END IF;
	IF TG_OP IN ('INSERT', 'UPDATE', 'DELETE') THEN				  			
		v_operation := SUBSTR(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 1 INTO v_mycode FROM sale_cdc.tb_category_cdc CAT WHERE CAT.category_code = V_ROW.category_code;
		--
		IF FOUND THEN
			--
			-- If the row exists, we update it
			--
			UPDATE  sale_cdc.tb_category_cdc	CAT
			SET  	category_name			=	V_ROW.category_name,
					created_by_user			=	V_ROW.created_by_user,
					created_date			=	V_ROW.created_date,
					updated_date			=	V_ROW.updated_date,
					operation				=	v_operation,
					user_id 				= 	CURRENT_USER,
					operation_timestamp		=	now()::TIMESTAMP
			WHERE	CAT.category_code		=	V_ROW.category_code;		
		ELSE
			--
			-- If the row not exists, we insert it
			--		
			INSERT INTO sale_cdc.tb_category_cdc (
				category_code,
				category_name,
				created_by_user,
				created_date,
				updated_date,
				operation,
				user_id,
				operation_timestamp
			) VALUES (
				V_ROW.category_code,
				V_ROW.category_name,
				V_ROW.created_by_user,
				V_ROW.created_date,
				V_ROW.updated_date,
				v_operation,
				CURRENT_USER,
				now()::TIMESTAMP			
			);
		END IF;			
    END IF;                
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tb_category_auditory on sale.tb_category;

CREATE TRIGGER tb_category_auditory 
	AFTER INSERT OR UPDATE OR DELETE ON sale.tb_category
	FOR EACH ROW EXECUTE FUNCTION sale.fn_tb_category();
	
--
-- TB_CLIENT
--
CREATE OR REPLACE FUNCTION sale.fn_tb_client()  RETURNS TRIGGER AS 
$$
DECLARE
	v_operation		sale_cdc.tb_client_cdc.operation%TYPE := 'D';
	v_mycode		numeric(1);
	v_row			sale_cdc.tb_client_cdc%ROWTYPE;
BEGIN	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	IF TG_OP = 'DELETE' THEN
		v_row := OLD;
	END IF;
	IF TG_OP IN ('INSERT', 'UPDATE', 'DELETE') THEN				  			
		v_operation := SUBSTR(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 1 INTO v_mycode FROM sale_cdc.tb_client_cdc CAT WHERE CAT.client_code = V_ROW.client_code;
		--
		IF FOUND THEN
			--
			-- If the row exists, we update it
			--
			UPDATE  sale_cdc.tb_client_cdc	CLI
			SET  	client_name				=	V_ROW.client_name,
					address					=	V_ROW.address,
					city					=	V_ROW.city,
					country					=	V_ROW.country,
					contact_email			=	V_ROW.contact_email,
					phone					=	V_ROW.phone,
					parent_client_code		=	V_ROW.parent_client_code,
					created_by_user			=	V_ROW.created_by_user,
					created_date			=	V_ROW.created_date,
					updated_date			=	V_ROW.updated_date,
					operation				=	v_operation,
					user_id 				= 	CURRENT_USER,
					operation_timestamp		=	now()::TIMESTAMP
			WHERE	CLI.client_code			=	V_ROW.client_code;		
		ELSE
			--
			-- If the row not exists, we insert it
			--		
			INSERT INTO sale_cdc.tb_client_cdc (
				client_code,
				client_name,
				address,
				city,
				country,
				contact_email,
				phone,
				parent_client_code,
				created_by_user,
				created_date,
				updated_date,
				operation,
				user_id,
				operation_timestamp
			) VALUES (
				V_ROW.client_code,
				V_ROW.client_name,
				V_ROW.address,
				V_ROW.city,
				V_ROW.country,
				V_ROW.contact_email,
				V_ROW.phone,
				V_ROW.parent_client_code,
				V_ROW.created_by_user,
				V_ROW.created_date,
				V_ROW.updated_date,
				v_operation,
				CURRENT_USER,
				now()::TIMESTAMP			
			);
		END IF;			
    END IF;                
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tb_client_auditory on sale.tb_client;

CREATE TRIGGER tb_client_auditory 
	AFTER INSERT OR UPDATE OR DELETE ON sale.tb_client
	FOR EACH ROW EXECUTE FUNCTION sale.fn_tb_client();	
	
--
-- TB_ORDER
--
CREATE OR REPLACE FUNCTION sale.fn_tb_order()  returns TRIGGER AS 
$$
DECLARE
	v_operation		sale_cdc.tb_order_cdc.operation%TYPE := 'D';
	v_mycode		numeric(1);
	v_row			sale_cdc.tb_order_cdc%ROWTYPE;
BEGIN	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	IF TG_OP = 'DELETE' THEN
		v_row := OLD;
	END IF;
	IF TG_OP IN ('INSERT', 'UPDATE', 'DELETE') THEN				  			
		v_operation := SUBSTR(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 1 INTO v_mycode FROM sale_cdc.tb_order_cdc ORD WHERE ORD.order_number = V_ROW.order_number;
		--
		IF FOUND THEN
			--
			-- If the row exists, we update it
			--
			UPDATE  sale_cdc.tb_order_cdc	ORD
			SET  	client_code				=	V_ROW.client_code,
					order_date				=	V_ROW.order_date,
					delivery_date			=	V_ROW.delivery_date,
					reception_date			=	V_ROW.reception_date,
					created_by_user			=	V_ROW.created_by_user,
					created_date			=	V_ROW.created_date,
					updated_date			=	V_ROW.updated_date,
					operation				=	v_operation,
					user_id 				= 	CURRENT_USER,
					operation_timestamp		=	now()::TIMESTAMP
			WHERE	ORD.order_number		=	V_ROW.order_number;		
		ELSE
			--
			-- If the row not exists, we insert it
			--		
			INSERT INTO sale_cdc.tb_order_cdc (
				order_number,
				client_code,
				order_date,
				delivery_date,
				reception_date,
				created_by_user,
				created_date,
				updated_date,
				operation,
				user_id,
				operation_timestamp
			) VALUES (
				V_ROW.order_number,
				V_ROW.client_code,
				V_ROW.order_date,
				V_ROW.delivery_date,
				V_ROW.reception_date,
				V_ROW.created_by_user,
				V_ROW.created_date,
				V_ROW.updated_date,
				v_operation,
				CURRENT_USER,
				now()::TIMESTAMP			
			);
		END IF;			
    END IF;                
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tb_order_auditory ON sale.tb_order;

CREATE TRIGGER tb_order_auditory 
	AFTER INSERT OR UPDATE OR DELETE ON sale.tb_order
	FOR EACH ROW EXECUTE FUNCTION sale.fn_tb_order();	
	
--
-- TB_ORDER_LINE
--
CREATE OR REPLACE FUNCTION sale.fn_tb_order_line()  RETURNS TRIGGER AS 
$$
DECLARE
	v_operation		sale_cdc.tb_order_line_cdc.operation%TYPE := 'D';
	v_mycode		numeric(1);
	v_row			sale_cdc.tb_order_line_cdc%ROWTYPE;
BEGIN	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	IF TG_OP = 'DELETE' THEN
		v_row := OLD;
	END IF;
	IF TG_OP IN ('INSERT', 'UPDATE', 'DELETE') THEN				  			
		v_operation := SUBSTR(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 	1 
		INTO 	v_mycode 
		FROM 	sale_cdc.tb_order_line_cdc ORD 
		WHERE 	ORD.order_number 		= 	V_ROW.order_number
		 AND	ORD.order_line_number	=	V_ROW.order_line_number;
		--
		IF FOUND THEN
			--
			-- If the row exists, we update it
			--
			UPDATE  sale_cdc.tb_order_line_cdc	ORD
			SET  	product_code			=	V_ROW.product_code,
					quantity				=	V_ROW.quantity,
					unit_price				=	V_ROW.unit_price,					
					created_by_user			=	V_ROW.created_by_user,
					created_date			=	V_ROW.created_date,
					updated_date			=	V_ROW.updated_date,
					operation				=	v_operation,
					user_id 				= 	CURRENT_USER,
					operation_timestamp		=	now()::TIMESTAMP
			WHERE	ORD.order_number		=	V_ROW.order_number
			 AND	ORD.order_line_number	=	V_ROW.order_line_number;
		ELSE
			--
			-- If the row not exists, we insert it
			--		
			INSERT INTO sale_cdc.tb_order_line_cdc (
				order_number,
			 	order_line_number,
				product_code,
				quantity,
				unit_price,
				created_by_user,
				created_date,
				updated_date,
				operation,
				user_id,
				operation_timestamp
			) VALUES (
				V_ROW.order_number,
			 	V_ROW.order_line_number,				
				V_ROW.product_code,
				V_ROW.quantity,
				V_ROW.unit_price,
				V_ROW.created_by_user,
				V_ROW.created_date,
				V_ROW.updated_date,
				v_operation,
				CURRENT_USER,
				now()::TIMESTAMP			
			);
		END IF;			
    END IF;                
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tb_order_line_auditory ON sale.tb_order_line;

CREATE TRIGGER tb_order_line_auditory 
	AFTER INSERT OR UPDATE OR DELETE ON sale.tb_order_line
	FOR EACH ROW EXECUTE FUNCTION sale.fn_tb_order_line();	
	
--
-- TB_PRODUCT
--
CREATE OR REPLACE FUNCTION sale.fn_tb_product()  returns TRIGGER AS 
$$
DECLARE
	v_operation		sale_cdc.tb_product_cdc.operation%TYPE := 'D';
	v_mycode		numeric(1);
	v_row			sale_cdc.tb_product_cdc%ROWTYPE;
BEGIN	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	IF TG_OP = 'DELETE' THEN
		v_row := OLD;
	END IF;
	IF TG_OP in ('INSERT', 'UPDATE', 'DELETE') THEN				  			
		v_operation := SUBSTR(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 	1 
		INTO 	v_mycode 
		FROM 	sale_cdc.tb_product_cdc PRO 
		WHERE 	PRO.product_code 		= 	V_ROW.product_code;
		--
		IF FOUND THEN
			--
			-- If the row exists, we update it
			--
			UPDATE  sale_cdc.tb_product_cdc	PRO
			SET  	subcategory_code		=	V_ROW.subcategory_code,
					product_name			=	V_ROW.product_name,					
					price					=	V_ROW.price,
					created_by_user			=	V_ROW.created_by_user,
					created_date			=	V_ROW.created_date,
					updated_date			=	V_ROW.updated_date,
					operation				=	v_operation,
					user_id 				= 	CURRENT_USER,
					operation_timestamp		=	now()::TIMESTAMP
			WHERE	product_code			=	V_ROW.product_code;
		ELSE
			--
			-- If the row not exists, we insert it
			--		
			INSERT INTO sale_cdc.tb_product_cdc (
				product_code,
			 	subcategory_code,
				product_name,
				price,
				created_by_user,
				created_date,
				updated_date,
				operation,
				user_id,
				operation_timestamp
			) VALUES (
				V_ROW.product_code,
			 	V_ROW.subcategory_code,
				V_ROW.product_name,
				V_ROW.price,
				V_ROW.created_by_user,
				V_ROW.created_date,
				V_ROW.updated_date,
				v_operation,
				CURRENT_USER,
				now()::TIMESTAMP			
			);
		END IF;			
    END IF;                
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tb_product_auditory ON sale.tb_product;

CREATE TRIGGER tb_product_auditory 
	AFTER INSERT OR UPDATE OR DELETE ON sale.tb_product
	FOR EACH ROW EXECUTE FUNCTION sale.fn_tb_product();		
	
--
-- TB_SUBCATEGORY
--
CREATE OR REPLACE FUNCTION sale.fn_tb_subcategory()  returns TRIGGER AS 
$$
DECLARE
	v_operation		sale_cdc.tb_subcategory_cdc.operation%TYPE := 'D';
	v_mycode		numeric(1);
	v_row			sale_cdc.tb_subcategory_cdc%ROWTYPE;
BEGIN	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	IF TG_OP = 'DELETE' THEN
		v_row := OLD;
	END IF;
	IF TG_OP IN ('INSERT', 'UPDATE', 'DELETE') THEN				  			
		v_operation := SUBSTR(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 	1 
		INTO 	v_mycode 
		FROM 	sale_cdc.tb_subcategory_cdc PRO 
		WHERE 	PRO.subcategory_code	= 	V_ROW.subcategory_code;
		--
		IF FOUND THEN
			--
			-- If the row exists, we update it
			--
			UPDATE  sale_cdc.tb_subcategory_cdc	SUB
			SET  	category_code			=	V_ROW.category_code,					
					subcategory_name		=	V_ROW.subcategory_name,
					created_by_user			=	V_ROW.created_by_user,
					created_date			=	V_ROW.created_date,
					updated_date			=	V_ROW.updated_date,
					operation				=	v_operation,
					user_id 				= 	CURRENT_USER,
					operation_timestamp		=	now()::TIMESTAMP
			WHERE	subcategory_code		=	V_ROW.subcategory_code;
		ELSE
			--
			-- If the row not exists, we insert it
			--		
			INSERT INTO sale_cdc.tb_subcategory_cdc (
				subcategory_code,
			 	category_code,
				subcategory_name,
				created_by_user,
				created_date,
				updated_date,
				operation,
				user_id,
				operation_timestamp
			) VALUES (
				V_ROW.subcategory_code,
			 	V_ROW.category_code,
				V_ROW.subcategory_name,
				V_ROW.created_by_user,
				V_ROW.created_date,
				V_ROW.updated_date,
				v_operation,
				CURRENT_USER,
				now()::TIMESTAMP			
			);
		END IF;			
    END IF;                
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tb_subcategory_auditory ON sale.tb_subcategory;

CREATE TRIGGER tb_subcategory_auditory 
	AFTER INSERT OR UPDATE OR DELETE ON sale.tb_subcategory
	FOR EACH ROW EXECUTE FUNCTION sale.fn_tb_subcategory();	