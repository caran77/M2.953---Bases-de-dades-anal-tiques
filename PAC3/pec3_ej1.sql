----------------------------------------------------------------------------------------------
--
-- Drop tables (and related sequences)
--
----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS sale_dw.tb_product_dim;
----------------------------------------------------------------------------------------------
--
-- Create sequences
--
----------------------------------------------------------------------------------------------
CREATE SEQUENCE sale_dw.seq_product_key INCREMENT BY 1 START WITH 1 NO CYCLE;
------------------------------------------------------------------------------------------------
--
-- Create table tb_product_dim
--
------------------------------------------------------------------------------------------------
CREATE TABLE sale_dw.tb_product_dim
(
	product_key			 INTEGER NOT NULL DEFAULT nextval('sale_dw.seq_product_key'),
	product_code         CHAR(5) NOT NULL ,
	product_name         CHARACTER VARYING(50) NOT NULL ,
	price                NUMERIC(12,2) NOT NULL ,
	subcategory_code     CHAR(5) ,
	subcategory_name     CHARACTER VARYING(50) ,
	category_code        CHAR(5) ,
	category_name        CHARACTER VARYING(50) ,
	start_date			 TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,  
	end_date 			 TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT pk_product_dim PRIMARY KEY (product_key)
);
--
-- Modify the sequence
--
ALTER SEQUENCE sale_dw.seq_product_key OWNED BY sale_dw.tb_product_dim.product_key;
--
-- Creation of the alternative (unique key) key
-- First, we create the unique index; then, the key associated
--
CREATE UNIQUE INDEX idx_product_code_start_date_dim ON sale_dw.tb_product_dim (product_code, start_date);
--
ALTER TABLE sale_dw.tb_product_dim 
ADD CONSTRAINT uk_product_code_start_date_dim 
UNIQUE USING INDEX idx_product_code_start_date_dim;
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
    
  v_product_key			sale_dw.tb_product_dim.product_key%type;
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
	v_row_product_dim.start_date := to_timestamp('1900-01-01 00.00:00', 'YYYY-MM-DD HH24.MI:SS');
	v_row_product_dim.end_date := to_timestamp('4000-01-01 00.00:00', 'YYYY-MM-DD HH24.MI:SS');
        
    BEGIN
	  -- Si ya existe el registro en la tabla, hay que historificar
	  -- Updateamos el registro anterior y modificamos la fecha de inicio del nuevo
	  SELECT	product_key 
	  INTO 		v_product_key 
	  FROM 		sale_dw.tb_product_dim pro 
	  WHERE 	pro.product_code 	= 	v_row_product_dim.product_code
	   AND		pro.end_date		=	to_timestamp('4000-01-01 00.00:00', 'YYYY-MM-DD HH24.MI:SS');
	  --	   
	  IF FOUND THEN
	  	UPDATE	sale_dw.tb_product_dim pro 
		SET		pro.end_date	=	now()
		WHERE	pro.product_key	=	v_product_key
		 AND	pro.end_date	=	to_timestamp('4000-01-01 00.00:00', 'YYYY-MM-DD HH24.MI:SS');
		--
		v_row_product_dim.start_date := now();
	  END IF;
	  -- Intentamos insertar valores en la dimension de productos dentro de un nuevo bloque 
      INSERT INTO sale_dw.tb_product_dim SELECT v_row_product_dim.*;

    -- La fila no debería existir nunca, ya que creamos una PK para cada registro
    -- Podría fallar la UK; si es así, lo tratamos como otro error cualquiera (ya no se hace el update)
    EXCEPTION 
        -- Si hay algun problema con la inserción, insertamos detalles en la tabla de errores       
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
