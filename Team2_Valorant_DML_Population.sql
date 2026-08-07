-- Author: Saint

PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;

INSERT INTO Region (RegionName) VALUES
('North America'), ('Europe'), ('Brazil'), ('Korea'),
('Asia Pacific'), ('Latin America'), ('Japan'), ('Oceania');

INSERT INTO Rank (RankName) VALUES
('Iron'), ('Bronze'), ('Silver'), ('Gold'), ('Platinum'),
('Diamond'), ('Ascendant'), ('Immortal'), ('Radiant');

INSERT INTO Role (RoleName) VALUES
('Controller'), ('Duelist'), ('Initiator'), ('Sentinel');

INSERT INTO Gamemode (GamemodeName) VALUES
('Competitive'), ('Unrated'), ('Swiftplay'), ('Spike Rush'),
('Deathmatch'), ('Team Deathmatch'), ('Escalation'), ('Custom');

INSERT INTO Map (MapName) VALUES
('Abyss'), ('Ascent'), ('Bind'), ('Breeze'), ('Corrode'), ('Fracture'),
('Haven'), ('Icebox'), ('Lotus'), ('Pearl'), ('Split'), ('Summit'), ('Sunset');

INSERT INTO Weapon (WeaponName, WeaponType) VALUES
('Bandit', 'Sidearm'), ('Classic', 'Sidearm'), ('Shorty', 'Sidearm'),
('Frenzy', 'Sidearm'), ('Ghost', 'Sidearm'), ('Sheriff', 'Sidearm'),
('Stinger', 'SMG'), ('Spectre', 'SMG'), ('Bucky', 'Shotgun'),
('Judge', 'Shotgun'), ('Bulldog', 'Rifle'), ('Guardian', 'Rifle'),
('Phantom', 'Rifle'), ('Vandal', 'Rifle'), ('Marshal', 'Sniper'),
('Outlaw', 'Sniper'), ('Operator', 'Sniper'), ('Ares', 'Heavy'),
('Odin', 'Heavy'), ('Tactical Knife', 'Melee');

INSERT INTO Ability (AbilityName) VALUES
('Cloudburst'), ('Updraft'), ('Tailwind'), ('Blade Storm'),
('Shock Bolt'), ('Recon Bolt'), ('Owl Drone'), ('Hunter''s Fury'),
('Barrier Orb'), ('Slow Orb'), ('Healing Orb'), ('Resurrection'),
('Shrouded Step'), ('Paranoia'), ('Dark Cover'), ('From the Shadows'),
('Blaze'), ('Curveball'), ('Hot Hands'), ('Run It Back'),
('Nanoswarm'), ('Alarmbot'), ('Turret'), ('Lockdown'),
('Boom Bot'), ('Blast Pack'), ('Paint Shells'), ('Showstopper'),
('Trapwire'), ('Cyber Cage'), ('Spycam'), ('Neural Theft'),
('Snake Bite'), ('Poison Cloud'), ('Toxic Screen'), ('Viper''s Pit'),
('Aftershock'), ('Flashpoint'), ('Fault Line'), ('Rolling Thunder');

INSERT INTO Agent (AgentName, RoleID)
SELECT seed.AgentName, r.RoleID
FROM (
    SELECT 'Jett' AgentName, 'Duelist' RoleName UNION ALL
    SELECT 'Sova', 'Initiator' UNION ALL
    SELECT 'Sage', 'Sentinel' UNION ALL
    SELECT 'Omen', 'Controller' UNION ALL
    SELECT 'Phoenix', 'Duelist' UNION ALL
    SELECT 'Killjoy', 'Sentinel' UNION ALL
    SELECT 'Raze', 'Duelist' UNION ALL
    SELECT 'Cypher', 'Sentinel' UNION ALL
    SELECT 'Viper', 'Controller' UNION ALL
    SELECT 'Breach', 'Initiator'
) seed
JOIN Role r ON r.RoleName = seed.RoleName;

