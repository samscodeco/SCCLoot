// scc_fnc_generateBuildingEntries
//
// Parameters: 
// Loot Type (Number) - Type of loot to spawn in the buildings
// Distance (Number) - Distance from player to search for buildings
//
// Returns: 
// Array in the format [[buildingClass,lootType],[buildingClass,lootType]...];
//
// Finds building objects around the player and formats their classnames and loot type to be used in the config file

scc_fnc_generateBuildingEntries = {
	
	// Get loot type
	_lootType = str (_this select 0);
	_distParam = _this select 1;
	
	// Get nearest buildings to player
	_nearbyBuildingClasses = [];
	
	// Iterate through nearby buildings and add them to the list
	{
		
		_nearbyBuildingClasses pushBackUnique (typeOf _x);
		
	} forEach nearestObjects [player, ["building"], _distParam];
	
	// Create array for final config entries
	_configEntries = [];
	
	// Create an entry for each building class
	{
		
		_entry = (format ["[%3%1%3, %2],", _x, _lootType, """"]);
		_configEntries pushBackUnique _entry;
		
	} forEach _nearbyBuildingClasses;
	
	// Return config entries
	str _configEntries;
	
};