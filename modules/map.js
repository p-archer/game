/* global require, module */

const { log, random, getWallChar, getFreeChar } = require('./general');
const chalk = require('chalk');
const Point = require('./point');
const Level = require('./level');
const Hero = require('./hero.coffee');
const { mapTypes } = require('./constants');

class Map {
	constructor(hero) {
		let type = getRandomLevelType();
		let initialLevel = new Level(null, type, hero);
		this.current = initialLevel;
	}

	show(hero, state) {
		let size = this.current.data.length;
		console.clear();
		let wall = getWallChar();
		let free = getFreeChar();
		log(' -- map: ' + this.current.level + ' type: ' + this.current.type);

		let line = (new Array(size+2).fill(wall)).join(' ');
		log(chalk.gray(line));

		for (let i=0; i<size; i++) {
			let str = this.current.data[i].reduce((acc, x, index) => {
				let point = new Point(index, i);
				if (hero && hero.position.isSame(point))
					return acc + ' ' + chalk.cyan('x');
				if (point.isSame(this.current.start) && this.current.level !== 1)
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
					return acc + ' ' + chalk.gray(wall);
				default:
					return acc + ' ' + chalk.gray(free);
				}
			}, ''); //add borders

			log(chalk.gray(wall) + str + ' ' + chalk.gray(wall));
		}

		log(chalk.gray(line));

		if (hero)
			Hero.showStats(hero, state);
		log();
	}

	generateNewLevel(hero, forceNew) {
		let type = this.current.type;
		let depth = getDepth(this.current);
		if (forceNew || depth % 10 === 0)
			type = getRandomLevelType();
		return new Level(this.current, type, hero);
	}

	setLevel(level) {
		this.current = level;
	}
}

function getDepth(level) {
	if (!level.parent)
		return 1;
	if (level.parent.type !== level.type)
		return 1;

	return 1 + getDepth(level.parent);
}

function getRandomLevelType() {
	let index = random(Object.keys(mapTypes).length);
	let key = Object.keys(mapTypes)[index];

	return mapTypes[key];
}

module.exports = Map;
