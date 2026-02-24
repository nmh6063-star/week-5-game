extends CharacterBody2D

var cam

var animator

var bullet = preload("res://scenes/bullet.tscn")

var UI
var Health

var melee_area
var melee_poly
var bat_sprite

var is_melee_attacking = false
var melee_cooldown = 0.25
var melee_active_time = 0.12
var melee_range = 25.0
var melee_arc_points = 18
var last_melee_time = -999.0

func _ready():
	cam = get_viewport().get_camera_2d()
	animator = get_node("AnimatedSprite2D")
	UI = get_node("../UI")
	Health = get_node("../UI/Control/MarginContainer2/Health")
	melee_area = get_node("MeleeArea")
	melee_poly = get_node("MeleeArea/MeleeShape")
	bat_sprite = get_node("BatSprite")

	melee_area.monitoring = false
	bat_sprite.visible = false

	if not melee_area.body_entered.is_connected(_on_melee_area_body_entered):
		melee_area.body_entered.connect(_on_melee_area_body_entered)
	_build_melee_semicircle()
	
	
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
		UI.update_bullet_count()
		print(Global.bullet_count)
		
	# --- Room transition ---
	var old_center = Global.room_position * 288
	var cam_offset = cam.position - old_center

	if self.position.x < (Global.room_position.x - 1) * 288 + 125:
		cam.move = true
		Global.room_position.x -= 1
		var new_center = Global.room_position * 288
		cam.target = new_center + cam_offset
		get_tree().paused = true
		UI.on_enter_room(Global.room_position) # <- 给 minimap 用（下面会加）
	elif self.position.x > (Global.room_position.x + 1) * 288 - 125:
		cam.move = true
		Global.room_position.x += 1
		var new_center = Global.room_position * 288
		cam.target = new_center + cam_offset
		get_tree().paused = true
		UI.on_enter_room(Global.room_position)
	elif self.position.y > (Global.room_position.y + 1) * 288 - 125:
		cam.move = true
		Global.room_position.y += 1
		var new_center = Global.room_position * 288
		cam.target = new_center + cam_offset - Vector2(0, 125)
		get_tree().paused = true
		UI.on_enter_room(Global.room_position)
	elif self.position.y < (Global.room_position.y - 1) * 288 + 125:
		cam.move = true
		Global.room_position.y -= 1
		var new_center = Global.room_position * 288
		cam.target = new_center + cam_offset + Vector2(0, 125)
		get_tree().paused = true
		UI.on_enter_room(Global.room_position)
	
	if Input.is_action_just_pressed("melee"):
		_try_melee_attack()
	
func _build_melee_semicircle():
	var pts = PackedVector2Array()
	pts.append(Vector2.ZERO)

	for i in range(melee_arc_points + 1):
		var t = float(i) / float(melee_arc_points)
		var ang = lerp(-PI * 0.5, PI * 0.5, t)
		var p = Vector2(cos(ang), sin(ang)) * melee_range
		pts.append(p)

	melee_poly.polygon = pts


func _mouse_dir() -> Vector2:
	var d = get_global_mouse_position() - global_position
	if d.length() < 0.001:
		return Vector2.RIGHT
	return d.normalized()


func _try_melee_attack():
	var now = Time.get_ticks_msec() / 1000.0
	if is_melee_attacking:
		return
	if now - last_melee_time < melee_cooldown:
		return

	last_melee_time = now
	is_melee_attacking = true

	var dir = _mouse_dir()

	var anim_name = "attack_right"
	if abs(dir.x) > abs(dir.y):
		if dir.x < 0:
			anim_name = "attack_left"
		else:
			anim_name = "attack_right"
	else:
		if dir.y < 0:
			anim_name = "attack_up"
		else:
			anim_name = "attack_down"

	melee_area.rotation = dir.angle()

	melee_area.monitoring = true
	bat_sprite.visible = true
	bat_sprite.play(anim_name)

	await get_tree().create_timer(melee_active_time).timeout
	melee_area.monitoring = false

	await get_tree().create_timer(0.8).timeout
	bat_sprite.visible = false

	is_melee_attacking = false

func _on_melee_area_body_entered(body):
	if body == self:
		return
	print(body)
	if body.has_method("take_damage"):
		body.take_damage(1)
	elif body.has_method("hit"):
		body.hit(1)
	elif body.is_in_group("damageable"):
		if body.has_method("die"):
			body.die()
	else:
		print("Melee hit: ", body.name)

func take_damage(dmg: int):
	Global.player_health -= dmg
	Health.update_hearts()
	print("damage taken")
