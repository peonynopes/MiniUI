open MiniUI

let init () = 0
let update counter = counter
let build _ = box () |> size 128. 128.
let () = run ~init ~build ~update
