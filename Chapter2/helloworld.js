const fs = require('fs');
const bytes = fs.readFileSync(__dirname + '/helloworld.wasm');
let hello_world = null; // function will be set later
let start_string_index = 100; // linear memory location of string
let memory = new WebAssembly.Memory({ initial: 1 }); // linear memory


let importObject = {
	env: {
		buffer: memory,
		start_string: start_string_index,
		print_string: function (str_len) {
			const bytes = new Uint8Array(memory.buffer,
				start_string_index, str_len);
			const log_string = new TextDecoder('utf8').decode(bytes);
			console.log(log_string);
		}
	}
};

(async () => {
	let obj = await
		WebAssembly.instantiate(new Uint8Array(bytes), importObject);
	({ helloworld: hello_world } = obj.instance.exports);
	hello_world();
})();