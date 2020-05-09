// Array of all the buildings containing loot
// Format is object, array of loot spots
scclootCurrentBuildingsWithLoot = [];
scclootCurrentContainersWithLoot = [];

while {true} do {
	
	if (scclootDebugMessages) then {
	
		systemChat "[SCCLoot] Running loot spawner...";
	
	};
	
	_lootSpawnScript = [] execVM "SCCLoot\System\lootSpawn.sqf";
	_lootSpawnCleanup = [] execVM "SCCLoot\System\lootCleanup.sqf";
	sleep 10;
	
};
