function bytecode_test() {
	let x = 0;
	for (let i = 0; i < 100_000_000; i++) {
		x = i % 1000;
	}
	return 99;
}
// if we don't call this, the function is removed in dce check
bytecode_test();