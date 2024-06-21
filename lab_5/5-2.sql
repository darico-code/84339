SET SERVEROUTPUT ON;


create or replace procedure GeneraSquadra(IDPartita NUMBER) IS

TYPE cursoreRef IS REF CURSOR;

attaccanti cursoreRef;
difensori cursoreRef;
portieri cursoreRef;

numeroDiGiocatori NUMBER;

squadra NUMBER := 1;

posizione NUMBER := 1;

gioid NUMBER;

hasReturned BOOLEAN := FALSE;

counterGiocatori NUMBER := 1;

giocatori_insufficienti EXCEPTION;

FUNCTION cursGiocatore(ruolo VARCHAR) RETURN cursoreRef IS
    c cursoreRef;
  BEGIN
    OPEN c FOR  SELECT gio.G_ID
                FROM CAL_GIOCATORI gio JOIN CAL_DISPONIBILITA dis
                ON gio.G_ID = dis.D_IDGIOCATORE AND
                dis.D_IDPARTITA = IDPartita
                WHERE gio.G_RUOLO=ruolo
                ORDER BY gio.G_LIVELLOTECNICO*1.2 + gio.G_LIVELLOATLETICO DESC;
    RETURN c;
  END;


BEGIN 
    SELECT COUNT(*) INTO numeroDiGiocatori FROM CAL_DISPONIBILITA WHERE D_IDPARTITA = IDPartita;
    IF numeroDiGiocatori < 10 THEN
    RAISE giocatori_insufficienti;
    END IF;
    attaccanti := cursGiocatore('attaccante');
    difensori := cursGiocatore('difensore');
    portieri := cursGiocatore('portiere');
    WHILE counterGiocatori <= numeroDiGiocatori LOOP
        IF (REMAINDER(squadra, 2) != 0) THEN
            squadra := 1;
        ELSE 
            squadra := 2;
        END IF;
        IF (REMAINDER(posizione, 3) = 1) THEN
            FETCH attaccanti INTO gioid;
            hasReturned := attaccanti%FOUND;
        ELSIF (mod(posizione, 3) = 2) THEN 
            FETCH difensori INTO gioid;
            hasReturned := difensori%FOUND;
        ELSE 
            FETCH portieri INTO gioid;
            hasReturned := portieri%FOUND;
        END IF;
        IF (hasReturned = TRUE) THEN
            INSERT INTO CAL_FORMAZIONI VALUES (IDPartita, gioid, squadra);
            counterGiocatori := counterGiocatori + 1;
            squadra := squadra + 1;
        END IF;
        hasReturned := FALSE;
        posizione := posizione + 1;
    END LOOP;
    CLOSE attaccanti;
    CLOSE difensori;
    CLOSE portieri;
    EXCEPTION
    WHEN giocatori_insufficienti THEN 
        DBMS_OUTPUT.PUT_LINE('meno di 10 giocatori');
    
END GeneraSquadra;
/
BEGIN
  GeneraSquadra(1);
END;
/