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
	
-- Obtenir per a cada país del client, el nombre total de clients diferents i el nombre total de comandes per a cada país que la seva Data de comanda (order date) sigui anterior al 28 Febrer 2016 i on la ciutat de client sigui diferent a Bilbao, ordenat descendentment per nombre total de comandes i ascendentment per país.

-- Obtenir el Nom del client, el Nom del producte i el nombre de línies de comanda, d'aquelles comandes amb Dates de comanda (order date) en les quals s'ha realitzat un nombre total de comandes igual o superior a 4 (de tots els clients), i el nombre dels quals de línies de comanda per a aquest client i producte sigui solament 1, ordenat ascendentment per Nom de client i descendentment per Nom de producte.
	