INSERT INTO Player (PlayerName, RegionID, RankID)
SELECT seed.PlayerName, reg.RegionID, r.RankID
FROM (
    SELECT 'jisutzu' PlayerName, 'North America' RegionName, 'Gold' RankName UNION ALL
    SELECT 'DESTROYBOT554', 'North America', 'Platinum' UNION ALL
    SELECT 'provrb', 'Europe', 'Diamond' UNION ALL
    SELECT 'frawg', 'Brazil', 'Ascendant' UNION ALL
    SELECT 'United', 'Korea', 'Immortal' UNION ALL
    SELECT 'DukeBabyKai', 'Asia Pacific', 'Gold' UNION ALL
    SELECT 'D1 Munch', 'Latin America', 'Platinum' UNION ALL
    SELECT 'baby pluto', 'Japan', 'Diamond' UNION ALL
    SELECT 'MunchSupremacy', 'Oceania', 'Silver' UNION ALL
    SELECT 'Osiris', 'North America', 'Ascendant' UNION ALL
    SELECT 'Court', 'Europe', 'Immortal' UNION ALL
    SELECT 'Redkiller880', 'Brazil', 'Diamond' UNION ALL
    SELECT 'LavaThief', 'Korea', 'Platinum' UNION ALL
    SELECT 'LordFrog', 'Asia Pacific', 'Gold' UNION ALL
    SELECT 'Bongo', 'Latin America', 'Silver' UNION ALL
    SELECT 'Ccoletoodirt', 'Japan', 'Ascendant' UNION ALL
    SELECT 'OptimalZ', 'Oceania', 'Diamond' UNION ALL
    SELECT 'kizar2mello', 'North America', 'Immortal' UNION ALL
    SELECT 'Draquino', 'Europe', 'Platinum' UNION ALL
    SELECT 'Delta', 'Brazil', 'Gold' UNION ALL
    SELECT 'SnazzyPot', 'Korea', 'Radiant' UNION ALL
    SELECT 'Tray', 'Asia Pacific', 'Diamond' UNION ALL
    SELECT 'predator', 'Latin America', 'Ascendant' UNION ALL
    SELECT 'Bnetplayer', 'Japan', 'Silver' UNION ALL
    SELECT 'heyyitskiwi', 'Oceania', 'Immortal'
) seed
JOIN Region reg ON reg.RegionName = seed.RegionName
JOIN Rank r ON r.RankName = seed.RankName
WHERE NOT EXISTS (
    SELECT 1 FROM Player p WHERE p.PlayerName = seed.PlayerName
);

INSERT INTO Match (MatchDate, GamemodeID, MapID, WinningTeam)
SELECT seed.MatchDate, g.GamemodeID, m.MapID, seed.WinningTeam
FROM (
    SELECT '2026-07-18' MatchDate, 'Competitive' GamemodeName, 'Ascent' MapName, 'Attackers' WinningTeam UNION ALL
    SELECT '2026-07-23', 'Competitive', 'Haven', 'Defenders' UNION ALL
    SELECT '2026-07-29', 'Unrated', 'Bind', 'Attackers'
) seed
JOIN Gamemode g ON g.GamemodeName = seed.GamemodeName
JOIN Map m ON m.MapName = seed.MapName
WHERE NOT EXISTS (
    SELECT 1 FROM Match existing
    WHERE existing.MatchDate = seed.MatchDate
      AND existing.GamemodeID = g.GamemodeID
      AND existing.MapID = m.MapID
);

WITH roster(MatchDate, PlayerName, AgentName, WeaponName, TeamSide) AS (VALUES
('2026-07-18','jisutzu','Jett','Vandal','Attackers'),
('2026-07-18','DESTROYBOT554','Sova','Phantom','Attackers'),
('2026-07-18','provrb','Sage','Vandal','Attackers'),
('2026-07-18','frawg','Omen','Phantom','Attackers'),
('2026-07-18','United','Killjoy','Vandal','Attackers'),
('2026-07-18','DukeBabyKai','Raze','Vandal','Defenders'),
('2026-07-18','D1 Munch','Cypher','Phantom','Defenders'),
('2026-07-18','baby pluto','Viper','Phantom','Defenders'),
('2026-07-18','MunchSupremacy','Breach','Vandal','Defenders'),
('2026-07-18','Osiris','Phoenix','Vandal','Defenders'),
('2026-07-23','Redkiller880','Jett','Vandal','Attackers'),
('2026-07-23','LordFrog','Sova','Phantom','Attackers'),
('2026-07-23','LavaThief','Sage','Phantom','Attackers'),
('2026-07-23','Bongo','Omen','Vandal','Attackers'),
('2026-07-23','Ccoletoodirt','Killjoy','Phantom','Attackers'),
('2026-07-23','OptimalZ','Raze','Vandal','Defenders'),
('2026-07-23','kizar2mello','Cypher','Phantom','Defenders'),
('2026-07-23','Draquino','Viper','Vandal','Defenders'),
('2026-07-23','Delta','Breach','Phantom','Defenders'),
('2026-07-23','SnazzyPot','Phoenix','Vandal','Defenders'),
('2026-07-29','Tray','Jett','Vandal','Attackers'),
('2026-07-29','predator','Sova','Phantom','Attackers'),
('2026-07-29','Bnetplayer','Sage','Operator','Attackers'),
('2026-07-29','heyyitskiwi','Omen','Phantom','Attackers'),
('2026-07-29','jisutzu','Killjoy','Vandal','Attackers'),
('2026-07-29','provrb','Raze','Vandal','Defenders'),
('2026-07-29','United','Cypher','Phantom','Defenders'),
('2026-07-29','Osiris','Viper','Phantom','Defenders'),
('2026-07-29','Redkiller880','Breach','Vandal','Defenders'),
('2026-07-29','Draquino','Phoenix','Vandal','Defenders')
)
INSERT INTO MatchPlayer (MatchID, PlayerID, AgentID, WeaponID, TeamSide)
SELECT m.MatchID, p.PlayerID, a.AgentID, w.WeaponID, roster.TeamSide
FROM roster
JOIN Match m ON m.MatchDate = roster.MatchDate
JOIN Player p ON p.PlayerName = roster.PlayerName
JOIN Agent a ON a.AgentName = roster.AgentName
JOIN Weapon w ON w.WeaponName = roster.WeaponName;

