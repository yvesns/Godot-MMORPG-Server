extends Node

var items

func _ready():
	pass

func init(player_name):
	var database_inventory = DatabaseManager.get_inventory(character_name)
	
	return true