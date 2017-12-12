/* global module, require */

const { random, log, debug } = require('./general');
const { attackTypes } = require('./constants');
const monsters = require('./monster.catalogue');
const chalk = require('chalk');
const Weapon = require('./weapon');
const Armour = require('./armour');

//generate monsters based on hero level and level type - forest, graveyard, jungle, desert, dungeon, tower
class Monster {
	constructor(level, type, position) {
		debug('generating new monster');

		if (!level)
			level = 1;

		if (!type)
			this.type = getRandomType(level);
		else
			this.type = type;

		this.level = level;
		this.position = position;

		this.maxhp = level * this.type.hp;
		this.hp = this.maxhp;
		this.gold = random(level * (this.type.gold.max - this.type.gold.min)) + (this.type.gold.min * level);

		debug('monster type', this.type.name);

		let factors = {
			armour: {
				melee: random(),
				ranged: random(),
				magic: random()
			},
			melee: random(),
			ranged: random(),
			magic: random()
		};

		debug('monster factors');
		debug(' - armour: ', factors.armour.melee, factors.armour.ranged, factors.armour.magic);
		debug(' - attack: ', factors.melee, factors.ranged, factors.magic);

		this.armour = [
			new Armour(attackTypes.melee, (factors.armour.melee / 100 * (this.type.armour.melee.max - this.type.armour.melee.min)) + (this.type.armour.melee.min)),
			new Armour(attackTypes.ranged, (factors.armour.ranged / 100 * (this.type.armour.ranged.max - this.type.armour.ranged.min)) + (this.type.armour.ranged.min)),
			new Armour(attackTypes.magic, (factors.armour.magic / 100 * (this.type.armour.magic.max - this.type.armour.magic.min)) + (this.type.armour.magic.min))
		];
		this.weapons = [
			new Weapon(attackTypes.melee, {
				factor: factors.melee,
				level: level,
				min: this.type.attack.melee.min,
				max: this.type.attack.melee.max,
				precision: this.type.attack.melee.precision
			}),
			new Weapon(attackTypes.ranged, {
				factor: factors.ranged,
				level: level,
				min: this.type.attack.ranged.min,
				max: this.type.attack.ranged.max,
				precision: this.type.attack.ranged.precision
			}),
			new Weapon(attackTypes.magic, {
				factor: factors.magic,
				level: level,
				min: this.type.attack.magic.min,
				max: this.type.attack.magic.max,
				precision: this.type.attack.magic.precision
			}),
		];

		let xpFactor = (factors.armour.melee + factors.armour.ranged + factors.armour.magic
						+ factors.melee + factors.ranged + factors.magic) / 6;
		this.xp = (xpFactor / 100 * level * (this.type.xp.max - this.type.xp.min)) + (this.type.xp.min * level);

		debug('monster xp factor', xpFactor, this.xp);
	}

	isAlive() {
		return this.hp > 0;
	}

	takeDamage(amount, attackType) {
		let armour = this.armour.filter(x => x.attackType === attackType)[0];
		let damage = armour.getDamage(amount);
		this.hp -= damage;

		log(' -- damaged enemy ' + chalk.red(damage));
	}

	attack(hero, attackType) {
		let weapon = this.weapons.filter(x => x.attackType === attackType)[0];
		let damage = weapon.getDamage();

		hero.takeDamage(damage, attackType);
	}

	getPreferredAttackType() {
		if (!this.type.attack.preferred) {
			let weapons = this.weapons.slice();
			weapons.sort((a, b) => {
				return  (b.damage * (b.precision + (100 - b.precision)/2)) - (a.damage * (a.precision + (100 - a.precision)/2));
			});

			return weapons[0].attackType;
		} else {
			return this.type.attack.preferred;
		}
	}

	showStats(level) {
		log(' -- enemy type: ' + chalk.redBright(this.type.name));

		if (level > 0) {
			log(' -- level: ' + this.level);
		}

		if (level > 1) {
			log(' -- enemy hp: ' + this.hp);
		}

		if (level === 3) {
			log();
			for (let weapon of this.weapons) {
				log(' -- ' + weapon.attackType + ' attack: ' + weapon.damageToString());
			}
			log();
			for (let armour of this.armour) {
				log(' -- ' + armour.attackType + ' resistance: ' + armour.amountToString());
			}
		}

		if (level > 3) {
			log();
			for (let weapon of this.weapons) {
				log(' -- ' + weapon.attackType + ' attack: ' + weapon.getMaxDamage().toFixed(2));
			}
			log();
			for (let armour of this.armour) {
				log(' -- ' + armour.attackType + ' resistance: ' + armour.amount.toFixed(2));
			}
		}

		if (level > 4) {
			log(' -- gold: ' + this.gold);
		}
	}
}

function getRandomType(level) {
	let typeList = Object.keys(monsters);
	let selected = null;
	while (selected == null) {
		let index = random(typeList.length);
		let monster = monsters[typeList[index]];
		if (monster.minLevel <= level)
			selected = index;
	}
	return monsters[typeList[selected]];
}

module.exports = Monster;
