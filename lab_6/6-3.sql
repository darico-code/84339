create table REGIONI (
NOME varchar2(20),
NUMABITANTI int,
primary key (NOME));

INSERT INTO REGIONI VALUES ('Lombardia', 100000);

create table DISTRETTI (
NOME varchar2(20),
DESCRIZIONE varchar2(50),
primary key (NOME));

INSERT INTO DISTRETTI VALUES ('Zona 7', 'criminalità');

create table CITTA (
NOME varchar2(20),
REGIONE varchar2(20),
NUMABITANTI int,
DISTRETTO varchar2(20),
primary key (NOME, REGIONE),
foreign key (REGIONE) references REGIONI(NOME),
foreign key (DISTRETTO) references DISTRETTI(NOME));

INSERT INTO CITTA VALUES ('Milano', 'Lombardia', 10000, 'Zona 7');
INSERT INTO CITTA VALUES ('Bologna', 'Lombardia', 10300, 'Zona 7');
INSERT INTO CITTA VALUES ('Livorno', 'Lombardia', 1030, 'Zona 7');
INSERT INTO CITTA VALUES ('Como', 'Lombardia', 10000, 'Zona 7');
INSERT INTO CITTA VALUES ('Norcia', 'Lombardia', 10032, 'Zona 7');
INSERT INTO CITTA VALUES ('Forli', 'Lombardia', 132, 'Zona 7');

create table PARAMETRI (
CITTA varchar2(20),
REGIONE  varchar2(20),
PARAMETRO  varchar2(20),
TIPOPARAMETRO  varchar2(20),
DESCRIZIONE  varchar2(50), 
VALORE int,
primary key (CITTA, REGIONE, PARAMETRO),
foreign key (CITTA, REGIONE) references CITTA(NOME, REGIONE));

INSERT INTO PARAMETRI VALUES ('Milano', 'Lombardia', 'Inquinamento', null, 'Inquinamento...', 2131); 
INSERT INTO PARAMETRI VALUES ('Bologna', 'Lombardia', 'Inquinamento', null, 'Inquinamento...', 211131); 
INSERT INTO PARAMETRI VALUES ('Livorno', 'Lombardia', 'Inquinamento', null, 'Inquinamento...', 231); 
INSERT INTO PARAMETRI VALUES ('Como', 'Lombardia', 'Inquinamento', null, 'Inquinamento...', 213132); 
INSERT INTO PARAMETRI VALUES ('Norcia', 'Lombardia', 'Inquinamento', null, 'Inquinamento...', 213); 
INSERT INTO PARAMETRI VALUES ('Forli', 'Lombardia', 'Inquinamento', null, 'Inquinamento...', 1); 

INSERT INTO PARAMETRI VALUES ('Milano', 'Lombardia', 'DimAreeVerdi', null, 'DimAreeVerdi...', 12); 
INSERT INTO PARAMETRI VALUES ('Bologna', 'Lombardia', 'DimAreeVerdi', null, 'DimAreeVerdi...', 21); 
INSERT INTO PARAMETRI VALUES ('Livorno', 'Lombardia', 'DimAreeVerdi', null, 'DimAreeVerdi...', 231); 
INSERT INTO PARAMETRI VALUES ('Como', 'Lombardia', 'DimAreeVerdi', null, 'DimAreeVerdi...', 212); 
INSERT INTO PARAMETRI VALUES ('Norcia', 'Lombardia', 'DimAreeVerdi', null, 'DimAreeVerdi...', 21213); 
INSERT INTO PARAMETRI VALUES ('Forli', 'Lombardia', 'DimAreeVerdi', null, 'DimAreeVerdi...', 121121);

