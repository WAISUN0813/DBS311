-- ******************************
-- Name: Xinyang Ma, Wai Sun Lam
-- ID: 152868162, 146691225
-- Date: Nov 30, 2023
-- Purpose: Assignment 2 - DBS311
-- ******************************

/*
    ERROR CODE
    ---------------------------------------------------------------------
    -1 = SQL%ROWCOUNT equals 0 (No rows updated or deleted)
    -2 = SQL%ROWCOUNT greater than 1 (More than 1 row updated or deleted)
    -3 = Other errors
    -4 = DUP_VAL_ON_INDEX (The inserting primary key already exists)
    -5 = NO_DATA_FOUND
    -6 = TOO_MANY_ROWS
    -7 = pc%NOTFOUND (No record in cursor)
    -8 = ROWTYPE_MISMATCH
*/

SET SERVEROUTPUT ON;
-- Q1.a
-- player table insert
CREATE OR REPLACE PROCEDURE spPlayersInsert (
    new_playerID players.playerID%TYPE,
    reg_number players.regNumber%TYPE,
    last_name players.lastName%TYPE,
    first_name players.firstName%TYPE,
    is_active players.isActive%TYPE,
    status OUT NUMBER
)
AS
BEGIN
    INSERT INTO players
    VALUES (new_playerID, reg_number, last_name, first_name, is_active)
    RETURNING new_playerID INTO status;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        status := -4;
    WHEN OTHERS THEN
        status := -3;
END spPlayersInsert;

-- execution
DECLARE
    status NUMBER;
BEGIN
    spPlayersInsert(9999, 9999, 'Jack', 'Smith', 1, status);
    IF status < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insertion failed. Error code: ' || status);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Insertion successful.');
    END IF;
END;

-- teams table insert
CREATE OR REPLACE PROCEDURE spTeamsInsert(
    new_teamID IN teams.teamID%TYPE,
    team_name IN teams.teamName%TYPE,
    is_active IN teams.isActive%TYPE,
    jersey_colour IN teams.jerseyColour%TYPE,
    status OUT NUMBER
)
AS
BEGIN
    INSERT INTO teams
    VALUES (new_teamID, team_name, is_active, jersey_colour)
    RETURNING teamID INTO status;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        status := -4;
    WHEN OTHERS THEN
        status := -3;
END spTeamsInsert;

-- execution
DECLARE
    status NUMBER;
BEGIN
    spTeamsInsert(999, 'Asdf', 1, 'Blue', status);
    IF status < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insertion failed. Error code: ' || status);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Insertion successful.');
    END IF;
END;

-- rosters table insert
CREATE OR REPLACE PROCEDURE spRostersInsert(
    player_id IN rosters.playerID%TYPE,
    team_id IN rosters.teamID%TYPE,
    is_active IN rosters.isActive%TYPE,
    jersey_number IN rosters.jerseyNumber%TYPE,
    new_rosterID OUT rosters.rosterID%TYPE
)
AS
BEGIN
    INSERT INTO rosters (playerID, teamID, isActive, jerseyNumber)
    VALUES (player_id, team_id, is_active, jersey_number)
    RETURNING rosterID INTO new_rosterID;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        new_rosterID := -4;
    WHEN OTHERS THEN
        new_rosterID := -3;
END spRostersInsert;

-- execution
DECLARE
    new_rosterID rosters.rosterID%TYPE;
BEGIN
    spRostersInsert(9999, 999, 1, 18, new_rosterID);
    IF new_rosterID < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Insertion failed. Error code: ' || new_rosterID);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Insertion successful. New roster ID: ' || new_rosterID);
    END IF;
END;

-- Q1.b
-- players table update
CREATE OR REPLACE PROCEDURE spPlayersUpdate(
    player_id IN players.playerID%TYPE,
    reg_number IN players.regNumber%TYPE,
    last_name IN players.lastName%TYPE,
    first_name IN players.firstName%TYPE,
    is_active IN players.isActive%TYPE,
    status OUT INT
)
AS
BEGIN
    UPDATE players SET
        regNumber = reg_number,
        lastName = last_name,
        firstName = first_name,
        isActive = is_active
    WHERE playerID = player_id;
    IF SQL%ROWCOUNT = 0 THEN
        status := -1;
    ELSIF SQL%ROWCOUNT = 1 THEN
        status := 1;
    ELSE
        status := -2;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        status := -3;
