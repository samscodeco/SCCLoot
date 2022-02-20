// scc_fnc_getLootTable
//
// Parameters: Loot type (int)
// Returns: Array of loot in format [Object, Spawn Chance]

scc_fnc_getLootTable = {
	
	_lootType = _this select 0;
	
	// Return the correct loot table
	_lootArray = [];
	
	switch (_lootType) do {
		
		case 1: {
			_lootArray = scclootCivil;
		};
		
		case 2: {
			_lootArray = scclootIndustrial;
		};
		
		case 3: {
			_lootArray = scclootMilitary;
		};
		
		case 4: {
			_lootArray = scclootMedical;
		};
		
		case 5: {
			_lootArray = scclootSupermarket;
		};
		
		default {
			_lootArray = scclootDefault;
		};
		
	};
	
	_lootArray;
	
};