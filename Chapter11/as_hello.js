const fs = require('fs');
const bytes = fs.readFileSync(__dirname + '/as_hello.wasm');
// The memory object is exported from AssemblyScript
var memory = null;
let importObject = {
	// module's file name without extension is used as the outer object name
	as_hello: {
		// AssemblyScript passes a length prefixed string with a simple index
		console_log: function (index) {
			// in case this is called before memory is set
			if (memory == null) {
				console.log('memory buffer is null');
				return;
			}
			const len_index = index - 4;
			// must divide by 2 to get from bytes to 16-bit unicode characters
			const len = new Uint32Array(memory.buffer, len_index, 4)[0];
			const str_bytes = new Uint16Array(memory.buffer,
				index, len);
			// decode the utf-16 byte array into a JS string
			const log_string = new TextDecoder('utf-16').decode(str_bytes);
			console.log(log_string);
		}
	},
	env: {
		abort: () => { }
	}
};
(async () => {
	let obj = await WebAssembly.instantiate(new Uint8Array(bytes),
		importObject);
	// memory object exported from AssemblyScript
	memory = obj.instance.exports.memory;
	// call the HelloWorld function
	obj.instance.exports.HelloWorld();
})();