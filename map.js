/* global require, module */

const { log } = require('./general');
const chalk = require('chalk');
const Point = require('./point');
const Level = require('./level');

class Map {
	constructor(mapSize) {
		this.mapSize = mapSize;
		this.currentLevel = 0;

		let initialLevel = new Level(mapSize);
		this.levels = [initialLevel];
	}

	nextLevel(hero) {
		if (this.currentLevel + 1 >= this.levels.length) {
			let newlevel = new Level(this.mapSize, hero);
			this.levels.push(newlevel);
		}

		this.currentLevel++;
		return true;
	}

	prevLevel() {
		if (this.currentLevel > 0) {
			this.currentLevel--;
			return true;
		}

		return null;
	}

	getCurrentLevel() {
		return this.levels[this.currentLevel];
	}

	show(hero) {
		let level = this.getCurrentLevel();
		let size = level.data.length;
		console.clear();
		log(' -- map: ' + this.currentLevel);

		for (let i=0; i<size; i++) {
			let str = level.data[i].reduce((acc, x, index) => {
				let point = new Point(index, i);
				if (hero && hero.position.isSame(point))
					return acc + ' ' + chalk.cyan('x');
				if (point.isSame(level.start))
					return acc + ' ' + chalk.green('a');
				if (point.isSame(level.end))
					return acc + ' ' + chalk.green('b');
				if (level.isMonster(point))
					return acc + ' ' + chalk.redBright('o');
				if (level.isShop(point))
					return acc + ' ' + chalk.green('s');
				if (level.isTreasure(point))
					return acc + ' ' + chalk.yellow('$');

				switch (x) {
				case 0:
					return acc + ' ' + chalk.gray('\u25a7');
				default:
					return acc + ' ' + chalk.gray('\u25e6');
				}
			}, ''); //add borders

			log(str);
		}
		if (hero)
			hero.showStats();
		log();
	}
}

module.exports = Map;
