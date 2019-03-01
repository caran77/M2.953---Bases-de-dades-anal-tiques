------------------------------------------------------------------------------------------------
--
-- Formato fechas
--
------------------------------------------------------------------------------------------------

SET datestyle = YMD;        -- Formato de fecha día-mes-año


------------------------------------------------------------------------------------------------
--
-- Datos tb_client
--
------------------------------------------------------------------------------------------------

INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code) VALUES ('C0001', 'Eroski', 'Las Rozas 23', 'Madrid', 'Spain', NULL, NULL, NULL);
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code) VALUES ('C0002', 'Gadis', 'Polígono Pocomaco 21', 'A Coruña', 'Spain', NULL, '+34537789995', NULL);
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code) VALUES ('C0003', 'Mercadona', 'Av. Castellana 35', 'Valencia', 'Spain', 'info@mercadona.es', NULL, NULL);
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code) VALUES ('C0026', 'Dia', 'Camps Elisees 125', 'París', 'France', 'dia@dia.fr', NULL, NULL);
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0004', 'Eroski - Madrid', NULL, 'Madrid', 'Spain', NULL, NULL, 'C0001', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0005', 'Eroski - Barcelona', NULL, 'Barcelona', 'Spain', 'info@eroski.es', NULL, 'C0001', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0006', 'Eroski - Santiago', NULL, 'Santiago de Compostela', 'Spain', NULL, '981 236 698', 'C0001', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0007', 'Gadis - Pais Vasco', 'C/Estación', 'Bilbao', 'Spain', NULL, NULL, 'C0002', 'asanvar');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0008', 'Gadis - Galicia', 'As Pontes', 'Ourense', 'Spain', 'info@eroski.es', NULL, 'C0002', 'asanvar');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0009', 'Mercadona - Madrid', 'Chueca 1', 'Madrid', 'Spain', NULL, NULL, 'C0003', 'asanvar');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0010', 'Mercadona - Barcelona', 'Av. Layetana', 'Barcelona', 'Spain', 'info@mercadona.es', NULL, 'C0003', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0011', 'Mercadona - Cracovia', 'ul. Grodzka 15', 'Cracovia', 'Poland', 'info@mercadona.es', '+48988885236', 'C0003', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0012', 'Mercadona - Varsovia', 'ul. Karmelica 15', 'Varsovia', 'Poland', 'info@mercadona.es', '+48888881136', 'C0003', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0013', 'Eroski - Getafe', 'Razados 23', 'Getafe', 'Spain', 'info@eroski.es', NULL, 'C0004', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0014', 'Eroski - Vallecas', 'Av. Victoria 89', 'Vallecas', 'Spain', 'info@eroski.es', NULL, 'C0004', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0015', 'Eroski - Barcelona', NULL, 'Barcelona', 'Spain', NULL, '981 236 698', 'C0005', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0016', 'Gadis - Bilbao', NULL, 'Bilbao', 'Spain', NULL, NULL, 'C0007', 'asanvar');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0017', 'Gadis - San Sebastián', 'As Pontes', 'Ourense', 'Spain', 'info@eroski.es', NULL, 'C0007', 'asanvar');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0018', 'Gadis - Santiago', NULL, 'Santiago de Compostela', 'Spain', NULL, NULL, 'C0008', 'asanvar');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0019', 'Gadis - Lugo', NULL, 'Lugo', 'Spain', 'info@eroski.es', NULL, 'C0008', 'asanvar');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0020', 'Mercadona - Getafe', NULL, 'Getafe', 'Spain', NULL, NULL, 'C0009', 'asanvar');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0021', 'Mercadona - Vallecas', 'Av. Simples 112', 'Vallecas', 'Spain', 'info@mercadona.es', NULL, 'C0009', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0022', 'Mercadona - Algeciras', 'ul. Grodzka 15', 'Algeciras', 'Spain', 'info@mercadona.es', NULL, 'C0009', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0023', 'Mercadona - Cracovia', 'ul. Grodzka 15', 'Cracovia', 'Poland', 'info@mercadona.es', '+48888881136', 'C0011', 'apermag');
INSERT INTO sale.tb_client (client_code, client_name, address, city, country, contact_email, phone, parent_client_code, created_by_user) VALUES ('C0024', 'Mercadona - Varsovia', 'ul. Karmelica 15', 'Varsovia', 'Poland', 'info@mercadona.es', '+48888881136', 'C0012', 'apermag');


