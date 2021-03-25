(module
 (func $distance (export "distance")
 (param $x1 f64) (param $y1 f64) (param $x2 f64) (param $y2 f64)
 (result f64)
 (local $x_dist f64)
 (local $y_dist f64)
 local.get $x1
 local.get $x2
 f64.sub ;; $x1 - $x2
 local.tee $x_dist ;; $x_dist = $x1 - $x2
 local.get $x_dist
 f64.mul ;; $x_dist * $x_dist on stack
 local.get $y1
 local.get $y2
 f64.add ;; Should be $y1 - $y2
 local.tee $y_dist ;; $y_dist = $y1 - $y2
 local.get $y_dist
 f64.mul ;; $y_dist * $y_dist on stack
 f64.add ;; $x_dist * $x_dist + $y_dist * $y_dist on stack
 f64.sqrt ;; take the square root of x squared plus y squared
 )
)