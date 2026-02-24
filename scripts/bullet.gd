extends CharacterBody2D

var speed = 20.0
var direction

func _ready():
	direction = global_position.direction_to(get_global_mouse_position())

func _physics_process(delta):
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta * speed)
	if collision and collision.get_collider().name != "Player":
		if collision.get_collider().has_method("slow"):
			collision.get_collider().slow()
		self.queue_free()
		#print("AHHH")
