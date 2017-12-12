/* global module, require */

const { states } = require('./constants');

function state() {
	let self = this;

	self.newState = newState;
	self.prevState = prevState;
	self.is = is;
	self.get = get;

	init();

	return self;

	function init() {
		self.stack = [{state: states.normal, param: null}];
	}

	function newState(state, param) {
		if (!self.is(state) || param) {
			self.stack.push({state: state, param: param});
		}
	}

	function prevState() {
		if (self.stack.length > 1)
			self.stack.pop();
	}

	function is(state) {
		return self.get().state === state;
	}

	function get() {
		return self.stack[self.stack.length -1];
	}
}

module.exports = state();
