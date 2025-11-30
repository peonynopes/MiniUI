open MiniUI

type state = WelcomeScreen | ExampleList | Counter of int

let init () = Counter 0
let update state = state

let counter_example counter info =
  window info
  |> padding (info.unit *. 0.01)
  |> children
       [
         box info
         |> border (info.unit *. 0.005)
         |> padding (info.unit *. 0.01)
         |> text_size (info.unit *. 0.04)
         |> text (string_of_int counter)
         |> on_mouse_up (fun _ _ button _ state ->
             match state with
             | Counter counter -> Counter (counter + 1)
             | _ -> state);
       ]

let view state info =
  match state with
  | WelcomeScreen -> box info
  | ExampleList -> box info
  | Counter counter -> counter_example counter info

let () = run ~init ~view ~update
