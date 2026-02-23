extends Node

var bullet_count = 10
var player_health = 5
var room_position = Vector2.ZERO

var visited_rooms := {}
var valid_rooms := {}

func _key(pos: Vector2) -> String:
	return "%d,%d" % [int(pos.x), int(pos.y)]

func mark_visited(pos: Vector2) -> void:
	visited_rooms[_key(pos)] = true

func is_visited(pos: Vector2) -> bool:
	return visited_rooms.has(_key(pos))

func mark_valid(pos: Vector2) -> void:
	valid_rooms[_key(pos)] = true

func is_valid(pos: Vector2) -> bool:
	return valid_rooms.has(_key(pos))
