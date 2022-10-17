------------------------ SLIDE 1
CREATE TYPE endereco AS OBJECT(
    Rua VARCHAR2(10),
    Cidade VARCHAR2(10),
    Estado VARCHAR2(10),
    CEP VARCHAR2(10),
    
    CONSTRUCTOR FUNCTION endereco(ende VARCHAR2, cit VARCHAR2, state VARCHAR2, cep VARCHAR2) RETURN SELF AS RESULT
);
/
CREATE TYPE BODY endereco AS
    CONSTRUCTOR FUNCTION endereco(ende VARCHAR2, cit VARCHAR2, state VARCHAR2, cep VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        SELF.Rua := ende;
        SELF.Cidade := cit;
        SELF.Estado := state;
        SELF.CEP := cep;
        RETURN;
    END;
END;
/

----------------------------2
CREATE TYPE pessoa AS OBJECT(
    ID VARCHAR2(10),
    Nome VARCHAR2(100),
    ende endereco
);
/
CREATE TABLE tb_pessoa OF pessoa(
    ID PRIMARY KEY
);

INSERT INTO tb_pessoa VALUES(pessoa('1', 'Rodrigo', endereco('Real', 'Recife', 'PE', '123456')));



-----------------------------3
CREATE TYPE tp_profissional AS OBJECT(
    nome VARCHAR2(100),
    nasc VARCHAR2(10)
)NOT FINAL NOT INSTANTIABLE;
/
CREATE TYPE tp_medico UNDER tp_profissional(
    CRM VARCHAR2(110),
    especialidade VARCHAR2(100)
);
/
CREATE TYPE tp_engenheiro UNDER tp_profissional(
    CREA VARCHAR2(100)
);
/
CREATE TABLE tb_medico OF tp_medico;
/
CREATE TABLE tb_engenheiro OF tp_engenheiro;
/
INSERT INTO tb_medico VALUES(tp_medico('Robson', '10122001', '123', 'Gineco'));
INSERT INTO tb_medico VALUES(tp_medico('Ricardo', '10122001', '456', 'Pneumo'));
INSERT INTO tb_medico VALUES(tp_medico('Lucarelli', '10122001', '789', 'Oftalmo'));

INSERT INTO tb_engenheiro VALUES(tp_engenheiro('Bolsonaro', '10122201', '3210'));
INSERT INTO tb_engenheiro VALUES(tp_engenheiro('Lula', '10122201', '4858'));
INSERT INTO tb_engenheiro VALUES(tp_engenheiro('Temer', '10122201', '5471'));

SELECT * FROM tb_medico;
SELECT * FROM tb_engenheiro;


----------------------- 4
CREATE TYPE tp_retangulo AS OBJECT(
    ID NUMBER,
    Altura NUMBER,
    Largura NUMBER,
    
    MAP MEMBER FUNCTION area RETURN NUMBER,
    MEMBER PROCEDURE atualizaAltura (novaAltura NUMBER)
);
/
CREATE TYPE BODY tp_retangulo AS
    MAP MEMBER FUNCTION area RETURN NUMBER IS
    BEGIN
        RETURN Altura * Largura;
    END;
    
    MEMBER PROCEDURE atualizaAltura (novaAltura NUMBER) IS
    BEGIN
        Altura := novaAltura;
    END;
    
END;
/

DECLARE
    ret tp_retangulo;
BEGIN
    ret := tp_retangulo(1,4,6);
    ret.atualizaAltura(6);
    dbms_output.put_line(ret.area);
END;


------------------------------ 5
CREATE TYPE tp_endereco AS OBJECT(
    CEP NUMBER,
    Bairro VARCHAR2(100),
    Cidade VARCHAR2(100)
);
/
CREATE TYPE tp_cliente AS OBJECT(
    CPF NUMBER,
    Nome VARCHAR2(100),
    Ende REF tp_endereco
);
/
--------------------------------- 6
CREATE TABLE tb_endereco OF tp_endereco(
    CEP PRIMARY KEY
);
/
CREATE TABLE tb_cliente OF tp_cliente(
    CPF PRIMARY KEY,
    Ende WITH ROWID REFERENCES tb_endereco
);
/

INSERT INTO tb_endereco VALUES(tp_endereco(50610000, 'Madalena', 'Recife'));
INSERT INTO tb_endereco VALUES(tp_endereco(50610010, 'Torroes', 'Recife'));
INSERT INTO tb_endereco VALUES(tp_endereco(50610020, 'Gracas', 'Recife'));

INSERT INTO tb_cliente VALUES(tp_cliente(26589540420, 'Rodrigo', (SELECT REF(G) FROM tb_endereco G WHERE G.CEP = 50610000)));
INSERT INTO tb_cliente VALUES(tp_cliente(26589151420, 'Ricardo', (SELECT REF(G) FROM tb_endereco G WHERE G.CEP = 50610000)));
INSERT INTO tb_cliente VALUES(tp_cliente(12512085810, 'Robson', (SELECT REF(G) FROM tb_endereco G WHERE G.CEP = 50610010)));
INSERT INTO tb_cliente VALUES(tp_cliente(01854105110, 'Bolsonaro', (SELECT REF(G) FROM tb_endereco G WHERE G.CEP = 50610020)));

SELECT * FROM tb_endereco;
SELECT C.CPF, C.Nome, DEREF(C.Ende).Bairro, DEREF(C.Ende).Cidade, DEREF(C.Ende).CEP FROM tb_cliente C;


-------------------------- SLIDE 3
---------------- 4

SELECT COUNT(*), DEREF(Ende).Bairro FROM tb_cliente GROUP BY DEREF(Ende).Bairro;

------------------ 5 
CREATE TYPE tp_venda AS OBJECT(
    Valor NUMBER,
    Data VARCHAR2(10),
    Cliente REF tp_cliente
);
/
CREATE TABLE tb_venda OF tp_venda(
    Cliente WITH ROWID REFERENCES tb_cliente
);
/
INSERT INTO tb_venda VALUES(tp_venda(50, '10122001', (SELECT REF(C) FROM tb_cliente C WHERE C.CPF = 26589540420)));

-----------------6
SELECT V.valor, V.Data, DEREF(V.Cliente).Nome, DEREF(DEREF(V.Cliente).Ende).CEP FROM tb_venda V;




------------------------ SLIDE 2
---------------- 1
CREATE TYPE tp_telefone AS OBJECT (
    DDD NUMBER,
    Numero NUMBER
);
/
CREATE TYPE arr_telefones AS VARRAY(5) OF tp_telefone;
/
CREATE TYPE tp_cliente AS OBJECT(
    Codigo NUMBER,
    Nome VARCHAR2(100),
    telefones arr_telefones
);
/
CREATE TABLE tb_cliente OF tp_cliente(
    Codigo PRIMARY KEY
);
/
INSERT INTO tb_cliente VALUES(tp_cliente(1,'Rodrigo', arr_telefones(tp_telefone(11,99942142), tp_telefone(21,5312404))));

SELECT * FROM tb_cliente;
SELECT C.nome, A.DDD, A.Numero FROM tb_cliente C, TABLE(C.Telefones) A;



----------------------- 2
CREATE TYPE tp_mercadoria AS OBJECT(
    Codigo NUMBER,
    Nome VARCHAR2(100),
    Preco NUMBER
);
/
CREATE TABLE tb_mercadoria OF tp_mercadoria;
/
CREATE TYPE tp_item AS OBJECT(
    Numero NUMBER,
    Quantidade NUMBER,
    Mercadoria REF tp_mercadoria
);
/
CREATE TYPE tb_item AS TABLE OF tp_item;
/
CREATE TYPE tp_pedido AS OBJECT(
    Numero NUMBER,
    Data_pedido VARCHAR2(10),
    Data_entrega VARCHAR2(10),
    Itens tb_item
);
/
CREATE TABLE tb_pedido OF tp_pedido NESTED TABLE Itens STORE AS tb_pedidos;
/

INSERT INTO tb_mercadoria VALUES(tp_mercadoria(1, 'Carne', 100));
INSERT INTO tb_mercadoria VALUES(tp_mercadoria(2, 'Peixe', 80));
INSERT INTO tb_mercadoria VALUES(tp_mercadoria(3, 'Galinha', 50));

SELECT * FROM tb_mercadoria;

INSERT INTO tb_pedido VALUES(tp_pedido(1, '10122001', '12142001', tb_item(tp_item(1,10,(SELECT REF(M) FROM tb_mercadoria M WHERE M.Nome = 'Carne')), tp_item(2,5, (SELECT REF(M) FROM tb_mercadoria M WHERE M.Nome = 'Galinha')))));
INSERT INTO tb_pedido VALUES(tp_pedido(2, '10122001', '12142001', tb_item(tp_item(3,8,(SELECT REF(M) FROM tb_mercadoria M WHERE M.Nome = 'Peixe')), tp_item(4,1, (SELECT REF(M) FROM tb_mercadoria M WHERE M.Nome = 'Carne')))));

SELECT P.Numero AS Cliente, I.Quantidade, DEREF(I.Mercadoria).Nome AS Mercadoria FROM tb_pedido P, TABLE(P.ITENS) I;


--------------- REVISÃO DE VALERIA
----------------- 1
CREATE TYPE tp_medidasCorporais AS OBJECT(
    Biceps NUMBER,
    Torax NUMBER,
    Coxa NUMBER
);
/
CREATE TYPE tp_Membro AS OBJECT(
    Codigo NUMBER,
    Altura NUMBER,
    Nome VARCHAR2(100),
    Idade NUMBER,
    Medidas tp_medidasCorporais,

    MEMBER FUNCTION RetornoNome RETURN VARCHAR2,
    MEMBER PROCEDURE DadosMembro
);
/
CREATE TYPE BODY tp_Membro AS
    MEMBER FUNCTION RetornoNome RETURN VARCHAR2 IS
    BEGIN
        RETURN Nome;
    END;

    MEMBER PROCEDURE DadosMembro IS
    BEGIN
        dbms_output.put_line('Código: ' || Codigo);
        dbms_output.put_line('Altura: ' || Altura);
        dbms_output.put_line('Nome: ' || Nome);
        dbms_output.put_line('Idade: ' || Idade);
        dbms_output.put_line('Biceps: ' || Medidas.Biceps);
        dbms_output.put_line('Torax: ' || Medidas.Torax);
        dbms_output.put_line('Coxa: ' || Medidas.Coxa);
    END;
END;
/
CREATE TYPE tp_horario AS OBJECT(
    Hora VARCHAR2(10),
    Dia VARCHAR2(10)
);
/
CREATE TYPE arr_hora AS VARRAY(5) OF tp_horario;
/
CREATE TYPE tp_membro_hora AS OBJECT(
    Membro REF tp_membro,
    Hora arr_hora
);
/
CREATE TYPE nt_membros AS TABLE OF tp_membro_hora;
/
CREATE TYPE tp_treinamento AS OBJECT(
    Codigo NUMBER,
    Nome VARCHAR2(100),
    Objetivo VARCHAR2(100),
    Participantes nt_membros,

    MEMBER FUNCTION quantidadeInscritos RETURN INTEGER,
    MAP MEMBER FUNCTION ordenaPorNome RETURN VARCHAR2
);
/
CREATE TYPE BODY tp_treinamento AS
    MEMBER FUNCTION quantidadeInscritos RETURN INTEGER IS
    qnt INTEGER;
    BEGIN
        SELECT COUNT(*) INTO qnt FROM TABLE(Participantes);
        RETURN qnt;  --Funciona?
    END;

    MAP MEMBER FUNCTION ordenaPorNome RETURN VARCHAR2 IS
    BEGIN
        RETURN Nome;
    END;
END;
/
CREATE TABLE tb_treinamento OF tp_treinamento NESTED TABLE Participantes STORE AS tb_treinamentos;
/
CREATE TABLE tb_Membro OF tp_Membro(Codigo PRIMARY KEY);
/

INSERT INTO tb_Membro VALUES(tp_Membro(1, 195, 'Rodrigo', 20, tp_medidasCorporais(40, 30, 50)));
INSERT INTO tb_Membro VALUES(tp_Membro(2, 170, 'Marina', 24, tp_medidasCorporais(50, 60, 30)));
INSERT INTO tb_Membro VALUES(tp_Membro(3, 185, 'Gustavo', 29, tp_medidasCorporais(80, 40, 70)));
INSERT INTO tb_Membro VALUES(tp_Membro(4, 160, 'Lucao', 28, tp_medidasCorporais(60, 20, 80)));
INSERT INTO tb_Membro VALUES(tp_Membro(5, 180, 'Artu', 22, tp_medidasCorporais(90, 30, 70)));
INSERT INTO tb_Membro VALUES(tp_Membro(6, 182, 'Raissa', 30, tp_medidasCorporais(50, 40, 60)));


INSERT INTO tb_treinamento VALUES(tp_treinamento(1, 'Marinheiro', 'Ficar Forte', nt_membros(
    tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Nome = 'Rodrigo'), arr_hora(tp_horario('10:50', 'Segunda'), tp_horario('13:20','Terça'))),
    tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Nome = 'Marina'), arr_hora(tp_horario('10:50', 'Segunda'), tp_horario('13:20','Quarta'))),
    tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Nome = 'Gustavo'), arr_hora(tp_horario('18:50', 'Sabado'), tp_horario('19:20','Sabado')))
)));
INSERT INTO tb_treinamento VALUES(tp_treinamento(2, 'Prancha', 'Abdomen', nt_membros(
    tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Nome = 'Lucao'), arr_hora(tp_horario('10:50', 'Quarta'), tp_horario('13:20','Terça'))),
    tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Nome = 'Artu'), arr_hora(tp_horario('10:50', 'Quarta'), tp_horario('13:20','Terça'))),
    tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Nome = 'Raissa'), arr_hora(tp_horario('18:50', 'Sabado'), tp_horario('19:20','Sabado')))
)));
INSERT INTO tb_treinamento VALUES(tp_treinamento(3, 'Remador', 'Costas', nt_membros(
    tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Nome = 'Rodrigo'), arr_hora(tp_horario('10:50', 'Segunda'), tp_horario('13:20','Terça'))),
    tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Nome = 'Lucao'), arr_hora(tp_horario('10:50', 'Segunda'), tp_horario('13:20','Quarta'))),
    tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Nome = 'Artu'), arr_hora(tp_horario('10:50', 'Segunda'), tp_horario('19:20','Sabado')))
)));
INSERT INTO tb_treinamento VALUES(tp_treinamento(4, 'Condicionamento Físico', 'Fortalecer músculos', nt_membros(
    tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Codigo = 1), arr_hora(tp_horario('19:00', 'Segunda'), tp_horario('07:00','Quarta'), tp_horario('15:00','Sexta'))),
    tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Codigo = 2), arr_hora(tp_horario('08:00', 'Terça'), tp_horario('15:00','Quinta'), tp_horario('10:00','Sabado')))
)));


