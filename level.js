/* global require, module */

const { random, log } = require('./general');
const { CHANCE_FOR_TREASURE, CHANCE_FOR_MONSTER, CHANCE_FOR_SHOP, shops } = require('./constants');
const Point = require('./point');
const Monster = require('./monster');

class Level {
	constructor(size, hero) {
		this.size = size;

		if (!hero)
			hero = {
				position: new Point(random(size), random(size)),
				level: 1
			};

		this.start = hero.position;
		this.data = generateRoutes(this.size, hero.position);
		this.end = findFurthest(this.data, hero.position);
		this.treasures = generateTreasures(this, hero.level);
		this.monsters = generateMonsters(this, hero.level);
		this.shops = generateShops(this);
	}

	isTreasure(point) {
		return this.treasures.filter((x) => {
			return point.isSame(x.position);
		})[0];
	}

	isMonster(point) {
		return this.monsters.filter((x) => {
			return point.isSame(x.position);
		})[0];
	}

	isShop(point) {
		return this.shops.filter((x) => {
			return point.isSame(x.position);
		})[0];
	}

	isValid(a, b) {
		if (b != null) {
			return isValid(this.data, new Point(a, b));
		} else {
			return isValid(this.data, a);
		}
	}

	isFree(point) {
		if (!this.isValid(point))
			return false;
		if (this.treasures && this.isTreasure(point))
			return false;
		if (this.monsters && this.isMonster(point))
			return false;
		if (this.shops && this.isShop(point))
			return false;
		return true;
	}

	showCellData(hero) {
		if (this.start.isSame(hero.position)) {
			log('stairs to previous level');
			log();
			return;
		}

		if (this.end.isSame(hero.position)) {
			log('stairs to next level');
			log();
			return;
		}

		let monster = this.isMonster(hero.position);
		if (monster) {
			log('you have found a hostile entity');
			monster.showStats(hero.skills.inspection.level);
			log();
			return;
		}

		let treasure = this.isTreasure(hero.position);
		if (treasure) {
			log('you have found a treasure chest');
			log(' -- lock difficulty: ' + treasure.lock);
			log();
			return;
		}

		let shop = this.isShop(hero.position);
		if (shop) {
			log('you have found ' + findPronoun(shop.type) + shop.type + ' shop');
			log();
			return;
		}

		log('nothing here');
		log();
	}

	removeTreasure(treasure) {
		this.treasures = this.treasures.filter((x) => {
			return !x.position.isSame(treasure.position);
		});
	}

	removeMonster(monster) {
		this.monsters = this.monsters.filter((x) => {
			return !x.position.isSame(monster.position);
		});
	}
}

function generateMatrix(size) {
	let data = [];
	for (let i=0; i<size; i++) {
		let row = new Array(size).fill(0);
		data.push(row);
	}

	return data;
}

function generateTreasures(level, heroLevel) {
	let size = level.size;
	let treasures = [];

	if (!heroLevel)
		heroLevel = 1;

	for (let i=0; i<size; i++) {
		for (let j=0; j<size; j++) {
			if (level.end.isSame({x: j, y: i})) {
				continue;
			}
			if (level.start.isSame({x: j, y: i})) {
				continue;
			}
			if (level.data[i][j] === 1 && random() < CHANCE_FOR_TREASURE) {
				let diff = random(heroLevel/5)+1;
				treasures.push({
					position: new Point(j, i),
					gold: (diff * 2) + random(diff * 3),
					lock: diff,
				});
			}
		}
	}

	return treasures;
}

function findFurthest(level, point) {
	let q = [{x: point.x, y: point.y, dist: 0}];
	let current;
	while (q.length > 0) {
		current = q.shift();

		if (isValid(level, {x: current.x+1, y: current.y}) && level[current.y][current.x+1] !== 1) {
			q.push({x: current.x+1, y: current.y, dist: current.dist+1});
		}
		if (isValid(level, {x: current.x-1, y: current.y}) && level[current.y][current.x-1] !== 1) {
			q.push({x: current.x-1, y: current.y, dist: current.dist+1});
		}
		if (isValid(level, {x: current.x, y: current.y-1}) && level[current.y-1][current.x] !== 1) {
			q.push({x: current.x, y: current.y-1, dist: current.dist+1});
		}
		if (isValid(level, {x: current.x, y: current.y+1}) && level[current.y+1][current.x] !== 1) {
			q.push({x: current.x, y: current.y+1, dist: current.dist+1});
		}

		level[current.y][current.x] = 1;
	}

	return new Point(current.x, current.y);
}

function isValid(levelData, point) {
	let size = levelData.length;
	if (point.x >= size || point.x < 0 || point.y < 0 || point.y >= size) {
		return false;
	}

	if (levelData[point.y][point.x] === 0) {
		return false;
	}

	return true;
}

function ripple(level, point, branch) {
	let size = level.length;
	if (point.x >= size || point.x < 0 || point.y < 0 || point.y >= size) {
		return;
	}

	if (level[point.y][point.x] !== 0) {
		return;
	}

	if (!branch) {
		branch = 0;
	}

	if (random(100) < (100 - (branch*3))) {
		level[point.y][point.x] = 100;

		ripple(level, { x: point.x+1, y: point.y }, branch+1);
		ripple(level, { x: point.x-1, y: point.y }, branch+1);
		ripple(level, { x: point.x, y: point.y+1 }, branch+1);
		ripple(level, { x: point.x, y: point.y-1 }, branch+1);
	}

	return branch;
}

function generateRoutes(size, start) {
	let matrix = generateMatrix(size);
	ripple(matrix, start);

	return matrix;
}

function generateMonsters(level, heroLevel) {
	let size = level.size;
	let monsters = [];

	if (!heroLevel)
		heroLevel = 1;

	let minLevel = Math.max(0, heroLevel - 3);
	let monsterLevel = minLevel < 1 ? random(heroLevel) + 1 : random(6) + minLevel;

	for (let i=0; i<size; i++) {
		for (let j=0; j<size; j++) {
			let point = new Point(j, i);
			if (level.end.isSame(point)) {
				continue;
			}
			if (level.start.isSame(point)) {
				continue;
			}
			if (level.data[i][j] === 1 && random() < CHANCE_FOR_MONSTER) {
				monsters.push(new Monster(monsterLevel, null, point));
			}
		}
	}

	return monsters;
}

function generateShops(level) {
	if (random() < CHANCE_FOR_SHOP) {
		let spot = findFreeSpot(level);
		if (spot) {
			return [{
				type: getRandomShopType(),
				position: spot
			}];
		}
	}

	return [];
}

function getRandomShopType() {
	let index = random(Object.keys(shops).length);
	let key = Object.keys(shops)[index];
	return shops[key];
}

function findFreeSpot(level) {
	let freeSpots = [];
	for (let i=0; i<level.data.length; i++) {
		for (let j=0; j<level.data.length; j++) {
			let point = new Point(i, j);
			if (level.isFree(point))
				freeSpots.push(point);
		}
	}

	if (freeSpots.length > 0)
		return freeSpots[random(freeSpots.length)];

	return null;
}

function findPronoun(str) {
	return (['a', 'e', 'i', 'o', 'u'].indexOf(str[0]) !== -1 ? 'an ' : 'a ');
}

module.exports = Level;
