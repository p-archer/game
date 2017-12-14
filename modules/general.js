/* global module, require */

const logFile = './game.log';
const fs = require('fs');
const moment = require('moment');

init();

function random(num) {
	if (num == null) {
		num = 100;
	}

	return Math.floor(Math.random() * num);
}

function log() {
	let args = [];

	for (let i=0; i<arguments.length; i++) {
		args.push(arguments[i]);
	}

	console.log(args.join(' '));
}

function debug() {
	let args = [];

	for (let i=0; i<arguments.length; i++) {
		args.push(arguments[i]);
	}

	args.unshift('[' + moment().format() + ']:');
	fs.appendFileSync(logFile, args.join(' ') + '\n', 'utf-8');
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
}

module.exports = {
	random: random,
	log: log,
	debug: debug
};
