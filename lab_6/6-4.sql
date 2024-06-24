create table FUMETTI (
F_Nome varchar2(20),
F_Disegnatore varchar2(20),
F_Editore varchar2(20),
F_Prezzo number(8,2),
primary key (F_Nome));

create table NUMERI (
N_Fumetto varchar2(20),
N_Numero int,
N_Anno int,
N_NumPagine int,
primary key (N_Fumetto, N_Numero),
foreign key (N_Fumetto) References FUMETTI(F_Nome));

create table AVVENTURE (
A_Fumetto varchar2(20),
A_Numero int,
A_Titolo varchar2(50),
A_Descrizione varchar2(70),
A_NumPagine int,
primary key (A_Fumetto, A_Numero, A_Titolo),
foreign key (A_Fumetto, A_Numero) references NUMERI(N_Fumetto, N_Numero));

create table PERSONAGGI (
P_Nome varchar2(20),
P_Descrizione varchar2(50),
primary key (P_Nome));

create table COMPARE_IN (
C_Pers varchar2(20),
C_Fumetto varchar2(20),
C_Numero int,
C_Titolo varchar2(50),
C_NumVignette int,
primary key (C_Pers, C_Fumetto, C_Numero, C_Titolo),
foreign key (C_Fumetto, C_Numero, C_Titolo) references AVVENTURE(A_Fumetto, A_Numero, A_Titolo),
foreign key (C_Pers) references PERSONAGGI(P_Nome));

-- Insert data into FUMETTI
INSERT ALL
    INTO FUMETTI (F_Nome, F_Disegnatore, F_Editore, F_Prezzo) VALUES ('Spider-Man', 'Steve Ditko', 'Marvel', 3.99)
    INTO FUMETTI (F_Nome, F_Disegnatore, F_Editore, F_Prezzo) VALUES ('Batman', 'Jim Lee', 'DC', 4.99)
    INTO FUMETTI (F_Nome, F_Disegnatore, F_Editore, F_Prezzo) VALUES ('Superman', 'John Byrne', 'DC', 4.49)
SELECT 1 FROM DUAL;

-- Insert data into NUMERI
INSERT ALL
    INTO NUMERI (N_Fumetto, N_Numero, N_Anno, N_NumPagine) VALUES ('Spider-Man', 1, 1962, 36)
    INTO NUMERI (N_Fumetto, N_Numero, N_Anno, N_NumPagine) VALUES ('Batman', 1, 1940, 32)
    INTO NUMERI (N_Fumetto, N_Numero, N_Anno, N_NumPagine) VALUES ('Superman', 1, 1938, 30)
    INTO NUMERI (N_Fumetto, N_Numero, N_Anno, N_NumPagine) VALUES ('Spider-Man', 2, 1963, 36)
    INTO NUMERI (N_Fumetto, N_Numero, N_Anno, N_NumPagine) VALUES ('Batman', 2, 1940, 32)
    INTO NUMERI (N_Fumetto, N_Numero, N_Anno, N_NumPagine) VALUES ('Superman', 2, 1939, 30)
SELECT 1 FROM DUAL;

-- Insert data into AVVENTURE
INSERT ALL
    INTO AVVENTURE (A_Fumetto, A_Numero, A_Titolo, A_Descrizione, A_NumPagine) VALUES ('Spider-Man', 1, 'Spider-Man vs Chameleon', 'First appearance of Spider-Man', 36)
    INTO AVVENTURE (A_Fumetto, A_Numero, A_Titolo, A_Descrizione, A_NumPagine) VALUES ('Batman', 1, 'The Case of the Chemical Syndicate', 'First appearance of Batman', 32)
    INTO AVVENTURE (A_Fumetto, A_Numero, A_Titolo, A_Descrizione, A_NumPagine) VALUES ('Superman', 1, 'Superman and the Menace of Metropolis', 'First appearance of Superman', 30)
    INTO AVVENTURE (A_Fumetto, A_Numero, A_Titolo, A_Descrizione, A_NumPagine) VALUES ('Spider-Man', 2, 'Spider-Man vs Vulture', 'Spider-Man fights Vulture', 36)
    INTO AVVENTURE (A_Fumetto, A_Numero, A_Titolo, A_Descrizione, A_NumPagine) VALUES ('Batman', 2, 'Batman vs Joker', 'First appearance of Joker', 32)
    INTO AVVENTURE (A_Fumetto, A_Numero, A_Titolo, A_Descrizione, A_NumPagine) VALUES ('Superman', 2, 'Superman vs Luthor', 'Superman fights Lex Luthor', 30)
    INTO AVVENTURE (A_Fumetto, A_Numero, A_Titolo, A_Descrizione, A_NumPagine) VALUES ('Batman', 2, 'Superman vs Batman the return', 'Superman fights Batman', 30)
