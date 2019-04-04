----------------------------------------------------------------------------------------------
--
-- Create schemas
--
----------------------------------------------------------------------------------------------
create schema if not exists surt_dw;

create schema if not exists surt_stg;

create schema if not exists sale_stg;

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
	error_timestamp		timestamp (6) without time zone,
	error_code			text,
	error_message		text,    	
	CONSTRAINT pk_product_err PRIMARY KEY (product_code, error_timestamp)
);

----------------------------------------------------------------------------------------------
--
-- Create view of products
--
----------------------------------------------------------------------------------------------

drop view if exists surt_stg.v_product_scat_cat;

create view surt_stg.v_product_scat_cat as
	select	PRO.product_code,
			PRO.product_name,
			PRO.price,
			SUB.subcategory_code,
			SUB.subcategory_name,
			CAT.category_code,
			CAT.category_name
	from	sale_cdc.tb_product_cdc				PRO
	left outer join sale_cdc.tb_subcategory_cdc	SUB on (
		PRO.subcategory_code	=	SUB.subcategory_code		
	)
	left outer join sale_cdc.tb_category_cdc	CAT on (
		SUB.category_code		=	CAT.category_code
	)
	where	PRO.operation_timestamp >= now() - (10 * interval '1 minute');
;
----------------------------------------------------------------------------------------------
--
-- Procedure sp_load_one_product
--
----------------------------------------------------------------------------------------------

drop procedure if exists sale_stg.sp_load_one_product;

create procedure sale_stg.sp_load_one_product (
	p_product_code		surt_dw.tb_product_dim.product_code%type,
	p_product_name 		surt_dw.tb_product_dim.product_name%type,
	p_price				surt_dw.tb_product_dim.price%type,
	p_subcategory_code	surt_dw.tb_product_dim.subcategory_code%type,
	p_subcategory_name	surt_dw.tb_product_dim.subcategory_name%type,
	p_category_code		surt_dw.tb_product_dim.category_code%type,
	p_category_name		surt_dw.tb_product_dim.category_name%type
) as
$$
declare
	v_mycode		numeric(1);
begin
	SELECT 1 INTO v_mycode FROM surt_dw.tb_product_dim DAD WHERE DAD.product_code = p_product_code;
	--		
	if FOUND then
		update	surt_dw.tb_product_dim
		set		product_name		=	p_product_name,
				price				=	p_price,
				subcategory_code	=	p_subcategory_code,
				subcategory_name    =	p_subcategory_name,
				category_code		=	p_category_code,
				category_name		=	p_category_name
		where	product_code		=	p_product_code;
	else
		insert into surt_dw.tb_product_dim (
			product_code,
			product_name,
			price,
			subcategory_code,
			subcategory_name,    
			category_code,
			category_name
		)values(
			p_product_code,
			p_product_name,
			p_price,
			p_subcategory_code,
			p_subcategory_name,    
			p_category_code,
			p_category_name			
		);	
	end if;
exception
	when others then
		insert into surt_stg.tb_product_err (
			product_code,
			error_timestamp,
			error_code,
			error_message
		) values (
			p_product_code,
			now()::timestamp,
			SQLSTATE,
			SQLERRM					
		);
end;
$$ language plpgsql;

--
-- Modify category and subcategory
--

drop procedure if exists sale_stg.sp_update_category;

create procedure sale_stg.sp_update_category()  as 
$$
declare
	c_category cursor for
		select	CAT.category_code,
				CAT.category_name
		from	sale_cdc.tb_category_cdc	CAT	
		where	CAT.operation_timestamp >= now() - (10 * interval '1 minute');
	c_product cursor (
		p_category_code	surt_dw.tb_product_dim.category_code%type
	) for			 
		select	PRO.product_code
		from	surt_dw.tb_product_dim	PRO
		where	PRO.category_code	=	p_category_code;
begin
	for v_category in c_category loop
		for v_product in c_product (v_category.category_code) loop
			begin
				update	surt_dw.tb_product_dim		PRO
				set		category_name 		=	CAT.category_name
				where	PRO.product_code	=	v_product.product_code;
			exception
				when others then
					insert into surt_stg.tb_product_err (
						product_code,
						error_timestamp,
						error_code,
						error_message
					) values (
						v_product.product_code,
						now()::timestamp,
						SQLSTATE,
						SQLERRM					
					);				
			end;
		end loop;
	end loop;
end;
$$ language plpgsql;

drop procedure if exists sale_stg.sp_update_subcategory;

create procedure sale_stg.sp_update_subcategory()  as 
$$
declare
	c_subcategory cursor for
		select	CAT.subcategory_code,
				CAT.subcategory_name
		from	sale_cdc.tb_subcategory_cdc	CAT	
		where	CAT.operation_timestamp >= now() - (10 * interval '1 minute');
	c_product cursor (
		p_category_code	surt_dw.tb_product_dim.subcategory_code%type
	) for			 
		select	PRO.product_code
		from	surt_dw.tb_product_dim	PRO
		where	PRO.subcategory_code	=	p_category_code;
begin
	for v_subcategory in c_subcategory loop
		for v_product in c_product (v_subcategory.subcategory_code) loop
			begin
				update	surt_dw.tb_product_dim		PRO
				set		subcategory_name 	=	CAT.subcategory_name
				where	PRO.product_code	=	v_product.product_code;
			exception
				when others then
					insert into surt_stg.tb_product_err (
						product_code,
						error_timestamp,
						error_code,
						error_message
					) values (
						v_product.product_code,
						now()::timestamp,
						SQLSTATE,
						SQLERRM					
					);		
			end;						
		end loop;
	end loop;	
end;
$$ language plpgsql;

----------------------------------------------------------------------------------------------
--
-- Procedure sp_load_product_dim
--
----------------------------------------------------------------------------------------------

drop procedure if exists sale_stg.sp_load_product_dim;

create procedure sale_stg.sp_load_product_dim()  as 
$$
declare
	v	record;
	c_product_scat_cat cursor for
		select	DAD.product_code,
				DAD.product_name,
				DAD.price,
				DAD.subcategory_code,
				DAD.subcategory_name,
				DAD.category_code,
				DAD.category_name
		from	surt_stg.v_product_scat_cat DAD;			
begin
	open c_product_scat_cat;
	loop
		fetch c_product_scat_cat into v;   
      	exit when not found;
		call sale_stg.sp_load_one_product (
			p_product_code		=>	V.product_code,
			p_product_name 		=>	V.product_name,
			p_price				=>	V.price,
			p_subcategory_code	=>	V.subcategory_code,
			p_subcategory_name	=>	V.subcategory_name,
			p_category_code		=>	V.category_code,
			p_category_name		=>	V.category_name
		);	
	end loop;
	close c_product_scat_cat;
	commit;
	--
	-- Actualitzem les categories i subcategories
	--
	call sale_stg.sp_update_category();
	call sale_stg.sp_update_subcategory();
end;
$$ language plpgsql;