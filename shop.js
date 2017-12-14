/* global require, module */

const { log, debug } = require('./general');
const { shops } = require('./constants');
const Skills = require('./skills');

class Shop {
	constructor(shopType, position) {
		this.type = shopType;
		this.position = position;

		debug('created ' + shopType + ' at ' + position);
	}

	showInventory(hero) {
		switch (this.type) {
		case shops.skills:
			showSkills(hero, true);
			break;
		}
	}

	getInventory(hero) {
		return getSkills(hero, true);
	}
}

function getSkills(hero, onlyNew) {
	let available = Skills.getAvailable(hero);

	if (onlyNew) {
		let known = hero.skills.map(x => x.name);
		available = available.filter((x) => {
			return known.indexOf(x.name) === -1;
		});
	}

	return available;
}

function showSkills(hero, onlyNew) {
	let skills = getSkills(hero, onlyNew);
	skills.forEach((x, index) => {
		log(''+index + '\t' + x.name);
	});
}

module.exports = Shop;
