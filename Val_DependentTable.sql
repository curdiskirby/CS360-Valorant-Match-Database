-- Player Table
-- Stores information about each Valorant player.
-- Each player belongs to one Region and one Rank.

CREATE TABLE Player (
    PlayerID INTEGER PRIMARY KEY AUTOINCREMENT,
    PlayerName VARCHAR(50) NOT NULL,
    RegionID INTEGER NOT NULL,
    RankID INTEGER NOT NULL,

    FOREIGN KEY (RegionID) REFERENCES Region(RegionID),
    FOREIGN KEY (RankID) REFERENCES Rank(RankID)
);


-- Agent Table
-- Stores every playable Valorant agent.
-- Each agent is assigned one Role.

CREATE TABLE Agent (
    AgentID INTEGER PRIMARY KEY AUTOINCREMENT,
    AgentName VARCHAR(50) NOT NULL UNIQUE,
    RoleID INTEGER NOT NULL,

    FOREIGN KEY (RoleID) REFERENCES Role(RoleID)
);


-- Match Table
-- Stores information about each Valorant match.
-- Includes the date, game mode, map, and winning team.

CREATE TABLE Match (
    MatchID INTEGER PRIMARY KEY AUTOINCREMENT,
    MatchDate DATE NOT NULL,
    GamemodeID INTEGER NOT NULL,
    MapID INTEGER NOT NULL,
    WinningTeam VARCHAR(20),

    FOREIGN KEY (GamemodeID) REFERENCES Gamemode(GamemodeID),
    FOREIGN KEY (MapID) REFERENCES Map(MapID)
);


-- MatchPlayer Table
-- Connects players to matches.
-- Records the player's agent, weapon, and team side.
-- Ensures each player appears only once per match.

CREATE TABLE MatchPlayer (
    MatchPlayerID INTEGER PRIMARY KEY AUTOINCREMENT,
    MatchID INTEGER NOT NULL,
    PlayerID INTEGER NOT NULL,
    AgentID INTEGER NOT NULL,
    WeaponID INTEGER,
    TeamSide VARCHAR(20) NOT NULL,

    FOREIGN KEY (MatchID) REFERENCES Match(MatchID),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID),
    FOREIGN KEY (WeaponID) REFERENCES Weapon(WeaponID),

    UNIQUE (MatchID, PlayerID)
);


-- MatchStats Table
-- Stores player performance statistics for each match.
-- Includes kills, deaths, assists, and score.

CREATE TABLE MatchStats (
    MatchStatsID INTEGER PRIMARY KEY AUTOINCREMENT,
    MatchPlayerID INTEGER NOT NULL UNIQUE,
    Kills INTEGER NOT NULL DEFAULT 0,
    Deaths INTEGER NOT NULL DEFAULT 0,
    Assists INTEGER NOT NULL DEFAULT 0,
    Score INTEGER NOT NULL DEFAULT 0,

    FOREIGN KEY (MatchPlayerID)
        REFERENCES MatchPlayer(MatchPlayerID)
);


-- PlayerAbilityLoadout Table
-- Stores the abilities and weapon used by a player in a match.
-- Prevents duplicate abilities for the same player.

CREATE TABLE PlayerAbilityLoadout (
    PlayerAbilityLoadoutID INTEGER PRIMARY KEY AUTOINCREMENT,
    MatchPlayerID INTEGER NOT NULL,
    AbilityID INTEGER NOT NULL,
    WeaponID INTEGER,

    FOREIGN KEY (MatchPlayerID)
        REFERENCES MatchPlayer(MatchPlayerID),  

    FOREIGN KEY (AbilityID)
        REFERENCES Ability(AbilityID),

    FOREIGN KEY (WeaponID)
        REFERENCES Weapon(WeaponID),

    UNIQUE (MatchPlayerID, AbilityID)
);
