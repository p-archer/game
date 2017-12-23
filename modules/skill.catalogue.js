/* global require, module */

const { attackTypes, heroClass } = require('./constants');

const SkillList = [{
	name: 'lockpick',
	core: [heroClass.warrior, heroClass.archer, heroClass.mage],
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
	core: [heroClass.warrior, heroClass.archer, heroClass.mage],
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
	core: [heroClass.warrior],
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
	description: 'Basic skill for using melee weapons.',
	cost: 250,
}, {
	name: 'archery',
	core: [heroClass.archer],
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
	description: 'Basic skill for using ranged weapons.',
	cost: 250,
}, {
	name: 'sorcery',
	core: [heroClass.mage],
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
	description: 'Basic skill for using magic weapons.',
	cost: 250,
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
	cost: 200,
	description: 'Gain extra gold from beasts by skinning them and selling their hides (10% more gold per level).'
}, {
	name: 'dodge',
	requirements: {
		level: 10,
		melee: 0,
		ranged: 10,
		magic: 0,
		skills: []
	},
	bonus: 0.03,
	cost: 1000,
	description: 'Dodge incoming ranged attacks (3% to dodge per level).'
}, {
	name: 'stunning hit',
	requirements: {
		level: 25,
		melee: 25,
		ranged: 0,
		magic: 0,
		skills: [{name: 'advanced swordsmanship', level: 1}]
	},
	bonus: 0.03,
	cost: 2500,
	description: 'Chance to stun enemy with melee attack (3% per level).'
}, {
	name: 'critical shot',
	requirements: {
		level: 25,
		melee: 0,
		ranged: 25,
		magic: 0,
		skills: [{name: 'advanced archery', level: 1}]
	},
	bonus: 0.03,
	cost: 2500,
	description: 'Chance to inflict double damage with ranged attack (3% per level).'
}, {
	name: 'disintegrate',
	requirements: {
		level: 25,
		melee: 0,
		ranged: 0,
		magic: 25,
		skills: [{name: 'advanced sorcery', level: 1}]
	},
	bonus: 0.02,
	cost: 2500,
	description: 'Instant kill under a certain percentage of hp (2% per level).'
}, {
	name: 'reflect',
	requirements: {
		level: 10,
		melee: 0,
		ranged: 0,
		magic: 10,
		skills: []
	},
	bonus: 0.03,
	cost: 1000,
	description: 'Reflect magic damage to origin (3% chance per level).'
}, {
	name: 'parrying',
	requirements: {
		level: 10,
		melee: 10,
		ranged: 0,
		magic: 0,
		skills: []
	},
	bonus: 0.03,
	cost: 1000,
	description: 'Parry incoming melee attacks (-50% damage) and retaliate with bonus (+50%) damage (3% chance per level).'
}, {
	name: 'blocking',
	requirements: {
		level: 0,
		melee: 0,
		ranged: 0,
		magic: 0,
		skills: []
	},
	bonus: 0.05,
	cost: 250,
	description: 'Increase damage resistance while blocking (5% more damage block per level).'
}];

// presence: 0, //lowers enemy damage and resistances
// regeneration: 0,
// sneak: 0, //can walk past enemies
// alchemy: 0, //potions
// hunter: 0, //dmg bonus against beasts

module.exports = SkillList;
