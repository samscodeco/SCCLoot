// If there is no module list, create one
if (isNil "sccModules") then {
	
	sccModules = [];
	
};

// Load loot system config
_compileScripts = [] execVM "SCCLoot\lootCompile.sqf";
waitUntil {scriptDone _compileScripts};

// Get buildings with custom positions
scclootCustomPosClassnames = [];

{
	
	scclootCustomPosClassnames pushBack (toLowerANSI (_x select 0));
	
} forEach scclootCustomPosBuildings;

// Init loot system
[] execVM "SCCLoot\System\lootHandler.sqf";

// Add module to the list of active modules
sccModules pushBackUnique "loot";