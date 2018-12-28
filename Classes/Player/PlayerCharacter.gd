extends "res://Classes/Character.gd"

var player = ""
var character_class = ""
var character_race = ""
var respawn_map = ""
var logout_map = ""
var logout_x = 0
var logout_y = 0
var inventory

func _ready():
	pass
	
func build_character(character_name):
	var db_character = DatabaseManager.get_character(character_name)
	
	if db_character.size() <= 0:
		return null
		
	if !init_from_database(db_character):
		return null
		
	return self
	
func init_from_database(database_character):
	set_name(database_character.name)
	set_player(database_character.player_fk)
	set_race(database_character.race_fk)
	set_class(database_character.class_fk)
	set_respawn_map(database_character.respawn_map_fk)
	set_logout_map(database_character.logout_map_fk)
	set_logout_x(database_character.logout_x)
	set_logout_y(database_character.logout_y)
	set_inventory(Global.Inventory.new().build_inventory(database_character.name))
	
func get_player():
	return player
	
func set_player(player):
	self.player = player
	
func get_class():
	return character_class
	
func set_class(character_class):
	self.character_class = character_class
	
func get_race():
	return character_race
	
func set_race(character_race):
	self.character_race = character_race
	
func get_respawn_map():
	return respawn_map
	
func set_respawn_map(map):
	respawn_map = map
	
func get_logout_map():
	return logout_map
	
func set_logout_map(map):
	logout_map = map
	
func get_logout_x():
	return logout_x
	
func set_logout_x(x):
	logout_x = x
	
func get_logout_y():
	return logout_y
	
func set_logout_y(y):
	logout_y = y
	
func get_inventory():
	return inventory
	
func set_inventory(inventory):
	self.inventory = inventory
	
func serialize():
	return {
		character_name = self.character_name,
		character_race = self.character_race,
		character_class = self.character_class,
		respawn_map = self.respawn_map,
		logout_map = self.logout_map,
		logout_x = self.logout_x,
		logout_y = self.logout_y
	}
	
func deserialize(character):
	set_name(character.character_name)
	set_race(character.character_race)
	set_class(character.character_class)
	set_respawn_map(character.respawn_map)
	set_logout_map(character.logout_map)
	set_logout_x(character.logout_x)
	set_logout_y(character.logout_y)