END spPlayersUpdate;

-- execution
DECLARE
    status INT;
BEGIN
    spPlayersUpdate(9999, 999, 'John', 'Webb', 1, status);
    IF status = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Update successful');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Update failed. Error code: ' || status);
    END IF;
END;

-- teams table update
CREATE OR REPLACE PROCEDURE spTeamsUpdate(
    team_id IN teams.teamID%TYPE,
    team_name IN teams.teamName%TYPE,
    is_active IN teams.isActive%TYPE,
    jersey_colour IN teams.jerseyColour%TYPE,
    status OUT INT
)
AS
BEGIN
    UPDATE teams SET
        teamName = team_name,
        isActive = is_active,
        jerseyColour = jersey_colour
    WHERE teamID = team_id;
    IF SQL%ROWCOUNT = 0 THEN
        status := -1;
    ELSIF SQL%ROWCOUNT = 1 THEN
        status := 1;
    ELSE
        status := -2;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        status := -3;
END spTeamsUpdate;

-- execution
DECLARE
    status INT;
BEGIN
    spTeamsUpdate(999, 'Qwe', 1, 'Yellow', status);
    IF status = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Update successful');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Update failed. Error code: ' || status);
    END IF;
END;

-- rosters table
CREATE OR REPLACE PROCEDURE spRostersUpdate(
    roster_id IN rosters.rosterID%TYPE,
    player_id IN rosters.playerID%TYPE,
    team_id IN rosters.teamID%TYPE,
    is_active IN rosters.isActive%TYPE,
    jersey_number IN rosters.jerseyNumber%TYPE,
    status OUT INT
)
AS
BEGIN
    UPDATE rosters SET
        playerID = player_id,
        teamID = team_id,
        isActive = is_active,
        jerseyNumber = jersey_number
    WHERE rosterID = roster_id;
    IF SQL%ROWCOUNT = 0 THEN
        status := -1;
    ELSIF SQL%ROWCOUNT = 1 THEN
        status := 1;
    ELSE
        status := -2;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        status := -3;
END spRostersUpdate;

-- execution
DECLARE
    status INT;
BEGIN
    spRostersUpdate(301, 9999, 999, 1, 12, status);
    IF status = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Update successful');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Update failed. Error code: ' || status);
    END IF;
END;

-- Q1.c
-- players table delete
CREATE OR REPLACE PROCEDURE spPlayersDelete(
    player_id IN players.playerID%TYPE,
    status OUT INT
)
AS
BEGIN
    DELETE FROM players WHERE playerID = player_id;
    IF SQL%ROWCOUNT = 0 THEN
        status := -1;
    ELSIF SQL%ROWCOUNT = 1 THEN
        status := 1;
    ELSE
        status := -2;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        status := -3;
END spPlayersDelete;

-- execution
DECLARE
    status INT;
BEGIN
    spPlayersDelete(9999, status);
    IF status = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Delete successful');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Delete failed. Error code: ' || status);
    END IF;
END;

-- teams table delete
CREATE OR REPLACE PROCEDURE spTeamsDelete(
    team_id IN teams.teamID%TYPE,
    status OUT INT
)
AS
BEGIN
    DELETE FROM teams WHERE teamID = team_id;
    IF SQL%ROWCOUNT = 0 THEN
        status := -1;
    ELSIF SQL%ROWCOUNT = 1 THEN
        status := 1;
    ELSE
        status := -2;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        status := -3;
END spTeamsDelete;

-- execution
DECLARE
    status INT;
BEGIN
    spTeamsDelete(999, status);
    IF status = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Delete successful');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Delete failed. Error code: ' || status);
    END IF;
END;

-- rosters table delete
CREATE OR REPLACE PROCEDURE spRostersDelete(
    roster_id IN rosters.rosterID%TYPE,
    status OUT INT
)
AS
BEGIN
    DELETE FROM rosters WHERE rosterID = roster_id;
    IF SQL%ROWCOUNT = 0 THEN
        status := -1;
    ELSIF SQL%ROWCOUNT = 1 THEN
        status := 1;
    ELSE
        status := -2;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        status := -3;
