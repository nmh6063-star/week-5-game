extends CharacterBody2D

var speed = 20.0

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

@onready var nav_agent = $NavigationAgent2D

func _ready():
	nav_agent.target_position = get_node("/root/Node2D/Player").position
	#nav_agent.navigation_finished.connect(_on_nav_finished)
	#nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	#make_path(Vector2(randi_range(0, 10), randi_range(0, 10)))

func _physics_process(delta):
	"""var space_state = get_world_2d().direct_space_state
	var hits = []
	var query
	for dir in dirs:
		query = PhysicsRayQueryParameters2D.create(self.position, self.position + Vector2(dir[0], dir[1]))
		var result = space_state.intersect_ray(query)
		if result:
			hits.append(dir)
	var origin = room_pos * 288
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
		while dirs[random] in hits:
			random = randi_range(0, hits.size()-1)
		commit = dirs[random]
	direction = global_position.direction_to(self.position + Vector2(commit[0], commit[1]))
	velocity = direction * speed
	move_and_slide()"""
	
	if !nav_agent.is_target_reached():
		var nav_point_direction = to_local(nav_agent.get_next_path_position()).normalized()
		var new_velocity = nav_point_direction * speed
		if nav_agent.avoidance_enabled:
			nav_agent.set_velocity(new_velocity)
		else:
			_on_navigation_agent_2d_velocity_computed(new_velocity)
		move_and_slide()
		print(get_node("/root/Node2D/Player").position)
	print(nav_agent.is_target_reached())
	
func _on_timer_timeout():
	if nav_agent.target_position != Vector2(50, 50) or nav_agent.is_target_reachable():
		nav_agent.target_position = nav_agent.target_position + ((get_node("/root/Node2D/Player").position - nav_agent.target_position)/5)
	get_node("Timer").start()

func _draw():
	for dir in dirs:
		draw_line(self.position, self.position + Vector2(dir[0], dir[1]), Color.GREEN, 1.0)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
