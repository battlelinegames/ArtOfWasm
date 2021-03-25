(module
 (func $add_three
 (param $a i32)
 (param $b i32)
 (param $c i32)
 (result i32)
 local.get $a
 local.get $b
 local.get $c
 i32.add
 i32.add
 )
 (func $square
 (param $a i32)
 (result i32)
 local.get $a
 local.get $a
 i32.mul
 )
 (func $inline_test (export "inline_test")
 (param $p1 i32)
 (param $p2 i32)
 (param $p3 i32)
 (result i32)
 (call $add_three (local.get $p1) (i32.const 2) (local.get $p2))
 (call $add_three (local.get $p3) (local.get $p1) (i32.const 13))
 call $square
 i32.add
 call $square
 )
)
