-- CREATE TYPE (1):
-- Tipo ENDERECO - Objeto
CREATE OR REPLACE TYPE tp_endereco AS OBJECT(
    cep VARCHAR2(8),
    complemento VARCHAR2(100),
    numero VARCHAR2(5),
    rua VARCHAR2(100)
);
/

-- CREATE TYPE (1):
-- Tipo TELEFONE - Objeto
CREATE OR REPLACE TYPE tp_telefone AS OBJECT(
    numero VARCHAR(9)
);
/

-- CREATE TYPE (1), VARRAY(19):
-- Tipo TELEFONES - VARRAY de Tp_Telefone
CREATE OR REPLACE TYPE tp_fones AS VARRAY(5) OF tp_telefone;
/

-- CREATE TYPE(1)
-- Tipo FICHA
CREATE OR REPLACE TYPE tp_ficha AS OBJECT(
    cor VARCHAR(10),
    valor NUMBER
);
/
-- CREATE TYPE(1)
-- TABELA DE FICHAS
CREATE TYPE tb_fichas AS TABLE OF tp_ficha;
/ 

-- CREATE TYPE(1):
-- Tipo EMPREGO - Objeto
CREATE OR REPLACE TYPE tp_jogo AS OBJECT(
    id VARCHAR2(10),
    nome_do_jogo VARCHAR2(20),
    custo_para_jogar NUMBER
);
/

-- CREATE TYPE (1), ORDER MEMBER FUNCTION(5):
-- Tipo CASA - Objeto
CREATE OR REPLACE TYPE tp_casa AS OBJECT(
    cnpj VARCHAR2(14),
    nome VARCHAR2(255),
    saldo NUMBER, 
    fichas tb_fichas,

    ORDER MEMBER FUNCTION comparaSaldo (SELF IN OUT NOCOPY tp_casa, x tp_casa) RETURN NUMBER
);
/
-- ORDER MEMBER FUNCTION (5), CREATE TYPE BODY(2)
-- Corpo do tipo casa
CREATE OR REPLACE TYPE BODY tp_casa AS
    ORDER MEMBER FUNCTION comparaSaldo (SELF IN OUT NOCOPY tp_casa, x tp_casa) RETURN NUMBER IS
    BEGIN 
        IF SELF.saldo < x.saldo THEN
            RETURN -1;
        ELSIF SELF.saldo > x.saldo THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END;
END;
/
-- CREATE TYPE (1), NOT FINAL (11) e NOT INSTANTIABLE(10), MEMBER PROCEDURE(3), MAP MEMBER(6), FINAL MEMBER(9):
-- Tipo PESSOA - Objeto,
-- São NOT FINAL e NOT INSTANTIABLE porque
-- é tp_jogador e tp_funcionario irão herdar dele
-- e todo tp_pessoa deve ser ou Jogador, ou Funcionário, portanto
-- não é instanciável
CREATE OR REPLACE TYPE tp_pessoa AS OBJECT (
    cpf VARCHAR2(11),
    nome VARCHAR2(255),
    sexo VARCHAR2(1),
    idade NUMBER(2),
    endereco tp_endereco,
    telefones tp_fones,
    
    FINAL MEMBER PROCEDURE display_endereco,
    MEMBER PROCEDURE display_info,
    MAP MEMBER FUNCTION comparaNome RETURN VARCHAR2

) NOT FINAL NOT INSTANTIABLE;
/

-- CREATE TYPE BODY(2), MEMBER PROCEDURE(3), MAP MEMBER FUNCTION(6)
-- Procedimento para visualizar informações de um jogador
CREATE OR REPLACE TYPE BODY tp_pessoa AS

    FINAL MEMBER PROCEDURE display_endereco IS
    BEGIN
        dbms_output.put_line('CEP: ' || endereco.cep);
        dbms_output.put_line('Rua: ' || endereco.rua);
        dbms_output.put_line('Número: ' || endereco.numero);
        dbms_output.put_line('Complemento: ' || endereco.complemento);
    END;

    MEMBER PROCEDURE display_info IS
    BEGIN
        dbms_output.put_line('Nome: ' || nome);
        dbms_output.put_line('CPF: ' || cpf);
        dbms_output.put_line('Sexo: ' || sexo);
        dbms_output.put_line('Idade: ' || idade);
    END;
    
    MAP MEMBER FUNCTION comparaNome RETURN VARCHAR2 IS
    BEGIN
        RETURN nome;
    END;
