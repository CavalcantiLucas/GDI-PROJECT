-- SQL

-- 1) ALTER TABLE
-- Adicionar um atributo que diz se o jogo é jogado em uma máquina ou fisicamente, e depois remove
ALTER TABLE Pessoa ADD CHECK (idade > 18);
/
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
/
-- 2) TABLE
-- Criar uma variável do tipo tabela para armazenar preços hipotéticos de entrada de jogos
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
/
-- 3) BLOCO ANÔNIMO
-- Criar um bloco anônimo para checar qual (e se houve) jogo jogado em uma datahora específica
-- Utilização do CASE WHEN para identificar o id do jogo que foi jogado naquela hora
DECLARE 
    v_datahora TIMESTAMP := TO_DATE('2022-08-20 23:50:34','yyyy-mm-dd hh24:mi:ss');
    v_jogoid INTEGER;
    v_nomejogo VARCHAR2(255);
BEGIN
    SELECT jogo_id INTO v_jogoid FROM Joga WHERE datahora = v_datahora;
    CASE v_jogoid
        WHEN 1 THEN v_nomejogo := 'Blackjack';
        WHEN 2 THEN v_nomejogo := 'Roleta';
        WHEN 3 THEN v_nomejogo := 'Poker';
        WHEN 4 THEN v_nomejogo := 'Roda da Fortuna';
        WHEN 5 THEN v_nomejogo := 'Caça-Níquel';
        WHEN 6 THEN v_nomejogo := 'Pachinko';
        WHEN 7 THEN v_nomejogo := 'Craps';
        WHEN 8 THEN v_nomejogo := 'Baccarat';
    END CASE;
        dbms_output.put_line(v_nomejogo);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Não houve jogo realizado nesse dia e horário.');
END;
/
-- 4) PROCEDURE
-- Criar um procedimento para Inserir uma nova partida na tabela Joga
CREATE OR REPLACE PROCEDURE InserePartida(
    p_cpfjogador IN Joga.cpf_jogador%TYPE,
    p_jogoid IN Joga.jogo_id%TYPE,
    p_datahora IN Joga.datahora%TYPE,
    p_cpffuncionario IN Joga.cpf_funcionario%TYPE) IS
BEGIN
        INSERT INTO Joga(cpf_jogador, jogo_id, datahora,cpf_funcionario)
            VALUES (p_cpfjogador, p_jogoid, p_datahora, p_cpffuncionario);
END;
/
-- Chamar o Procedimento adicionando um jogador à partida
BEGIN
    InserePartida('17932577527', 4, to_date('2022-05-29 10:32:48','yyyy-mm-dd hh24:mi:ss'), '29014744030');
END;
/
-- 5) FUNCTION
-- Função para atualizar o valor da carteira de um Jogador baseado em um jogo que ele entrou
CREATE OR REPLACE FUNCTION AtualizaCarteira(
    f_cpfjogador IN Jogador.cpf_jogador%TYPE,
    f_jogoid IN Jogo.id%TYPE) 
    RETURN NUMBER IS
        resultado Jogador.carteira%TYPE;
        carteira_atual Jogador.carteira%TYPE;
        custo_jogo Jogo.custo%TYPE;
BEGIN
        SELECT J.carteira INTO carteira_atual FROM Jogador J
        WHERE J.cpf_jogador = f_cpfjogador;

        SELECT G.Custo INTO custo_jogo FROM Jogo G
        WHERE G.id = f_jogoid;

        resultado := carteira_atual - custo_jogo;

        IF resultado < 0 
            THEN return carteira_atual;
        ELSE return resultado;
        END IF;
END;
/
-- Bloco para chamar a função Atualiza Carteira
DECLARE
    v_atualizado NUMBER;
BEGIN
    v_atualizado := AtualizaCarteira('77648271427', 3);
    dbms_output.put_line(v_atualizado);  
END;
/
-- 6) %TYPE
-- Criar uma variável do mesmo tipo que o tipo do atributo cargo da tabela Emprego
DECLARE 
    profissao Emprego.cargo%TYPE;
BEGIN
    profissao := 'Barman';
    dbms_output.put_line(profissao);
END;
/
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
/   
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
/
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
/
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
/
-- 11) WHILE LOOP
-- Criar um laço para saber qual o jogo mais jogado daquele momento
-- Para simplificar, criamos uma função MaisJogado
CREATE OR REPLACE FUNCTION MaisJogado
    RETURN NUMBER IS
        num_jogos NUMBER;
        i NUMBER; -- Número que usaremos para a condição do while
        valor_maisjogado NUMBER; -- Variável que guarda a quantidadade de vezes que o mais jogado foi jogado
        id_maisjogado NUMBER; -- Variável que guarda o id do jogo mais jogado
        auxiliar NUMBER; -- Variável que guarda o id do jogo atual
