extends Control

# Soul Knight-ish minimap: simple thumbnail of the whole generated grid.
# - Only draws valid rooms.
# - Visited rooms: dim fill
# - Current room: bright fill
# - Unvisited valid rooms: very faint outline (or hidden if you want)

@export var padding: int = 2
@export var show_unvisited_outline: bool = true

@export var visited_color: Color = Color(0.55, 0.55, 0.55, 1.0)
@export var current_color: Color = Color(1, 1, 1, 1.0)
@export var outline_color: Color = Color(0.25, 0.25, 0.25, 1.0)
@export var unvisited_outline_alpha: float = 1
@export var player_dot_radius: float = 2.5

var _x_min: int = 0
var _x_max: int = 0
var _y_min: int = 0
var _y_max: int = 0

var _current_room: Vector2 = Vector2.ZERO

func configure(x_min: int, x_max: int, y_min: int, y_max: int) -> void:
	_x_min = x_min
	_x_max = x_max
	_y_min = y_min
	_y_max = y_max
	queue_redraw()

func set_current_room(pos: Vector2) -> void:
	_current_room = Vector2(int(pos.x), int(pos.y))
	queue_redraw()

func _draw() -> void:
	var w = max(1, _x_max - _x_min + 1)
	var h = max(1, _y_max - _y_min + 1)

	var avail_w := size.x - padding * 2
	var avail_h := size.y - padding * 2
	if avail_w <= 0 or avail_h <= 0:
		return

	# fit the whole grid into the panel
	var cell = floor(min(avail_w / float(w), avail_h / float(h)))
	cell = max(2.0, cell)

	# center it
	var draw_w = cell * w
	var draw_h = cell * h
	var origin := Vector2(
		padding + (avail_w - draw_w) * 0.5,
		padding + (avail_h - draw_h) * 0.5
	)

	# draw rooms
	for y in range(_y_min, _y_max + 1):
		for x in range(_x_min, _x_max + 1):
			var pos := Vector2(x, y)
			if not Global.is_valid(pos):
				continue

			var px = origin.x + (x - _x_min) * cell
			var py = origin.y + (y - _y_min) * cell
			var rect := Rect2(Vector2(px, py), Vector2(cell, cell))

			var is_visited = Global.is_visited(pos)
			var is_current := int(_current_room.x) == x and int(_current_room.y) == y

			if is_current:
				draw_rect(rect, current_color, true)
			elif is_visited:
				draw_rect(rect, visited_color, true)
			elif show_unvisited_outline:
				var oc := outline_color
				oc.a = unvisited_outline_alpha
				draw_rect(rect, oc, false, 1.0)

	# player dot (center of current room)
	var cx = origin.x + (int(_current_room.x) - _x_min + 0.5) * cell
	var cy = origin.y + (int(_current_room.y) - _y_min + 0.5) * cell
	draw_circle(Vector2(cx, cy), player_dot_radius, Color(0.2, 0.8, 1.0, 1.0))
