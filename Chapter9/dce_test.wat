(module
(func $dead_code_1
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
(func $dead_code_2
 (param $a i32)
 (result i32)
 local.get $a
 local.get $a
 i32.mul
 )
 (func $dce_test (export "dce_test")
 (param $p1 i32)
 (param $p2 i32)
 (result i32)
 local.get $p1
 local.get $p2
 i32.add
 )
)