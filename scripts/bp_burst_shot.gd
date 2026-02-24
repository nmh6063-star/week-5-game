extends BulletPattern

@export var burst_count: int = 3
@export var burst_delay: float = 0.2

# Fires a single bullet aimed at target_pos
func fire(target_pos: Vector2 = Vector2.ZERO):
	if not bullet_scene or not shoot_allowed():
		return

	for i in range(burst_count):
		var bullet = bullet_scene.instantiate()
		
		bullet.global_position = global_position

		var direction = (target_pos - global_position).normalized()
		bullet.direction = direction
		bullet.rotation = direction.angle()
		
		get_tree().current_scene.add_child(bullet)

		await get_tree().create_timer(burst_delay).timeout
