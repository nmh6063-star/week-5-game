extends Node2D

class_name BulletPattern

@export var bullet_scene: PackedScene
@export var fire_rate: float = 3

var root_fire

var can_fire: bool = true
var timer: Timer

func _ready():
	timer = get_node_or_null("Timer")
	if not timer:
		timer = Timer.new()
		timer.name = "Timer"
		add_child(timer)
	root_fire = randf_range(fire_rate - 0.5, fire_rate) / Global.fire_rate_multi
	timer.wait_time = root_fire
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)

# This is the function the enemy will call
func fire(target_pos: Vector2 = Vector2.ZERO):
	pass # Overridden by specific patterns

func _process(delta):
	if get_parent().timer > 0:
		timer.wait_time = root_fire * Global.slow_multi
	else:
		timer.wait_time = root_fire

func shoot_allowed() -> bool:
	if can_fire:
		can_fire = false
		timer.start()
		return true
	return false

func _on_timer_timeout() -> void:
	can_fire = true
