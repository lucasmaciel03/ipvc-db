-- Active: 1709286079626@@localhost@1433@bancoei27712
-- SQL SERVER - TSQL - VIEWS, SP's, Triggers e Cursores
-- 1 
-- Uma conta pode ter vários Clientes e um Cliente pode ter várias contas. Nas contas bancárias existem dois tipos de movimentos:
--      - Movimento a débito - Quando o valor do movimento é retrado da conta;
--      - Movimento a crédito - Quando o valor do movimento é acrescentado à conta.

-- 1.1 Implementação do modelo
--  Tabela Ciente (IdCliente, Nomde)
CREATE TABLE Cliente (
    IdCliente int IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100)
);

--  Tabela Conta (IdConta, Saldo)
CREATE TABLE Conta (
    IdConta int IDENTITY(1,1) PRIMARY KEY,
    Saldo DECIMAL(10,2)
);
 
--  Tabela Titular_Conta (IdConta, IdCliente)
CREATE TABLE Titular_Conta (
    IdConta int,
    IdCliente int,
    PRIMARY KEY (IdConta, IdCliente),
    FOREIGN KEY (IdConta) REFERENCES Conta(IdConta),
    FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);

--  Tabela Movimento (IdConta, NMovimento, Data, TipoMovimento, Valor)
CREATE TABLE Movimento (
    IdConta int NOT NULL,
    NMovimento int NOT NULL IDENTITY(1,1),
    Data DATE,
    TipoMovimento CHAR(1) CHECK (TipoMovimento IN ('C', 'D')),
    Valor DECIMAL(15,2),
    PRIMARY KEY (NMovimento),
    FOREIGN KEY (IdConta) REFERENCES Conta(IdConta)
);

--? Alterar campo TipoMovimento, pois só pode ser "C" ou "D"
ALTER TABLE Movimento ADD CONSTRAINT CHK_TipoMovimento CHECK (TipoMovimento IN ('C', 'D'));

--! DROP TABLE Movimento;
DROP TABLE Movimento;



-- 1.2 Instruções SQL
--  1.2.1 Instrução
--      Inserir um campo na tabela conta, chamado tipo_conta para classificar se é uma conta de R de "risco",E de "estável", e P de "potencial investidor"e por defeito "Sem movimentos"
ALTER TABLE Conta ADD Tipo_conta CHAR(1) DEFAULT 'S' CHECK (tipo_conta IN ('R','E','P','S'))

-- 1.2.2 Instrução
--      Inserir um campo na tabela cliente, chamado tipo para classificar se o cliente é I de "individual"ou E de "empresa"
ALTER TABLE Cliente ADD Tipo CHAR(1) DEFAULT 'I' CHECK (tipo IN ('I','E'))

-- 1.2.3 Instrução
--      Inserir um campo na tabela conta, chamado definicao_conta para definir conta a P de prazo, N de normal e C de certificados do tesouro.
ALTER TABLE Conta ADD Definicao_conta CHAR(1) DEFAULT 'N' CHECK (definicao_conta IN ('P','N','C'))

-- 1.2.4 Carregamento de Dados
--      Aceder ao mockaroo (gerador de dados aleatórios) e gerar scripts sql para car- regar com dados as tabelas criadas tendo em conta as restrições de integridade de domínio.
--      Inserir 10 Clientes
insert into Cliente (Nome, Tipo) values ('Ody', 'E');
insert into Cliente (Nome, Tipo) values ('Claudio', 'E');
insert into Cliente (Nome, Tipo) values ('Rafaela', 'E');
insert into Cliente (Nome, Tipo) values ('Stepha', 'I');
insert into Cliente (Nome, Tipo) values ('Sadella', 'E');
insert into Cliente (Nome, Tipo) values ('Katalin', 'E');
insert into Cliente (Nome, Tipo) values ('Devi', 'I');
insert into Cliente (Nome, Tipo) values ('Valentina', 'E');
insert into Cliente (Nome, Tipo) values ('Wilhelmina', 'E');
insert into Cliente (Nome, Tipo) values ('Shawnee', 'I');

--      Inserir 10 Contas
insert into Conta (Saldo, Tipo_conta, Definicao_conta) values (7593.5, 'S', 'N');
insert into Conta (Saldo, Tipo_conta, Definicao_conta) values (6405.08, 'P', 'C');
insert into Conta (Saldo, Tipo_conta, Definicao_conta) values (3140.72, 'P', 'N');
insert into Conta (Saldo, Tipo_conta, Definicao_conta) values (6876.29, 'E', 'N');
insert into Conta (Saldo, Tipo_conta, Definicao_conta) values (4993.73, 'E', 'C');
insert into Conta (Saldo, Tipo_conta, Definicao_conta) values (8720.49, 'E', 'C');
insert into Conta (Saldo, Tipo_conta, Definicao_conta) values (4504.55, 'P', 'P');
insert into Conta (Saldo, Tipo_conta, Definicao_conta) values (2395.58, 'P', 'N');
insert into Conta (Saldo, Tipo_conta, Definicao_conta) values (3309.49, 'S', 'P');
insert into Conta (Saldo, Tipo_conta, Definicao_conta) values (974.48, 'E', 'N');

