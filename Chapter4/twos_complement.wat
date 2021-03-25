(module
	(func $twos_complement (export "twos_complement")
		(param $number i32)
		(result i32)
		local.get $number
		i32.const 0xffffffff ;; all binary 1s to flip the bits
		i32.xor ;; flip all the bits
		i32.const 1
		i32.add ;; add one after flipping all bits for 2s complement
	)
)