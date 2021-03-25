const fs = require('fs');
const bytes = fs.readFileSync('./globals.wasm');
let global_test = null;
let importObject = {
	js: {
		log_i32: (value) => { console.log("i32: ", value) },
		log_f32: (value) => { console.log("f32: ", value) },
		log_f64: (value) => { console.log("f64: ", value) },
	},
	env: {
		import_i32: 5_000_000_000, // _ is ignored in numbers in JS and WAT
		import_f32: 123.0123456789,
		import_f64: 123.0123456789,
	}
};

(async () => {
	let obj = await WebAssembly.instantiate(new Uint8Array(bytes),
		importObject);
	({ globaltest: global_test } = obj.instance.exports);
	global_test();
})();