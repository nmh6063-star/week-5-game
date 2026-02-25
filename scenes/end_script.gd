extends CanvasLayer

func _ready():
	$"Control/Card 1/VBoxContainer/Label".text = "You Died!\nYou killed " + str(Global.enemy_kills) + " enemies\nYou reached floor " + str(Global.floor)
