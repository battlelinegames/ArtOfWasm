(module
	(import "env" "print_string" (func $print_string (param i32 i32)))
	(import "env" "buffer" (memory 1))
	(data (i32.const 128) "0123456789ABCDEF")
	(data (i32.const 256) " 0")
	(global $dec_string_len i32 (i32.const 16))
	;; add this code before the $set_dec_string function
	(global $hex_string_len i32 (i32.const 16)) ;; hex character count
	(data (i32.const 384) " 0x0") ;; hex string data

	;; add this code before the $set_hex_string function
	(global $bin_string_len i32 (i32.const 40))
	(data (i32.const 512) " 0000 0000 0000 0000 0000 0000 0000 0000")
	(func $set_bin_string (param $num i32) (param $string_len i32)
		(local $index i32)
		(local $loops_remaining i32)
		(local $nibble_bits i32)
		global.get $bin_string_len
		local.set $index
		i32.const 8 ;; there are 8 nibbles in 32 bits (32/4 = 8)
		local.set $loops_remaining ;; outer loop separates nibbles
		(loop $bin_loop (block $outer_break ;; outer loop for spaces
			local.get $index 
			i32.eqz
			br_if $outer_break ;; stop looping when $index is 0
			i32.const 4
			local.set $nibble_bits ;; 4 bits in each nibble
			(loop $nibble_loop (block $nibble_break ;; inner loop for digits
				local.get $index 
				i32.const 1
				i32.sub
				local.set $index ;; decrement $index
				local.get $num
				i32.const 1
				i32.and ;; i32.and 1 results in 1 if last bit is 1 else 0
				if ;; if the last bit is a 1
					local.get $index
					i32.const 49 ;; ascii '1' is 49
					i32.store8 offset=512 ;; store '1' at 512 + $index
				else ;; else executes if last bit was 0
					local.get $index
					i32.const 48 ;; ascii '0' is 48
					i32.store8 offset=512 ;; store '0' at 512 + $index
				end
				local.get $num
				i32.const 1
				i32.shr_u ;; $num shifted right 1 bit
				local.set $num ;; shift off the last bit of $num
				local.get $nibble_bits
				i32.const 1
				i32.sub
				local.tee $nibble_bits ;; decrement $nibble_bits
				i32.eqz ;; $nibble_bits == 0
				br_if $nibble_break ;; break when $nibble_bits == 0
				br $nibble_loop
			)) ;; end $nibble_loop
			local.get $index 
			i32.const 1
			i32.sub
			local.tee $index ;; decrement $index
			i32.const 32 ;; ascii space
			i32.store8 offset=512 ;; store ascii space at 512+$index
			br $bin_loop
		)) ;; end $bin_loop
	)	
	(func $set_hex_string (param $num i32) (param $string_len i32)
		(local $index i32)
		(local $digit_char i32)
		(local $digit_val i32)
		(local $x_pos i32)
		global.get $hex_string_len
		local.set $index ;; set the index to the number of hex characters
		(loop $digit_loop (block $break
			local.get $index
			i32.eqz 
			br_if $break
			local.get $num
			i32.const 0xf ;; last 4 bits are 1
			i32.and ;; the offset into $digits is in the last 4 bits of number
			local.set $digit_val ;; the digit value is the last 4 bits
			local.get $num
			i32.eqz
			if ;; if $num == 0
				local.get $x_pos
				i32.eqz
				if
					local.get $index
					local.set $x_pos ;; position of 'x' in the "0x" hex prefix
				else
					i32.const 32 ;; 32 is ascii space character
					local.set $digit_char
				end
			else
				;; load character from 128 + $digit_val
				(i32.load8_u offset=128 (local.get $digit_val))
				local.set $digit_char
			end 
			local.get $index
			i32.const 1
			i32.sub
			local.tee $index ;; $index = $index - 1
			local.get $digit_char
			;; store $digit_char at location 384+$index
			i32.store8 offset=384
			local.get $num
			i32.const 4
			i32.shr_u ;; shifts 1 hexadecimal digit off $num
			local.set $num
			br $digit_loop
		))
		local.get $x_pos
		i32.const 1
		i32.sub
		i32.const 120 ;; ascii x
		i32.store8 offset=384 ;; store 'x' in string
		local.get $x_pos
		i32.const 2
		i32.sub
		i32.const 48 ;; ascii '0'
		i32.store8 offset=384 ;; store "0x" at front of string
	) ;; end $set_hex_string

	(func $set_dec_string (param $num i32) (param $string_len i32)
		(local $index i32)
		(local $digit_char i32)
		(local $digit_val i32)
		local.get $string_len
		local.set $index ;; set $index to the string length
		local.get $num
		i32.eqz ;; is $num is equal to zero
		if ;; if the number is 0, I don't want all spaces
			local.get $index
			i32.const 1
			i32.sub
			local.set $index ;; $index--
			;; store ascii '0' to memory location 256 + $index
			(i32.store8 offset=256 (local.get $index) (i32.const 48))
		end
		(loop $digit_loop (block $break ;; loop converts number to a string
			local.get $index ;; set $index to end of string, decrement to 0
			i32.eqz ;; is the $index 0?
			br_if $break ;; if so break out of loop
			local.get $num
			i32.const 10
			i32.rem_u ;; decimal digit is remainder of divide by 10
			local.set $digit_val ;; replaces call above
			local.get $num
			i32.eqz ;; check to see if the $num is now 0
			if
				i32.const 32 ;; 32 is ascii space character
				local.set $digit_char ;; if $num is 0, left pad spaces
			else
				(i32.load8_u offset=128 (local.get $digit_val))
				local.set $digit_char ;; set $digit_char to ascii digit
			end 
			local.get $index
			i32.const 1
			i32.sub
			local.set $index
			;; store ascii digit in 256 + $index
			(i32.store8 offset=256
				(local.get $index) (local.get $digit_char)) 
			local.get $num
			i32.const 10
			i32.div_u
			local.set $num ;; remove last decimal digit, dividing by 10
			br $digit_loop ;; loop
		)) ;; end of $block and $loop
	)

	(func (export "to_string") (param $num i32)
		(call $set_dec_string
		(local.get $num) (global.get $dec_string_len))
		(call $print_string
		(i32.const 256) (global.get $dec_string_len))		
		(call $set_hex_string (local.get $num)
		(global.get $hex_string_len))
		(call $print_string (i32.const 384) (global.get $hex_string_len))	

		(call $set_bin_string
		(local.get $num) (global.get $bin_string_len))
		(call $print_string (i32.const 512) (global.get $bin_string_len))
	)
)