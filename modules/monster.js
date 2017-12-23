/* global module, require */

const { random, log, debug } = require('./general');
const { attackTypes, heroStates, HP_GAIN_FACTOR, species } = require('./constants');
const monsters = require('./monster.catalogue');
const chalk = require('chalk');
const Weapon = require('./weapon');
const Armour = require('./armour');

class Monster {
	constructor(level, position, mapType) {
		debug('generating new monster for mapType ' + mapType);

		if (!level)
			level = 1;

		this.type = getRandomType(level, mapType);
		console.log(this.type);
		debug('monster type', this.type.name);

		this.level = level;
		this.position = position;
		this.movement = this.type.movement;

		this.maxhp = Math.pow(HP_GAIN_FACTOR, level) * this.type.hp;
		this.hp = this.maxhp;
		this.gold = ((this.type.gold.max - this.type.gold.min) * random() / 100 + this.type.gold.min) * level;

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
		this.weapon = new Weapon({
			attackType: this.type.attack.attackType,
			level: random(level),
			min: this.type.attack.min,
			max: this.type.attack.max,
			range: this.type.attack.range
		});

		this.xp = Math.pow(HP_GAIN_FACTOR, level) * ((this.type.xp.max - this.type.xp.min) * (random() / 100) + this.type.xp.min);
	}

	isAlive() {
		return this.hp > 0;
	}

	takeDamage(combat) {
		let hero = combat.hero;
		let armour = this.armour.filter(x => x.attackType === hero.weapon.attackType)[0];
		let rawDamage = hero.getDamage(combat);
		let damage = armour.getDamage(rawDamage);
		this.hp -= damage;

		let inspection = hero.getSkill('inspection').level;
		switch (inspection) {
		case 0:
			if (damage > 0)
				log(chalk.green(' -- damaged enemy'));
			else
				log(chalk.red(' -- attack failed'));
			break;
		case 1:
			log(' -- damaged enemy ' + chalk.green(damage));
			break;
		default:
			log(' -- damaged enemy ' + chalk.green(damage) + ' (' + this.hp.toFixed(2) + '/' + this.maxhp.toFixed(2) + ' hp left)');
			break;
		}

		if (this.hp <= 0) {
			let bonusXP = getBonusXP(hero, this);
			let bonusGold = getBonusGold(hero, this);
			log(chalk.green(' -- enemy dead'));
			log(' -- looted ' + chalk.yellow(this.gold.toFixed(2)) + ' + ' + chalk.yellow(bonusGold.toFixed(2) + ' gold'));
			log(' -- gained ' + chalk.yellow(this.xp.toFixed(2)) + ' + ' + chalk.yellow(bonusXP.toFixed(2) + ' xp'));
			log();
			log(' * press any key to continue *');

			hero.gainXP(this.xp + bonusXP);
			hero.giveGold(this.gold + bonusGold);
		}

		return this.hp > 0;
	}

	attack(combat) {
		combat.hero.takeDamage(combat);

		if (combat.hero.state === heroStates.reflected) {
			combat.hero.state = heroStates.normal;
			this.takeDamage(combat);
		}
	}

	getPreferredAttackType() {
		if (!this.type.attack.preferred) {
			let weapons = this.weapons.slice();
			weapons.sort((a, b) => {
				return b.getDamage() - a.getDamage();
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

		if (level > 1 && level < 5) {
			log(' -- enemy hp: ' + this.hp.toFixed(2));
		}

		if (level === 3) {
			log();
			log(' -- ' + this.weapon.attackType + ' attack: ' + this.weapon.damageToString());
			log();
			for (let armour of this.armour) {
				log(' -- ' + armour.attackType + ' resistance: ' + armour.amountToString());
			}
		}

		if (level === 4) {
			log();
			log(' -- ' + this.weapon.attackType + ' attack: ' + chalk.red(this.weapon.getMinDamage().toFixed(2) + ' - ' + this.weapon.getMaxDamage().toFixed(2)));
			log();
			for (let armour of this.armour) {
				log(' -- ' + armour.attackType + ' resistance: ' + armour.amount.toFixed(2));
			}
		}

		if (level > 4) {
			log(' -- enemy hp: ' + this.hp.toFixed(2) + ' base: ' + this.type.hp);
			log();
			log(' -- ' + this.weapon.attackType + ' attack: ' + chalk.red(this.weapon.getMinDamage().toFixed(2) + ' - ' + this.weapon.getMaxDamage().toFixed(2)));
			log();
			for (let armour of this.armour) {
				log(' -- ' + armour.attackType + ' resistance: ' + armour.amount.toFixed(2));
			}
			log(' -- gold: ' + this.gold.toFixed(2));
		}
	}
}

function getRandomType(level, mapType) {
	let available = monsters.filter((x) => {
		return x.land.indexOf(mapType) !== -1 && x.minLevel <= level && x.maxLevel >= level;
	});

	return available[random(available.length)];
}

function getBonusGold(hero, monster) {
	let types = monster.type.species;

	if (types.has(species.beast)) {
		let skinning = hero.getSkill('skinning');
		if (skinning)
			return (monster.gold * (skinning.level * skinning.bonus));
	}

	return 0;
}

function getBonusXP(hero, monster) {
	return 0;
}

module.exports = Monster;
