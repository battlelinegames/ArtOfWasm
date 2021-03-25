const fs = require('fs');
const bytes = fs.readFileSync('./mod_and.wasm');
(async () => {
	const obj =
		await WebAssembly.instantiate(new Uint8Array(bytes));
	let mod = obj.instance.exports.mod;
	let and = obj.instance.exports.and;
	let start_time = Date.now(); // reset start_time
	// The '| 0' syntax is a hint to the JavaScript engine to tell it
	// to use integers instead of floats, which can improve performance in
	// some circumstances
	for (let i = 0 | 0; i < 4_000_000; i++) {
		mod(i); // call the mod function 4 million times
	}
	// calculate the time it took to run 4 million mod calls
	console.log(`mod: ${Date.now() - start_time}`);
	start_time = Date.now(); // reset start_time
	for (let i = 0 | 0; i < 4_000_000; i++) {
		and(i); // call the and function 4 million times
	}
	// calculate the time it took to run 4 million and calls
	console.log(`and: ${Date.now() - start_time}`);
	start_time = Date.now(); // reset start_time
	for (let i = 0 | 0; i < 4_000_000; i++) {
		Math.floor(i % 1000);
	}
	// calculate the time it took to run 4 million modulo calls
	console.log(`js mod: ${Date.now() - start_time}`);
})();