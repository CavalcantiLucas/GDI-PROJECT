-- SQL

-- 1) ALTER TABLE
-- Adicionar um atributo que diz se o jogo é jogado em uma máquina ou fisicamente, e depois remove
ALTER TABLE Pessoa ADD CHECK (idade > 18);

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






-- PL SQL

-- 1) RECORD
-- Criar uma variável do tipo registro de um Funcionário
DECLARE
    TYPE Funcionario IS RECORD(
        nome VARCHAR2(255),
        CPF VARCHAR2(11),
        salario NUMBER,
        cargo VARCHAR2(30)
    );

    func_register Funcionario;
BEGIN
    func_register.nome := 'Rodrigo';
    func_register.CPF := '12345678910';
    func_register.salario := 9999;
    func_register.cargo := 'Dealer';
    
    dbms_output.put_line(func_register.nome);
    dbms_output.put_line(func_register.CPF);
    dbms_output.put_line(func_register.salario);
    dbms_output.put_line(func_register.cargo);
END;

-- 2) TABLE
-- Criar uma variável do tipo tabela, para armazenar preços hipotéticos de entrada de jogos
DECLARE
    TYPE Tabela_Precos IS TABLE OF Jogo.custo%TYPE
    INDEX BY BINARY_INTEGER;
    variavel_tabela Tabela_Precos;
BEGIN
    variavel_tabela(1) := 50;
    variavel_tabela(2) := 30;
    variavel_tabela(3) := 100;

    dbms_output.put_line(variavel_tabela(1));
    dbms_output.put_line(variavel_tabela(2));
    dbms_output.put_line(variavel_tabela(3));
END;

-- 6) %TYPE
-- Criar uma variável do mesmo tipo que o tipo do atributo cargo da tabela Emprego
DECLARE 
    profissao Emprego.cargo%TYPE;
BEGIN
    profissao := 'Barman';
    dbms_output.put_line(profissao);
END;

-- 7) %ROWTYPE
-- Criar uma variável de registro de tipo igual à tabela Joga
DECLARE
    v_joga Joga%ROWTYPE;
BEGIN
    v_joga.cpf_jogador := '17932577527';
    v_joga.jogo_id := 4;
    v_joga.datahora := CURRENT_TIMESTAMP;
    v_joga.cpf_funcionario := '35170942001';
    
    dbms_output.put_line(v_joga.cpf_jogador);
    dbms_output.put_line(v_joga.jogo_id);
    dbms_output.put_line(v_joga.datahora);
    dbms_output.put_line(v_joga.cpf_funcionario);
END;
    
-- 8) IF ELSIF
-- Checar se o custo medio de entrada dos jogos é caro, justo ou barato
DECLARE
    custo_medio NUMBER;
    custo NUMBER;
BEGIN
    SELECT AVG(custo) INTO custo_medio FROM Jogo;
    IF custo_medio > 100
        THEN dbms_output.put_line('Caro');
    ELSIF custo_medio > 50
        THEN dbms_output.put_line('Preço Justo');
    ELSE dbms_output.put_line('Barato');
    END IF;
END;

-- 9) CASE WHEN
-- Iterar pelos preços das fichas da casa que tem o cnpj '40658419000150', e printar a cor das fichas relacionados aqueles preços
BEGIN
    FOR precoEntrada IN(SELECT valor FROM Ficha_casa WHERE cnpj_casa = '40658419000150') LOOP
        CASE precoEntrada.valor
            WHEN 1 THEN dbms_output.put_line('Ficha Branca'); 
            WHEN 5 THEN dbms_output.put_line('Ficha Vermelha');
            WHEN 10 THEN dbms_output.put_line('Ficha Azul');
            WHEN 50 THEN dbms_output.put_line('Ficha Verde');
            WHEN 100 THEN dbms_output.put_line('Ficha Amarela');
            WHEN 1000 THEN dbms_output.put_line('Ficha Preta'); 
        END CASE;
    END LOOP;
END;

-- 10) LOOP EXIT WHEN
-- Iterar sobre todos os indices da variável tabela Tabela_Precos
DECLARE
    TYPE Tabela_Precos IS TABLE OF Jogo.custo%TYPE
    INDEX BY BINARY_INTEGER;
    variavel_tabela Tabela_Precos;
    iterator NUMBER;
BEGIN
    variavel_tabela(1) := 50;
    variavel_tabela(2) := 30;
    variavel_tabela(3) := 100;
    variavel_tabela(4) := 300;
    variavel_tabela(5) := 150;
    iterator := 1;
    LOOP
        dbms_output.put_line('Custo de entrada: ' || variavel_tabela(iterator));
        iterator := iterator + 1;
    EXIT WHEN iterator > 5;
    END LOOP;
END;

-- 11) WHILE LOOP
--  
DECLARE
    
BEGIN

END;

-- 12) FOR IN LOOP
-- Iterar por cada funcionário e contar quantos funcionários não gerenciaram nenhuma partida
DECLARE
    cont_func_sem_jogos NUMBER;
    igual NUMBER; -- verifica se já encontrou um funcionário no jogo
BEGIN
    cont_func_sem_jogos := 0;
    FOR func_atual IN (SELECT f.cpf_funcionario FROM Funcionario f) LOOP -- para cada funcionario
        igual := 0;
        FOR func_jogo IN (SELECT j.cpf_funcionario FROM Joga j) LOOP -- para cada jogo
            IF func_atual.cpf_funcionario = func_jogo.cpf_funcionario THEN -- se o funcionario tiver no jogo
                igual := 1;
            END IF;
        END LOOP;
        IF igual = 0 THEN -- se o funcionario nao estava em nenhum jogo
            cont_func_sem_jogos := cont_func_sem_jogos + 1;
        END IF;
    END LOOP;
    dbms_output.put_line('Existem '|| cont_func_sem_jogos || ' funcionários sem participar de nenhuma partida.');
END;

-- 13) SELECT ... INTO
-- Armazenar em uma variável o cargo, salário e cnpj da casa que paga o maior salário

DECLARE
    v_emprego Emprego%ROWTYPE;
    v_max_salario NUMBER;
BEGIN
    SELECT MAX(salario) INTO v_max_salario FROM EMPREGO;

    SELECT * INTO v_emprego FROM Emprego
    WHERE salario = v_max_salario;

    dbms_output.put_line(v_emprego.cargo);
    dbms_output.put_line(v_emprego.salario);
    dbms_output.put_line(v_emprego.cnpj_casa);
END;