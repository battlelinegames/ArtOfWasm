(module
 (type $i32_i32_=>_i32 (func (param i32 i32) (result i32)))
 (export "pow2_mul" (func $0))
 (func $0 (param $0 i32) (param $1 i32) (result i32)
  (i32.add
   (i32.shl
    (local.get $0)
    (i32.const 4)
   )
   (i32.shr_u
    (local.get $1)
    (i32.const 3)
   )
  )
 )
)
