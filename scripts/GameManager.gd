extends Node2D

var cursor

func _ready():
	cursor = get_node("Cursor")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	cursor.position = get_global_mouse_position()
