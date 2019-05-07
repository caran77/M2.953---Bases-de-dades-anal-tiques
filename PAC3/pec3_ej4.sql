--
-- Function to get next monday
--
CREATE OR REPLACE FUNCTION sale_stg.tb_get_next_monday (p_date date) RETURNS date as
$$
DECLARE
	v_date	DATE;
	v_days	INTEGER := 7;
BEGIN
	IF to_char(p_date, 'D') = '2' THEN
		v_days := 0;
	ELSE
		v_days := 7;
	END IF;
	v_date := date_trunc ('week', p_date) + (v_days * INTERVAL '1 day'); 
	RETURN v_date; 
END;
$$ LANGUAGE plpgsql;
--
CREATE OR REPLACE VIEW sale_stg.vw_total_product AS
	SELECT	ord.order_number,
			ord.order_date,
			sale_stg.tb_get_next_monday(p_date => ord.order_date) next_monday,		
			SUM(lin.quantity * lin.unit_price) total_order
	FROM	sale.tb_order		ord
	JOIN	sale.tb_order_line	lin ON (
			ord.order_number	=	lin.order_number
	)
	GROUP BY ord.order_number,
			ord.order_date,
			sale_stg.tb_get_next_monday(p_date => ord.order_date);
--
CREATE OR REPLACE VIEW sale_stg.vw_total_product_week AS 
	SELECT	ord.order_number,
			ord.next_monday, 
			SUM(ord.total_order) OVER (PARTITION BY ord.next_monday) AS total_day,
			ROUND(AVG(ord.total_order) OVER (ORDER BY ord.order_date RANGE BETWEEN 
				UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS acumulative_avg
	FROM	sale_stg.vw_total_product		ord
	ORDER BY ord.order_date;
--
-- Finally we have the data:
-- 1. Order_number: code of the order
-- 2. Next_monday: day of the notification (nex monday after the order; same day if it is monday)
-- 3. Total_day. Total of the week (monday of the notification)
-- 4. Acumulative_avg. Average by order (from the begining)
-- 5. Ratio. Percentage increase over the previous week (first value has not sense, we can't divide by 0)
-- 
SELECT 	pro.order_number,
		pro.next_monday,
		pro.total_day,
		pro.acumulative_avg,
		(pro.total_day-(COALESCE ((	
			select 	pro_in.total_day 
		 	from 	sale_stg.vw_total_product_week pro_in 
		 	where 	pro_in.next_monday 	= 	pro.next_monday - 7 * interval '1 day'
		 	limit 1
		), 1))) / (COALESCE ((	
			select 	pro_in.total_day 
		 	from 	sale_stg.vw_total_product_week pro_in 
		 	where 	pro_in.next_monday 	= 	pro.next_monday - 7 * interval '1 day'
		 	limit 1
		), 1)) * 100 ratio
FROM 	sale_stg.vw_total_product_week	pro;