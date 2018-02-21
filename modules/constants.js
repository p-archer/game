/* global module */

const ARMOUR_GAIN_FACTOR = 0.01;
const CHANCE_FOR_ADDITIONAL_EXIT = 50;
const CHANCE_FOR_MONSTER = 15;
const CHANCE_FOR_SHOP = 100;
const CHANCE_FOR_TREASURE = 35;
const GOLD_RANGE = [10, 50, 200, 500, 1000];
const HP_GAIN_FACTOR = 1.125;
const LEVEL_GAIN_FACTOR = 1.125;
const MANA_GAIN_FACTOR = 1.025;
const MAP_SIZE = 12;
const MAX_SKILL_LEVEL = 5;
const QUALITY_RANGE = [0, 15, 25, 40, 80, 160];
const WEAPON_GAIN_FACTOR = 1.033;
const XP_GAIN_FACTOR = 1.10;

const directions = {
	north: 'north',
	south: 'south',
	east: 'east',
	west: 'west'
};

const actions = {
	approach: 'approach',
	retreat: 'retreat',
	attack: 'attack',
	useSpell: 'useSpell'
};

const states = {
	characterSelection: 'character-selection',
	characterSheet: {
		main: 'character sheet',
		weapons: 'weapons',
		armour: 'armour',
		masteries: 'masteries',
		skills: 'skills',
		abilities: 'abilities'
	},
	combat: {
		main: 'combat',
		abilities: 'combat-abilities',
		quiver: 'combat-quiver',
		broadheads: 'combat-broadheads',
	},
	normal: 'normal',
	shop: 'shop',
	quit: 'quit',
	wait: 'wait',
};

const heroStates = {
	bleeding: 'bleeding',
	block: 'block',
	burning: 'burning',
	frozen: 'frozen',
	maimed: 'maimed',
	normal: 'normal',
	parried: 'parried',
	poisoned: 'poisoned',
	reflected: 'reflected',
	stunned: 'stunned',
};

const attackTypes = {
	arcane: 'arcane',
	dark: 'dark',
	fire: 'fire',
	ice: 'ice',
	lightning: 'lightning',
	physical: 'physical',
	poison: 'poison',
	pure: 'pure',
};

const shops = {
	weapons: 'shop-weapons',
	// armour: 'shop-armour',
	// spells: 'shop-spells',
	// items: 'shop-items',
	skills: 'shop-skills'
};

const mapStyles = {
	corridors: 'corridors',
	plain: 'plain',
	ripple: 'ripple',
};

const mapTypes = {
	arctic: { name: 'arctic', level: 0, style: mapStyles.plain }, //melee heavy, some ranged
	crypt: { name: 'crypt', level: 0, style: mapStyles.corridors }, //mixed (melee heavy)
	desert: { name: 'desert', level: 5, style: mapStyles.plain }, //
	dungeon: { name: 'dungeon', level: 5, style: mapStyles.corridors }, //melee
	enchanted: { name: 'enchanted forest', level: 15, style: mapStyles.plain }, //magic
	inferno: { name: 'inferno', level: 10, style: mapStyles.ripple }, //magic
	forest: { name: 'forest', level: 0, style: mapStyles.plain }, //melee
	magical: { name: 'arcane dimension', level: 10, style: mapStyles.ripple }, //magic
	swamp: { name: 'swamp', level: 10, style: mapStyles.corridors }, //ranged
	tower: { name: 'tower', level: 20, style: mapStyles.ripple }, //magic
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

const heroClass = {
	arbalist: 'arbalist',
	archer: 'archer',
	bandit: 'bandit',
	crusader: 'crusader',
	knight: 'knight',
	mage: 'mage',
	sorcerer: 'sorcerer',
	warrior: 'warrior',
	wizard: 'wizard',
};

const weaponStates = {
	bleeding: 'weapon-state-bleed',
	burning: 'weapon-state-burning',
	critical: 'weapon-state-critical',
	freezing: 'weapon-state-freezing',
	leeching: 'weapon-state-leech',
	lifeDrain: 'weapon-state-lifedrain',
	maiming: 'weapons-state-maim',
	manaDrain: 'weapon-state-manadrain',
	manaLeeching: 'weapon-state-manaleech',
	piercing: 'weapon-state-pierce',
	poisoning: 'weapon-state-poison',
	stunnning: 'weapon-state-stun',
};

const weaponTypes = {
	axe: 'axe',
	bow: 'bow',
	crossbow: 'crossbow',
	hammer: 'hammer',
	spear: 'spear',
	staff: 'staff',
	sword: 'sword',
	wand: 'wand',
	tome: 'tome'
};

const armourTypes = {
	light: 'armour-light',
	medium: 'armour-medium',
	heavy: 'armour-heavy',
};

const speed = {
	normal: 30,
	slow: 40,
	fast: 20,
	vslow: 50,
	vfast: 10,
};

module.exports = {
	ARMOUR_GAIN_FACTOR: ARMOUR_GAIN_FACTOR,
	CHANCE_FOR_ADDITIONAL_EXIT: CHANCE_FOR_ADDITIONAL_EXIT,
	CHANCE_FOR_MONSTER: CHANCE_FOR_MONSTER,
	CHANCE_FOR_SHOP: CHANCE_FOR_SHOP,
	CHANCE_FOR_TREASURE: CHANCE_FOR_TREASURE,
	GOLD_RANGE: GOLD_RANGE,
	HP_GAIN_FACTOR: HP_GAIN_FACTOR,
	LEVEL_GAIN_FACTOR: LEVEL_GAIN_FACTOR,
	MANA_GAIN_FACTOR: MANA_GAIN_FACTOR,
	MAP_SIZE: MAP_SIZE,
	MAX_SKILL_LEVEL: MAX_SKILL_LEVEL,
	QUALITY_RANGE: QUALITY_RANGE,
	XP_GAIN_FACTOR: XP_GAIN_FACTOR,
	WEAPON_GAIN_FACTOR: WEAPON_GAIN_FACTOR,

	actions: actions,
	armourTypes: armourTypes,
	attackTypes: attackTypes,
	directions: directions,
	heroClass: heroClass,
	heroStates: heroStates,
	mapStyles: mapStyles,
	mapTypes: mapTypes,
	shops: shops,
	species: species,
	speed: speed,
	states: states,
	weaponTypes: weaponTypes,
	weaponStates: weaponStates,
};
