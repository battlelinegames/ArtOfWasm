(module
	(import "env" "log_add_message"
		(func $log_add_message (param i32 i32 i32)))
	(func (export "add_message")
		(param $a i32) (param $b i32)
		(local $sum i32)

		local.get $a
		local.get $b
		i32.add
		local.set $sum
		(call $log_add_message
		(local.get $a) (local.get $b) (local.get $sum))
	)
)