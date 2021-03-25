const fs = require('fs');
const bytes = fs.readFileSync(__dirname + '/func_perform.wasm');
let i = 0;
let importObject = {
	js: {
		external_call: function () { // The imported JavaScript function
			i++;
			return i; // increment i variable and return it
		}
	}
};

(async () => {
	const obj = await WebAssembly.instantiate(new Uint8Array(bytes),
		importObject);
	// destructure wasm_call and js_call from obj.instance.exports
	({ wasm_call, js_call } = obj.instance.exports);
	let start = Date.now();
	wasm_call(); // call wasm_call from WebAssembly module
	let time = Date.now() - start;
	console.log('wasm_call time=' + time); // execution time in ms
	start = Date.now();
	js_call(); // call js_call from WebAssembly module
	time = Date.now() - start;
	console.log('js_call time=' + time); // execution time in milliseconds
})();