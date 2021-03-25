(module
	(memory 1)
	(global $pointer i32 (i32.const 128))
	(func $init
		(i32.store
			(global.get $pointer) ;; store at address $pointer
			(i32.const 99) ;; value stored	
		)
	)
	(func (export "get_ptr") (result i32)
		(i32.load (global.get $pointer)) ;; return value at location $pointer
	)
	(start $init)
)