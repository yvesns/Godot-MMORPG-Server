extends Node

var character_name

func _ready():
	pass
	
func get_name():
	return character_name
	
func set_name(character_name):
	self.character_name = character_name