END;
/
-- CREATE TYPE (1), OVERRIDING MEMBER(8):
-- Tipo JOGADOR - Objeto - Subtipo de tp_pessoa
CREATE OR REPLACE TYPE tp_jogador UNDER tp_pessoa(
    carteira NUMBER,

    OVERRIDING MEMBER PROCEDURE display_info
);
/

-- CREATE TYPE BODY(2), OVERRIDING MEMBER PROCEDURE(3)
-- Procedimento para visualizar informações de um jogador
CREATE OR REPLACE TYPE BODY tp_jogador AS

    OVERRIDING MEMBER PROCEDURE display_info IS
    BEGIN
        dbms_output.put_line('Nome: ' || nome);
        dbms_output.put_line('CPF: ' || cpf);
        dbms_output.put_line('Sexo: ' || sexo);
        dbms_output.put_line('Idade: ' || idade);
        dbms_output.put_line('Carteira: ' || carteira);
        
    END;
    
END;
/
-- CREATE TYPE (1), OVERRIDING MEMBER PROCEDURE(8), CONSTRUCTOR FUNCTION(7), REF(15):
-- Tipo FUNCIONARIO - Objeto - Subtipo de tp_funcionario
CREATE OR REPLACE TYPE tp_funcionario UNDER tp_pessoa(
    cargo_funcionario VARCHAR2(30),
    salario NUMBER,
    casa REF tp_casa, --Relacionamento trabalha_em
    
    
    OVERRIDING MEMBER PROCEDURE display_info,
    MEMBER FUNCTION salarioAnual RETURN NUMBER,
    CONSTRUCTOR FUNCTION tp_funcionario(x1 tp_funcionario) RETURN SELF AS RESULT
);
/
-- ALTER TYPE (12)
-- Alterando funcionário para adicionar o seu supervisor
ALTER TYPE tp_funcionario
    ADD ATTRIBUTE(supervisor REF tp_funcionario) CASCADE;
/

-- CREATE TYPE BODY(2), OVERRIDING MEMBER PROCEDURE(3), CONSTRUCTOR FUNCTION(7)
-- Corpo do tp_funcionario
CREATE OR REPLACE TYPE BODY tp_funcionario AS
    OVERRIDING MEMBER PROCEDURE display_info IS
    BEGIN
        dbms_output.put_line('Nome: ' || nome);
        dbms_output.put_line('CPF: ' || cpf);
        dbms_output.put_line('Sexo: ' || sexo);
        dbms_output.put_line('Idade: ' || idade);
        dbms_output.put_line('Cargo: ' || cargo_funcionario);
        dbms_output.put_line('Salário: ' || salario);
    END;

    MEMBER FUNCTION salarioAnual RETURN NUMBER IS
    BEGIN
        RETURN salario*12;
    END;

    CONSTRUCTOR FUNCTION tp_funcionario (x1 tp_funcionario) RETURN SELF AS RESULT IS 
    BEGIN
        cpf := x1.cpf;
        nome := x1.nome;
        sexo := x1.sexo;
        idade := x1.idade;
        endereco := x1.endereco;
        telefones := x1.telefones;
        cargo_funcionario := x1.cargo_funcionario;
        salario := x1.salario;
        casa := x1.casa;
        supervisor := x1.supervisor;
        RETURN;
    END;

END;
/
--CREATE OR REPLACE TYPE(1), REF(15)
-- Tipo compra
CREATE OR REPLACE TYPE tp_compra AS OBJECT(
    funcionario REF tp_funcionario,
    jogador REF tp_jogador,
    ficha tp_ficha,
    id VARCHAR2(10),
    valor_compra NUMBER
);
/
--CREATE OR REPLACE TYPE(1), REF(15)
-- Tipo Jogo_casa
CREATE OR REPLACE TYPE tp_jogo_casa AS OBJECT( --Relacionamento contem
    jogo REF tp_jogo,
    casa REF tp_casa
);
/
--CREATE OR REPLACE TYPE(1), REF(15)
-- Tipo joga
CREATE OR REPLACE TYPE tp_joga AS OBJECT(
    jogo REF tp_jogo,
    jogador REF tp_jogador,
    funcionario REF tp_funcionario,
    datahora TIMESTAMP
);
/





