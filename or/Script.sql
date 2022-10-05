-- CREATE TYPE (1), FINAL MEMBER(9):
-- Tipo ENDERECO - Objeto
CREATE OR REPLACE TYPE tp_endereco AS OBJECT(
    cep VARCHAR2(8),
    complemento VARCHAR2(100),
    numero VARCHAR2(5),
    rua VARCHAR2(100)
);
/

-- CREATE TYPE (1), FINAL MEMBER(9):
-- Tipo TELEFONE - Objeto
CREATE OR REPLACE TYPE tp_telefone AS OBJECT(
    numero VARCHAR(9)
);
/

-- CREATE TYPE (1), VARRAY(19), FINAL MEMBER(9):
-- Tipo TELEFONES - VARRAY de Tp_Telefone
CREATE OR REPLACE TYPE tp_fones AS VARRAY(5) OF tp_telefone;
/

CREATE OR REPLACE TYPE tp_ficha AS OBJECT(
    cor VARCHAR(10),
    valor NUMBER
);
/
CREATE TYPE tb_fichas AS TABLE OF tp_ficha;
/ 

-- CREATE TYPE(1), FINAL MEMBER(9):
-- Tipo EMPREGO - Objeto
CREATE OR REPLACE TYPE tp_jogo AS OBJECT(
    id VARCHAR2(10),
    nome_do_jogo VARCHAR2(10),
    custo_para_jogar NUMBER
);
/

-- CREATE TYPE (1), FINAL MEMBER(9):
-- Tipo CASA - Objeto
CREATE OR REPLACE TYPE tp_casa AS OBJECT(
    cnpj VARCHAR2(14),
    nome VARCHAR2(255),
    saldo NUMBER, 
    fichas tb_fichas
);
/

-- CREATE TYPE (1), NOT FINAL (11) e NOT INSTANTIABLE(10):
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
    telefones tp_fones
    
) NOT FINAL NOT INSTANTIABLE;
/

-- CREATE TYPE (1), FINAL MEMBER(9):
-- Tipo JOGADOR - Objeto - Subtipo de tp_pessoa
CREATE OR REPLACE TYPE tp_jogador UNDER tp_pessoa(
    carteira NUMBER
);
/

-- CREATE TYPE (1), FINAL MEMBER(9):
-- Tipo FUNCIONARIO - Objeto - Subtipo de tp_funcionario
CREATE OR REPLACE TYPE tp_funcionario UNDER tp_pessoa(
    cargo_funcionario VARCHAR2(30),
    salario NUMBER,
    casa REF tp_casa --Relacionamento trabalha_em
    supervisor REF tp_funcionario, --Autorrelacionamento
    
);
/

--CREATE TYPE(1),
CREATE OR REPLACE TYPE tp_compra AS OBJECT( -- Relacionamento compra
    funcionario REF tp_funcionario,
    jogador REF tp_jogador,
    ficha REF tp_ficha,
    id VARCHAR2(10),
    valor_compra NUMBER
);
/

CREATE OR REPLACE TYPE tp_jogo_casa AS OBJECT( --Relacionamento contem
    jogo REF tp_jogo,
    casa REF tp_casa
);
/

CREATE OR REPLACE TYPE tp_joga AS OBJECT(
    jogo REF tp_jogo,
    jogador REF tp_jogador,
    funcionario REF tp_funcionario,
    datahora TIMESTAMP
);
/



------------------------------------------------------------------------
-- CREATE TABLE (13)

CREATE TABLE tb_casa OF tp_casa NESTED TABLE fichas STORE AS nt_casas; --Relacionamento Fraco
/
CREATE TABLE tb_jogador OF tp_jogador(
    cpf PRIMARY KEY
);
/
CREATE TABLE tb_funcionario OF tp_funcionario(
    cpf PRIMARY KEY,
    supervisor SCOPE IS tb_funcionario
);
/
CREATE TABLE tb_jogo OF tp_jogo(
    id PRIMARY KEY
);
/
CREATE TABLE tb_compra OF tp_compra(
    id PRIMARY KEY
);
/
CREATE TABLE tb_jogo_casa OF tp_jogo_casa(
    jogo WITH ROWID REFERENCES tb_jogo
);
/
CREATE TABLE tb_joga OF tp_joga;
/

