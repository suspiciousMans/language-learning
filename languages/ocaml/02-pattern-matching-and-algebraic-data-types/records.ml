(* 02 — Record types *)

type person = {
  name: string;
  age: int;
  email: string;
}

type point2d = {
  x: float;
  y: float;
}

(* TODO: write functions that work with records *)

let greet p =
  "Hello, " ^ p.name ^ " (age " ^ string_of_int p.age ^ ")"

let manhattan_distance a b =
  abs_float (a.x -. b.x) +. abs_float (a.y -. b.y)

(* EXERCISE:
   - Write `is_adult p` that returns true if age >= 18.
   - Write `older p1 p2` that returns the older person.
   - Write `move p dx dy` that returns a new point with offset dx, dy.
   - Write `distance a b` (Euclidean) for point2d.
   - Write `update_email p new_email` using record update syntax.
   - Write a `student` record type that extends person with a `student_id` and `gpa`.
*)