END spRostersDelete;

-- execution
DECLARE
    status INT;
BEGIN
    spRostersDelete(301, status);
    IF status = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Delete successful');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Delete failed. Error code: ' || status);
    END IF;
END;

-- Q1.d
-- players table select
CREATE OR REPLACE PROCEDURE spPlayersSelect(
    player_id IN players.playerID%TYPE,
    reg_number OUT players.regNumber%TYPE,
    last_name OUT players.lastName%TYPE,
    first_name OUT players.firstName%TYPE,
    is_active OUT players.isActive%TYPE,
    status OUT INT
)
AS
BEGIN
    SELECT
        regNumber,
        lastName,
        firstName,
        isActive
    INTO
        reg_number,
        last_name,
        first_name,
        is_active
    FROM players
    WHERE playerID = player_id;
    status := 1;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        status := -5;
    WHEN TOO_MANY_ROWS THEN
        status := -6;
    WHEN OTHERS THEN
        status := -3;
END spPlayersSelect;

-- execution
DECLARE
    p_playerID players.playerID%TYPE := 1302;
    p_regNum players.regNumber%TYPE;
    p_lastN players.lastName%TYPE;
    p_firstN players.firstName%TYPE;
    p_is_active players.isActive%TYPE;
    status INT;
BEGIN
    spPlayersSelect(p_playerID, p_regNum, p_lastN, p_firstN, p_is_active, status);
    IF status = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Select successful.');
        DBMS_OUTPUT.PUT_LINE('PLAYERID: '|| p_playerID);
        DBMS_OUTPUT.PUT_LINE('REGNUMBER: '|| p_regNum);
        DBMS_OUTPUT.PUT_LINE('LASTNAME: '|| p_lastN);
        DBMS_OUTPUT.PUT_LINE('FIRSTNAME: '|| p_firstN);
        DBMS_OUTPUT.PUT_LINE('ISACTIVE: '|| p_is_active);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Select failed. Error code: ' || status);
    END IF;
END;

-- teams table select
CREATE OR REPLACE PROCEDURE spTeamsSelect(
    team_id IN teams.teamID%TYPE,
    team_name OUT teams.teamName%TYPE,
    is_active OUT teams.isActive%TYPE,
    jersey_colour OUT teams.jerseyColour%TYPE,
    status OUT INT
)
AS
BEGIN
    SELECT
        teamName,
        isActive,
        jerseyColour
    INTO
        team_name,
        is_active,
        jersey_colour
    FROM teams
    WHERE teamID = team_id;
    status := 1;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        status := -5;
    WHEN TOO_MANY_ROWS THEN
        status := -6;
    WHEN OTHERS THEN
        status := -3;
END spTeamsSelect;

-- execution
DECLARE
    t_teamID teams.teamID%TYPE := 210;
    t_regNum teams.teamName%TYPE;
    t_is_active teams.isActive%TYPE;
    t_jersey_colour teams.jerseyColour%TYPE;
    status INT;
BEGIN
    spTeamsSelect(t_teamID, t_regNum, t_is_active, t_jersey_colour, status);
    IF status = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Select successful.');
        DBMS_OUTPUT.PUT_LINE('TEAMID: '|| t_teamID);
        DBMS_OUTPUT.PUT_LINE('REGNUMBER: '|| t_regNum);
        DBMS_OUTPUT.PUT_LINE('ISACTIVE: '|| t_is_active);
        DBMS_OUTPUT.PUT_LINE('JERSEYCOLOUR: '|| t_jersey_colour);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Select failed. Error code: ' || status);
    END IF;
END;

-- rosters table select
CREATE OR REPLACE PROCEDURE spRostersSelect(
    roster_id IN rosters.rosterID%TYPE,
    player_id OUT rosters.playerID%TYPE,
    team_id OUT rosters.teamID%TYPE,
    is_active OUT rosters.isActive%TYPE,
    jersey_number OUT rosters.jerseyNumber%TYPE,
    status OUT INT
)
AS
BEGIN
    SELECT
        playerID,
        teamID,
        isActive,
        jerseyNumber
    INTO
        player_id,
        team_id,
        is_active,
        jersey_number
    FROM rosters
    WHERE rosterID = roster_id;
    status := 1;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        status := -5;
    WHEN TOO_MANY_ROWS THEN
        status := -6;
    WHEN OTHERS THEN
        status := -3;