------------------------------------------------------------------------
-- CREATE TABLE (13), NESTED TABLE(20)
-- tabela de casas
CREATE TABLE tb_casa OF tp_casa (
    cnpj PRIMARY KEY
) NESTED TABLE fichas STORE AS nt_casas;
/
-- CREATE TABLE (13)
-- tabela de jogadores
CREATE TABLE tb_jogador OF tp_jogador(
    cpf PRIMARY KEY
);
/
-- CREATE TABLE (13), SCOPE IS(16)
-- tabela de funcionarios
CREATE TABLE tb_funcionario OF tp_funcionario(
    cpf PRIMARY KEY,
    supervisor SCOPE IS tb_funcionario
);
/
-- CREATE TABLE (13)
-- tabela de jogos
CREATE TABLE tb_jogo OF tp_jogo(
    id PRIMARY KEY
);
/
-- CREATE TABLE (13)
-- tabela de compras
CREATE TABLE tb_compra OF tp_compra(
    id PRIMARY KEY
);
/
-- CREATE TABLE (13), WITH ROWID(14)
-- tabela de jogos que tem em uma casa
CREATE TABLE tb_jogo_casa OF tp_jogo_casa(
    jogo WITH ROWID REFERENCES tb_jogo,
    casa WITH ROWID REFERENCES tb_casa
);
/
-- CREATE TABLE (13)
-- tabela de partidas que ocorreram
CREATE TABLE tb_joga OF tp_joga;
/



--------------------- POVOAMENTO ---------------------

-- Inserções da tabela JOGADOR
-- INSERT INTO(17)
INSERT INTO tb_jogador VALUES(tp_jogador('55566621111', 'Agatha Ottoni', 'F', 40,
                              tp_endereco('85304390', NULL, '1023', 'Rua das Canafístulas'),
                              tp_fones(tp_telefone('992665122'), tp_telefone('921571282')), 300));

INSERT INTO tb_jogador VALUES(tp_jogador('19321816283', 'Victor Matheus de Azevedo P.', 'M', 52,
                              tp_endereco('58420430', 'Ap 602', '224', 'Rua Alaíde Leandro Sobreira'),
                              tp_fones(tp_telefone('997415326'), tp_telefone('91234567')), 3000));

INSERT INTO tb_jogador VALUES(tp_jogador('94044687544', 'Lucas Gabriel R. de Melo', 'M', 25,
                              tp_endereco('19067100', 'Ap 2002', '471', 'Rua Santa Pavezi Rubim'),
                              tp_fones(tp_telefone('993547816'), tp_telefone('981357891')), 600));

INSERT INTO tb_jogador VALUES(tp_jogador('34864572097', 'Ana Carla Albuquerque', 'F', 28,
                              tp_endereco('65632660', 'Ap 904', '63', 'Rua Três'),
                              tp_fones(tp_telefone('991348915'), tp_telefone('935478915')), 5000));
 
INSERT INTO tb_jogador VALUES(tp_jogador('42824439602', 'Gabriel Barbosa Almeida', 'M', 26,
                              tp_endereco('89218055', 'Ap 3001', '1226', 'Rua Blumenau'),
                              tp_fones(tp_telefone('947589268'), tp_telefone('915745987')), 10000));                             
                              

-- Inserções da tabela FUNCIONARIO
-- INSERT INTO(17), REF(15)
INSERT INTO tb_funcionario VALUES(tp_funcionario('95068505005', 'Sara Maria da Carvalheira', 'F', 38,
                              tp_endereco('13274350', NULL, '26', 'Avenida Doutor Altino Gouveia'),
                              tp_fones(tp_telefone('991635284'), tp_telefone('921571282'), tp_telefone('988195234')),
                              'Supervisor', 8000, (SELECT REF(c) FROM tb_casa c WHERE c.cnpj = '40658419000150'), NULL));

INSERT INTO tb_funcionario VALUES(tp_funcionario('51871590035', 'João Pedro Barreto Panda', 'M', 20,
                              tp_endereco('57071182', 'Ap 201', '280', 'Rua Nova Vida'),
                              tp_fones(tp_telefone('992665122'), tp_telefone('921571282')), 
                              'Dealer', 5000, (SELECT REF(c) FROM tb_casa c WHERE c.cnpj = '40658419000150'), 
                              (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '95068505005')));

