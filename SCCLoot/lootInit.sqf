// If there is no module list, create one
if (isNil "sccModules") then {
	
	sccModules = [];
	
};

// Add module to the list of active modules
sccModules pushBackUnique "loot";

// Array of all the buildings containing loot
// Format is object, array of loot spots
scclootCurrentBuildingsWithLoot = [];
scclootCurrentContainersWithLoot = [];
scclootStaticSpots = [];
scclootStaticContainers = [];

// Enable/disable spawn/cleanup scripts
scclootEnableSpawn = true;
scclootEnableCleanup = true;

// Flags set when spawn/cleanup runs
scclootSpawnerActive = true;
scclootCleanupActive = false;

// Useful variables
scclootWorldCentre = [worldSize / 2, worldSize / 2];

// Compile config
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Config\lootConfig.sqf";
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Config\lootTables.sqf";
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Config\lootBuildings.sqf";

// Compile functions
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Functions\scc_fnc_findValidBuildings.sqf";
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Functions\scc_fnc_findValidContainers.sqf";
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Functions\scc_fnc_getBuildingPositions.sqf";
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Functions\scc_fnc_getLootType.sqf";
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Functions\scc_fnc_getLootTable.sqf";
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Functions\scc_fnc_spawnItem.sqf";
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Functions\scc_fnc_resetLoot.sqf";

// Get loot spawn type from config
switch (scclootSpawnType) do {
	
	// Classic, dynamic loot spawning
	case 1: {
		
		// Start loot spawner
		_lootSpawnScript = [] execVM "SCCLoot\System\lootSpawn.sqf";
		// Start loot cleanup
		_lootSpawnCleanup = [] execVM "SCCLoot\System\lootCleanup.sqf";
		
	};
	
	// Static, battle royale-style loot spawning, can be reset with scc_fnc_resetLoot
	case 2: {
		
		[] call scc_fnc_resetLoot;
		
	};
	
	default {
		
		// Start loot spawner
		_lootSpawnScript = [] execVM "SCCLoot\System\lootSpawn.sqf";
		// Start loot cleanup
		_lootSpawnCleanup = [] execVM "SCCLoot\System\lootCleanup.sqf";
		
	};
	
};