END spRostersSelect;

DECLARE
    r_rosterID rosters.rosterID%TYPE := 1;
    r_player_id rosters.playerID%TYPE;
    r_team_id rosters.teamID%TYPE;
    r_jersey_colour rosters.isActive%TYPE;
    r_jersey_number rosters.jerseyNumber%TYPE;
    status INT;
BEGIN
    spRostersSelect(r_rosterID, r_player_id, r_team_id, r_jersey_colour, r_jersey_number, status);
    IF status = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Select successful.');
        DBMS_OUTPUT.PUT_LINE('ROSTERID: '|| r_rosterID);
        DBMS_OUTPUT.PUT_LINE('PLAYERID: '|| r_player_id);
        DBMS_OUTPUT.PUT_LINE('TEAMID: '|| r_team_id);
        DBMS_OUTPUT.PUT_LINE('JERSEYCOLOUR: '|| r_jersey_colour);
        DBMS_OUTPUT.PUT_LINE('JERSEYNUMBER: '|| r_jersey_number);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Select failed. Error code: ' || status);
    END IF;
END;


-- Q2
-- PLAYERS TABLE SELECT ALL
CREATE OR REPLACE PROCEDURE spPlayersSelectAll AS
    CURSOR pc IS
    SELECT * FROM players;
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        RPAD('PLAYERID', 12, ' ') ||
        RPAD('REGNUMBER', 12, ' ') ||
        RPAD('FIRSTNAME', 20, ' ') ||
        RPAD('LASTNAME', 20, ' ') ||
        'ACTIVE');
   FOR player IN pc
   LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(player.playerID, 12, ' ') ||
            RPAD(player.regNumber, 12, ' ') ||
            RPAD(player.firstName, 20, ' ') ||
            RPAD(player.lastName, 20, ' ') ||
            player.isActive);
   END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Select failed. Error code: -3');
END spPlayersSelectAll;

-- execution
BEGIN
    spPlayersSelectAll();
END;

-- teams table select all
CREATE OR REPLACE PROCEDURE spTeamsSelectAll AS
    CURSOR pc IS
    SELECT * FROM teams;
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        RPAD('TEAMID', 9, ' ') ||
        RPAD('TEAMNAME', 12, ' ') ||
        RPAD('ACTIVE', 9, ' ') ||
        'JERSEYCOLOUR');
   FOR team IN pc
   LOOP
      DBMS_OUTPUT.PUT_LINE(
          RPAD(team.teamID, 9, ' ') ||
          RPAD(team.teamName, 12, ' ') ||
          RPAD(team.isActive, 9, ' ') ||
          team.jerseyColour);
   END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Select failed. Error code: -3');
END spTeamsSelectAll;

-- execution
BEGIN
    spTeamsSelectAll();
END;

-- rosters table select all
CREATE OR REPLACE PROCEDURE spRostersSelectAll AS
    CURSOR pc IS
    SELECT * FROM rosters;
BEGIN
   DBMS_OUTPUT.PUT_LINE(
       RPAD('ROSTERID', 12, ' ') ||
       RPAD('PLAYERID', 12, ' ') ||
       RPAD('TEAMID', 9, ' ') ||
       RPAD('ACTIVE', 9, ' ') ||
       'JERSEYNUMBER');
   FOR roster IN pc
   LOOP
      DBMS_OUTPUT.PUT_LINE(
          RPAD(roster.rosterID, 12, ' ') ||
          RPAD(roster.playerID, 12, ' ') ||
          RPAD(roster.teamID, 9, ' ') ||
          RPAD(roster.isActive, 9, ' ') ||
          roster.jerseyNumber);
   END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Select failed. Error code: -3');
END spRostersSelectAll;

BEGIN
    spRostersSelectAll();
END;

