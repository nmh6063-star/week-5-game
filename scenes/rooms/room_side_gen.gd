extends TileMap

@onready var opening:String = "LRUD"
@onready var cells = self.get_used_cells(0)
@onready var room_pos = Vector2(0, -10)
var enemyGen = false

var enemy = preload("res://scenes/enemy.tscn")
var enemy_smart = preload("res://scenes/enemy_smart.tscn")
var enemy_smarter = preload("res://scenes/enemy_smarter.tscn")

func _check(data, start, pos):
	opening = data
	for cell in cells:
		if cell.x == 8 and cell.y > -2 and cell.y < 1 and "R" in opening:
			self.erase_cell(0, cell)
		if cell.x == -9 and cell.y > -2 and cell.y < 1 and "L" in opening:
			self.erase_cell(0, cell)
		if cell.y == -9 and cell.x > -2 and cell.x < 1 and "U" in opening:
			self.erase_cell(0, cell)
		if cell.y == 8 and cell.x > -2 and cell.x < 1 and "D" in opening:
			self.erase_cell(0, cell)
	if !start:
		room_pos = pos
		_gen_room()

func _process(delta):
	if room_pos != Vector2(0, -10):
		if !enemyGen and Global.room_position == room_pos:
			var num = randi_range(0, Global.spawn_rate)
			if num != 0:
				for i in range(num):
					_enemy_spawn()
			enemyGen = true


func _gen_room():
	var level = Global.level_data[randi_range(0, Global.level_data.size()-1)]["coordinates"]
	for cell in level:
		self.set_cell(0, Vector2(cell.x, cell.y), 0, Vector2(6, 23))

func _enemy_spawn():
	var player = get_node("/root/Node2D/Player")
	var origin = room_pos * 288
	var range = []
	if player.position.y < origin.y - 75.0:
		range = [Vector2(-8, -2),Vector2(7, 7)]
		#range = [Vector2(),Vector2()]
		#direction = "d"
	elif player.position.y > origin.y + 75.0:
		range = [Vector2(-8, -8),Vector2(7, 1)]
		#direction = "u"
	elif player.position.x > origin.x + 75.0:
		print("coming from right")
		range = [Vector2(-8, -8),Vector2(1, -7)]
		#direction = "r"
	else:
		print("coming from left")
		range = [Vector2(-2, -8),Vector2(7, 7)]
		#direction = "l"
	cells = self.get_used_cells(0)
	var spawnable = []
	for cell in cells:
		if cell.x >= range[0].x and cell.x <= range[1].x and cell.y >= range[0].y and cell.y <= range[1].y:
			var tile = self.get_cell_atlas_coords(0, cell)
			if tile != Vector2i(6, 23):
				spawnable.append(cell)
	var num = randi_range(0, spawnable.size()-1)
	var typing = randf_range(0.0, 1.0)
	var inst
	if typing < Global.weights[0] and typing > Global.weights[1]:
		inst = enemy.instantiate()
	elif typing < Global.weights[1] and typing > Global.weights[2]:
		inst = enemy_smart.instantiate()
	else:
		inst = enemy_smarter.instantiate()
	var local_pos = self.map_to_local(spawnable[num])
	var global_pos = self.to_global(local_pos)
	inst.position = global_pos
	get_node("/root/Node2D").add_child(inst)
	inst.start_pos = room_pos
	
		
	
	
