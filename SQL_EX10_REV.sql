CREATE DATABASE EXERC10
GO
USE EXERC10
GO
CREATE TABLE medicamento
(
    codigo INT IDENTITY(1, 1) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    apresentacao VARCHAR(50) NOT NULL,
    unidade_cadastro VARCHAR(50) NOT NULL,
    preco_proposto DECIMAL(7, 3)
    PRIMARY KEY (codigo)
)
GO
CREATE TABLE cliente 
(
    cpf CHAR(11) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    rua VARCHAR(50) NOT NULL,
    numero INT NOT NULL,
    bairro VARCHAR(50) NOT NULL,
    telefone CHAR(13)
    PRIMARY KEY (cpf)
)
GO
CREATE TABLE venda 
(
    nota_fiscal INT NOT NULL,
    cpf_cliente CHAR(11) NOT NULL,
    codigo_medicamento INT NOT NULL,
    quantidade INT NOT NULL,
    valor_total DECIMAL(7, 2) NOT NULL,
    data_venda DATE NOT NULL
    PRIMARY KEY (nota_fiscal, cpf_cliente, codigo_medicamento)
    FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf),
    FOREIGN KEY (codigo_medicamento) REFERENCES medicamento(codigo)
)

INSERT INTO medicamento
VALUES
('Acetato de medroxiprogesterona', '150 mg/ml', 'Ampola', 6.700),
('Aciclovir', '200mg/comp.', 'Comprimido', 0.280),
('Ácido Acetilsalicílico', '500mg/comp.', 'Comprimido', 0.035),
('Ácido Acetilsalicílico', '100mg/comp.', 'Comprimido', 0.030),
('Ácido Fólico', '5mg/comp.', 'Comprimido', 0.054),
('Albendazol', '400mg/comp. mastigável', 'Comprimido', 0.560),
('Alopurinol', '100mg/comp.', 'Comprimido', 0.080),
('Amiodarona', '200mg/comp.', 'Comprimido', 0.200),
('Amitriptilina(Cloridrato)', '25mg/comp.', 'Comprimido', 0.220),
('Amoxicilina', '500mg/cáps.', 'Cápsula', 0.190)

INSERT INTO cliente
VALUES
('34390898700', 'Maria Zélia', 'Anhaia', 65, 'Barra Funda', '92103762'),
('21345986290', 'Roseli Silva', 'Xv. De Novembro', 987, 'Centro', '82198763'),
('86927981825', 'Carlos Campos', 'Voluntários da Pátria', 1276, 'Santana', '98172361'),
('31098120900', 'João Perdizes', 'Carlos de Campos', 90, 'Pari', '61982371')

INSERT INTO venda
VALUES
(31501, '86927981825', 10, 3, 0.57, '2020-11-01'),
(31501, '86927981825', 2, 10, 2.8, '2020-11-01'),
(31501, '86927981825', 5, 30, 1.05, '2020-11-01'),
(31501, '86927981825', 8, 30, 6.6, '2020-11-01'),
(31502, '34390898700', 8, 15, 3, '2020-11-01'),
(31502, '34390898700', 2, 10, 2.8, '2020-11-01'),
(31502, '34390898700', 9, 10, 2.2, '2020-11-01'),
(31503, '31098120900', 1, 20, 134, '2020-11-02')

--Nome, apresentação, unidade e valor unitário dos remédios que ainda não foram vendidos. Caso a unidade de cadastro seja comprimido, mostrar Comp.
SELECT m.nome, m.apresentacao,
	CASE 
        WHEN m.unidade_cadastro = 'Comprimido' THEN 'Comp.'
        ELSE m.unidade_cadastro
    END, m.preco_proposto
FROM medicamento m
WHERE m.codigo NOT IN (SELECT v.codigo_medicamento FROM venda v)

--Nome dos clientes que compraram Amiodarona
SELECT cli.nome
FROM cliente cli
INNER JOIN venda v on cli.cpf = v.cpf_cliente
INNER JOIN medicamento  m on m.codigo = v.codigo_medicamento
WHERE m.nome = 'Amiodarona'

--CPF do cliente, endereço concatenado, nome do medicamento (como nome de remédio),  apresentação do remédio, unidade, preço proposto, quantidade vendida e valor total dos remédios vendidos a Maria Zélia
SELECT cli.cpf, CONCAT (cli.rua, ' ' , cli.numero, ' ' ,cli.bairro) AS Endereco, m.nome as NomeRemedio, m.apresentacao, m.unidade_cadastro, m.preco_proposto, v.quantidade, v.valor_total
FROM cliente cli
INNER JOIN venda v on cli.cpf = v.cpf_cliente
INNER JOIN medicamento  m on m.codigo = v.codigo_medicamento
WHERE cli.nome = 'Maria Zélia'

--Data de compra, convertida, de Carlos Campos
SELECT CONVERT(VARCHAR, v.data_venda, 103) AS DataConvertida
FROM venda v
INNER JOIN cliente cli on cli.cpf = v.cpf_cliente
WHERE cli.nome = 'Carlos Campos'

--Alterar o nome da  Amitriptilina(Cloridrato) para Cloridrato de Amitriptilina
UPDATE medicamento
SET nome = 'Cloridrato de Amitriptilina'
WHERE nome = 'Amitriptilina(Cloridrato)'