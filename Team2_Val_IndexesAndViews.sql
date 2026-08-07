-- Author: Curtis

-- INDEXES

-- Player lookups by name and joins to Region/Rank
CREATE INDEX IF NOT EXISTS idx_Player_PlayerName ON Player(PlayerName);
CREATE INDEX IF NOT EXISTS idx_Player_RegionID ON Player(RegionID);
CREATE INDEX IF NOT EXISTS idx_Player_RankID ON Player(RankID);

-- Match: used in ORDER BY and joins
CREATE INDEX IF NOT EXISTS idx_Match_MatchDate ON Match(MatchDate);
CREATE INDEX IF NOT EXISTS idx_Match_GamemodeID ON Match(GamemodeID);
CREATE INDEX IF NOT EXISTS idx_Match_MapID ON Match(MapID);

-- MatchPlayer: for queries that filter/join by PlayerID or AgentID directly
CREATE INDEX IF NOT EXISTS idx_MatchPlayer_PlayerID ON MatchPlayer(PlayerID);
CREATE INDEX IF NOT EXISTS idx_MatchPlayer_AgentID ON MatchPlayer(AgentID);
CREATE INDEX IF NOT EXISTS idx_MatchPlayer_WeaponID ON MatchPlayer(WeaponID);

-- Agent: role-based lookups
CREATE INDEX IF NOT EXISTS idx_Agent_RoleID ON Agent(RoleID);

-- Weapon: queries that group by type / filter by type
CREATE INDEX IF NOT EXISTS idx_Weapon_WeaponType ON Weapon(WeaponType);

-- PlayerAbilityLoadout: for querying by AbilityID alone
CREATE INDEX IF NOT EXISTS idx_PAL_AbilityID ON PlayerAbilityLoadout(AbilityID);

-- MatchStats: for sorting by Score
CREATE INDEX IF NOT EXISTS idx_MatchStats_Score ON MatchStats(Score);

-- VIEWS

-- Player match history view
CREATE VIEW IF NOT EXISTS vw_PlayerMatchHistory AS
SELECT
    p.PlayerID,
    p.PlayerName,
    m.MatchID,
    m.MatchDate,
    g.GamemodeName,
    mp2.MapName AS MapName,
    mp.TeamSide,
    m.WinningTeam
FROM MatchPlayer mp
JOIN Player p ON mp.PlayerID = p.PlayerID
JOIN Match m ON mp.MatchID = m.MatchID
JOIN Gamemode g ON m.GamemodeID = g.GamemodeID
JOIN Map mp2 ON m.MapID = mp2.MapID;

-- Match score (per-match full stat lines)
CREATE VIEW IF NOT EXISTS vw_MatchScore AS
SELECT
    m.MatchID,
    m.MatchDate,
    p.PlayerID,
    p.PlayerName,
    a.AgentName,
    mp.TeamSide,
    r.RankName,
    ms.Kills,
    ms.Deaths,
    ms.Assists,
    ms.Score
FROM Match m
JOIN MatchPlayer mp ON m.MatchID = mp.MatchID
JOIN Player p ON mp.PlayerID = p.PlayerID
JOIN Agent a ON mp.AgentID = a.AgentID
LEFT JOIN Rank r ON p.RankID = r.RankID
LEFT JOIN MatchStats ms ON ms.MatchPlayerID = mp.MatchPlayerID;

-- Agent usage aggregation
CREATE VIEW IF NOT EXISTS vw_AgentUsage AS
SELECT
    a.AgentID,
    a.AgentName,
    COUNT(mp.MatchPlayerID) AS TimesPicked
FROM Agent a
LEFT JOIN MatchPlayer mp ON a.AgentID = mp.AgentID
GROUP BY a.AgentID, a.AgentName;

-- Weapon usage aggregation
CREATE VIEW IF NOT EXISTS vw_WeaponUsage AS
SELECT
    w.WeaponID,
    w.WeaponName,
    w.WeaponType,
    COUNT(mp.MatchPlayerID) AS TimesUsed
FROM Weapon w
LEFT JOIN MatchPlayer mp ON w.WeaponID = mp.WeaponID
GROUP BY w.WeaponID, w.WeaponName, w.WeaponType;

-- Player average stats per map
CREATE VIEW IF NOT EXISTS vw_PlayerAvgStatsByMap AS
SELECT
    p.PlayerID,
    p.PlayerName,
    map.MapID,
    map.MapName,
    AVG(ms.Kills)   AS AvgKills,
    AVG(ms.Deaths)  AS AvgDeaths,
    AVG(ms.Assists) AS AvgAssists,
    AVG(ms.Score)   AS AvgScore
FROM MatchStats ms
JOIN MatchPlayer mp ON ms.MatchPlayerID = mp.MatchPlayerID
JOIN Player p ON mp.PlayerID = p.PlayerID
JOIN Match m ON mp.MatchID = m.MatchID
JOIN Map map ON m.MapID = map.MapID
GROUP BY p.PlayerID, map.MapID;
