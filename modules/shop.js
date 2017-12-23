/* global require, module */

const { log, debug } = require('./general');
const { shops } = require('./constants');
const Skills = require('./skills');
const Weapon = require('./weapon');
const { WeaponList } = require('./weapons.catalogue');
const chalk = require('chalk');

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
		case shops.weapons:
			showWeapons(hero);
			break;
		}
	}

	getInventory(hero) {
		switch (this.type) {
		case shops.skills:
			return getSkills(hero, true);
		case shops.weapons:
			return getWeapons(hero);
		}
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
		log(''+index + '\t' + x.name.toFixed(32) + '\tcost: ' + chalk.yellow((x.cost ? x.cost : 0) + ' gold'));
	});
}

function getWeapons(hero) {
	return WeaponList.getAvailable(hero);
}

function showWeapons(hero) {
	let weapons = getWeapons(hero);
	log();
	log('current weapon damage\t' + hero.weapon.getMinDamage().toFixed(2) + ' - ' + hero.weapon.getMaxDamage().toFixed(2));
	log();
	weapons.forEach((x, index) => {
		let weapon = new Weapon(x);
		weapon.level = hero.weapon.level;
		log(''+index + '\t' + chalk.blueBright(x.name));
		log('\tdamage\t ' + chalk.green(weapon.getMinDamage().toFixed(2) + ' - ' + weapon.getMaxDamage().toFixed(2)));
		log('\trange\t ' + weapon.range);
		log('\tcost\t ' + chalk.yellow(x.cost + ' gold'));
		log();
	});
}

module.exports = Shop;
