/* global module, require */

const { states } = require('./constants');

let stack = [{state: states.characterSelection, param: null}];

function newState(state, param) {
	if (!is(state) || param) {
		stack.push({state: state, param: param});
	}
}

function resetTo(state, param) {
	stack = [{state: state, param: param}];
}

function prevState() {
	if (stack.length > 1)
		stack.pop();
}

function is(state) {
	return get().state === state;
}

function get() {
	return stack[stack.length -1];
}

module.exports = {
	state: {
		newState: newState,
		resetTo: resetTo,
		prevState: prevState,
		is: is,
		get: get
	}
};