SELECT M.Codigo, M.Altura, M.Nome, M.Idade, M.Medidas.Biceps, M.Medidas.Torax, M.Medidas.Coxa FROM tb_Membro M;
SELECT M.Codigo, M.Altura, M.Nome, M.Idade, M.Medidas.Biceps, M.Medidas.Torax, M.Medidas.Coxa FROM tb_Membro M WHERE M.Medidas.Coxa = 70;

SELECT T.Nome, T.Objetivo, DEREF(P.Membro).Nome AS NOME, H.HORA AS HORA FROM tb_treinamento T, TABLE(T.Participantes) P, TABLE(P.HORA) H;
SELECT T.Nome, T.Objetivo, DEREF(P.Membro).Nome AS NOME, H.HORA AS HORA FROM tb_treinamento T, TABLE(T.Participantes) P, TABLE(P.HORA) H WHERE H.Dia = 'Segunda';


------------------------ 2
SELECT T.Objetivo, DEREF(P.Membro).Nome AS NOME, DEREF(P.Membro).Altura AS ALTURA, DEREF(P.Membro).Medidas.Biceps, DEREF(P.Membro).Medidas.Torax, DEREF(P.Membro).Medidas.Coxa, H.Hora, H.Dia FROM tb_treinamento T, TABLE(T.Participantes) P, TABLE(P.Hora) H WHERE T.Nome = 'Condicionamento Físico';

