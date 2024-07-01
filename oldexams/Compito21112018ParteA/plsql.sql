SET SERVEROUTPUT ON;

CREATE TABLE CAMPO(
    IdCampo NUMBER PRIMARY KEY,
    NomeCampo VARCHAR(30),
    Luogo VARCHAR(30)
)

INSERT INTO CAMPO VALUES (1, 'Wimbledon', 'via 1');
INSERT INTO CAMPO VALUES (2, 'Santiago Bernabeu', 'via 2');

CREATE TABLE UTENTE (
    IdUser NUMBER PRIMARY KEY,
    Nome VARCHAR(30),
    Telefono VARCHAR(10)
)

INSERT INTO UTENTE VALUES(1, 'Dario', '3334445555');
INSERT INTO UTENTE VALUES(2, 'Leonardo', '1112223333');
INSERT INTO UTENTE VALUES(3, 'Andrea', '0001115566');

CREATE TABLE PRENOTAZIONE (
    IdCampo NUMBER,
    IdUser NUMBER,
    Data date,
    OraInizio NUMBER CHECK(OraInizio < 24 OR OraInizio >= 0),
    OraFine NUMBER CHECK(OraFine < 24 OR OraFine >= 0),
    PRIMARY KEY (IdCampo, Data, OraInizio),
    FOREIGN KEY (IdCampo) REFERENCES CAMPO(IdCampo),
    FOREIGN KEY (IdUser) REFERENCES UTENTE(IdUser)
)

INSERT INTO PRENOTAZIONE VALUES (1, 1, '10-Feb-2019', 14, 19);
INSERT INTO PRENOTAZIONE VALUES (1, 2, '01-Mar-2020', 14, 19);
INSERT INTO PRENOTAZIONE VALUES (2, 1, '01-May-2020', 14, 19);

create or replace procedure insPrenotazione(vCampo NUMBER, vUtente NUMBER, vDa DATE, vA DATE, vOraI NUMBER , vOraFine NUMBER) IS
cursor curs is SELECT IdUser utente, data, IdCampo campoId, OraInizio, OraFine
                FROM prenotazione
                WHERE data >= vDa AND data <= vA
                AND ((OraFine > vOraI AND OraFine <= vOraFine) OR (vOraFine > OraInizio AND  vOraFine <= OraFine))
                AND IdCampo = vCampo AND EXTRACT(DAY FROM VDa) = EXTRACT(DAY FROM data);
rec curs%ROWTYPE;
currentDate DATE;
BEGIN
    OPEN curs;
    FETCH curs INTO rec;
    IF curs%NOTFOUND THEN
        currentDate := vDa;
        DBMS_OUTPUT.PUT_LINE('Prenotazione disponibile');
        WHILE currentDate <= vA LOOP
            INSERT INTO PRENOTAZIONE VALUES(vCampo, vUtente, currentDate, vOraI, vOraFine);
            currentDate := currentDate + 7;
        END LOOP;
    ELSE 
        WHILE curs%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Prenotazione in conflitto: campo '|| rec.campoId
            || ' data ' || rec.data || ' orario ' || rec.OraInizio || '-'||rec.OraFine ||
            ' utente ' || rec.utente);
            FETCH curs INTO rec;
        END LOOP;
    END IF;
    
END insPrenotazione;
/
BEGIN 
    InsPrenotazione (1,1,'01-Mar-2020','18-Mar-2020',21,23);
END;