extends Node

var SQLite
var db
var db_file = "res://database.sql"

var Inventory = preload("res://Classes/Player/Inventory.gd")
var Item = preload("res://Classes/Item/Item.gd")

enum BindType { DOUBLE, INT, TEXT }

func _ready():
	pass

func init_database():
	SQLite = load("res://lib/gdsqlite.gdns")
	var result = null
	
	#Just for testing, remove later.
	Directory.new().remove("res://database.sql")
	
	db = SQLite.new()
	
	if (!db.open(db_file)):
		print("Failed to open database.")
		return
	
	init_tables()
	
	#Remove later.
	run_tests()
	
func init_tables():
	var table_query
	var data_types
	
	print(db.simple_query(DatabaseQueries.create_player_table()))
	print(db.simple_query(DatabaseQueries.create_race_table()))
	print(db.simple_query(DatabaseQueries.create_class_table()))
	print(db.simple_query(DatabaseQueries.create_player_character_table()))
	print(db.simple_query(DatabaseQueries.create_map_table()))
	
	for table in DatabaseQueries.get_table_list():
		data_types = DatabaseInsertData.get_types(table)
		
		if data_types == null:
			continue
			
		table_query = DatabaseQueries.insert(table)
		
		for data in DatabaseInsertData.get_data(table):
			print(db.query(table_query, data, data_types.duplicate()))
	
func run_tests():
	var character_class = preload("res://Classes/Player/PlayerCharacter.gd")
	
	var char1 = character_class.new()
	char1.set_name("TestCharacter")
	char1.set_race("Human")
	char1.set_class("CommonHuman")
	
	var char2 = character_class.new()
	char2.set_name("TestCharacter2")
	char2.set_race("Vampire")
	char2.set_class("Blood Seeker")
	
	var item = Item.new()
	
	#print(insert_item())
	
	print(insert_player("test", "test".hash(), "mail"))
	print(insert_player_character("test", char1))
	print(insert_player_character("test", char2))
	print(db.fetch_assoc(DatabaseQueries.select_player(), ["test"], [TEXT]))
	print(has_player("test"))
	print(has_email("mail"))
	
	print(db.query(DatabaseQueries.insert_map(), ["TestMap"], [TEXT]))
	
##########
# Player #
##########
	
func has_player(player):
	return db.fetch_assoc(DatabaseQueries.select_player(), [player], [TEXT]).size() > 0
	
func has_email(email):
	return db.fetch_assoc(DatabaseQueries.select_player("email"), [email], [TEXT]).size() > 0
	
func insert_player(login, password, email):
	return db.query(DatabaseQueries.insert_player(), [login, password, email], [TEXT, INT, TEXT])
	
func get_player(player_name):
	var query_result = db.fetch_assoc(DatabaseQueries.select_player(), [player_name], [TEXT])
	
	if query_result.size() > 0:
		return query_result[0]
	
	return null
	
####################
# Player character #
####################

func has_character(character):
	return db.fetch_assoc(DatabaseQueries.select_player_character(), [character], [TEXT]).size() > 0
	
func insert_player_character(player, character):
	var info = [character.get_name(), player, character.get_race(), character.get_class()]
	
	return db.query(DatabaseQueries.insert_player_character(), info, [TEXT, TEXT, TEXT, TEXT])
	
func get_characters(player):
	return db.fetch_assoc(DatabaseQueries.select_player_characters(), [player], [TEXT])
	
func get_character(character_name):
	var query_result = db.fetch_assoc(DatabaseQueries.select_player_character(), [character_name], [TEXT])
	var inventory = Inventory.new()
	var character
	
	if !inventory.init(character_name):
		return null
	
	if query_result.size() <= 0:
		return null
	
	character = query_result[0]
	character.inventory = inventory.get_items()
	
	return query_result[0]
	
func delete_character(character_name):
	return db.query(DatabaseQueries.delete_player_character(), [character_name], [TEXT])
	
#########
# Class #
#########

func get_class(character_class):
	return db.fetch_assoc(DatabaseQueries.select_class(), [character_class], [TEXT])
	
########
# Item #
########

func get_item(item_id):
	return db.fetch_assoc(DatabaseQueries.select_item(), [item_id], [INT])
	
func insert_item(item):
	var db_item = Item.new()
	
	db_item.deserialize(item)
	
	return db.query(DatabaseQueries.insert_item(), db_item.to_database_array(), DatabaseInsertData.get_types("item"))
	
#############
# Inventory #
#############

func get_inventory(character_name):
	return db.fetch_assoc(DatabaseQueries.select_inventory(), [character_name], [TEXT])