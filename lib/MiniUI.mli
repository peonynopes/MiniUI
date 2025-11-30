module Color : sig
  type t

  val make : int -> int -> int -> int -> t
  val beige : t
  val black : t
  val blank : t
  val blue : t
  val darkblue : t
  val darkbrown : t
  val darkgray : t
  val darkgreen : t
  val darkpurple : t
  val gold : t
  val gray : t
  val magenta : t
  val maroon : t
  val orange : t
  val pink : t
  val red : t
  val skyblue : t
  val violet : t
  val white : t
  val yellow : t
end

type info = {
  width : float;
  height : float;
  monitor_width : float;
  monitor_height : float;
}

module Mouse : sig
  type t = Left | Middle | Right | Side | Extra | Forward | Back
end

type state = ..
type state += NoState
type 'a box

val box : unit -> 'a box
val at_x : float -> 'a box -> 'a box
val at_y : float -> 'a box -> 'a box
val at : float -> float -> 'a box -> 'a box
val size : float -> float -> 'a box -> 'a box
val width : float -> 'a box -> 'a box
val height : float -> 'a box -> 'a box
val children : 'a box list -> 'a box -> 'a box
val vertical : 'a box -> 'a box
val horizontal : 'a box -> 'a box
val gap : float -> 'a box -> 'a box
val padding : float -> 'a box -> 'a box
val color : Color.t -> 'a box -> 'a box
val rounding : float -> 'a box -> 'a box
val grow_width : 'a box -> 'a box
val grow_height : 'a box -> 'a box
val grow : 'a box -> 'a box
val padding_top : float -> 'a box -> 'a box
val padding_bottom : float -> 'a box -> 'a box
val padding_left : float -> 'a box -> 'a box
val padding_right : float -> 'a box -> 'a box
val align_x : float -> 'a box -> 'a box
val align_y : float -> 'a box -> 'a box
val text : string -> 'a box -> 'a box
val text_color : Color.t -> 'a box -> 'a box
val text_size : float -> 'a box -> 'a box
val text_font : Raylib.Font.t -> 'a box -> 'a box
val text_spacing : float -> 'a box -> 'a box
val min_width : float -> 'a box -> 'a box
val min_height : float -> 'a box -> 'a box
val max_width : float -> 'a box -> 'a box
val max_height : float -> 'a box -> 'a box

val on_mouse_moved :
  (float -> float -> float -> float -> 'a box -> 'a -> 'a) -> 'a box -> 'a box

val on_mouse_enter :
  (float -> float -> float -> float -> 'a box -> 'a -> 'a) -> 'a box -> 'a box

val on_mouse_leave :
  (float -> float -> float -> float -> 'a box -> 'a -> 'a) -> 'a box -> 'a box

val on_mouse_down :
  (float -> float -> Mouse.t -> 'a box -> 'a -> 'a) -> 'a box -> 'a box

val on_mouse_up :
  (float -> float -> Mouse.t -> 'a box -> 'a -> 'a) -> 'a box -> 'a box

type button

val new_button : unit -> button
val button : button -> 'a box

val run :
  init:(unit -> 'a) -> update:('a -> 'a) -> view:('a -> info -> 'a box) -> unit
