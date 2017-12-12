/* global module, require */

const { attackTypes } = require('./constants');

const monsters = {
	fairy: {
		name: 'fairy',
		minLevel: 0,
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
			min: 3,
			max: 6
		}
	},
	wolf: {
		name: 'wolf',
		minLevel: 0,
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
	},
	skeleton: {
		name: 'skeleton',
		minLevel: 0,
		attack: {
			preferred: attackTypes.melee,
			melee: {
				max: 1,
				min: 1,
				precision: 80
			},
			ranged: {
				max: 3,
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
		hp: 5,
		gold: {
			min: 1,
			max: 4
		},
		xp: {
			min: 3,
			max: 7
		}
	},
	spider: {
		name: 'spider',
		minLevel: 0,
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
	},
	dryad: {
		name: 'dryad',
		minLevel: 3,
		attack: {
			melee: {
				max: 1,
				min: 1,
				precision: 60
			},
			ranged: {
				max: 5,
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
			max: 8
		}
	},
	bear: {
		name: 'bear',
		minLevel: 5,
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
	},
	centaur: {
		name: 'centaur',
		minLevel: 10,
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
	},
};


module.exports = monsters;