--      Inserir 10 Titulares
insert into Titular_Conta (IdConta, IdCliente) values (3, 1);
insert into Titular_Conta (IdConta, IdCliente) values (1, 2);
insert into Titular_Conta (IdConta, IdCliente) values (5,4);
insert into Titular_Conta (IdConta, IdCliente) values (9, 5);
insert into Titular_Conta (IdConta, IdCliente) values (2,3);
insert into Titular_Conta (IdConta, IdCliente) values (4, 6);
insert into Titular_Conta (IdConta, IdCliente) values (7, 7);
insert into Titular_Conta (IdConta, IdCliente) values (8,9);
insert into Titular_Conta (IdConta, IdCliente) values (10, 8);
insert into Titular_Conta (IdConta, IdCliente) values (6, 10);

--      Inserir 10 Movimentos
insert into Movimento (IdConta, Data, TipoMovimento, Valor) values (9, '2023-12-29', 'D', 7905.39);
insert into Movimento (IdConta, Data, TipoMovimento, Valor) values (6, '2023-05-24', 'C', 9479.5);
insert into Movimento (IdConta, Data, TipoMovimento, Valor) values (8, '2023-07-19', 'C', 986.67);
insert into Movimento (IdConta, Data, TipoMovimento, Valor) values (7, '2023-05-29', 'D', 7280.15);
insert into Movimento (IdConta, Data, TipoMovimento, Valor) values (4, '2023-05-14', 'D', 9338.85);
insert into Movimento (IdConta, Data, TipoMovimento, Valor) values (3, '2023-12-14', 'D', 8269.18);
insert into Movimento (IdConta, Data, TipoMovimento, Valor) values (5, '2023-06-20', 'C', 5523.38);
insert into Movimento (IdConta, Data, TipoMovimento, Valor) values (2, '2024-01-24', 'C', 783.98);
insert into Movimento (IdConta, Data, TipoMovimento, Valor) values (1, '2023-08-10', 'C', 7821.51);
insert into Movimento (IdConta, Data, TipoMovimento, Valor) values (10, '2023-05-25', 'D', 2984.78);

-- 1.2.5 Instrução
--       Apresente os movimentos a crédito entre 250€ e 500€ do mais recente ao mais antigo.
SELECT * FROM Movimento WHERE TipoMovimento = 'C' AND Valor BETWEEN 250 AND 500 ORDER BY Data DESC;

-- 1.2.6 Instrução
--       Apresente os clientes com movimentos a débito superiores a 1000€.
SELECT * FROM Movimento WHERE TipoMovimento = 'D' AND Valor > 1000;

-- 1.2.7 Instrução
--     O banco precisa saber quais as contas com mais de 5 movimentos de crédito, na listagem apresente com as colunas NumeroDeMovimentos, totalMovimentos, idConta, nome, tipo de cliente, estado da conta e saldo.
--    Crie uma vista chamada movimentosSuperior5, tendo em conta o seguinte:
--      - NumeroDeMovimentos são o total de movimento de crédito
--      - TotaMovimentos é o somatório dos movimentos de crédito
--      - Saldo é o saldo atual da conta
CREATE VIEW movimentosSuperior5 AS
SELECT COUNT(m.IdMovimento) AS NumeroDeMovimentos, SUM(m.Valor) AS TotalMovimentos, co.IdConta, cl.Nome, cl.Tipo, co.Tipo_conta, co.Saldo 
FROM Movimento m 
JOIN Conta co ON m.IdConta = co.IdConta 
JOIN Titular_Conta tc ON co.IdConta = tc.IdConta
JOIN Cliente cl ON tc.IdCliente = cl.IdCliente
WHERE m.TipoMovimento = 'C' 
GROUP BY co.IdConta, cl.Nome, cl.Tipo, co.Tipo_conta, co.Saldo
HAVING COUNT(m.IdMovimento) > 5;

-- 1.2.8 Instrução
-- Crie uma vista chamada resumoContas que retorna o número de contas a prazo, certificados e normais e o somatório do saldo e o saldo mais alto
CREATE VIEW resumoContas AS
SELECT COUNT(IdConta) AS NumeroDeContas, 
    SUM(CASE WHEN Definicao_conta = 'P' THEN 1 ELSE 0 END) AS ContasPrazo, 
    SUM(CASE WHEN Definicao_conta = 'C' THEN 1 ELSE 0 END) AS ContasCertificados, 
    SUM(CASE WHEN Definicao_conta = 'N' THEN 1 ELSE 0 END) AS ContasNormais, 
    SUM(Saldo) AS SaldoTotal, 
    MAX(Saldo) AS SaldoMaisAlto
FROM Conta;

