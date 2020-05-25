// Functions for modders/mission makers
// These functions are designed to ease the process of adding custom structures/building positions to SCCLoot.
// For more information, see the README in the script directory.

scc_fnc_highlightBuldingPositions = {
	
	// Creates an arrow highlighting every position in surrounding buildings and structures
	// Paramteters: Distance (Number) - Distance from the player to search for buildings
	// Returns: Array of buildings without positions
	
	// Get distance to search parameter
	_searchDist = _this select 0;
	
	// Create array for buildings without positions
	_buildingsWithNoPositions = [];
	
	// Iterate through nearby buildings
	{
		_buildingPositions = [_x] call BIS_fnc_buildingPositions;
		
		// If building has positions
		if (count _buildingPositions > 0) then {
		
			{
				
				// Create an arrow highlighting each building position
				_arrowObj = "Sign_Arrow_F" createVehicle _x;
				_arrowObj setVehiclePosition [_x, [], 0, "CAN_COLLIDE"];
				
			} forEach _buildingPositions;
			
		} else {
			
			// If no positions, add to no positions array
			_buildingsWithNoPositions pushBack (typeOf _x);
			
		};
		
	} forEach (nearestObjects [player, ["building"], _searchDist]);
	
	// Return array of buildings with no positions
	str _buildingsWithNoPositions;
	
};

scc_fnc_getBuildingPositions = {
	
	// Gets positions of custom position markers
	// Parameters: 	
	// Marker (Object) - Class of the marker objects
	// Structure (Object) - Structure to apply the custom positions to
	// Returns: Array of positions
	
	// Get parameters
	_markerClass = _this select 0
	_buildingObject = _this select 1;
	
	// Create array of positions
	_posArray = [];
	
	// Iterate through nearest objects
	{
		
		// If the object is a marker, add relative position to the array
		if (typeOf _x == _markerClass) then {
			
			_posArray pushBack (_buildingObject worldToModel (getPos _x));
			
		};
		
	} forEach (nearestObjects [player, [], 500]);
	
	// Return list of custom building positions
	str _posArray;
	
};

scc_fnc_generateBuildingEntries = {
	
	// Finds building objects around the player and formats their classnames and loot type to be used in the config file
	// Parameters: 
	// Loot Type (Number) - Type of loot to spawn in the buildings
	// Distance (Number) - Distance from player to search for buildings
	// Returns: Array in the format [[buildingClass,lootType],[buildingClass,lootType]...];
	
	// Get loot type
	_lootType = str (_this select 0);
	_distParam = _this select 1;
	
	// Get nearest buildings to player
	_nearbyBuildingClasses = [];
	
	// Iterate through nearby buildings and add them to the list
	{
		
		_nearbyBuildingClasses pushBackUnique (typeOf _x);
		
	} forEach _nearbyBuildings = nearestObjects [player, ["building"], _distParam];
	
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