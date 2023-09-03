-- Inserção de dados e queries

USE my_ecommerce;
-- show tables;

INSERT INTO Clients (Fname, Minit, Lname, CPF, Address) VALUES
			 ('Maria','M','Silva', 12346789, 'rua silva de prata 29, Carangola - Cidade das flores'),
		     ('Matheus','O','Pimentel', 987654321,'rua alemeda 289, Centro - Cidade das flores'),
			 ('Ricardo','F','Silva', 45678913,'avenida alemeda vinha 1009, Centro - Cidade das flores'),
			 ('Julia','S','França', 789123456,'rua lareijras 861, Centro - Cidade das flores'),
			 ('Roberta','G','Assis', 98745631,'avenidade koller 19, Centro - Cidade das flores'),
			 ('Isabela','M','Cruz', 654789123,'rua alemeda das flores 28, Centro - Cidade das flores');
             
INSERT INTO product (Pname, classificatiON_kids, category, avaliação, size) VALUES
							  ('FONe de ouvido',false,'Eletrônico','4',NULL),
                              ('Barbie Elsa',true,'Brinquedos','3',NULL),
                              ('Body Carters',true,'Vestimenta','5',NULL),
                              ('MicrofONe Vedo - Youtuber',False,'Eletrônico','4',NULL),
                              ('Sofá retrátil',False,'Móveis','3','3x57x80'),
                              ('Farinha de arroz',False,'Alimentos','2',NULL),
                              ('Fire Stick AmazON',False,'Eletrônico','3',NULL);
                              
INSERT INTO payments (idPayclient, typePayment, limitAvailable) VALUES
    (1, 'Cartão', 1000.00),
    (2, 'Boleto', 500.00),
    (3, 'Cartão', 750.00),
    (4, 'Dinheiro', 300.00),
    (5, 'Cartão', 600.00),
    (6, 'Boleto', 400.00);


INSERT INTO orders (idOrderClient, idOrderPayment, orderStatus, orderDescriptiON, sendValue) VALUES
    (1, 1, default, 'compra via aplicativo', NULL),
    (2, 2, default, 'compra via aplicativo', 50),
    (3, 3, 'CONfirmado', NULL, NULL),
    (4, 4, default, 'compra via web site', 150);

INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus) VALUES
    (1, 3, 2, NULL),
    (2, 3, 1, NULL);

INSERT INTO productStorage (storageLocatiON,quantity) VALUES 
							('Rio de Janeiro',1000),
                            ('Rio de Janeiro',500),
                            ('São Paulo',10),
                            ('São Paulo',100),
                            ('São Paulo',10),
                            ('Brasília',60);
                            
INSERT INTO storageLocatiON (idLproduct, idLstorage, locatiON) VALUES
						 (1,2,'RJ'),
                         (2,6,'GO');
                         
INSERT INTO supplier (SocialName, CNPJ, cONtact) VALUES 
							('Almeida e filhos', 123456789123456,'21985474'),
                            ('Eletrônicos Silva',854519649143457,'21985484'),
                            ('Eletrônicos Valma', 934567893934695,'21975474');

INSERT INTO productSupplier (idPsSupplier, idPsProduct, quantity) VALUES
						 (1,1,500),
                         (1,2,400),
                         (2,4,633),
                         (3,3,5),
                         (2,5,10);

INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, locatiON, cONtact) VALUES 
						('Tech eletrONics', NULL, 123456789456321, NULL, 'Rio de Janeiro', 219946287),
					    ('Botique Durgas',NULL,NULL,123456783,'Rio de Janeiro', 219567895),
						('Kids World',NULL,456789123654485,NULL,'São Paulo', 1198657484);
                        
INSERT INTO productSeller (idPseller, idPproduct, prodQuantity) VALUES 
						 (1,6,80),
                         (2,7,10);

select count(*) as 'N Clientes' FROM clients ;

select * FROM clients c, orders o where c.idClient = idOrderClient;

select Fname,Lname, idOrder, orderStatus FROM clients c, orders o where c.idClient = idOrderClient;

SELECT c.Fname, c.Lname, o.idOrder, p.Pname as Produto, o.orderStatus as Status FROM clients c
   JOIN orders o ON c.idClient = o.idOrderClient
   JOIN productOrder po ON o.idOrder = po.idPOorder
   JOIN product p ON po.idPOproduct = p.idProduct;

select concat(Fname,' ',Lname) as Client, idOrder as Request, orderStatus as Status FROM clients c, orders o where c.idClient = idOrderClient;

INSERT INTO orders (idOrderClient, idOrderPayment, orderStatus, orderDescriptiON, sendValue)
   VALUES (2, 2, DEFAULT, 'compra via aplicativo', NULL);

select count(*)  FROM clients c, orders o where c.idClient = idOrderClient;

select Fname FROM clients c 
   INNER JOIN orders o ON c.idClient = o.idOrderClient
   INNER JOIN productOrder p ON p.idPOorder = o.idOrder
   GROUP BY idClient; 

select c.idClient, Fname, count(*) as Number_of_orders FROM clients c 
   INNER JOIN orders o ON c.idClient = o.idOrderClient
   GROUP BY idClient; 

SELECT c.Fname, c.Lname, SUM(o.sendValue) as total_send_value FROM clients c
   INNER JOIN orders o ON c.idClient = o.idOrderClient
   GROUP BY c.Fname, c.Lname
   HAVING total_send_value > 50;

-- Quantos pedidos foram feitos por cada cliente?
SELECT c.idClient, c.Fname, c.Lname, COUNT(o.idOrder) as total_pedidos FROM clients c
   LEFT JOIN orders o ON c.idClient = o.idOrderClient
   GROUP BY c.idClient, c.Fname, c.Lname;

-- Algum vendedor também é fornecedor?
SELECT s.idSeller, s.SocialName AS Vendedor, f.SocialName AS Fornecedor FROM seller s
   INNER JOIN supplier f ON s.CNPJ = f.CNPJ;

-- Relação de produtos fornecedores e estoques
SELECT p.Pname AS Produto, f.SocialName AS Fornecedor, ps.quantity AS Quantidade FROM product p
   INNER JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
   INNER JOIN supplier f ON ps.idPsSupplier = f.idSupplier;

-- Relação de nomes dos fornecedores e nomes dos produtos
SELECT f.SocialName AS Fornecedor, p.Pname AS Produto FROM supplier f
   INNER JOIN productSupplier ps ON f.idSupplier = ps.idPsSupplier
   INNER JOIN product p ON ps.idPsProduct = p.idProduct;
