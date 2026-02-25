extends Camera2D

var move = false
var target = Vector2.ZERO
var move_speed = 8.0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	if move:
		self.position = position.lerp(target, delta * move_speed)
		if self.position.x < target.x + 1.0 and self.position.x > target.x - 1.0 and self.position.y < target.y + 1.0 and self.position.y > target.y - 1.0:
			self.position = target
			move = false
			await get_tree().create_timer(0.05).timeout
			get_tree().paused = false
	
