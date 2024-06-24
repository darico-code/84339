SET SERVEROUTPUT ON;

CREATE TABLE PAZIENTI (
CF VARCHAR(26) PRIMARY KEY,
Nome VARCHAR(20),
Cognome VARCHAR(20),
Sesso CHAR(1),
DataN date)

CREATE TABLE PRESTAZIONI(
Cod CHAR(4) PRIMARY KEY,
Nome VARCHAR(20),
Costo NUMBER)

CREATE TABLE RICOVERI(
Paziente VARCHAR(26),
DataInizio date,
DataFine date,
PRIMARY KEY(Paziente, DataInizio),
FOREIGN KEY(Paziente) REFERENCES PAZIENTI(CF)
)

CREATE TABLE EROGAZIONI (
Paziente VARCHAR(26),
DataRicovero date, 
Prestazione CHAR(4),
PRIMARY KEY(Paziente, DataRicovero, Prestazione),
FOREIGN KEY(Paziente, DataRicovero) REFERENCES RICOVERI(Paziente, DataInizio),
FOREIGN KEY(Prestazione) REFERENCES PRESTAZIONI(Cod)
)

INSERT INTO PAZIENTI VALUES ('AAAA', 'JOHN', 'DOE', 'M', '21-JAN-2001');
INSERT INTO PAZIENTI VALUES ('BBBB', 'JANE', 'SMITH', 'F', '02-MAR-2011');
INSERT INTO PAZIENTI VALUES ('CCCC', 'BOB', 'JONES', 'M', '11-JAN-1993');

INSERT INTO PRESTAZIONI VALUES ('CCCC', 'massaggio 1', 222);
INSERT INTO PRESTAZIONI VALUES ('CDDD', 'massaggio 2', 42343);
INSERT INTO PRESTAZIONI VALUES ('CCCD', 'massaggio 3', 2212);
INSERT INTO PRESTAZIONI VALUES ('CCCE', 'massaggio 4', 22);
INSERT INTO PRESTAZIONI VALUES ('CCCF', 'massaggio 5', 21);

INSERT INTO RICOVERI VALUES ('AAAA', '23-FEB-2024','25-FEB-2024');
INSERT INTO RICOVERI VALUES ('AAAA', '26-FEB-2024','13-MAR-2024');
INSERT INTO RICOVERI VALUES ('BBBB', '21-FEB-2024','21-MAR-2024');
INSERT INTO RICOVERI VALUES ('CCCC', '21-FEB-2023','21-MAR-2024');

INSERT INTO EROGAZIONI VALUES ('AAAA','23-FEB-2024','CCCC');
INSERT INTO EROGAZIONI VALUES ('AAAA','23-FEB-2024','CCCF');
INSERT INTO EROGAZIONI VALUES ('BBBB','21-FEB-2024','CCCD');
INSERT INTO EROGAZIONI VALUES ('AAAA','23-FEB-2024','CCCD');
INSERT INTO EROGAZIONI VALUES ('AAAA','26-FEB-2024','CCCD');

SELECT paziente, di, df FROM (SELECT r.Paziente paziente, r.dataInizio di, r.dataFine df, (r.dataFine - r.dataInizio) durata,  CASE
                                                    WHEN (r.dataFine - r.dataInizio) >= 7 THEN 20 + SUM(pr.costo) - (r.dataFine - r.dataInizio)*2
                                                    ELSE (15 + SUM(pr.costo) - (r.dataFine - r.dataInizio)*1.5)
                                                    END costo_totale
                FROM Ricoveri r JOIN Erogazioni e ON r.Paziente = e.Paziente JOIN
                PRESTAZIONI pr ON e.prestazione = pr.Cod
                WHERE r.datafine IS NOT NULL AND r.dataInizio >= '20-FEB-2024' AND r.dataFine <= '31-DEC-2024'
                GROUP BY r.Paziente, r.dataInizio, r.dataFine
                ORDER BY costo_totale DESC) 
                WHERE rownum <= 1;

create or replace procedure Costi(dataInizioPar date, dataFinePar date) IS
Cursor curs IS SELECT * FROM 
                            (SELECT paziente, di, df FROM (SELECT r.Paziente paziente, r.dataInizio di, r.dataFine df, (r.dataFine - r.dataInizio) durata,  CASE
                                                    WHEN (r.dataFine - r.dataInizio) >= 7 THEN 20 + SUM(pr.costo) - (r.dataFine - r.dataInizio)*2
                                                    ELSE (15 + SUM(pr.costo) - (r.dataFine - r.dataInizio)*1.5)
                                                    END costo_totale
                FROM Ricoveri r JOIN Erogazioni e ON r.Paziente = e.Paziente JOIN
                PRESTAZIONI pr ON e.prestazione = pr.Cod
                WHERE r.datafine IS NOT NULL AND r.dataInizio >= dataInizioPar AND r.dataFine <= dataFinePar
                GROUP BY r.Paziente, r.dataInizio, r.dataFine
                ORDER BY costo_totale DESC) 
                WHERE rownum <= 1) tabl JOIN Erogazioni e1 ON (e1.paziente = tabl.paziente AND e1.dataricovero = tabl.di) JOIN Prestazioni pr1 ON pr1.cod = e1.prestazione;

BEGIN
    FOR rec IN curs LOOP
        /* Aggiungere altro output... */
        DBMS_OUTPUT.PUT_LINE('codice prestazione:' || rec.prestazione);
    END LOOP;
END Costi;
/
BEGIN
    Costi('24-FEB-2024', '31-DEC-2024');
END;