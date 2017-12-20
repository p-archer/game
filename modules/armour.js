/* global module, require */

const { log, debug } = require('./general');
const { ARMOUR_GAIN_FACTOR, XP_GAIN_FACTOR } = require('./constants');
const chalk = require('chalk');

class Armour {
	constructor(attackType, amount) {
		this.attackType = attackType;
		this.amount = amount || 0;

		this.level = 1;
		this.xp = 0;
		this.nextLevel = 10;
	}

	gainXP(amount) {
		this.xp += amount;
		debug('armor ' + this.attackType + ' gained xp ' + amount);

		while (this.xp >= this.nextLevel)
			this.levelUp();
	}

	levelUp() {
		this.amount += ((100 - this.amount) * ARMOUR_GAIN_FACTOR);
		this.xp -= this.nextLevel;
		this.nextLevel *= XP_GAIN_FACTOR;
		this.level++;

		log(chalk.green(' -- you became more proficient with ' + this.attackType + ' armour'));
		debug('armour ' + this.attackType + ' levelled up');
	}

	getDamage(amount) {
		return Math.floor(amount * (100 - this.amount)) / 100;
	}

	amountToString() {
		if (this.amount === 0)
			return 'none';
		if (this.amount < 10)
			return 'minimal';
		if (this.amount < 25)
			return 'weak';
		if (this.amount < 50)
			return 'moderate';
		if (this.amount < 75)
			return 'strong';
		if (this.amount < 100)
			return 'overwhelming';

		return 'immune';
	}
}

module.exports = Armour;
