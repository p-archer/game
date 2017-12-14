/* global require, module */

const { attackTypes } = require('./constants');

const SkillList = [{
	name: 'lockpick',
	core: true,
	requirements: {
		level: 0,
		melee: 0,
		ranged: 0,
		magic: 0,
		skills: []
	},
	cost: 0,
	description: 'Skill for opening locks'
}, {
	name: 'inspection',
	core: true,
	requirements: {
		level: 0,
		melee: 0,
		ranged: 0,
		magic: 0,
		skills: []
	},
	description: 'This skill allows you to inspect enemies before battle. The higher the skill the more information you can gather.'
}, {
	name: 'swordsmanship',
	core: true,
	requirements: {
		level: 0,
		melee: 0,
		ranged: 0,
		magic: 0,
		skills: []
	},
	attackType: attackTypes.melee,
	damageBonus: function() {
		return (this.level * 0.05);
	},
	description: 'Basic skill for using melee weapons.'
}, {
	name: 'archery',
	core: true,
	requirements: {
		level: 0,
		melee: 0,
		ranged: 0,
		magic: 0,
		skills: []
	},
	attackType: attackTypes.ranged,
	damageBonus: function() {
		return (this.level * 0.05);
	},
	description: 'Basic skill for using ranged weapons.'
}, {
	name: 'sorcery',
	core: true,
	requirements: {
		level: 0,
		melee: 0,
		ranged: 0,
		magic: 0,
		skills: []
	},
	attackType: attackTypes.magic,
	damageBonus: function() {
		return (this.level * 0.05);
	},
	description: 'Basic skill for using magic weapons.'
}, {
	name: 'improved swordsmanship',
	requirements: {
		level: 10,
		melee: 10,
		ranged: 0,
		magic: 0,
		skills: [{name: 'swordsmanship', level: 5}]
	},
	cost: 500,
	attackType: attackTypes.melee,
	damageBonus: function() {
		return (this.level * 0.05);
	},
	description: 'Improved skill for using melee weapons.'
}, {
	name: 'improved archery',
	requirements: {
		level: 10,
		melee: 0,
		ranged: 10,
		magic: 0,
		skills: [{name: 'archery', level: 5}],
	},
	cost: 500,
	attackType: attackTypes.ranged,
	damageBonus: function() {
		return (this.level * 0.05);
	},
	description: 'Improved skill for using ranged weapons.'
}, {
	name: 'improved sorcery',
	requirements: {
		level: 10,
		melee: 0,
		ranged: 0,
		magic: 10,
		skills: [{name: 'sorcery', level: 5}]
	},
	cost: 500,
	attackType: attackTypes.magic,
	damageBonus: function() {
		return (this.level * 0.05);
	},
	description: 'Improved skill for using magic weapons.'
}, {
	name: 'advanced swordsmanship',
	requirements: {
		level: 25,
		melee: 25,
		ranged: 0,
		magic: 0,
		skills: [{name: 'improved swordsmanship', level: 5}]
	},
	cost: 2500,
	attackType: attackTypes.melee,
	damageBonus: function() {
		return (this.level * 0.05);
	},
	description: 'Advanced skill for using melee weapons.'
}, {
	name: 'advanced archery',
	requirements: {
		level: 25,
		melee: 0,
		ranged: 25,
		magic: 0,
		skills: [{name: 'improved archery', level: 5}],
	},
	cost: 2500,
	attackType: attackTypes.ranged,
	damageBonus: function() {
		return (this.level * 0.05);
	},
	description: 'Advanced skill for using ranged weapons.'
}, {
	name: 'advanced sorcery',
	requirements: {
		level: 25,
		melee: 0,
		ranged: 0,
		magic: 25,
		skills: [{name: 'improved sorcery', level: 5}]
	},
	cost: 2500,
	attackType: attackTypes.magic,
	damageBonus: function() {
		return (this.level * 0.05);
	},
	description: 'Advanced skill for using magic weapons.'
}, {
	name: 'skinning',
	requirements: {
		level: 0,
		melee: 0,
		ranged: 0,
		magic: 0,
		skills: []
	},
	bonus: 0.10,
	cost: 100,
	description: 'Gain extra gold from beasts by skinning them and selling their hides (10% more gold per level).'
}];

// presence: 0, //lowers enemy damage and resistances
// regeneration: 0,
// sneak: 0, //can walk past enemies
// alchemy: 0, //potions
// hunter: 0, //dmg bonus against beasts
// skinning: 0, //loot bonus from beasts
// criticals: 0, //critical chance + each attack type
// blocking: 0, //block a large portion of dmg
// dodging: 0, //dodge attack
// parrying: 0, //retaliate bonus

module.exports = SkillList;
