extends Node2D

var cursor

var room = preload("res://scenes/rooms/room_lrud.tscn")
var roomPos = Vector2.ZERO
var lastDir = ""
@export var xBounds: Vector2 = Vector2(-2, 2)
@export var maxY: int = 5
var stopGen = false
var roomDirections = ["LR", "LRD", "LRU", "LRUD"]
var rooms = []
var roomAssignment = []
var roomy = 0
var downCounter = 0
var UI

func _ready():
	#process_mode = Node.PROCESS_MODE_ALWAYS
	cursor = get_node("Cursor")
	UI = get_node("UI")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Timer.start()
	roomPos.x = randi_range(xBounds.x, xBounds.y)
	Global.room_position = Vector2(roomPos.x, 0)
	get_node("Player").position = Global.room_position * 288
	var inst = room.instantiate()
	self.add_child(inst)
	inst.position = roomPos * 288
	var roomType = randi_range(0, roomDirections.size()-1)
	roomAssignment.append(roomDirections[roomType])
	rooms.append(inst)
	while roomPos.y != maxY:
		_room_gen()
	var counter = 0
	for i in range(maxY+1):
		for x in range(xBounds.x, xBounds.y+1):
			var breaker = false
			for room in rooms:
				if room.position/288 == Vector2(x, i):
					breaker = true
					break
			if breaker:
				continue
			inst = room.instantiate()
			self.add_child(inst)
			inst.position = Vector2(x, i) * 288
			roomType = randi_range(0, roomDirections.size()-1)
			roomAssignment.append(roomDirections[roomType])
			rooms.append(inst)
	for room in rooms:
		room._check(roomAssignment[counter])
		counter += 1
		
	# mark valid rooms for minimap
	for r in rooms:
		Global.mark_valid(r.position / 288)

	# starting room visited
	Global.mark_visited(Global.room_position)
			
	
	

func _on_timer_timeout():
	if Global.bullet_count < 10:
		Global.bullet_count += 1
		UI.update_bullet_count()
		print("add")
	
func _room_gen():
	var inst = room.instantiate()
	self.add_child(inst)
	var dir = randi_range(0, 4)
	var direction = ""
	if dir == 0 or dir == 1:
		direction = "left"
	elif dir == 2 or dir == 3:
		direction = "right"
	else:
		direction = "down"
	while lastDir == direction and !(direction == "down" and lastDir == ""):
		dir = randi_range(0, 4)
		if dir == 0 or dir == 1:
			direction = "left"
		elif dir == 2 or dir == 3:
			direction = "right"
		else:
			direction = "down"
	if direction == "left" and roomPos.x > xBounds.x:
		print("left")
		roomPos.x -= 1
		var roomType = randi_range(0, roomDirections.size()-1)
		roomAssignment.append(roomDirections[roomType])
		downCounter = 0
	elif direction == "right" and roomPos.x < xBounds.y:
		print("right")
		roomPos.x += 1
		var roomType = randi_range(0, roomDirections.size()-1)
		roomAssignment.append(roomDirections[roomType])
		downCounter = 0
	elif roomPos.y < maxY:
		downCounter += 1
		print("down")
		roomPos.y += 1
		var roomType = randi_range(2, roomDirections.size()-1)
		if (roomAssignment[roomAssignment.size()-1] == "LR" or roomAssignment[roomAssignment.size()-1] == "LRU" or downCounter >= 2):
			var inst2 = room.instantiate()
			self.add_child(inst2)
			inst2.position = Vector2(rooms[rooms.size()-1].position.x, rooms[rooms.size()-1].position.y)
			var dir2 = randi_range(0, 1)
			roomAssignment.pop_back()
			if downCounter >= 2:
				roomAssignment.append("LRUD")
				print("special case")
			else:
				if dir2 == 1:
					roomAssignment.append("LRD")
				else:
					roomAssignment.append("LRUD")
			rooms[rooms.size()-1].queue_free()
			rooms.pop_back()
			rooms.append(inst2)
			print("had to edit")
		roomAssignment.append(roomDirections[roomType])
	if direction == "left":
		lastDir = "right"
	elif direction == "right":
		lastDir = "left"
	else:
		lastDir = "pass"
	inst.position = roomPos * 288
	rooms.append(inst)


func _unhandled_input(event):
	# Press Q to quit the game
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q:
			get_tree().quit()