-- Q3
-- players table
CREATE OR REPLACE PROCEDURE spPlayersSelectAllOutput(p_result OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_result FOR
        SELECT * FROM players;
END spPlayersSelectAllOutput;

-- execution
DECLARE
    p1_result SYS_REFCURSOR;
    player_id players.playerID%TYPE;
    reg_number players.regNumber%TYPE;
    last_name players.lastName%TYPE;
    first_name players.firstName%TYPE;
    is_active players.isActive%TYPE;
BEGIN
    spPlayersSelectAllOutput(p1_result);
    DBMS_OUTPUT.PUT_LINE(
        RPAD('PLAYERID', 12, ' ') ||
        RPAD('REGNUMBER', 12, ' ') ||
        RPAD('LASTNAME', 20, ' ') ||
        RPAD('FIRSTNAME', 20, ' ') ||
        'ACTIVE');
    LOOP
        FETCH p1_result INTO player_id, reg_number, last_name, first_name, is_active;
        EXIT WHEN p1_result%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(player_id, 12, ' ') ||
            RPAD(reg_number, 12, ' ') ||
            RPAD(last_name, 20, ' ') ||
            RPAD(first_name, 20, ' ') ||
            is_active
        );
    END LOOP;
    CLOSE p1_result;
END;

-- teams table
CREATE OR REPLACE PROCEDURE spTeamsSelectAllOutput(p_result OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_result FOR
        SELECT * FROM teams;
END spTeamsSelectAllOutput;

-- execution
DECLARE
    p1_result SYS_REFCURSOR;
    team_id teams.teamID%TYPE;
    team_name teams.teamName%TYPE;
    is_active teams.isActive%TYPE;
    jersey_colour teams.jerseyColour%TYPE;
BEGIN
    spTeamsSelectAllOutput(p1_result);
    DBMS_OUTPUT.PUT_LINE(
        RPAD('TEAMID', 9, ' ') ||
        RPAD('TEAMNAME', 12, ' ') ||
        RPAD('ACTIVE', 9, ' ') ||
        'JERSEYNUMBER');
    LOOP
        FETCH p1_result INTO team_id, team_name, is_active, jersey_colour;
        EXIT WHEN p1_result%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(team_id, 9, ' ') ||
            RPAD(team_name, 12, ' ') ||
            RPAD(is_active, 9, ' ') ||
            jersey_colour);
    END LOOP;
    CLOSE p1_result;
END;

-- rosters table
CREATE OR REPLACE PROCEDURE spRostersSelectAllOutput(p_result OUT SYS_REFCURSOR)
AS
BEGIN
    OPEN p_result FOR
        SELECT * FROM rosters;
END spRostersSelectAllOutput;

-- execution
DECLARE
    p1_result SYS_REFCURSOR;
    roster_id rosters.rosterID%TYPE;
    player_id rosters.playerID%TYPE;
    team_id rosters.teamID%TYPE;
    is_active rosters.isActive%TYPE;
    jersey_number rosters.jerseyNumber%TYPE;
BEGIN
    spRostersSelectAllOutput(p1_result);
    DBMS_OUTPUT.PUT_LINE(
        RPAD('ROSTERID', 12, ' ') ||
        RPAD('PLAYERID', 12, ' ') ||
        RPAD('TEAMID', 9, ' ') ||
        RPAD('ACTIVE', 9, ' ') ||
        'JERSEY NUMBER');
    LOOP
        FETCH p1_result INTO roster_id, player_id, team_id, is_active, jersey_number;
        EXIT WHEN p1_result%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(roster_id, 12, ' ') ||
            RPAD(player_id, 12, ' ') ||
            RPAD(team_id, 9, ' ') ||
            RPAD(is_active, 9, ' ') ||
            jersey_number);
    END LOOP;
    CLOSE p1_result;
END;

-- Q4
CREATE OR REPLACE VIEW vwPlayerRosters AS
SELECT
    p.playerID AS playerID,
    regNumber,
    firstName,
    lastName,
    p.isActive AS playerIsActive,
    t.teamID AS teamID,
    teamName,
    t.isActive AS teamIsActive,
    jerseyColour,
    rosterID,
    r.isActive AS rosterIsActive,
    jerseyNumber
FROM players p
    JOIN rosters r ON p.playerID = r.playerID
    JOIN teams t ON r.teamID = t.teamID
ORDER BY playerID;

-- execution
SELECT * FROM vwPlayerRosters;

