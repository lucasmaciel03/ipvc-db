-- Active: 1709286079626@@localhost@1433@bd_testeexemplo
-- Teste de Exemplo - TSQL

-- Considere o modelo relacionaod abaixo:
-- CLIENTES (
--   id_cliente INTEGER PRIMARY KEY,
--   nome VARCHAR(100),
--   morada VARCHAR(100),
--   desconto FLOAT
-- )

-- MOVIMENTO (
--   id_movimento INTEGER PRIMARY KEY,
--   id_cliente INTEGER FOREIGN KEY REFERENCES CLIENTES,
--   data_movimneto DATE,
--   total_acumuado FLOAT
-- )

-- MOVIMENTO_PRODUTO (
--   id_produto INTEGER PRIMARY KEY,
--   id_movimento INTEGER FOREIGN KEY REFERENCES MOVIMENTO,
--   quantidade INTEGER,

-- PRODUTO (
--   id_produto INTEGER PRIMARY KEY,
--   nome VARCHAR(100),
--   preco FLOAT
--   stock INTEGER
-- )

-- SQL Code para criar as tabelas
CREATE TABLE CLIENTES (
    id_cliente INTEGER PRIMARY KEY, nome VARCHAR(100), morada VARCHAR(100), desconto FLOAT
)
-- Update all fields Desconto to 0
UPDATE CLIENTES
SET
    desconto = 0

CREATE TABLE MOVIMENTO (
    id_movimento INTEGER PRIMARY KEY, id_cliente INTEGER FOREIGN KEY REFERENCES CLIENTES, data_movimento DATE, total_acumulado FLOAT
)

CREATE TABLE MOVIMENTO_PRODUTO (
    id_produto INTEGER FOREIGN KEY REFERENCES PRODUTO, id_movimento INTEGER FOREIGN KEY REFERENCES MOVIMENTO, quantidade INTEGER
)

DROP TABLE MOVIMENTO_PRODUTO

CREATE TABLE PRODUTO (
    id_produto INTEGER PRIMARY KEY, nome VARCHAR(100), preco FLOAT, stock INTEGER
)

-- 1- Crie uma função “calcula_movimento” que tem como parâmetros o id do produto e quantidade que retorna o total do movimento. Apresenta como exemplo a chamada da função.
CREATE FUNCTION calcula_movimento(@id_produto INTEGER
, @quantidade INTEGER) RETURNS FLOAT 
-- Retorna o total do movimento 
AS 
BEGIN
DECLARE
	@total_movimento FLOAT
	SELECT @total_movimento = preco * @quantidade
	FROM PRODUTO
	WHERE
	    id_produto = @id_produto RETURN @total_movimento END
-- Código para execução 

SELECT dbo.calcula_movimento (1, 10) AS TotalMovimento
-- 2- Crie uma função “media_cliente” que tem como parâmetros o id do cliente que retorna o media do acumulado de um cliente. Apresente como exemplo a chamada da função.
CREATE FUNCTION media_cliente(@id_cliente INTEGER) 
RETURNS FLOAT AS 
BEGIN
DECLARE
	@media_acumulado FLOAT
	SELECT @media_acumulado = AVG(total_acumulado)
	FROM MOVIMENTO
	WHERE
	    id_cliente = @id_cliente RETURN @media_acumulado END
-- Código para execução 

SELECT dbo.media_cliente (1) AS MediaCliente
-- 3- Crie uma vista "lista_produtos_vendidos" que lista os produtos existentes com as colunas nome_produto, quantidade_total, valor_acumulado (quantidade total * preco) com stock inferior a 5. Apresente como exemplo a chamada da vista ordenada pelo nomedo produto de forma descendente.
CREATE VIEW lista_produtos_vendidos AS
SELECT
    P.nome AS nome_produto,
    SUM(MP.quantidade) AS quantidade_total,
    SUM(MP.quantidade) * P.preco AS valor_acumulado
FROM
    PRODUTO P
    JOIN MOVIMENTO_PRODUTO MP ON P.id_produto = MP.id_produto
GROUP BY
    P.nome,
    P.preco,
    P.stock
HAVING
    P.stock < 5
-- Call the view
SELECT * FROM lista_produtos_vendidos ORDER BY nome_produto DESC
-- Drop View lista_produtos_vendidos
DROP VIEW lista_produtos_vendidos2
-- 4- Crie um trigger “atualiza_stock” que ao inserir ou remover um movimento de produto, valida o stock do produto ao inserir e caso o stock não seja suficiente deverá retornar um mensagem/alerta indicando o stock existente senão atualiza o stock retirando as quantidades inseridas no movimento. No caso de remoção deverá repor o stock das quantidades do movimento.
CREATE TRIGGER atualiza_stock ON MOVIMENTO_PRODUTO 
AFTER INSERT, DELETE AS 
BEGIN
	SET NOCOUNT ON;
	-- This is to prevent the message "N rows affected" from being displayed
	-- Handling INSERT Operations
	IF EXISTS (
	    SELECT *
	    FROM inserted
	)
	-- Check if there are any rows inserted
	BEGIN DECLARE @stock INT,
	@need INT,
	@id_produto INT;
	-- Loop through all inserted records
	SELECT @id_produto = id_produto, @need = SUM(quantidade)
	FROM inserted
	GROUP BY
	    id_produto;
	-- Check current stock
	SELECT @stock = stock FROM PRODUTO WHERE id_produto = @id_produto;
	-- Check if there is enough stock
	IF @stock < @need BEGIN RAISERROR (
	    'Insufficiente stock. Only %d items left.', 16, 1, @stock
	);
	-- Raise an error, 16, 1 is the severity and state
	ROLLBACK TRANSACTION;
	-- Rollback the transaction
END
	ELSE BEGIN
	-- Update the stock by reducing the quantity
	UPDATE PRODUTO
	SET
	    stock = stock - @need
	WHERE
	    id_produto = @id_produto;
END
END
	-- Handling DELETE Operations
	IF EXISTS (
	    SELECT *
	    FROM deleted
	) BEGIN DECLARE @quantity INT;
	-- Loop through all deleted records
	SELECT @id_produto = id_produto, @quantity = SUM(quantidade)
	FROM deleted
	GROUP BY
	    id_produto;
	-- Update the stock by adding back the quantity
	UPDATE PRODUTO
	SET
	    stock = stock + @quantity
	WHERE
	    id_produto = @id_produto;
END
END;
	-- Execução do Trigger (INSERT)
	INSERT INTO
	    MOVIMENTO_PRODUTO
	VALUES (1, 8, 2)
	    -- Execução do Trigger (DELETE)
	DELETE FROM MOVIMENTO_PRODUTO
	WHERE
	    id_produto = 1
	    AND quantidade = 4
	    -- Delete trigger atualiza_stock
	    DROP
	TRIGGER atualiza_stock
	-- 5- Crie um trigger “atualiza_desconto” que ao atualizar o movimento, valida o acumulado total pago de todos os movimentos por parte do cliente e caso o acumulado seja superior a 1200€ então garante um desconto de 10%, isto é, atualiza o valor do desconto na tabela clientes e quando ultrapassa os 6000€ tem direito a mais 10% de desconto. O cliente terá ainda a um desconto extra de 5% após atingir o patamar dos 6000€ e ultrapassar as 1000 quantidades de umdeterminado produto. Cada um dos descontos referidos é aplicado apenas uma vez por cliente.
	CREATE
	TRIGGER atualiza_desconto ON MOVIMENTO AFTER
	UPDATE AS BEGIN
	SET
	NOCOUNT ON;
	-- Varaible to hold total paid amount and quantity for a scecific product
DECLARE
	@totalPaid FLOAT, @totalQuantity INT, @clientId INT;
	-- Check each update movement
	SELECT @clientId = id_cliente FROM inserted;
	-- Calculate total amount paid by the client across tall movements
	SELECT @totalpaid = SUM(total_acumulado)
	FROM MOVIMENTO
	WHERE
	    id_cliente = @clientId;
	-- Calculate total quantity of a specific product (assmung product ID is known, say 1)
	SELECT @totalQuantity = SUM(quantidade)
	FROM
	    MOVIMENTO_PRODUTO
	    JOIN MOVIMENTO ON MOVIMENTO_PRODUTO.id_movimento = MOVIMENTO.id_movimento
	WHERE
	    MOVIMENTO.id_cliente = @clientId
	    AND MOVIMENTO_PRODUTO.id_produto = 1;
	-- Update discount based on the total amount
	IF @totalPaid > 6000 BEGIN IF @totalQuantity > 1000 BEGIN
	-- Update to 25% discount if total quantity of the specific product exceeds 1000
	UPDATE CLIENTES
	SET
	    desconto = 20
	WHERE
	    id_cliente = @clientId
	    AND (
	        desconto IS NULL
	        OR desconto < 20
	    );
END
END
	ELSE IF @totalPaid > 1200 BEGIN
	-- Update to 10% discount if not already at or above 10%
	UPDATE CLIENTES
	SET
	    desconto = 10
	WHERE
	    id_cliente = @clientId
	    AND (
	        desconto IS NULL
	        OR desconto < 10
	    );
END
END;
	-- Delete Trigger atualiza_desconto
	DROP
	TRIGGER atualiza_desconto
	-- Execução do Trigger
	UPDATE MOVIMENTO
	SET
	    total_acumulado = 7300
	WHERE
	    id_cliente = 1
	    -- 6- Crie um procedimento “aplicaDesconto_set”, que tem como parâmetros de entrada o desconto, limite. O procedimento deverá atualizar o desconto a todos os clientes que apresentem um acumulado superior ao parâmetro limite. Por fim deverá apresentar a listagem dos clientes com desconto aplicado na qual deverá conter como colunas para alem do nome do cliente, o número de movimentos realizados e o somatório do total acumulado. Apresente uma instrução para execução do procedimento criado.
	CREATE PROCEDURE
	    aplicaDesconto_set (
	        @desconto FLOAT, @limite FLOAT
	    ) AS BEGIN
	SET
	NOCOUNT ON;
	-- Update the discount for clients with total accumulated above the limit
	UPDATE CLIENTES
	SET
	    desconto = @desconto
	FROM CLIENTES
	WHERE
	    id_cliente IN (
	        SELECT id_cliente
	        FROM MOVIMENTO
	        GROUP BY
	            id_cliente
	        HAVING
	            SUM(total_acumulado) > @limite
	    )
	    -- Select and Display the clients with the newply applied discount
	SELECT
	    CLIENTES.nome AS NomeDoCliente,
	    COUNT(MOVIMENTO.id_movimento) AS NumeroDeMovimentos,
	    sum(MOVIMENTO.total_acumulado) AS TotalAcumulado
	FROM CLIENTES
	    JOIN MOVIMENTO ON CLIENTES.id_cliente = MOVIMENTO.id_cliente
	WHERE
	    CLIENTES.desconto = @desconto
	GROUP BY
	    CLIENTES.nome END;
	-- Call the procedure
	EXEC dbo . aplicaDesconto_set @desconto = 15 . 0 , @limite = 5000;
	-- Delete the procedure
	DROP PROCEDURE aplicaDescotno_set
