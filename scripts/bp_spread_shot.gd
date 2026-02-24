extends BulletPattern

@export var bullet_count: int = 8

func fire(target_pos: Vector2 = Vector2.ZERO):
	if not bullet_scene or not shoot_allowed():
		return
		
	for i in range(bullet_count):
		var bullet = bullet_scene.instantiate()
		var angle = i * (2 * PI / bullet_count)
		
		# Set bullet position, direction, and angle
		bullet.global_position = global_position
		bullet.direction = Vector2.RIGHT.rotated(angle)
		bullet.rotation = angle
		
		# Add bullet to the level root, not the enemy
		get_tree().current_scene.add_child(bullet)
