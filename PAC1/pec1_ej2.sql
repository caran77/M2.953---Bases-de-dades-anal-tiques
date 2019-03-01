--Obtenir el codi, Nom i ciutat d'aquells clients que no tenen un telèfon registrat ni una adreça registrada, 
--ordenat descendentment per Nom de client i ascendentment per ciutat
select	CLI.client_code, CLI.client_name, CLI.city
from	sale.tb_client	CLI
where	CLI.phone is null
 and	CLI.address is null
order by CLI.client_name desc, CLI.city asc

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
order by PRO.price desc