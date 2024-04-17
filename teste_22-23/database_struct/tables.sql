-- Active: 1709286079626@@localhost@1433@bd_teste2223
-- Considere o modelo relacional abaixo e as suas indicações apresentadas, responda com instruções TSQL.

-- Tabelas
-- Referencias(
    -- id_referencia PK
    -- id_matricula FK
    -- data_pagamento
    -- referencia
    -- valor
    --estado
-- ) 
-- Matriculas(
    -- id_matricula PK
    -- id_aluno FK
    -- id_propina FK
    -- id_curso FK
    -- prestacoes
    -- divida
    -- estado_matricula
-- )
-- Alunos(
    -- id_aluno PK
    -- nome
    -- estado
-- )
-- Propinas(
    -- id_propina PK
    -- propina
    -- grau
    -- anoletivo
--)

-- na tabela aluno o campo estado é 0 ou 1 indicando ativo ou inativo respetivamente

-- em referencias o campo estado pode ser ’PAGA’, ’EMITIDA’ ou ’ANULADA’

-- a tabela matriculas contem
    -- estado_matricula pode ser 0 que significa ’EM DIVIDA’, 1 ’REGULARIZADA’ e 2 ’SUSPENSA’
    -- prestacoes indica o numero de referencias para pagamento o valor tem de estar entre 1 e 10.
    -- o id_curso é a chave do curso em que está matriculado
    -- divida é o valor em dívida, que no momento da matricula será o total da propina sendo atualizado a cada referencia paga

-- por fim em propinas o campo propina é o valor da propina e é do tipo decimal(6,2), grau pode ser ’CTESP’, ’LICENCIATURA’, ’MESTRADO’ e anoletivo indica o ano letivo que se refere a propina(Exemplo ’202223 ’).

CREATE TABLE Referencias(
    id_referencia INT PRIMARY KEY,
    id_matricula INT FOREIGN KEY REFERENCES Matriculas(id_matricula),
    data_pagamento DATE,
    referencia VARCHAR(50),
    valor DECIMAL(6,2),
    estado VARCHAR(10)
);

CREATE TABLE Matriculas(
    id_matricula INT PRIMARY KEY,
    id_aluno INT FOREIGN KEY REFERENCES Alunos(id_aluno),
    id_propina INT FOREIGN KEY REFERENCES Propinas(id_propina),
    id_curso INT,
    prestacoes INT CHECK(prestacoes BETWEEN 1 AND 10),
    divida DECIMAL(6,2),
    estado_matricula INT CHECK(estado_matricula BETWEEN 0 AND 2)
);

CREATE TABLE Alunos(
    id_aluno INT PRIMARY KEY,
    nome VARCHAR(50),
    estado BIT
);

CREATE TABLE Propinas(
    id_propina INT PRIMARY KEY,
    propina DECIMAL(6,2),
    grau VARCHAR(50),
    anoletivo VARCHAR(50)
);

-- Add Random Data to Tables 10 rows each
INSERT INTO Alunos VALUES(1, 'Aluno 1', 1);
INSERT INTO Alunos VALUES(2, 'Aluno 2', 1);
INSERT INTO Alunos VALUES(3, 'Aluno 3', 1);
INSERT INTO Alunos VALUES(4, 'Aluno 4', 1);
INSERT INTO Alunos VALUES(5, 'Aluno 5', 1);
INSERT INTO Alunos VALUES(6, 'Aluno 6', 1);
INSERT INTO Alunos VALUES(7, 'Aluno 7', 1);
INSERT INTO Alunos VALUES(8, 'Aluno 8', 1);
INSERT INTO Alunos VALUES(9, 'Aluno 9', 1);
INSERT INTO Alunos VALUES(10, 'Aluno 10', 1);

INSERT INTO Propinas VALUES(1, 100.00, 'CTESP', '202223');
INSERT INTO Propinas VALUES(2, 200.00, 'CTESP', '202223');
INSERT INTO Propinas VALUES(3, 300.00, 'CTESP', '202223');
INSERT INTO Propinas VALUES(4, 400.00, 'CTESP', '202223');
INSERT INTO Propinas VALUES(5, 500.00, 'CTESP', '202223');
INSERT INTO Propinas VALUES(6, 600.00, 'CTESP', '202223');
INSERT INTO Propinas VALUES(7, 700.00, 'CTESP', '202223');
INSERT INTO Propinas VALUES(8, 800.00, 'CTESP', '202223');
INSERT INTO Propinas VALUES(9, 900.00, 'CTESP', '202223');
INSERT INTO Propinas VALUES(10, 1000.00, 'CTESP', '202223');

INSERT INTO Matriculas VALUES(1, 1, 1, 1, 10, 1000.00, 0);
INSERT INTO Matriculas VALUES(2, 2, 2, 1, 10, 2000.00, 0);
INSERT INTO Matriculas VALUES(3, 3, 3, 1, 10, 3000.00, 0);
INSERT INTO Matriculas VALUES(4, 4, 4, 1, 10, 4000.00, 0);
INSERT INTO Matriculas VALUES(5, 5, 5, 1, 10, 5000.00, 0);
INSERT INTO Matriculas VALUES(6, 6, 6, 1, 10, 6000.00, 0);
INSERT INTO Matriculas VALUES(7, 7, 7, 1, 10, 7000.00, 0);
INSERT INTO Matriculas VALUES(8, 8, 8, 1, 10, 8000.00, 0);
INSERT INTO Matriculas VALUES(9, 9, 9, 1, 10, 9000.00, 0);
INSERT INTO Matriculas VALUES(10, 10, 10, 1, 10, 10000.00, 0);

INSERT INTO Referencias VALUES(1, 1, '2022-01-01', 'Referencia 1', 100.00, 'EMITIDA');
INSERT INTO Referencias VALUES(2, 2, '2022-01-01', 'Referencia 2', 200.00, 'EMITIDA');
INSERT INTO Referencias VALUES(3, 3, '2022-01-01', 'Referencia 3', 300.00, 'EMITIDA');
INSERT INTO Referencias VALUES(4, 4, '2022-01-01', 'Referencia 4', 400.00, 'EMITIDA');
INSERT INTO Referencias VALUES(5, 5, '2022-01-01', 'Referencia 5', 500.00, 'EMITIDA');
INSERT INTO Referencias VALUES(6, 6, '2022-01-01', 'Referencia 6', 600.00, 'EMITIDA');
INSERT INTO Referencias VALUES(7, 7, '2022-01-01', 'Referencia 7', 700.00, 'EMITIDA');
INSERT INTO Referencias VALUES(8, 8, '2022-01-01', 'Referencia 8', 800.00, 'EMITIDA');
INSERT INTO Referencias VALUES(9, 9, '2022-01-01', 'Referencia 9', 900.00, 'EMITIDA');
INSERT INTO Referencias VALUES(10, 10, '2022-01-01', 'Referencia 10', 1000.00, 'EMITIDA');

-- Edit into table Propinas the column anoletivo to be INT
ALTER TABLE Propinas ALTER COLUMN anoletivo INT;

