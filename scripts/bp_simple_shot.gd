extends BulletPattern

# Fires a single bullet aimed at target_pos
func fire(target_pos: Vector2 = Vector2.ZERO):
	if not bullet_scene or not shoot_allowed():
		return

	if target_pos == Vector2.ZERO:
		target_pos = global_position + Vector2.RIGHT

	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	
	var direction = (target_pos - global_position).normalized()
	bullet.direction = direction
	bullet.rotation = direction.angle()
	
	get_tree().current_scene.add_child(bullet)
