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

-- 1 - Crie uma instrução que retorne por curso e ano letivo, o grau, o total em dívida, o total de propinas, o número de alunos e a média do numero de prestações ordenado por ano letivo de forma descendente.
SELECT
    pr.anoletivo AS ano_letivo,
    pr.grau AS grau,
    SUM(m.divida) AS total_divida,
    SUM(pr.propina) AS total_propina,
    COUNT(m.id_aluno) AS num_alunos,
    AVG(m.prestacoes) AS media_prestacoes
FROM
    Matriculas m
    JOIN Propinas pr ON m.id_propina = pr.id_propina
GROUP BY
    pr.anoletivo,
    pr.grau
ORDER BY
    pr.anoletivo DESC;
    
-- 2- Crie uma função chamada retorna_valor_prestacao que tem como parâmetros número de prestações e id_propina retornando o valor de uma prestação. Apresenta como exemplo a chamada da função com pârametros a escolha.
CREATE FUNCTION retorna_valor_prestacao
(
    @n_prestacoes INT,
    @id_propina INT
)
RETURNS INT
AS
BEGIN
    DECLARE @valor_prestacao INT

    SELECT @valor_prestacao = propina / @n_prestacoes
    FROM Propinas
    WHERE id_propina = @id_propina

    RETURN @valor_prestacao
END

-- Código para execução
SELECT dbo.retorna_valor_prestacao(5, 1) AS ValorPrestacao



