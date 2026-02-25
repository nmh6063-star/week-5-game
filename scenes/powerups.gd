extends CanvasLayer

@onready var card1Button: Button = get_node("Control/Card 1/VBoxContainer/Select")
@onready var card2Button: Button = get_node("Control/Card 2/VBoxContainer/Select")

@onready var card1Label: Label = get_node("Control/Card 1/VBoxContainer/Label")
@onready var card2Label: Label = get_node("Control/Card 2/VBoxContainer/Label")

var ability_list = [{
	"description": "Add 1 bullet to your bullet cap"
},
{
	"description": "Add 2 hearts to your health"
},
{
	"description": "Your bullets make enemies move even slower and shoot even slower"
},
{
	"description": "You can press shift to dash. Burn bullets to dash. Subsequent upgrades will decrease the number of bullets needed to dash"
},
{
	"description": "Your bullets will now push enemies away. Subsequent upgrades will increase the distance enemies are pushed"
},
{
	"description": "Change your gun to a shotgun. Shoot bullets in a burst rather than one by one. Subsequent upgrades will increase bullets shot"
}]

var weights = [1.0, 0.7, 0.4, 0.2, 0.15, 0.1]

var pick1
var pick2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if card1Button:
		card1Button.pressed.connect(_on_my_button1_pressed)
	if card2Button:
		card2Button.pressed.connect(_on_my_button2_pressed)
	var num = randf_range(0.0, 1.0)
	print(num)
	if num < weights[0] and num > weights[1]:
		pick1 = 0
	elif num < weights[1] and num > weights[2]:
		pick1 = 1
	elif num < weights[2] and num > weights[3]:
		pick1 = 2
	elif num < weights[3] and num > weights[4]:
		pick1 = 3
	elif num < weights[4] and num > weights[5]:
		pick1 = 4
	else:
		pick1 = 5
	num = randf_range(0.0, 1.0)
	if num < weights[0] and num > weights[1]:
		pick2 = 0
	elif num < weights[1] and num > weights[2]:
		pick2 = 1
	elif num < weights[2] and num > weights[3]:
		pick2 = 2
	elif num < weights[3] and num > weights[4]:
		pick2 = 3
	elif num < weights[4] and num > weights[5]:
		pick2 = 4
	else:
		pick2 = 5
	card1Label.text = ability_list[pick1]["description"]
	card2Label.text = ability_list[pick2]["description"]
	#print("pick 1 was " + str(pick1))
	#print("pick 2 was " + str(pick2))

func _on_my_button1_pressed():
	#print("Button 1 was pressed! Function executed.")
	print(ability_list[pick1]["description"])
	if pick1 == 0:
		Global.bullet_cap += 1
	elif pick1 == 1:
		Global.player_health += 2
	elif pick1 == 2:
		Global.slow_multi += 0.5
	elif pick1 == 3:
		Global.powers["dash"] += 1
	elif pick1 == 4:
		Global.powers["push"] += 1
	elif pick1 == 5:
		Global.powers["shotgun"] += 1
	_return_to_game()

func _on_my_button2_pressed():
	print(ability_list[pick2]["description"])
	if pick2 == 0:
		Global.bullet_cap += 1
	elif pick2 == 1:
		Global.player_health += 2
	elif pick2 == 2:
		Global.slow_multi += 0.5
	elif pick2 == 3:
		Global.powers["dash"] += 1
	elif pick2 == 4:
		Global.powers["push"] += 1
	elif pick2 == 5:
		Global.powers["shotgun"] += 1
	_return_to_game()

func _return_to_game():
	Global.visited_rooms = {}
	Global.valid_rooms = {}
	Global.weights[1] = clamp(Global.weights[1] + 0.1, 0.0, 1.0)
	Global.weights[2] = clamp(Global.weights[2] + 0.05, 0.0, 1.0)
	Global.spawn_rate += 1
	Global.fire_rate_multi += 0.1
	Global.bullet_count = Global.bullet_cap
	Global.floor += 1
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
	
