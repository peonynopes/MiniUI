open MiniUI

let init () = false
let update hover = hover

let view hover info =
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
         |> text_color (if hover then Color.blue else Color.black)
         |> on_mouse_enter (fun x y dx dy box state -> true)
         |> on_mouse_leave (fun x y dx dy box state -> false);
         box () |> text "(and Raylib)"
         |> text_spacing (unit *. 0.005)
         |> text_size (unit *. 0.05)
         |> text_color Color.darkgray;
       ]

let () = run ~init ~update ~view
