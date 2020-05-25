// Load loot system config
[] call compile "SCCLoot\lootCompile.sqf";

// Get buildings with custom positions
scclootCustomPosClassnames = [];

{
	
	scclootCustomPosClassnames pushBack (toLowerANSI (_x select 0));
	
} forEach scclootCustomPosBuildings;

// Init loot system
[] execVM "SCCLoot\System\lootHandler.sqf";