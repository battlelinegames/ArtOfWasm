const fs = require('fs');
const bytes = fs.readFileSync(__dirname + '/number_string.wasm');
const value = parseInt(process.argv[2]);
let memory = new WebAssembly.Memory({ initial: 1 });
(async () => {
	const obj =
		await WebAssembly.instantiate(new Uint8Array(bytes), {
			env: {
				buffer: memory,
				print_string: function (str_pos, str_len) {
					const bytes = new Uint8Array(memory.buffer,
						str_pos, str_len);
					const log_string = new TextDecoder('utf8').decode(bytes);
					// log_string is left padded. 
					console.log(`>${log_string}!`);
				}
			}
		});
	obj.instance.exports.to_string(value);
})();