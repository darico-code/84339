-- Inserimento dati nella tabella PARTITI
INSERT INTO ES_PARTITI (IdPartito, Nome, Nazione) VALUES (1, 'Partito A', 'Italia');
INSERT INTO ES_PARTITI (IdPartito, Nome, Nazione) VALUES (2, 'Partito B', 'Italia');
INSERT INTO ES_PARTITI (IdPartito, Nome, Nazione) VALUES (3, 'Partito C', 'Italia');

-- Inserimento dati nella tabella CIRCOSCRIZIONE
INSERT INTO ES_CIRCOSCRIZIONE (IdCircoscrizione, Descrizione, NumSeggi) VALUES (1, 'Circoscrizione 1', 5);
INSERT INTO ES_CIRCOSCRIZIONE (IdCircoscrizione, Descrizione, NumSeggi) VALUES (2, 'Circoscrizione 2', 3);

-- Inserimento dati nella tabella CANDIDATI
INSERT INTO ES_CANDIDATI (IdCandidato, Nome, Cognome, IdPartito, IdCircoscrizione, NumPreferenze) VALUES (1, 'Mario', 'Rossi', 1, 1, 100);
INSERT INTO ES_CANDIDATI (IdCandidato, Nome, Cognome, IdPartito, IdCircoscrizione, NumPreferenze) VALUES (2, 'Luigi', 'Verdi', 1, 1, 80);
INSERT INTO ES_CANDIDATI (IdCandidato, Nome, Cognome, IdPartito, IdCircoscrizione, NumPreferenze) VALUES (3, 'Giovanni', 'Bianchi', 2, 1, 120);
INSERT INTO ES_CANDIDATI (IdCandidato, Nome, Cognome, IdPartito, IdCircoscrizione, NumPreferenze) VALUES (4, 'Paolo', 'Neri', 2, 1, 60);
INSERT INTO ES_CANDIDATI (IdCandidato, Nome, Cognome, IdPartito, IdCircoscrizione, NumPreferenze) VALUES (5, 'Anna', 'Gialli', 3, 1, 150);
INSERT INTO ES_CANDIDATI (IdCandidato, Nome, Cognome, IdPartito, IdCircoscrizione, NumPreferenze) VALUES (6, 'Franco', 'Rossi', 1, 2, 200);
INSERT INTO ES_CANDIDATI (IdCandidato, Nome, Cognome, IdPartito, IdCircoscrizione, NumPreferenze) VALUES (7, 'Laura', 'Verdi', 2, 2, 50);
INSERT INTO ES_CANDIDATI (IdCandidato, Nome, Cognome, IdPartito, IdCircoscrizione, NumPreferenze) VALUES (8, 'Dario', 'Bekic', 3, 2, 50);
INSERT INTO ES_CANDIDATI (IdCandidato, Nome, Cognome, IdPartito, IdCircoscrizione, NumPreferenze) VALUES (9, 'Dario1', 'Bekic1', 3, 2, 50);

-- Inserimento dati nella tabella VOTI
INSERT INTO ES_VOTI (IdCircoscrizione, IdPartito, NumVoti) VALUES (1, 1, 200);
INSERT INTO ES_VOTI (IdCircoscrizione, IdPartito, NumVoti) VALUES (1, 2, 300);
INSERT INTO ES_VOTI (IdCircoscrizione, IdPartito, NumVoti) VALUES (1, 3, 500);
INSERT INTO ES_VOTI (IdCircoscrizione, IdPartito, NumVoti) VALUES (2, 1, 400);
INSERT INTO ES_VOTI (IdCircoscrizione, IdPartito, NumVoti) VALUES (2, 2, 100);
INSERT INTO ES_VOTI (IdCircoscrizione, IdPartito, NumVoti) VALUES (2, 3, 15000);

SET SERVEROUTPUT ON;

create or replace procedure ElencoEletti(vCircoscrizione NUMBER) IS
cursor numSeggi is SELECT totaleVoti,  ROUND(v.NumVoti*c.NumSeggi/totaleVoti) numeroSeggi, v.IdPartito idPartito
                        FROM ES_VOTI v JOIN ES_CIRCOSCRIZIONE c ON v.IdCircoscrizione = c.IdCircoscrizione, (SELECT SUM(NumVoti) totaleVoti FROM ES_VOTI WHERE idCircoscrizione = vCircoscrizione)
                        WHERE v.IdCircoscrizione = vCircoscrizione;

cursor candidati (numeroDaEstrarrePar NUMBER, 
                  idPartitoPar NUMBER) IS SELECT IdCandidato, Nome, Cognome
                                           FROM ( SELECT IdCandidato, Nome, Cognome, NumPreferenze
                                                  FROM ES_CANDIDATI
                                                  WHERE idPartito = idPartitoPar AND
                                                  IdCircoscrizione = vCircoscrizione
                                                  ORDER BY 4 DESC)  
                                           WHERE rownum <= numeroDaEstrarrePar;

BEGIN 
    FOR partito IN numSeggi LOOP
        DBMS_OUTPUT.PUT_LINE('Per il partito con id: ' || partito.idPartito ||
        ' sono eletti: ');
        FOR candidato in candidati(partito.numeroSeggi, partito.idPartito) LOOP
            DBMS_OUTPUT.PUT_LINE('' || candidato.Nome || ' ' || candidato.Cognome);
        END LOOP;
    END LOOP;
END ElencoEletti;
/
-- Chiamata alla procedura per testare la circoscrizione 1
BEGIN
    ElencoEletti(2);
END;
/

