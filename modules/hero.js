/* global module, require, process */

const { log, debug, random } = require('./general');
const { attackTypes, heroClass, states, directions, MAX_SKILL_LEVEL, heroStates, HP_GAIN_FACTOR, XP_GAIN_FACTOR, WEAPON_GAIN_FACTOR } = require('./constants');
const Weapon = require('./weapon');
const Armour = require('./armour');
const Skills = require('./skills');
const { state } = require('./state');
const { WeaponList } = require('./weapons.catalogue');

const chalk = require('chalk');
const Point = require('./point');

class Hero {
	constructor(position) {
		this.hp = 10;
		this.maxhp = 10;
		this.level = 1;
		this.xp = 0;
		this.nextLevel = 10;
		this.movement = 10;
		this.gold = 0;
		this.weapon = null;
		this.skills = [];

		this.skillPoints = 0;
		this.position = position;
	}

	setClass(hc) {
		switch (hc) {
		case heroClass.warrior:
			this.weapon = new Weapon(WeaponList.get('short sword'));
			this.skills = Skills.getCoreSkills(hc);
			this.armour = [
				new Armour(attackTypes.melee, 15),
				new Armour(attackTypes.ranged, 10),
				new Armour(attackTypes.magic, 0)
			];
			break;
		case heroClass.archer:
			this.weapon = new Weapon(WeaponList.get('short bow'));
			this.skills = Skills.getCoreSkills(hc);
			this.armour = [
				new Armour(attackTypes.melee, 10),
				new Armour(attackTypes.ranged, 5),
				new Armour(attackTypes.magic, 0)
			];
			break;
		case heroClass.mage:
			this.weapon = new Weapon(WeaponList.get('short wand'));
			this.skills = Skills.getCoreSkills(hc);
			this.armour = [
				new Armour(attackTypes.melee, 0),
				new Armour(attackTypes.ranged, 5),
				new Armour(attackTypes.magic, 10)
			];
			break;
		}

		this.skills.forEach((x) => {
			x.level = 0;
		});
	}

	move(map, dir) {
		let level = map.current;
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
		let skillBonus = this.getDamageBonus(this.weapon.attackType);
		let levelBonus = Math.pow(WEAPON_GAIN_FACTOR, this.weapon.level);

		switch (state.get().state) {
		case states.characterSheet.weapons:
			log();
			log(' --- ' + this.weapon.attackType + ' weapon --- ');
			log('name:\t\t\t' + chalk.blueBright(this.weapon.name));
			log('base damage\t\t' + this.weapon.min.toFixed(2) + ' - ' + this.weapon.max.toFixed(2));
			log('skill bonus\t\t' + ((skillBonus-1) * 100).toFixed(0) + '%');
			log('level bonus\t\t' + ((levelBonus-1) * 100).toFixed(0) + '%');
			log('adjusted damage\t\t' + chalk.green((this.weapon.min * skillBonus * levelBonus).toFixed(2) + ' - ' + (this.weapon.max * skillBonus * levelBonus).toFixed(2)));
			log('range\t\t\t' + this.weapon.range);
			log('level\t\t\t' + this.weapon.level);
			log('xp\t\t\t' + this.weapon.xp.toFixed(2) + '/' + this.weapon.nextLevel.toFixed(2));
			break;
		case states.characterSheet.armour:
			log();
			for (let armour of this.armour) {
				log(' --- ' + armour.attackType + ' armour --- ');
				log('resistance\t' + armour.amount.toFixed(2));
				log('level\t\t' + armour.level);
				log('xp\t\t' + armour.xp.toFixed(2) + '/' + armour.nextLevel.toFixed(2));
			}
			break;
		case states.characterSheet.skills:
			log();
			log(' --- skills --- ');
			for (let i=0; i<this.skills.length && i<16; i++) {
				let skill = this.skills[i];
				log(i.toString(16) + '. ' + skill.name + '\t' + skill.level + '/' + MAX_SKILL_LEVEL);
			}
			log();
			log('unallocated skill points: ' + this.skillPoints);
			break;
		case states.characterSheet.main:
			console.clear();
			log(' --- stats --- ');
			log('hp\t\t' + this.hp.toFixed(2) + '/' + this.maxhp.toFixed(2));
			log('level\t\t' + this.level);
			log('xp\t\t' + this.xp.toFixed(2) + '/' + this.nextLevel.toFixed(2));
			log('gold\t\t' + this.gold.toFixed(2));
			log('movement\t' + this.movement);
			break;
		default:
			log('xp: ' + this.xp.toFixed(2) + '/' + this.nextLevel.toFixed(2) + '\thp: ' + this.hp.toFixed(2) + '/' + this.maxhp.toFixed(2) + '\tlevel: ' + this.level);
		}
	}

	giveGold(gold) {
		this.gold += gold;
	}

	openTreasure(treasure) {
		if (this.getSkill('lockpick').level >= treasure.lock) {
			this.giveGold(treasure.gold);
			return true;
		} else {
			return null;
		}
	}

