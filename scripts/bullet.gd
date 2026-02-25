extends CharacterBody2D

var speed = 20.0
var direction

func _ready():
	#direction = global_position.direction_to(get_global_mouse_position())
	self.name = "Bullet"

func _physics_process(delta):
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta * speed)
	if collision and collision.get_collider().name != "Player":
		if collision.get_collider().has_method("slow"):
			collision.get_collider().slow()
			if Global.powers["push"] == 1:
				print("push")
				collision.get_collider().apply_knockback(self.direction, Global.powers["push"] * 100.0)
		print(collision.get_collider().name)
		self.queue_free()
		#print("AHHH")
