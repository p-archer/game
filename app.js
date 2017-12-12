/* global require, process */

const { log } = require('./general');
const { MAP_SIZE, directions, states, attackTypes } = require('./constants');
const chalk = require('chalk');
const Map = require('./map');
const Hero = require('./hero');
const state = require('./state');

const stdin = process.openStdin();

console.clear = () => {
	process.stdout.write('\x1Bc');
};

init();

function init() {
	stdin.setRawMode(true);
	stdin.resume();
	stdin.setEncoding('utf-8');

	let map = new Map(MAP_SIZE);
	let hero = new Hero(map.getCurrentLevel().start);

	setupPrompt(map, hero);

	map.show(hero);
	showMenu();
	showPrompt();
}

function setupPrompt(map, hero) {
	stdin.on('data', (input) => {
		process.stdout.write(input + '\n');
		let handled = null;

		if (state.is(states.normal)) {
			handled = handleMainMenu(input, map, hero);
		}

		if (!handled && state.is(states.wait)) {
			state.prevState();
			state.prevState();
			map.show(hero);
			showMenu();
			handled = true;
		}

		if (!handled && state.is(states.characterSheet.main)) {
			switch (input) {
			case 'a':
				state.newState(states.characterSheet.weapons);
				handled = true;
				break;
			case 's':
				state.newState(states.characterSheet.armour);
				handled = true;
				break;
			case 'd':
				state.newState(states.characterSheet.skills);
				handled = true;
				break;
			}

			if (handled) {
				if (!state.is(states.normal))
					hero.showStats(state.get());

				showMenu();
			}
		}

		// if (state.is(states.characterSheet.weapons)) {
		// }
		// if (state.is(states.characterSheet.armour)) {
		// }
		if (!handled && state.is(states.characterSheet.skills)) {
			handled = handleSkillsInput(input, map, hero);
		}
		if (!handled && state.is(states.combat)) {
			handled = handleCombatInput(input, map, hero);
		}

		if (!handled && state.is(states.shop)) {
			handled = handleShopInput(input, map, hero);
		}

		if (!handled && !state.is(states.normal)) {
			if (input === 'q') {
				state.prevState();
				map.show(hero);
				showMenu();
				handled = true;
			}
		}

		if (!handled) {
			switch (input) {
			case '\u0003':
			case 'q':
				log('bye');
				log();
				process.exit();
				break;
			default:
				log('(' + input + ') unknown command');
			}
		}

		showPrompt();
	});
}

function interact(hero, map) {
	let level = map.getCurrentLevel();

	if (level.start.isSame(hero.position)) {
		if (map.prevLevel())
			map.show(hero);
		else
			log(chalk.red(' -- can\'t return to previous level'));
	}
	if (level.end.isSame(hero.position)) {
		if (map.nextLevel(hero))
			map.show(hero);
		else
			log(chalk.red(' -- can\'t access next level'));
	}

	let monster = level.isMonster(hero.position);
	if (monster) {
		state.newState(states.combat);
		showMenu();
	}

	let treasure = level.isTreasure(hero.position);
	if (treasure) {
		if (hero.openTreasure(treasure)) {
			level.removeTreasure(treasure);
			log('opened treasure, found ' + chalk.yellow(treasure.gold) + ' gold');
			log();
		} else {
			log(chalk.red(' -- failed to open treasure'));
			log();
		}
	}

	let shop = level.isShop(hero.position);
	if (shop) {
		state.newState(states.shop, shop.type);
		showMenu();
	}
}

