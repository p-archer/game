/* global module, require, process */

const { log, debug } = require('./general');
const { attackTypes, states, directions, MAX_SKILL_LEVEL } = require('./constants');
const Weapon = require('./weapon');
const Armour = require('./armour');
const state = require('./state');

const chalk = require('chalk');
const Point = require('./point');

class Hero {
	constructor(position) {
		this.hp = 10;
		this.maxhp = 10;
		this.level = 1;
		this.xp = 0;
		this.nextLevel = 10;
		this.speed = 10;
		this.gold = 0;
		this.weapons = [
			new Weapon(attackTypes.melee, {damage: 2, precision: 80}),
			new Weapon(attackTypes.ranged, {damage: 3, precision: 20}),
			new Weapon(attackTypes.magic, {damage: 1.8, precision: 100}),
		];
		this.armour = [
			new Armour(attackTypes.melee, 0),
			new Armour(attackTypes.ranged, 0),
			new Armour(attackTypes.magic, 0)
		];

		this.skills = {
			lockpick: {
				level: 0,
				description: 'Skill for opening locks'
			},
			inspection: {
				level: 0,
				description: 'This skill allows you to inspect enemies before battle. The higher the skill the more information you can gather.'
			},
			swordsmanship: {
				level: 0,
				attackType: attackTypes.melee,
				damageBonus: function() {
					return (this.level * 0.05) + 1;
				},
				description: 'Basic skill for using melee weapons.'
			},
			archery: {
				level: 0,
				attackType: attackTypes.ranged,
				damageBonus: function() {
					return (this.level * 0.05) + 1;
				},
				description: 'Basic skill for using ranged weapons.'
			},
			sorcery: {
				level: 0,
				attackType: attackTypes.magic,
				damageBonus: function() {
					return (this.level * 0.05) + 1;
				},
				description: 'Basic skill for using magic weapons.'
			}
			// presence: 0, //lowers enemy damage and resistances
			// swordsmanship: 0, //melee bonus
			// archery: 0, //ranged dmg bonus
			// sorcery: 0, //magic dmg bonus
			// regeneration: 0,
			// sneak: 0, //can walk past enemies
			// alchemy: 0, //potions
			// hunter: 0, //dmg bonus against beasts
			// skinning: 0, //loot bonus from beasts
			// criticals: 0, //critical chance + each attack type
			// blocking: 0, //block a large portion of dmg
			// dodging: 0, //dodge attack
			// parrying: 0, //retaliate bonus
		};
		this.skillPoints = 0;
		this.position = position;
	}

	move(map, dir) {
		let level = map.getCurrentLevel();
		let valid = true;

		switch (dir) {
		case directions.north:
			if (level.isValid(this.position.x, this.position.y-1)) {
				this.position = new Point(this.position.x, this.position.y-1);
			} else {
				valid = false;
			}
			break;
		case directions.south:
			if (level.isValid(this.position.x, this.position.y+1)) {
				this.position = new Point(this.position.x, this.position.y+1);
			} else {
				valid = false;
			}
			break;
		case directions.east:
			if (level.isValid(this.position.x+1, this.position.y)) {
				this.position = new Point(this.position.x+1, this.position.y);
			} else {
				valid = false;
			}
			break;
		case directions.west:
			if (level.isValid(this.position.x-1, this.position.y)) {
				this.position = new Point(this.position.x-1, this.position.y);
			} else {
				valid = false;
			}
			break;
		}

		if (valid) {
			debug('moved hero to ', this.position.x, this.position.y);
			map.show(this);
			level.showCellData(this);
		}
	}

