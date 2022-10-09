-- Teste do ORDER MEMBER FUNCTION comparaSaldo
DECLARE
    resultado NUMBER;
    casa tp_casa;
    casa2 tp_casa;
BEGIN
    SELECT VALUE(C) INTO casa FROM tb_casa C WHERE C.cnpj = '40658419000150';
    SELECT VALUE(C2) INTO casa2 FROM tb_casa C2 WHERE C2.cnpj = '89619720000143';
    resultado := casa.comparaSaldo(casa2);
    IF(resultado = -1) THEN dbms_output.put_line('Saldo menor'); END IF;
    IF(resultado = 0) THEN dbms_output.put_line('Saldo igual'); END IF;
    IF(resultado = 1) THEN dbms_output.put_line('Saldo maior'); END IF;
END;
/
-- Teste do MAP MEMBER FUNCTION
-- Teste do MAP MEMBER FUNCTION comparaNome
-- Chamamos a MAP MEMBER function implícita e explícitamente
DECLARE
    resultado VARCHAR2(255);
    resultado2 VARCHAR2(255);
    func tp_funcionario;
    func2 tp_funcionario;
BEGIN
    SELECT VALUE(F) INTO func FROM tb_funcionario F WHERE F.cpf = '95068505005';
    SELECT VALUE(F2) INTO func2 FROM tb_funcionario F2 WHERE F2.cpf = '51871590035';
    resultado := func.comparaNome();
    resultado2 := func2.comparaNome();
    IF (resultado < resultado2) THEN
    dbms_output.put_line('Com MAP explícito, menor nome: ' || resultado);
    ELSE
    dbms_output.put_line('Com MAP explícito, menor nome: ' || resultado2);
    END IF;
    
    IF (func < func) THEN
    dbms_output.put_line('Com MAP implícito, menor nome: ' || func.nome);
    ELSE
    dbms_output.put_line('Com MAP implícito, menor nome: ' || func2.nome);
    END IF;
END;
/
-- Teste do FINAL MEMBER PROCEDURE display_endereco
DECLARE
    joga tp_jogador;
BEGIN
    SELECT VALUE(J) INTO joga FROM tb_jogador J WHERE J.CPF = '94044687544';
    joga.display_endereco;
END;
/
-- Teste dos MEMBER's PROCEDURE's display_info
DECLARE
    joga tp_jogador;
    func tp_funcionario;
BEGIN
    SELECT VALUE(J) INTO joga FROM tb_jogador J WHERE J.CPF = '94044687544';
    SELECT VALUE(F) INTO func FROM tb_funcionario F WHERE F.CPF = '99942745033';
    joga.display_info;
    dbms_output.put_line('------------------');
    func.display_info;
END;
/
-- Teste do MEMBER FUNCTION salarioAnual
DECLARE
    salarioAnual NUMBER;
    func tp_funcionario;
BEGIN
    SELECT VALUE(F) INTO func FROM tb_funcionario F WHERE F.CPF = '99518963088';
    salarioAnual := func.salarioAnual;
    dbms_output.put_line(salarioAnual);
END;
/

-- Teste do CONSTRUCTOR FUNCTION tp_funcionario
-- esperar o feedback dos monitores
DECLARE
    v_func tp_funcionario;
BEGIN
    v_func := tp_funcionario('12345678911', 'Rutra Sarvalho dos Cantos', 'M', 26);
    dbms_output.put_line(v_func.cpf);
    dbms_output.put_line(v_func.nome);
    dbms_output.put_line(v_func.sexo);
    dbms_output.put_line(v_func.idade);
END;
/