USE master
DROP DATABASE EXERC07
CREATE DATABASE EXERC07
USE EXERC07
GO

CREATE TABLE CLIENTE (
rg						CHAR(10)						NOT NULL,
cpf						CHAR(14)						NOT NULL,
nome					VARCHAR(100)					NOT NULL,
logradouro_end			VARCHAR(100)					NOT NULL,
numero_end				INT								NOT NULL,
PRIMARY KEY (rg)
)
GO

CREATE TABLE PEDIDO (
notaFiscal				INT								IDENTITY(1001, 1) NOT NULL,
valor					INT								NOT NULL,
datinha					DATE							NOT NULL,
rg_Cliente				CHAR(10)						NOT NULL,
PRIMARY KEY (notaFiscal),
FOREIGN KEY (rg_Cliente) REFERENCES CLIENTE (rg)
)
GO

CREATE TABLE FORNECEDOR (
codigo					INT								IDENTITY(1, 1) NOT NULL,
nome					VARCHAR(100)					NOT NULL,
logradouro_end			VARCHAR(50)						NOT NULL,
numero_end				INT								NULL,
pais_end				VARCHAR(50)						NOT NULL,
area					VARCHAR(4)						NOT NULL,
telefone				VARCHAR(20)						NULL,
cnpj					CHAR(14)						NULL,
cidade					VARCHAR(50)						NULL,
transporte				VARCHAR(30)						NULL,
moeda					VARCHAR(6)						NOT NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE MERCADORIA (
codigo					INT								IDENTITY(10, 1) NOT NULL,
descrição				VARCHAR(100)					NOT NULL,
preco					INT								NOT NULL,
quantidade				INT								NOT NULL,
cod_Fornecedor			INT								NOT NULL
PRIMARY KEY (codigo),
FOREIGN KEY (cod_Fornecedor) REFERENCES FORNECEDOR (codigo)
)
GO

INSERT INTO CLIENTE
VALUES
('29531844', '34519878040', 'Luiz André', 'R. Astorga', 500),
('13514996x', '84984285630', 'Maria Luiza', 'R. Piauí', 174),
('121985541', '23354997310', 'Ana Barbara', 'Av. Jaceguai', 1141),
('23987746x', '43587669920', 'Marcos Alberto', 'R. Quinze', 22)

INSERT INTO PEDIDO
VALUES
(754.00, '2018-04-01', '121985541'),
(350.00, '2018-04-02', '121985541'),
(30.00, '2018-04-02', '29531844'),
(1500.00, '2018-04-03', '13514996x')

INSERT INTO FORNECEDOR 
VALUES
('Clone', 'Av. Nações Unidas', 12000, 'BR', 55, '1141487000', NULL, 'São Paulo', NULL, 'R$'),
('Logitech', '28th Street', 100, 'USA', 1, '2127695100', NULL, NULL, 'Avião', 'US$'),
('LG', 'Rod. Castello Branco', NULL, 'BR', 55, '0800664400', 4159978100001, 'Sorocaba', NULL, 'R$'),
('PcChips', 'Ponte da Amizade', NULL, 'PY', 595, NULL, NULL, NULL, 'Navio', 'US$')


INSERT INTO MERCADORIA
VALUES
('Mouse', 24.00, 30, 1),
('Teclado', 50.00, 20, 1),
('Cx. De Som', 30.00, 8, 2),
('Monitor 17', 350.00, 4, 3),
('Notebook', 1500.00, 7, 4)

--Nota: (CPF deve vir sempre mascarado no formato XXX.XXX.XXX-XX e RG Sempre com um traçao antes do último dígito (Algo como XXXXXXXX-X), mas alguns tem 8 e outros 9 dígitos)

-- Atualizar CPF
UPDATE CLIENTE
SET cpf = 
    SUBSTRING(cpf, 1, 3) + '.' +
    SUBSTRING(cpf, 4, 3) + '.' +
    SUBSTRING(cpf, 7, 3) + '-' +
    SUBSTRING(cpf, 10, 2);

UPDATE CLIENTE
SET rg =
	CASE 
		WHEN LEN(rg) = 8 THEN SUBSTRING(rg, 1, 8) + '-' + SUBSTRING(rg, 9, 1)
		WHEN LEN(rg) = 9 THEN SUBSTRING(rg, 1, 8) + '-' + SUBSTRING(rg, 9, 1)
	END;

UPDATE PEDIDO
SET rg_Cliente = 
    CASE 
        WHEN LEN(rg_Cliente) = 8 THEN SUBSTRING(rg_Cliente, 1, 8) + '-' + SUBSTRING(rg_Cliente, 9, 1)
        WHEN LEN(rg_Cliente) = 9 THEN SUBSTRING(rg_Cliente, 1, 8) + '-' + SUBSTRING(rg_Cliente, 9, 1)
    END;

--Consultar 10% de desconto no pedido 1003
SELECT (valor * 0.90) AS Val_Desconto
FROM PEDIDO
WHERE notaFiscal = '1003'

--Consultar 5% de desconto em pedidos com valor maior de R$700,00
SELECT notaFiscal, valor * 0.95 AS Desconto
FROM PEDIDO
WHERE valor > 700.00

--Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10
SELECT codigo, preco, preco + (preco * 0.20) AS Aumento
FROM MERCADORIA
WHERE quantidade < 10

--Data e valor dos pedidos do Luiz
SELECT ped.datinha, ped.valor
FROM PEDIDO ped
INNER JOIN CLIENTE cli on cli.rg = ped.rg_Cliente
WHERE cli.nome LIKE '%Luiz%'


--CPF, Nome e endereço concatenado do cliente de nota 1004
SELECT cli.cpf, cli.nome, CONCAT(cli.logradouro_end,' Nº ' ,cli.numero_end) AS Endereco
FROM CLIENTE cli
INNER JOIN PEDIDO ped on ped.rg_Cliente = cli.rg
WHERE ped.notaFiscal = 1004

--País e meio de transporte da Cx. De som
SELECT f.pais_end, f.transporte
FROM FORNECEDOR f
INNER JOIN MERCADORIA m on m.cod_Fornecedor = f.codigo
WHERE m.descrição = 'Cx. De som'

--Nome e Quantidade em estoque dos produtos fornecidos pela Clone
SELECT m.descrição, m.quantidade
FROM MERCADORIA m
INNER JOIN FORNECEDOR f on f.codigo = m.cod_Fornecedor
WHERE f.nome = 'Clone'

--Endereço concatenado e telefone dos fornecedores do monitor. (Telefone brasileiro (XX)XXXX-XXXX ou XXXX-XXXXXX (Se for 0800), Telefone Americano (XXX)XXX-XXXX)
SELECT CONCAT(f.logradouro_end, ' Nº ' , f.numero_end) AS Endereco,
			CASE 
               WHEN Telefone LIKE '0800%' THEN 'Telefone: (' + SUBSTRING(Telefone, 1, 3) + ')' + SUBSTRING(Telefone, 3, 4) + '-' + SUBSTRING(Telefone, 7, 4)
               WHEN LEN(Telefone) = 10 THEN 'Telefone: (' + SUBSTRING(Telefone, 1, 2) + ')' + SUBSTRING(Telefone, 3, 4) + '-' + SUBSTRING(Telefone, 7, 4)
               WHEN LEN(Telefone) = 11 THEN 'Telefone: (' + SUBSTRING(Telefone, 1, 3) + ')' + SUBSTRING(Telefone, 4, 4) + '-' + SUBSTRING(Telefone, 8, 4)
               ELSE 'Telefone: ' + SUBSTRING(Telefone, 1, 3) + '-' + SUBSTRING(Telefone, 4, 6)
			END
FROM FORNECEDOR f
INNER JOIN MERCADORIA m on m.cod_Fornecedor = f.codigo
WHERE m.descrição LIKE '%Monitor%'

--Tipo de moeda que se compra o notebook
SELECT f.moeda
FROM FORNECEDOR f
INNER JOIN MERCADORIA m on m.cod_Fornecedor = f.codigo
WHERE m.descrição = 'Notebook'

--Considerando que hoje é 03/02/2019, há quantos dias foram feitos os pedidos e, criar uma coluna que escreva Pedido antigo para pedidos feitos há mais de 6 meses e pedido recente para os outros
SELECT *, DATEDIFF(DAY, datinha, '03/02/2019') As Dias,
	CASE
        WHEN DATEDIFF(MONTH, datinha, GETDATE()) >= 6 THEN 'Pedido antigo'
        ELSE 'Pedido recente'
    END AS 'StatusPedido'
FROM PEDIDO

--Nome e Quantos pedidos foram feitos por cada cliente
SELECT c.nome, COUNT(p.notaFiscal) AS 'QuantidadePedidos'
FROM CLIENTE c
INNER JOIN PEDIDO p on p.rg_Cliente = c.rg
GROUP BY c.nome

--RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos
SELECT c.rg, c.cpf, c.nome, CONCAT (c.logradouro_end, ' Nº ' , c.numero_end)
FROM CLIENTE c
LEFT JOIN PEDIDO p on c.rg = p.rg_Cliente
WHERE p.rg_Cliente IS NULL
