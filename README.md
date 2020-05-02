# SCCLoot
by samscodeco <sam@samscode.co>

This script adds simple, configurable loot spawning to any Arma 3 mission.

Got feedback/suggestions, or using this script in your mission? Get in touch!

## Installation

1. Place the 'SCCLoot' folder inside the root mission directory.
2. Add the following line to your mission's init.sqf: 

```
[] execVM "SCCLoot\lootInit.sqf";
```

## Configuration

There are four config files in the 'Config' directory: 'lootConfig', 'lootBuildings', 'lootTables' and 'lootAddedBuildings'. Editing any other
files other than these three may result in unintended behaviour.

## More Information

For a more detailed description and help, see the README.txt file inside the SCCLoot directory.

## Known Issues
- Items may clip into the floor in some buildings.

## License

This script released under the BSD License. You are free to modify or distribute it, provided that the original copyright notice is retained.
For more information, see the license file in the source directory.