INSERT INTO PARAMETRI VALUES ('Milano', 'Lombardia', 'NumCentriCulturali', null, 'NumCentriCulturali...', 3212); 
INSERT INTO PARAMETRI VALUES ('Bologna', 'Lombardia', 'NumCentriCulturali', null, 'NumCentriCulturali...', 3333); 
INSERT INTO PARAMETRI VALUES ('Livorno', 'Lombardia', 'NumCentriCulturali', null, 'NumCentriCulturali...', 232); 
INSERT INTO PARAMETRI VALUES ('Como', 'Lombardia', 'NumCentriCulturali', null, 'NumCentriCulturali...', 2132232); 
INSERT INTO PARAMETRI VALUES ('Norcia', 'Lombardia', 'NumCentriCulturali', null, 'NumCentriCulturali...', 22222); 
INSERT INTO PARAMETRI VALUES ('Forli', 'Lombardia', 'NumCentriCulturali', null, 'NumCentriCulturali...', 1111);



create table OUTPUT (
CITTA varchar2(20),
REGIONE  varchar2(20),
VALORE int,
primary key (CITTA, REGIONE),
foreign key (CITTA, REGIONE) references CITTA(NOME, REGIONE));


SELECT tab1.Citta, tab1.Regione, (tab1.DimAreeVerdi/ct.NumAbitanti)*(1+tab2.NumCentriCulturali/10) Valore
FROM (SELECT p.valore DimAreeVerdi, p.citta citta, p.regione regione
        FROM PARAMETRI p
        WHERE p.Parametro = 'DimAreeVerdi') tab1 JOIN
        (SELECT p.valore NumCentriCulturali, p.citta citta, p.regione regione
        FROM PARAMETRI p 
        WHERE p.Parametro = 'NumCentriCulturali') tab2 ON 
        (tab1.citta = tab2.citta AND tab1.regione = tab2.regione) JOIN
        (SELECT citta, regione
        FROM (SELECT p.citta citta, p.regione regione
              FROM Parametri p
              WHERE p.parametro = 'Inquinamento'
              GROUP BY citta, regione
              ORDER BY AVG(p.valore) ASC)
        WHERE rownum <=10) tab3 ON 
        (tab3.citta = tab2.citta AND tab3.regione = tab2.regione) 
        JOIN CITTA ct ON (ct.nome = tab3.citta AND ct.regione = tab3.regione)
ORDER BY Valore DESC;

create or replace procedure Vivibile(Vregione VARCHAR) IS
cursor curs IS SELECT tab1.Citta, tab1.Regione, (tab1.DimAreeVerdi/ct.NumAbitanti)*(1+tab2.NumCentriCulturali/10) Valore
FROM (SELECT p.valore DimAreeVerdi, p.citta citta, p.regione regione
        FROM PARAMETRI p
        WHERE p.Parametro = 'DimAreeVerdi') tab1 JOIN
        (SELECT p.valore NumCentriCulturali, p.citta citta, p.regione regione
        FROM PARAMETRI p 
        WHERE p.Parametro = 'NumCentriCulturali') tab2 ON 
        (tab1.citta = tab2.citta AND tab1.regione = tab2.regione) JOIN
        (SELECT citta, regione
        FROM (SELECT p.citta citta, p.regione regione
              FROM Parametri p
              WHERE p.parametro = 'Inquinamento'
              GROUP BY citta, regione
              ORDER BY AVG(p.valore) ASC)
        WHERE rownum <=10) tab3 ON 
        (tab3.citta = tab2.citta AND tab3.regione = tab2.regione) 
        JOIN CITTA ct ON (ct.nome = tab3.citta AND ct.regione = tab3.regione)
ORDER BY Valore DESC;

counter NUMBER := 5;

rec curs%ROWTYPE;

BEGIN 
    OPEN curs;
    WHILE counter > 0 LOOP
        IF (curs%NOTFOUND) THEN 
            EXIT;
        END IF;
        FETCH curs INTO rec;
        INSERT INTO OUTPUT VALUES (rec.Citta, rec.Regione, rec.Valore);
        counter:= counter -1;
    END LOOP;
END Vivibile;
/
BEGIN
    Vivibile('Lombardia');
END;




