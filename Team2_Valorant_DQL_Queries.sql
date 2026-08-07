        -- =====================================================================
-- Valorant Match-Tracking Database
-- Data Query Language (DQL) File - SELECT statements
-- Author: Jacob (In charge of DQL files) / Team Top Fraggers
--
-- Each query below is mapped to a Use Case from the Design Doc.
-- Total queries: 15
-- Queries with JOINs: 14
-- Queries with Aggregate Functions: 6
-- Queries using VIEWs: 6
-- =====================================================================


-- ---------------------------------------------------------------------
-- Use Case: (Player) View their full match history, sorted by most recent.
-- Shows every match a specific player has taken part in, most recent first.
-- Uses JOIN + VIEW
-- ---------------------------------------------------------------------
SELECT
    PlayerName,
    MatchID,
    MatchDate,
    GamemodeName,
    MapName,
    TeamSide,
    WinningTeam
FROM vw_PlayerMatchHistory
WHERE PlayerName = 'ExamplePlayer'
ORDER BY MatchDate DESC;


-- ---------------------------------------------------------------------
-- Use Case: (Player) View detailed stats (K/D/A, Score) for a specific
-- past match.
-- Uses JOIN + VIEW
-- ---------------------------------------------------------------------
SELECT
    PlayerName,
    MatchID,
    MatchDate,
    AgentName,
    Kills,
    Deaths,
    Assists,
    Score
FROM vw_MatchScore
WHERE PlayerName = 'ExamplePlayer'
  AND MatchID = 1;


-- ---------------------------------------------------------------------
-- Use Case: (Player) Customize and save an ability/weapon loadout before
-- joining a match.
-- Retrieves the saved ability + weapon loadout for a player's match entry.
-- Uses JOIN.
-- ---------------------------------------------------------------------
SELECT
    p.PlayerName,
    mp.MatchID,
    ab.AbilityName,
    w.WeaponName,
    w.WeaponType
FROM PlayerAbilityLoadout pal
JOIN MatchPlayer mp ON pal.MatchPlayerID = mp.MatchPlayerID
JOIN Player p       ON mp.PlayerID = p.PlayerID
JOIN Ability ab     ON pal.AbilityID = ab.AbilityID
LEFT JOIN Weapon w  ON pal.WeaponID = w.WeaponID
WHERE mp.MatchPlayerID = 1;


-- ---------------------------------------------------------------------
-- Use Case: (Player) Check their current rank and account level progress.
-- Looks up a single player's rank and region.
-- Uses JOIN.
-- ---------------------------------------------------------------------
SELECT
    p.PlayerName,
    r.RankName,
    reg.RegionName
FROM Player p
JOIN Rank r     ON p.RankID = r.RankID
JOIN Region reg ON p.RegionID = reg.RegionID
WHERE p.PlayerName = 'ExamplePlayer';


-- ---------------------------------------------------------------------
-- Use Case: (System) Record a new match's outcome (map, mode, winning
-- team) when it ends.
-- Retrieves the full outcome summary of a completed match for display.
-- Uses JOIN.
-- ---------------------------------------------------------------------
SELECT
    m.MatchID,
    m.MatchDate,
    g.GamemodeName,
    mp.MapName,
    m.WinningTeam
FROM Match m
JOIN Gamemode g ON m.GamemodeID = g.GamemodeID
JOIN Map mp     ON m.MapID = mp.MapID
ORDER BY m.MatchDate DESC
LIMIT 10;


-- ---------------------------------------------------------------------
-- Use Case: (System) Log each participating player's per-match
-- performance stats and final rank.
-- Full box score for every player in a given match, including their rank.
-- Uses JOIN + VIEW
-- ---------------------------------------------------------------------
SELECT
    MatchID,
    PlayerName,
    AgentName,
    TeamSide,
    RankName,
    Kills,
    Deaths,
    Assists,
    Score
FROM vw_MatchScore
WHERE MatchID = 1
ORDER BY Score DESC;


-- ---------------------------------------------------------------------
-- Use Case: (Player) Compare their average stats (Kills/Deaths/Assists/
-- Score) across matches on a specific map.
-- Uses JOIN + AGGREGATE (AVG) + VIEW
-- ---------------------------------------------------------------------
SELECT
    PlayerName,
    MapName,
    AvgKills,
    AvgDeaths,
    AvgAssists,
    AvgScore
FROM vw_PlayerAvgStatsByMap
WHERE PlayerName = 'ExamplePlayer'
  AND MapName = 'Ascent';


