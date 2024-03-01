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

--  Tabela Movimento (IdConta, IdMovimento, Data, TipoMovimento, Valor)
CREATE TABLE Movimento (
    IdMovimento int IDENTITY(1,1) PRIMARY KEY,
    IdConta int,
    Data DATE,
    TipoMovimento CHAR(1),
    Valor DECIMAL(10,2),
    FOREIGN KEY (IdConta) REFERENCES Conta(IdConta)
);

