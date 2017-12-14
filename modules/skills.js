/* global require, module */

const { attackTypes } = require('./constants');
const skillList = require('./skill.catalogue');

function Skills() {
	let self = this;

	self.getAvailable = getAvailable;
	self.getCoreSkills = getCoreSkills;

	init();

	return self;

	function init() {
	}

	function getCoreSkills() {
		let skills = skillList.filter((x) => {
			return x.core;
		});

		return skills;
	}

	function getAvailable(hero) {
		let skills = skillList.filter((x) => {
			if (x.requirements.level > hero.level)
				return false;
			if (x.requirements.melee > hero.getWeapon(attackTypes.melee).level)
				return false;
			if (x.requirements.ranged > hero.getWeapon(attackTypes.ranged).level)
				return false;
			if (x.requirements.magic > hero.getWeapon(attackTypes.magic).level)
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
