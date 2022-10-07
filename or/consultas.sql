-- Consultas da tabela jogador
-- Jogador que tem a menor carteira
SELECT J.nome, J.carteira FROM tb_jogador J
WHERE J.carteira = (SELECT MIN(J2.carteira) FROM tb_jogador J2);

--
-- (REF)


-- Consultas da tabela funcionario (DEREF)
-- Funcionários que têm o cargo caixa e trabalham na casa de cnpj 40658419000150
SELECT F.nome, DEREF(F.casa).nome as casa FROM tb_funcionario F
WHERE F.cargo_funcionario = 'Caixa'
AND DEREF(F.casa).cnpj = '40658419000150';


--Consulta à VARRAY (VARRAY)
-- O nome e o número de todos os jogadores em que o número deles começa com 99
SELECT J.nome, T.numero FROM tb_jogador J, TABLE(J.telefones) T WHERE T.numero LIKE ('99%');

-- Constula à NESTED TABLE (NESTED TABLE)
-- Todas as fichas do cassino EL FREJO
SELECT * FROM TABLE (SELECT C.fichas FROM tb_casa C WHERE C.cnpj = '40658419000150');