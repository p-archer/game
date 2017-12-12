/* global module */

const MAP_SIZE = 12;
const CHANCE_FOR_TREASURE = 2;
const CHANCE_FOR_MONSTER = 10;
const CHANCE_FOR_SHOP = 20;
const MAX_SKILL_LEVEL = 5;
const ARMOUR_GAIN_FACTOR = 0.01;

const directions = {
	north: 0,
	south: 1,
	east: 2,
	west: 3
};

const states = {
	normal: 'normal',
	wait: 'wait',
	characterSheet: {
		main: 'character sheet',
		weapons: 'weapons',
		armour: 'armour',
		skills: 'skills'
	},
	combat: 'combat',
	shop: 'shop'
};

const heroStates = {
	normal: 'normal',
	block: 'block'
};

const attackTypes = {
	melee: 'melee',
	ranged: 'ranged',
	magic: 'magic'
};

const shops = {
	weapons: 'weapons',
	armour: 'armour',
	spells: 'spells',
	items: 'items',
	skills: 'skills'
};

const mapTypes = {
	arctic: 'arctic',
	crypt: 'crypt',
	desert: 'desert',
	dungeon: 'dungeon',
	enchanted: 'enchanted forest',
	inferno: 'inferno',
	forest: 'forest',
	magical: 'arcane dimension',
	swamp: 'swamp',
	tower: 'tower',
};

const species = {
	beast: 'beast',
	fairy: 'fairy',
	giant: 'giant',
	greenskin: 'greenskin',
	humanoid: 'humanoid',
	infernal: 'infernal',
	lizard: 'lizard',
	magical: 'magical',
	mythological: 'mythological',
	undead: 'undead',
};

module.exports = {
	ARMOUR_GAIN_FACTOR: ARMOUR_GAIN_FACTOR,
	CHANCE_FOR_MONSTER: CHANCE_FOR_MONSTER,
	CHANCE_FOR_SHOP: CHANCE_FOR_SHOP,
	CHANCE_FOR_TREASURE: CHANCE_FOR_TREASURE,
	MAP_SIZE: MAP_SIZE,
	MAX_SKILL_LEVEL: MAX_SKILL_LEVEL,
	attackTypes: attackTypes,
	directions: directions,
	heroStates: heroStates,
	mapTypes: mapTypes,
	shops: shops,
	species: species,
	states: states,
};
