-- 1) ALTER TABLE
-- Adicionar um atributo que diz se o jogo é jogado em uma máquina ou fisicamente, e depois remove
ALTER TABLE jogo ADD (MaquinaOuFisico VARCHAR2(20));
ALTER TABLE jogo DROP (MaquinaOuFisico);

-- 2) CREATE INDEX
-- Criar um index para o salario dos cargos
CREATE INDEX indice_salario ON Emprego(salario);

-- 3) INSERT INTO
-- Inserindo uma nova compra
INSERT INTO Compra(cpf_jogador, cpf_funcionario, cor_ficha, cnpj_casa, datahora, valor_compra)
    VALUES ('62982197499', '35170942001', 'Azul', '89619720000143', to_date('2022-08-20 17:10:01','yyyy-mm-dd hh24:mi:ss'), 5000);

-- 4) UPDATE 
-- Atualizar o endereço de uma pessoa que se mudou
UPDATE Pessoa
SET cep_endereco = '94853810'
WHERE cpf = '95068505005';

-- 5) DELETE
-- Apagar a tupla que inserimos no INSERTO INTO (item 3)
DELETE FROM Compra
WHERE cpf_jogador = '62982197499'
AND valor_compra = 5000;

-- 6) SELECT FROM WHERE
-- Consultar o cpf dos jogadores e o valor da compra na tabela de compras em que a ficha tem a cor Preto
SELECT cpf_jogador, valor_compra FROM compra 
WHERE cor_ficha = 'Preto';

-- 7) BETWEEN
-- Consultar o cpf dos jogadores que tem o valor da carteira entre 1000 e 10000 reais
SELECT cpf_jogador FROM Jogador
WHERE carteira BETWEEN 1000 AND 10000;

-- 8) IN
-- Consultar o nome e o salario dos funcionarios que são Dealers ou Caixas
SELECT p.nome, e.salario FROM Funcionario f, Pessoa p, Emprego e
WHERE f.cpf_funcionario = p.cpf
AND f.cargo_funcionario = e.cargo
AND f.cnpj_casa = e.cnpj_casa
AND f.cargo_funcionario IN ('Caixa', 'Dealer');

-- 9) LIKE
-- Consultar a quantidade de pessoas que o nome começa com 'a'
SELECT count(*) FROM Pessoa 
WHERE nome LIKE 'A%';

-- 10) IS NULL
-- Consultar o cpf dos jogadores e o id do jogo que não tem funcionário participando do jogo
SELECT cpf_jogador, jogo_id FROM joga 
WHERE cpf_funcionario IS NULL;

-- 11) INNER JOIN
-- Consultar o nome da pessoa e o nome da rua de onde ele mora
SELECT p.cpf, e.rua FROM Pessoa p
INNER JOIN Endereco e ON e.cep = p.cep_endereco;

-- 12) MAX
-- Consultar o custo máximo para participar de um jogo
SELECT MAX(custo) FROM JOGO;

-- 13) MIN
-- Consultar o custo mínimo para participar de um jogo
SELECT MIN(custo) FROM JOGO;

-- 14) AVG
-- Consultar o custo médio para participar de um jogo
SELECT AVG(custo) FROM JOGO;

-- 15) COUNT
-- Consultar quantos jogos de poker o jogador de cpf '55566621111' participou
SELECT count(*) FROM joga
WHERE jogo_id = 3
AND cpf_jogador = '55566621111';

-- 16) LEFT JOIN 
-- Consultar o nome dos jogos que têm funcionários participando
SELECT DISTINCT jogo.nome FROM funcionario f
LEFT OUTER JOIN joga ON f.cpf_funcionario = joga.cpf_funcionario
INNER JOIN jogo ON joga.jogo_id = jogo.id;

-- 17) SUBCONSULTA COM OPERADOR RELACIONAL
-- Consultar o ID e o nome dos jogos que tem o custo de entrada maior que a média dos custos de entrada dos jogos
SELECT id, nome FROM Jogo
WHERE custo > (SELECT AVG(custo) FROM jogo);

-- 18) SUBCONSULTA COM IN
-- Consultar o CPF e o nome do jogador, alem do ID do jogo, de uma partida(JOGA) que tem o custo de entrada maio que 100 reais
SELECT j.cpf_jogador, p.nome, j.jogo_id FROM Joga j, Pessoa p
WHERE j.jogo_id IN (SELECT id FROM Jogo WHERE custo > 100)
AND j.cpf_jogador = p.cpf
ORDER BY j.jogo_id, p.nome;


-- 19) SUBCONSULTA COM ANY
-- Consultar o id e o nome do jogo em que o id é igual do que pelo menos uma partida em que
-- o funcionário de cpf '99518963088' participa
SELECT id, nome FROM Jogo
WHERE id = ANY (SELECT jogo_id FROM Joga
                    WHERE id = jogo_id
                    AND cpf_funcionario = '99518963088');

-- 20) SUBCONSULTA COM ALL
-- Consultar todos os salários que são maiores que todos os salários da casa de cnpj '89619720000143'
SELECT salario FROM Emprego e
WHERE salario > ALL (SELECT f.salario FROM Emprego f
                    WHERE f.cnpj_casa = '89619720000143');

-- 21) ORDER BY
-- Consultar o nome dos cargos dos funcionarios na casa 1, ordenados pelo salario
SELECT cargo FROM Emprego 
WHERE cnpj_casa = '40658419000150'
ORDER BY salario;

-- 22) GROUP BY
-- Consultar o sexo e a quantidade de pessoas daquele sexo
SELECT sexo, Count(*) as QUANTIDADE FROM Pessoa
GROUP BY sexo;

-- 23) HAVING
-- Consultar as casas que só tem um funcionário supervisor
SELECT f.cnpj_casa FROM funcionario f
where f.cargo_funcionario = 'Supervisor'
GROUP BY f.cnpj_casa
having count(*) = 1;

-- 24) INTERSECT
-- Consultar as cores de ficha que tem em comum entre as casas 1 (cnpj = 40658419000150) e 2 (cnpj = 07829772000180)
SELECT cor FROM Ficha_casa
WHERE cnpj_casa = '40658419000150'
INTERSECT
    SELECT cor FROM Ficha_casa
    WHERE cnpj_casa = '07829772000180';

-- 25) CREATE VIEW
-- Criando uma visão sobre a consulta de funcionários da casa 1 (cnpj = 40658419000150)
CREATE OR REPLACE VIEW func_casa1 AS
SELECT f.cpf_funcionario, f.cargo_funcionario FROM funcionario f
WHERE f.cnpj_casa = '40658419000150';

select cpf_funcionario from func_casa1;

-- 26) GRANT / REVOKE
-- Dar a permissão de fazer um select nas tabelas Jogo e compra para public, e depois tirar isso apenas da tabela compra
GRANT SELECT ON Compra TO public;
GRANT SELECT ON Jogo TO public;
REVOKE SELECT ON Compra FROM public;

