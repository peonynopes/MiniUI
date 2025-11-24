open MiniUI

type entry_state = { hover : bool; time : float }
type menu_state = { a : unit }
type state = EntryScreen of entry_state | ExampleMenu of menu_state

let entry_screen state info =
  let unit = min info.monitor_width info.monitor_height in
  box ()
  |> size info.width info.height
  |> color Color.white |> align_x 0.5 |> align_y 0.5 |> vertical
  |> gap (unit *. 0.005)
  |> padding (unit *. 0.005)
  |> children
       [
         box () |> text "Hello from MiniUI!"
         |> text_spacing (unit *. 0.01)
         |> text_size (unit *. 0.1)
         |> text_color (Color.make 0 0 0 (int_of_float (255. *. state.time)));
         box () |> text "(and Raylib)"
         |> text_spacing (unit *. 0.005)
         |> text_size (unit *. 0.05)
         |> text_color Color.darkgray;
         box () |> text "To example menu ->"
         |> text_size (unit *. 0.05)
         |> text_spacing (unit *. 0.005)
         |> text_color (if state.hover then Color.blue else Color.black)
         |> on_mouse_enter (fun x y dx dy box state ->
             match state with
             | EntryScreen state -> EntryScreen { state with hover = true }
             | _ -> state)
         |> on_mouse_leave (fun x y dx dy box state ->
             match state with
             | EntryScreen state -> EntryScreen { state with hover = false }
             | _ -> state)
         |> on_mouse_up (fun x y button box state ->
             match state with
             | EntryScreen state -> ExampleMenu { a = () }
             | _ -> state);
       ]

let example_menu state info =
  let unit = min info.monitor_width info.monitor_height in
  box ()
  |> size info.width info.height
  |> padding (unit *. 0.005)
  |> vertical |> color Color.white
  |> gap (unit *. 0.005)
  |> children
       [
         box ()
         |> text "MiniUI example menu."
         |> text_color Color.black
         |> text_size (unit *. 0.05)
         |> text_spacing (unit *. 0.005);
         box () |> grow;
       ]

let init () = EntryScreen { hover = false; time = 0. }

let update state =
  match state with
  | EntryScreen state ->
      EntryScreen
        {
          state with
          time =
            (if state.time > 1. then state.time
             else state.time +. (Raylib.get_frame_time () *. 0.5));
        }
  | _ -> state

let view state info =
  match state with
  | EntryScreen state -> entry_screen state info
  | ExampleMenu state -> example_menu state info

let () = run ~init ~update ~view
