--Obtenir el codi, Nom i ciutat d'aquells clients que no tenen un telèfon registrat ni una adreça registrada, 
--ordenat descendentment per Nom de client i ascendentment per ciutat

select	CLI.client_code, CLI.client_name, CLI.city
from	sale.tb_client	CLI
where	CLI.phone is null
 and	CLI.address is null
order by CLI.client_name desc, CLI.city asc;

--Obtenir la diferència total entre la suma del valor de la línia de comanda utilitzant el preu unitari de 
--la línia de comanda i la suma del valor de la línia de comanda utilitzant el preu del producte, 
--i el nombre total de productes diferents, per a aquells productes que tenen un preu unitari en la línia de 
--comanda diferent al preu establert en la Taula mestre de productes. 
--La suma del valor de la línia de comanda es calcula multiplicant la quantitat per el preu

select	sum(total_diferencia) total_diferencia,
		count(product_code)		total_productes 
from	(
	with productes_amb_preu_diferent as (
		select	PRO.product_code, PRO.price
		from	sale.tb_product	PRO
		where	exists (
			select	1
			from	sale.tb_order_line	LIN
			where	LIN.product_code	=	PRO.product_code
			 and	LIN.unit_price		!=	PRO.price
		)
	)
		select	sum(LIN.quantity * (LIN.unit_price - PAPD.price)) total_diferencia, PAPD.product_code
		from	productes_amb_preu_diferent	PAPD
		join	sale.tb_order_line			LIN on (
				PAPD.product_code	=	LIN.product_code
		)
		group by PAPD.product_code
) total;
				
--Obtenir el Nom del producte i el seu preu, i el Nom de la categoria i el Nom de la subcategoria 
--associats de tots els productes que existeixin en la Taula mestra de productes, 
--i que no han estat demanats per clients el país dels quals d'origen és diferent a Polònia, 
--ordenat descendentment per preu

with linees_no_de_polonia as (
	select	LIN.product_code
	from	sale.tb_order_line	LIN
	join	sale.tb_order		ORD on (
			LIN.order_number = ORD.order_number
	)
	join	sale.tb_client	CLI on (
			ORD.client_code = CLI.client_code
	)
	where	CLI.country != 'Polonia'
)
select	PRO.product_name, 
		PRO.price,
		CAT.category_name,
		SUP.subcategory_name
from	sale.tb_product	PRO
left outer join sale.tb_subcategory SUP on (
	PRO.subcategory_code = SUP.subcategory_code		
)
left outer join sale.tb_category CAT on (
	SUP.category_code = CAT.category_code
)
 and not exists (
	select	1
	 from	linees_no_de_polonia POL
	 where	POL.product_code = PRO.product_code
) 
order by PRO.price desc;

--Obtenir el Nom de la categoria del producte, el nombre total de línies de comanda i la suma total de la comanda, 
--calculada com la quantitat de la comanda multiplicada per el preu unitari, 
--ordenat ascendentment per Nom de categoria

with total_per_comanda as (
	select	SUM(LIN.quantity * LIN.unit_price) total_comanda, 
		COUNT(*) total_linees,
		ORD.order_number
	from	sale.tb_order_line	LIN
	join	sale.tb_order		ORD on (
		LIN.order_number = ORD.order_number
	)
	group by ORD.order_number
)
	select	CAT.category_name,
			TPC.total_linees,
			TPC.total_comanda
	from	sale.tb_order_line	LIN
	join	sale.tb_order		ORD on (
		LIN.order_number = ORD.order_number
	)
	join	total_per_comanda	TPC on (
		ORD.order_number = TPC.order_number
	)
	join	sale.tb_product	PRO on (
		LIN.product_code	=	PRO.product_code
	)
	left outer join sale.tb_subcategory SUB on (
		PRO.subcategory_code = SUB.subcategory_code
	)
	left outer join sale.tb_category CAT on (
		SUB.category_code = CAT.category_code
	)	
	order by CAT.category_name desc nulls last;
	
-- Obtenir per a cada país del client, el nombre total de clients diferents i el nombre total de comandes 
-- per a cada país que la seva Data de comanda (order date) sigui anterior al 28 Febrer 2016 i 
-- on la ciutat de client sigui diferent a Bilbao, ordenat descendentment per nombre total de comandes i ascendentment per país

with total_ordres_per_client_i_pais as (
	select	CLI.country, CLI.client_code, count(*) total
	from	sale.tb_order ORD
	join	sale.tb_client CLI on (
		ORD.client_code		=	CLI.client_code
	)
	where	CLI.city	!=	'Bilbao'
	 and	order_date	<	to_date('28/02/2016', 'dd/mm/yyyy')
	group by CLI.country, CLI.client_code
) 
	select	country, 
			count(client_code) total_clients,
			sum(total) total_comandes			
	from	total_ordres_per_client_i_pais
	group by country
	order by total_comandes desc, country asc;
	

-- Obtenir el Nom del client, el Nom del producte i el nombre de línies de comanda, 
-- d'aquelles comandes amb Dates de comanda (order date) en les quals s'ha realitzat un nombre total de comandes 
-- igual o superior a 4 (de tots els clients), i el nombre dels quals de línies de comanda per a aquest client 
-- i producte sigui solament 1, ordenat ascendentment per Nom de client i descendentment per Nom de producte

with dias_amb_4_o_mes_comandes as (
	select	ORD.order_date, count(*)
	from	sale.tb_order ORD
	group by ORD.order_date
	having	count(*) >= 4
)
	select	CLI.client_name,
			PRO.product_name,
			count(*) linees_de_comanda
	from	dias_amb_4_o_mes_comandes	COM
	join	sale.tb_order				ORD on (
		COM.order_date		=	ORD.order_date
	)
	join	sale.tb_client 	CLI on (
		ORD.client_code	=	CLI.client_code
	) 
	join	sale.tb_order_line	LIN on (
		ORD.order_number = LIN.order_number
	)
	join	sale.tb_product PRO on (
		LIN.product_code = PRO.product_code 
	)
	group by CLI.client_name,
			PRO.product_name				
	having count(*) = 1
	order by CLI.client_name asc,
			PRO.product_name desc;				