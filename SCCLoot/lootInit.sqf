// Load loot system config
[] call compile preprocessFileLineNumbers "SCCLoot\Config\lootConfig.sqf";

// Load loot tables
[] call compile preprocessFileLineNumbers "SCCLoot\Config\lootTables.sqf";

// Load building config
[] call compile preprocessFileLineNumbers "SCCLoot\Config\lootBuildings.sqf";

// Load buildings with custom positions
[] call compile preprocessFileLineNumbers "SCCLoot\Config\lootAddedBuildings.sqf";

// Load pre-defined containers
[] call compile preprocessFileLineNumbers "SCCLoot\Config\lootContainers.sqf";

// Get buildings with custom positions
scclootCustomPosClassnames = [];

{
	
	scclootCustomPosClassnames pushBack (toLowerANSI (_x select 0));
	
} forEach scclootCustomPosBuildings;

// Init loot system
[] execVM "SCCLoot\System\lootHandler.sqf";