BEGIN
        i := 1;
        num_jogos := 8;
        valor_maisjogado := -1;
        WHILE (i <= num_jogos) LOOP
            SELECT COUNT(*) INTO auxiliar FROM Joga
            WHERE Joga.jogo_id = i;
            IF auxiliar > valor_maisjogado THEN
                id_maisjogado := i;
                valor_maisjogado := auxiliar;
            END IF;
            i := i + 1;
        END LOOP;
        return id_maisjogado;
END;
/
-- Bloco para facilitar o teste da função MaisJogado
DECLARE
    v_maisjogado NUMBER;
    v_nome_maisjogado VARCHAR(255);
BEGIN
    v_maisjogado := MaisJogado;
    SELECT J.nome INTO v_nome_maisjogado FROM Jogo J
    WHERE J.id = v_maisjogado;
    dbms_output.put_line(v_nome_maisjogado);
END;
/
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
/
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
/
-- 14) CURSOR (OPEN, FETCH e CLOSE)
-- Imprimir todas as informações dos funcionários em ordem alfabetica
DECLARE
    nome_cursor Pessoa.nome%TYPE;
    CURSOR cs_funcionario IS
    SELECT p.nome FROM pessoa p
    INNER JOIN funcionario f ON p.cpf = f.cpf_funcionario
    ORDER BY p.nome ASC;      
BEGIN
    OPEN cs_funcionario;
    LOOP 
        FETCH cs_funcionario INTO nome_cursor;
        EXIT WHEN cs_funcionario%NOTFOUND;
        dbms_output.put_line(nome_cursor);
    END LOOP;
    CLOSE cs_funcionario;
END;
/


-- 15) EXCEPTION WHEN
-- Funcionario tenta alterar o salário de um cargo sem ser supervisor
CREATE OR REPLACE PROCEDURE AlterarSalario(
    p_cpf_func_logado IN Funcionario.cpf_funcionario%TYPE, -- Funcionario que tenta fazer a alteração
    p_cnpj IN Emprego.cnpj_casa%TYPE, -- Cnpj da casa
    P_cargo_alterado IN Emprego.cargo%TYPE, -- Cargo que será alterado
    p_novo_valor NUMBER) -- Valor que o funcionario deseja alterar
    IS
    p_cargo_func_logado VARCHAR(30); -- Variável para obter o cargo do funcionario que deseja alterar
    not_supervisor EXCEPTION; -- Declaração da Exceção
BEGIN

    -- Consulta para checar se o funcionário é Supervisor
    SELECT F.cargo_funcionario INTO p_cargo_func_logado FROM Funcionario F
    WHERE F.cpf_funcionario = p_cpf_func_logado;

    IF p_cargo_func_logado != 'Supervisor' THEN
        RAISE not_supervisor;
    ELSE -- Entra no ELSE caso seja Supervisor
        UPDATE Emprego
        SET salario = p_novo_valor
        WHERE cargo = P_cargo_alterado AND cnpj_casa = p_cnpj;
    END IF;

    EXCEPTION
        WHEN not_supervisor THEN
        RAISE_APPLICATION_ERROR(-20215, 'Apenas Supervisores podem alterar o salário de outros funcionários');
END;
/
-- Bloco para testar o procedimento em que ocorre a exceção
BEGIN
    AlterarSalario('99942745033', '40658419000150', 'Caixa', 200000);
END;
/

-- 16) USO DE PARÂMETROS (IN, OUT ou IN OUT)
-- Procedimento para inserir nova casa como na abertura de uma nova franquia
CREATE OR REPLACE PROCEDURE insereNovaCasa(
    p_cnpj IN Casa.cnpj%TYPE,
    p_nome IN Casa.nome%TYPE,
    p_saldo IN Casa.saldo%TYPE)
    IS
BEGIN
    INSERT INTO Casa(cnpj, nome, saldo)
    VALUES (p_cnpj, p_nome, p_saldo);
END;
/
-- código de teste do procedimento
BEGIN
    insereNovaCasa('12345678900000', 'El mesos', 900000);
END;
/
-- Para checar se a casa foi adicionada
select * from casa
/
-- 17) CREATE OR REPLACE PACKAGE
-- Um pacote em que tem um procedimento e uma variável do tipo table, em que o procedimento recebe um CPF
-- E devolve uma tabela com todas as compras daquele CPF