--------------------- POVOAMENTO ---------------------

--JOGADOR--
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
                              

-- FUNCIONARIO --

--esses ainda tao errados
INSERT INTO tb_funcionario VALUES(tp_funcionario('51871590035', 'João Pedro Barreto Panda', 'M', 20,
                              tp_endereco('57071182', 'Ap 201', '280', 'Rua Nova Vida'),
                              tp_fones(tp_telefone('992665122'), tp_telefone('921571282')), 'Dealer', SELECT REF(f) FROM tb_casa c WHERE c.cnpj_casa = '40658419000150', SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '95068505005'));

INSERT INTO tb_funcionario VALUES(tp_funcionario('95068505005', 'Sara Maria da Carvalheira', 'F', 38,
                              tp_endereco('13274350', NULL, '26', 'Avenida Doutor Altino Gouveia'),
                              tp_fones(tp_telefone('991635284'), tp_telefone('921571282'), tp_telefone('988195234')), 'Supervisor', SELECT REF(f) FROM tb_casa c WHERE c.cnpj_casa = '40658419000150', NULL));

-- esses funcionarios abaixo estao incompletos
INSERT INTO tb_funcionario VALUES(tp_funcionario('99942745033', 'lucas Oliveira Cavalcanti', 'M', 30,
                              tp_endereco('57071182', 'Ap 201', '280', 'Rua Nova Vida'),
                              tp_fones(tp_telefone('992665122'), tp_telefone('921571282')), 'Caixa', SELECT REF(f) FROM tb_casa c WHERE c.cnpj_casa = '40658419000150', SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '95068505005'));

INSERT INTO tb_funcionario VALUES(tp_funcionario('61888835044', 'João Lucas Alves', 'M', 34,
                              tp_endereco('57071182', 'Ap 201', '280', 'Rua Nova Vida'),
                              tp_fones(tp_telefone('992665122'), tp_telefone('921571282')), 'Caixa', SELECT REF(f) FROM tb_casa c WHERE c.cnpj_casa = '40658419000150', SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '95068505005'));

INSERT INTO tb_funcionario VALUES(tp_funcionario('99518963088', 'Bruna Alves W. Siqueira', 'F', 35,
                              tp_endereco('57071182', 'Ap 201', '280', 'Rua Nova Vida'),
                              tp_fones(tp_telefone('992665122'), tp_telefone('921571282')), 'Dealer', SELECT REF(f) FROM tb_casa c WHERE c.cnpj_casa = '40658419000150', SELECT REF(f) FROM tb_funcionario f WHERE f.cpf = '95068505005'));

--CASA--
INSERT INTO tb_casa VALUES(tp_casa('40658419000150', 'El Frejo', 7850000, tb_fichas(tp_ficha('Branco', 1),tp_ficha('Vermelho',5),tp_ficha('Azul',10), tp_ficha('Verde',50), tp_ficha('Amarelo',100), tp_ficha('Preto',1000))))

INSERT INTO tb_casa VALUES(tp_casa('07829772000180', 'The Wild Jack', 4121000, tb_fichas(tp_ficha('Amarelo',1),tp_ficha('Rosa',10),tp_ficha('Vermelho',100), tp_ficha('Azul',500), tp_ficha('Preto',1000), tp_ficha('Verde',5000))))

INSERT INTO tb_casa VALUES(tp_casa('89619720000143', 'Tranquility Base Hotel & Casino', 8428223, tb_fichas(tp_ficha('Preto',1),tp_ficha('Rosa',10),tp_ficha('Vermelho',100), tp_ficha('Amarelo',500), tp_ficha('Azul',1000), tp_ficha('Branco',10000))))

