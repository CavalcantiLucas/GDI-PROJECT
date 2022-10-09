-- Consultas da tabela jogador
-- Jogador que tem a menor carteira
SELECT J.nome, J.carteira FROM tb_jogador J
WHERE J.carteira = (SELECT MIN(J2.carteira) FROM tb_jogador J2);
/
--
-- (REF)
-- Inserir uma nova compra
INSERT INTO tb_compra VALUES(tp_compra(
    (SELECT REF(F) FROM tb_funcionario F WHERE F.cpf = '61888835044'),
    (SELECT REF(J) FROM tb_jogador J WHERE J.cpf = '19321816283'),
    (SELECT VALUE(FC) FROM tb_casa c, TABLE(c.fichas) FC WHERE FC.cor = 'Azul' AND c.cnpj = '07829772000180'),
    6,
    3500
));
/

-- (DEREF)
-- Funcionários que têm o cargo caixa e trabalham na casa de cnpj 40658419000150
SELECT F.nome, DEREF(F.casa).nome as casa FROM tb_funcionario F
WHERE F.cargo_funcionario = 'Caixa'
AND DEREF(F.casa).cnpj = '40658419000150';
/
-- Nomes dos funcionários e dos seus supervisores que trabalham na casa el frejo
SELECT F.nome, DEREF(F.supervisor).nome AS supervisor FROM tb_funcionario F
WHERE DEREF(F.casa).cnpj = '40658419000150';
/
-- Nomes dos jogadores que jogaram poker
SELECT DEREF(J.jogador).nome AS Jogador FROM tb_joga J
WHERE DEREF(J.jogo).nome_jogo = 'Poker';
/
-- Nome dos jogadores que compraram fichas na casa The Wild Jack
SELECT DEREF(C.jogador).nome AS Jogador FROM tb_compra C
WHERE DEREF(DEREF(C.funcionario).casa).nome = 'The Wild Jack';

--Consulta à VARRAY (VARRAY)
-- O nome e o telefone de todos os jogadores em que o telefone deles começa com 99
SELECT J.nome, T.numero FROM tb_jogador J, TABLE(J.telefones) T WHERE T.numero LIKE ('99%');
/

-- Constula à NESTED TABLE (NESTED TABLE)
-- Todas as fichas do cassino EL FREJO
SELECT * FROM TABLE (SELECT C.fichas FROM tb_casa C WHERE C.cnpj = '40658419000150');
/