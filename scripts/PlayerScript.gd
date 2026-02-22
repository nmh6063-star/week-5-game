extends CharacterBody2D

var cam

var animator

var bullet = preload("res://scenes/bullet.tscn")

func _ready():
	cam = get_viewport().get_camera_2d()
	animator = get_node("AnimatedSprite2D")

func _physics_process(delta):
	var horizontal = Input.get_axis("move_left", "move_right")
	var vertical = Input.get_axis("move_up", "move_down")
	velocity.x = horizontal * 100.0
	velocity.y = vertical * 100.0
	move_and_slide()
	var distance = self.position - get_global_mouse_position()
	var angle = abs(asin(distance.y/distance.x)) / PI * 2
	#print(distance)
	var camPos = self.position
	if abs(distance.x) > 50.0:
		camPos = Vector2(self.position.x - clamp((distance.x - (abs(distance.x)/distance.x) * 50.0)/5.0, -25.0, 25.0), camPos.y)
	if abs(distance.y) > 50.0:
		camPos = Vector2(camPos.x, self.position.y - clamp((distance.y - (abs(distance.y)/distance.y) * 50.0)/5.0, -25.0, 25.0))
	camPos = Vector2(clamp(camPos.x, (Global.room_position.x - 1) * 288 + 275, (Global.room_position.x + 1) * 288 - 275), clamp(camPos.y, (Global.room_position.y - 1) * 288 + 225, (Global.room_position.y + 1) * 288 - 225))
	cam.position = camPos
	if self.position.x > get_global_mouse_position().x:
		angle *= -1
	#print(angle)
	var modifier
	if velocity.x != 0 or velocity.y != 0:
		modifier = "run"
	else:
		modifier = "idle"
	if abs(angle) == 1.0:
		if self.position.y > get_global_mouse_position().y:
			animator.play(modifier + "_up")
		else:
			animator.play(modifier + "_down")
	else:
		if angle < 0:
			animator.play(modifier + "_left")
		else:
			animator.play(modifier + "_right")
			
	if Input.is_action_just_pressed("shoot") and Global.bullet_count > 0:
		var inst = bullet.instantiate()
		inst.position = self.position
		inst.rotation = atan(distance.y/distance.x)
		get_tree().get_root().add_child(inst)
		Global.bullet_count -= 1
		print(Global.bullet_count)
	if self.position.x < (Global.room_position.x - 1) * 288 + 125:
		cam.move = true
		Global.room_position.x -= 1
		cam.target = Global.room_position * 288
		get_tree().paused = true
	elif self.position.x > (Global.room_position.x + 1) * 288 - 125:
		cam.move = true
		Global.room_position.x += 1
		cam.target = Global.room_position * 288
		get_tree().paused = true
	elif self.position.y > (Global.room_position.y + 1) * 288 - 125:
		cam.move = true
		Global.room_position.y += 1
		cam.target = Vector2(Global.room_position.x * 288, Global.room_position.y * 288 - 45.0)
		get_tree().paused = true
	elif self.position.y < (Global.room_position.y - 1) * 288 + 125:
		cam.move = true
		Global.room_position.y -= 1
		cam.target = Vector2(Global.room_position.x * 288, Global.room_position.y * 288 + 45.0)
		get_tree().paused = true
	
	
