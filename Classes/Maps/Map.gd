extends Node

var maps = {
	"TestMap": preload("res://Classes/Maps/TestMap.gd").new()
}

func _ready():
	pass
	
func validate_character_position(character):
	return maps[character.get_logout_map()].validate_character_position(character)
	
func get_respawn_position(map):
	return maps[map].get_respawn_position()