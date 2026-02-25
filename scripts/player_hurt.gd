extends CharacterBody2D

func _process(delta):
	self.position = get_node("/root/Node2D/Player").position
