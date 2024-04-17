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

-- 3- Crie uma vista chamada vista_alunos_divida_superior_3 que apresente as colunas id_matricula, id_aluno, nome do aluno, grau, curso, ano letivo, prestações,valor da prestação (deve usar a funcao), valor propina, divida, referencias pagas (número de referencias no estado PAGA),referencias em dívida (número referencias no estado EMITIDA). A vista deverá agrupar a informação e apresentar apenas os alunos com mais de 3 referencias por pagar. Apresente como exemplo a chamada da vista ordenada pelo id_aluno e filtrado para o ano letivo ’202223’ e para o curso com ’9119’.
CREATE VIEW vista_alunos_divida_superior_3 AS
SELECT
    m.id_matricula,
    a.id_aluno,
    a.nome,
    p.grau,
    m.id_curso AS curso,
    p.anoletivo AS ano_letivo,
    m.prestacoes,
    p.propina / CAST(m.prestacoes AS DECIMAL(10,2)) AS valor_prestacao,
    p.propina AS valor_propina,
    m.divida,
    COUNT(CASE WHEN r.estado = 'PAGA' THEN 1 END) AS referencias_pagas,
    COUNT(CASE WHEN r.estado = 'EMITIDA' THEN 1 END) AS referencias_em_divida
FROM
    Matriculas m
    INNER JOIN Alunos a ON m.id_aluno = a.id_aluno
    INNER JOIN Propinas p ON m.id_propina = p.id_propina
    LEFT JOIN Referencias r ON m.id_matricula = r.id_matricula
GROUP BY
    m.id_matricula,
    a.id_aluno,
    a.nome,
    p.grau,
    m.id_curso,
    p.anoletivo,
    m.prestacoes,
    p.propina,
    m.divida
HAVING
    COUNT(CASE WHEN r.estado = 'EMITIDA' THEN 1 END) > 3
