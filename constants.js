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

module.exports = {
	CHANCE_FOR_TREASURE: CHANCE_FOR_TREASURE,
	CHANCE_FOR_MONSTER: CHANCE_FOR_MONSTER,
	CHANCE_FOR_SHOP: CHANCE_FOR_SHOP,
	MAX_SKILL_LEVEL: MAX_SKILL_LEVEL,
	MAP_SIZE: MAP_SIZE,
	ARMOUR_GAIN_FACTOR: ARMOUR_GAIN_FACTOR,
	directions: directions,
	states: states,
	attackTypes: attackTypes,
	shops: shops
};
