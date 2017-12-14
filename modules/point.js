class Point {
	constructor(x, y) {
		this.x = x;
		this.y = y;
	}

	isSame(point) {
		return (point.x === this.x && point.y === this.y);
	}
}

module.exports = Point;
