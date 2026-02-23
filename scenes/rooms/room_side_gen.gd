extends TileMap

@onready var opening:String = "LRUD"
@onready var cells = self.get_used_cells(0)

func _check(data):
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
	_gen_room()


func _gen_room():
	var level = Global.level_data[randi_range(0, Global.level_data.size()-1)]["coordinates"]
	for cell in level:
		self.set_cell(0, Vector2(cell.x, cell.y), 0, Vector2(6, 23))
	
