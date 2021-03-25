(module
 (type $i32_i32_i32_=>_i32 (func (param i32 i32 i32) (result i32)))
 (export "inline_test" (func $0))
 (func $0 (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (i32.mul
   (local.tee $0
    (i32.add
     (i32.add
      (local.get $0)
      (i32.add
       (local.get $1)
       (i32.const 2)
      )
     )
     (i32.mul
      (local.tee $0
       (i32.add
        (local.get $2)
        (i32.add
         (local.get $0)
         (i32.const 13)
        )
       )
      )
      (local.get $0)
     )
    )
   )
   (local.get $0)
  )
 )
)