	takeDamage(combat) {
		let monster = combat.monster;
		let distance = Math.abs(combat.heroPos - combat.monsterPos);
		let armour = this.armour.filter(x => x.attackType === monster.weapon.attackType)[0];
		let rawDamage = monster.weapon.getDamage(distance);
		let damage = armour.getDamage(rawDamage);

		if (this.state === heroStates.block) {
			let blocking = this.getSkill('blocking');

			if (blocking) {
				damage *= (0.5 + (blocking.level * blocking.bonus));
			} else {
				damage *= 0.5;
			}

			this.state = heroStates.normal;
		}

		let parry = this.getSkill('parrying');
		let dodge = this.getSkill('dodge');
		let reflect = this.getSkill('reflect');

		switch (monster.weapon.attackType) {
		case attackTypes.melee:
			if (parry) {
				if (random() < 100 * parry.level * parry.bonus) {
					damage *= 0.5;
					this.state = heroStates.parried;
					log(chalk.yellow(' -- parried enemy attack'));
				}
			}
			break;
		case attackTypes.ranged:
			if (dodge) {
				if (random() < 100 * dodge.level * dodge.bonus) {
					damage = 0;
					log(chalk.yellow(' -- dodged enemy attack'));
				}
			}
			break;
		case attackTypes.magic:
			if (reflect) {
				if (random() < 100 * reflect.level * reflect.bonus) {
					this.state = heroStates.reflected;
					log(chalk.yellow(' -- reflected enemy attack'));
				}
			}
			break;
		}

		this.hp -= damage;

		log(' -- damaged by enemy ' + chalk.red(damage) + ' (' + this.hp.toFixed(2) + '/' + this.maxhp.toFixed(2) + ' hp left)');

		if (this.hp <= 0) {
			log(chalk.red(' -- you have been killed'));
			log(chalk.red(' -- game over'));
			log();
			process.exit();
		}

		armour.gainXP(rawDamage);
	}

	heal() {
		let diff = Math.round(this.maxhp - this.hp);
		if (diff === 0) {
			log(chalk.yellow(' -- already at full hp'));
			return;
		}

		if (this.gold > diff) {
			this.gold -= diff;
			this.hp = this.maxhp;
			log(chalk.green(' -- healed'));
		} else {
			log(chalk.red(' -- you don\'t have enough gold'));
		}
	}

	gainXP(amount) {
		this.xp += amount;

		while (this.xp >= this.nextLevel)
			this.levelUp();
	}

	levelUp() {
		this.xp -= this.nextLevel;
		this.nextLevel *= XP_GAIN_FACTOR;
		this.maxhp *= HP_GAIN_FACTOR;
		this.hp = this.maxhp;
		this.level++;

		this.skillPoints++;
		log(chalk.green(' -- level ' + this.level + ' reached, unspent skill points: ' + this.skillPoints));
		log();
	}

	getDamage(combat) {
		let distance = Math.abs(combat.heroPos - combat.monsterPos);
		let damage = this.weapon.getDamage(distance);
		let bonus = this.getDamageBonus(this.attackType);

		if (this.state === heroStates.parried) {
			log(' -- applying bonus damage from parry');
			damage *= 1.5;
			this.state = heroStates.normal;
		}

		this.weapon.gainXP(damage * bonus);
		debug('weapon damaging enemy ' + damage * bonus);

		return damage * bonus;
	}

	attack(combat) {
		return combat.monster.takeDamage(combat);
	}

	block() {
		this.state = heroStates.block;
		log(' -- blocking');
	}

	getDamageBonus(attackType) {
		let skillMultiplier = 1;
		for (let i=0; i<this.skills.length; i++) {
			if (this.skills[i].attackType === attackType && this.skills[i].damageBonus)
				skillMultiplier += this.skills[i].damageBonus();
		}

		return skillMultiplier;
	}

	showSkill(skill) {
		log();
		log(' --- ' + skill.name + ' --- ');
		log('level\t' + skill.level);
		log();
		log(' -- description:\n' + skill.description);
	}

	upgradeSkill(skill) {
		if (this.skillPoints > 0) {
			if (skill.level < MAX_SKILL_LEVEL) {
				skill.level++;
				this.skillPoints--;

				log(chalk.green(' -- ' + skill.name + ' skill upgraded'));
				debug('skill ' + skill.name + ' upgraded');
			} else {
				log(chalk.red(' -- max level reached'));
			}
		} else {
			log(chalk.red(' -- not enough skill points'));
		}
	}

	getSkill(name) {
		return this.skills.filter((x) => {
			return x.name === name;
		})[0];
	}

	buySkill(skill) {
		this.gold -= skill.cost;
		this.skills.push(skill);
		this.getSkill(skill.name).level = 0;

		log(chalk.green(' -- skill ' + skill.name + ' has been bought'));
		log();
	}

	buyWeapon(weapon) {
		this.gold -= weapon.cost;
		weapon.level = this.weapon.level;
		weapon.xp = this.weapon.xp;
		this.weapon = new Weapon(weapon);

		log(' -- bought weapon ' + chalk.blueBright(weapon.name));
		log();
	}
}

module.exports = Hero;
