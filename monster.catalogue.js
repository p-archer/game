/* global module, require */

const { attackTypes, species, mapTypes } = require('./constants');

const monsters = [{
	name: 'fairy',
	land: [mapTypes.forest, mapTypes.enchanted, mapTypes.magical],
	species: [species.fairy, species.magical],
	minLevel: 0,
	maxLevel: 30,
	attack: {
		melee: {
			max: 1,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 3,
			min: 1,
			precision: 100
		}
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
	attack: {
		melee: {
			max: 1,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
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
	hp: 5,
	gold: {
		min: 1,
		max: 3
	},
	xp: {
		min: 2,
		max: 4
	}
}, {
	name: 'skeleton',
	land: [mapTypes.dungeon, mapTypes.crypt, mapTypes.tower],
	species: [species.undead],
	minLevel: 0,
	maxLevel: 50,
	attack: {
		preferred: attackTypes.melee,
		melee: {
			max: 1,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 2,
			min: 1,
			precision: 15
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
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
		max: 5
	}
}, {
	name: 'zombie',
	land: [mapTypes.dungeon, mapTypes.crypt],
	species: [species.undead],
	minLevel: 5,
	maxLevel: 30,
	attack: {
		preferred: attackTypes.melee,
		melee: {
			max: 2,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
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
	hp: 10,
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
	attack: {
		melee: {
			max: 1,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
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
	minLevel: 5,
	maxLevel: 40,
	attack: {
		melee: {
			max: 1,
			min: 1,
			precision: 60
		},
		ranged: {
			max: 4,
			min: 2,
			precision: 20
		},
		magic: {
			max: 0,
			min: 0,
			precision: 100
		}
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
	hp: 4,
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
	minLevel: 5,
	maxLevel: 40,
	attack: {
		melee: {
			max: 4,
			min: 2,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
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
	hp: 10,
	gold: {
		min: 2,
		max: 5
	},
	xp: {
		min: 3,
		max: 7
	}
}, {
	name: 'centaur',
	land: [mapTypes.forest, mapTypes.enchanted, mapTypes.swamp],
	species: [species.mythological],
	minLevel: 10,
	maxLevel: 50,
	attack: {
		melee: {
			max: 4,
			min: 2,
			precision: 80
		},
		ranged: {
			max: 5,
			min: 2,
			precision: 20
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
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
	attack: {
		melee: {
			max: 1,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
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
	attack: {
		melee: {
			max: 2,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 5,
			min: 2,
			precision: 20
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
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
	minLevel: 10,
	maxLevel: 40,
	attack: {
		melee: {
			max: 6,
			min: 4,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
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
	hp: 7,
	gold: {
		min: 2,
		max: 4
	},
	xp: {
		min: 4,
		max: 6
	}
}, {
	name: 'highwayman',
	land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.forest],
	species: [species.humanoid],
	minLevel: 5,
	maxLevel: 40,
	attack: {
		melee: {
			max: 4,
			min: 2,
			precision: 80
		},
		ranged: {
			max: 3,
			min: 1,
			precision: 20
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
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
	attack: {
		melee: {
			max: 1,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 2,
			min: 1,
			precision: 100
		}
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
	minLevel: 10,
	maxLevel: 50,
	attack: {
		melee: {
			max: 3,
			min: 2,
			precision: 80
		},
		ranged: {
			max: 4,
			min: 3,
			precision: 25
		},
		magic: {
			max: 4,
			min: 3,
			precision: 100
		}
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
	hp: 7,
	gold: {
		min: 6,
		max: 10
	},
	xp: {
		min: 5,
		max: 8
	}
}, {
	name: 'giant',
	land: [mapTypes.arctic, mapTypes.enchanted, mapTypes.desert],
	species: [species.giant],
	minLevel: 20,
	maxLevel: 50,
	attack: {
		melee: {
			max: 8,
			min: 5,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
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
	minLevel: 5,
	maxLevel: 40,
	attack: {
		melee: {
			max: 4,
			min: 2,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 0,
			min: 0,
			precision: 0
		}
	},
	armour: {
		melee: {
			max: 35,
			min: 0
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
	hp: 5,
	gold: {
		min: 4,
		max: 6
	},
	xp: {
		min: 4,
		max: 6
	}
}, {
	name: 'whisp',
	land: [mapTypes.tower, mapTypes.enchanted, mapTypes.magical],
	species: [species.magical],
	minLevel: 0,
	maxLevel: 20,
	attack: {
		melee: {
			max: 0,
			min: 0,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 1,
			min: 1,
			precision: 100
		}
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
	minLevel: 5,
	maxLevel: 40,
	attack: {
		melee: {
			max: 3,
			min: 2,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 5,
			min: 2,
			precision: 100
		}
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
	attack: {
		melee: {
			max: 5,
			min: 3,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 0
		},
		magic: {
			max: 4,
			min: 2,
			precision: 100
		}
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
	hp: 6,
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
	attack: {
		melee: {
			max: 1,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 5,
			min: 3,
			precision: 25
		},
		magic: {
			max: 3,
			min: 2,
			precision: 100
		}
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
	hp: 6,
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
	minLevel: 5,
	maxLevel: 30,
	attack: {
		melee: {
			max: 2,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 5,
			min: 2,
			precision: 50
		},
		magic: {
			max: 2,
			min: 1,
			precision: 100
		}
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
	attack: {
		melee: {
			max: 4,
			min: 2,
			precision: 80
		},
		ranged: {
			max: 6,
			min: 2,
			precision: 30
		},
		magic: {
			max: 0,
			min: 0,
			precision: 100
		}
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
	hp: 8,
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
	attack: {
		melee: {
			max: 4,
			min: 2,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 30
		},
		magic: {
			max: 0,
			min: 0,
			precision: 100
		}
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
	hp: 8,
	gold: {
		min: 3,
		max: 4
	},
	xp: {
		min: 5,
		max: 7
	}
}, {
	name: 'kobold',
	land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.inferno],
	species: [species.greenskin],
	minLevel: 0,
	maxLevel: 20,
	attack: {
		melee: {
			max: 1,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 3,
			min: 1,
			precision: 20
		},
		magic: {
			max: 1,
			min: 1,
			precision: 100
		}
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
		max: 3
	}
}, {
	name: 'medusa',
	land: [mapTypes.dungeon, mapTypes.swamp],
	species: [species.mythological],
	minLevel: 10,
	maxLevel: 40,
	attack: {
		melee: {
			max: 2,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 5,
			min: 3,
			precision: 30
		},
		magic: {
			max: 0,
			min: 0,
			precision: 100
		}
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
	hp: 5,
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
	land: [mapTypes.dungeon, mapTypes.inferno, mapTypes.magical],
	species: [species.infernal, species.magical],
	minLevel: 0,
	maxLevel: 20,
	attack: {
		melee: {
			max: 1,
			min: 1,
			precision: 80
		},
		ranged: {
			max: 0,
			min: 0,
			precision: 30
		},
		magic: {
			max: 1,
			min: 1,
			precision: 100
		}
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
