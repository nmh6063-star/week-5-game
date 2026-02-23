extends HBoxContainer

const HEART_TEXTURE = preload("res://assets/PostApocalypse_AssetPack_v1.1.2/UI/HP/Heart_Full.png")

func _ready():
	update_hearts()

func update_hearts():
	for child in get_children():
		child.queue_free()
	for i in range(Global.player_health):
		var heart = TextureRect.new()
		heart.custom_minimum_size = Vector2(40, 40)
		heart.texture = HEART_TEXTURE
		heart.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(heart)
