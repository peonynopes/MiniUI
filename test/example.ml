open MiniUI

type state = WelcomeScreen | ExampleList | Counter of int

let init () = ExampleList
let update state = state

let example_entry name info onclick =
  box info |> text name |> on_mouse_up (fun _ _ button _ state -> onclick)

let example_list info =
  window info
  |> padding (info.unit *. 0.01)
  |> gap (info.unit *. 0.01)
  |> children
       [
         box info |> text "MiniUI Example List";
         box info |> grow
         |> children [ example_entry "Counter Example" info (Counter 0) ];
       ]

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
  | WelcomeScreen -> window info
  | ExampleList -> example_list info
  | Counter counter -> counter_example counter info

let () = run ~init ~view ~update
