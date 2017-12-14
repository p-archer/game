/* global require, process */

const { log } = require('./general');
const { MAP_SIZE, directions, states, attackTypes, shops, species } = require('./constants');
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
	let hero = new Hero(map.current.start);

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

		if (!handled && state.is(states.characterSheet.skills)) {
			handled = handleSkillsInput(input, map, hero);
		}
		if (!handled && state.is(states.combat)) {
			handled = handleCombatInput(input, map, hero);
		}

		// if (!handled && state.is(states.shops.skills)) {
		// 	// handled = handleShopInput(input, map, hero);
		// 	let shop = state.get().param;
		// 	showMenu();
		// 	log(' --- available skills --- ');
		// 	shop.showInventory(hero);
		// }

		if (!handled && state.is(states.shop)) {
			let shop = state.get().param;
			handled = handleShopInput(input, map, hero, shop);
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
	let level = map.current;

	if (level.start.isSame(hero.position)) {
		if (map.prevLevel())
			map.show(hero);
		else
			log(chalk.red(' -- can\'t return to previous level'));
	}
	level.end.forEach((x, index) => {
		if (x.position.isSame(hero.position)) {
			if (!x.nextLevel) {
				x.nextLevel = map.generateNewLevel(hero, index !== 0);
			}

			map.setLevel(x.nextLevel);
			map.show(hero);
		}
	});

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
		state.newState(states.shop, shop);
		log(' --- inventory --- ');
		shop.showInventory(hero);
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
			log(' --- ' + state.get().param.name + ' --- ');
			log('u\tupgrade');
			log('q\tback');
		} else {
			log(' --- skills --- ');
			log('q\tback to character sheet');
			log('[0-f]\tcorresponding skill');
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
		log('q\tback');
		log('f\tfull heal (1 gold per hp)');
	}

	log();
}

function showPrompt() {
	if (!state.is(states.wait))
		process.stdout.write(state.get().state + ' > ');
}

function handleCombatInput(input, map, hero) {
	let level = map.current;
	let monster = level.isMonster(hero.position);
	let attackType = null;

	switch(input) {
	case 'x':
		hero.block(monster);
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
	default:
		return false;
	}

	if (attackType) {
		log(' -- attacking with ' + chalk.cyan(attackType));
		if (hero.attack(monster, attackType)) {
			monster.attack(hero, attackType);
		} else {
			let xp = monster.xp;
			let bonusXP = getBonusXP(hero, monster);
			let gold = monster.gold;
			let bonusGold = getBonusGold(hero, monster);
			level.removeMonster(monster);
			log(chalk.green(' -- enemy dead'));
			log(' -- looted ' + chalk.yellow(gold.toFixed(2)) + ' + ' + chalk.yellow(bonusGold.toFixed(2) + ' gold'));
			log(' -- gained ' + chalk.yellow(xp.toFixed(2)) + ' + ' + chalk.yellow(bonusXP.toFixed(2) + ' xp'));
			log();
			log(' * press any key to continue *');

			hero.gainXP(xp + bonusXP);
			hero.giveGold(gold + bonusGold);

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
	if (!hero.attack(monster, attackType)) {
		let xp = monster.xp;
		let bonusXP = getBonusXP(hero, monster);
		let gold = monster.gold;
		let bonusGold = getBonusGold(hero, monster);
		level.removeMonster(monster);
		log(chalk.green(' -- enemy dead'));
		log(' -- looted ' + chalk.yellow(gold.toFixed(2)) + ' + ' + chalk.yellow(bonusGold.toFixed(2) + ' gold'));
		log(' -- gained ' + chalk.yellow(xp.toFixed(2)) + ' + ' + chalk.yellow(bonusXP.toFixed(2) + ' xp'));
		log();
		log(' * press any key to continue *');

		hero.gainXP(xp + bonusXP);
		hero.giveGold(gold + bonusGold);

		state.newState(states.wait);
		return true;
	}
	log();

	return true;
}

function handleSkillsInput(input, map, hero) {
	let param = state.get().param;
	if (!param) {
		let skills = hero.skills;
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

function handleShopInput(input, map, hero, shop) {
	if (shop.type === shops.skills) {
		let num = parseInt(input, 16);
		let inventory = shop.getInventory(hero);
		if (!isNaN(num) && num < inventory.length) {
			let skill = inventory[num];
			if (hero.gold >= skill.cost) {
				hero.buySkill(skill);
			} else {
				log(chalk.red(' -- not enough gold to buy skill'));
			}

			return true;
		}
	}

	switch (input) {
	case 'f':
		hero.heal();
		return true;
	default:
		return false;
	}
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
