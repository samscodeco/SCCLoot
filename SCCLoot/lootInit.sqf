// If there is no module list, create one
if (isNil "sccModules") then {
	
	sccModules = [];
	
};

// Compile all config files
// Loot config
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Config\lootConfig.sqf";
// Loot tables
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Config\lootTables.sqf";
// Building config
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Config\lootBuildings.sqf";
// Pre-defined container config
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Config\lootContainers.sqf";
// Functions
[] call compileFinal preprocessFileLineNumbers "SCCLoot\Functions\lootFunctions.sqf";

// Array of all the buildings/containers containing loot
// Format is object, array of loot spots
scclootCurrentBuildingsWithLoot = [];
scclootCurrentContainersWithLoot = [];

scclootEnableSpawn = true;
scclootEnableCleanup = true;

scclootSpawnerActive = false;
scclootCleanupActive = false;

// Get buildings with custom positions
scclootCustomPosClassnames = [];

{
	
	scclootCustomPosClassnames pushBack (toLowerANSI (_x select 0));
	
} forEach scclootCustomPosBuildings;

// Init loot system
scclootSpawnScriptHandle = [] execVM "SCCLoot\System\lootSpawn.sqf";
scclootCleanupScriptHandle = [] execVM "SCCLoot\System\lootCleanup.sqf";

// Add module to the list of active modules
sccModules pushBackUnique "loot";