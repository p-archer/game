/* global require, module */

const { random, log, debug } = require('./general');
const { CHANCE_FOR_TREASURE, CHANCE_FOR_MONSTER, CHANCE_FOR_SHOP, shops, MAP_SIZE, directions } = require('./constants');
const Point = require('./point');
const Monster = require('./monster');
const Shop = require('./shop');

class Level {
	constructor(parent, type, hero) {
		if (!hero)
			hero = {
				position: new Point(random(MAP_SIZE), random(MAP_SIZE)),
				level: 1
			};

		this.type = type;
		this.parent = parent;
		if (parent)
			this.level = parent.level + 1;
		else
			this.level = 1;

		this.children = [];
		this.start = hero.position;
		this.data = generateRoutes(MAP_SIZE, hero.position);
		this.end = [{position: findFurthest(this.data, hero.position)}];
		this.treasures = generateTreasures(this, hero.level);
		this.monsters = generateMonsters(this, hero.level);
		this.shops = generateShops(this);

		if (random() < 10)
			this.end.push({position: findFreeSpot(this)});

		debug('monsters', this.monsters.length);
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

	isEnd(point) {
		return this.end.filter((x) => {
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
		if (this.start.isSame(point))
			return false;
		if (this.isEnd(point))
			return false;
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

		if (this.isEnd(hero.position)) {
			log('stairs to next level');
			log();
			return;
		}

		let monster = this.isMonster(hero.position);
		if (monster) {
			log('you have found a hostile entity');
			monster.showStats(hero.getSkill('inspection').level);
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
	let treasures = [];

	if (!heroLevel)
		heroLevel = 1;

	for (let i=0; i<MAP_SIZE; i++) {
		for (let j=0; j<MAP_SIZE; j++) {
			if (level.isEnd(new Point({x: j, y: i}))) {
				continue;
			}
			if (level.start.isSame({x: j, y: i})) {
				continue;
			}
			if (level.data[i][j] === 1 && random() < CHANCE_FOR_TREASURE) {
				let diff = random(heroLevel/5)+1;
				treasures.push({
					position: new Point(j, i),
					gold: random(Math.pow(5, diff)),
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
	if (point.x >= MAP_SIZE || point.x < 0 || point.y < 0 || point.y >= MAP_SIZE) {
		return false;
	}

	if (levelData[point.y][point.x] === 0) {
		return false;
	}

	return true;
}

function ripple(level, point, branch) {
	if (point.x >= MAP_SIZE || point.x < 0 || point.y < 0 || point.y >= MAP_SIZE) {
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
	// ripple(matrix, start);

	let length = random(MAP_SIZE * MAP_SIZE /2) + 2*MAP_SIZE;
	let steps = 0, previousDirection = null, position = start;

	debug('generating map (desired length: ' + length + ')');

	while (steps < length) {
		let possibleDirections = getPossibleDirections(matrix, position);
		let direction = null;

		debug('possible directions', possibleDirections.join(' '));

		if (!previousDirection || possibleDirections.indexOf(previousDirection) === -1) {
			direction = possibleDirections[random(possibleDirections.length)];
		} else {
			if (random() < 25) {
				direction = possibleDirections[random(possibleDirections.length)];
			} else {
				direction = previousDirection;
			}
		}

		debug('chosen direction', direction);

		switch (direction) {
		case directions.north:
			matrix[position.y-1][position.x] = 100;
			position = new Point(position.x, position.y-1);
			break;
		case directions.south:
			matrix[position.y+1][position.x] = 100;
			position = new Point(position.x, position.y+1);
			break;
		case directions.west:
			matrix[position.y][position.x-1] = 100;
			position = new Point(position.x-1, position.y);
			break;
		case directions.east:
			matrix[position.y][position.x+1] = 100;
			position = new Point(position.x+1, position.y);
			break;
		default:
			steps = length;
		}

		previousDirection = direction;
		steps++;
	}

	return matrix;
}

function getPossibleDirections(map, point) {
	let array = [];

	if (point.x - 1 > 0 && map[point.y][point.x-1] === 0)
		array.push(directions.west);
	if (point.x + 1 < MAP_SIZE && map[point.y][point.x+1] === 0)
		array.push(directions.east);
	if (point.y - 1 > 0 && map[point.y-1][point.x] === 0)
		array.push(directions.north);
	if (point.y + 1 < MAP_SIZE && map[point.y+1][point.x] === 0)
		array.push(directions.south);

	return array;
}

function generateMonsters(level, heroLevel) {
	let monsters = [];

	if (!heroLevel)
		heroLevel = 1;

	let minLevel = Math.max(0, Math.max(heroLevel, level.level) - 5);

	for (let i=0; i<MAP_SIZE; i++) {
		for (let j=0; j<MAP_SIZE; j++) {
			let point = new Point(j, i);
			if (!level.isFree(point))
				continue;

			let monsterLevel = minLevel < 1 ? random(heroLevel) + 1 : random(6) + minLevel;
			if (level.data[i][j] === 1 && random() < CHANCE_FOR_MONSTER) {
				monsters.push(new Monster(monsterLevel, point, level.type));
			}
		}
	}

	return monsters;
}

function generateShops(level) {
	if (random() < 100) {
	// if (random() < CHANCE_FOR_SHOP) {
		let spot = findFreeSpot(level);
		if (spot) {
			return [new Shop(getRandomShopType(), spot)];
		}
	}

	return [];
}

function getRandomShopType() {
	return shops.skills;

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
