-- modelo_ecommerce
-- drop database my_ecommerce;
CREATE DATABASE IF NOT EXISTS my_ecommerce;
USE my_ecommerce;

-- Criar Tabela cliente
CREATE TABLE IF NOT EXISTS  clients(
		idClient int auto_increment,
        Fname varchar(10),
        Minit char(3),
        Lname varchar(20),
        CPF char(11) not null,
        Address varchar(255),
        PRIMARY KEY (idClient),
        CONSTRAINT  unique_cpf_client UNIQUE (CPF)
);

-- Criar Tabela produto
CREATE TABLE IF NOT EXISTS  product(
		idProduct int auto_increment,
        Pname varchar(255) not null,
        classification_kids bool default false,
        category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
        avaliação float default 0,
        size varchar(10),
        PRIMARY KEY (IdProduct)
);

-- Criar Tabela pagamentos
CREATE TABLE IF NOT EXISTS  payments(
	idPayment int auto_increment,
	idPayclient int ,
    typePayment enum('Boleto','Cartão','Dois cartões', 'Dinheiro'),
    limitAvailable float,
	PRIMARY KEY(idPayment),
    CONSTRAINT fk_payment_client FOREIGN KEY (idPayclient) REFERENCES clients(idClient)
);

-- Criar Tabela pedido
CREATE TABLE IF NOT EXISTS  orders(
	idOrder int auto_increment,
    idOrderClient int,
    idOrderPayment int not null, 
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    PRIMARY KEY (IdOrder),
    CONSTRAINT fk_ordes_client FOREIGN KEY (idOrderClient) REFERENCES clients(idClient),
    CONSTRAINT fk_orders_payment FOREIGN KEY (idOrderPayment) REFERENCES payments(IdPayment)
	on update cascade
);

-- Criar Tabela fornecedor
CREATE TABLE IF NOT EXISTS  supplier(
	idSupplier int auto_increment,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    PRIMARY KEY (idSupplier),
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- Criar Tabela vendedor
CREATE TABLE IF NOT EXISTS  seller(
	idSeller int auto_increment,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    PRIMARY KEY (idSeller),
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

-- Criar Tabela estoque
CREATE TABLE IF NOT EXISTS  productStorage(
	idProdStorage int auto_increment,
    storageLocation varchar(255),
    quantity int default 0,
    PRIMARY KEY (idProdStorage)
);

-- Criar Tabela Produto/Vendedor
CREATE TABLE IF NOT EXISTS   productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    PRIMARY KEY (idPseller, idPproduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES product(idProduct)
);

-- Criar Tabela Produto/Fornecedor
CREATE TABLE IF NOT EXISTS  productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_prodcut FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
);

-- Criar Tabela Produto/Pedido
CREATE TABLE IF NOT EXISTS  productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_order FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);

-- Criar Tabela Local de Armazenamento
CREATE TABLE IF NOT EXISTS  storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
);