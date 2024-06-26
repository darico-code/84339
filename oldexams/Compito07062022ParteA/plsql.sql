SET SERVEROUTPUT ON;

-- Create the ALUNNI table
CREATE TABLE ALUNNI (
    A_IDAlunno NUMBER PRIMARY KEY,
    A_Nome VARCHAR2(50) NOT NULL,
    A_Cognome VARCHAR2(50) NOT NULL,
    A_Classe VARCHAR2(10) NOT NULL
);

-- Create the VOTI table
CREATE TABLE VOTI (
    V_IDVoto NUMBER PRIMARY KEY,
    V_IDAlunno NUMBER NOT NULL,
    V_Materia VARCHAR2(50) NOT NULL,
    V_Data DATE NOT NULL,
    V_Voto NUMBER NOT NULL,
    V_Tipo VARCHAR2(10) NOT NULL,
    FOREIGN KEY (V_IDAlunno) REFERENCES ALUNNI(A_IDAlunno)
);

SELECT V_IDAlunno, A_Nome nome, A_Cognome cognome, case WHEN count(*)>2 THEN SUM(V_Voto)-MIN(V_Voto) WHEN count(*)=2 THEN SUM(V_Voto) ELSE 0 END somma, case WHEN count(*) > 2 THEN count(*)-1 ELSE count(*) END numeri
                                                            FROM ALUNNI JOIN VOTI ON A_IDAlunno = V_IDAlunno
                                                            WHERE A_Classe = '3A' AND V_Materia = 'Italiano'
                                                            GROUP BY V_IDAlunno, V_Tipo, A_Nome, A_Cognome
                                                            ORDER BY 1;

-- Insert data into ALUNNI table
INSERT INTO ALUNNI (A_IDAlunno, A_Nome, A_Cognome, A_Classe) VALUES (1, 'Mario', 'Rossi', '3A');
INSERT INTO ALUNNI (A_IDAlunno, A_Nome, A_Cognome, A_Classe) VALUES (2, 'Luca', 'Bianchi', '3B');
INSERT INTO ALUNNI (A_IDAlunno, A_Nome, A_Cognome, A_Classe) VALUES (3, 'Giulia', 'Verdi', '3A');

-- Insert data into VOTI table
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (1, 1, 'Matematica', TO_DATE('2023-05-15', 'YYYY-MM-DD'), 8, 'Orale');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (2, 1, 'Italiano', TO_DATE('2023-05-20', 'YYYY-MM-DD'), 7, 'Scritto');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (3, 2, 'Matematica', TO_DATE('2023-05-15', 'YYYY-MM-DD'), 6, 'Orale');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (4, 3, 'Italiano', TO_DATE('2023-05-25', 'YYYY-MM-DD'), 9, 'Scritto');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (5, 3, 'Italiano', TO_DATE('2023-05-25', 'YYYY-MM-DD'), 9, 'Scritto');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (6, 3, 'Italiano', TO_DATE('2023-05-25', 'YYYY-MM-DD'), 9, 'Scritto');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (7, 3, 'Italiano', TO_DATE('2023-05-25', 'YYYY-MM-DD'), 9, 'Scritto');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (8, 3, 'Italiano', TO_DATE('2023-05-25', 'YYYY-MM-DD'), 9, 'Scritto');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (9, 3, 'Italiano', TO_DATE('2023-05-25', 'YYYY-MM-DD'), 10, 'Scritto');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (10, 3, 'Italiano', TO_DATE('2023-05-25', 'YYYY-MM-DD'), 3, 'Scritto');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (11, 3, 'Italiano', TO_DATE('2023-05-25', 'YYYY-MM-DD'), 2, 'Scritto');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (12, 3, 'Italiano', TO_DATE('2023-05-25', 'YYYY-MM-DD'), 5, 'Orale');
INSERT INTO VOTI (V_IDVoto, V_IDAlunno, V_Materia, V_Data, V_Voto, V_Tipo) VALUES (13, 3, 'Italiano', TO_DATE('2023-05-25', 'YYYY-MM-DD'), 3, 'Orale');

create or replace procedure calcolaMedia(vClasse VARCHAR, vMateria VARCHAR) IS
cursor getMedia IS SELECT V_IDAlunno, A_Nome nome, A_Cognome cognome, case WHEN count(*)>2 THEN SUM(V_Voto)-MIN(V_Voto) WHEN count(*)=2 THEN SUM(V_Voto) ELSE 0 END somma, case WHEN count(*) > 2 THEN count(*)-1 ELSE count(*) END numeri
                                                            FROM ALUNNI JOIN VOTI ON A_IDAlunno = V_IDAlunno
                                                            WHERE A_Classe = vClasse AND V_Materia = vMateria
                                                            GROUP BY V_IDAlunno, V_Tipo, A_Nome, A_Cognome
                                                            ORDER BY 1;
media NUMBER := 0; 
record1 getMedia%ROWTYPE;
record2 getMedia%ROWTYPE;
token NUMBER := 1;
exitTotal BOOLEAN := FALSE;
BEGIN 
    OPEN getMedia;
    WHILE token=1 OR getMedia%FOUND LOOP
        FETCH getMedia INTO record1;
        IF getMedia%NOTFOUND THEN
            EXIT;
        END IF;
        FETCH getMedia INTO record2;
        WHILE record1.V_IDAlunno != record2.V_IDAlunno LOOP
            DBMS_OUTPUT.PUT_LINE('Alunno: ' || record1.nome || ' ' || record1.cognome
            || ' voto 0');
            record1 := record2;
            FETCH getMedia INTO record2;
            IF (getMedia%NOTFOUND) THEN
                DBMS_OUTPUT.PUT_LINE('Alunno: ' || record1.nome || ' ' || record1.cognome
                || ' voto 0');
                exitTotal := TRUE;
                EXIT;
            END IF;
        END LOOP;
        IF exitTotal THEN
            EXIT;
        END IF;
        IF (record1.numeri < 2 OR record2.numeri < 2) THEN
            media := 0;
        ELSE 
            media := (record1.somma+record2.somma)/(record1.numeri+record2.numeri);
        END IF;
        DBMS_OUTPUT.PUT_LINE('Alunno: ' || record1.nome || ' ' || record1.cognome
        || ' voto ' || media);
        token := 0;
    END LOOP;
    CLOSE getMedia;
END calcolaMedia;
/
BEGIN 
    calcolaMedia('3A', 'Italiano');
END;
                                                            