WITH statline(MatchDate, PlayerName, Kills, Deaths, Assists, Score) AS (VALUES
('2026-07-18','jisutzu',24,15,6,7250), ('2026-07-18','DESTROYBOT554',18,14,12,6420),
('2026-07-18','provrb',15,13,10,5710), ('2026-07-18','frawg',17,16,9,5890),
('2026-07-18','United',14,12,8,5480), ('2026-07-18','DukeBabyKai',22,18,5,6740),
('2026-07-18','D1 Munch',16,17,7,5520), ('2026-07-18','baby pluto',13,16,11,5210),
('2026-07-18','MunchSupremacy',12,18,14,5080), ('2026-07-18','Osiris',19,19,4,5980),
('2026-07-23','Redkiller880',20,18,5,6380), ('2026-07-23','LordFrog',16,17,11,5790),
('2026-07-23','LavaThief',13,16,12,5240), ('2026-07-23','Bongo',15,19,8,5370),
('2026-07-23','Ccoletoodirt',11,17,7,4690), ('2026-07-23','OptimalZ',26,14,6,7610),
('2026-07-23','kizar2mello',19,13,9,6490), ('2026-07-23','Draquino',18,15,10,6250),
('2026-07-23','Delta',14,16,15,5660), ('2026-07-23','SnazzyPot',17,15,5,5840),
('2026-07-29','Tray',28,12,4,8050), ('2026-07-29','predator',19,14,13,6680),
('2026-07-29','Bnetplayer',17,11,8,6210), ('2026-07-29','heyyitskiwi',14,15,10,5480),
('2026-07-29','jisutzu',16,13,7,5770), ('2026-07-29','provrb',21,17,6,6610),
('2026-07-29','United',18,16,9,6140), ('2026-07-29','Osiris',15,18,12,5630),
('2026-07-29','Redkiller880',13,19,14,5410), ('2026-07-29','Draquino',16,18,5,5520)
)
INSERT INTO MatchStats (MatchPlayerID, Kills, Deaths, Assists, Score)
SELECT mp.MatchPlayerID, s.Kills, s.Deaths, s.Assists, s.Score
FROM statline s
JOIN Match m ON m.MatchDate = s.MatchDate
JOIN Player p ON p.PlayerName = s.PlayerName
JOIN MatchPlayer mp ON mp.MatchID = m.MatchID AND mp.PlayerID = p.PlayerID;

WITH agent_ability(AgentName, AbilityName) AS (VALUES
('Jett','Cloudburst'), ('Jett','Updraft'), ('Jett','Tailwind'), ('Jett','Blade Storm'),
('Sova','Shock Bolt'), ('Sova','Recon Bolt'), ('Sova','Owl Drone'), ('Sova','Hunter''s Fury'),
('Sage','Barrier Orb'), ('Sage','Slow Orb'), ('Sage','Healing Orb'), ('Sage','Resurrection'),
('Omen','Shrouded Step'), ('Omen','Paranoia'), ('Omen','Dark Cover'), ('Omen','From the Shadows'),
('Phoenix','Blaze'), ('Phoenix','Curveball'), ('Phoenix','Hot Hands'), ('Phoenix','Run It Back'),
('Killjoy','Nanoswarm'), ('Killjoy','Alarmbot'), ('Killjoy','Turret'), ('Killjoy','Lockdown'),
('Raze','Boom Bot'), ('Raze','Blast Pack'), ('Raze','Paint Shells'), ('Raze','Showstopper'),
('Cypher','Trapwire'), ('Cypher','Cyber Cage'), ('Cypher','Spycam'), ('Cypher','Neural Theft'),
('Viper','Snake Bite'), ('Viper','Poison Cloud'), ('Viper','Toxic Screen'), ('Viper','Viper''s Pit'),
('Breach','Aftershock'), ('Breach','Flashpoint'), ('Breach','Fault Line'), ('Breach','Rolling Thunder')
)
INSERT INTO PlayerAbilityLoadout (MatchPlayerID, AbilityID, WeaponID)
SELECT mp.MatchPlayerID, ab.AbilityID, mp.WeaponID
FROM MatchPlayer mp
JOIN Agent a ON a.AgentID = mp.AgentID
JOIN agent_ability aa ON aa.AgentName = a.AgentName
JOIN Ability ab ON ab.AbilityName = aa.AbilityName;

COMMIT;
