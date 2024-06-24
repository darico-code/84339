SET SERVEROUTPUT ON;

create table CLIENTE (
C_ID int,
C_NOME varchar2(20),
C_COGNOME varchar2(20),
C_DATAN date,
C_TELEFONO varchar2(50),
C_TIPOCONTR varchar2(20),
primary key (C_ID));

INSERT INTO CLIENTE VALUES (1, 'N1', 'C1', SYSDATE, 'NU1', '1');
INSERT INTO CLIENTE VALUES (2, 'N2', 'C2', SYSDATE, 'NU2', '2');
INSERT INTO CLIENTE VALUES (3, 'N3', 'C3', SYSDATE, 'NU3', '3');
INSERT INTO CLIENTE VALUES (4, 'N4', 'C4', SYSDATE, 'NU4', '4');

create table OPERATORI (
O_ID int,
O_NOME varchar2(20),
O_COGNOME varchar2(20),
O_DATAN date,
O_LIVELLO int,
primary key (O_ID));

INSERT INTO OPERATORI VALUES (1, 'ON1', 'OC1', SYSDATE, 1);
INSERT INTO OPERATORI VALUES (2, 'ON2', 'OC2', SYSDATE, 1);
INSERT INTO OPERATORI VALUES (3, 'ON3', 'OC3', SYSDATE, 3);
INSERT INTO OPERATORI VALUES (4, 'ON4', 'OC4', SYSDATE, 2);

create table PROBLEMI (
P_COD varchar2(16),
P_DESCRIZIONE varchar2(50),
P_CLASSE varchar2(20),
P_DIFF float,
primary key (P_COD));

INSERT INTO PROBLEMI VALUES ('1', 'desc1', 'cl1', 0.2);
INSERT INTO PROBLEMI VALUES ('2', 'desc2', 'cl1', 0.7);
INSERT INTO PROBLEMI VALUES ('3', 'desc3', 'cl3', 0.5);

create table CHIAMATE(
C_ID int,
C_CLIENTE int,
C_OPERATORE int,
C_PROBLEMA varchar2(16),
C_APERTURA date,
C_RISULTATO int,
primary key (C_ID),
foreign key (C_CLIENTE) references CLIENTE(C_ID),
foreign key (C_OPERATORE) references OPERATORI(O_ID),
foreign key (C_PROBLEMA) references PROBLEMI(P_COD));

INSERT INTO CHIAMATE VALUES (1, 1, 2, '2', sysdate, 1);
INSERT INTO CHIAMATE VALUES (2, 3, 1, '2', sysdate, 1);
INSERT INTO CHIAMATE VALUES (3, 4, 1, '1', sysdate, -1);
INSERT INTO CHIAMATE VALUES (4, 1, 1, '3', sysdate, 0);
INSERT INTO CHIAMATE VALUES (5, 1, 3, '2', sysdate, -1);
INSERT INTO CHIAMATE VALUES (6, 1, 2, '2', sysdate, -1);
INSERT INTO CHIAMATE VALUES (7, 1, 2, '1', sysdate, -1);
INSERT INTO CHIAMATE VALUES (8, 2, 2, '2', sysdate, -1);

create table OPERAZIONI(
R_CHIAMATA int,
R_DATAORA date,
R_DURATA int,
R_DESCRIZIONE varchar2(50),
primary key (R_CHIAMATA,R_DATAORA),
foreign key (R_CHIAMATA) references CHIAMATE1(C_ID));

INSERT INTO OPERAZIONI VALUES (1, SYSDATE, 32, 'descrop1');
INSERT INTO OPERAZIONI VALUES (2, SYSDATE, 12, 'descrop2');
INSERT INTO OPERAZIONI VALUES (3, SYSDATE, 2, 'descrop3');
INSERT INTO OPERAZIONI VALUES (4, SYSDATE, 23, 'descrop4');
INSERT INTO OPERAZIONI VALUES (5, SYSDATE, 12, 'descrop5');
INSERT INTO OPERAZIONI VALUES (6, SYSDATE, 2, 'descrop6');
INSERT INTO OPERAZIONI VALUES (7, SYSDATE, 8, 'descrop7');
INSERT INTO OPERAZIONI VALUES (8, SYSDATE, 38, 'descrop7');

/*
Si scriva la stored procedure RatingOperatori(v_data date) che stila una
classifica delle performance degli operatori a partire da v_data e restituisce in
output quelli con valutazione negativa. La valutazione è calcolata in base al
seguente algoritmo:
Valutazione= (VPos-Vneg)/( VPos+Vneg)
• VPos è la quantità di tempo speso da ogni operatore per gestire chiamate
conclusesi positivamente (Risultato=1) e pesate per il livello di difficoltà del
problema relativo (Difficoltà ]0,..1]).
• VNeg è uguale a VPos ma per le chiamate conclusesi negativamente
(Risultato = -1)
Le chiamata non ancora conclusesi hanno il campo Risultato = 0 e non devono essere considerate nel conteggio.*/

create or replace procedure RatingOperatori(v_data date) IS
cursor curs IS  SELECT ((vpos_t.VPOS-vneg_t.VNEG) / (vpos_t.VPOS+vneg_t.VNEG)) punteggio, vpos_t.opid operatore
                 FROM 
                 (SELECT sum(p.P_DIFF*o.r_durata) VPOS, chi.C_OPERATORE opid
                 FROM PROBLEMI p JOIN CHIAMATE chi ON chi.C_PROBLEMA = p.p_cod
                 JOIN OPERAZIONI o ON o.r_chiamata = chi.c_id 
                 WHERE chi.c_risultato = 1 AND chi.c_apertura >= v_data
                 GROUP BY chi.C_OPERATORE) vpos_t JOIN (SELECT sum(p.P_DIFF*o.r_durata) VNEG, chi.C_OPERATORE opid
                 FROM PROBLEMI p JOIN CHIAMATE chi ON chi.C_PROBLEMA = p.p_cod
                 JOIN OPERAZIONI o ON o.r_chiamata = chi.c_id 
                 WHERE chi.c_risultato = -1 AND chi.c_apertura >= v_data
                 GROUP BY chi.C_OPERATORE) vneg_t ON vpos_t.opid = vneg_t.opid
                 ORDER BY punteggio ASC;
BEGIN 
    FOR rec IN curs LOOP
        IF (rec.punteggio > 0 ) THEN
            EXIT;
        END IF;
        DBMS_OUTPUT.PUT_LINE('op id: ' || rec.operatore || ' punteggio: ' ||
                                rec.punteggio);
    END LOOP;
END RatingOperatori;
/
BEGIN
 RatingOperatori('24-JUN-2024');   
END;


