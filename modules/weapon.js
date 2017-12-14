/* global module, require */

const { random, log, debug } = require('./general');
const chalk = require('chalk');

class Weapon {
	constructor(attackType, options) {
		this.attackType = attackType;
		this.precision = options.precision || 0;

		this.factor = options.factor || 1;
		if (!options.damage) {
			this.damage = options.min + (this.factor * (options.max - options.min) / 100);
		} else {
			this.damage = options.damage;
		}

		this.level = options.level || 0;
		this.xp = 0;
		this.nextLevel = 10 * Math.pow(1.2, this.level);

		debug('created ' + this.attackType + ' weapon with base damage ' + this.damage);
	}

	gainXP(amount) {
		this.xp += amount;
		debug('weapon ' + this.attackType + ' gained xp ' + amount);

		while (this.xp >= this.nextLevel)
			this.levelUp();
	}

	levelUp() {
		this.xp -= this.nextLevel;
		this.nextLevel *= 1.2;
		this.level++;

		log(chalk.green(' -- you became more proficient with ' + this.attackType + ' weapons'));
		debug('weapon ' + this.attackType + ' levelled up');
	}

	getDamage() {
		let a = this.damage * this.precision;
		let b = this.damage * (100 - this.precision);

		let damage = (a + random(b)) * Math.pow(1.1, this.level) / 100;
		return damage;
	}

	getBaseDamage() {
		return this.damage;
	}

	getMaxDamage() {
		return this.damage * Math.pow(1.1, this.level);
	}

	damageToString() {
		let value = this.damage * this.factor/100;
		if (value === 0)
			return 'none';
		if (value <= 1)
			return 'minimal';
		if (value <= 2.5)
			return 'weak';
		if (value < 5)
			return 'moderate';
		if (value <= 7.5)
			return 'strong';

		return 'overwhelming';
	}
}

module.exports = Weapon;
