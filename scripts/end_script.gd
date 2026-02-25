extends CanvasLayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$"Control/Card 1/MarginContainer/VBoxContainer/Label".text = "You Died!\nYou killed " + str(Global.enemy_kills) + " enemies\nYou reached floor " + str(Global.floor)
	$"Control/Card 1/MarginContainer/VBoxContainer/MarginContainer/Restart".pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	Global.bullet_count = 10
	Global.player_health = 5
	Global.bullet_cap = 10
	Global.room_position = Vector2.ZERO
	Global.spawn_rate = 2
	Global.enemy_kills = 0
	Global.slow_multi = 1.5
	Global.weights = [1.0, 0.25, 0.0]
	Global.fire_rate_multi = 1.0
	Global.floor = 1
	Global.points = 0
	Global.powers = {"pull": 0, "push": 0, "shotgun": 0, "dash": 0}
	Global.visited_rooms = {}
	Global.valid_rooms = {}
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