------------------------- 3
SELECT T.OBJETIVO, T.Participantes FROM tb_treinamento T WHERE T.Nome = 'Condicionamento Físico'; 
--Nao funciona de verdade

------------------------ 4
DECLARE
    p tp_Membro;
BEGIN
    SELECT VALUE(M) INTO p FROM tb_Membro M WHERE M.Idade = (SELECT MAX(Idade) FROM tb_Membro);
    dbms_output.put_line(p.RetornoNome);
END;
--OU
SELECT M.RetornoNome() AS Nome FROM tb_Membro M WHERE M.Idade = (SELECT MAX(Idade) FROM tb_Membro);

------------------------ 5 
DECLARE
    p tp_Membro;
BEGIN
    SELECT VALUE(M) INTO p FROM tb_Membro M WHERE M.Codigo = 1;
    p.DadosMembro;
END;

------------------------ 6
DECLARE
    t tp_treinamento;
BEGIN
    SELECT VALUE(tr) INTO t FROM tb_treinamento tr WHERE tr.nome = 'Condicionamento Físico';
    dbms_output.put_line(t.quantidadeInscritos);
END;
--OU
SELECT tr.quantidadeInscritos() AS Quantidade FROM tb_treinamento tr WHERE tr.nome = 'Condicionamento Físico';

