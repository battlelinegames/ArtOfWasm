const fs = require('fs');
const loader = require("@assemblyscript/loader");
(async () => {
	let module = await loader.instantiate(fs.readFileSync('as_concat.wasm'));
	//__newString, __getString functions require
	//compile with --runtime stub | full
	let first_str_index = module.exports.__newString("first string");
	let second_str_index = module.exports.__newString("second string");
	let cat_str_index = module.exports.cat(first_str_index, second_str_index);
	let cat_string = module.exports.__getString(cat_str_index);
	console.log(cat_string);
})();