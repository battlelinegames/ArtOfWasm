(module
 (func $combine_constants (export "combine_constants")
 (result i32)
 i32.const 10
 i32.const 20
 i32.add
 i32.const 55
 i32.add
 )
)