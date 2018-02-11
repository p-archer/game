/* global module, require */

const logFile = './game.log';
const fs = require('fs');
const moment = require('moment');
const chalk = require('chalk');

init();

let wall = '\u25a7';
let free = '\u25e6';
let useLog = normalLog;

function random(num) {
	if (num == null) {
		num = 100;
	}

	return Math.floor(Math.random() * num);
}

function log() {
	useLog(...arguments);
}

function trashLog() {
	let args = [];

	for (let i=0; i<arguments.length; i++) {
		if (arguments[i] === Object(arguments[i]))
			args.push(JSON.stringify(arguments[i]));
		else
			args.push(arguments[i]);
	}

	let str = args.join(' ');
	let trash = generateTrash(90 - str.length);

	if (args.length > 0)
		console.log(str, trash);
	else
		console.log();
}

function normalLog() {
	let args = [];

	for (let i=0; i<arguments.length; i++) {
		if (arguments[i] === Object(arguments[i]))
			args.push(JSON.stringify(arguments[i]));
		else
			args.push(arguments[i]);
	}

	console.log(args.join(' '));
}

function warn() {
	let args = [];

	for (let i=0; i<arguments.length; i++) {
		if (arguments[i] === Object(arguments[i]))
			args.push(JSON.stringify(arguments[i]));
		else
			args.push(arguments[i]);
	}

	console.log(chalk.yellow(args.join(' ')));
}

function err() {
	let args = [];

	for (let i=0; i<arguments.length; i++) {
		if (arguments[i] === Object(arguments[i]))
			args.push(JSON.stringify(arguments[i]));
		else
			args.push(arguments[i]);
	}

	console.log(chalk.redBright(args.join(' ')));
}

function debug() {
	let args = [];

	for (let i=0; i<arguments.length; i++) {
		args.push(arguments[i]);
	}

	args.unshift('[' + moment().format() + ']:');
	fs.appendFileSync(logFile, args.join(' ') + '\n', 'utf-8');
}

function get(array, fn) {
	return array.filter(fn)[0];
}

function init() {
	let str = '[' + moment().format() + ']: game started\n';
	fs.writeFileSync(logFile, str, 'utf-8');

	Array.prototype.has = function(item) {
		if (typeof item === 'string') {
			return this.indexOf(item) !== -1;
		}

		if (typeof item === 'object') {
			let has = true;
			for (let key in item) {
				let mapped = this.map((x) => x[key]);
				has = has && mapped.indexOf(item[key]) !== -1;
			}

			return has;
		}

		return false;
	};

	Array.prototype.remove = function(item) {
		let index = this.indexOf(item);
		return this.splice(index, 1);
	};

	String.prototype.toFixed = function(length) {
		if (length < this.length)
			length = this.length;
		let padding = new Array(length - this.length).join(' ');
		return this + padding;
	};

	Object.prototype.loop = function(fn) {
		let keys = Object.keys(this);
		keys.forEach((key) => {
			if (this.hasOwnProperty(key))
				fn(key, this[key]);
		});
	};

	Object.prototype.clone = function() {
		let result = {};
		let self = this;
		Object.getOwnPropertyNames(self).forEach((x) => {
			if (typeof self[x] === 'object')
				result[x] = self[x].clone();
			else
				result[x] = self[x];
		});

		return result;
	};

	Object.prototype.copy = function() {
		return Object.assign({}, this);
	};

	Object.defineProperty(Object.prototype, 'size', {
		get: function() {
			return Object.keys(this).length;
		},
		writeable: false
	});

	Object.defineProperty(Object.prototype, 'keys', {
		get: function() {
			return Object.keys(this);
		},
		writeable: false
	});
}

function generateTrash(length = 74) {
	const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	let len = random(length);
	let str = [];

	while (str.join(' ').length < len) {
		let wordLen = random(10) + 1;
		let word = '';
		for (let i=0; i<wordLen; i++)
			word += chars[random(chars.length)];
		str.push(word);
	}

	return str.join(' ').substring(0, length);
}

function setWorkMode() {
	chalk.level = 0;
	wall = '0';
	free = '.';

	useLog = trashLog;
}

function getWallChar() {
	return wall;
}

function getFreeChar() {
	return free;
}

function getPercent(value, inverted) {
	if (value > 1)
		if (!inverted)
			return chalk.green('+' + ((value-1) * 100).toFixed(0) + '%');
		else
			return chalk.yellow('+' + ((value-1) * 100).toFixed(0) + '%');
	if (value === 1)
		return '+0%';
	if (value < 1)
		if (!inverted)
			return chalk.yellow(((value-1) * 100).toFixed(0) + '%');
		else
			return chalk.green(((value-1) * 100).toFixed(0) + '%');
}

module.exports = {
	getWallChar: getWallChar,
	getFreeChar: getFreeChar,
	debug: debug,
	err: err,
	getPercent: getPercent,
	warn: warn,
	log: log,
	random: random,
	generateTrash: generateTrash,
	setWorkMode: setWorkMode,
};
