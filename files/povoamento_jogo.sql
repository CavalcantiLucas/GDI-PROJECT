CREATE SEQUENCE jogo_id INCREMENT BY 1 START WITH 1;

-- povoamento Jogo

INSERT INTO Jogo(id, nome, custo)
    VALUES (jogo_id.NEXTVAL, 'Blackjack', 150);

INSERT INTO Jogo(id, nome, custo)
    VALUES (jogo_id.NEXTVAL, 'Roleta', 100);

INSERT INTO Jogo(id, nome, custo)
    VALUES (jogo_id.NEXTVAL, 'Poker', 200);

INSERT INTO Jogo(id, nome, custo)
    VALUES (jogo_id.NEXTVAL, 'Roda da Fortuna', 50);

INSERT INTO Jogo(id, nome, custo)
    VALUES (jogo_id.NEXTVAL, 'Caça-Níquel', 10);

INSERT INTO Jogo(id, nome, custo)
    VALUES (jogo_id.NEXTVAL, 'Pachinko', 25);

INSERT INTO Jogo(id, nome, custo)
    VALUES (jogo_id.NEXTVAL, 'Craps', 120);

INSERT INTO Jogo(id, nome, custo)
    VALUES (jogo_id.NEXTVAL, 'Baccarat', 80);