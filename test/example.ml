open MiniUI

type state = { counter : int; button : button }

let init () = { counter = 0; button = new_button () }
let update counter = counter

let view state _ =
  box () |> padding 8. |> children [ button state.button |> size 128. 128. ]

let () = run ~init ~view ~update
