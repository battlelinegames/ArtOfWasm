(module
	;; Imported JavaScript function (below) takes position and length
	(import "env" "str_pos_len" (func $str_pos_len (param i32 i32)))
	(import "env" "null_str" (func $null_str (param i32)))
	(import "env" "len_prefix" (func $len_prefix (param i32)))
	(import "env" "buffer" (memory 1))

  (data (i32.const 0) "null-terminating string\00")
  (data (i32.const 128) "another null-terminating string\00")	;; 30 character string
	(data (i32.const 256) "Know the length of this string")
	;; 35 characters
	(data (i32.const 384) "Also know the length of this string")
	;; add the next four lines. Two data elements and two comments
	;; length is 22 in decimal, which is 16 in hex
	(data (i32.const 512) "\16length-prefixed string")
	;; length is 30 in decimal, which is 1e in hex
	(data (i32.const 640) "\1eanother length-prefixed string")	
	(func (export "main")
		(call $str_pos_len (i32.const 256) (i32.const 30))
		(call $str_pos_len (i32.const 384) (i32.const 35))
		(call $string_copy
		(i32.const 256) (i32.const 384) (i32.const 30))
		(call $str_pos_len (i32.const 384) (i32.const 35))
		(call $str_pos_len (i32.const 384) (i32.const 30))
	)
	(func $byte_copy
		(param $source i32) (param $dest i32) (param $len i32)
		(local $last_source_byte i32)
		local.get $source
		local.get $len
		i32.add ;; $source + $len
		local.set $last_source_byte ;; $last_source_byte = $source + $len
		(loop $copy_loop (block $break
			local.get $dest ;; push $dest on stack for use in i32.store8 call
			(i32.load8_u (local.get $source)) ;; load a single byte from $source
			i32.store8 ;; store a single byte in $dest
			local.get $dest
			i32.const 1
			i32.add
			local.set $dest ;; $dest = $dest + 1
			local.get $source
			i32.const 1
			i32.add
			local.tee $source ;; $source = $source + 1
			local.get $last_source_byte
			i32.eq
			br_if $break
			br $copy_loop
		)) ;; end $copy_loop
	)
;; add this block of code to the strings.wat file
	(func $byte_copy_i64
		(param $source i32) (param $dest i32) (param $len i32)
		(local $last_source_byte i32)
		local.get $source
		local.get $len
		i32.add
		local.set $last_source_byte
		(loop $copy_loop (block $break
			(i64.store (local.get $dest) (i64.load (local.get $source)))
			local.get $dest
			i32.const 8
			i32.add
			local.set $dest ;; $dest = $dest + 8
			local.get $source
			i32.const 8
			i32.add
			local.tee $source ;; $source = $source + 8
			local.get $last_source_byte
			i32.ge_u	
			br_if $break
			br $copy_loop
		)) ;; end $copy_loop
	)

	(func $string_copy
		(param $source i32) (param $dest i32) (param $len i32)
		(local $start_source_byte i32)
		(local $start_dest_byte i32)
		(local $singles i32)
		(local $len_less_singles i32)
		local.get $len
		local.set $len_less_singles ;; value without singles
		local.get $len
		i32.const 7 ;; 7 = 0111 in binary
		i32.and
		local.tee $singles ;; set $singles to last 3 bits of length
		if ;; if the last 3 bits of $len is not 000
			local.get $len
			local.get $singles
			i32.sub
			local.tee $len_less_singles ;; $len_less_singles = $len - $singles
			local.get $source
			i32.add
			;; $start_source_byte=$source+$len_less_singles
			local.set $start_source_byte
			local.get $len_less_singles
			local.get $dest
			i32.add
			local.set $start_dest_byte ;; $start_dest_byte=$dest+$len_less_singles
			(call $byte_copy (local.get $start_source_byte)
			(local.get $start_dest_byte)(local.get $singles))
		end
		local.get $len
		i32.const 0xff_ff_ff_f8 ;; all bits are 1 except the last three which are 0
		i32.and ;; set the last three bits of the length to 0
		local.set $len
		(call $byte_copy_i64 (local.get $source) (local.get $dest) (local.get $len))
	)
)