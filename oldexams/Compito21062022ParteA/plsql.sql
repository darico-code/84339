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
create or replace procedure stampaVoto( massimo NUMBER, minimo NUMBER,
                                        accum1 NUMBER, contatore1 NUMBER,
                                        materia VARCHAR) IS
voto NUMBER;
accum NUMBER := accum1;
contatore NUMBER := contatore1;
BEGIN 
    IF contatore < 5 THEN
        voto := 0;
    ELSE
        accum := accum - massimo;
        contatore := contatore - 1;
        IF contatore > 5 THEN
            accum := accum - minimo;
            contatore := contatore - 1;
        END IF;
        voto := accum / contatore;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Materia: ' || materia || ' voto ' || voto);
END stampaVoto;


create or replace procedure votiAlunno(vAlunno NUMBER) IS
cursor curs is  SELECT V_Materia mat, V_Voto voto
                FROM VOTI JOIN ALUNNI ON V_IDAlunno = A_IDAlunno
                WHERE A_IDAlunno = vAlunno
                ORDER BY 1, 2;
massimo NUMBER := -1;
minimo NUMBER := 11;
accumulatore NUMBER := 0;
contatore NUMBER := 0;
nomeAlunno VARCHAR(50);
materia VARCHAR(50) := NULL;
BEGIN
    SELECT A_Nome INTO nomeAlunno FROM ALUNNI WHERE A_IDAlunno = vAlunno;
    DBMS_OUTPUT.PUT_LINE('Alunno: ' || nomeAlunno);
    FOR val IN curs LOOP
        IF materia IS NULL THEN
            materia := val.mat;
        ELSIF materia != val.mat THEN
            stampaVoto(massimo, minimo, accumulatore, contatore, materia);
            materia := val.mat;
            massimo := -1;
            minimo := 11;
            accumulatore := 0;
            contatore := 0;
        END IF;
        IF val.voto > massimo THEN 
            massimo := val.voto;
        END IF;
        IF val.voto < minimo THEN
            minimo := val.voto;
        END IF;
        accumulatore := accumulatore + val.voto;
        contatore := contatore + 1;
    END LOOP;
    IF materia IS NOT NULL THEN
        stampaVoto(massimo, minimo, accumulatore, contatore, materia);
    END IF;
END votiAlunno;
/
BEGIN 
    votiAlunno(3);
END;