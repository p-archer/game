/* global require, module */

const { attackTypes } = require('./constants');
const skillList = require('./skill.catalogue');

function Skills() {
	let self = this;

	self.getAll = getAll;
	self.getAvailable = getAvailable;
	self.getCoreSkills = getCoreSkills;

	init();

	return self;

	function init() {
	}

	function getCoreSkills(hc) {
		let skills = skillList.filter((x) => {
			return x.core && x.core.has(hc);
		});

		return skills;
	}

	function getAll() {
		return skillList;
	}

	function getAvailable(hero) {
		let skills = skillList.filter((x) => {
			if (x.requirements.level > hero.level)
				return false;

			if (x.requirements.melee && (hero.weapon.attackType !== attackTypes.melee || x.requirements.melee > hero.weapon.level))
				return false;

			if (x.requirements.ranged && (hero.weapon.attackType !== attackTypes.ranged || x.requirements.ranged > hero.weapon.level))
				return false;

			if (x.requirements.magic && (hero.weapon.attackType !== attackTypes.magic || x.requirements.magic > hero.weapon.level))
				return false;

			let skillsMet = true;
			x.requirements.skills.forEach((x) => {
				let skill = hero.getSkill(x.name);
				if (!skill || skill.level < x.level)
					skillsMet = false;
			});

			return skillsMet;
		});

		return skills;
	}
}

module.exports = Skills();
