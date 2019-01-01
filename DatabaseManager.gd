extends Node

var SQLite
var db
var db_file = "res://database.sql"

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
	var data
	
	for table in DatabaseQueries.get_table_list():
		print(db.simple_query(DatabaseQueries.create(table)))
	
	for table in DatabaseQueries.get_table_list():
		data_types = DatabaseInsertData.get_types(table)
		
		if data_types == null:
			print("Data type array is null. Not inserting table: " + table)
			continue
		
		data = DatabaseInsertData.get_data(table)
		
		if data == null or data.size() <= 0:
			continue
			
		table_query = DatabaseQueries.insert(table)
		
		for row in data:
			print(db.query(table_query, row, data_types.duplicate()))
	
func run_tests():
	# Insert player and char
	var character_class = preload("res://Classes/Player/PlayerCharacter.gd")
	
	var char1 = character_class.new()
	char1.set_name("TestCharacter")
	char1.set_race("Human")
	char1.set_class("CommonHuman")
	
	var char2 = character_class.new()
	char2.set_name("TestCharacter2")
	char2.set_race("Vampire")
	char2.set_class("Blood Seeker")
	
	print(insert_player("test", "test".hash(), "mail"))
	print(insert_player_character("test", char1))
	print(insert_player_character("test", char2))
	print(db.fetch_assoc(DatabaseQueries.select_player(), ["test"], [TEXT]))
	print(has_player("test"))
	print(has_email("mail"))
	
	# Insert map
	print(db.query(DatabaseQueries.insert_map(), ["TestMap"], [TEXT]))
	
	# Insert item
	var item = Global.Item.new()
	var item_options = {}
	item_options["Increased damage"] = 5

	item.set_name("Test helmet")
	item.set_type("Barbuta")
	item.set_rarity("Normal")
	item.set_options(item_options)
	
	print(insert_item(item))
	
	# Insert inventory item
	var item_query = "SELECT * FROM " + DatabaseQueries.item_table + ";"
	var db_item = db.fetch_assoc(item_query, [], [])[0]
	
	item.init_from_database(db_item)
	print(insert_inventory_item(char1, item))
	print(get_inventory(char1.get_name())[0])
	
	for character in build_character_list("test"):
		print(character)
		character = character.serialize()
		print(character)
		character = Global.PlayerCharacter.new().deserialize(character)
	
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
	return db.fetch_assoc(DatabaseQueries.select_player_character(), [character_name], [TEXT])
	
func build_character_list(player):
	var characters = get_characters(player)
	
	if characters.size() <= 0:
		return []
		
	for i in range(characters.size()):
		characters[i] = Global.PlayerCharacter.new().init_from_database(characters[i])
		
	return characters
	
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
	return db.query(DatabaseQueries.insert_item(), item.to_database_array(), DatabaseInsertData.get_types(DatabaseQueries.item_table))
	
#############
# Item Type #
#############

func get_item_type(item_type_id):
	return db.fetch_assoc(DatabaseQueries.select_item_type(), [item_type_id], [TEXT])
	
#############
# Inventory #
#############

func get_inventory(character):
	return db.fetch_assoc(DatabaseQueries.select_inventory(), [character], [TEXT])
	
func insert_inventory_item(character, item):
	var types = DatabaseInsertData.get_types(DatabaseQueries.inventory_table)
	var row = [character.get_name(), item.get_id(), item.get_inventory_x(), item.get_inventory_y()]
	
	return db.fetch_assoc(DatabaseQueries.insert_inventory_item(), row, types)