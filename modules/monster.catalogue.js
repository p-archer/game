/* global module, require */

const { attackTypes, species, mapTypes } = require('./constants');

const monsters = [{
	name: 'fairy',
	land: [mapTypes.forest, mapTypes.enchanted, mapTypes.magical],
	species: [species.fairy, species.magical],
	minLevel: 10,
	maxLevel: 40,
	movement: 12,
	attack: {
		attackType: attackTypes.magic,
		max: 3,
		min: 1,
	},
	armour: {
		melee: {
			max: 10,
			min: 0
		},
		ranged: {
			max: 10,
			min: 0
		},
		magic: {
			max: 30,
			min: 5
		}
	},
	hp: 3,
	gold: {
		min: 2,
		max: 5
	},
	xp: {
		min: 2,
		max: 4
	}
}, {
	name: 'wolf',
	land: [mapTypes.forest, mapTypes.arctic],
	species: [species.beast],
	minLevel: 0,
	maxLevel: 25,
	movement: 15,
	attack: {
		attackType: attackTypes.melee,
		max: 1,
		min: 1,
	},
	armour: {
		melee: {
			max: 20,
			min: 0
		},
		ranged: {
			max: 0,
			min: 0
		},
		magic: {
			max: 0,
			min: 0
		}
	},
	hp: 4,
	gold: {
		min: 1,
		max: 3
	},
	xp: {
		min: 2,
		max: 4
	}
}, {
	name: 'skeleton warrior',
	land: [mapTypes.dungeon, mapTypes.crypt, mapTypes.tower],
	species: [species.undead],
	minLevel: 0,
	maxLevel: 50,
	movement: 10,
	attack: {
		attackType: attackTypes.melee,
		max: 1,
		min: 1,
	},
	armour: {
		melee: {
			max: 20,
			min: 0
		},
		ranged: {
			max: 60,
			min: 50
		},
		magic: {
			max: 10,
			min: 0
		}
	},
	hp: 4,
	gold: {
		min: 1,
		max: 4
	},
	xp: {
		min: 1,
		max: 4
	}
}, {
	name: 'skeleton magi',
	land: [mapTypes.magical, mapTypes.tower],
	species: [species.undead],
	minLevel: 5,
	maxLevel: 50,
	movement: 6,
	attack: {
		attackType: attackTypes.magic,
		max: 2,
		min: 1,
	},
	armour: {
		melee: {
			max: 10,
			min: 0
		},
		ranged: {
			max: 60,
			min: 50
		},
		magic: {
			max: 20,
			min: 0
		}
	},
	hp: 4,
	gold: {
		min: 1,
		max: 4
	},
	xp: {
		min: 2,
		max: 5
	}
}, {
	name: 'skeleton archer',
	land: [mapTypes.dungeon, mapTypes.crypt, mapTypes.swamp],
	species: [species.undead],
	minLevel: 5,
	maxLevel: 50,
	movement: 6,
	attack: {
		attackType: attackTypes.ranged,
		max: 2,
		min: 1,
		range: 15
	},
	armour: {
		melee: {
			max: 20,
			min: 0
		},
		ranged: {
			max: 60,
			min: 50
		},
		magic: {
			max: 10,
			min: 0
		}
	},
	hp: 4,
	gold: {
		min: 1,
		max: 4
	},
	xp: {
		min: 2,
		max: 4
	}
}, {
	name: 'skeleton knight',
	land: [mapTypes.dungeon, mapTypes.crypt],
	species: [species.undead],
	minLevel: 10,
	maxLevel: 50,
	movement: 10,
	attack: {
		attackType: attackTypes.melee,
		max: 4,
		min: 2,
	},
	armour: {
		melee: {
			max: 40,
			min: 20
		},
		ranged: {
			max: 60,
			min: 50
		},
		magic: {
			max: 10,
			min: 0
		}
	},
	hp: 6,
	gold: {
		min: 3,
		max: 6
	},
	xp: {
		min: 4,
		max: 6
	}
}, {
	name: 'zombie',
	land: [mapTypes.dungeon, mapTypes.crypt],
	species: [species.undead],
	minLevel: 5,
	maxLevel: 30,
	movement: 6,
	attack: {
		attackType: attackTypes.melee,
		max: 2,
		min: 1,
	},
	armour: {
		melee: {
			max: 30,
			min: 10
		},
		ranged: {
			max: 20,
			min: 10
		},
		magic: {
			max: 20,
			min: 0
		}
	},
	hp: 8,
	gold: {
		min: 2,
		max: 6
	},
	xp: {
		min: 3,
		max: 6
	}
}, {
	name: 'spider',
	land: [mapTypes.forest, mapTypes.dungeon, mapTypes.crypt],
	species: [species.beast],
	minLevel: 0,
	maxLevel: 20,
	movement: 10,
	attack: {
		attackType: attackTypes.melee,
		max: 1,
		min: 1,
	},
	armour: {
		melee: {
			max: 10,
			min: 0
		},
		ranged: {
			max: 0,
			min: 0
		},
		magic: {
			max: 30,
			min: 0
		}
	},
	hp: 3,
	gold: {
		min: 1,
		max: 2
	},
	xp: {
		min: 1,
		max: 3
	}
}, {
	name: 'dryad',
	land: [mapTypes.forest, mapTypes.enchanted],
	species: [species.magical, species.fairy],
	minLevel: 10,
	maxLevel: 40,
	movement: 15,
	attack: {
		attackType: attackTypes.ranged,
		max: 4,
		min: 2,
		range: 20
	},
	armour: {
		melee: {
			max: 10,
			min: 0
		},
		ranged: {
			max: 20,
			min: 0
		},
		magic: {
			max: 20,
			min: 5
		}
	},
	hp: 5,
	gold: {
		min: 3,
		max: 6
	},
	xp: {
		min: 4,
		max: 6
	}
}, {
	name: 'bear',
	land: [mapTypes.forest, mapTypes.arctic],
	species: [species.beast],
	minLevel: 10,
	maxLevel: 40,
	movement: 12,
	attack: {
		attackType: attackTypes.melee,
		max: 5,
		min: 2,
	},
	armour: {
		melee: {
			max: 20,
			min: 0
		},
		ranged: {
			max: 0,
			min: 0
		},
		magic: {
			max: 0,
			min: 0
		}
	},
	hp: 8,
	gold: {
		min: 2,
		max: 5
	},
	xp: {
		min: 3,
		max: 7
	}
}, {
	name: 'centaur archer',
	land: [mapTypes.forest, mapTypes.enchanted, mapTypes.swamp],
	species: [species.mythological],
	minLevel: 20,
	maxLevel: 50,
	movement: 20,
	attack: {
		attackType: attackTypes.ranged,
		max: 5,
		min: 3,
		range: 15
	},
	armour: {
		melee: {
			max: 30,
			min: 10
		},
		ranged: {
			max: 25,
			min: 5
		},
		magic: {
			max: 0,
			min: 0
		}
	},
	hp: 5,
	gold: {
		min: 3,
		max: 7
	},
	xp: {
		min: 5,
		max: 8
	}
}, {
	name: 'centaur lancer',
	land: [mapTypes.forest, mapTypes.enchanted, mapTypes.swamp],
	species: [species.mythological],
	minLevel: 20,
	maxLevel: 50,
	movement: 20,
	attack: {
		attackType: attackTypes.melee,
		max: 4,
		min: 2,
	},
	armour: {
		melee: {
			max: 30,
			min: 10
		},
		ranged: {
			max: 25,
			min: 5
		},
		magic: {
			max: 0,
			min: 0
		}
	},
	hp: 5,
	gold: {
		min: 3,
		max: 7
	},
	xp: {
		min: 5,
		max: 8
	}
}, {
	name: 'goblin',
	land: [mapTypes.dungeon, mapTypes.swamp],
	species: [species.greenskin],
	minLevel: 0,
	maxLevel: 20,
	movement: 10,
	attack: {
		attackType: attackTypes.melee,
		max: 1,
		min: 1,
	},
	armour: {
		melee: {
			max: 15,
			min: 0
		},
		ranged: {
			max: 15,
			min: 0
		},
		magic: {
			max: 15,
			min: 0
		}
	},
	hp: 3,
	gold: {
		min: 1,
		max: 2
	},
	xp: {
		min: 1,
		max: 3
	}
}, {
	name: 'salamander',
	land: [mapTypes.dungeon, mapTypes.swamp],
	species: [species.lizard],
	minLevel: 5,
	maxLevel: 30,
	movement: 10,
	attack: {
		attackType: attackTypes.ranged,
		max: 4,
		min: 2,
		range: 15
	},
	armour: {
		melee: {
			max: 20,
			min: 10
		},
		ranged: {
			max: 20,
			min: 10
		},
		magic: {
			max: 20,
			min: 10
		}
	},
	hp: 5,
	gold: {
		min: 3,
		max: 5
	},
	xp: {
		min: 3,
		max: 5
	}
}, {
	name: 'orc',
	land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.arctic],
	species: [species.greenskin],
	minLevel: 20,
	maxLevel: 50,
	movement: 10,
	attack: {
		attackType: attackTypes.melee,
		max: 6,
		min: 4,
	},
	armour: {
		melee: {
			max: 50,
			min: 20
		},
		ranged: {
			max: 25,
			min: 15
		},
		magic: {
			max: 25,
			min: 10
		}
	},
	hp: 6,
	gold: {
		min: 2,
		max: 4
	},
	xp: {
		min: 4,
		max: 8
	}
}, {
	name: 'highwayman',
	land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.forest],
	species: [species.humanoid],
	minLevel: 10,
	maxLevel: 40,
	movement: 10,
	attack: {
		attackType: attackTypes.melee,
		max: 4,
		min: 2,
	},
	armour: {
		melee: {
			max: 25,
			min: 10
		},
		ranged: {
			max: 25,
			min: 10
		},
		magic: {
			max: 25,
			min: 10
		}
	},
	hp: 5,
	gold: {
		min: 5,
		max: 7
	},
	xp: {
		min: 4,
		max: 6
	}
}, {
	name: 'goblin',
	land: [mapTypes.dungeon, mapTypes.inferno],
	species: [species.infernal],
	minLevel: 0,
	maxLevel: 20,
	movement: 10,
	attack: {
		attackType: attackTypes.melee,
		max: 1,
		min: 1,
	},
	armour: {
		melee: {
			max: 15,
			min: 0
		},
		ranged: {
			max: 15,
			min: 0
		},
		magic: {
			max: 15,
			min: 0
		}
	},
	hp: 3,
	gold: {
		min: 1,
		max: 2
	},
	xp: {
		min: 2,
		max: 4
	}
}, {
	name: 'succubus',
	land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.inferno, mapTypes.tower, mapTypes.magical],
	species: [species.infernal],
	minLevel: 20,
	maxLevel: 50,
	movement: 15,
	attack: {
		attackType: attackTypes.magic,
		max: 4,
		min: 2,
	},
	armour: {
		melee: {
			max: 45,
			min: 0
		},
		ranged: {
			max: 45,
			min: 0
		},
		magic: {
			max: 45,
			min: 0
		}
	},
	hp: 4,
	gold: {
		min: 6,
		max: 10
	},
	xp: {
		min: 4,
		max: 6
	}
}, {
	name: 'giant',
	land: [mapTypes.arctic, mapTypes.enchanted, mapTypes.desert],
	species: [species.giant],
	minLevel: 20,
	maxLevel: 50,
	movement: 6,
	attack: {
		attackType: attackTypes.melee,
		max: 8,
		min: 5,
	},
	armour: {
		melee: {
			max: 45,
			min: 0
		},
		ranged: {
			max: 35,
			min: 0
		},
		magic: {
			max: 25,
			min: 0
		}
	},
	hp: 10,
	gold: {
		min: 3,
		max: 5
	},
	xp: {
		min: 6,
		max: 10
	}
}, {
	name: 'jackal',
	land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.desert],
	species: [species.mythological, species.beast],
	minLevel: 10,
	maxLevel: 40,
	movement: 15,
	attack: {
		attackType: attackTypes.melee,
		max: 3,
		min: 1,
	},
	armour: {
		melee: {
			max: 35,
			min: 20
		},
		ranged: {
			max: 25,
			min: 0
		},
		magic: {
			max: 25,
			min: 0
		}
	},
	hp: 4,
	gold: {
		min: 4,
		max: 6
	},
	xp: {
		min: 3,
		max: 5
	}
}, {
	name: 'whisp',
	land: [mapTypes.tower, mapTypes.enchanted, mapTypes.magical],
	species: [species.magical],
	minLevel: 0,
	maxLevel: 20,
	movement: 12,
	attack: {
		attackType: attackTypes.magic,
		max: 1,
		min: 1,
	},
	armour: {
		melee: {
			max: 10,
			min: 0
		},
		ranged: {
			max: 10,
			min: 0
		},
		magic: {
			max: 10,
			min: 0
		}
	},
	hp: 2,
	gold: {
		min: 1,
		max: 2
	},
	xp: {
		min: 1,
		max: 2
	}
}, {
	name: 'genie',
	land: [mapTypes.enchanted, mapTypes.tower, mapTypes.magical],
	species: [species.magical],
	minLevel: 10,
	maxLevel: 40,
	movement: 15,
	attack: {
		attackType: attackTypes.magic,
		max: 4,
		min: 2,
	},
	armour: {
		melee: {
			max: 15,
			min: 0
		},
		ranged: {
			max: 15,
			min: 0
		},
		magic: {
			max: 40,
			min: 20
		}
	},
	hp: 4,
	gold: {
		min: 4,
		max: 6
	},
	xp: {
		min: 4,
		max: 6
	}
}, {
	name: 'fire elemental',
	land: [mapTypes.inferno, mapTypes.tower, mapTypes.magical],
	species: [species.magical],
	minLevel: 10,
	maxLevel: 100,
	movement: 12,
	attack: {
		attackType: attackTypes.melee,
		max: 5,
		min: 2,
	},
	armour: {
		melee: {
			max: 35,
			min: 20
		},
		ranged: {
			max: 35,
			min: 20
		},
		magic: {
			max: 50,
			min: 20
		}
	},
	hp: 5,
	gold: {
		min: 4,
		max: 6
	},
	xp: {
		min: 6,
		max: 8
	}
}, {
	name: 'ice elemental',
	land: [mapTypes.arctic, mapTypes.tower, mapTypes.magical],
	species: [species.magical],
	minLevel: 10,
	maxLevel: 100,
	movement: 8,
	attack: {
		attackType: attackTypes.ranged,
		max: 6,
		min: 3,
		range: 25
	},
	armour: {
		melee: {
			max: 35,
			min: 20
		},
		ranged: {
			max: 35,
			min: 20
		},
		magic: {
			max: 50,
			min: 20
		}
	},
	hp: 4,
	gold: {
		min: 4,
		max: 6
	},
	xp: {
		min: 6,
		max: 8
	}
}, {
	name: 'elf',
	land: [mapTypes.forest, mapTypes.enchanted],
	species: [species.humanoid],
	minLevel: 10,
	maxLevel: 30,
	movement: 10,
	attack: {
		attackType: attackTypes.ranged,
		max: 4,
		min: 2,
		range: 30
	},
	armour: {
		melee: {
			max: 35,
			min: 20
		},
		ranged: {
			max: 20,
			min: 10
		},
		magic: {
			max: 20,
			min: 10
		}
	},
	hp: 4,
	gold: {
		min: 2,
		max: 5
	},
	xp: {
		min: 4,
		max: 6
	}
}, {
	name: 'drow elf',
	land: [mapTypes.forest, mapTypes.dungeon, mapTypes.swamp],
	species: [species.humanoid],
	minLevel: 20,
	maxLevel: 50,
	movement: 10,
	attack: {
		attackType: attackTypes.ranged,
		max: 6,
		min: 2,
		range: 30
	},
	armour: {
		melee: {
			max: 45,
			min: 20
		},
		ranged: {
			max: 40,
			min: 10
		},
		magic: {
			max: 30,
			min: 10
		}
	},
	hp: 6,
	gold: {
		min: 6,
		max: 7
	},
	xp: {
		min: 7,
		max: 9
	}
}, {
	name: 'troll',
	land: [mapTypes.forest, mapTypes.dungeon, mapTypes.swamp],
	species: [species.greenskin],
	minLevel: 10,
	maxLevel: 50,
	movement: 12,
	attack: {
		attackType: attackTypes.melee,
		max: 4,
		min: 2,
	},
	armour: {
		melee: {
			max: 45,
			min: 20
		},
		ranged: {
			max: 40,
			min: 10
		},
		magic: {
			max: 30,
			min: 10
		}
	},
	hp: 7,
	gold: {
		min: 3,
		max: 4
	},
	xp: {
		min: 5,
		max: 8
	}
}, {
	name: 'kobold',
	land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.inferno, mapTypes.desert],
	species: [species.greenskin],
	minLevel: 0,
	maxLevel: 20,
	movement: 8,
	attack: {
		attackType: attackTypes.ranged,
		max: 2,
		min: 1,
		range: 15
	},
	armour: {
		melee: {
			max: 15,
			min: 0
		},
		ranged: {
			max: 15,
			min: 0
		},
		magic: {
			max: 15,
			min: 0
		}
	},
	hp: 2,
	gold: {
		min: 1,
		max: 3
	},
	xp: {
		min: 2,
		max: 4
	}
}, {
	name: 'medusa',
	land: [mapTypes.dungeon, mapTypes.swamp],
	species: [species.mythological],
	minLevel: 10,
	maxLevel: 50,
	movement: 8,
	attack: {
		attackType: attackTypes.ranged,
		max: 4,
		min: 3,
		range: 10
	},
	armour: {
		melee: {
			max: 25,
			min: 10
		},
		ranged: {
			max: 30,
			min: 10
		},
		magic: {
			max: 20,
			min: 10
		}
	},
	hp: 4,
	gold: {
		min: 3,
		max: 6
	},
	xp: {
		min: 5,
		max: 8
	}
}, {
	name: 'imp',
	land: [mapTypes.dungeon, mapTypes.inferno, mapTypes.magical, mapTypes.desert],
	species: [species.infernal, species.magical],
	minLevel: 0,
	maxLevel: 20,
	movement: 10,
	attack: {
		attackType: attackTypes.magic,
		max: 1,
		min: 1,
	},
	armour: {
		melee: {
			max: 25,
			min: 0
		},
		ranged: {
			max: 20,
			min: 0
		},
		magic: {
			max: 25,
			min: 10
		}
	},
	hp: 2,
	gold: {
		min: 1,
		max: 4
	},
	xp: {
		min: 1,
		max: 3
	}
}];

module.exports = monsters;