CREATE OR REPLACE PACKAGE todas_compras AS

    TYPE t_compraTable IS TABLE OF compra.valor_compra%TYPE
    INDEX BY BINARY_INTEGER;
    
    PROCEDURE listaCompras(
        p_cpfjogador IN jogador.cpf_jogador%TYPE,
        p_valor_compra OUT t_compraTable 
    );

END todas_compras;
/

-- 18) CREATE OR REPLACE PACKAGE BODY
-- Corpo do pacote do item 17
CREATE OR REPLACE PACKAGE BODY todas_compras AS

    PROCEDURE listaCompras(
        p_cpfjogador IN jogador.cpf_jogador%TYPE,
        p_valor_compra OUT t_compraTable
    ) IS
    iterator BINARY_INTEGER;   
    valor compra.valor_compra%TYPE;
    CURSOR c_compras IS
    SELECT valor_compra FROM Compra
    WHERE cpf_jogador = p_cpfjogador;
    BEGIN
        iterator := 0;
        OPEN c_compras;
        LOOP
            FETCH c_compras INTO valor;
            EXIT  WHEN c_compras%NOTFOUND;
            iterator := iterator + 1;
            p_valor_compra(iterator) := valor;
        END LOOP; 
    END listaCompras;

END todas_compras;
/
--Testar o package
--Se quiser mudar o CPF, muda nos dois parametros, na chamada da função e no select
DECLARE
    tabela todas_compras.t_compraTable;
    quantidade NUMBER;
    iterator NUMBER;
BEGIN
    iterator := 1;
    todas_compras.listaCompras('55566621111', tabela);
    SELECT count(*) into quantidade FROM Compra WHERE cpf_jogador = '55566621111'; 
    WHILE (iterator <= quantidade)LOOP
        dbms_output.put_line(tabela(iterator));
        iterator := iterator + 1;
    END LOOP;
END;
/


-- 19) TRIGGER (COMANDO)
-- A casa não funciona no primeiro dia do mês, se alguém tentar
-- JOGAR algum jogo nesse dia, a operação não pode acontecer

-- Para testar se está funcionando, basta mudar o dia do "IF dia IN('1')" para o dia atual
-- em que você está testando
CREATE OR REPLACE TRIGGER DiaLivre
BEFORE INSERT ON Joga
DECLARE
    dia varchar(2);
    dia_livre EXCEPTION;
BEGIN
    dia := EXTRACT(day from sysdate());
    
    IF dia IN ('1') THEN
        RAISE dia_livre;
    END IF;
EXCEPTION
    WHEN dia_livre THEN
    Raise_application_error(-20202, 'Hoje o Cassino não abre! Volte amanhã!');
END;
/
-- Bloco para testar o trigger
BEGIN
    INSERT INTO Joga(cpf_jogador, jogo_id, datahora, cpf_funcionario)
    VALUES ('55566621111', 3, to_date('2022-09-01 19:10:01','yyyy-mm-dd hh24:mi:ss'), '51871590035');
END;
/


-- 20) TRIGGER (LINHA)
-- Criar um Trigger de linha para quando uma compra for inserida na tabela Compra,
-- a Casa vai ter o seu saldo incrementado com o valor da compra
CREATE OR REPLACE TRIGGER AtualizaSaldo
AFTER INSERT ON Compra
FOR EACH ROW
BEGIN
    UPDATE Casa
    SET saldo = saldo + :NEW.valor_compra
    WHERE cnpj = :NEW.cnpj_casa;
END;
/
-- Para ativar o Trigger, fizemos o bloco abaixo
BEGIN
    INSERT INTO Compra(cpf_jogador, cpf_funcionario, cor_ficha, cnpj_casa, datahora, valor_compra)
    VALUES ('42824439602', '99942745033', 'Verde', '40658419000150', to_date('2022-08-27 10:22:21','yyyy-mm-dd hh24:mi:ss'), 200);
END;
/
-- 20.1) TRIGGER (LINHA) 2.0
-- Trigger para checar se, caso um Funcionário que esteja sendo inserido
-- não seja um supervisor, ele DEVE possuir um supervisor
CREATE OR REPLACE TRIGGER tem_supervisor
BEFORE INSERT ON Funcionario
FOR EACH ROW
BEGIN
    IF :NEW.cargo_funcionario != 'Supervisor' AND :NEW.cpf_supervisor IS NULL THEN
        RAISE_APPLICATION_ERROR(-20123, 'Todo funcionário não Supervisor deve possuir um Supervisor');
    END IF;
END;
/