	showStats() {
		switch (state.get().state) {
		case states.characterSheet.weapons:
			log();
			for (let weapon of this.weapons) {
				log(' --- ' + weapon.attackType + ' weapon --- ');
				log('damage\t' + weapon.getMaxDamage().toFixed(2) + ' (+' + ((this.getDamageBonus(weapon.attackType) - 1) * 100).toFixed(0) + '%)');
				log('precision\t' + weapon.precision);
				log('level\t' + weapon.level);
				log('xp\t' + weapon.xp.toFixed(2) + '/' + weapon.nextLevel.toFixed(2));
			}
			break;
		case states.characterSheet.armour:
			log();
			for (let armour of this.armour) {
				log(' --- ' + armour.attackType + ' armour --- ');
				log('resistance\t' + armour.amount.toFixed(2));
				log('level\t' + armour.level);
				log('xp\t' + armour.xp.toFixed(2) + '/' + armour.nextLevel.toFixed(2));
			}
			break;
		case states.characterSheet.skills:
			log();
			log(' --- skills --- ');
			for (let i=0; i<Object.keys(this.skills).length && i<16; i++) {
				let skill = Object.keys(this.skills)[i];
				let level = this.skills[skill].level;
				log(i.toString(16) + '. ' + skill + '\t' + level + '/' + MAX_SKILL_LEVEL);
			}
			log();
			log('unallocated skill points: ' + this.skillPoints);
			break;
		case states.characterSheet.main:
			console.clear();
			log(' --- stats --- ');
			log('hp\t' + this.hp.toFixed(2) + '/' + this.maxhp.toFixed(2));
			log('level\t' + this.level);
			log('xp\t' + this.xp.toFixed(2) + '/' + this.nextLevel.toFixed(2));
			log('gold\t' + this.gold);
			log('speed\t' + this.speed);
			break;
		default:
			log('xp: ' + this.xp.toFixed(2) + '/' + this.nextLevel.toFixed(2) + '\thp: ' + this.hp.toFixed(2) + '/' + this.maxhp.toFixed(2) + '\tlevel: ' + this.level);
		}
	}

	giveGold(gold) {
		this.gold += gold;
	}

	openTreasure(treasure) {
		if (this.skills.lockpick.level >= treasure.lock) {
			this.giveGold(treasure.gold);
			return true;
		} else {
			return null;
		}
	}

	takeDamage(amount, attackType) {
		let armour = this.armour.filter(x => x.attackType === attackType)[0];
		let damage = armour.getDamage(amount);

		log(' -- damaged by enemy ' + chalk.red(damage));

		this.hp -= damage;

		if (this.hp <= 0) {
			log(chalk.red(' -- you have been killed'));
			log(chalk.red(' -- game over'));
			log();
			process.exit();
		}

		//armour gains xp
		armour.gainXP(amount);
	}

	heal(amount) {
		this.hp += amount;
		if (this.hp > this.maxhp)
			this.hp = this.maxhp;
	}

	gainXP(amount) {
		this.xp += amount;

		while (this.xp >= this.nextLevel)
			this.levelUp();
	}

	levelUp() {
		this.xp -= this.nextLevel;
		this.nextLevel *= 1.2;
		this.maxhp *= 1.2;
		this.hp = this.maxhp;
		this.level++;

		this.skillPoints++;
		log(chalk.green(' -- level ' + this.level + ' reached, unspent skill points: ' + this.skillPoints));
		log();
	}

	attack(monster, attackType) {
		let weapon = this.weapons.filter(x => x.attackType === attackType)[0];
		let damage = weapon.getDamage();
		let bonus = this.getDamageBonus(attackType);

		monster.takeDamage(damage * bonus, attackType);
		weapon.gainXP(damage);
	}

	defend() {
	}

	getDamageBonus(attackType) {
		let skillMultiplier = 1;
		for (let skill in this.skills) {
			if (this.skills[skill].attackType === attackType && this.skills[skill].damageBonus())
				skillMultiplier *= this.skills[skill].damageBonus();
		}

		return skillMultiplier;
	}

	showSkill(skill) {
		log();
		log(' --- ' + skill + ' --- ');
		log('level\t' + this.skills[skill].level);
		log();
		log(' -- description:\n' + this.skills[skill].description);
	}

	upgradeSkill(skill) {
		if (this.skillPoints > 0) {
			if (this.skills[skill].level < MAX_SKILL_LEVEL) {
				this.skills[skill].level++;
				this.skillPoints--;

				log(chalk.green(' -- ' + skill + ' skill upgraded'));
				debug('skill ' + skill + ' upgraded');
			} else {
				log(chalk.red(' -- max level reached'));
			}
		} else {
			log(chalk.red(' -- not enough skill points'));
		}
	}
}

module.exports = Hero;
