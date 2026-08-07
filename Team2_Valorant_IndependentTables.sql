DROP TABLE IF EXISTS Region;
DROP TABLE IF EXISTS Rank;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS Ability;
DROP TABLE IF EXISTS Weapon;
DROP TABLE IF EXISTS Gamemode;
DROP TABLE IF EXISTS Map;

-- Would be used in Player table
CREATE TABLE Region (
	RegionID INTEGER PRIMARY KEY AUTOINCREMENT,
	RegionName VARCHAR(50) NOT NULL UNIQUE
);

-- Would be used in Player table and potentialyl MatchPlayer table
CREATE TABLE Rank (
	RankID INTEGER PRIMARY KEY AUTOINCREMENT,
	RankName VARCHAR(50) NOT NULL UNIQUE
);

-- Would be used in Agent table
CREATE TABLE Role (
	RoleID INTEGER PRIMARY KEY AUTOINCREMENT,
	RoleName VARCHAR(50) NOT NULL UNIQUE
);

-- Would be used in Agent table and PlayerAbilityLoadout table
CREATE TABLE Ability (
	AbilityID INTEGER PRIMARY KEY AUTOINCREMENT,
	AbilityName VARCHAR(50) NOT NULL UNIQUE
);

-- Would be used in MatchPlayer table and PlayerAbilityLoadout table
CREATE TABLE Weapon (
	WeaponID INTEGER PRIMARY KEY AUTOINCREMENT,
	WeaponName VARCHAR(50) NOT NULL UNIQUE,
	WeaponType VARCHAR(50)
);

-- Would be used in Match table
CREATE TABLE Gamemode (
	GamemodeID INTEGER PRIMARY KEY AUTOINCREMENT,
	GamemodeName VARCHAR(50) NOT NULL UNIQUE
);

-- Would be used in Match table
CREATE TABLE Map (
	MapID INTEGER PRIMARY KEY AUTOINCREMENT,
	MapName VARCHAR(50) NOT NULL UNIQUE
);
