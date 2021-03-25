(module
 (func $mod (export "mod")
 (param $p0 i32)
 (result i32)
 local.get $p0
 i32.const 1000
 i32.rem_u
 )
 (func $and (export "and")
 (param $p0 i32)
 (result i32)
 local.get $p0
 i32.const 0x3ff
 i32.and
 )
)