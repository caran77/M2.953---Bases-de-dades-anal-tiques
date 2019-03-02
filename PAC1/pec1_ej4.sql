--És necessari afegir en la Taula de línies de comanda una nova columna anomenada suma total IVA (total_vat_sum), 
--amb tipus de dada numèrica que permeti 20 dígits no decimals i 4 dígits decimals, i no ha de permetre valors Nuls. 
--La columna ha d'actualitzar-se per a totes les línies de comanda amb el valor obtingut de multiplicar la quantitat 
--per el preu unitari, amb un 8% d'IVA afegit sobre la base de la suma total.

alter table sale.tb_order_line add column total_vat_sum numeric(24,4);

update	sale.tb_order_line
set		total_vat_sum	=	unit_price*quantity*1.08;

alter table sale.tb_order_line alter column total_vat_sum set not null;

select	*
from	sale.tb_order_line;