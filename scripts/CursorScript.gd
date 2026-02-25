extends Sprite2D

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	self.position = get_global_mouse_position()
