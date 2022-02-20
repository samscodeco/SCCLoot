// scc_fnc_highlightBuldingPositions
//
// Paramteters: Distance (Number) - Distance from the player to search for buildings
// Returns: Array of buildings without positions
//
// Creates an arrow highlighting every position in surrounding buildings and structures

scc_fnc_highlightBuldingPositions = {
	
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