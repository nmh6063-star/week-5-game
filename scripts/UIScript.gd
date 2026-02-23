extends CanvasLayer

func _ready():
	update_bullet_count()

func update_bullet_count():
	$Control/MarginContainer3/HBoxContainer/BulletCount.text = "x %d" % Global.bullet_count
