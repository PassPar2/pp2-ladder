# pp2-ladder
This is an adaptation of https://github.com/aymannajim/esx_ladders for qb-core

This script add a ladder item for players to use.

Only 1 ladder can be storred in inventory

You can make the ladder visible by changing config : 
```
Config.EnableAttach = true
```

# Dependencies:
- qb-core - https://github.com/qbcore-framework/qb-core
- qb-target - https://github.com/qbcore-framework/qb-target
- qb-menu - https://github.com/qbcore-framework/qb-menu


# Installation:
Add to qb-core/shared/item.lua

```
	-- ladder
	['ladder'] 			 		 = {['name'] = 'ladder', 			  	['label'] = 'Ladder', 			['weight'] = 5000, 		['type'] = 'item', 		['image'] = 'ladder.png', 	['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A wooden ladder'},
```

Add `ladder.png` to your inventory images folder

# preview
Coming soon

# Ladder stream
The stream folder is optional, the one used here is from https://github.com/aymannajim/esx_ladders
