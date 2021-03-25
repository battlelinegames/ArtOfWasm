(module
	(func (export "pow2_mul")
		(param $p1 i32)
		(param $p2 i32)
		(result i32)
		local.get $p1
		i32.const 16
		i32.mul ;; multiply by 16, which is 24
		local.get $p2
		i32.const 8
		i32.div_u ;; divide by 8, which is 23
		i32.add
	)
)