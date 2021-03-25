const fs = require('fs');
const bytes = fs.readFileSync('./mod_and_loop.wasm');
(async () => {
	const obj =
		await WebAssembly.instantiate(new Uint8Array(bytes));
	let mod_loop = obj.instance.exports.mod_loop;
	let and_loop = obj.instance.exports.and_loop;
	let start_time = Date.now(); // set start_time
	and_loop();
	console.log(`and_loop: ${Date.now() - start_time}`);
	start_time = Date.now(); // reset start_time
	mod_loop();
	console.log(`mod_loop: ${Date.now() - start_time}`);
	start_time = Date.now(); // reset start_time
	let x = 0;
	for (let i = 0; i < 100_000_000; i++) {
		x = i % 1000;
	}
	console.log(`js mod: ${Date.now() - start_time}`);
})();