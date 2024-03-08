CREATE TABLE Cliente (
    IdCliente int IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100)
);

CREATE TABLE Conta (
    IdConta int IDENTITY(1,1) PRIMARY KEY,
    Saldo DECIMAL(10,2)
);

CREATE TABLE Titular_Conta (
    IdConta int,
    IdCliente int,
    PRIMARY KEY (IdConta, IdCliente),
    FOREIGN KEY (IdConta) REFERENCES Conta(IdConta),
    FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
);

CREATE TABLE Movimento (
    IdMovimento int IDENTITY(1,1) PRIMARY KEY,
    IdConta int,
    Data DATE,
    TipoMovimento CHAR(1),
    Valor DECIMAL(10,2),
    FOREIGN KEY (IdConta) REFERENCES Conta(IdConta)
);