SELECT 1 FROM DUAL;


-- Insert data into PERSONAGGI
INSERT ALL
    INTO PERSONAGGI (P_Nome, P_Descrizione) VALUES ('Spider-Man', 'Peter Parkera young man with spider-like abilities')
    INTO PERSONAGGI (P_Nome, P_Descrizione) VALUES ('Batman', 'Bruce Wayne, a wealthy vigilante with no superpowe')
    INTO PERSONAGGI (P_Nome, P_Descrizione) VALUES ('Superman', 'Clark Kent, a Kryptonian with superhuman abilities')
    INTO PERSONAGGI (P_Nome, P_Descrizione) VALUES ('Joker', 'A criminal mastermind and archenemy of Batman')
    INTO PERSONAGGI (P_Nome, P_Descrizione) VALUES ('Lex Luthor', 'A wealthy businessman and archenemy of Superman')
    INTO PERSONAGGI (P_Nome, P_Descrizione) VALUES ('Wonder Woman', 'Diana Prince an Amazonian princess with superhuman')
SELECT 1 FROM DUAL;

-- Insert data into COMPARE_IN
INSERT ALL
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Spider-Man', 'Spider-Man', 1, 'Spider-Man vs Chameleon', 20)
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Batman', 'Batman', 1, 'The Case of the Chemical Syndicate', 22)
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Superman', 'Superman', 1, 'Superman and the Menace of Metropolis', 18)
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Spider-Man', 'Spider-Man', 2, 'Spider-Man vs Vulture', 19)
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Batman', 'Batman', 2, 'Batman vs Joker', 23)
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Superman', 'Superman', 2, 'Superman vs Luthor', 21)
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Joker', 'Batman', 2, 'Batman vs Joker', 10)
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Lex Luthor', 'Superman', 2, 'Superman vs Luthor', 12)
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Lex Luthor', 'Superman', 1, 'Superman and the Menace of Metropolis', 5)
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Superman', 'Batman', 2, 'Batman vs Joker', 7)  -- Superman appears in Batman comic
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Wonder Woman', 'Batman', 2, 'Batman vs Joker', 8)
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Wonder Woman', 'Superman', 1, 'Superman and the Menace of Metropolis', 10)
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Spider-Man', 'Superman', 2, 'Superman vs Luthor', 6)  -- Spider-Man appears in Superman comic
    INTO COMPARE_IN (C_Pers, C_Fumetto, C_Numero, C_Titolo, C_NumVignette) VALUES ('Superman', 'Batman', 2, 'Superman vs Batman the return', 6)  -- Superman re-appears in Batman comic
SELECT 1 FROM DUAL;


create or replace procedure Correla(VFum1 VARCHAR, VFum2 VARCHAR) IS
cursor curs IS  SELECT COUNT(*) numero FROM 
(SELECT DISTINCT(c_pers) nome FROM compare_in WHERE c_fumetto = 'Superman') tab1
JOIN (SELECT c_pers nome FROM compare_in WHERE c_fumetto= 'Batman') tab2
ON tab1.nome = tab2.nome;

numero NUMBER := 0;

BEGIN 
    OPEN curs;
    FETCH curs INTO numero;
    DBMS_OUTPUT.PUT_LINE('fattore di correlazione: '|| numero);
END;
/

