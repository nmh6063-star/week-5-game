extends CanvasLayer

var _mini_map: Control
var _dash_controls: HBoxContainer
var _kill_points: Label

var _x_min: int = 0
var _x_max: int = 0
var _y_min: int = 0
var _y_max: int = 0

func _ready():
	update_bullet_count()
	_mini_map = $Control/MinimapPanel/MarginContainer4/MiniMapView
	_dash_controls = $Control/MarginContainer/HBoxContainer/DashControls
	_kill_points = $Control/MarginContainer4/HBoxContainer/KillPoints
	# Wait until GameManager finished generating and Global.valid_rooms is filled.
	$Control/MarginContainer3/HBoxContainer/BulletCount.max_value = Global.bullet_cap
	call_deferred("_init_minimap")

func _process(_delta):
	if _kill_points != null:
		_kill_points.text = "Kill Points: " + str(Global.points)

	if _dash_controls == null:
		return
	var dash_power = Global.powers["dash"]
	_dash_controls.visible = dash_power != 0
	if _dash_controls.visible:
		var can_dash = Global.bullet_count >= floor(7.0 / dash_power)
		_dash_controls.modulate = Color.WHITE if can_dash else Color(0.5, 0.5, 0.5, 1.0)

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
	$Control/MarginContainer3/HBoxContainer/BulletCount.value = Global.bullet_count

func on_enter_room(room_pos: Vector2) -> void:
	# mark discovery
	Global.mark_visited(room_pos)

	# update minimap highlight
	if _mini_map != null and _mini_map.has_method("set_current_room"):
		_mini_map.set_current_room(room_pos)
