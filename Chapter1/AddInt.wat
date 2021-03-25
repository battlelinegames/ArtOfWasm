(module
  (func (export "AddInt")
  (param $value_1 i32) (param $value_2 i32)
  (result i32)
		local.get $value_1
		local.get $value_2
		i32.add
  )
)