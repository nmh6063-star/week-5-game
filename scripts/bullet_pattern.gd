extends Node2D

class_name BulletPattern

@export var bullet_scene: PackedScene
@export var fire_rate: float = 3

var can_fire: bool = true
var timer: Timer

func _ready():
	timer = get_node_or_null("Timer")
	if not timer:
		timer = Timer.new()
		timer.name = "Timer"
		add_child(timer)
	timer.wait_time = fire_rate
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)

# This is the function the enemy will call
func fire(target_pos: Vector2 = Vector2.ZERO):
	pass # Overridden by specific patterns

func shoot_allowed() -> bool:
	if can_fire:
		can_fire = false
		timer.start()
		return true
	return false

func _on_timer_timeout() -> void:
	can_fire = true
