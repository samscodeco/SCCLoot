// All scripts that are compiled at runtime
// Loot config
[] call compile preprocessFileLineNumbers "SCCLoot\Config\lootConfig.sqf";

// Loot tables
[] call compile preprocessFileLineNumbers "SCCLoot\Config\lootTables.sqf";

// Building config
[] call compile preprocessFileLineNumbers "SCCLoot\Config\lootBuildings.sqf";

// Custom positions config
[] call compile preprocessFileLineNumbers "SCCLoot\Config\lootAddedBuildings.sqf";

// Pre-defined container config
[] call compile preprocessFileLineNumbers "SCCLoot\Config\lootContainers.sqf";

// Functions
[] call compile preprocessFileLineNumbers "SCCLoot\Functions\lootFunctions.sqf";