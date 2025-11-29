open MiniUI

let init () = 0
let update counter = counter

let build _ =
  window () |> color Color.white
  |> children [ box () |> color Color.blue |> size 128. 128. ]

let () = run ~init ~build ~update
