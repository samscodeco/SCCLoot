// Loot Settings

scclootSpawnWaitTime = 15;		// How often loot is spawned in seconds
scclootCleanupWaitTime = 15;	// How often loot is cleaned up in seconds
scclootSpawnRange = 100;		// How close the player must be to a building to spawn loot
scclootCleanupRange = 250;		// How far the player must be from a building before loot is cleaned up
scclootDebug = true;			// Enables debug mode

scclootMinMagazinesToSpawn = 0;	// Minimum number of magazines that will spawn with each weapon
scclootMaxMagazinesToSpawn = 4;	// Maximum number of magazines that will spawn with each weapon

scclootMinContainerLoot = 1;	// Minimum number of items that will spawn in a loot container
scclootMaxContainerLoot = 3;	// Maxinum number of items that will spawn in a loot container

// Loot spawn type
// 1 = Dynamic - Loot is spawned in buildings around players and cleaned up when they move far enough away. Default mode, intended for survival missions.
// 2 = Static - Loot is spawned in all buildings at the beginning of the mission and can only be cleaned up/respawned through code. Intended for "battle royale" style scenarios.
scclootSpawnType = 1;