-- Q5
CREATE OR REPLACE PROCEDURE spTeamRosterByID( tID vwPlayerRosters.teamID%TYPE ) AS
    roster vwPlayerRosters%ROWTYPE;
    found INT := 0;
    CURSOR pc IS
        SELECT * FROM vwPlayerRosters
        WHERE teamID = tID;
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        RPAD('PlayerID', 12, ' ') ||
        RPAD('FirstName', 20, ' ') ||
        RPAD('LastName', 20, ' ') ||
        RPAD('JerseyNumber', 13, ' ') ||
        RPAD('Team', 15, ' ')
    );
    OPEN pc;
        LOOP
            FETCH pc INTO roster;
            IF pc%NOTFOUND AND found = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error code: -7');
                EXIT;
            ELSE
                found := 1;
            END IF;
            EXIT WHEN pc%NOTFOUND AND found = 1;
            DBMS_OUTPUT.PUT_LINE(
                RPAD(roster.playerID, 12, ' ') ||
                RPAD(roster.firstName, 20, ' ') ||
                RPAD(roster.lastName, 20, ' ') ||
                RPAD(roster.jerseyNumber, 13, ' ') ||
                RPAD(roster.teamName, 15, ' '));
        END LOOP;
    CLOSE pc;
EXCEPTION
    WHEN ROWTYPE_MISMATCH THEN
        DBMS_OUTPUT.PUT_LINE('Error code: -8');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: -3');
END spTeamRosterByID;

-- execution
BEGIN
    spTeamRosterByID(212);
END;

-- Q6
CREATE OR REPLACE PROCEDURE spTeamRosterByName( tname vwPlayerRosters.teamName%TYPE )AS
    roster vwPlayerRosters%ROWTYPE;
    found INT := 0;
    CURSOR pc IS
        SELECT * FROM vwPlayerRosters
        WHERE UPPER(teamName) LIKE '%' || UPPER(tname) || '%';
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        RPAD('PlayerID', 12, ' ') ||
        RPAD('FirstName', 20, ' ') ||
        RPAD('LastName', 20, ' ') ||
        RPAD('JerseyNumber', 13, ' ') ||
        RPAD('Team', 15, ' ')
    );
    OPEN pc;
        LOOP
            FETCH pc INTO roster;
            IF pc%NOTFOUND AND found = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error code: -7');
                EXIT;
            ELSE
                found := 1;
            END IF;
            EXIT WHEN pc%NOTFOUND AND found = 1;
            DBMS_OUTPUT.PUT_LINE(
                RPAD(roster.playerID, 12, ' ') ||
                RPAD(roster.firstName, 20, ' ') ||
                RPAD(roster.lastName, 20, ' ') ||
                RPAD(roster.jerseyNumber, 13, ' ') ||
                RPAD(roster.teamName, 15, ' '));
        END LOOP;
    CLOSE pc;
EXCEPTION
    WHEN ROWTYPE_MISMATCH THEN
        DBMS_OUTPUT.PUT_LINE('Error code: -8');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: -3');
END spTeamRosterByName;

-- execution
BEGIN
    spTeamRosterByName('aur');
END;

-- Q7
CREATE OR REPLACE VIEW vwTeamsNumPlayers AS
SELECT
    teamID,
    COUNT(playerID) AS numPlayers
FROM rosters
WHERE isActive = 1
GROUP BY teamID
ORDER BY teamID;

-- execution
SELECT * FROM vwTeamsNumPlayers;

-- Q8
CREATE OR REPLACE FUNCTION fncNumPlayersByTeamID ( tid INT )
    RETURN INT IS
    np INT;
BEGIN
    SELECT numPlayers
    INTO np
    FROM vwTeamsNumPlayers
    WHERE teamID = tid;
    RETURN np;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        np := -5;
        RETURN np;
    WHEN TOO_MANY_ROWS THEN
        np := -6;
        RETURN np;
    WHEN OTHERS THEN
        np := -3;
        RETURN np;
END fncNumPlayersByTeamID;

-- execution
BEGIN
    DBMS_OUTPUT.PUT_LINE(fncNumPlayersByTeamID(212));
END;

