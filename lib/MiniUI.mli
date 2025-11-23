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

type box

val box : unit -> box
val at_x : float -> box -> box
val at_y : float -> box -> box
val at : float -> float -> box -> box
val size : float -> float -> box -> box
val width : float -> box -> box
val height : float -> box -> box
val children : box list -> box -> box
val vertical : box -> box
val horizontal : box -> box
val gap : float -> box -> box
val padding : float -> box -> box
val color : Color.t -> box -> box
val rounding : float -> box -> box
val grow_width : box -> box
val grow_height : box -> box
val grow : box -> box
val padding_top : float -> box -> box
val padding_bottom : float -> box -> box
val padding_left : float -> box -> box
val padding_right : float -> box -> box
val align_x : float -> box -> box
val align_y : float -> box -> box
val text : string -> box -> box
val text_color : Color.t -> box -> box
val text_size : float -> box -> box
val text_font : Raylib.Font.t -> box -> box
val text_spacing : float -> box -> box
val min_width : float -> box -> box
val min_height : float -> box -> box
val max_width : float -> box -> box
val max_height : float -> box -> box


val run :
  init:(unit -> 'a) -> update:('a -> 'a) -> view:('a -> info -> box) -> unit
