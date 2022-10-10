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

-- Consulta à tabela compra
-- Retorna o valor da compra e casa onde foi realizada a compra por um Jogador específico
SELECT C.valor_compra, DEREF(DEREF(C.funcionario).casa).nome AS Casa FROM tb_compra C
WHERE DEREF(C.jogador).cpf = '94044687544';

-- Consulta à VARRAY (VARRAY)
-- O nome e o telefone de todos os jogadores em que o telefone deles começa com 99
SELECT J.nome, T.numero FROM tb_jogador J, TABLE(J.telefones) T WHERE T.numero LIKE ('99%');
/

-- Consulta à NESTED TABLE (NESTED TABLE)
-- Todas as fichas do cassino EL FREJO
SELECT * FROM TABLE (SELECT C.fichas FROM tb_casa C WHERE C.cnpj = '40658419000150');
/

-- Consulta à NESTED TABLE Fichas
-- Cores das fichas que custam 100 em cada uma das casas
SELECT C.nome, F.cor FROM tb_casa C, TABLE (C.fichas) F WHERE F.valor = 100;

-- Consulta à tabela de funcionarios
-- Retornar a quantidade de supervisores que são mulheres
SELECT COUNT (*) AS QTD_MULHERES_SUPERVISORAS FROM tb_funcionario C WHERE DEREF(C.supervisor).sexo = 'F';
/

-- Consulta à tabela de jogos
-- Retornar a média de custo dos jogos
SELECT AVG(custo_jogo) AS custo_medio FROM tb_jogo C;
/

-- Consulta à tabela jogo_casa
-- Consultar um jogo específico e saber quais casas oferecem aquele jogo
SELECT DEREF(J.jogo).nome_jogo AS nome_jogo, DEREF(J.casa).nome AS nome_casa
FROM tb_jogo_casa J 
WHERE DEREF(J.jogo).id = '3'
/

-- Consulta à tabela tb_funcionario
-- Retorna nome, salario e casa do funcionário mais bem pago entre os cassinos
SELECT F.nome, F.salario, DEREF(F.casa).nome AS casa FROM tb_funcionario F
WHERE F.salario = (SELECT MAX(F2.salario) FROM tb_funcionario F2)