-- Q9
CREATE OR REPLACE VIEW vwSchedule AS
SELECT
    gameID,
    gameNum,
    gameDateTime,
    homeTeam,
    homeScore,
    visitTeam,
    visitScore,
    g.locationID,
    ht.teamName AS homeTeamName,
    vt.teamName AS visitTeamName,
    locationName
FROM games g
    JOIN teams ht ON g.homeTeam = ht.teamID
    JOIN teams vt ON g.visitTeam = vt.teamID
    JOIN slLocations l ON g.locationID = l.locationID
ORDER BY gameID;

-- execution
SELECT * FROM vwSchedule;

-- Q10
CREATE OR REPLACE PROCEDURE spSchedUpcomingGames ( numDay INT ) AS
    game vwSchedule%ROWTYPE;
    found INT := 0;
    CURSOR pc IS
        SELECT * FROM vwSchedule
        WHERE
            TRUNC(gameDateTime) - TRUNC(sysdate)  <= numDay AND
            TRUNC(gameDateTime) - TRUNC(sysdate) > 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        RPAD('GAMEID', 7, ' ') ||
        RPAD('GAMEDATETIME', 15, ' ') ||
        RPAD('HOMETEAMNAME', 15, ' ') ||
        RPAD('VISITTEAMNAME', 15, ' ') ||
        RPAD('LOCATIONNAME', 22, ' '));
    OPEN pc;
        LOOP
            FETCH pc INTO game;
            IF pc%NOTFOUND AND found = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error code: -7');
                EXIT;
            ELSE
                found := 1;
            END IF;
            EXIT WHEN pc%NOTFOUND AND found = 1;
            DBMS_OUTPUT.PUT_LINE(
                RPAD(game.gameID, 7, ' ') ||
                RPAD(TO_CHAR(game.gameDateTime, 'Mon-dd-yyyy'), 15, ' ') ||
                RPAD(game.homeTeamName, 15, ' ') ||
                RPAD(game.visitTeamName, 15, ' ') ||
                RPAD(game.locationName, 22, ' '));
        END LOOP;
    CLOSE pc;
EXCEPTION
    WHEN ROWTYPE_MISMATCH THEN
        DBMS_OUTPUT.PUT_LINE('Error code: -8');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: -3');
END spSchedUpcomingGames;

-- execution
BEGIN
    spSchedUpcomingGames(5);
END;

-- Q11
CREATE OR REPLACE PROCEDURE spSchedPastGames ( numDay INT ) AS
    game vwSchedule%rowtype;
    found INT := 0;
    CURSOR pc IS
        SELECT * FROM vwSchedule
        WHERE
            TRUNC(sysdate) - TRUNC(gameDateTime) <= numDay AND
            TRUNC(sysdate) - TRUNC(gameDateTime) > 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        RPAD('GAMEID', 7, ' ') ||
        RPAD('GAMEDATETIME', 15, ' ') ||
        RPAD('HOMETEAMNAME', 15, ' ') ||
        RPAD('HOMESCORE', 10, ' ') ||
        RPAD('VISITTEAMNAME', 15, ' ') ||
        RPAD('VISITSCORE', 11, ' ') ||
        RPAD('LOCATIONNAME', 22, ' '));
    OPEN pc;
        LOOP
            FETCH pc INTO game;
            IF pc%NOTFOUND AND found = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error code: -7');
                EXIT;
            ELSE
                found := 1;
            END IF;
            EXIT WHEN pc%NOTFOUND AND found = 1;
            DBMS_OUTPUT.PUT_LINE(
                RPAD(game.gameID, 7, ' ') ||
                RPAD(TO_CHAR(game.gameDateTime, 'Mon-dd-yyyy'), 15, ' ') ||
                RPAD(game.homeTeamName, 15, ' ') ||
                RPAD(game.homeScore, 10, ' ') ||
                RPAD(game.visitTeamName, 15, ' ') ||
                RPAD(game.visitScore, 11, ' ') ||
                RPAD(game.locationName, 22, ' '));
        END LOOP;
    CLOSE pc;
EXCEPTION
    WHEN ROWTYPE_MISMATCH THEN
        DBMS_OUTPUT.PUT_LINE('Error code: -8');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: -3');
END spSchedPastGames;

-- execution
BEGIN
    spSchedPastGames(5);
END;

