extends "res://Classes/Character.gd"

var character_class
var character_race

func _ready():
	pass
	
func get_class():
	return character_class
	
func set_class(character_class):
	self.character_class = character_class
	
func get_race():
	return character_race
	
func set_race(character_race):
	self.character_race = character_race
	
func serialize():
	return {
		character_name = self.character_name,
		character_race = self.character_race,
		character_class = self.character_class
	}
	
func deserialize(character):
	set_name(character.character_name)
	set_race(character.character_race)
	set_class(character.character_class)