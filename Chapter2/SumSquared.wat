(module
	(func (export "SumSquared")
	(param $value_1 i32) (param $value_2 i32)
	(result i32)
	(local $sum i32)
	
	(i32.add (local.get $value_1) (local.get $value_2))
	local.set $sum
	(i32.mul (local.get $sum) (local.get $sum))
	)
)