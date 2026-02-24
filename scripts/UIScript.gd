extends CanvasLayer

var _mini_map: Control

var _x_min: int = 0
var _x_max: int = 0
var _y_min: int = 0
var _y_max: int = 0

func _ready():
	update_bullet_count()
	_mini_map = $Control/MinimapPanel/MarginContainer4/MiniMapView
	# Wait until GameManager finished generating and Global.valid_rooms is filled.
	call_deferred("_init_minimap")

func _init_minimap() -> void:
	var gm = get_parent()
	if gm == null:
		return

	_x_min = int(gm.xBounds.x)
	_x_max = int(gm.xBounds.y)
	_y_min = 0
	_y_max = int(gm.maxY)

	if _mini_map != null and _mini_map.has_method("configure"):
		_mini_map.configure(_x_min, _x_max, _y_min, _y_max)

	# starting room visited + draw
	on_enter_room(Global.room_position)

func update_bullet_count():
	$Control/MarginContainer3/HBoxContainer/BulletCount.text = "x %d" % Global.bullet_count

func on_enter_room(room_pos: Vector2) -> void:
	# mark discovery
	Global.mark_visited(room_pos)

	# update minimap highlight
	if _mini_map != null and _mini_map.has_method("set_current_room"):
		_mini_map.set_current_room(room_pos)
