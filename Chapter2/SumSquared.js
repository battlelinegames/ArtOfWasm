const fs = require('fs');
const bytes = fs.readFileSync(__dirname + '/SumSquared.wasm');
const val1 = parseInt(process.argv[2]);
const val2 = parseInt(process.argv[3]);
(async () => {
	const obj =
		await WebAssembly.instantiate(new Uint8Array(bytes));
	let sum_sq =
		obj.instance.exports.SumSquared(val1, val2);
	console.log(
		`(${val1} + ${val2}) * (${val1} + ${val2}) = ${sum_sq}`
	);
})();