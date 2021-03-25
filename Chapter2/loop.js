const fs = require('fs');
const bytes = fs.readFileSync(__dirname + '/loop.wasm');
const n = parseInt(process.argv[2] || "1"); // we will loop n times
let loop_test = null;
let importObject = {
	env: {
		log: function (n, factorial) { // log n factorial to output tag
			console.log(`${n}! = ${factorial}`);
		}
	}
};
(async () => {
	let obj = await WebAssembly.instantiate(new Uint8Array(bytes),
		importObject);
	loop_test = obj.instance.exports.loop_test;
	const factorial = loop_test(n); // call our loop test
	console.log(`result ${n}! = ${factorial}`);
	if (n > 12) {
		console.log(`
		===============================================================
		Factorials greater than 12 are too large for a 32-bit integer.
		===============================================================
		`)
	}
})();
