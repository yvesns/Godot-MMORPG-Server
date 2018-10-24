extends Node

var maximum_player_characters = 3
var maximum_character_name_length = 20
var character_name_regex = RegEx.new()

func _ready():
	character_name_regex.compile("[^A-Za-z0-9]")
	
func validate_character_creation_info(player, character):
	var character_count = DatabaseManager.get_characters(player).size()
	var character_class
	
	print(character)
	print(character.get_name())
	print(character.get_race())
	print(character.get_class())
		
	if character_count >= Global.maximum_player_characters:
		return "Maximum number of characters reached"
		
	if (character.get_name().length() < 3 ||
	    character.get_name().length() > maximum_character_name_length):
		return "Invalid character name size"
		
	if character_name_regex.search(character.get_name()) != null:
		return "Invalid character name: only letters and numbers are allowed"
		
	if DatabaseManager.has_character(character.get_name()):
		return "Name already taken"
		
	character_class = DatabaseManager.get_class(character.get_class())
	
	if (character_class.size() <= 0 ||
	    character_class[0].race_fk != character.get_race()):
		return "Invalid race or class"
		
	return null