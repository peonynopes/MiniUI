hmodule Color = struct
  open Raylib.Color

  type t = Raylib.Color.t

  let make r g b a = Raylib.Color.create r g b a
  let beige = beige
  let black = black
  let blank = blank
  let blue = blue
  let darkblue = darkblue
  let darkbrown = darkbrown
  let darkgray = darkgray
  let darkgreen = darkgreen
  let darkpurple = darkpurple
  let gold = gold
  let gray = gray
  let magenta = magenta
  let maroon = maroon
  let orange = orange
  let pink = pink
  let red = red
  let skyblue = skyblue
  let violet = violet
  let white = white
  let yellow = yellow
end

type state = ..
type state += NoState

type 'a box = {
  state : state;
  x : float;
  y : float;
  width : float;
  height : float;
  color : Raylib.Color.t;
}

let box () =
  {
    state = NoState;
    x = 0.;
    y = 0.;
    width = 0.;
    height = 0.;
    color = Raylib.Color.blank;
  }

let at x y box = { box with x; y }
let at_x x box = { box with x }
let at_y y box = { box with y }
let size width height box = { box with width; height }
let width width box = { box with width }
let height height box = { box with height }
let color color box = { box with color }

let draw box =
  let open Raylib in
  if
    box.x = 0. && box.y = 0.
    && box.width = float (get_render_width ())
    && box.height = float (get_render_height ())
  then clear_background box.color
  else
    draw_rectangle_rec
      (Rectangle.create box.x box.y box.width box.height)
      box.color

let run ~init ~build ~update =
  let open Raylib in
  let state = init () in
  let box = build state in
  let rec loop state =
    if window_should_close () then close_window ();
    begin_drawing ();
    draw box;
    end_drawing ();
    loop (update state)
  in
  set_config_flags [ ConfigFlags.Window_resizable ];
  set_target_fps 30;
  init_window 1920 1080 "MiniUI";
  loop state
