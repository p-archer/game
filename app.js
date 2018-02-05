/* global require, process */

require('coffee-script/register');

const { log, err, warn, setWorkMode } = require('./modules/general');
const { states } = require('./modules/constants');
const { state } = require('./modules/state');
const chalk = require('chalk');
const ui = require('./modules/ui/ui.coffee');

const stdin = process.openStdin();

console.clear = () => {
	process.stdout.write('\x1Bc');
};

init();

function init() {
	setWorkMode();

	stdin.setRawMode(true);
	stdin.resume();
	stdin.setEncoding('utf-8');

	setupPrompt();
	ui.showOutput(state.get());

	showPrompt();
}

function setupPrompt() {
	let hero, map;

	stdin.on('data', (input) => {
		process.stdout.write(input + '\n');
		let handled = null;
		let newState = null;

		[ handled, newState, hero, map ] = ui.handleInput(state.get(), input, hero, map);
		if (handled && newState !== state.get()) {
			if (!newState)
				state.prevState();
			else
				state.newState(newState.state, newState.param);
			ui.showOutput(state.get(), hero, map);
		}

		if (!handled) {
			if (input === 'q') {
				state.prevState();
				ui.showOutput(state.get(), hero, map);
			} else {
				warn('> unknown input');
			}
		}

		showPrompt();
	});
}

function showPrompt() {
	log();
	if (!state.is(states.wait))
		process.stdout.write(state.get().state + ' > ');
}