INSERT INTO tb_funcionario VALUES(tp_funcionario('99942745033', 'Lucas Oliveira Cavalcanti', 'M', 30,
                              tp_endereco('54505390', NULL, '322', 'Rua Conde da Boa Vista'),
                              tp_fones(tp_telefone('992005132')), 'Caixa', 3500, (SELECT REF(c) FROM tb_casa c WHERE c.cnpj = '40658419000150'), (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '42777797005')));

INSERT INTO tb_funcionario VALUES(tp_funcionario('61888835044', 'João Lucas Alves', 'M', 34,
                              tp_endereco('69908650', NULL, '89', 'Avenida Getúlio Vargas'),
                              tp_fones(tp_telefone('992665122'), tp_telefone('921571282')), 'Caixa', 2850, (SELECT REF(c) FROM tb_casa c WHERE c.cnpj = '07829772000180'), (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '16790533028')));

INSERT INTO tb_funcionario VALUES(tp_funcionario('99518963088', 'Bruna Alves W. Siqueira', 'F', 35,
                              tp_endereco('23092490', 'Ap 1202', '90', 'Rua São Bento do Sul'),
                              tp_fones(tp_telefone('912245118'), tp_telefone('995481078')), 'Dealer', 6400, (SELECT REF(c) FROM tb_casa c WHERE c.cnpj = '07829772000180'), (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '16790533028')));
        
INSERT INTO tb_funcionario VALUES(tp_funcionario('49869393004', 'Andreia Duboc', 'F', 46,
                              tp_endereco('60831160', NULL, '777', 'Rua Lourdes Vidal Alves'),
                              tp_fones(tp_telefone('994887659')), 'Supervisor', 6550, (SELECT REF(c) FROM tb_casa c WHERE c.cnpj = '89619720000143'), NULL));

INSERT INTO tb_funcionario VALUES(tp_funcionario('66559107060', 'Matheus Frej Lemos C.', 'M', 62,
                              tp_endereco('74971460', 'Ap 101', '800', 'Travessa 1'),
                              tp_fones(tp_telefone('992342832'), tp_telefone('995481378'),tp_telefone('991222418')), 'Dealer', 4900, (SELECT REF(c) FROM tb_casa c WHERE c.cnpj = '89619720000143'), (SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '49869393004')));

-- Inserções da tabela CASA
-- INSERT INTO(17), NESTED TABLE(20)
INSERT INTO tb_casa VALUES(tp_casa('40658419000150', 'El Frejo', 7850000, tb_fichas(tp_ficha('Branco', 1),tp_ficha('Vermelho',5),tp_ficha('Azul',10), tp_ficha('Verde',50), tp_ficha('Amarelo',100), tp_ficha('Preto',1000))));

INSERT INTO tb_casa VALUES(tp_casa('07829772000180', 'The Wild Jack', 4121000, tb_fichas(tp_ficha('Amarelo',1),tp_ficha('Rosa',10),tp_ficha('Vermelho',100), tp_ficha('Azul',500), tp_ficha('Preto',1000), tp_ficha('Verde',5000))));

INSERT INTO tb_casa VALUES(tp_casa('89619720000143', 'Tranquility Base Hotel & Casino', 8428223, tb_fichas(tp_ficha('Preto',1),tp_ficha('Rosa',10),tp_ficha('Vermelho',100), tp_ficha('Amarelo',500), tp_ficha('Azul',1000), tp_ficha('Branco',10000))));


-- Inserções da tabela JOGO
-- INSERT INTO(17)
INSERT INTO tb_jogo VALUES(tp_jogo('1','Blackjack',150));
INSERT INTO tb_jogo VALUES(tp_jogo('2','Roleta',100));
INSERT INTO tb_jogo VALUES(tp_jogo('3','Poker',200));
INSERT INTO tb_jogo VALUES(tp_jogo('4','Roda da Fortuna',50));
INSERT INTO tb_jogo VALUES(tp_jogo('5','Caça-Níquel',10));


-- Inserções da tabela COMPRA
-- INSERT INTO(17), VALUE(18), REF(15)
INSERT INTO tb_compra VALUES(tp_compra(
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '99942745033'),
    (SELECT REF(J) FROM tb_jogador J WHERE J.cpf = '55566621111'),
    (SELECT VALUE(FC) FROM tb_casa c, TABLE(c.fichas) FC WHERE FC.cor = 'Branco' AND c.cnpj = '40658419000150'),
    1,
    100
));

