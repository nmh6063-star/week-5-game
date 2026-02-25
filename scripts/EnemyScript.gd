extends CharacterBody2D

@export var speed = 20.0

var dirs = [
	[0, -25],
	[25, -25],
	[25, 0],
	[25, 25],
	[0, 25],
	[-25, 25],
	[-25, 0],
	[-25, -25]
]

var room_pos = Vector2(0, 0)

var commit = [0, -25]

var direction

var health = 1

var timer = 0

@export var enemytype: int = 0

@onready var start_pos = Vector2(-1, -1)

@onready var nav_agent = $NavigationAgent2D

var bullet_pattern: BulletPattern

var knockback_force = Vector2.ZERO

func _ready():
	nav_agent.target_position = get_node("/root/Node2D/Player").position
	
	for child in get_children():
		if child is BulletPattern:
			bullet_pattern = child
			break # Stop once we find one
			
	if bullet_pattern == null:
		push_warning("Enemy has no BulletPattern child node!")
	#nav_agent.navigation_finished.connect(_on_nav_finished)
	#nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	#make_path(Vector2(randi_range(0, 10), randi_range(0, 10)))

func _physics_process(delta):
	if Global.room_position == start_pos:
		knockback_force = lerp(knockback_force, Vector2.ZERO, 0.2)
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(self.position, get_node("/root/Node2D/Player").position)
		var result = space_state.intersect_ray(query)
		if (result and str(result.collider).contains("TileMap") and enemytype == 2) or enemytype == 1:
			var hits = []
			for dir in dirs:
				query = PhysicsRayQueryParameters2D.create(self.position, self.position + Vector2(dir[0], dir[1]))
				result = space_state.intersect_ray(query)
				if result:
					hits.append(dir)
			var origin = Global.room_position * 288
			var passed = false
			if self.position.x > origin.x + 90 or self.position.x < origin.x - 90 or self.position.y > origin.y + 90 or self.position.y < origin.y - 90:
				passed = true
				if self.position.x > origin.x + 90:
					self.position.x -= 0.1
				elif self.position.x < origin.x - 90:
					self.position.x += 0.1
				elif self.position.y > origin.y + 90:
					self.position.y -= 0.1
				else:
					self.position.y += 0.1
			if commit in hits or passed:
				var random = randi_range(0, dirs.size()-1)
				var counter = 0
				while dirs[random] in hits:
					counter += 1
					random = randi_range(0, dirs.size()-1)
					if counter > dirs.size():
						break
				commit = dirs[random]
			direction = global_position.direction_to(self.position + Vector2(commit[0], commit[1]))
			velocity = direction * speed + knockback_force
			move_and_slide()
		else:
			if !nav_agent.is_target_reached():
				var nav_point_direction = to_local(nav_agent.get_next_path_position()).normalized()
				var tempSpeed = speed
				if timer > 0:
					tempSpeed /= Global.slow_multi
				var new_velocity = nav_point_direction * tempSpeed + knockback_force
				if nav_agent.avoidance_enabled:
					nav_agent.set_velocity(new_velocity)
				else:
					_on_navigation_agent_2d_velocity_computed(new_velocity)
				move_and_slide()
			#print(nav_agent.is_target_reached())
		if health <= 0:
			Global.enemy_kills += 1
			self.queue_free()
		if timer > 0:
			timer -= delta
			self.modulate = Color8(0, 255, 255, 255)
		else:
			self.modulate = Color8(255, 255, 255, 255)
		var player = get_node_or_null("/root/Node2D/Player")
		if player and bullet_pattern:
			bullet_pattern.fire(player.global_position)

func _on_timer_timeout():
	if Global.room_position == start_pos:
		var player = get_node_or_null("/root/Node2D/Player")
		if nav_agent.target_position != player.position or nav_agent.is_target_reachable():
			nav_agent.target_position = nav_agent.target_position + ((get_node("/root/Node2D/Player").position - nav_agent.target_position))
		get_node("Timer").start()

func take_damage(damage):
	health -= damage

func slow():
	timer = clamp(timer + 1, 0, 5 * Global.slow_multi)

func apply_knockback(direction: Vector2, strength: float):
	knockback_force = direction.normalized() * strength
	


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
