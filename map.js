/* global require, module */

const { log, random } = require('./general');
const chalk = require('chalk');
const Point = require('./point');
const Level = require('./level');
const { mapTypes } = require('./constants');

class Map {
	constructor() {
		let type = getRandomLevelType();
		let initialLevel = new Level(null, type);
		this.current = initialLevel;
	}

	prevLevel() {
		if (this.current.parent) {
			this.current = this.current.parent;
			return true;
		}

		return null;
	}

	show(hero) {
		let size = this.current.data.length;
		console.clear();
		log(' -- map: ' + this.current.level + ' type: ' + this.current.type);

		let line = (new Array(size+2).fill('\u25a7')).join(' ');
		log(chalk.gray(line));

		for (let i=0; i<size; i++) {
			let str = this.current.data[i].reduce((acc, x, index) => {
				let point = new Point(index, i);
				if (hero && hero.position.isSame(point))
					return acc + ' ' + chalk.cyan('x');
				if (point.isSame(this.current.start))
					return acc + ' ' + chalk.green('a');

				let isEnd = this.current.end.filter((x) => {
					return point.isSame(x.position);
				});
				if (isEnd.length > 0)
					return acc + ' ' + chalk.green('b');

				if (this.current.isMonster(point))
					return acc + ' ' + chalk.redBright('o');
				if (this.current.isShop(point))
					return acc + ' ' + chalk.green('s');
				if (this.current.isTreasure(point))
					return acc + ' ' + chalk.yellow('$');

				switch (x) {
				case 0:
					return acc + ' ' + chalk.gray('\u25a7');
				default:
					return acc + ' ' + chalk.gray('\u25e6');
				}
			}, ''); //add borders

			log(chalk.gray('\u25a7') + str + ' ' + chalk.gray('\u25a7'));
		}
		log(chalk.gray(line));

		if (hero)
			hero.showStats();
		log();
	}

	generateNewLevel(hero, forceNew) {
		let type = this.current.type;
		if (forceNew || this.current.level % 5 === 0)
			type = getRandomLevelType();
		return new Level(this.current, type, hero);
	}

	setLevel(level) {
		this.current = level;
	}
}

function getRandomLevelType() {
	let index = random(Object.keys(mapTypes).length);
	let key = Object.keys(mapTypes)[index];

	return mapTypes[key];
}

module.exports = Map;
