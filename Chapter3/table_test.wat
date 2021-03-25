(module
  (import "js" "tbl" (table $tbl 4 anyfunc))
	;; import increment function
	(import "js" "increment" (func $increment (result i32)))
	;; import decrement function
	(import "js" "decrement" (func $decrement (result i32)))
	;; import wasm_increment function
	(import "js" "wasm_increment" (func $wasm_increment (result i32)))
	;; import wasm_decrement function
	(import "js" "wasm_decrement" (func $wasm_decrement (result i32)))
	;; table function type definitions all i32 and take no parameters
	(type $returns_i32 (func (result i32)))

	(global $inc_ptr i32 (i32.const 0)) ;; JS increment function table index
	(global $dec_ptr i32 (i32.const 1)) ;; JS decrement function table index
	(global $wasm_inc_ptr i32 (i32.const 2)) ;; WASM increment function index
	(global $wasm_dec_ptr i32 (i32.const 3)) ;; WASM decrement function index	

	;; Test performance of an indirect table call of JavaScript functions
	(func (export "js_table_test")
		(loop $inc_cycle
			;; indirect call to JavaScript increment function
			(call_indirect (type $returns_i32) (global.get $inc_ptr))
			i32.const 4_000_000
			i32.le_u ;; is the value returned by call to $inc_ptr <= 4,000,000?
			br_if $inc_cycle ;; if so, loop
		)
		(loop $dec_cycle
			;; indirect call to JavaScript decrement function
			(call_indirect (type $returns_i32) (global.get $dec_ptr))
			i32.const 4_000_000
			i32.le_u ;; is the value returned by call to $dec_ptr <= 4,000,000?
			br_if $dec_cycle ;; if so, loop
		)
	)	

	;; Test performance of direct call to JavaScript functions
	(func (export "js_import_test")
		(loop $inc_cycle
			call $increment ;; direct call to JavaScript increment function
			i32.const 4_000_000
			i32.le_u ;; is the value returned by call to $increment<=4,000,000?
			br_if $inc_cycle ;; if so, loop
		)
		(loop $dec_cycle
			call $decrement ;; direct call to JavaScript decrement function
			i32.const 4_000_000
			i32.le_u ;; is the value returned by call to $decrement<=4,000,000?
			br_if $dec_cycle ;; if so, loop
		)
	)
	;; Test performance of an indirect table call to WASM functions
	(func (export "wasm_table_test")
		(loop $inc_cycle
			;; indirect call to WASM increment function
			(call_indirect (type $returns_i32) (global.get $wasm_inc_ptr))
			i32.const 4_000_000
			i32.le_u ;; is the value returned by call to $wasm_inc_ptr<=4,000,000?
			br_if $inc_cycle ;; if so, loop
		)
		(loop $dec_cycle
			;; indirect call to WASM decrement function
			(call_indirect (type $returns_i32) (global.get $wasm_dec_ptr))
			i32.const 4_000_000
			i32.le_u ;; is the value returned by call to $wasm_dec_ptr<=4,000,000?
			br_if $dec_cycle ;; if so, loop
		)
	)
	;; Test performance of direct call to WASM functions
	(func (export "wasm_import_test")
		(loop $inc_cycle
			call $wasm_increment ;; direct call to WASM increment function
			i32.const 4_000_000
			i32.le_u
			br_if $inc_cycle
		)
		(loop $dec_cycle
			call $wasm_decrement ;; direct call to WASM decrement function
			i32.const 4_000_000
			i32.le_u
			br_if $dec_cycle
		)
	)
)	