/* global require, process */

const { log } = require('./modules/general');
const { MAP_SIZE, attackTypes, directions, states, shops, heroClass } = require('./modules/constants');
const chalk = require('chalk');
const Map = require('./modules/map');
const Hero = require('./modules/hero');
const { state } = require('./modules/state');

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

	showMenu();
	showPrompt();
}

function setupPrompt(map, hero) {
	stdin.on('data', (input) => {
		process.stdout.write(input + '\n');
		let handled = null;

		if (state.is(states.characterSelection)) {
			switch (input) {
			case '1':
				hero.setClass(heroClass.warrior);
				handled = true;
				break;
			case '2':
				hero.setClass(heroClass.archer);
				handled = true;
				break;
			case '3':
				hero.setClass(heroClass.mage);
				handled = true;
				break;
			case 'q':
				input = '\u0003';
				break;
			}

			if (handled) {
				state.resetTo(states.normal);
				map.show(hero);
				showMenu();
				return;
			}
		}

		if (state.is(states.normal)) {
			handled = handleMainMenu(input, map, hero);
		}

		if (state.is(states.quit)) {
			switch (input) {
			case 'y':
				input = '\u0003';
				break;
			case 'n':
				handled = true;
				state.prevState();
				map.show(hero);
				showMenu();
				break;
			}
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
			case 'q':
			case '\u0003':
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
		let combat = startCombat(hero, monster);
		state.newState(states.combat, combat);
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
		console.clear();
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

	if (state.is(states.characterSelection)) {
		console.clear();
		log();
		log(' --- character selection --- ');
		log('1\twarrior (melee weapons)');
		log('2\tarcher (ranged weapons)');
		log('3\tmage (magic weapons and spells)');
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
		let combatState = state.get().param;
		let distance = Math.abs(combatState.heroPos - combatState.monsterPos);
		showCombatState(combatState);

		if (distance > 1)
			log('a\tapproach enemy');
		log('s\tattack with weapon (' + chalk.blueBright(combatState.hero.weapon.name) + ')');
		log('d\tcast spell or use ability');
		log('x\tguard stance');
		log('q\tflee');
	}

	if (state.is(states.quit)) {
		log('are you sure you want to quit (y/n)?');
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
	let combatState = state.get().param;
	let distance = Math.abs(combatState.heroPos - combatState.monsterPos);

	switch(input) {
	case 'x':
		hero.block(monster);
		break;
	case 'a':
		if (distance > 1) {
			combatState.heroPos = Math.min(combatState.monsterPos-1, combatState.heroPos + combatState.hero.movement);
			showCombatState(combatState);
		} else {
			log(chalk.red(' -- already in melee range'));
		}
		break;
	case 's':
		handleHeroAttack(combatState, level);
		break;
	case 'd':
		break;
	case 'q':
		state.prevState();
		return true;
	default:
		return false;
	}

	//monster's turn
	handleMonsterAttack(combatState, level);
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
	case '\t':
	case 'm':
		map.show(hero);
		return true;
	case 'e':
		interact(hero, map);
		return true;
	case 'q':
		state.newState(states.quit);
		showMenu();
		return true;
	}

	return false;
}

function handleShopInput(input, map, hero, shop) {
	if (shop.type === shops.weapons) {
		let num = parseInt(input, 16);
		let inventory = shop.getInventory(hero);
		if (!isNaN(num) && num < inventory.length) {
			let weapon = inventory[num];
			if (hero.gold >= weapon.cost) {
				hero.buyWeapon(weapon);
			} else {
				log(chalk.red(' -- not enough gold to buy skill'));
			}

			return true;
		}
	}

	if (shop.type === shops.skills) {
		let num = parseInt(input, 16);
		let inventory = shop.getInventory(hero);
		if (!isNaN(num) && num < inventory.length) {
			let skill = inventory[num];
			if (hero.gold >= skill.cost) {
				console.clear();
				hero.buySkill(skill);
				log(' --- inventory --- ');
				shop.showInventory(hero);
				showMenu();
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

function showCombatState(combat) {
	// console.clear();
	log();
	let str = '';

	for (let i=0; i<combat.size; i++) {
		if (i === combat.heroPos) {
			str += chalk.green('x');
			continue;
		}
		if (i === combat.monsterPos) {
			str += chalk.red('x');
			continue;
		}

		str += '_';
	}

	log(str);
	log();
}

function startCombat(hero, monster) {
	return { heroPos: 1, monsterPos: 31, hero: hero, monster: monster, size: 33, history: [] };
}

function handleHeroAttack(combatState, level) {
	let distance = Math.abs(combatState.heroPos - combatState.monsterPos);
	let hero = combatState.hero;
	let monster = combatState.monster;

	if (distance === 1) {
		log(' -- attacking enemy');
		if (hero.attack(combatState)) {
			monster.attack(combatState);
		} else {
			level.removeMonster(monster);
			state.newState(states.wait);
		}
	} else {
		if (hero.weapon.attackType === attackTypes.melee) {
			log(chalk.red(' -- not in melee range'));
		} else {
			log(' -- attacking enemy');
			if (!hero.attack(combatState)) {
				level.removeMonster(monster);
				state.newState(states.wait);
			}
		}
	}
}

function handleMonsterAttack(combatState, level) {
	let distance = Math.abs(combatState.heroPos - combatState.monsterPos);
	let hero = combatState.hero;
	let monster = combatState.monster;

	if (monster.hp <= 0)
		return;

	log();
	log(' -- enemy\'s turn');

	if (distance === 1) {
		log(' -- attacking with ' + chalk.cyan(monster.weapon.attackType));

		monster.attack(combatState);
		if (!hero.attack(combatState)) {
			level.removeMonster(monster);
			state.newState(states.wait);
		}
	} else {
		if (monster.weapon.attackType === attackTypes.melee || distance > monster.weapon.range) {
			log(' -- approaching hero');
			combatState.monsterPos = Math.max(combatState.heroPos+1, combatState.monsterPos - monster.movement);
			showCombatState(combatState);
		} else {
			log(' -- attacking with ' + chalk.cyan(monster.weapon.attackType));
			monster.attack(combatState);
		}
	}
}
