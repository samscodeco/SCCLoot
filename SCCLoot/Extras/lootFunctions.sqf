// scc_fnc_highlightBuldingPositions
// Sticks an arrow on every pre-defined building position around the player
// Paramteters: None
scc_fnc_highlightBuldingPositions = {

	_noPositions = [];

	{
		_buildingPositions = [_x] call BIS_fnc_buildingPositions;
		
		if (count _buildingPositions > 0) then {
		
			{
				
				_arrowObj = "Sign_Arrow_F" createVehicle _x;
				
				_arrowObj setVehiclePosition [_x, [], 0, "CAN_COLLIDE"];
				
			} forEach _buildingPositions;
			
		} else {
			
			_noPositions pushBack (typeOf _x);
			
		};
		
	} forEach (nearestObjects [player, ["building"], 1000]);

	str _noPositions;
	
};

// scc_fnc_getBuildingPositions
// Gets relative positions of custom position markers
// Parameters: None
scc_fnc_getBuildingPositions = {

	_buildingObject = cursorObject;
	_posArray = [];

	{
		
		if (typeOf _x == "Sign_Arrow_F") then {
			
			_posArray pushBack (_buildingObject worldToModel (getPos _x));
			
		};
		
	} forEach (nearestObjects [player, ["Building"], 200]);

	_posArray;
	
};

// scc_fnc_generateBuildingEntries
// Grabs building objects around the player and formats their classnames to be used in the config file
// Parameters: Loot Type (int)
scc_fnc_generateBuildingEntries = {

	_lootType = str (_this select 0);
	
	_nearbyBuildings = nearestObjects [player, ["building"], 500];
	_nearbyBuildingClasses = [];
	
	{
		
		_nearbyBuildingClasses pushBack (typeOf _x);
		
	} forEach _nearbyBuildings;
	
	_configEntries = [];
	
	{
		
		_entry = (format ["[%3%1%3, %2],", _x, _lootType, """"]);
		_configEntries pushBack _entry;
		
	} forEach _nearbyBuildingClasses;
	
	_outputEntries = "";
	
	{
		
		_outputEntries = _outputEntries + _x;
		
	} forEach _configEntries;
	
	_outputEntries;
	
};