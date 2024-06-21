create or replace procedure Assegna(vSettimana NUMBER) IS
cursor ottieniCorsiAttivi IS (  
                        SELECT temp.idcorso idcorso, sa2.idallievo idallievo
                        FROM (
                        SELECT stp.T_idcorso idcorso,
                        stp.T_etamin etamin, stp.T_etamax etamax,
                        stp.T_livello livello
                        FROM SCI_TIPICORSI stp JOIN SCI_ALLIEVI sa
                        ON stp.T_livello = sa.A_livello
                        WHERE sa.A_eta BETWEEN stp.T_etamin AND stp.T_etamax AND
                        sa.A_SETIMANARICHIESTA = vSettimana
                        GROUP BY stp.T_idcorso, stp.T_etamin,
                        stp.T_etamax, stp.T_livello
                        HAVING COUNT(*) > stp.T_minpartecipanti ) temp 
                        JOIN SCI_ALLIEVI sa2 ON temp.livello = sa2.A_livello
                        WHERE sa2.A_eta BETWEEN temp.etamin AND temp.etamax
                        AND sa2.A_SETTIMANARICHIESTA = vSettimana
                        );
BEGIN 
    DELETE FROM SCI_ASSEGNAMENTI;
    FOR corsoAllievo IN ottieniCorsiAttivi LOOP
        INSERT INTO SCI_ASSEGNAMENTI VALUES
        (corsoAllievo.idcorso, corsoAllievo.idallievo);
    END LOOP;
END Assegna;
                            