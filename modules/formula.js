const factor = 0.03;

let x = 0;
for (let i=0; i<50; i++) {
	x = x + ((100 - x) * factor);
	console.log(x);
}
