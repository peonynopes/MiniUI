module Color = struct
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

type info = {
  width : float;
  height : float;
  monitor_width : float;
  monitor_height : float;
}

type size_mode = Fit | Fixed | Grow

module Mouse = struct
  type t = Left | Middle | Right | Side | Extra | Forward | Back
end

type state = ..
type state += NoState

type 'a mouse_motion_callback =
  (float -> float -> float -> float -> 'a box -> 'a -> 'a) option

and 'a box = {
  state : state;
  x : float;
  y : float;
  width : float;
  height : float;
  children : 'a box list;
  floating : bool;
  vertical : bool;
  gap : float;
  padding_top : float;
  padding_bottom : float;
  padding_left : float;
  padding_right : float;
  color : Raylib.Color.t;
  rounding : float;
  width_mode : size_mode;
  height_mode : size_mode;
  needed_width : float;
  needed_height : float;
  align_x : float;
  align_y : float;
  text : string;
  text_color : Color.t;
  text_size : float;
  text_font : Raylib.Font.t;
  text_spacing : float;
  min_width : float;
  min_height : float;
  max_width : float;
  max_height : float;
  on_mouse_moved : 'a mouse_motion_callback;
  on_mouse_enter : 'a mouse_motion_callback;
  on_mouse_leave : 'a mouse_motion_callback;
  on_mouse_down : (float -> float -> Mouse.t -> 'a box -> 'a -> 'a) option;
  on_mouse_up : (float -> float -> Mouse.t -> 'a box -> 'a -> 'a) option;
}

let box () =
  {
    state = NoState;
    x = 0.;
    y = 0.;
    width = 0.;
    height = 0.;
    children = [];
    floating = false;
    vertical = false;
    gap = 0.;
    padding_top = 0.;
    padding_bottom = 0.;
    padding_left = 0.;
    padding_right = 0.;
    color = Color.blank;
    rounding = 0.;
    width_mode = Fit;
    height_mode = Fit;
    needed_width = 0.;
    needed_height = 0.;
    align_x = 0.;
    align_y = 0.;
    text = "";
    text_color = Color.white;
    text_size = 12.;
    text_font = Raylib.get_font_default ();
    text_spacing = 1.;
    min_width = 0.;
    min_height = 0.;
    max_width = infinity;
    max_height = infinity;
    on_mouse_moved = None;
    on_mouse_enter = None;
    on_mouse_leave = None;
    on_mouse_down = None;
    on_mouse_up = None;
  }

let at x y box = { box with x; y; floating = true }
let at_x x box = { box with x; floating = true }
let at_y y box = { box with y; floating = true }

let size width height box =
  { box with width; height; width_mode = Fixed; height_mode = Fixed }

let width width box = { box with width; width_mode = Fixed }
let height height box = { box with height; height_mode = Fixed }
let children children box = { box with children }
let vertical box = { box with vertical = true }
let horizontal box = { box with vertical = false }
let gap gap box = { box with gap }
let color color box = { box with color }
let rounding rounding box = { box with rounding }
let grow_width box = { box with width_mode = Grow; width = 0. }
let grow_height box = { box with height_mode = Grow; height = 0. }
let align_x align_x box = { box with align_x }
let align_y align_y box = { box with align_y }
let text text box = { box with text }
let text_color text_color box = { box with text_color }
let text_size text_size box = { box with text_size }
let text_font text_font box = { box with text_font }
let text_spacing text_spacing box = { box with text_spacing }
let min_width min_width box = { box with min_width }
let min_height min_height box = { box with min_height }
let max_width max_width box = { box with max_width }
let max_height max_height box = { box with max_height }

let on_mouse_moved on_mouse_moved box =
  { box with on_mouse_moved = Some on_mouse_moved }

let on_mouse_enter on_mouse_enter box =
  { box with on_mouse_enter = Some on_mouse_enter }

let on_mouse_leave on_mouse_leave box =
  { box with on_mouse_leave = Some on_mouse_leave }

let on_mouse_down on_mouse_down box =
  { box with on_mouse_down = Some on_mouse_down }

let on_mouse_up on_mouse_up box = { box with on_mouse_up = Some on_mouse_up }

let grow box =
  { box with width_mode = Grow; height_mode = Grow; width = 0.; height = 0. }

let padding_top padding_top box = { box with padding_top }
let padding_bottom padding_bottom box = { box with padding_bottom }
let padding_left padding_left box = { box with padding_left }
let padding_right padding_right box = { box with padding_right }

let padding padding box =
  {
    box with
    padding_top = padding;
    padding_bottom = padding;
    padding_left = padding;
    padding_right = padding;
  }

let rec position box =
  let _, children =
    List.fold_left_map
      (fun offset child ->
        let offset, child =
          if child.floating then (offset, child)
          else if box.vertical then
            ( offset +. child.height +. box.gap,
              {
                child with
                x =
                  (box.width -. child.width -. box.padding_left
                 -. box.padding_right)
                  *. box.align_x;
                y =
                  child.y +. offset
                  +. ((box.height -. box.needed_height) *. box.align_y);
              } )
          else
            ( offset +. child.width +. box.gap,
              {
                child with
                x =
                  child.x +. offset
                  +. ((box.width -. box.needed_width) *. box.align_x);
                y =
                  (box.height -. child.height -. box.padding_top
                 -. box.padding_bottom)
                  *. box.align_y;
              } )
        in
        ( offset,
          position
            {
              child with
              x = child.x +. box.x +. box.padding_left;
              y = child.y +. box.y +. box.padding_top;
            } ))
      (if box.vertical then 0. else 0.)
      box.children
  in
  { box with children }

let rec fit_width box =
  let children = List.map fit_width box.children in
  let needed_width, min_width =
    List.fold_left
      (fun widths child ->
        let needed_width, min_width = widths in
        if box.vertical then
          (max needed_width child.width, max min_width child.min_width)
        else (needed_width +. child.width, min_width +. child.min_width))
      (0., 0.) children
  in
  let needed_width =
    needed_width +. box.padding_left +. box.padding_right
    +.
    if box.vertical then 0.
    else box.gap *. (float (List.length box.children) -. 1.)
  in
  let min_width =
    min_width +. box.padding_left +. box.padding_right
    +.
    if box.vertical then 0.
    else box.gap *. (float (List.length box.children) -. 1.)
  in
  let text_width =
    Raylib.Vector2.x
      (Raylib.measure_text_ex box.text_font box.text box.text_size
         box.text_spacing)
    +. box.padding_left +. box.padding_right
  in
  let needed_width = max needed_width text_width in
  let min_width = max (max min_width text_width) box.min_width in
  let box =
    if box.width_mode = Fit then { box with width = needed_width } else box
  in
  { box with children; needed_width; min_width }

let rec fit_height box =
  let children = List.map fit_height box.children in
  let needed_height, min_height =
    List.fold_left
      (fun heights child ->
        let needed_height, min_height = heights in
        if box.vertical then
          (needed_height +. child.height, min_height +. child.min_height)
        else (max needed_height child.height, max min_height child.min_height))
      (0., 0.) children
  in
  let needed_height =
    needed_height +. box.padding_top +. box.padding_bottom
    +.
    if box.vertical then box.gap *. (float (List.length box.children) -. 1.)
    else 0.
  in
  let min_height =
    min_height +. box.padding_top +. box.padding_bottom
    +.
    if box.vertical then box.gap *. (float (List.length box.children) -. 1.)
    else 0.
  in
  let text_height =
    Raylib.Vector2.y
      (Raylib.measure_text_ex box.text_font box.text box.text_size
         box.text_spacing)
    +. box.padding_top +. box.padding_bottom
  in
  let needed_height = max needed_height text_height in
  let min_height = max (max min_height text_height) box.min_height in
  let box =
    if box.height_mode = Fit then { box with height = needed_height } else box
  in
  { box with children; needed_height; min_height }

let rec size_width box =
  let remaining_width = box.width -. box.needed_width in
  if box.vertical then
    {
      box with
      children =
        List.map
          (fun child ->
            let child =
              if child.width_mode = Grow then
                {
                  child with
                  width = box.width -. box.padding_left -. box.padding_right;
                }
              else child
            in
            size_width child)
          box.children;
    }
  else
    {
      box with
      children =
        List.map
          (fun child ->
            let child =
              if child.width_mode = Grow then
                { child with width = remaining_width }
              else child
            in
            size_width child)
          box.children;
    }

let rec size_height box =
  let remaining_height = box.height -. box.needed_height in
  if box.vertical then
    {
      box with
      children =
        List.map
          (fun child ->
            let child =
              if child.height_mode = Grow then
                { child with height = remaining_height }
              else child
            in
            size_height child)
          box.children;
    }
  else
    {
      box with
      children =
        List.map
          (fun child ->
            let child =
              if child.height_mode = Grow then
                {
                  child with
                  height = box.height -. box.padding_top -. box.padding_bottom;
                }
              else child
            in
            size_height child)
          box.children;
    }

let build box =
  box |> fit_width |> size_width |> fit_height |> size_height |> position

let rec draw box =
  let open Raylib in
  if
    box.x = 0. && box.y = 0.
    && box.width = float (get_render_width ())
    && box.height = float (get_render_height ())
    && box.rounding = 0.
  then clear_background box.color
  else
    draw_rectangle_rounded
      (Rectangle.create box.x box.y box.width box.height)
      box.rounding 16 box.color;
  draw_text_ex box.text_font box.text
    (Vector2.create box.x box.y)
    box.text_size box.text_spacing box.text_color;
  (*draw_rectangle_lines_ex
    (Rectangle.create box.x box.y box.width box.height)
    1. Color.skyblue;*)
  let _ =
    List.for_all
      (fun child ->
        draw child;
        true)
      box.children
  in
  ()

let is_in_box x y box =
  x >= box.x && y >= box.y
  && x -. box.x <= box.width
  && y -. box.y <= box.height

let rec mouse_motion_driver x y delta_x delta_y box state =
  let previous_x, previous_y = (x -. delta_x, y -. delta_y) in
  let was_in_box = is_in_box previous_x previous_y box in
  let is_in_box = is_in_box x y box in
  let state =
    match box.on_mouse_enter with
    | None -> state
    | Some callback ->
        if (not was_in_box) && is_in_box then
          callback x y delta_x delta_y box state
        else state
  in
  let state =
    match box.on_mouse_moved with
    | None -> state
    | Some callback ->
        if was_in_box && is_in_box then callback x y delta_x delta_y box state
        else state
  in
  let state =
    match box.on_mouse_leave with
    | None -> state
    | Some callback ->
        if was_in_box && not is_in_box then
          callback x y delta_x delta_y box state
        else state
  in
  List.fold_left
    (fun state child -> mouse_motion_driver x y delta_x delta_y child state)
    state box.children

let rec mouse_down_driver x y button box state =
  let state =
    match box.on_mouse_down with
    | None -> state
    | Some callback ->
        if is_in_box x y box then callback x y button box state else state
  in
  List.fold_left
    (fun state child -> mouse_down_driver x y button child state)
    state box.children

let rec mouse_up_driver x y button box state =
  let state =
    match box.on_mouse_up with
    | None -> state
    | Some callback ->
        if is_in_box x y box then callback x y button box state else state
  in
  List.fold_left
    (fun state child -> mouse_up_driver x y button child state)
    state box.children

let check_mouse_button button map_button box state =
  let open Raylib in
  if is_mouse_button_pressed button then
    let mouse_position = get_mouse_position () in
    let mouse_x, mouse_y =
      (Vector2.x mouse_position, Vector2.y mouse_position)
    in
    mouse_down_driver mouse_x mouse_y map_button box state
  else if is_mouse_button_released button then
    let mouse_position = get_mouse_position () in
    let mouse_x, mouse_y =
      (Vector2.x mouse_position, Vector2.y mouse_position)
    in
    mouse_up_driver mouse_x mouse_y map_button box state
  else state

let run ~init ~update ~view =
  let open Raylib in
  let rec loop state =
    if window_should_close () then close_window ()
    else
      let state = update state in
      let monitor = get_current_monitor () in
      let element =
        view state
          {
            width = float (get_render_width ());
            height = float (get_render_height ());
            monitor_width = float (get_monitor_width monitor);
            monitor_height = float (get_monitor_height monitor);
          }
        |> build
      in
      let mouse_delta = get_mouse_delta () in
      let delta_x, delta_y = (Vector2.x mouse_delta, Vector2.y mouse_delta) in
      let state =
        if delta_x <> 0. || delta_y <> 0. then
          let mouse_position = get_mouse_position () in
          let mouse_x, mouse_y =
            (Vector2.x mouse_position, Vector2.y mouse_position)
          in
          mouse_motion_driver mouse_x mouse_y delta_x delta_y element state
        else state
      in
      let state =
        check_mouse_button MouseButton.Left Mouse.Left element state
      in
      let state =
        check_mouse_button MouseButton.Right Mouse.Right element state
      in
      let state =
        check_mouse_button MouseButton.Middle Mouse.Middle element state
      in
      let state =
        check_mouse_button MouseButton.Forward Mouse.Forward element state
      in
      let state =
        check_mouse_button MouseButton.Back Mouse.Back element state
      in
      let state =
        check_mouse_button MouseButton.Side Mouse.Side element state
      in
      let state =
        check_mouse_button MouseButton.Extra Mouse.Extra element state
      in
      set_window_min_size
        (max (int_of_float element.min_width) 1)
        (max (int_of_float element.min_height) 1);
      set_window_max_size
        (int_of_float element.max_width)
        (int_of_float element.max_height);
      begin_drawing ();
      draw element;
      end_drawing ();
      loop state
  in
  set_config_flags [ ConfigFlags.Window_resizable ];
  (*set_target_fps 30;*)
  init_window 1920 1080 "MiniUI";
  loop (init ())

type button = { mutable hovered : bool }

let reserve_button () = { hovered = false }

let button button_state =
  box ()
  |> on_mouse_enter (fun _ _ _ _ _ state ->
      button_state.hovered <- true;
      state)
  |> on_mouse_leave (fun _ _ _ _ _ state ->
      button_state.hovered <- false;
      state)
  |> color (if button_state.hovered then Color.blue else Color.beige)