-- Q12
CREATE OR REPLACE PROCEDURE spRunStandings AS
BEGIN
    DELETE FROM tempStandings;
    INSERT INTO tempStandings (
    SELECT
        TheTeamID,
        (SELECT teamname FROM teams WHERE teamid = t.TheTeamID) AS teamname,
        SUM(GamesPlayed) AS GP,
        SUM(Wins) AS W,
        SUM(Losses) AS L,
        SUM(Ties) AS T,
        SUM(Wins) * 3 + SUM(Ties) AS Pts,
        SUM(GoalsFor) AS GF,
        SUM(GoalsAgainst) AS GA,
        SUM(GoalsFor) - SUM(GoalsAgainst) AS GD
    FROM (
        SELECT
            hometeam AS TheTeamID,
            COUNT(gameID) AS GamesPlayed,
            SUM(homescore) AS GoalsFor,
            SUM(visitscore) AS GoalsAgainst,
            SUM(
                CASE
                    WHEN homescore > visitscore THEN 1
                    ELSE 0
                    END) AS Wins,
            SUM(
                CASE
                    WHEN homescore < visitscore THEN 1
                    ELSE 0
                    END) AS Losses,
            SUM(
                CASE
                    WHEN homescore = visitscore THEN 1
                    ELSE 0
                    END) AS Ties
        FROM games
        WHERE isPlayed = 1
        GROUP BY hometeam
        UNION ALL
        SELECT
            visitteam AS TheTeamID,
            COUNT(gameID) AS GamesPlayed,
            SUM(visitscore) AS GoalsFor,
            SUM(homescore) AS GoalsAgainst,
            SUM(
                CASE
                    WHEN homescore < visitscore THEN 1
                    ELSE 0
                    END) AS Wins,
            SUM(
                CASE
                    WHEN homescore > visitscore THEN 1
                    ELSE 0
                    END) AS Losses,
            SUM(
                CASE
                    WHEN homescore = visitscore THEN 1
                    ELSE 0
                    END) AS Ties
        FROM games
        WHERE isPlayed = 1
        GROUP BY visitteam) t
    GROUP BY TheTeamID);
END spRunStandings;

-- execution
BEGIN
    spRunStandings();
END;

-- Q13
CREATE OR REPLACE TRIGGER trgRunStandings
AFTER INSERT OR UPDATE OR DELETE ON games
BEGIN
    spRunStandings();
END trgRunStandings;

-- execution
UPDATE games SET homescore = 2 WHERE gameid = 1;
SELECT * FROM tempStandings;

-- Q14
-- view
CREATE OR REPLACE VIEW vwTeamScorer AS
SELECT
    firstName,
    lastName,
    teamId,
    SUM(numGoals) AS totalGoals
FROM goalscorers gs
    JOIN players p ON gs.playerId = p.playerId
GROUP BY
    firstName,
    lastName,
    teamId
ORDER BY totalGoals DESC;

-- stored procedure
CREATE OR REPLACE PROCEDURE spTeamScorer ( tid INT ) AS
    scorer vwTeamScorer%rowtype;
    found INT := 0;
    CURSOR pc IS
        SELECT * FROM vwTeamScorer
        WHERE teamId = tid;
BEGIN
    DBMS_OUTPUT.PUT_LINE(
        RPAD('FIRSTNAME', 15, ' ') ||
        RPAD('LASTNAME', 15, ' ') ||
        RPAD('TOTALGOALS', 10, ' '));
    OPEN pc;
        LOOP
            FETCH pc INTO scorer;
            IF pc%NOTFOUND AND found = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Error code: -7');
                EXIT;
            ELSE
                found := 1;
            END IF;
            EXIT WHEN pc%NOTFOUND AND found = 1;
            DBMS_OUTPUT.PUT_LINE(
                RPAD(scorer.firstName, 15, ' ') ||
                RPAD(scorer.lastName, 15, ' ') ||
                RPAD(scorer.totalGoals, 10, ' '));
        END LOOP;
    CLOSE pc;
EXCEPTION
    WHEN ROWTYPE_MISMATCH THEN
        DBMS_OUTPUT.PUT_LINE('Error code: -8');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: -3');
END spTeamScorer;

-- execution
BEGIN
    spTeamScorer(212);
END;