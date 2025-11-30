open MiniUI

type state = WelcomeScreen | ExampleList | Counter of int

let init () = Counter 0
let update state = state

let example_template info content =
  window info
  |> padding (info.unit *. 0.01)
  |> gap (info.unit *. 0.01)
  |> children
       [
         box info |> grow_width
         |> gap (info.unit *. 0.01)
         |> vertical
         |> children
              [
                box info |> text "<- Back";
                box info |> grow_width |> center
                |> children [ box info |> text "Counter Example" ];
              ]
         |> on_mouse_up (fun _ _ button _ state -> ExampleList);
         box info |> grow |> center |> children content;
       ]

let counter_example counter info =
  example_template info
    [
      button info
      |> text (string_of_int counter)
      |> on_mouse_up (fun _ _ button _ state ->
          match state with
          | Counter counter -> Counter (counter + 1)
          | _ -> state);
    ]

let view state info =
  match state with
  | WelcomeScreen -> box info
  | ExampleList -> window info
  | Counter counter -> counter_example counter info

let () = run ~init ~view ~update