-- ---------------------------------------------------------------------
-- Use Case: (Player/Admin) Look up which agents a player uses most
-- frequently and their win rate with each.
-- Counts how often a player picked each agent and how many of those
-- matches their team won.
-- Uses JOIN + AGGREGATE (COUNT, SUM).
-- ---------------------------------------------------------------------
SELECT
    p.PlayerName,
    a.AgentName,
    COUNT(*) AS TimesPlayed,
    SUM(CASE WHEN mp.TeamSide = m.WinningTeam THEN 1 ELSE 0 END) AS Wins
FROM MatchPlayer mp
JOIN Player p ON mp.PlayerID = p.PlayerID
JOIN Agent a  ON mp.AgentID = a.AgentID
JOIN Match m  ON mp.MatchID = m.MatchID
WHERE p.PlayerName = 'ExamplePlayer'
GROUP BY p.PlayerName, a.AgentName
ORDER BY TimesPlayed DESC;


-- ---------------------------------------------------------------------
-- Use Case: (Admin) Correct or remove a fraudulent/erroneous match
-- record and audit related player stats.
-- Pulls every player-stat row tied to a single match so an admin can
-- review the full record before editing/deleting it.
-- Uses JOIN.
-- ---------------------------------------------------------------------
SELECT
    m.MatchID,
    m.MatchDate,
    p.PlayerName,
    a.AgentName,
    ms.MatchStatsID,
    ms.Kills,
    ms.Deaths,
    ms.Assists,
    ms.Score
FROM Match m
JOIN MatchPlayer mp ON m.MatchID = mp.MatchID
JOIN Player p       ON mp.PlayerID = p.PlayerID
JOIN Agent a        ON mp.AgentID = a.AgentID
JOIN MatchStats ms  ON ms.MatchPlayerID = mp.MatchPlayerID
WHERE m.MatchID = 1;


-- ---------------------------------------------------------------------
-- Use Case: (Admin) Audit overall player activity - total matches
-- played and total kills, to help spot suspicious stat patterns.
-- Uses AGGREGATE (COUNT, SUM) - no join needed, single table rollup
-- of MatchPlayer/MatchStats already resolved via subquery-free grouping.
-- ---------------------------------------------------------------------
SELECT
    PlayerID,
    COUNT(*) AS TotalMatches
FROM MatchPlayer
GROUP BY PlayerID
ORDER BY TotalMatches DESC;


-- ---------------------------------------------------------------------
-- Use Case: (Admin) See how many players currently sit at each
-- competitive rank, to monitor the overall rank distribution.
-- Uses JOIN + AGGREGATE (COUNT).
-- ---------------------------------------------------------------------
SELECT
    r.RankName,
    COUNT(p.PlayerID) AS NumberOfPlayers
FROM Rank r
LEFT JOIN Player p ON r.RankID = p.RankID
GROUP BY r.RankName
ORDER BY NumberOfPlayers DESC;


-- ---------------------------------------------------------------------
-- Use Case: (Admin) Add new agents or abilities via game updates -
-- view all current agents along with their assigned role.
-- Uses JOIN.
-- ---------------------------------------------------------------------
SELECT
    a.AgentName,
    ro.RoleName
FROM Agent a
JOIN Role ro ON a.RoleID = ro.RoleID
ORDER BY ro.RoleName, a.AgentName;


-- ---------------------------------------------------------------------
-- Use Case: (Admin) Identify the most popular agents server-wide,
-- to help balance future game updates.
-- Uses JOIN + AGGREGATE (COUNT) + VIEW.
-- ---------------------------------------------------------------------
SELECT
    AgentName,
    TimesPicked
FROM vw_AgentUsage
ORDER BY TimesPicked DESC;


-- ---------------------------------------------------------------------
-- Use Case: (Admin) Identify the most-used weapons across all matches
-- to inform balance patches.
-- Uses JOIN + AGGREGATE (COUNT) + VIEW.
-- ---------------------------------------------------------------------
SELECT
    WeaponName,
    WeaponType,
    TimesUsed
FROM vw_WeaponUsage
ORDER BY TimesUsed DESC;


-- ---------------------------------------------------------------------
-- Use Case: (Player) Register a new account and set up a profile -
-- verify a player's profile was created correctly by looking them up
-- along with their chosen region and starting rank.
-- Uses JOIN.
-- ---------------------------------------------------------------------
SELECT
    p.PlayerID,
    p.PlayerName,
    reg.RegionName,
    r.RankName
FROM Player p
JOIN Region reg ON p.RegionID = reg.RegionID
JOIN Rank r     ON p.RankID = r.RankID
ORDER BY p.PlayerID DESC
LIMIT 1;