------------------------------------------------------------------------------------------------
--
-- Datos tb_category
--
------------------------------------------------------------------------------------------------

INSERT INTO  sale.tb_category (category_code, category_name) VALUES ('CT001', 'Frutas');
INSERT INTO  sale.tb_category (category_code, category_name) VALUES ('CT002', 'Bebidas');
INSERT INTO  sale.tb_category (category_code, category_name) VALUES ('CT003', 'Congelados');
INSERT INTO  sale.tb_category (category_code, category_name) VALUES ('CT004', 'Lácteos');
INSERT INTO  sale.tb_category (category_code, category_name) VALUES ('CT005', 'Carnes');
INSERT INTO  sale.tb_category (category_code, category_name) VALUES ('CT006', 'Higiene');


------------------------------------------------------------------------------------------------
--
-- Datos tb_subcategory
--
------------------------------------------------------------------------------------------------

INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC001', 'CT001', 'Cítricos');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC002', 'CT001', 'Manzanas y peras');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC003', 'CT001', 'Melón y sandía');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC004', 'CT002', 'Aguas');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC005', 'CT002', 'Gaseosas');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC006', 'CT002', 'Zumos');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC013', NULL, 'Vinos');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC007', 'CT003', 'Pizzas');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC008', 'CT003', 'Verduras');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC009', 'CT004', 'Leche');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC014', NULL, 'Yogures');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC010', 'CT005', 'Pollo');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC011', 'CT005', 'Pavo');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC012', NULL, 'Ternera');
INSERT INTO  sale.tb_subcategory (subcategory_code, category_code, subcategory_name) VALUES ('SC015', NULL, 'Papel');


------------------------------------------------------------------------------------------------
--
-- Datos tb_product
--
------------------------------------------------------------------------------------------------

INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0001', 'SC001', 'Naranjas España', 1.99);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0002', 'SC001', 'Limones España', 1.79);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0003', 'SC001', 'Pomelos Grecias', 0.98);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0004', 'SC002', 'Manzana Golden', 1.59);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0005', 'SC002', 'Manzana Royal', 1.75);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0006', 'SC003', 'Melón Grecia', 3.39);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0007', 'SC004', 'Bezoya', 0.39);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0008', 'SC004', 'Cabreiroá', 0.59);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0009', 'SC004', 'Del grifo', 0.19);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0010', 'SC005', 'Lapitusa', 1.39);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0011', 'SC013', 'El Coto', 3.69);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0012', 'SC013', 'Azpilicueta', 5.89);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0013', 'SC007', 'Pizza Margarita', 2.69);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0014', 'SC007', 'Pizza Cuatro Quesos', 2.89);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0015', 'SC008', 'Guisantes El Tenedor', 1.29);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0016', 'SC008', 'Brocoli El Tenedor', 2.29);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0026', 'SC015', 'Papel', 3.59);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0017', 'SC014', 'Yogur Yoplait', 0.39);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0018', 'SC009', 'Leche desnatada', 0.59);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0019', 'SC009', 'Leche entera', 0.79);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0020', 'SC009', 'Leche semi-desnatada', 0.69);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0021', 'SC010', 'Alitas pollo', 1.39);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0022', 'SC010', 'Pollo entero', 4.39);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0023', 'SC012', 'Pata de ternera', 3.59);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0024', 'SC012', 'Falda de ternera', 2.99);
INSERT INTO sale.tb_product (product_code, subcategory_code, product_name, price) VALUES ('P0025', 'SC014', 'Danio', 0.99);


------------------------------------------------------------------------------------------------
--
-- Datos tb_order
--
------------------------------------------------------------------------------------------------

INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#001', 'C0013', '2016-01-05', '2016-01-06', NULL);
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#002', 'C0013', '2016-01-07', '2016-01-13', '2016-01-13');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#003', 'C0015', '2016-01-15', '2016-01-16', '2016-01-16');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#004', 'C0015', '2016-01-17', '2016-01-21', NULL);
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#005', 'C0016', '2016-01-01', '2016-01-03', '2016-01-04');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#006', 'C0017', '2016-01-05', '2016-01-07', NULL);
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#007', 'C0017', '2016-01-06', '2016-01-15', '2016-01-21');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#008', 'C0018', '2016-01-08', '2016-01-14', NULL);
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#009', 'C0018', '2016-01-25', '2016-01-27', NULL);
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#010', 'C0018', '2016-01-22', '2016-01-29', '2016-01-31');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#011', 'C0020', '2016-01-14', '2016-01-15', '2016-01-15');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#012', 'C0021', '2016-01-16', '2016-01-19', NULL);
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#013', 'C0021', '2016-01-31', '2016-01-31', NULL);
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#014', 'C0021', '2016-01-21', '2016-01-25', '2016-01-25');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#015', 'C0022', '2016-01-13', '2016-01-17', '2016-01-17');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#016', 'C0022', '2016-01-12', '2016-01-17', NULL);
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#017', 'C0022', '2016-01-14', '2016-01-26', NULL);
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#018', 'C0024', '2016-01-14', '2016-01-19', '2016-01-19');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#019', 'C0024', '2016-01-19', '2016-01-30', '2016-01-31');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#020', 'C0024', '2016-01-20', '2016-01-28', '2016-01-28');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#021', 'C0015', '2016-01-17', '2016-01-22', NULL);
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#022', 'C0018', '2016-01-17', '2016-01-22', '2016-01-23');
INSERT INTO sale.tb_order (order_number, client_code, order_date, delivery_date, reception_date) VALUES ('ON2016#023', 'C0018', '2016-01-17', '2016-01-24', '2016-01-25');


------------------------------------------------------------------------------------------------
--
-- Create table tb_order_line
--
------------------------------------------------------------------------------------------------

INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#016', 1, 'P0024', 19, 2.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#016', 2, 'P0003', 14, 0.79);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#016', 3, 'P0006', 19, 3.59);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#016', 4, 'P0025', 1, 0.99);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#017', 1, 'P0001', 1, 1.99);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#006', 1, 'P0024', 20, 2.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#006', 2, 'P0003', 2, 0.79);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#006', 3, 'P0010', 13, 1.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#006', 4, 'P0024', 17, 2.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#007', 1, 'P0001', 16, 1.99);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#007', 2, 'P0005', 17, 1.75);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#007', 3, 'P0016', 18, 2.29);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#007', 4, 'P0020', 4, 0.69);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#008', 1, 'P0006', 3, 3.59);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#017', 2, 'P0002', 19, 1.79);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#017', 3, 'P0003', 14, 0.79);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#018', 1, 'P0003', 10, 0.79);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#018', 2, 'P0024', 19, 2.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#018', 3, 'P0021', 19, 1.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#018', 4, 'P0001', 7, 1.99);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#020', 1, 'P0008', 7, 0.59);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#020', 2, 'P0005', 5, 1.75);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#022', 1, 'P0024', 3, 2.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#022', 2, 'P0001', 5, 1.99);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#023', 1, 'P0024', 6, 2.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#023', 2, 'P0001', 10, 1.99);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#023', 3, 'P0003', 1, 0.79);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#023', 4, 'P0010', 1, 1.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#001', 1, 'P0001', 12, 1.99);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#001', 2, 'P0003', 5, 0.79);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#001', 3, 'P0007', 10, 0.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#002', 1, 'P0010', 3, 1.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#002', 2, 'P0002', 19, 1.79);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#003', 1, 'P0009', 7, 0.19);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#005', 1, 'P0018', 10, 0.59);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#005', 2, 'P0021', 17, 1.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#008', 2, 'P0005', 20, 1.75);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#010', 1, 'P0024', 14, 2.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#010', 2, 'P0008', 20, 0.59);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#010', 3, 'P0009', 19, 0.19);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#012', 1, 'P0024', 14, 2.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#012', 2, 'P0003', 14, 0.79);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#012', 3, 'P0002', 5, 1.79);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#012', 4, 'P0001', 10, 1.99);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#012', 5, 'P0024', 14, 2.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#013', 1, 'P0003', 14, 0.79);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#014', 1, 'P0001', 10, 1.99);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#014', 2, 'P0024', 1, 2.39);
INSERT INTO sale.tb_order_line (order_number, order_line_number, product_code, quantity, unit_price) VALUES ('ON2016#014', 3, 'P0025', 2, 1.98);
