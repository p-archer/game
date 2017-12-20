/* global module */

const MAP_SIZE = 12;
const CHANCE_FOR_TREASURE = 2;
const CHANCE_FOR_MONSTER = 10;
const CHANCE_FOR_SHOP = 50;
const MAX_SKILL_LEVEL = 5;
const ARMOUR_GAIN_FACTOR = 0.01;
const WEAPON_GAIN_FACTOR = 1.05;
const HP_GAIN_FACTOR = 1.05;
const XP_GAIN_FACTOR = 1.1;

const directions = {
	north: 'north',
	south: 'south',
	east: 'east',
	west: 'west'
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
	shop: 'shop',
	quit: 'quit'
};

const heroStates = {
	normal: 'normal',
	block: 'block',
	parried: 'parried',
	reflected: 'reflected',
};

const attackTypes = {
	melee: 'melee',
	ranged: 'ranged',
	magic: 'magic'
};

const shops = {
	weapons: 'shop-weapons',
	armour: 'shop-armour',
	spells: 'shop-spells',
	items: 'shop-items',
	skills: 'shop-skills'
};

const mapTypes = {
	arctic: 'arctic', //melee heavy, some ranged
	crypt: 'crypt', //mixed (melee heavy)
	desert: 'desert', //
	dungeon: 'dungeon', //melee
	enchanted: 'enchanted forest', //magic
	inferno: 'inferno', //magic
	forest: 'forest', //melee
	magical: 'arcane dimension', //magic
	swamp: 'swamp', //ranged
	tower: 'tower', //magic
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
	HP_GAIN_FACTOR: HP_GAIN_FACTOR,
	XP_GAIN_FACTOR: XP_GAIN_FACTOR,
	WEAPON_GAIN_FACTOR: WEAPON_GAIN_FACTOR,
	attackTypes: attackTypes,
	directions: directions,
	heroStates: heroStates,
	mapTypes: mapTypes,
	shops: shops,
	species: species,
	states: states,
};