INSERT INTO tb_compra VALUES(tp_compra(
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '61888835044'),
    (SELECT REF(J) FROM tb_jogador J WHERE J.cpf = '19321816283'),
    (SELECT VALUE(FC) FROM tb_casa c, TABLE(c.fichas) FC WHERE FC.cor = 'Vermelho' AND c.cnpj = '07829772000180'),
    2,
    500
));

INSERT INTO tb_compra VALUES(tp_compra(
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '99942745033'),
    (SELECT REF(J) FROM tb_jogador J WHERE J.cpf = '94044687544'),
    (SELECT VALUE(FC) FROM tb_casa c, TABLE(c.fichas) FC WHERE FC.cor = 'Preto' AND c.cnpj = '40658419000150'),
    3,
    10000
));

INSERT INTO tb_compra VALUES(tp_compra(
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '99942745033'),
    (SELECT REF(J) FROM tb_jogador J WHERE J.cpf = '38612505780'),
    (SELECT VALUE(FC) FROM tb_casa c, TABLE(c.fichas) FC WHERE FC.cor = 'Amarelo' AND c.cnpj = '40658419000150'),
    4,
    500
));

INSERT INTO tb_compra VALUES(tp_compra(
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '61888835044'),
    (SELECT REF(J) FROM tb_jogador J WHERE J.cpf = '26744842684'),
    (SELECT VALUE(FC) FROM tb_casa c, TABLE(c.fichas) FC WHERE FC.cor = 'Verde' AND c.cnpj = '07829772000180'),
    5,
    5000
));


-- Inserções da tabela JOGO-CASA
-- INSERT INTO(17), REF(15)
INSERT INTO tb_jogo_casa VALUES (tp_jogo_casa(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '1'),
    (SELECT REF(C) FROM tb_casa C WHERE C.cnpj = '40658419000150'))
);
INSERT INTO tb_jogo_casa VALUES (tp_jogo_casa(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '2'),
    (SELECT REF(C) FROM tb_casa C WHERE C.cnpj = '40658419000150'))
);
INSERT INTO tb_jogo_casa VALUES (tp_jogo_casa(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '3'),
    (SELECT REF(C) FROM tb_casa C WHERE C.cnpj = '07829772000180'))
);
INSERT INTO tb_jogo_casa VALUES (tp_jogo_casa(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '4'),
    (SELECT REF(C) FROM tb_casa C WHERE C.cnpj = '07829772000180'))
);
INSERT INTO tb_jogo_casa VALUES (tp_jogo_casa(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '5'),
    (SELECT REF(C) FROM tb_casa C WHERE C.cnpj = '89619720000143'))
);
INSERT INTO tb_jogo_casa VALUES (tp_jogo_casa(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '3'),
    (SELECT REF(C) FROM tb_casa C WHERE C.cnpj = '89619720000143'))
);


-- Inserções da tabela JOGA
-- INSERT INTO(17), REF(15)
INSERT INTO tb_joga VALUES(tp_joga(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '3'),
    (SELECT REF(JG) FROM tb_jogador JG WHERE JG.cpf = '55566621111'),
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '51871590035'),
    to_date('2022-08-31 19:10:01','yyyy-mm-dd hh24:mi:ss')
));
INSERT INTO tb_joga VALUES(tp_joga(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '3'),
    (SELECT REF(JG) FROM tb_jogador JG WHERE JG.cpf = '94044687544'),
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '51871590035'),
    to_date('2022-08-31 19:10:01','yyyy-mm-dd hh24:mi:ss')
));
INSERT INTO tb_joga VALUES(tp_joga(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '5'),
    (SELECT REF(JG) FROM tb_jogador JG WHERE JG.cpf = '19321816283'),
    NULL,
    to_date('2022-02-27 19:45:56','yyyy-mm-dd hh24:mi:ss')
));
INSERT INTO tb_joga VALUES(tp_joga(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '4'),
    (SELECT REF(JG) FROM tb_jogador JG WHERE JG.cpf = '34864572097'),
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '99518963088'),
    to_date('2022-05-27 13:42:34','yyyy-mm-dd hh24:mi:ss')
));
INSERT INTO tb_joga VALUES(tp_joga(
    (SELECT REF(J) FROM tb_jogo J WHERE J.id = '1'),
    (SELECT REF(JG) FROM tb_jogador JG WHERE JG.cpf = '42824439602'),
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '99518963088'),
    to_date('2022-05-28 14:50:12','yyyy-mm-dd hh24:mi:ss')
));