function showMenu() {
	log();

	if (!state || state.is(states.normal)) {
		log(' --- menu ---');
		log('h\thelp (this menu)');
		log('c\thero stats');
		log('q\tquit');
		log();
		log(' --- movement --- ');
		log('w\tmove north');
		log('s\tmove south');
		log('a\tmove west');
		log('d\tmove east');
		log();
		log(' --- interaction --- ');
		log('e\topen/toggle');
	}

	if (state.is(states.characterSheet.main)) {
		log(' --- character sheet --- ');
		log('q\tback to main menu');
		log('a\tweapons');
		log('s\tarmour');
		log('d\tskills');
	}

	if (state.is(states.characterSheet.weapons)) {
		log(' --- weapons --- ');
		log('q\tback to character sheet');
	}
	if (state.is(states.characterSheet.armour)) {
		log(' --- armour --- ');
		log('q\tback to character sheet');
	}
	if (state.is(states.characterSheet.skills)) {
		if (state.get().param) {
			log(' --- ' + state.get().param + ' --- ');
			log('u\tupgrade');
			log('q\tback');
		} else {
			log(' --- skills --- ');
			log('q\tback to character sheet');
			log('[1-f]\tcorresponding skill');
		}
	}

	if (state.is(states.combat)) {
		log('a\tmelee attack');
		log('s\tranged attack');
		log('d\tmagic attack');
		log('x\tblock incoming attack');
		log('c\tcharacter sheet');
	}

	if (state.is(states.shop)) {
		let shopType = state.get().param;
		log(' --- ' + shopType + ' shop --- ');
		log('a\tbuy');
		log('s\tsell');
		log('d\texchange');
		log('q\tback');
	}

	log();
}

function showPrompt() {
	if (!state.is(states.wait))
		process.stdout.write(state.get().state + ' > ');
}

function handleCombatInput(input, map, hero) {
	let level = map.getCurrentLevel();
	let monster = level.isMonster(hero.position);
	let attackType = null;

	switch(input) {
	case 'x':
		hero.defend(monster);
		break;
	case 'a':
		attackType = attackTypes.melee;
		break;
	case 's':
		attackType = attackTypes.ranged;
		break;
	case 'd':
		attackType = attackTypes.magic;
		break;
	case 'q':
		state.prevState();
		return true;
	}

	if (attackType) {
		log(' -- attacking with ' + chalk.cyan(attackType));
		hero.attack(monster, attackType);
		if (monster.isAlive()) {
			monster.attack(hero, attackType);
		} else {
			level.removeMonster(monster);
			log(chalk.green(' -- enemy dead'));
			log(' -- looted ' + chalk.yellow(monster.gold) + ' gold');
			log(' -- gained ' + chalk.yellow(monster.xp.toFixed(2)) + ' xp');
			log();
			log(' * press any key to continue *');
			hero.gainXP(monster.xp);
			hero.giveGold(monster.gold);

			state.newState(states.wait);
			return true;
		}
	}

	//monster's turn
	attackType = monster.getPreferredAttackType();
	log();
	log(' -- enemy\'s turn');
	log(' -- attacking with ' + chalk.cyan(attackType));
	monster.attack(hero, attackType);
	hero.attack(monster, attackType);
	log();

	return true;
}

function handleSkillsInput(input, map, hero) {
	let param = state.get().param;
	if (!param) {
		let skills = Object.keys(hero.skills);
		let num = parseInt(input, 16);

		if (!isNaN(num) && num < skills.length) {
			let skill = skills[num];
			state.newState(states.characterSheet.skills, skill);
			console.clear();
			hero.showSkill(skill);
			showMenu();

			return true;
		}
	} else {
		if (input === 'u') {
			hero.upgradeSkill(param);
			return true;
		}
		if (input === 'q') {
			state.prevState();
			console.clear();
			hero.showStats(state);
			showMenu();
			return true;
		}
	}

	return false;
}

function handleMainMenu(input, map, hero) {
	switch (input) {
	case 'w':
		hero.move(map, directions.north);
		return true;
	case 's':
		hero.move(map, directions.south);
		return true;
	case 'a':
		hero.move(map, directions.west);
		return true;
	case 'd':
		hero.move(map, directions.east);
		return true;
	case 'c':
		state.newState(states.characterSheet.main);
		hero.showStats(state.get());
		showMenu();
		return true;
	case 'h':
		showMenu();
		return true;
	case '\t':
	case 'm':
		map.show(hero);
		return true;
	case 'e':
		interact(hero, map);
		return true;
	case 'q':
		input = '\u0003';
		/* fallthrough */
	default:
		return false;
	}
}

function handleShopInput(input, map, hero) {
	switch (input) {
	case 'a':
		return true;
	case 's':
		return true;
	case 'd':
		return true;
	default:
		return false;
	}
}
