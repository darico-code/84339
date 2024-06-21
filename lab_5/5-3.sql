SET SERVEROUTPUT ON;

create or replace procedure CorreggiCompito(IDStudente NUMBER, IDCompito NUMBER) IS
cursor votiParziali IS (SELECT area, AVG(val) val, count(*) num
                       FROM (SELECT d.d_areadomanda area, case rs.rs_Risposta when d.D_rispostacorretta THEN d.D_LIVELLOCOMPLESSITÀ ELSE -0.5 END val
                            FROM COM_RISPOSTESTUDENTE rs JOIN COM_DOMANDE d ON rs.rs_iddomanda = d.d_id
                            WHERE rs.rs_idstudente = IDStudente AND rs.rs_idcompito = IDCompito)
                        GROUP BY area);

-- rec votiParziali%ROWTYPE;
P float;
AREA float;
TOTALE float := 0 ;

BEGIN 
    FOR rec IN votiParziali LOOP
        TOTALE := TOTALE + rec.val*rec.area;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('totale è: ' || TOTALE);
END CorreggiCompito;
/
BEGIN 
    CorreggiCompito(1,1);
END;