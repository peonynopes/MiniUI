open MiniUI

let init () = ()
let update () = ()
let view () info =
  let unit = min info.monitor_width info.monitor_height in
  box ()
  |> size info.width info.height
  |> color Color.white
  |> align_x 0.5
  |> align_y 0.5
  |> vertical
  |> gap 8.
  |> children [
    box ()
    |> text "Hello from MiniUI!"
    |> text_spacing (unit *. 0.01)
    |> text_size (unit *. 0.1)
    |> text_color Color.black;
    box ()
    |> text "(and Raylib)"
    |> text_spacing (unit *. 0.005)
    |> text_size (unit *. 0.05)
    |> text_color Color.darkgray
  ]

let () = run ~init ~update ~view
