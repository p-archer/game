/* global module, require */

const { attackTypes } = require('./constants');

//melee: spears, swords, axes
//ranged: bows, crossbows, javelins
//magic: wands, staffs, tomes
//weapon type specialisation

//weapon rarity: normal, rare, unique, set
//weapons should have bonuses and/or abilities
//some weapons are not available in shops
//shops should randomise weapon qualities

let weapons = [{
	name: 'short sword',
	min: 1,
	max: 3,
	range: 1,
	attackType: attackTypes.melee,
	requirements: {
		level: 0,
		melee: 0,
		skills: [{name: 'swordsmanship', level: 0}],
	},
	cost: 10
}, {
	name: 'long sword',
	min: 2,
	max: 4,
	range: 1,
	attackType: attackTypes.melee,
	requirements: {
		level: 5,
		melee: 5,
		skills: [{name: 'swordsmanship', level: 1}],
	},
	cost: 10
}, {
	name: 'short bow',
	min: 1,
	max: 4,
	range: 20,
	attackType: attackTypes.ranged,
	requirements: {
		level: 0,
		ranged: 0,
		skills: [{name: 'archery', level: 0}],
	},
	cost: 10
}, {
	name: 'long bow',
	min: 2,
	max: 5,
	range: 25,
	attackType: attackTypes.ranged,
	requirements: {
		level: 5,
		ranged: 5,
		skills: [{name: 'archery', level: 1}],
	},
	cost: 10
}, {
	name: 'recurve bow',
	min: 3,
	max: 6,
	range: 28,
	attackType: attackTypes.ranged,
	requirements: {
		level: 10,
		ranged: 10,
		skills: [{name: 'improved archery', level: 1}],
	},
	cost: 10
}, {
	name: 'short wand',
	min: 1.6,
	max: 1.6,
	range: 1000,
	attackType: attackTypes.magic,
	requirements: {
		level: 0,
		magic: 0,
		skills: [{name: 'sorcery', level: 0}],
	},
	cost: 10
}, {
	name: 'wand',
	min: 2.4,
	max: 2.4,
	range: 1000,
	attackType: attackTypes.magic,
	requirements: {
		level: 5,
		magic: 5,
		skills: [{name: 'sorcery', level: 1}],
	},
	cost: 10
}];

function get(name) {
	let items = weapons.filter((x) => x.name === name);

	if (items)
		return items[0];
	else
		return null;
}

function getAvailable(hero) {
	return weapons.filter((x) => {
		if (hero.weapon.name === x.name)
			return false;
		if (hero.level < x.requirements.level)
			return false;
		if (x.requirements.melee && (hero.weapon.attackType !== attackTypes.melee || x.requirements.melee > hero.weapon.level))
			return false;
		if (x.requirements.ranged && (hero.weapon.attackType !== attackTypes.ranged || x.requirements.ranged > hero.weapon.level))
			return false;
		if (x.requirements.magic && (hero.weapon.attackType !== attackTypes.magic || x.requirements.magic > hero.weapon.level))
			return false;

		if (!x.requirements.skills)
			x.requirements.skills = [];

		let skillsMet = true;
		x.requirements.skills.forEach((x) => {
			let skill = hero.getSkill(x.name);
			if (!skill || skill.level < x.level)
				skillsMet = false;
		});

		return skillsMet;
	});
}

module.exports = {
	WeaponList: {
		get: get,
		getAvailable: getAvailable,
	}
};
