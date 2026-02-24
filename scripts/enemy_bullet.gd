extends CharacterBody2D

@export var speed: float = 100.0
var direction: Vector2 = Vector2.ZERO

func _process(delta: float):
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("take_damage"):
			collision.get_collider().take_damage(1)
		self.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() 

	
