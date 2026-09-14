(* 06 — Unit tests with OUnit2 *)

open OUnit2

(* Tests for math functions *)

let test_square_positive _ =
  assert_equal 25 (Math_functions.square 5)

let test_square_zero _ =
  assert_equal 0 (Math_functions.square 0)

let test_square_negative _ =
  assert_equal 16 (Math_functions.square (-4))

let test_is_prime_true _ =
  assert_bool "2 is prime" (Math_functions.is_prime 2);
  assert_bool "3 is prime" (Math_functions.is_prime 3);
  assert_bool "17 is prime" (Math_functions.is_prime 17)

let test_is_prime_false _ =
  assert_bool "1 is not prime" (not (Math_functions.is_prime 1));
  assert_bool "4 is not prime" (not (Math_functions.is_prime 4));
  assert_bool "15 is not prime" (not (Math_functions.is_prime 15))

let test_gcd_basic _ =
  assert_equal 3 (Math_functions.gcd 9 6)

let test_gcd_coprime _ =
  assert_equal 1 (Math_functions.gcd 7 11)

let test_gcd_same _ =
  assert_equal 5 (Math_functions.gcd 5 5)

let test_factorial_zero _ =
  assert_equal 1 (Math_functions.factorial 0)

let test_factorial_positive _ =
  assert_equal 24 (Math_functions.factorial 4);
  assert_equal 120 (Math_functions.factorial 5)

let test_factorial_negative _ =
  assert_raises (Invalid_argument "factorial of negative")
    (fun () -> Math_functions.factorial (-1))

let suite = [
  "square_positive" >:: test_square_positive;
  "square_zero" >:: test_square_zero;
  "square_negative" >:: test_square_negative;
  "is_prime_true" >:: test_is_prime_true;
  "is_prime_false" >:: test_is_prime_false;
  "gcd_basic" >:: test_gcd_basic;
  "gcd_coprime" >:: test_gcd_coprime;
  "gcd_same" >:: test_gcd_same;
  "factorial_zero" >:: test_factorial_zero;
  "factorial_positive" >:: test_factorial_positive;
  "factorial_negative" >:: test_factorial_negative;
]

let () = run_test_tt_main suite