--------------------------- 7 
SELECT T.Nome, T.Objetivo, DEREF(P.Membro).Nome AS NOME, H.HORA AS HORA FROM tb_treinamento T, TABLE(T.Participantes) P, TABLE(P.HORA) H ORDER BY T.ordenaPorNome();

-------------------------- 8 
INSERT INTO TABLE(SELECT t.Participantes FROM tb_treinamento t WHERE t.nome = 'Prancha') VALUES(tp_membro_hora((SELECT REF(P) FROM tb_Membro P WHERE P.Nome = 'Rodrigo'), arr_hora(tp_horario('8:00', 'Quarta'), tp_horario('11:00','Sexta'))));

-------------------------- 9
DECLARE
    aux arr_hora;
    i INTEGER;
BEGIN 
    SELECT P.Hora INTO aux FROM tb_treinamento T, TABLE(T.Participantes) P WHERE T.Nome = 'Condicionamento Físico' AND DEREF(P.Membro).Codigo = 1;
    aux.EXTEND;
    i := aux.COUNT;
    aux(i) := tp_horario('10:00', 'Sabado');
    UPDATE TABLE(SELECT T.Participantes FROM tb_treinamento T WHERE T.Nome = 'Condicionamento Físico') P SET P.Hora = aux WHERE DEREF(P.Membro).Codigo = 1;
END;


-------------------------- 10
SELECT T.Nome, H.hora, H.Dia FROM tb_treinamento T, TABLE(T.Participantes) P, TABLE(P.Hora) H WHERE DEREF(P.Membro).Nome = 'Raissa';