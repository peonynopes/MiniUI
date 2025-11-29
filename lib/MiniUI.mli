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

type state = ..
type 'a box

val box : unit -> 'a box
val at_x : float -> 'a box -> 'a box
val at_y : float -> 'a box -> 'a box
val at : float -> float -> 'a box -> 'a box
val size : float -> float -> 'a box -> 'a box
val width : float -> 'a box -> 'a box
val height : float -> 'a box -> 'a box
val color : Color.t -> 'a box -> 'a box
val run : init:(unit -> 'a) -> build:('a -> 'a box) -> update:('a -> 'a) -> unit
