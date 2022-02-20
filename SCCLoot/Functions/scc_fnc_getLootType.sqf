scc_fnc_getLootType = {

	_building = _this select 0;
	_lootType = 0;
	
	// Get building loot type
	{

		_currentEntryType = _x select 0;
		_currentEntryLoot = _x select 1;
		
		if (_currentEntryType == typeOf _building) then {
			
			_lootType = _currentEntryLoot;
			
		};
		
	} forEach scclootListBuildings;
	
	_lootType;
	
};