-- Client amb codi C0030, amb Nom Lidl, adreça Drungüerkanster 38, ciutat Frankfurt, país Germany, telèfon no proporcionat, 
-- i email info@lidl.de.
delete from sale.tb_client where client_code in ('C0032','C0031','C0030'); 
insert into sale.tb_client (
	client_code,
	client_name,
	address,
	city,
	country,
	contact_email,
	created_by_user,
	created_date
)values(
	'C0030',
	'Lidl',
	'Drungüerkanster 38',
	'Frankfurt',
	'Germany',
	'info@lidl.de',
	'UOC-Alumno',
	to_date('31/10/2017', 'dd/mm/yyyy')
);

-- Client amb codi C0031, amb Nom Lidl - Frankfurt, adreça Drungüerkanster 128, ciutat Frankfurt, país Germany, telèfon 998858896, i email frankfurt@lidl.de. Aquest client té com a pare el client Lidl.
insert into sale.tb_client (
	client_code,
	client_name,
	address,
	city,
	country,
	contact_email,
	created_by_user,
	created_date,
	phone,
	parent_client_code
)values(
	'C0031',
	'Lidl - Frankfurt',
	'Drungüerkanster 128',
	'Frankfurt',
	'Germany',
	'frankfurt@lidl.de',
	'UOC-Alumno',
	to_date('31/10/2017', 'dd/mm/yyyy'),
	'998858896',
	'C0030'
);
-- Client amb codi C0032, amb Nom Lidl – Frankfurt GmB, adreça Drungüerkanster 128, ciutat Frankfurt, país Germany, telèfon 998858896, i email frankfurt@lidl.de. Aquest client té com a pare el client Lidl - Frankfurt.
 --Es demana que es registri tota aquesta informació amb usuari creador UOC-Alumno i Data de creació 31 Octubre 2017.
insert into sale.tb_client (
	client_code,
	client_name,
	address,
	city,
	country,
	contact_email,
	created_by_user,
	created_date,
	phone,
	parent_client_code
)values(
	'C0032',
	'Lidl – Frankfurt GmB',
	'Drungüerkanster 128',
	'Frankfurt',
	'Germany',
	'frankfurt@lidl.de',
	'UOC-Alumno',
	to_date('31/10/2017', 'dd/mm/yyyy'),
	'998858896',
	'C0031'
);

commit;