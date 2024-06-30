SET SERVEROUTPUT ON;
-- UTENTI(IdUtente, Nome, Cognome)
-- CORSI(IdCorso, Nome, DataDa, DataA, Ora, Attivo, NumMin)
-- LEZIONI(IdLezione,IdCorso:CORSI, Data)
-- ISCRIZIONI(IdCorso:CORSI,IdUtente:UTENTI)

CREATE TABLE UTENTI(
    IdUtente NUMBER PRIMARY KEY,
    Nome VARCHAR(40),
    Cognome VARCHAR(40)
);

CREATE TABLE CORSI(
    IdCorso NUMBER PRIMARY KEY,
    Nome VARCHAR(40),
    DataDa DATE,
    DataA DATE,
    Ora NUMBER,
    Attivo CHAR(1),
    NumMin NUMBER
);

CREATE TABLE LEZIONI(
    IdLezione NUMBER,
    IdCorso NUMBER,
    Data TIMESTAMP,
    PRIMARY KEY(IdLezione, IdCorso),
    FOREIGN KEY (IdCorso) REFERENCES CORSI(IdCorso)
);

CREATE TABLE ISCRIZIONI(
    IdCorso NUMBER,
    IdUtente NUMBER,
    FOREIGN KEY (IdCorso) REFERENCES CORSI(IdCorso),
    FOREIGN KEY (IdUtente) REFERENCES UTENTI(IdUtente)
);

-- Inserimento dati nella tabella UTENTI
INSERT INTO UTENTI (IdUtente, Nome, Cognome) VALUES (1, 'Mario', 'Rossi');
INSERT INTO UTENTI (IdUtente, Nome, Cognome) VALUES (2, 'Luigi', 'Verdi');
INSERT INTO UTENTI (IdUtente, Nome, Cognome) VALUES (3, 'Anna', 'Bianchi');
INSERT INTO UTENTI (IdUtente, Nome, Cognome) VALUES (4, 'Laura', 'Neri');

-- Inserimento dati nella tabella CORSI
INSERT INTO CORSI (IdCorso, Nome, DataDa, DataA, Ora, Attivo, NumMin) VALUES (1, 'Corso di Matematica', TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-12-01', 'YYYY-MM-DD'), 10, '0', 2);
INSERT INTO CORSI (IdCorso, Nome, DataDa, DataA, Ora, Attivo, NumMin) VALUES (2, 'Corso di Fisica', TO_DATE('2024-07-15', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'), 12, '0', 1);
INSERT INTO CORSI (IdCorso, Nome, DataDa, DataA, Ora, Attivo, NumMin) VALUES (3, 'Corso di Informatica', TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 14, '0', 3);

DROP TABLE LEZIONI;
-- Inserimento dati nella tabella ISCRIZIONI
INSERT INTO ISCRIZIONI (IdCorso, IdUtente) VALUES (1, 1);
INSERT INTO ISCRIZIONI (IdCorso, IdUtente) VALUES (1, 2);
INSERT INTO ISCRIZIONI (IdCorso, IdUtente) VALUES (2, 3);
INSERT INTO ISCRIZIONI (IdCorso, IdUtente) VALUES (3, 1);
INSERT INTO ISCRIZIONI (IdCorso, IdUtente) VALUES (3, 2);
INSERT INTO ISCRIZIONI (IdCorso, IdUtente) VALUES (3, 3);
INSERT INTO ISCRIZIONI (IdCorso, IdUtente) VALUES (3, 4);


create or replace procedure AttivaCorsi(vData DATE) IS
cursor curs is SELECT c.IdCorso, c.DataDa, c.DataA, c.Ora
                FROM CORSI c
                WHERE c.Attivo = 0 AND c.DataDa>vData AND c.NumMin <=
                (SELECT COUNT(*) FROM ISCRIZIONI i WHERE i.IdCorso = c.IdCorso)
                FOR UPDATE OF c.Attivo;

currentDate date;                
idLec NUMBER(4) := 0;

BEGIN
    
    FOR corso IN curs LOOP
        idLec := 0;
        UPDATE CORSI
        SET Attivo = 1
        WHERE CURRENT OF curs; 
        currentDate := corso.DataDa;
        WHILE currentDate<=corso.DataA LOOP
            INSERT INTO LEZIONI VALUES (idLec, corso.idCorso, TO_DATE(TO_CHAR(currentDate, 'YYYY-MM-DD')|| ' ' || corso.ora || ':00:00', 'YYYY-MM-DD HH24:MI:SS'));
            currentDate := currentDate + 7;
            idLec := idLec +1;
        END LOOP;
    END LOOP;
END AttivaCorsi;
/
BEGIN
    AttivaCorsi(TO_DATE('2024-06-30', 'YYYY-MM-DD'));
END;

DELETE FROM LEZIONI;