-- 1.3 Procedimentos SQL

-- 1.3.1 Procedimento 1
--      Crie um procedimento para inserir, atualizar ou remover um movimento
CREATE PROCEDURE MovimentoIU
    @IdMovimento int = NULL,
    @IdConta int,
    @Data DATE,
    @TipoMovimento CHAR(1),
    @Valor DECIMAL(10,2)
AS
BEGIN
    IF @IdMovimento IS NULL
    BEGIN
        INSERT INTO Movimento (IdConta, Data, TipoMovimento, Valor) VALUES (@IdConta, @Data, @TipoMovimento, @Valor);
    END
    ELSE
    BEGIN
        UPDATE Movimento SET IdConta = @IdConta, Data = @Data, TipoMovimento = @TipoMovimento, Valor = @Valor WHERE IdMovimento = @IdMovimento;
    END
END

--! Delete procedimento MovimentoIU

-- 1.3.2 Procedimento 2
--      Considere o campo tipo_conta criado na tabela conta que classifica se é uma conta de "risco","estável","potencial investidor"e crie um procedimento cha- mado insertMovimento para inserir um movimento e que classifica a conta (tipo_conta) mediante as seguinte condições:
--      saldo inferior a 250€ - risco
--      saldo entre 250€ e 5000€ - estável
--      saldo superior a 5000€ - potencial investidor
CREATE PROCEDURE insertMovimento
    @IdConta int,
    @Data DATE,
    @TipoMovimento CHAR(1),
    @Valor DECIMAL(10,2)
AS
BEGIN
    DECLARE @Saldo DECIMAL(10,2);
    SELECT @Saldo = Saldo FROM Conta WHERE IdConta = @IdConta;
    IF @Saldo < 250
    BEGIN
        UPDATE Conta SET Tipo_conta = 'R' WHERE IdConta = @IdConta; -- Risco
    END
    ELSE IF @Saldo BETWEEN 250 AND 5000
    BEGIN
        UPDATE Conta SET Tipo_conta = 'E' WHERE IdConta = @IdConta; -- Estável
    END
    ELSE
    BEGIN
        UPDATE Conta SET Tipo_conta = 'P' WHERE IdConta = @IdConta; -- Potencial Investidor
    END
    INSERT INTO Movimento (IdConta, Data, TipoMovimento, Valor) VALUES (@IdConta, @Data, @TipoMovimento, @Valor);
END

-- 1.4 Triggers SQL
-- 1.4.1 Trigger 1
--      Crie um procedimento chamado atualizaSaldo para inserir um movimento e que ao inserir um movimento atualiza o saldo mediante as seguintes condições:
--         - TipoMovimento for "D"(subtrai o valor do movimento ao saldo) 
--         - TipoMovimento for "C"(adiciona o valor do movimento ao saldo)
CREATE PROCEDURE atualizaSaldo
    @IdMovimento int,
    @IdConta int,
    @Data DATE,
    @TipoMovimento CHAR(1),
    @Valor DECIMAL(10,2)
AS
BEGIN
    DECLARE @Saldo DECIMAL(10,2);
    SELECT @Saldo = Saldo FROM Conta WHERE IdConta = @IdConta;
    IF @TipoMovimento = 'D'
    BEGIN
        UPDATE Conta SET Saldo = @Saldo - @Valor WHERE IdConta = @IdConta;
    END
    ELSE IF @TipoMovimento = 'C'
    BEGIN
        UPDATE Conta SET Saldo = @Saldo + @Valor WHERE IdConta = @IdConta;
    END
    INSERT INTO Movimento (IdConta, Data, TipoMovimento, Valor) VALUES (@IdConta, @Data, @TipoMovimento, @Valor);
END

-- 1.4.2 Trigger 2
--      Crie um trigger que após um movimento inserido consulta o saldo e classifica a conta(tipo_conta) mediante as seguintes condições:
--         - saldo inferior a 250€ - risco
--         - saldo entre 250€ e 5000€ - estável
--         - saldo superior a 5000€ - potencial investidor
CREATE TRIGGER classificaConta
ON Movimento
AFTER INSERT
AS
BEGIN
    DECLARE @IdConta INT;
    DECLARE @Saldo DECIMAL(10,2);
    DECLARE @TipoConta CHAR(1);
    SELECT @IdConta = IdConta, @Saldo = Saldo FROM Conta WHERE IdConta = (SELECT IdConta FROM inserted);
    IF @Saldo < 250
    BEGIN
        SET @TipoConta = 'R'; -- Risco
    END
    ELSE IF @Saldo BETWEEN 250 AND 5000
    BEGIN
        SET @TipoConta = 'E'; -- Estável
    END
    ELSE
    BEGIN
        SET @TipoConta = 'P'; -- Potencial Investidor
    END
    UPDATE Conta SET Tipo_conta = @TipoConta WHERE IdConta = @IdConta;
END

-- 1.5 Cursosres SQL






