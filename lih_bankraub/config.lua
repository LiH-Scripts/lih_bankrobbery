
Config = {
	Debug = true, -- allows you to restart script while in-game, otherwise u need to restart fivem.
	PoliceJobs = {'police', 'gouvernement', 'fib', 'sheriff'}, -- Jobs that can't do bankrobberies etc, but can secure the banks.
	CashInDirty = true, -- safe rewards in dirty (black_money) or normal cash?
	AllCooldown = 360, --Globaler Cooldown solange eine Bank gemacht wird bis der Tresor schließt in Sekunden
	AllCooldownAfter = 220, --Globaler Cooldown nachdem eine Bank gemacht wird in Sekunden
	Cooldown = 1800, --Colldown für einzelne Banken in Sekunden 1800 = 30 Minuten
	ProgressWait = 20000, --Wartezeit mit Geldanimation in Milisekunden
}

Config.Banks = {
	[1] = {
		id = 1,
		name = 'Nationalbank',
		blip = {enable = false, name = "Bank | Pacific Standard Public Deposit", pos = vector3(231.67,214.91,106.28), display = 4, sprite = 431, color = 5, scale = 0.7},
		police = 1,
		inUse = false, -- do not touch!

		keypads = {
			['start'] = {pos = vector3(258.70, 223.05, 106.28), text = {[1] = 'Keypad hacken', } , hacked = false},
			['vault'] = {pos = vector3(254.28, 225.77, 101.87), text = {[1] = 'Tresor hacken', }, hacked = false},
			
		},

		doors = {
			['terminal'] = {pos = vector3(261.63, 222.82, 106.28), model =  409280169, heading = 340.000, setHeading = 340.0, freeze = true}, -- cell door to enter stairs leading down to main vault
			['vault'] = {pos = vector3(253.18, 228.25, 101.67), model = 961976194, heading = 70.000, setHeading = 70.0, count = 270, freeze = true}, -- vault main doo
			['cell'] = {pos = vector3(252.51, 221.40, 101.68), model = 409280169, heading = 340.40, setHeading = 340.40, freeze = true, action = 'thermite', offset = vector3(-1.19,0.0,-0.02)}, -- 1st celldoor after main vault
			['cell2'] = {pos = vector3(261.01, 215.39, 101.68), model = 409280169, heading = 160.0, setHeading = 340.0, freeze = true, action = 'thermite', offset = vector3(-1.19,-0.0,-0.02)}, -- 2nd celldoor to access the other safes
		},

		safes = {
			[1] = {
				
				pos = vector3(249.399,237.722,97.11), anim = vector4(249.36,237.722,97.11,62.67), robbed = false, failed = false,
				requireDoor = 'cell',
				items = {
					{name = 'diamondring', amount = {min = 1, max = 2}, chance = 10},
					{name = 'crowexgold1', amount = {min = 1, max = 5}, chance = 20},
					{name = 'crowexgold2', amount = {min = 1, max = 5}, chance = 40},
					{name = 'gold', amount = {min = 1, max = 20}, chance = 60},
					{name = 'goldkette', amount = {min = 1, max = 10}, chance = 80},
					{name = 'goldcoin', amount = {min = 1, max = 20}, chance = 100},
				},
				cash = {enable = true, min = 80000, max = 200000},
				propanim = {''}
			},
			[2] = {
				pos = vector3(252.2923,239.9158,97.117), anim = vector4(252.2923,239.9158,97.117,333.99), robbed = false, failed = false,
				requireDoor = 'cell',
				items = {
					{name = 'diamondring', amount = {min = 1, max = 2}, chance = 10},
					{name = 'crowexgold1', amount = {min = 1, max = 5}, chance = 20},
					{name = 'crowexgold2', amount = {min = 1, max = 5}, chance = 40},
					{name = 'gold', amount = {min = 1, max = 20}, chance = 60},
					{name = 'goldkette', amount = {min = 1, max = 10}, chance = 80},
					{name = 'goldcoin', amount = {min = 1, max = 20}, chance = 100},
				},
				cash = {enable = true, min = 80000, max = 200000},
				propanim = {''}
			},
			[3] = {
				pos = vector3(258.95, 214.84, 101.68), anim = vector4(258.95, 214.84, 101.68, 336.85), robbed = false, failed = false,
				requireDoor = 'cell',
				items = {
					{name = 'diamondring', amount = {min = 1, max = 2}, chance = 10},
					{name = 'crowexgold1', amount = {min = 1, max = 5}, chance = 20},
					{name = 'crowexgold2', amount = {min = 1, max = 5}, chance = 40},
					{name = 'gold', amount = {min = 1, max = 20}, chance = 60},
					{name = 'goldkette', amount = {min = 1, max = 10}, chance = 80},
					{name = 'goldcoin', amount = {min = 1, max = 20}, chance = 100},
				},
				cash = {enable = true, min = 8000, max = 20000},
				propanim = {''}
			},
		},

		
		
		pettyCash = {
		[1] = {
				
				pos = vector3(2250.02, 219.28, 101.68), robbed = false, failed = false,
				requireDoor = 'vault',
				items = {
					{name = 'gold', amount = {min = 15, max = 30}, chance = 100},
				},
				cash = {enable = true, min = 8000, max = 20000},
				propanim = {'gold'}
			},
		[2] = {
				
				pos = vector3(255.54, 218.67, 101.68), robbed = false, failed = false,
				requireDoor = 'vault',
				items = {},
				cash = {enable = true, min = 8000, max = 20000},
				propanim = {'money'}
			},
		[3] = {
				
				pos = vector3(254.78, 216.20, 101.68), robbed = false, failed = false,
				requireDoor = 'vault',
				items = {},
				cash = {enable = true, min = 8000, max = 20000},
				propanim = {'money'}
			},		
		
		
		
		
					
		},

		reqItems = { -- required items for pacific & settings:
			['hacking_laptop'] = { -- do not touch ID's
				{name = 'laptop_h', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['id_card_f'] = { -- do not touch ID's
				{name = 'id_card_f', amount = 1, remove = true, chance = 95}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['thermite'] = { -- do not touch ID's
				{name = 'thermal_charge', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			
			['drilling'] = { -- do not touch ID's
				{name = 'drill', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
		},
	},
	[2] = {
		id = 2,
		name = 'Blaine County',
		blip = {enable = false, name = 'Bank | Blaine County Savings Bank', pos = vector3(-110.94,6462.53,31.64), display = 4, sprite = 431, color = 5, scale = 0.7},
		police = 6,
		inUse = false, -- do not touch!

		keypads = {
			['start'] = {pos = vector3(-105.9,6472.11,31.9), text = 'Keypad Terminal hacken', hacked = false},
			['vault'] = {pos = vector3(-105.51,6475.23,32.0), text = 'Tresor Terminal hacken', hacked = false},
		},

		doors = { -- heading on open: +110.0
			['terminal'] = {pos = vector3(-105.81,6475.62,31.63), model = 1309269072, heading = 314.58, setHeading = 314.58, freeze = true}, -- cell door to enter safes
			['vault'] = {pos = vector3(-104.6,6473.44,31.8), model = -1185205679, heading = 45.0, setHeading = 45.0, count = 270, freeze = true}, -- vault main door
			
		},

		safes = {
			[1] = {
				pos = vector3(-102.59,6475.23,31.62), anim = vector4(-103.16,6475.82,31.65,220.24), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[2] = {
				pos = vector3(-103.08,6478.67,31.62), anim = vector4(-103.67,6478.08,31.62,318.58), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[3] = {
				pos = vector3(-106.88,6478.35,31.62), anim = vector4(-106.21,6477.68,31.62,43.00), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[4] = {
				pos = vector3(-107.31,6473.15,31.62), anim = vector4(-106.80,6473.85,31.62,137.65), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[5] = {
				pos = vector3(-107.99,6475.83,31.62), anim = vector4(-107.32,6475.31,31.62,48.86), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
		},

		

		pettyCash = {
			[1] = {pos = vector3(-113.64,6471.93,31.63), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = vector3(-112.32,6470.57,31.63), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = vector3(-111.27,6469.51,31.63), robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},

		reqItems = { -- required items for pacific & settings:
			['hacking_laptop'] = { -- do not touch ID's
				{name = 'laptop_h', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['id_card_f'] = { -- do not touch ID's
				{name = 'id_card_f', amount = 1, remove = true, chance = 95}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['thermite'] = { -- do not touch ID's
				{name = 'thermal_charge', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			
			['drilling'] = { -- do not touch ID's
				{name = 'drill', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			}
			
		},

	},
	[3] = {
		id = 3,
		name = 'Fleeca Hauptplatz', -- name of the bank
		blip = {enable = false, name = 'Bank | Fleeca Bank [Legion Square]', pos = vector3(150.87,-1037.16,29.34), display = 4, sprite = 431, color = 5, scale = 0.7},
		police = 6, -- required cops
		inUse = false, -- do not touch!

		keypads = {
			['start'] = {pos = vector3(147.35,-1046.24,29.37), text = 'Keypad Terminal Hacken', hacked = false},
			['vault'] = {pos = vector3(148.52,-1046.57,29.60), text = 'Tresor Terminal Hacken', hacked = false},
		},

		doors = { -- heading on open: -100.0
			['terminal'] = {pos = vector3(150.29,-1047.63,29.67), model = -1591004109, heading = 159.85, setHeading = 159.85, freeze = true}, -- cell door to enter safes
			['vault'] = {pos = vector3(148.03,-1044.36,29.51), model = 2121050683, heading = 249.85, setHeading = 249.85, count = 250, freeze = true}, -- vault main door
			
		},

		safes = {
			[1] = {
				pos = vector3(146.48,-1048.44,29.34), anim = vector4(147.2295,-1048.66,29.34,68.84), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[2] = {
				pos = vector3(148.10,-1051.24,29.34), anim = vector4(148.39,-1050.35,29.34,155.65), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[3] = {
				pos = vector3(150.77,-1050.02,29.34), anim = vector4(150.18,-1049.77,29.34,249.98), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[4] = {
				pos = vector3(149.78,-1044.55,29.34), anim = vector4(149.68,-1045.26,29.34,342.73), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[5] = {
				pos = vector3(151.52,-1046.76,29.34), anim = vector4(150.79,-1046.51,29.34,247.81), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
		},
		
		pettyCash = {
			[1] = {pos = vector3(151.13,-1042.27,29.37), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = vector3(149.7,-1041.73,29.37), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = vector3(148.08,-1041.10,29.37), robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},

		

		reqItems = { -- required items for pacific & settings:
			['hacking_laptop'] = { -- do not touch ID's
				{name = 'laptop_h', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['id_card_f'] = { -- do not touch ID's
				{name = 'id_card_f', amount = 1, remove = true, chance = 95}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['thermite'] = { -- do not touch ID's
				{name = 'thermal_charge', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			
			['drilling'] = { -- do not touch ID's
				{name = 'drill', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			}
			
		},
	},
	[4] = {
		id = 4,
		name = 'Fleeca Alta', -- name of the bank
		blip = {enable = false, name = 'Bank | Fleeca Bank [Alta]', pos = vector3(315.32,-275.55,53.92), display = 4, sprite = 431, color = 5, scale = 0.7},
		police = 6, -- required cops
		inUse = false, -- do not touch!

		keypads = {
			['start'] = {pos = vector3(311.69,-284.55,54.16), text = 'Keypad Terminal Hacken', hacked = false},
			['vault'] = {pos = vector3(312.87,-284.99,54.39), text = 'Tresor Terminal Hacken', hacked = false},
		},

		doors = { -- heading on open: -100.0
			['terminal'] = {pos = vector3(314.62,-285.99,54.46), model = -1591004109, heading = 159.86, setHeading = 159.86, freeze = true}, -- cell door to enter safes
			['vault'] = {pos = vector3(312.36,-282.73,54.3), model = 2121050683, heading = 249.86, setHeading = 249.86, count = 250, freeze = true}, -- vault main door
			
		},

		safes = {
			[1] = {
				pos = vector3(310.70,-286.80,54.14), anim = vector4(311.61,-287.09,54.14,68.98), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[2] = {
				pos = vector3(312.50,-289.59,54.14), anim = vector4(312.75,-288.71,54.14,159.08), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[3] = {
				pos = vector3(315.26,-288.29,54.14), anim = vector4(314.47,-288.13,54.14,253.56), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[4] = {
				pos = vector3(314.25,-282.97,54.14), anim = vector4(313.95,-283.62,54.14,342.52), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[5] = {
				pos = vector3(315.86,-285.01,54.14), anim = vector4(315.11,-284.78,54.14,248.85), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
		},
		
		pettyCash = {
			[1] = {pos = vector3(315.42,-280.56,54.17), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = vector3(313.7,-279.89,54.17), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = vector3(312.08,-279.37,54.17), robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},

		

		reqItems = { -- required items for pacific & settings:
			['hacking_laptop'] = { -- do not touch ID's
				{name = 'laptop_h', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['id_card_f'] = { -- do not touch ID's
				{name = 'id_card_f', amount = 1, remove = true, chance = 95}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['thermite'] = { -- do not touch ID's
				{name = 'thermal_charge', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			
			['drilling'] = { -- do not touch ID's
				{name = 'drill', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			}
			
		},
	},
	[5] = {
		id = 5,
		name = 'Fleeca Burton', -- name of the bank
		blip = {enable = false, name = 'Bank | Fleeca Bank [Burton]', pos = vector3(-349.89,-46.44,49.04), display = 4, sprite = 431, color = 5, scale = 0.7},
		police = 6, -- required cops
		inUse = false, -- do not touch!

		keypads = {
			['start'] = {pos = vector3(-353.52,-55.47,49.20), text = 'Keypad Terminal Hacken', hacked = false},
			['vault'] = {pos = vector3(-352.22,-55.77,49.23), text = 'Tresor Terminal Hacken', hacked = false},
		},

		doors = { -- heading on open: -100.0
			['terminal'] = {pos = vector3(-350.41,-56.8,49.33), model = -1591004109, heading = 160.85, setHeading = 160.85, freeze = true}, -- cell door to enter safes
			['vault'] = {pos = vector3(-352.74,-53.57,49.18), model = 2121050683, heading = 250.85, setHeading = 250.85, count = 250, freeze = true}, -- vault main door
			
		},

		safes = {
			[1] = {
				pos = vector3(-354.30,-57.70,49.014), anim = vector4(-353.41,-57.87,49.01,68.58), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[2] = {
				pos = vector3(-352.51,-60.42,49.01), anim = vector4(-352.19,-59.51,49.01,159.24), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[3] = {
				pos = vector3(-349.62,-59.11,49.01), anim = vector4(-350.49,-58.94,49.01,254.33), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[4] = {
				pos = vector3(-350.79,-53.70,49.01), anim = vector4(-351.06,-54.45,49.01,344.00), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[5] = {
				pos = vector3(-349.29,-55.90,49.01), anim = vector4(-349.98,-55.67,49.01,247.43), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
		},
		
		pettyCash = {
			[1] = {pos = vector3(-349.61,-51.40,49.05), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = vector3(-351.3,-50.80,49.05), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = vector3(-353.09,-50.20,49.05), robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},

		

		reqItems = { -- required items for pacific & settings:
			['hacking_laptop'] = { -- do not touch ID's
				{name = 'laptop_h', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['id_card_f'] = { -- do not touch ID's
				{name = 'id_card_f', amount = 1, remove = true, chance = 95}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['thermite'] = { -- do not touch ID's
				{name = 'thermal_charge', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			
			['drilling'] = { -- do not touch ID's
				{name = 'drill', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			}
			
		},
	},
	[6] = {
		id = 6,
		name = 'Fleeca Rockford', -- name of the bank
		blip = {enable = false, name = 'Bank | Fleeca Bank [Rockford Hills]', pos = vector3(-1214.44,-327.5,37.67), display = 4, sprite = 431, color = 5, scale = 0.7},
		police = 6, -- required cops
		inUse = false, -- do not touch!

		keypads = {
			['start'] = {pos = vector3(-1210.49,-336.44,37.98), text = 'Keypad Terminal Hacken', hacked = false},
			['vault'] = {pos = vector3(-1209.30,-335.73, 37.97), text = 'Tresor Terminal Hacken', hacked = false},
		},

		doors = { -- heading on open: -100.0
			['terminal'] = {pos = vector3(-1207.33,-335.13,38.08), model = -1591004109, heading = 206.86, setHeading = 206.86, freeze = true}, -- cell door to enter safes
			['vault'] = {pos = vector3(-1211.26,-334.56,37.92), model = 2121050683, heading = 296.86, setHeading = 296.86, count = 250, freeze = true}, -- vault main door
			
		},

		safes = {
			[1] = {
				pos = vector3(-1209.45,-33.47,37.75), anim = vector4(-1208.60,-338.02,37.75,115.56), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[2] = {
				pos = vector3(-1206.10,-339.15,37.75), anim = vector4(-1206.62,-338.35,37.75,206.15), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[3] = {
				pos = vector3(-1205.04,-336.19,37.75), anim = vector4(-1205.82,-336.71,37.75,299.26), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[4] = {
				pos = vector3(-1209.89,-333.40,37.75), anim = vector4(-1209.52,-333.93,37.75,26.24), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[5] = {
				pos = vector3(-1207.25,-333.54,37.75), anim = vector4(-1207.78,-333.99,37.75,298.41), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
		},
		
		pettyCash = {
			[1] = {pos = vector3(-1210.58,-330.75,37.78), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = vector3(-1211.99,-331.45,37.78), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = vector3(-1213.63,-332.28,37.78), robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},

		

		reqItems = { -- required items for pacific & settings:
			['hacking_laptop'] = { -- do not touch ID's
				{name = 'laptop_h', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['id_card_f'] = { -- do not touch ID's
				{name = 'id_card_f', amount = 1, remove = true, chance = 95}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['thermite'] = { -- do not touch ID's
				{name = 'thermal_charge', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			
			['drilling'] = { -- do not touch ID's
				{name = 'drill', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			}
			
		},
	},
	[7] = {
		id = 7,
		name = 'Fleeca Ocean', -- name of the bank
		blip = {enable = false, name = 'Bank | Fleeca Bank [Great Ocean Highway]', pos = vector3(-2966.28,483.01,15.69), display = 4, sprite = 431, color = 5, scale = 0.7},
		police = 6, -- required cops
		inUse = false, -- do not touch!

		keypads = {
			['start'] = {pos = vector3(-2956.55,482.1,15.99), text = 'Keypad Terminal Hacken', hacked = false},
			['vault'] = {pos = vector3(-2956.44,483.35, 15.87), text = 'Tresor Terminal Hacken', hacked = false},
		},

		doors = { -- heading on open: -100.0
			['terminal'] = {pos = vector3(-2956.12,485.42,16.00), model = -1591004109, heading = 267.54, setHeading = 267.54, freeze = true}, -- cell door to enter safes
			['vault'] = {pos = vector3(-2958.54,482.27,15.84), model = -63539571, heading = 357.54, setHeading = 357.54, count = 250, freeze = true}, -- vault main door
			
		},

		safes = {
			[1] = {
				pos = vector3(-2954.138,481.9888,15.6753), anim = vector4(-2954.136,482.8257,15.67532,174.28), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[2] = {
				pos = vector3(-2952.124,484.4436,15.67539), anim = vector4(-2952.935,484.3697,15.67539,263.67), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[3] = {
				pos = vector3(-2954.121,486.7845,15.67542), anim = vector4(-2954.104,485.9754,15.6754,355.06), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[4] = {
				pos = vector3(-2958.85,484.0662,15.6753), anim = vector4(-2958.034,484.128,15.6753,89.17), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[5] = {
				pos = vector3(-2957.4,486.2582,15.67534), anim = vector4(-2957.432,485.405,15.67534,354.07), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
		},
		
		pettyCash = {
			[1] = {pos = vector3(-2961.43,484.62,15.73), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = vector3(-2961.52,482.99,15.73), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = vector3(-2961.59,481.25,15.73), robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},

		

		reqItems = { -- required items for pacific & settings:
			['hacking_laptop'] = { -- do not touch ID's
				{name = 'laptop_h', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['id_card_f'] = { -- do not touch ID's
				{name = 'id_card_f', amount = 1, remove = true, chance = 95}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['thermite'] = { -- do not touch ID's
				{name = 'thermal_charge', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			
			['drilling'] = { -- do not touch ID's
				{name = 'drill', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			}
			
		},
	},
	[8] = {
		id = 8,
		name = 'Fleeca Senora', -- name of the bank
		blip = {enable = false, name = 'Bank | Fleeca Bank [Grand Senora Desert]', pos = vector3(1175.13,2703.09,38.17), display = 4, sprite = 431, color = 5, scale = 0.7},
		police = 6, -- required cops
		inUse = false, -- do not touch!

		keypads = {
			['start'] = {pos = vector3(1175.64,2712.85,38.30), text = 'Keypad Terminal Hacken', hacked = false},
			['vault'] = {pos = vector3(1174.37,2712.85,38.26), text = 'Tresor Terminal Hacken', hacked = false},
		},

		doors = { -- heading on open: -100.0
			['terminal'] = {pos = vector3(1172.29,2713.15,38.39), model = -1591004109, heading = 0.0, setHeading = 0.0, freeze = true}, -- cell door to enter safes
			['vault'] = {pos = vector3(1175.54,2710.86,38.23), model = 2121050683, heading = 90.0, setHeading = 90.0, count = 250, freeze = true}, -- vault main door
			
		},

		safes = {
			[1] = {
				pos = vector3(1175.63,2715.20,38.06), anim = vector4(1174.72,2715.25,38.06,266.26), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[2] = {
				pos = vector3(1173.12,2717.20,38.06), anim = vector4(1173.09,2716.30,38.06,356.55), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[3] = {
				pos = vector3(1170.81,2715.17,38.06), anim = vector4(1171.68,2715.19,38.06,87.71), robbed = false, failed = false,
				requireHack = 'vault',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[4] = {
				pos = vector3(1173.77,2710.36,38.06), anim = vector4(1173.77,2711.24,38.06,180.11), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
			[5] = {
				pos = vector3(1171.36,2711.88,38.06), anim = vector4(1172.23,2711.84,38.06,88.92), robbed = false, failed = false,
				requireHack = 'start',
				items = {},
				cash = {enable = true, min = 30000, max = 90000},
				propanim = {'money'}
			},
		},
		
		pettyCash = {
			[1] = {pos = vector3(1173.16,2707.86,38.11), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[2] = {pos = vector3(1174.9,2707.87,38.11), robbed = false, reward = {dirty = true, min = 2000, max = 5000}},
			[3] = {pos = vector3(1176.59,2707.86,38.11), robbed = false, reward = {dirty = true, min = 2000, max = 5000}}, 
		},

		
		reqItems = { -- required items for pacific & settings:
			['hacking_laptop'] = { -- do not touch ID's
				{name = 'laptop_h', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['id_card_f'] = { -- do not touch ID's
				{name = 'id_card_f', amount = 1, remove = true, chance = 95}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			['thermite'] = { -- do not touch ID's
				{name = 'thermal_charge', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			},
			
			['drilling'] = { -- do not touch ID's
				{name = 'drill', amount = 1, remove = true, chance = 100}, -- item name, amount required, remove/not remove, chance to remove in %.
				-- add more items with same layout if u want
			}
			
		},
	},
}

Config.RequireItem = {
	['hacking_laptop'] = { -- action id do not change!
		require = true, -- require this item upon action?
		name = 'laptop_h', -- item name
		amount = 1, -- amount required
		remove = true, -- remove item upon usage
	},
	['id_card_f'] = { -- action id do not change!
		require = true, -- require this item upon action?
		name = 'id_card_f', -- item name
		amount = 1, -- amount required
		remove = true, -- remove item upon usage
	},
	['thermite'] = { -- action id do not change!
		require = true, -- require this item upon action?
		name = 'thermal_charge', -- item name
		amount = 1, -- amount required
		remove = true, -- remove item upon usage
	},
	
	['drilling'] = { -- action id do not change!
		require = true, -- require this item upon action?
		name = 'drill', -- item name
		amount = 1, -- amount required
		remove = false, -- remove item upon usage
	},
	
}

Config.KeyControls = {
    ['hack_terminal'] = 38,
    ['hack_vault'] = 38,
    ['use_id_card_f'] = 47,
    ['door_action'] = 38,
    ['drill_start'] = 38,
    ['drill_stop'] = 214,
    --['crack_safe'] = 38,
    ['petty_cash'] = 38,
    ['reset_bank'] = 47,
}