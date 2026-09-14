(* 04 — Module operations for tests *)

module Stack_ops = struct
  let create = Stack.create
  let push = Stack.push
  let pop = Stack.pop
  let is_empty = Stack.is_empty
  let length = Stack.length
end

module Queue_ops = struct
  let create = Queue_impl.create
  let push = Queue_impl.push
  let pop = Queue_impl.pop
  let is_empty = Queue_impl.is_empty
  let length = Queue_impl.length
end
