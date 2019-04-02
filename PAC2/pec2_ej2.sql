--
-- TB_CATEGORY
--
create or replace function sale.fn_tb_category()  returns trigger as 
$$
declare
	v_operation		sale_cdc.tb_category_cdc.operation%type := 'D';
	v_mycode		numeric(1);
	v_row			sale_cdc.tb_category_cdc%rowtype;
begin	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	if TG_OP = 'DELETE' then
		v_row := OLD;
	end if;
	if TG_OP in ('INSERT', 'UPDATE', 'DELETE') then				  			
		v_operation := substr(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 1 INTO v_mycode FROM sale_cdc.tb_category_cdc CAT WHERE CAT.category_code = V_ROW.category_code;
		--
		if FOUND then
			--
			-- If the row exists, we update it
			--
			update  sale_cdc.tb_category_cdc	CAT
			set  	category_name			=	V_ROW.category_name,
					created_by_user			=	V_ROW.created_by_user,
					created_date			=	V_ROW.created_date,
					updated_date			=	V_ROW.updated_date,
					operation				=	v_operation,
					user_id 				= 	current_user,
					operation_timestamp		=	now()::timestamp
			where	CAT.category_code		=	V_ROW.category_code;		
		else
			--
			-- If the row not exists, we insert it
			--		
			insert into sale_cdc.tb_category_cdc (
				category_code,
				category_name,
				created_by_user,
				created_date,
				updated_date,
				operation,
				user_id,
				operation_timestamp
			) values (
				V_ROW.category_code,
				V_ROW.category_name,
				V_ROW.created_by_user,
				V_ROW.created_date,
				V_ROW.updated_date,
				v_operation,
				current_user,
				now()::timestamp			
			);
		end if;			
    end if;                
    return null;
end;
$$ language plpgsql;

drop trigger if exists tb_category_auditory on sale.tb_category;

create trigger tb_category_auditory 
	after insert or update or delete on sale.tb_category
	for each row execute function sale.fn_tb_category();
	
--
-- TB_CLIENT
--
create or replace function sale.fn_tb_client()  returns trigger as 
$$
declare
	v_operation		sale_cdc.tb_client_cdc.operation%type := 'D';
	v_mycode		numeric(1);
	v_row			sale_cdc.tb_client_cdc%rowtype;
begin	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	if TG_OP = 'DELETE' then
		v_row := OLD;
	end if;
	if TG_OP in ('INSERT', 'UPDATE', 'DELETE') then				  			
		v_operation := substr(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 1 INTO v_mycode FROM sale_cdc.tb_client_cdc CAT WHERE CAT.client_code = V_ROW.client_code;
		--
		if FOUND then
			--
			-- If the row exists, we update it
			--
			update  sale_cdc.tb_client_cdc	CLI
			set  	client_name				=	V_ROW.client_name,
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
					user_id 				= 	current_user,
					operation_timestamp		=	now()::timestamp
			where	CLI.client_code			=	V_ROW.client_code;		
		else
			--
			-- If the row not exists, we insert it
			--		
			insert into sale_cdc.tb_client_cdc (
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
			) values (
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
				current_user,
				now()::timestamp			
			);
		end if;			
    end if;                
    return null;
end;
$$ language plpgsql;

drop trigger if exists tb_client_auditory on sale.tb_client;

create trigger tb_client_auditory 
	after insert or update or delete on sale.tb_client
	for each row execute function sale.fn_tb_client();	
	
--
-- TB_ORDER
--
create or replace function sale.fn_tb_order()  returns trigger as 
$$
declare
	v_operation		sale_cdc.tb_order_cdc.operation%type := 'D';
	v_mycode		numeric(1);
	v_row			sale_cdc.tb_order_cdc%rowtype;
begin	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	if TG_OP = 'DELETE' then
		v_row := OLD;
	end if;
	if TG_OP in ('INSERT', 'UPDATE', 'DELETE') then				  			
		v_operation := substr(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 1 INTO v_mycode FROM sale_cdc.tb_order_cdc ORD WHERE ORD.order_number = V_ROW.order_number;
		--
		if FOUND then
			--
			-- If the row exists, we update it
			--
			update  sale_cdc.tb_order_cdc	ORD
			set  	client_code				=	V_ROW.client_code,
					order_date				=	V_ROW.order_date,
					delivery_date			=	V_ROW.delivery_date,
					reception_date			=	V_ROW.reception_date,
					created_by_user			=	V_ROW.created_by_user,
					created_date			=	V_ROW.created_date,
					updated_date			=	V_ROW.updated_date,
					operation				=	v_operation,
					user_id 				= 	current_user,
					operation_timestamp		=	now()::timestamp
			where	ORD.order_number		=	V_ROW.order_number;		
		else
			--
			-- If the row not exists, we insert it
			--		
			insert into sale_cdc.tb_order_cdc (
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
			) values (
				V_ROW.order_number,
				V_ROW.client_code,
				V_ROW.order_date,
				V_ROW.delivery_date,
				V_ROW.reception_date,
				V_ROW.created_by_user,
				V_ROW.created_date,
				V_ROW.updated_date,
				v_operation,
				current_user,
				now()::timestamp			
			);
		end if;			
    end if;                
    return null;
end;
$$ language plpgsql;

drop trigger if exists tb_order_auditory on sale.tb_order;

create trigger tb_order_auditory 
	after insert or update or delete on sale.tb_order
	for each row execute function sale.fn_tb_order();	
	
--
-- TB_ORDER_LINE
--
create or replace function sale.fn_tb_order_line()  returns trigger as 
$$
declare
	v_operation		sale_cdc.tb_order_line_cdc.operation%type := 'D';
	v_mycode		numeric(1);
	v_row			sale_cdc.tb_order_line_cdc%rowtype;
begin	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	if TG_OP = 'DELETE' then
		v_row := OLD;
	end if;
	if TG_OP in ('INSERT', 'UPDATE', 'DELETE') then				  			
		v_operation := substr(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 	1 
		INTO 	v_mycode 
		FROM 	sale_cdc.tb_order_line_cdc ORD 
		WHERE 	ORD.order_number 		= 	V_ROW.order_number
		 AND	ORD.order_line_number	=	V_ROW.order_line_number;
		--
		if FOUND then
			--
			-- If the row exists, we update it
			--
			update  sale_cdc.tb_order_line_cdc	ORD
			set  	product_code			=	V_ROW.product_code,
					quantity				=	V_ROW.quantity,
					unit_price				=	V_ROW.unit_price,					
					created_by_user			=	V_ROW.created_by_user,
					created_date			=	V_ROW.created_date,
					updated_date			=	V_ROW.updated_date,
					operation				=	v_operation,
					user_id 				= 	current_user,
					operation_timestamp		=	now()::timestamp
			where	ORD.order_number		=	V_ROW.order_number
			 and	ORD.order_line_number	=	V_ROW.order_line_number;
		else
			--
			-- If the row not exists, we insert it
			--		
			insert into sale_cdc.tb_order_line_cdc (
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
			) values (
				V_ROW.order_number,
			 	V_ROW.order_line_number,				
				V_ROW.product_code,
				V_ROW.quantity,
				V_ROW.unit_price,
				V_ROW.created_by_user,
				V_ROW.created_date,
				V_ROW.updated_date,
				v_operation,
				current_user,
				now()::timestamp			
			);
		end if;			
    end if;                
    return null;
end;
$$ language plpgsql;

drop trigger if exists tb_order_line_auditory on sale.tb_order_line;

create trigger tb_order_line_auditory 
	after insert or update or delete on sale.tb_order_line
	for each row execute function sale.fn_tb_order_line();	
	
--
-- TB_PRODUCT
--
create or replace function sale.fn_tb_product()  returns trigger as 
$$
declare
	v_operation		sale_cdc.tb_product_cdc.operation%type := 'D';
	v_mycode		numeric(1);
	v_row			sale_cdc.tb_product_cdc%rowtype;
begin	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	if TG_OP = 'DELETE' then
		v_row := OLD;
	end if;
	if TG_OP in ('INSERT', 'UPDATE', 'DELETE') then				  			
		v_operation := substr(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 	1 
		INTO 	v_mycode 
		FROM 	sale_cdc.tb_product_cdc PRO 
		WHERE 	PRO.product_code 		= 	V_ROW.product_code;
		--
		if FOUND then
			--
			-- If the row exists, we update it
			--
			update  sale_cdc.tb_product_cdc	PRO
			set  	subcategory_code		=	V_ROW.subcategory_code,
					product_name			=	V_ROW.product_name,					
					price					=	V_ROW.price,
					created_by_user			=	V_ROW.created_by_user,
					created_date			=	V_ROW.created_date,
					updated_date			=	V_ROW.updated_date,
					operation				=	v_operation,
					user_id 				= 	current_user,
					operation_timestamp		=	now()::timestamp
			where	product_code			=	V_ROW.product_code;
		else
			--
			-- If the row not exists, we insert it
			--		
			insert into sale_cdc.tb_product_cdc (
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
			) values (
				V_ROW.product_code,
			 	V_ROW.subcategory_code,
				V_ROW.product_name,
				V_ROW.price,
				V_ROW.created_by_user,
				V_ROW.created_date,
				V_ROW.updated_date,
				v_operation,
				current_user,
				now()::timestamp			
			);
		end if;			
    end if;                
    return null;
end;
$$ language plpgsql;

drop trigger if exists tb_product_auditory on sale.tb_product;

create trigger tb_product_auditory 
	after insert or update or delete on sale.tb_product
	for each row execute function sale.fn_tb_product();		
	
--
-- TB_SUBCATEGORY
--
create or replace function sale.fn_tb_subcategory()  returns trigger as 
$$
declare
	v_operation		sale_cdc.tb_subcategory_cdc.operation%type := 'D';
	v_mycode		numeric(1);
	v_row			sale_cdc.tb_subcategory_cdc%rowtype;
begin	
	--
	-- If the operation is a delete, we have to save the OLD value
	-- If not, we have to save the NEW value
	--
	v_row := NEW;
	if TG_OP = 'DELETE' then
		v_row := OLD;
	end if;
	if TG_OP in ('INSERT', 'UPDATE', 'DELETE') then				  			
		v_operation := substr(TG_OP, 1, 1);
		--
		-- Does the row exists?
		--
		SELECT 	1 
		INTO 	v_mycode 
		FROM 	sale_cdc.tb_subcategory_cdc PRO 
		WHERE 	PRO.subcategory_code	= 	V_ROW.subcategory_code;
		--
		if FOUND then
			--
			-- If the row exists, we update it
			--
			update  sale_cdc.tb_subcategory_cdc	SUB
			set  	category_code			=	V_ROW.category_code,					
					subcategory_name		=	V_ROW.subcategory_name,
					created_by_user			=	V_ROW.created_by_user,
					created_date			=	V_ROW.created_date,
					updated_date			=	V_ROW.updated_date,
					operation				=	v_operation,
					user_id 				= 	current_user,
					operation_timestamp		=	now()::timestamp
			where	subcategory_code		=	V_ROW.subcategory_code;
		else
			--
			-- If the row not exists, we insert it
			--		
			insert into sale_cdc.tb_subcategory_cdc (
				subcategory_code,
			 	category_code,
				subcategory_name,
				created_by_user,
				created_date,
				updated_date,
				operation,
				user_id,
				operation_timestamp
			) values (
				V_ROW.subcategory_code,
			 	V_ROW.category_code,
				V_ROW.subcategory_name,
				V_ROW.created_by_user,
				V_ROW.created_date,
				V_ROW.updated_date,
				v_operation,
				current_user,
				now()::timestamp			
			);
		end if;			
    end if;                
    return null;
end;
$$ language plpgsql;

drop trigger if exists tb_subcategory_auditory on sale.tb_subcategory;

create trigger tb_subcategory_auditory 
	after insert or update or delete on sale.tb_subcategory
	for each row execute function sale.fn_tb_subcategory();	