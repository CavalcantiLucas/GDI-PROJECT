-- Consultas da tabela jogador
-- Jogador que tem a menor carteira
SELECT J.nome, J.carteira FROM tb_jogador J
WHERE J.carteira = (SELECT MIN(J2.carteira) FROM tb_jogador J2);
/
--
-- (REF)
DECLARE
    ref_casa REF tp_casa;
    v_casa tp_casa;
BEGIN
    SELECT REF(c) INTO ref_casa FROM tb_casa c WHERE c.cnpj = '40658419000150';
    SELECT DEREF(ref_casa) INTO v_casa FROM DUAL;
    dbms_output.put_line('Nome da Casa: ' || v_casa.nome);
    dbms_output.put_line('Saldo da Casa: R$' || v_casa.saldo);
    dbms_output.put_line('CNPJ da Casa: ' || v_casa.cnpj);
END;
/

--Consulta à VARRAY (VARRAY)
-- O nome e o número de todos os jogadores em que o número deles começa com 99
SELECT J.nome, T.numero FROM tb_jogador J, TABLE(J.telefones) T WHERE T.numero LIKE ('99%');
/
-- Constula à NESTED TABLE (NESTED TABLE)
-- Todas as fichas do cassino EL FREJO
SELECT * FROM TABLE (SELECT C.fichas FROM tb_casa C WHERE C.cnpj = '40658419000150');
/