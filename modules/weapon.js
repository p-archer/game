/* global module, require */

const { random, log, debug } = require('./general');
const { WEAPON_GAIN_FACTOR, XP_GAIN_FACTOR, attackTypes } = require('./constants');
const chalk = require('chalk');

class Weapon {
	constructor(weapon) {
		this.attackType = weapon.attackType;
		this.name = weapon.name;
		switch (weapon.attackType) {
		case attackTypes.melee:
			this.range = 1;
			break;
		case attackTypes.magic:
			this.range = 1000;
			break;
		}

		if (weapon.range)
			this.range = weapon.range;

		this.min = weapon.min;
		this.max = weapon.max;

		this.level = weapon.level || 0;
		this.xp = weapon.xp || 0;
		this.nextLevel = 10 * Math.pow(XP_GAIN_FACTOR, this.level);

		debug('created ' + this.attackType + ' weapon with base damage ' + this.min + ' - ' + this.max);
	}

	gainXP(amount) {
		this.xp += amount;
		debug('weapon ' + this.attackType + ' gained xp ' + amount);

		while (this.xp >= this.nextLevel)
			this.levelUp();
	}

	levelUp() {
		this.xp -= this.nextLevel;
		this.nextLevel *= XP_GAIN_FACTOR;
		this.level++;

		log(chalk.green(' -- you became more proficient with ' + this.attackType + ' weapons'));
		debug('weapon ' + this.attackType + ' levelled up');
	}

	getDamage(dist) {
		if (dist === 1) {
			if (this.attackType === attackTypes.ranged) {
				log(chalk.yellow(' -- ranged weapon penalty for close combat ') + chalk.red(50 + '% damage'));
				return 0.5 * (this.min + (random() * (this.max - this.min) / 100)) * Math.pow(WEAPON_GAIN_FACTOR, this.level);
			}

			if (this.attackType === attackTypes.magic) {
				log(chalk.yellow(' -- magic weapon penalty for close combat ') + chalk.red(50 + '% chance for failure'));
				if (random() < 50) {
					return (this.min + (random() * (this.max - this.min) / 100)) * Math.pow(WEAPON_GAIN_FACTOR, this.level);
				} else {
					return null;
				}
			}
		}

		if (dist <= this.range)
			return (this.min + (random() * (this.max - this.min) / 100)) * Math.pow(WEAPON_GAIN_FACTOR, this.level);

		if (dist < this.range * 2) {
			let precision = (1 - ((dist - this.range) / this.range)) * 100;
			log(chalk.yellow(' -- outside optimal range (chance to hit is ' + precision.toFixed(2) + '%)'));
			if (random() < precision)
				return (this.min + (random() * (this.max - this.min) / 100)) * Math.pow(WEAPON_GAIN_FACTOR, this.level);
		}

		return null;
	}

	damageToString() {
		let value = this.max;
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

	getMinDamage() {
		return this.min * Math.pow(WEAPON_GAIN_FACTOR, this.level);
	}

	getMaxDamage() {
		return this.max * Math.pow(WEAPON_GAIN_FACTOR, this.level);
	}
}

module.exports = Weapon;
